//
//  GeoExtensions.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 16.06.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

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

func openPlaceInExternalMapsApp(placeName: String, latitude: Double, longitude: Double) {
    let regionDistance: CLLocationDistance = 5000
    let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
    let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
    
    let options = [
        MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
        MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
    ]
    let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
    let mapItem = MKMapItem(placemark: placemark)
    mapItem.name =  placeName
    mapItem.openInMaps(launchOptions: options)
}

/// Calculates total distance based on the order of locations
func calculatePathDistance(locations: [Location])-> Double {
    if 0...1 ~= locations.count { return 0.0 }
    let coreLocationsList = locations.map { (location) -> CLLocation in
        return CLLocation(latitude: location.latitude, longitude: location.longitude)
    }
    var distance = 0.0
    for loc in 0..<coreLocationsList.count - 1 {
        distance += coreLocationsList[loc].distance(from: coreLocationsList[loc + 1])
    }
    return distance
}

extension Location {
    func computeDistanceTo(location2: Location)-> Double {
        let clLocation1 = CLLocation.init(latitude: self.latitude, longitude: self.longitude)
        let clLocation2 = CLLocation.init(latitude: location2.latitude, longitude: location2.longitude)
        return clLocation1.distance(from: clLocation2)
    }
}
