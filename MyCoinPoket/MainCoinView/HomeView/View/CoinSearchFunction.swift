//
//  CoinSearchFunction.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/14/24.
//

import SwiftUI

extension CoinSearchView {

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
           }) {
               Text(title)
                   .padding(7)
                   .background(selectedCategory == title ? Color.gray : Color.blue)
                   .foregroundColor(.white)
                   .cornerRadius(8)
           }
       }
   

    // 비동기로 코인의 가격을 가져오는 함수
    func loadCoinPrice(for item: UpBitMarket) async {
        do {
            // 서버에서 전체 데이터를 받아옴
            if let priceData = try await UpbitAPIManager.fetchMarketPrice(for: item.market) {
                // priceData 배열에서 첫 번째 요소를 가져와 trade_price 값을 사용
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
          //  print("가격을 패치하는데 에러 - \(item.market): \(error)")
        }
    }


}



