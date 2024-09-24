//
//  OpenAIRouter.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/24/24.
//

import Foundation
import Alamofire

enum OpenAIRouter: URLRequestConvertible {
    case sendMessage(messages: [[String: String]])
    
    var baseURL: String {
        return GPTAPIKey.baseurl
    }
    
    var path: String {
        switch self {
        case .sendMessage:
            return "/chat/completions"
        }
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var headers: HTTPHeaders {
        return [
            OpenAIHeader.authorization.rawValue: "Bearer \(GPTAPIKey.hi1)",
            OpenAIHeader.contentType.rawValue: "application/json"
        ]
    }
    
    var parameters: [String: Any] {
        switch self {
        case .sendMessage(let messages):
            return [
                OpenAIRequestParameter.model.rawValue: "gpt-4o",  // 사용하고 싶은 모델 이름
                OpenAIRequestParameter.messages.rawValue: messages,
                OpenAIRequestParameter.maxCompletionTokens.rawValue: 100,
                OpenAIRequestParameter.temperature.rawValue: 0.7
            ]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL().appendingPathComponent(path)
        
        var request = URLRequest(url: url)
        request.method = method
        request.headers = headers
        
        return try JSONEncoding.default.encode(request, with: parameters)
    }
}


