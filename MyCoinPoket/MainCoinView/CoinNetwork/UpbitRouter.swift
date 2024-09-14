//
//  UpbitRouter.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/13/24.
//

import Foundation
import Alamofire

enum UpbitRouter {
    case fetchAllMarket
    case fetchMarket
    case fetchMarketPrice(marketCode: String)
    case fetchWeeklyCandles(marketCode: String, count: Int, to: String?)
}

extension UpbitRouter {
    
    var baseURL: String {
        return UpbitAPI.UpbitBaseURL
    }
    
    var method: Alamofire.HTTPMethod{
        return .get
    }
    
    var path: String {
        switch self {
        case .fetchAllMarket:
            return "/market/all"
        case .fetchMarket:
            return "/market/all"
        case .fetchMarketPrice(let marketCode):
            return "/ticker?markets=\(marketCode)"
        case .fetchWeeklyCandles(let marketCode, let count, let to):
            var path = "/candles/weeks?market=\(marketCode)&count=\(count)"
            if let to = to {
                path += "&to=\(to)"
            }
            return path
        }
    }
    

    func asURLRequest() throws -> URLRequest {
        guard let url = URL(string: baseURL + path) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}

