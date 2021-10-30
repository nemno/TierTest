//
//  APICommunicator.swift
//  KHTest
//

import Foundation
import Alamofire

enum Endpoint: String {
    case getScooters = ""
}

protocol APICommunicator {
    func request(method: HTTPMethod, endpoint: Endpoint, completion: @escaping (([String: Any]?, Error?) -> Void))
}

final class DefaultAPICommunicator: APICommunicator {
    private let APIURL: String
    private let APIKey: String
    
    init(APIURL: String, APIKey: String) {
        self.APIURL = APIURL
        self.APIKey = APIKey
    }
    
    // MARK: - Protocol methods
    func request(method: HTTPMethod, endpoint: Endpoint, completion: @escaping (([String: Any]?, Error?) -> Void)) {
        guard let url = URL(string: self.APIURL + endpoint.rawValue) else {
            completion(nil, TierError.wrongURLFormatError)
            return
        }
        
        var request = URLRequest(url: url)
        request.method = method

        request.addValue(self.APIKey, forHTTPHeaderField: "secret-key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        AF.request(request)
            .validate()
            .responseString(completionHandler: { response in
                if let data = response.data {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                        completion(json, nil)
                    } else {
                        completion(nil, TierError.responseSerializationError)
                    }
                } else {
                    completion(nil, response.error)
                }
            })
    }
}
