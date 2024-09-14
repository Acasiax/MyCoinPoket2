//
//  NaverNewsRouter.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/13/24.
//

import Foundation
import Alamofire

enum NaverNewsRouter {
    case search(query: String, start: Int, display: Int)
}

extension NaverNewsRouter: NaverNewsTargetType {
    var baseURL: String {
        return NaverNewsAPI.naverNewsBaseURL
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        switch self {
        case .search:
            return "/v1/search/news.json"
        }
    }
    
    var parameters: [String: String] {
        switch self {
        case .search(let query, let start, let display):
            return [
                "query": query,
                "display": "\(display)",
                "start": "\(start)",
                "sort": "date"
            ]
        }
    }
    
    var headers: HTTPHeaders {
        return [
            NaverNewsHeader.clientId.rawValue: NaverNewsAPI.clientId,
            NaverNewsHeader.clientSecret.rawValue: NaverNewsAPI.clientSecret
        ]
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        var request = try URLRequest(url: url.appendingPathComponent(path), method: method)
        request.allHTTPHeaderFields = headers.dictionary
        request = try URLEncoding.default.encode(request, with: parameters)
        return request
    }
}


