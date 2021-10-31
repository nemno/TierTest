//
//  LocationProvider.swift
//  TierTest
//

import UIKit
import CoreLocation

protocol LocationProvider {
    func getCurrentLocation(completion: @escaping ((CLLocation?, Error?) -> Void))
}

final class DefaultLocationProvider: NSObject, LocationProvider, CLLocationManagerDelegate {
    private (set) var currentLocation: CLLocation?
    private var locationUpdateCompletions: [((CLLocation?, Error?) -> Void)] = []
    let locationManager: CLLocationManager
    
    override init() {
        self.locationManager = CLLocationManager()
        super.init()
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        self.locationManager.distanceFilter = 50
        self.locationManager.pausesLocationUpdatesAutomatically = false
        self.locationManager.delegate = self
    }
    
    private func requestAuthorization() {
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func getCurrentLocation(completion: @escaping ((CLLocation?, Error?) -> Void)) {
        let authorized = self.locationManager.authorizationStatus == .authorizedAlways || self.locationManager.authorizationStatus == .authorizedWhenInUse
        if CLLocationManager.locationServicesEnabled() && authorized {
                    if let location = self.currentLocation {
                        completion(location, nil)
                    } else {
                        self.locationUpdateCompletions.append(completion)
                    }
        } else {
            self.locationUpdateCompletions.append(completion)
            requestAuthorization()
        }
    }
    
    private func start() {
        self.locationManager.startUpdatingLocation()
        self.locationManager.startMonitoringSignificantLocationChanges()
    }
    
    // MARK: - CLLocationManagerDelegate methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.currentLocation = location
            
            for completion in self.locationUpdateCompletions {
                completion(location, nil)
            }
            
            self.locationUpdateCompletions.removeAll()
        }
    }
        
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        for completion in self.locationUpdateCompletions {
            completion(nil, error)
        }
        self.locationUpdateCompletions.removeAll()
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.start()
    }
}
