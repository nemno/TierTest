//
//  MapDataService.swift
//  TierTest
//

final class MapDataService: DataService {
    var apiCommunicator: APICommunicator
    
    init(apiCommunicator: APICommunicator) {
        self.apiCommunicator = apiCommunicator
    }
    
    func getScooters(completion: @escaping (([String]?, Error?) -> Void)) {
        self.apiCommunicator.request(method: .get, endpoint: Endpoint.getScooters, completion: { (response, error) in
            
        })
    }
}
