//
//  MapDataService.swift
//  TierTest
//

import Foundation

final class MapDataService: DataService {
    var apiCommunicator: APICommunicator
    
    init(apiCommunicator: APICommunicator) {
        self.apiCommunicator = apiCommunicator
    }
    
    func getScooters(completion: @escaping ((ScootersResponseApiModel?, Error?) -> Void)) {
        self.apiCommunicator.request(method: .get, endpoint: Endpoint.getScooters, completion: { (responseData, error) in
            guard let data = responseData else {
                completion(nil, error)
                return
            }

            guard let decodedResponse = try? JSONDecoder().decode(ScootersResponseApiModel.self, from: data) else {
                completion(nil, TierError.responseSerializationError)
                return
            }
            
            completion(decodedResponse, nil)
        })
    }
}
