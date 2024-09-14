//
//  AppViewModel.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/13/24.
//

import Foundation

class AppViewModel: ObservableObject {
    @Published var coins: [UpBitMarket]?
    @Published var currentCoin: UpBitMarket?
    @Published var weeklyCandles: [String: [CandleData]] = [:]

    // 주간 시세 데이터 가져오기
    func fetchWeeklyCandles(for market: String) {
        Task {
            do {
                let candles = try await UpbitAPIManager.fetchWeeklyCandles(for: market, count: 7)  // 마지막 7주 간 데이터
                await MainActor.run {
                    self.weeklyCandles[market] = candles  // 해당 코인의 주간 시세 데이터 업데이트
                }
            } catch {
              //  print("Error fetching weekly candles: \(error)")
            }
        }
    }
    
    // 특정 코인의 주간 시세 데이터를 반환하는 함수
    func getWeeklyCandles(for market: String) -> [CandleData]? {
        return weeklyCandles[market]
    }
}


