//
//  MapModule.swift
//  TierTest
//

import UIKit

final class MapModule: Module {
    var coordinator: Coordinator
    var didFinishModuleFlow: (() -> Void)
    var dataService: DataService
    lazy var rootViewController: UIViewController? = {
        return MapViewController(viewDidAppear: { [weak self] in
            self?.start()
        })
    }()
    
    private let locationProvider: LocationProvider
    
    init(coordinator: Coordinator, dataService: DataService, locationProvider: LocationProvider, didFinishModuleFlow: @escaping (() -> Void)) {
        self.coordinator = coordinator
        self.dataService = dataService
        self.didFinishModuleFlow = didFinishModuleFlow
        self.locationProvider = locationProvider
    }
    
    private func start() {
        getCurrentLocation()
        getScooters()
    }
    
    private func getScooters() {
        guard let mapDataService = self.dataService as? MapDataService else { return }
        
        mapDataService.getScooters { (response, error) in
            
        }
    }
    
    private func getCurrentLocation() {
        self.locationProvider.getCurrentLocation { (currentLocation, error) in
            // TODO: Handle current location based on feature requirement
        }
    }
}
