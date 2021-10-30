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
        return MapViewController(nibName: nil, bundle: nil)
    }()
    
    init(coordinator: Coordinator, dataService: DataService, didFinishModuleFlow: @escaping (() -> Void)) {
        self.coordinator = coordinator
        self.dataService = dataService
        self.didFinishModuleFlow = didFinishModuleFlow
        
        getScooters()
    }
    
    private func getScooters() {
        guard let mapDataService = self.dataService as? MapDataService else { return }
        guard let viewController = self.rootViewController as? MapViewController else { return }
        
        mapDataService.getScooters { (response, error) in
            
        }
    }
}
