//
//  UpbitTargetType.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/13/24.
//

import Foundation
import Alamofire

protocol UpbitTargetType: URLRequestConvertible {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: String]? { get }
    var headers: HTTPHeaders? { get }
}

