//
//  UpbitAPIManager.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/13/24.
//

import Foundation
import Alamofire

struct UpbitAPIManager {
    
    private init() { }
    
    // 모든 시장 정보를 가져오는 함수
    static func fetchAllMarket(completion: @escaping (Markets?) -> Void) {
        do {
            let request = try UpbitRouter.fetchAllMarket.asURLRequest()
            
            AF.request(request).responseDecodable(of: Markets.self) { response in
                switch response.result {
                case .success(let markets):
                  
                    DispatchQueue.main.async {
                        completion(markets)
                    }
                case .failure(let error):
                    print("Error fetching all markets: \(error)")
                    completion(nil)
                }
            }
        } catch {
            print("URLRequest 생성 실패: \(error)")
            completion(nil)
        }
    }
    
    // 모든 시장 데이터를 가져오는 함수
    static func fetchMarket() async throws -> Markets {
        let request = try UpbitRouter.fetchMarket.asURLRequest()
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(request).responseDecodable(of: Markets.self) { response in
                switch response.result {
                case .success(let markets):
                    continuation.resume(returning: markets)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    // 개별 시장 가격 정보를 가져오는 함수
    static func fetchMarketPrice(for marketCode: String) async throws -> [MarketPrice]? {
        let request = try UpbitRouter.fetchMarketPrice(marketCode: marketCode).asURLRequest()
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(request).responseDecodable(of: [MarketPrice].self) { response in
                switch response.result {
                case .success(let marketPrices):
                    continuation.resume(returning: marketPrices)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    // 특정 코인의 주간 시세 데이터를 가져오는 함수
    static func fetchWeeklyCandles(for marketCode: String, count: Int = 1, to: String? = nil) async throws -> [CandleData] {
    
        let request = try UpbitRouter.fetchWeeklyCandles(marketCode: marketCode, count: count, to: to).asURLRequest()
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(request).responseDecodable(of: [CandleData].self) { response in
                switch response.result {
                case .success(let candleData):
                    continuation.resume(returning: candleData)
                case .failure(let error):
                    do {
                        // 서버 오류 처리
                        if let errorResponse = try? JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: Any],
                           let errorName = errorResponse["name"] as? String {
                            let customError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error fetching weekly candles: \(errorName)"])
                            continuation.resume(throwing: customError)
                        } else {
                            continuation.resume(throwing: error)
                        }
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }
}

