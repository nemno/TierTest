//
//  MapViewController.swift
//  TierTest
//

import UIKit
import MapKit

final class MapViewController: UIViewController, MKMapViewDelegate {
    private var mapView: MKMapView = MKMapView(frame: .zero)
    
    private let viewDidAppear: (() -> Void)
    private var viewModels: [ScooterViewModel] = []
    
    init(viewDidAppear: @escaping (() -> Void)) {
        self.viewDidAppear = viewDidAppear
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        setupMapView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewDidAppear()
    }
    
    func setScooters(_ scooters: [ScooterViewModel]) {
        self.viewModels = scooters
        let annotations = viewModels.map { scooter -> MKAnnotation in
            return scooter.annotation
        }
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.mapView.addAnnotations(annotations)
    }
    
    // MARK: - UI Helper methods
    
    private func setupMapView() {
        mapView.showsUserLocation = true
        mapView.delegate = self
        self.view.addSubview(mapView)
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(0.0)
            make.bottom.equalTo(0.0)
            make.leading.equalTo(0.0)
            make.trailing.equalTo(0.0)
        }
        
        mapView.register(ScooterClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }
    
    // MARK: - MKMapViewDelegate methods
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? ScooterAnnotation else { return nil }
        return ScooterAnnotationView(annotation: annotation, reuseIdentifier: "scooterAnnotation")
    }
}
