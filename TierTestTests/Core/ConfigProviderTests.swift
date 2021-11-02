//
//  ConfigProviderTests.swift
//  TierTestTests
//

import XCTest

@testable import TierTest

final class ConfigProviderTests: XCTestCase {
    private var sut: ConfigProvider?
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testConfigProvider() {
        // Given
        sut = DefaultConfigProvider()

        // When
        let config = sut?.buildConfig
        let apiURL = sut?.APIURL()
        let apiKey = sut?.APIKey()
        
        // Then
        XCTAssert(config == .staging)
        XCTAssert(apiURL == "https://api.jsonbin.io/b/5fa8ff8dbd01877eecdb898f")
        XCTAssert(apiKey == "$2b$10$VE0tRqquld4OBl7LDeo9v.afsyRXFlXcQzmj1KpEB6K1wG2okzQcK")
    }
}
