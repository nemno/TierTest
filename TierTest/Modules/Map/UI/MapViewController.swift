//
//  MapViewController.swift
//  TierTest
//

import UIKit
import MapKit

final class MapViewController: UIViewController {
    private var mapView: MKMapView = MKMapView(frame: .zero)
    
    private let viewDidAppear: (() -> Void)
    
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
    
    // MARK: - UI Helper methods
    
    private func setupMapView() {
        mapView.showsUserLocation = true
        self.view.addSubview(mapView)
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(0.0)
            make.bottom.equalTo(0.0)
            make.leading.equalTo(0.0)
            make.trailing.equalTo(0.0)
        }
    }
}
