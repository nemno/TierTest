//
//  MapDataServiceTests.swift
//  TierTestTests
//

import XCTest

@testable import TierTest

class MapDataServiceTests: XCTestCase {
    private var apiCommunicator: APICommunicator?
    private var sut: MapDataService?

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        apiCommunicator = nil
        sut = nil
        super.tearDown()
    }
    
    func testFetchingScooters() {
        // Given
        let communicator = MockMapModuleAPICommunicator()
        apiCommunicator = communicator
        sut = MapDataService(apiCommunicator: communicator)
        
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

    func testFetchingScootersFailure() {
        // Given
        let communicator = MockFailingMapModuleAPICommunicator()
        apiCommunicator = communicator
        sut = MapDataService(apiCommunicator: communicator)
        
        let expectation = self.expectation(description: "got error")

        // When
        sut?.getScooters { (response, error) in
            if let tierError = error as? TierError {
                // Then
                if tierError == .responseSerializationError {
                    expectation.fulfill()
                }
            }
        }
        waitForExpectations(timeout: 0.1, handler: nil)
    }
}
