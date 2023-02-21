//
//  HealthProvider.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 09.06.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import Foundation
import HealthKit
import RxSwift

class HealthProvider {
    let healthStore = HKHealthStore()
    let allTypes = Set([HKObjectType.workoutType(),
                        HKObjectType.quantityType(forIdentifier: .stepCount)!,
                        HKObjectType.quantityType(forIdentifier: .distanceCycling)!,
                        HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
                        HKObjectType.quantityType(forIdentifier: .heartRate)!])
    
    typealias HKQueryUpdateHandler = ((HKAnchoredObjectQuery, [HKSample]?, [HKDeletedObject]?, HKQueryAnchor?, Error?) -> Swift.Void)
    
    private var activeQueries = [HKQuery]()
    
    
    func requestHealthKitAuthorization() {
        healthStore.requestAuthorization(toShare: allTypes, read: allTypes) { (success, error) in
            if !success {
                // Handle the error here.
            }
        }
    }
    
    func getTodayStepCount(completion: @escaping (Double) -> Void) {
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(0.0)
                return
            }
            completion(sum.doubleValue(for: HKUnit.count()))
        }
        
        healthStore.execute(query)
    }
    
    func getTodayStepCountObservable()-> Observable<Double> {
        return Observable.create { observer in
            let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
            let now = Date()
            let startOfDay = Calendar.current.startOfDay(for: now)
            
            let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
            
            let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
                guard let result = result, let sum = result.sumQuantity() else {
                    observer.onError(error ?? ExceptionType.unknown(message: "Unable to query HealthKit data"))
                    return
                }
                observer.onNext(sum.doubleValue(for: HKUnit.count()))
            }
            self.healthStore.execute(query)
            return Disposables.create()
        }
    }
    
    func getStepCountObservable(from dateStart: Date, to dateEnd: Date)-> Observable<Double> {
        return Observable<Double>.create { observer in
            let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
            let predicate = HKQuery.predicateForSamples(withStart: dateStart, end: dateEnd, options: .strictStartDate)
            let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
                guard let result = result, let sum = result.sumQuantity() else {
                    observer.onError(ExceptionType.unknown(message: "Unable to retrieve steps: \(error?.localizedDescription ?? "")"))
                    return
                }
                observer.onNext(sum.doubleValue(for: HKUnit.count()))
                observer.onCompleted()
            }
            self.healthStore.execute(query)
            return Disposables.create()
        }
    }
    
    func getStepCountSegmentedByDayObservable(from dateStart: Date, to dateEnd: Date)-> Observable<Array<(Date, Date, Double)>> {
        return Observable<Array<(Date, Date, Double)>>.create { observer in
            let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
            let predicate = HKQuery.predicateForSamples(withStart: dateStart, end: dateEnd, options: .strictStartDate)
            
            var dateComponents = DateComponents()
            dateComponents.day = 10
            let calendar = NSCalendar.current
            
            var anchorComponents = calendar.dateComponents([.day, .month, .year], from: Date())
            anchorComponents.hour = 0
            let anchorDate = calendar.date(from: anchorComponents)
            let query = HKStatisticsCollectionQuery(quantityType: stepsQuantityType,
                                                    quantitySamplePredicate: predicate,
                                                    options: .cumulativeSum,
                                                    anchorDate: anchorDate!,
                                                    intervalComponents: dateComponents)
            
            query.initialResultsHandler =  { query, result, error in
                guard let result = result else {
                    observer.onError(ExceptionType.unknown(message: "Unable to retrieve steps: \(error?.localizedDescription ?? "")"))
                    return
                }
               
                let stepCountByDays = result.statistics().map { statistics -> (Date, Date, Double) in
                    let atomicStepCount = statistics.sumQuantity()!.doubleValue(for: HKUnit.count())
                    return (dateStart, dateEnd, atomicStepCount)
                }
                print("stepCountByDays ========= \(stepCountByDays)")
                observer.onNext(stepCountByDays)
                observer.onCompleted()
            }
           
            self.healthStore.execute(query)
            return Disposables.create()
        }}
    
    func getSteps(from dateStart: Date, to dateEnd: Date, completion:  @escaping (Double, Date?, Date?)-> Void) {
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let predicate = HKQuery.predicateForSamples(withStart: dateStart, end: dateEnd, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(0.0, nil, nil)
                return
            }
            completion(sum.doubleValue(for: HKUnit.count()), dateStart, dateEnd)
        }
        healthStore.execute(query)
    }
    
    func startLiveStepsTracking() {
        // Configure steps quantity type.
        guard let quantityType = HKObjectType.quantityType(forIdentifier: .stepCount) else { return }
        
        // Create query to receive continiuous heart rate samples.
        let datePredicate = HKQuery.predicateForSamples(withStart: Date(), end: nil, options: .strictStartDate)
        let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
        let queryPredicate = NSCompoundPredicate(andPredicateWithSubpredicates:[datePredicate, devicePredicate])
        let updateHandler: HKQueryUpdateHandler = { [weak self] query, samples, deletedObjects, queryAnchor, error in
            if let quantitySamples = samples as? [HKQuantitySample] {
                print(quantitySamples)
                //                self?.process(samples: quantitySamples)
            }
        }
        let query = HKAnchoredObjectQuery(type: quantityType,
                                          predicate: queryPredicate,
                                          anchor: nil,
                                          limit: HKObjectQueryNoLimit,
                                          resultsHandler: updateHandler)
        query.updateHandler = updateHandler
        
        // Execute the heart rate query.
        healthStore.execute(query)
        
        // Remember all active Queries to stop them later.
        activeQueries.append(query)
    }
    func getMostRecentSample(for sampleType: HKSampleType,
                                   completion: @escaping (HKQuantitySample?, Error?) -> Void) {
        let limit = 1
        let sampleQuery = HKSampleQuery(sampleType: sampleType, predicate: nil, limit: limit, sortDescriptors: nil) { (query, samples, error) in
        DispatchQueue.main.async {
          guard let samples = samples,
                let mostRecentSample = samples.first as? HKQuantitySample else {
                completion(nil, error)
                return
          }
          completion(mostRecentSample, nil)
        }
      }
       healthStore.execute(sampleQuery)
    }
}
