//
//  NaverNewsTargetType.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/13/24.
//

import Foundation
import Alamofire

protocol NaverNewsTargetType: URLRequestConvertible {
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: [String: String] { get }
    var headers: HTTPHeaders { get }
}
