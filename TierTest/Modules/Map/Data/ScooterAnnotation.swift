//
//  ScooterAnnotation.swift
//  TierTest
//

import MapKit

final class ScooterAnnotation: NSObject, MKAnnotation {
    private var latitude: CLLocationDegrees = 0
    private var longitude: CLLocationDegrees = 0
    
    @objc dynamic var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        set {
            latitude = newValue.latitude
            longitude = newValue.longitude
        }
    }
}
