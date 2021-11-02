//
//  MockFailingMapModuleAPICommunicator.swift
//  TierTestTests
//

import Foundation
import Alamofire

@testable import TierTest

final class MockFailingMapModuleAPICommunicator: APICommunicator {
    let mockResponseString = """
 {
    "data":{
       "current":[
          {
             "id":"6348dfa0-1b20-40ed-98e9-fe9e232b6105",
             "vehicleId":"8ece0495-bef0-4eac-a58e-dede2bf975a3",
             "hardwareId":"868446031763952",
             "zoneId":"BERLIN",
             "resolution":"CLAIMED",
             "resolvedBy":"5VRiXTOvRWbWfAlIKDv10HrE8LJ2",
             "resolvedAt":"2019-10-10T06:35:21.153Z",
             "battery":91,
             "state":"ACTIVE",
             "model":"AB",
             "fleetbirdId":118160,
             "latitude":52.506731,
             "longitude":13.289618
          },
          {
             "id":"9a59f908-d45f-4159-9843-a1e2a4b85731",
             "vehicleId":"4cd6d67a-56f4-42ec-ab0b-85c6a8834ea0",
             "hardwareId":"862061041542068",
             "zoneId":"BERLIN",
             "resolution":"CLAIMED",
             "resolvedBy":"Rd2CFMWkCzLPHiDZOWMlDeV9o783",
             "resolvedAt":"2019-10-10T05:43:29.048Z",
             "battery":100,
             "state":"ACTIVE",
             "model":"AB",
             "fleetbirdId":123190,
             "latitude":52.515626,
             "longitude":13.347024
          },
          {
             "id":"9a1d5414-0cb3-4e6a-a147-a8f9920443bc",
             "vehicleId":"a7496787-0e7d-40da-ab4a-e65a9d184a89",
             "hardwareId":"868446031698182",
             "zoneId":"BERLIN",
             "resolution":"NOT_FOUND",
             "resolvedBy":"KmOOdbjxxxWwnbFCLZXdtGLQPZ92",
             "resolvedAt":"2019-10-10T09:42:14.370Z",
             "battery":14,
             "state":"LOW_BATTERY",
             "model":"AB",
             "fleetbirdId":118070,
             "latitude":52.472968,
             "longitude":13.442552
          }
       ],
       "stats":{
          "open":38,
          "assigned":0,
          "resolved":113
       }
    }
"""
    
    func request(method: HTTPMethod, endpoint: Endpoint, completion: @escaping ((Data?, Error?) -> Void)) {
        let data = mockResponseString.data(using: .utf8)
        completion(data, nil)
    }
}
