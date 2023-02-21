//
//  CitizenAPI.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 04.12.2019.
//  Copyright © 2019 Novotorica. All rights reserved.
//


import Alamofire
import RxSwift

class CitizenAPI {
    
    public func getPlaces()-> Observable<ListResponse<Place>> {
        return Observable<ListResponse<Place>>.create { observer in
            
            AF.request(Constants.apiEndpoint + "/places")
                .validate()
                .responseData { (response) in
                    response.mapDataToObserver(observer: observer)
                    
                }
            return Disposables.create()
        }
    }
    
    public func getPlaceById(id: Int)-> Observable<Place> {
        return Observable<Place>.create { observer in
            print(Constants.apiEndpoint + "/places/\(id)")
            AF.request(Constants.apiEndpoint + "/places/\(id)")
                .validate()
                .responseData { response in
                    response.mapDataToObserver(observer: observer)
                }
            return Disposables.create() }
    }
    
    public func registerUserWithApple(authRequest: AuthorizationRequest)-> Observable<Token> {
        return Observable.create { observer in
            AF.request(Constants.apiEndpoint + "/appleSignup", method: .post, parameters: authRequest.asDictionary(), encoding: JSONEncoding.default)
                .validate()
                .responseData { response in
                    response.mapDataToObserver(observer: observer)
                }
            return Disposables.create()
        }
    }
    
    public func getUserBalance()-> Observable<Balance> {
        return Observable.create({ observer in
            AF.request(Constants.apiEndpoint + "/balance", method: .get, interceptor: Interceptor(interceptors: [AuthInterceptor(), AppVersionInterceptor()]))
                .validate()
                .responseData {  response in
                    debugPrint(response)

                response.mapDataToObserver(observer: observer)
            }
            return Disposables.create()
        })
    }
    
    public func sendSmsToPhoneNumber(phoneNumber: PhoneNumber)-> Observable<PhoneNumberConfirmationSmsStatus>{
        return Observable.create({  observer in
            AF.request(Constants.apiEndpoint + "/smsSignUp", method: .post, parameters: phoneNumber.asDictionary(), encoding: JSONEncoding.default).validate().responseData {   response in
                response.mapDataToObserver(observer: observer)
            }
            
            return Disposables.create()
        })
    }
    
    public func confirmPhoneNumberViaSms(smsCode: SmsCode)-> Observable<Token>{
        return Observable.create({  observer in
            AF.request(Constants.apiEndpoint + "/loginByCode", method: .post, parameters: smsCode.asDictionary(), encoding: JSONEncoding.default).validate().responseData {   response in
                response.mapDataToObserver(observer: observer)
            }
            return Disposables.create()
        })
    }
    
    public func getUserProfile()-> Observable<UserProfile> {
        return Observable.create { observer in
            AF.request(Constants.apiEndpoint + "/profile", method: .get, encoding: URLEncoding.default, interceptor: Interceptor(interceptors: [AuthInterceptor(), AppVersionInterceptor()]))
                .validate()
                .responseData { response in
                    response.mapDataToObserver(observer: observer)
                }
            return Disposables.create()
        }
    }
    
    public func getStats(from date: String)-> Observable<UserStats> {
        return Observable.create { observer in
            
            AF.request(Constants.apiEndpoint + "/activities/statistic", method: .get, parameters: ["startDate" : date],encoding: URLEncoding.queryString, interceptor: Interceptor(interceptors: [AuthInterceptor(), AppVersionInterceptor()]))
                .validate()
                .responseData { response in
                    response.mapDataToObserver(observer: observer)
                }
            return Disposables.create()
        }
    }
    
    public func updateProfile(profile: Profile)-> Observable<Void> {
        return Observable.create { observer in
            AF.request(Constants.apiEndpoint + "/profile", method: .put, parameters: profile.asDictionary(), encoding: JSONEncoding.default, interceptor: Interceptor(interceptors: [AuthInterceptor(), AppVersionInterceptor()])).responseData {    responseData in
                switch responseData.result {
                case .success(let data):
                    observer.onNext(())
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    public func uploadActionsIntersections(activitiesIntersections: ActivitiesIntersections)-> Completable {
        return Completable.create { completable in
            AF.request(Constants.apiEndpoint + "/activities/intersections", method: .post, parameters: activitiesIntersections.asDictionary(), encoding: JSONEncoding.default, interceptor: Interceptor(interceptors: [AuthInterceptor(), AppVersionInterceptor()]))
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success(let _):
                        completable(.completed)
                    case .failure(let error):
                        completable(.error(error))
                    }
                }
            return Disposables.create()
        }
    }
    
    public func getInvoices(startTime: Date, endTime: Date)-> Observable<ListResponse<Invoice>> {
        return Observable.create { observer in
            AF.request(Constants.apiEndpoint + "/invoices?startDate=\(startTime.iso8601)&endDate=\(endTime.iso8601)", method: .get, interceptor: Interceptor(interceptors: [AuthInterceptor(), AppVersionInterceptor()])).responseData { response in
                response.mapDataToObserver(observer: observer)
            }
            return Disposables.create()
        }
    }
    
    public func getProducts()-> Observable<ListResponse<Product>> {
        return Observable<ListResponse<Product>>.create { observer in
            AF.request(Constants.apiEndpoint + "/products")
                .validate()
                .responseData { (response) in
                    response.mapDataToObserver(observer: observer)
                }
            return Disposables.create()
        }
    }
    
    public func getProductById(id: Int)-> Observable<Product> {
        return Observable.create { observer in
            AF.request(Constants.apiEndpoint + "/products/\(id)").validate().responseData { responseData in
                responseData.mapDataToObserver(observer: observer)
            }
            return Disposables.create()
        }
    }
    
    public func checkProductIsAvailableForPurchase(id: Int) -> Observable<ListResponse<ProductAvailability>> {
        let headers = HTTPHeaders.init(["Content-Type" : "application/json"])
        return Observable.create {  observer in
            AF.request(Constants.apiEndpoint + "/products/\(id)/check", method: .get, encoding: JSONEncoding.default, headers: headers, interceptor: Interceptor(interceptors: [AuthInterceptor(), AppVersionInterceptor()])).validate().responseData {   responseData in
                responseData.mapDataToObserver(observer: observer)
            }
            return Disposables.create()
        }
    }
    
    public func purchaseProductInfo(productPurchaseRequest: ProductPurchaseRequest)-> Observable<ProductPurchaseStatus> {
        let headers = HTTPHeaders.init(["Content-Type" : "application/json"])
        return Observable.create {  observer in
            AF.request(Constants.apiEndpoint + "/purchases", method: .post, parameters: productPurchaseRequest.asDictionary(), encoding: JSONEncoding.default, headers: headers, interceptor: Interceptor(interceptors: [AuthInterceptor(), AppVersionInterceptor()])).validate().responseData {  responseData in
                responseData.mapDataToObserver(observer: observer)
            }
            return Disposables.create()
        }
    }
    
    public func getPurchaseByOrderId(orderId: String)-> Observable<ProductPurchaseStatus> {
        let headers = HTTPHeaders.init(["Content-Type" : "application/json"])
        return Observable.create {  observer in
            AF.request(Constants.apiEndpoint + "/purchases/orders/\(orderId)", method: .get, encoding: JSONEncoding.default, headers: headers, interceptor: Interceptor(interceptors: [AuthInterceptor(), AppVersionInterceptor()])).validate().responseData { responseData in
                responseData.mapDataToObserver(observer: observer)
            }
            return Disposables.create()
        }
    }
    
    public func getPurchaseByTimestamp(timestamp: Int)-> Observable<Purchase> {
        let headers = HTTPHeaders.init(["Content-Type" : "application/json"])
        return Observable.create {  observer in
            AF.request(Constants.apiEndpoint + "/purchases/\(timestamp)", method: .get, encoding: JSONEncoding.default, headers: headers, interceptor: Interceptor(interceptors: [AuthInterceptor(), AppVersionInterceptor()])).validate().responseData { responseData in
                responseData.mapDataToObserver(observer: observer)
            }
            return Disposables.create()
        }
    }
    
    public func getEvents()-> Observable<ListResponse<Event>> {
        return Observable.create {  observer in
            AF.request(Constants.apiEndpoint + "/events", method: .get, encoding: JSONEncoding.default).validate().responseData { responseData in
                responseData.mapDataToObserver(observer: observer)
            }
            return Disposables.create()
        }
    }
    
    public func getEventById(id: Int)-> Observable<Event> {
        return Observable.create {  observer in
            AF.request(Constants.apiEndpoint + "/events/\(id)", method: .get, encoding: JSONEncoding.default).validate().responseData { responseData in
                responseData.mapDataToObserver(observer: observer)
            }
            return Disposables.create()
        }
    }
    
    public func getQuests()-> Observable<ListResponse<Quest>> {
        return Observable.create {  observer in
            AF.request(Constants.apiEndpoint + "/quests", method: .get, encoding: JSONEncoding.default).validate().responseData { responseData in
                responseData.mapDataToObserver(observer: observer)
            }
            return Disposables.create()
        }
    }
    
    public func getQuests(latitude: Double, longitude: Double)-> Observable<ListResponse<Quest>> {
        return Observable.create {  observer in
            AF.request(Constants.apiEndpoint + "/quests?latitude=\(latitude)&longitude=\(longitude)", method: .get, encoding: JSONEncoding.default).validate().responseData { responseData in
                responseData.mapDataToObserver(observer: observer)
            }
            return Disposables.create()
        }
    }
    
    public func getQuestById(id: Int)-> Observable<Quest> {
        return Observable.create {  observer in
            AF.request(Constants.apiEndpoint + "/quests/\(id)", method: .get, encoding: JSONEncoding.default).validate().responseData { responseData in
                responseData.mapDataToObserver(observer: observer)
            }
            return Disposables.create()
        }
    }
    
    public func getQuestById(id: Int, latitude: Double, longitude: Double)-> Observable<Quest> {
        return Observable.create {  observer in
            AF.request(Constants.apiEndpoint + "/quests/\(id)?latitude=\(latitude)&longitude=\(longitude)", method: .get, encoding: JSONEncoding.default).validate().responseData { responseData in
                responseData.mapDataToObserver(observer: observer)
            }
            return Disposables.create()
        }
    }
    
    public func uploadQrCode(qrCodeRequest: QrCodeUploadRequest)-> Observable<QrCodeStatusResponse> {
        let headers = HTTPHeaders.init(["Content-Type" : "application/json"])
        
        return Observable.create { observer in
            AF.request(Constants.apiEndpoint + "/qrs", method: .post, parameters: qrCodeRequest.asDictionary(), encoding: JSONEncoding.default, headers: headers, interceptor: Interceptor(interceptors: [AuthInterceptor(), AppVersionInterceptor()]))
                .responseDecodable(of: QrCodeStatusResponse.self, errorCode: -2) { res in
                    switch(res) {
                    case .success(let response): do {
                        observer.onNext(response)
                    }
                    case .failure(let error): do {
                        observer.onError(error)
                    }
                    }
                }
            return Disposables.create()
        }
    }
    //MARK: - uploadWorkout
    public func uploadWorkout(workout: Workout)-> Observable<Void> {
        let headers = HTTPHeaders.init(["Content-Type" : "application/json"])
        return Observable.create { observer in
            let str = workout.asDictionary()
            print("workout = \(String(describing: str))")
            AF.request(Constants.apiEndpoint + "/activities/workouts", method: .post, parameters: workout.asDictionary(), encoding: JSONEncoding.default, headers: headers, interceptor: Interceptor(interceptors: [AuthInterceptor(), AppVersionInterceptor()])).responseData { responseJSON in
                switch responseJSON.result {
                case .success(_):
                    observer.onNext(())
                case .failure(let error):
                    observer.onError(error)
                }
                responseJSON.debugPrintHttpRequestResponse()
                
            }
            return Disposables.create()
        }
    }
    
    public func getDobroOffers()-> Observable<ListResponse<DobroOffer>> {
        return Observable.create {  observer in
            AF.request(Constants.apiEndpoint + "/dobro/offers", method: .get, encoding: JSONEncoding.default).validate().responseData { responseData in
                responseData.mapDataToObserver(observer: observer)
            }
            return Disposables.create()
        }
    }
    
    public func getDobroOffersByCategory(category: String)-> Observable<ListResponse<DobroOffer>> {
        return Observable.create {  observer in
            AF.request(Constants.apiEndpoint + "/dobro/offers?category=\(category)", method: .get, encoding: JSONEncoding.default).validate().responseData { responseData in
                responseData.mapDataToObserver(observer: observer)
            }
            return Disposables.create()
        }
    }
    
    public func getDobroOfferById(id: Int)-> Observable<DobroOffer> {
        return Observable.create {  observer in
            AF.request(Constants.apiEndpoint + "/dobro/offers/\(id)", method: .get, encoding: JSONEncoding.default).validate().responseData { responseData in
                responseData.mapDataToObserver(observer: observer)
                observer.onCompleted()
            }
            return Disposables.create()
        }.take(1)
    }
    
    public func purchaseDobroOfferById(id: Int)-> Observable<DobroOrder> {
        let headers = HTTPHeaders.init(["Content-Type" : "application/json"])
        
        return Observable.create {  observer in
            AF.request(Constants.apiEndpoint + "/dobro/offers/\(id)", method: .post, encoding: JSONEncoding.default, headers: headers, interceptor: Interceptor(interceptors: [AuthInterceptor(), AppVersionInterceptor()])).validate().responseData { responseData in
                responseData.mapDataToObserver(observer: observer)
                observer.onCompleted()
            }
            return Disposables.create()
        }.take(1)
    }
    
    public func orderRedeemCode(id: Int, parameters: [String: Any]) -> Observable<DobroOrder> {
        let headers = HTTPHeaders.init(["Content-Type" : "application/json"])
        return Observable.create {  observer in
            AF.request(Constants.apiEndpoint + "/dobro/orders/\(id)/redeemCode", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: Interceptor(interceptors: [AuthInterceptor(), AppVersionInterceptor()])).validate().responseData { responseData in
                responseData.mapDataToObserver(observer: observer)
            }
            return Disposables.create()
        }
    }
    
    public func getDobroOrders() -> Observable<ListResponse<DobroOrder>> {
        let headers = HTTPHeaders.init(["Content-Type" : "application/json"])
        return Observable.create {  observer in
            AF.request(Constants.apiEndpoint + "/dobro/orders/", method: .get, encoding: JSONEncoding.default, headers: headers, interceptor: Interceptor(interceptors: [AuthInterceptor(), AppVersionInterceptor()])).validate().responseData { responseData in
                responseData.mapDataToObserver(observer: observer)
            }
            return Disposables.create()
        }
    }
    
    public func getDobroOrderById(orderId: Int) -> Observable<DobroOrder> {
        let headers = HTTPHeaders.init(["Content-Type" : "application/json"])
        return Observable.create {  observer in
            AF.request(Constants.apiEndpoint + "/dobro/orders/\(orderId)", method: .get, encoding: JSONEncoding.default, headers: headers, interceptor: Interceptor(interceptors: [AuthInterceptor(), AppVersionInterceptor()])).validate().responseData { responseData in
                responseData.mapDataToObserver(observer: observer)
            }
            return Disposables.create()
        }
    }
    
    public func getDobroOfferCategories()-> Observable<ListResponse<DobroOfferCategory>> {
        return Observable.create {  observer in
            AF.request(Constants.apiEndpoint + "/dobro/offers/categories", method: .get, encoding: JSONEncoding.default, interceptor: Interceptor(interceptors: [AuthInterceptor(), AppVersionInterceptor()])).validate().responseData { responseData in
                responseData.mapDataToObserver(observer: observer)
            }
            return Disposables.create()
        }
    }
    public func getKeyForAppMetrica() -> Observable<AppMetricaKey> {        
        return Observable.create { observer  in
            AF.request(Constants.appMetricaKey + "/keyValue/0/boolean", method: .get, encoding: JSONEncoding.default, interceptor: Interceptor( interceptors: [AuthInterceptor(),AppVersionInterceptor()])).validate().responseData { responseData in
                guard let str = responseData.data else { return }
                let ff = String(decoding: str, as: UTF8.self)
                print(ff)
                responseData.mapDataToObserver(observer: observer)
                
            }
            return Disposables.create()
        }
        
    }
    
    //MARK: - Get Workout Type
    public func getWorkoutType() -> Observable<WorkoutType> {
        return Observable.create { observer in
            AF.request(Constants.apiEndpoint + "/workoutTypes", method: .get, encoding:JSONEncoding.default).validate().responseData { responseData in
                responseData.mapDataToObserver(observer: observer)
                
             }
            return Disposables.create()
        }
    }
    
    
    
    
    
    
    
}
