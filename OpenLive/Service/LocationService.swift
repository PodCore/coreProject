//
//  LocationService.swift
//  OpenLive
//
//  Created by Sky Xu on 3/13/18.
//  Copyright © 2018 Agora. All rights reserved.
//

import Foundation
import MapKit

typealias JSONDictionary = [String: Any]

class LocationService: NSObject {
    
    override init() {
        super.init()
    }
    static let shared = LocationService()
    let manager = CLLocationManager()
    public private(set) var currentLocation: CLLocation!
    let authStatus = CLLocationManager.authorizationStatus()
    let inUse = CLAuthorizationStatus.authorizedWhenInUse
    let always = CLAuthorizationStatus.authorizedAlways
    
   private func getAddress(completion: @escaping(_ address: CLLocation?, _ success: Bool) -> Void) {
        self.manager.requestWhenInUseAuthorization()
        if self.authStatus == inUse || self.authStatus == always {
            self.currentLocation = manager.location
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(self.currentLocation, completionHandler: { (placeMark, err) in
                if let e = err {
                    completion(nil, false)
                } else {
                    let placeArr = placeMark
//                    get the lat and long of the location
                    guard let address = placeArr?[0].location else { return }
                    completion(address, true)
                }
            })
        }
    }
    
    public func convertToRegion(completion: @escaping(_ location: Location, _ success: Bool) -> Void) {
        var cleanedLocation: Location!
        getAddress { (location, success) in
            if success {
                let lat = Int((location?.coordinate.latitude)!)
                let long = Int((location?.coordinate.longitude)!)
                cleanedLocation = Location(dict: ["lat": lat, "long": long])
                completion(cleanedLocation, true)
            }
        }
    }

}
