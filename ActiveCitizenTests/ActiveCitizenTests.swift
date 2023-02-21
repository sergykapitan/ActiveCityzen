//
//  ActiveCitizenTests.swift
//  ActiveCitizenTests
//
//  Created by Vladimir Vetrov on 03/07/2019.
//  Copyright © 2019 Novotorica. All rights reserved.
//
import XCTest
import HealthKit
import Alamofire
import CoreLocation
import RxSwift
//@testable import Активный_Житель


class ActiveCitizenTests: XCTestCase {
    
   // var test: RedesingWorkoutTypeViewController!
    
    override func setUp() {
     //   test = RedesingWorkoutTypeViewController()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
      //  test = nil
    }
    
    func testIt() {
        let double = 0.123456789
        print(double.rounded(toPlaces: 3) )
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.setLocalizedDateFormatFromTemplate("MMMMd")
        print(formatter.string(from: Date()))
        
        let currentHour: Int = Calendar.current.component(.hour, from: Date().addingTimeInterval(60*60*8))
        print(currentHour)
        
        var greeting = ""
        switch(currentHour) {
               case 4..<12: greeting = "Доброе утро!"
               case 12..<17: greeting = "Добрый день!"
               case 17...23: greeting = "Добрый вечер!"
               default:
                   greeting = "Доброй ночи!"
               }
        print(greeting)
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        getTodaysSteps(completion: { steps in
            print(steps)
        })
        
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testA() {
        let date = "2017-09-04T04:14:37Z"
        
        let dateStart = ISO8601DateFormatter().date(from: date)
        print(dateStart)
        
        if let myDate = ISO8601DateFormatter().date(from: date){
            print(myDate) //2019-12-08 02:22:26 +0000
        }
    }
    
    func testQueryParameters() {
        let url = "?test1=blah&test2=blahblah"
        let test1 = getQueryStringParameter(url: url, param: "test1")
        print(test1)
    }
    
    func getQueryStringParameter(url: String, param: String) -> String? {
        guard let url = URLComponents(string: url) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }
    
    
    let healthStore = HKHealthStore()
    
    func computeDistanceBetween(location1: CLLocation, location2: CLLocation)-> Double {
        let loc1lat = location1.coordinate.latitude
        let loc1lon = location1.coordinate.longitude
        let loc2lat = location2.coordinate.latitude
        let loc2lon = location2.coordinate.longitude
        
        let radFromLat = (loc1lat * Double.pi) / 180
        let radFromLng = (loc1lon * Double.pi) / 180
        let radToLat = (loc2lat * Double.pi) / 180
        let radToLng = (loc2lon * Double.pi) / 180
        let distance =
            6371000 *
                2 *
                asin(
                    sqrt(
                        pow(sin((radFromLat - radToLat) / 2), 2) +
                            cos(radFromLat) *
                            cos(radToLat) *
                            pow(sin((radFromLng - radToLng) / 2), 2)
                    )
        )
        return distance
    }
    
    func getTodaysSteps(completion: @escaping (Double) -> Void) {
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
    
    func testGetStepsHuh() {
        let dateStart = Calendar.current.date(bySettingHour: 15, minute: 40, second: 0, of: Date())!
        getSteps(from: dateStart, to: Date(), completion: { foo, bar, qwe in
            print(foo)
            print("ggez")
        })
    }
    
    func testRounding() {
        
    }
    func testTimer() {
     //   test.updateTimer(timeElapsed: 3745)
     //   print( "TIMER ===== \(test.redesingWorkoutView.bottomView.workoutBottomTimerLabel.text)")
    }
    func testCenterPolygon() {
       // let placeController = PlaceViewController()
    }
    
}
extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
