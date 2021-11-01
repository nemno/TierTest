//
//  APICommunicator.swift
//  TierTest
//

import Foundation
import Alamofire

enum Endpoint: String {
    case getScooters = ""
}

protocol APICommunicator {
    func request(method: HTTPMethod, endpoint: Endpoint, completion: @escaping ((Data?, Error?) -> Void))
}

final class DefaultAPICommunicator: APICommunicator {
    private let APIURL: String
    private let APIKey: String
    
    init(APIURL: String, APIKey: String) {
        self.APIURL = APIURL
        self.APIKey = APIKey
    }
    
    // MARK: - Protocol methods
    func request(method: HTTPMethod, endpoint: Endpoint, completion: @escaping ((Data?, Error?) -> Void)) {
        let reachabilityManager = NetworkReachabilityManager()
        reachabilityManager?.startListening(onUpdatePerforming: { status in
            if status == .notReachable {
                print("\n==========\n❌ NO INTERNET CONNECTION\n==========\n")
                completion(nil, TierError.noInternetConnection)
                return
            }
        })
        
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
                    completion(data, nil)
                } else {
                    completion(nil, response.error)
                }
            })
    }
}
