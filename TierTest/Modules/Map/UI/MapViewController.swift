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
    private var annotationToSelect: ScooterAnnotation?
    private var presentedScooterDetailView: ScooterDetailView?

    init(viewDidAppear: @escaping (() -> Void)) {
        self.viewDidAppear = viewDidAppear
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("mapScreenTitle", comment: "mapScreenTitle")
        self.view.backgroundColor = .white
        setupMapView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewDidAppear()
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
    
    private func animateMapviewToSelectedScooter(scooter: ScooterViewModel) {
        animateMapviewToCoordinate(coordinate: scooter.annotation.coordinate)
    }
    
    private func animateMapviewToCoordinate(coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: Constants.mapViewSpanLatitude, longitudeDelta: Constants.mapViewSpanLongitude))
        mapView.setVisibleMapRect(region.mapRect, edgePadding: UIEdgeInsets(top: self.view.safeAreaInsets.top, left: 0.0, bottom: Constants.detailViewHeight, right: 0.0), animated: true)
    }
    
    private func showScooterDetailView(scooter: ScooterViewModel) {
        if let presentedDetailView = self.presentedScooterDetailView {
            presentedDetailView.setup(with: scooter)
            return
        }
        
        let detailView = ScooterDetailView(frame: .zero)
        detailView.setup(with: scooter)
        self.view.addSubview(detailView)
        detailView.snp.makeConstraints { make in
            make.leading.equalTo(0.0)
            make.bottom.equalTo(Constants.detailViewHeight)
            make.trailing.equalTo(0.0)
            make.height.equalTo(Constants.detailViewHeight)
        }
        self.view.layoutIfNeeded()

        UIView.animate(withDuration: Constants.detailViewAnimationDuration) {
            detailView.snp.updateConstraints { make in
                make.bottom.equalTo(0.0)
            }
            self.view.layoutIfNeeded()
        }
        
        self.presentedScooterDetailView = detailView
    }
    
    private func hideScooterDetailView() {
        guard let detailView = self.presentedScooterDetailView else { return }
        if !mapView.selectedAnnotations.isEmpty { return }
        
        UIView.animate(withDuration: Constants.detailViewAnimationDuration) {
            detailView.snp.updateConstraints { make in
                make.bottom.equalTo(Constants.detailViewHeight)
            }
            self.view.layoutIfNeeded()
        } completion: { [weak self] finished in
            self?.presentedScooterDetailView = nil
        }
    }
    
    private func searchSelectedViewModel(for annotation: MKAnnotation) -> ScooterViewModel? {
        guard let scooterAnnotation = annotation as? ScooterAnnotation else { return nil }
        let selectedViewmodel = viewModels.filter { viewModel -> Bool in
            return viewModel.annotation == scooterAnnotation
        }.first
        
        return selectedViewmodel
    }
    
    // MARK: - MKMapViewDelegate methods
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? ScooterAnnotation else { return nil }
        return ScooterAnnotationView(annotation: annotation, reuseIdentifier: "scooterAnnotation")
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        guard let selectedAnnotation = self.annotationToSelect else { return }
        let visibleAnnotations = mapView.annotations(in: mapView.visibleMapRect)
        
        if visibleAnnotations.contains(selectedAnnotation) {
            mapView.selectAnnotation(selectedAnnotation, animated: true)
            self.annotationToSelect = nil
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }
        guard let selectedViewModel = self.searchSelectedViewModel(for: annotation) else { return }
        showScooterDetailView(scooter: selectedViewModel)
        animateMapviewToCoordinate(coordinate: annotation.coordinate)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        // TODO: fix this workaround
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [weak self] in
            self?.hideScooterDetailView()
        }
    }
            
    // MARK: - Public methods
    
    func setScooters(_ scooters: [ScooterViewModel]) {
        self.viewModels = scooters
        let annotations = viewModels.map { scooter -> MKAnnotation in
            return scooter.annotation
        }
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.mapView.addAnnotations(annotations)
    }
    
    func setNearestScooter(scooter: ScooterViewModel) {
        annotationToSelect = scooter.annotation
        animateMapviewToSelectedScooter(scooter: scooter)
        showScooterDetailView(scooter: scooter)
    }
}

// MARK: - Constants
private extension MapViewController {
    enum Constants {
        static let mapViewSpanLatitude = 0.0006360758398997746
        static let mapViewSpanLongitude = 0.0005722307572568752
        static let detailViewHeight: CGFloat = 200.0
        static let detailViewAnimationDuration = 0.3
    }
}
