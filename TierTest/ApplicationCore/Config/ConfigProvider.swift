//
//  ConfigProvider.swift
//  TierTest
//

enum BuildConfig {
    case dev
}

protocol ConfigProvider {
    var buildConfig: BuildConfig { get }
    func APIURL() -> String
    func APIKey() -> String
}
