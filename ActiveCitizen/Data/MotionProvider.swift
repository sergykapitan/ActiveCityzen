//
//  MotionService.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 14.10.2019.
//  Copyright © 2019 Novotorica. All rights reserved.
//

import Foundation
import CoreMotion
import RxSwift

class MotionProvider {
    private let pedometerInstance = CMPedometer.init()
    private let motionActivityManagerInstance = CMMotionActivityManager.init()
    private let pedometerSubject: PublishSubject = PublishSubject<CMPedometerData>()
    private let motionActivitySubject: PublishSubject<CMMotionActivity> = PublishSubject()
    
    func startPedometer() {
        if CMPedometer.authorizationStatus() != .authorized {
            print("CMPedometer usage not authorized")
            pedometerSubject.onError(ExceptionType.security(message: "CMPedometer usage not authorized"))
        }
        
        pedometerInstance.stopUpdates()
        pedometerInstance.startUpdates(from: Date(), withHandler: {(data, error) in
            guard let data = data, error == nil else {
                self.pedometerSubject.onError(error!)
                return }
            self.pedometerSubject.onNext(data)
        })
        
    }
    
    func getPedometer()-> Observable<CMPedometerData> {
        startPedometer()
        return pedometerSubject.do(afterNext: { _ in
            self.startPedometer()
        })
    }
    
    func getUserActionTracker()-> Observable<CMMotionActivity> {
        return motionActivitySubject
    }
    
    func stopPedometer() {
        pedometerInstance.stopUpdates()
        pedometerSubject.onCompleted()
    }
    
    private func getMotionActivityManager() {
        if CMMotionActivityManager.authorizationStatus() != .authorized {
            print("CMMotionActivityManager usage not authorized")
        } else {
            motionActivityManagerInstance.startActivityUpdates(to: .init(), withHandler: { motionActivity in
                guard let motionActivity = motionActivity else { return }
                self.motionActivitySubject.onNext(motionActivity)
            })
        }
    }
    
    deinit {
        stopPedometer()
    }
}
