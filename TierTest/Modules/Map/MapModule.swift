//
//  MapModule.swift
//  TierTest
//

import UIKit
import CoreLocation

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
    private let APIToUIMapper: ScootersAPIToUIMapper
    
    init(coordinator: Coordinator, dataService: DataService, locationProvider: LocationProvider, APIToUIMapper: ScootersAPIToUIMapper, didFinishModuleFlow: @escaping (() -> Void)) {
        self.coordinator = coordinator
        self.dataService = dataService
        self.didFinishModuleFlow = didFinishModuleFlow
        self.locationProvider = locationProvider
        self.APIToUIMapper = APIToUIMapper
    }
    
    // MARK: - Private helper methods
    
    private func start() {
        getScooters()
    }
    
    private func getScooters() {
        guard let mapDataService = self.dataService as? MapDataService else { return }
        
        coordinator.showFullScreenLoading()
        mapDataService.getScooters { [weak self] (response, error) in
            guard let self = self else { return }
            
            self.coordinator.hideFullScreenLoading()
            if let response = response {
                let viewModels = self.APIToUIMapper.map(apiModels: response.data.current)
                self.didFetch(scooters: viewModels)
                self.getCurrentLocationForNearestScooter(scooters: viewModels)
            } else {
                let tierError: TierError = (error as? TierError) ?? .unknown
                self.coordinator.presentPopup(title: tierError.errorTitle(), message: tierError.errorMessage(), okTitle: Constants.errorPopupOKTitle, cancelTitle: nil, okCallback: {}, cancelCallback: nil)
            }
        }
    }
    
    private func getCurrentLocationForNearestScooter(scooters: [ScooterViewModel]) {
        self.locationProvider.getCurrentLocation { [weak self] (currentLocation, error) in
            if let location = currentLocation {
                var sortedScooters = scooters
                sortedScooters.sort { (left, right) -> Bool in
                    return location.distance(from: CLLocation(latitude: left.annotation.coordinate.latitude, longitude: left.annotation.coordinate.latitude)) < location.distance(from: CLLocation(latitude: right.annotation.coordinate.latitude, longitude: right.annotation.coordinate.latitude))
                }
                
                if let nearestScooter = sortedScooters.first {
                    self?.didFindNearestScooter(scooter: nearestScooter)
                }
            } else {
                let tierError: TierError = (error as? TierError) ?? .unknown
                self?.coordinator.presentPopup(title: tierError.errorTitle(), message: tierError.errorMessage(), okTitle: Constants.errorPopupOKTitle, cancelTitle: nil, okCallback: {}, cancelCallback: nil)
            }
        }
    }
    
    private func didFetch(scooters: [ScooterViewModel]) {
        guard let mapViewController = self.rootViewController as? MapViewController else { return }
        mapViewController.setScooters(scooters)
    }
    
    private func didFindNearestScooter(scooter: ScooterViewModel) {
        guard let mapViewController = self.rootViewController as? MapViewController else { return }
        mapViewController.setNearestScooter(scooter: scooter)
    }
}

// MARK: - Constants

private extension MapModule {
    enum Constants {
        static let errorPopupOKTitle = NSLocalizedString("alertOk", comment: "alertOk")
    }
}
