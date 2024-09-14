//
//  GraphView.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/13/24.
//

import SwiftUI

struct GraphView: View {
    //하이
    var market: String
    @ObservedObject var appModel: AppViewModel

    var body: some View {
        if let weeklyCandles = appModel.getWeeklyCandles(for: market) {  // 특정 코인의 주간 시세 데이터가 있는 경우
            let prices = weeklyCandles.map { $0.trade_price }  // 주간 종가를 배열로 추출
            let profit = prices.last! > prices.first!  // 마지막 가격이 첫 번째 가격보다 높으면 이익
           
            GeometryReader { _ in
                // 사용자 정의 라인 그래프 (이익 여부에 따라 그래프 색상 설정)
                LineGraph(data: prices, profit: profit)
            }
            .padding(.vertical, 30)
            .padding(.bottom, 20)
        } else {
            // 데이터가 없는 경우 로딩 상태 표시
            Text("Loading graph...")
                .font(.caption)
                .foregroundColor(.gray)
                .task {
                    await appModel.fetchWeeklyCandles(for: market)  // 주간 시세 데이터가 없으면 가져오기
                }
        }
    }
}


