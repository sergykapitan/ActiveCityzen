//
//  ResizableMapViewController.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 26.10.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import UIKit
import YandexMapKit

class ResizableMapViewController: BaseViewController {

    @IBOutlet weak var mapView: YMKMapView!
    
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    @IBOutlet weak var imageButtonPlus: UIImageView!
    @IBOutlet weak var imageButtonMinus: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let map = mapView.mapWindow.map
        mapView.isUserInteractionEnabled = false
        let placeLocationPoint = YMKPoint(latitude: latitude, longitude: longitude)
        map.mapObjects.addPlacemark(with: placeLocationPoint, image: R.image.iconLocationLightBlue()!)
        
        LocationProvider.instance.getCurrentLocationSingle().subscribe { location in
            let userLocationPoint = YMKPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            map.mapObjects.addPlacemark(with: userLocationPoint, image: R.image.iconUserCurrentLocation()!)
        } onError: { error in
            print(error)
        }.disposed(by: disposeBag)


        map.move(
              with: YMKCameraPosition.init(target: placeLocationPoint, zoom: 15, azimuth: 0, tilt: 0),
              animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 3),
              cameraCallback: nil)
        
        let buttonPlusGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(zoomMapIn))
        let buttonMinusGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(zoomMapOut))
        buttonPlusGestureRecognizer.numberOfTapsRequired = 1
        buttonMinusGestureRecognizer.numberOfTapsRequired = 1
        imageButtonPlus.addGestureRecognizer(buttonPlusGestureRecognizer)
        imageButtonMinus.addGestureRecognizer(buttonMinusGestureRecognizer)
    }
    
    @objc func zoomMapIn() {
     print("btn  +  tapped")
        let map = mapView.mapWindow.map
        
        mapView.mapWindow.map.move(
            with: YMKCameraPosition.init(target: YMKPoint(latitude: latitude, longitude: longitude), zoom: map.cameraPosition.zoom + 1, azimuth: 0, tilt: 0),
              animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 1),
              cameraCallback: nil)
    }
  
    @objc func zoomMapOut() {
        let map = mapView.mapWindow.map
        mapView.mapWindow.map.move(
            with: YMKCameraPosition.init(target: YMKPoint(latitude: latitude, longitude: longitude), zoom: map.cameraPosition.zoom - 1, azimuth: 0, tilt: 0),
              animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 1),
              cameraCallback: nil)
    }
}
