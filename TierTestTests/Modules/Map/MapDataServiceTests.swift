//
//  MapDataServiceTests.swift
//  TierTestTests
//

import XCTest

@testable import TierTest

class MapDataServiceTests: XCTestCase {
    private var apiCommunicator: MockMapModuleAPICommunicator!
    private var sut: MapDataService?

    override func setUp() {
        super.setUp()
        apiCommunicator = MockMapModuleAPICommunicator()
    }

    override func tearDown() {
        apiCommunicator = nil
        sut = nil
        super.tearDown()
    }
    
    func testFetchingScooters() {
        // Given
        sut = MapDataService(apiCommunicator: apiCommunicator)
        
        let expectation = self.expectation(description: "got valid respond")

        // When
        sut?.getScooters { (response, error) in
            if response != nil {
                // Then
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 0.1, handler: nil)
    }

}
