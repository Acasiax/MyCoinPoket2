//
//  CryptoModel.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/13/24.
//

import SwiftUI

typealias Markets = [UpBitMarket]
typealias MarketPrices = [MarketPrice]

// MARK: - Market
struct UpBitMarket: Hashable, Codable, Identifiable {
    let id = UUID()
    let market, koreanName, englishName: String
    var isStarred: Bool = false
    let color = Color.random()
    
    
    // MARK: - 지금은 빈값이지만 주봉 가져오는 MarketPrice 서버값을 대입할 예정인 변수들
    var price: Double?
    // MARK:-
    var trade_date: String?
    var trade_time: String?
    var trade_date_kst: String?
    var trade_time_kst: String?
    var trade_timestamp: Int64?
    var opening_price: Double?
    var high_price: Double?
    var low_price: Double?
    var trade_price: Double?
    var prev_closing_price: Double?
    var change: String?
    var change_price: Double?
    var change_rate: Double?
    var signed_change_price: Double?
    var signed_change_rate: Double?
    var trade_volume: Double?
    var acc_trade_price: Double?
    var acc_trade_price_24h: Double?
    var acc_trade_volume: Double?
    var acc_trade_volume_24h: Double?
    var highest_52_week_price: Double?
    var highest_52_week_date: String?
    var lowest_52_week_price: Double?
    var lowest_52_week_date: String?
    var timestamp: Int64?

    
    enum CodingKeys: String, CodingKey {
        case market
        case koreanName = "korean_name"
        case englishName = "english_name"
    }
}


//MARK: - 업비트 마켓이름으로 가져온 해당 코인의 주간 가격

// 종목 정보 구조체
struct MarketPrice: Codable, Identifiable {
    var id: String { return market + String(timestamp) }
    let market: String
    let trade_date: String
    let trade_time: String
    let trade_date_kst: String
    let trade_time_kst: String
    let trade_timestamp: Int64
    let opening_price: Double
    let high_price: Double
    let low_price: Double
    let trade_price: Double
    let prev_closing_price: Double
    let change: String
    let change_price: Double
    let change_rate: Double
    let signed_change_price: Double
    let signed_change_rate: Double
    let trade_volume: Double
    let acc_trade_price: Double
    let acc_trade_price_24h: Double
    let acc_trade_volume: Double
    let acc_trade_volume_24h: Double
    let highest_52_week_price: Double
    let highest_52_week_date: String
    let lowest_52_week_price: Double
    let lowest_52_week_date: String
    let timestamp: Int64
}



// MARK: - CandleData 구조체
struct CandleData: Codable, Identifiable {
    var id: String { market }  // market 필드를 고유 식별자로 사용
    
    let market: String                         // 종목 코드
    let candle_date_time_utc: String           // 캔들 기준 시각 (UTC)
    let candle_date_time_kst: String           // 캔들 기준 시각 (KST)
    let opening_price: Double                  // 시가
    let high_price: Double                     // 고가
    let low_price: Double                      // 저가
    let trade_price: Double                    // 종가
    let timestamp: Int64                       // 마지막 틱이 저장된 시각
    let candle_acc_trade_price: Double         // 누적 거래 금액
    let candle_acc_trade_volume: Double        // 누적 거래량
    let first_day_of_period: String            // 캔들 기간의 첫 날
}

