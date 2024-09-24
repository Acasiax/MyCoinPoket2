//
//  FearGreedNetworkManager.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/24/24.
//

import Foundation
import Alamofire

struct FearGreedNetworkManager {
    
    static func fetchFearGreedIndex(completion: @escaping (Result<FearGreedResponse, Error>) -> Void) {
        let url = "\(FearGreedAPI.baseURL)\(FearGreedAPI.fearGreedEndpoint)?limit=60"
        
        AF.request(url)
            .validate()
            .responseDecodable(of: FearGreedResponse.self) { response in
                switch response.result {
                case .success(let fearGreedResponse):
                    completion(.success(fearGreedResponse))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}

