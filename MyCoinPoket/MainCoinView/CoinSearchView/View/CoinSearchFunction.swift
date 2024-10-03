//
//  CoinSearchFunction.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/14/24.
//

import SwiftUI

extension Home_CoinSearchView {

    func categoryButtonsView() -> some View {
        HStack {
            categoryButton(title: "KRW")
            categoryButton(title: "BTC")
            categoryButton(title: "USDT")
            categoryButton(title: "전체")
            Spacer()
        }
        .padding(.leading)
    }

    func categoryButton(title: String) -> some View {
        Button(action: {
            selectedCategory = title
            updateWebSocketForCategory()
        }) {
            Text(title)
                .foregroundStyle(selectedCategory == title ? Color.white : Color.gray)
                .padding(7)
                .padding(.horizontal, 5)
                .background(selectedCategory == title ? Color.blue : Color.gray.opacity(0.2))
                //.foregroundColor(.white)
                .cornerRadius(8)
        }
    }

    // 선택된 카테고리에 맞춰 WebSocket에 데이터를 다시 보내는 함수
    func updateWebSocketForCategory() {
        let filteredMarketCodes = filterCoinName.map { $0.market }
        WebSocketManager.shared.send(marketCodes: filteredMarketCodes)
    }

    // 비동기로 코인의 가격을 가져오는 함수
    func loadCoinPrice(for item: UpBitMarket) async {
        do {
            if let priceData = try await UpbitAPIManager.fetchMarketPrice(for: item.market) {
                if let firstMarket = priceData.first {
                    if let index = market.firstIndex(where: { $0.market == item.market }) {
                        market[index].price = firstMarket.trade_price
                        market[index].change_rate = firstMarket.change_rate
                        market[index].change_price = firstMarket.change_price
                        market[index].change = firstMarket.change
                        
                        // 가격 업데이트 후 주간 시세 데이터 가져오기
                        await fetchGraphData(for: item)
                    }
                }
            }
        } catch {
            // 에러 처리
        }
    }
}

