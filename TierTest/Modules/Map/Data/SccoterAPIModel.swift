//
//  SccoterAPIModel.swift
//  TierTest
//
struct ScootersResponseApiModel: Codable {
    let data: ScooterDataApiModel
}

struct ScooterDataApiModel: Codable {
    let current: [SccoterAPIModel]
    let stats: ScooterStatsApiModel
}

struct SccoterAPIModel: Codable {
    let id: String
    let vehicleId: String
    let hardwareId: String
    let zoneId: String
    let resolution: String?
    let resolvedBy: String?
    let resolvedAt: String?
    let battery: Int
    let state: String
    let model: String
    let fleetbirdId: Int
    let latitude: Double
    let longitude: Double
}

struct ScooterStatsApiModel: Codable {
    let open: Int
    let assigned: Int
    let resolved: Int
}
