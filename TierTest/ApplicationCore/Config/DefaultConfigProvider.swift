//
//  ConfigProvider.swift
//  KHTest
//

import UIKit

final class DefaultConfigProvider: ConfigProvider {
    let buildConfig: BuildConfig
    private var configData: [String: Any] = [:]

    init() {
        var propertyListFormat =  PropertyListSerialization.PropertyListFormat.xml
        var plistXML: Data?

        self.buildConfig = .dev

        if let devPath = Bundle.main.path(forResource: "Config", ofType: "plist") {
            plistXML = FileManager.default.contents(atPath: devPath)
        } else {
            assertionFailure("no config plist found!")
            return
        }
        
        guard let xml = plistXML else {
            assertionFailure("plist could not be parsed!")
            return
        }
        
        guard let plistDictionary = try? PropertyListSerialization.propertyList(from: xml, options: .mutableContainersAndLeaves, format: &propertyListFormat) as? [String: Any] else {
            assertionFailure("plist could not be parsed!")
            return
        }
        
        self.configData = plistDictionary
    }
    
    // MARK: - Protocol methods
    func APIURL() -> String {
        if let url = self.configData["APIURL"] as? String {
            return url
        }
        
        assertionFailure("Could not find API URL!")
        return ""
    }
    
    func APIKey() -> String {
        if let key = self.configData["APIKey"] as? String {
            return key
        }
        
        assertionFailure("Could not find API Key!")
        return ""
    }
}
