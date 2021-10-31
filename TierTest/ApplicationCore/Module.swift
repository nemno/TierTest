//
//  Module.swift
//  TierTest
//

import UIKit

protocol Module {
    var coordinator: Coordinator { get }
    var didFinishModuleFlow: (()->Void) { get }
    var dataService: DataService { get }
    var rootViewController: UIViewController? { get }
}
