//
//  TierError.swift
//  TierTest
//
import Foundation

public enum TierError: Error {
    case noInternetConnection
    case wrongURLFormatError
    case responseSerializationError
    case unknown

    func errorTitle() -> String {
        switch self {
        case .noInternetConnection:
            return NSLocalizedString("noConnectionTitle", comment: "noConnectionTitle")
        default:
            return NSLocalizedString("errorTitle", comment: "errorTitle")

        }
    }
    
    func errorMessage() -> String {
        switch self {
        case .noInternetConnection:
            return NSLocalizedString("noConnectionDescription", comment: "noConnectionDescription")
        default:
            return NSLocalizedString("errorMessage", comment: "errorMessage")
        }
    }
}
