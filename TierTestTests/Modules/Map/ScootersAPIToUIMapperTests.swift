//
//  ScootersAPIToUIMapperTests.swift
//  TierTestTests
//

import XCTest

@testable import TierTest

final class ScootersAPIToUIMapperTests: XCTestCase {
    private var sut: ScootersAPIToUIMapper?

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testMapping() {
        // Given
        sut = ScootersAPIToUIMapper()
        
        // When
        let result = sut?.map(apiModels: [mockAPIModel()])
        
        // Then
        let viewModel = result?.first
        XCTAssert(viewModel?.model == "Cindy Crawford")
        XCTAssert(viewModel?.batteryStatus == "69%")
        XCTAssert(viewModel?.annotation.coordinate.latitude == 19.0)
        XCTAssert(viewModel?.annotation.coordinate.longitude == 87.0)
    }
}

private extension ScootersAPIToUIMapperTests {
    func mockAPIModel() -> SccoterAPIModel {
        return SccoterAPIModel(id: "", vehicleId: "", hardwareId: "", zoneId: "", resolution: nil, resolvedBy: nil, resolvedAt: nil, battery: 69, state: "", model: "Cindy Crawford", fleetbirdId: 0, latitude: 19.0, longitude: 87.0)
    }
}
