//
//  ApplicationCoordinator.swift
//  KHTest
//

import UIKit
import Alamofire
import SnapKit

protocol Coordinator {
    var rootViewController: UIViewController { get }
    func presentModule(module: Module, animated: Bool, completion:(()->Void)?)
    func dismissPresentedModule(animated: Bool, completion:(()->Void)?)
    func popModule()
    func setRootModule(module: Module, animated: Bool, completion:(()->Void)?)
    func pushModule(module: Module, animated: Bool, completion:(()->Void)?)
    func presentPopup(title: String, message: String, okTitle: String, cancelTitle: String?, okCallback:@escaping (()->Void), cancelCallback:(()->Void)?)
    func showFullScreenLoading()
    func hideFullScreenLoading()
}


final class ApplicationCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    private (set) var  rootViewController: UIViewController
    
    private var loadingView: UIView?
    private var noConnectionAlertView: UIView?
        
    private var modules: [Module] = []
    private (set) var presentedModules: [Module] = []
    private var isNavigationBeingObserved: Bool = false
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
        
        let reachabilityManager = NetworkReachabilityManager()
        reachabilityManager?.startListening(onUpdatePerforming: { status in
            if status == .notReachable {
                print("\n==========\n❌ NO INTERNET CONNECTION\n==========\n")
//                self?.showNoConnectionAlert()
            } else {
//                self?.hideNoConnectionAlert()
            }
        })
    }
    
    // MARK: - Protocol methods
    
    func presentModule(module: Module, animated: Bool, completion:(()->Void)? = nil) {
        guard let viewControllerToPresent = module.rootViewController else { return }
        
        checkAndClearPresentedControllers()
                
        if let presenter = self.presentedModules.last {
            presenter.rootViewController?.present(viewControllerToPresent, animated: animated, completion: completion)
        } else {
            self.rootViewController.present(viewControllerToPresent, animated: animated, completion: completion)
        }
        self.presentedModules.append(module)
    }
    
    func dismissPresentedModule(animated: Bool, completion: (() -> Void)?) {
        self.presentedModules.last?.rootViewController?.dismiss(animated: animated, completion: completion)
        self.presentedModules.removeLast()
    }
    
    func pushModule(module: Module, animated: Bool, completion: (() -> Void)?) {
        guard let navigationController = self.rootViewController as? UINavigationController else { return }
        guard let viewControllerToPush = module.rootViewController else { return }
        
        if self.isNavigationBeingObserved == false {
            self.isNavigationBeingObserved = true
                            
            navigationController.delegate = self
        }
        
        var navigationCompletion = completion ?? {}

        navigationCompletion = { [weak self] in
            self?.modules.append(module)
            completion?()
        }

        navigationController.pushViewController(viewControllerToPush, animated: animated)
        
        guard animated, let coordinator = navigationController.transitionCoordinator else {
            DispatchQueue.main.async { navigationCompletion() }
            return
        }

        coordinator.animate(alongsideTransition: nil) { _ in navigationCompletion() }
    }
    
    func popModule() {
        if let navigationController = self.rootViewController as? UINavigationController {
            navigationController.popViewController(animated: true)
//            self.modules.removeLast()
        }
    }
    
    func presentPopup(title: String, message: String, okTitle: String, cancelTitle: String?, okCallback: @escaping (()->Void), cancelCallback:(()->Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: okTitle, style: .default, handler: { action in
            okCallback()
        }))
        if let cancelT = cancelTitle {
            alertController.addAction(UIAlertAction(title: cancelT, style: .cancel, handler: { action in
                cancelCallback?()
            }))
        }
        
        self.rootViewController.present(alertController, animated: true, completion: nil)
    }
    
    func setRootModule(module: Module, animated: Bool, completion: (() -> Void)?) {
        guard let navigationController = self.rootViewController as? UINavigationController else { return }
        guard let viewControllerToPush = module.rootViewController else { return }
        
        self.modules.removeAll()
        self.modules.append(module)
        
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        navigationController.setViewControllers([viewControllerToPush], animated: animated)
        CATransaction.commit()
    }
    
    func showFullScreenLoading() {
        if let _ = self.loadingView {
            return
        }
        
        let loadingBackgroundView = UIView(frame: .zero)
        loadingBackgroundView.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
        
        if let viewController = self.rootViewController.presentedViewController {
            viewController.view.addSubview(loadingBackgroundView)
        } else {
            self.rootViewController.view.addSubview(loadingBackgroundView)
        }
        
        loadingBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(0.0)
            make.leading.equalTo(0.0)
            make.trailing.equalTo(0.0)
            make.bottom.equalTo(0.0)
        }
        
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.color = .white
        activityIndicatorView.sizeToFit()
        loadingBackgroundView.addSubview(activityIndicatorView)
        activityIndicatorView.snp.makeConstraints { make in
            make.center.equalTo(loadingBackgroundView.snp.center)
        }
        activityIndicatorView.startAnimating()
        
        self.loadingView = loadingBackgroundView
    }
    
    func hideFullScreenLoading() {
        self.loadingView?.removeFromSuperview()
        self.loadingView = nil
    }
    
    // MARK: - Private helper methods
    
    private func checkAndClearPresentedControllers() {
        if self.presentedModules.count == 0 && self.rootViewController.presentedViewController == nil {
            return
        }
        
        var controller = self.rootViewController.presentedViewController
        
        while controller?.presentedViewController != nil {
            controller = controller?.presentedViewController
        }
        
        if self.presentedModules.last?.rootViewController != controller {
            self.presentedModules.removeLast()
            checkAndClearPresentedControllers()
        }
    }
    
    // MARK: - UINavigationControllerDelegate methods
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if navigationController.viewControllers.count < self.modules.count {
            self.modules.removeLast()
        }
    }
    
}
