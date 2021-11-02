//
//  ConfigProvider.swift
//  TierTest
//

enum BuildConfig {
    case dev
    case staging
    case unknown
}

protocol ConfigProvider {
    var buildConfig: BuildConfig { get }
    func APIURL() -> String
    func APIKey() -> String
}
