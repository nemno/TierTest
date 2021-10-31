//
//  ApplicationFacade.swift
//  TierTest
//

import UIKit

final class ApplicationAssembler {
    lazy var applicationCoordinator: ApplicationCoordinator = {
        return createApplicationCoordinator()
    }()
    
    private lazy var configProvider: ConfigProvider = {
        return DefaultConfigProvider()
    }()
    
    lazy var APICommunicator: APICommunicator = {
        return DefaultAPICommunicator(APIURL: self.configProvider.APIURL(), APIKey: self.configProvider.APIKey())
    }()

    lazy var locationProvider: LocationProvider = {
        return DefaultLocationProvider()
    }()
    
    private func createApplicationCoordinator() -> ApplicationCoordinator {
        let navigationController = UINavigationController()
        return ApplicationCoordinator(rootViewController: navigationController)
    }
    
    func createRootViewController() -> UIViewController? {
        applicationCoordinator.setRootModule(module: self.createMapModule(), animated: false, completion: nil)
        return applicationCoordinator.rootViewController
    }
    
    // MARK: - Module creation methods
    private func createMapModule() -> Module {
        let mapDataService = MapDataService(apiCommunicator: self.APICommunicator)
        return MapModule(coordinator: self.applicationCoordinator, dataService: mapDataService, locationProvider: self.locationProvider, didFinishModuleFlow: { [weak self] in
            self?.applicationCoordinator.popModule()
        })
    }
}
