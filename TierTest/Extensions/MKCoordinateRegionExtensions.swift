//
//  MKCoordinateRegionExtensions.swift
//  TierTest
//

import MapKit

extension MKCoordinateRegion {
    var mapRect:MKMapRect {
        get{
            let a = MKMapPoint(CLLocationCoordinate2DMake(
                   self.center.latitude + self.span.latitudeDelta / 2,
                   self.center.longitude - self.span.longitudeDelta / 2))

            let b = MKMapPoint(CLLocationCoordinate2DMake(
                    self.center.latitude - self.span.latitudeDelta / 2,
                    self.center.longitude + self.span.longitudeDelta / 2))

            return MKMapRect(x: min(a.x,b.x), y: min(a.y,b.y), width: abs(a.x-b.x), height: abs(a.y-b.y))
        }
    }
}
