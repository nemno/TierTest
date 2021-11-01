//
//  ScooterAnnotationView.swift
//  TierTest
//

import MapKit

final class ScooterAnnotationView: MKMarkerAnnotationView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = "scooter"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultHigh
        markerTintColor = UIColor.DefaultTheme.mainColor
        glyphImage = #imageLiteral(resourceName: "scooterAnnotationIcon")
    }
}
