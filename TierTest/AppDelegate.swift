//
//  AppDelegate.swift
//  TierTest
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var applicationAssembler: ApplicationAssembler?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.applicationAssembler = ApplicationAssembler()
        let rootViewController = self.applicationAssembler?.createRootViewController()
        self.window?.rootViewController = rootViewController
        self.window?.makeKeyAndVisible()

        return true
    }

}

