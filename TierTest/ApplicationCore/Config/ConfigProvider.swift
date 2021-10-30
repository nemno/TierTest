//
//  ConfigProvider.swift
//  TierTest
//
//  Created by Norbert Nemes on 2021. 10. 30..
//

enum BuildConfig {
    case dev
}

protocol ConfigProvider {
    var buildConfig: BuildConfig { get }
    func APIURL() -> String
    func APIKey() -> String
}
