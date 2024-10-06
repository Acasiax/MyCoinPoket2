//
//  HeaderNamedView.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/14/24.
//

import SwiftUI

struct HeaderNamedView: View {
    
    var coin88: UpBitMarket
    @ObservedObject var socketViewModel: SocketViewModel
    
    var body: some View {
        HStack(spacing: 15){
            
            if let coin = socketViewModel.coins.first(where: { $0.code == coin88.market }) {
                       let price = coin.trade_price
                       let prevPrice = coin.prev_closing_price

                       Rectangle()
                           .frame(width: 7, height: 40)
                           .cornerRadius(5)
                           .foregroundStyle(price > prevPrice ? .red : (price < prevPrice ? .blue : .primary))
                   } else {
                       Rectangle()
                           .frame(width: 7, height: 40)
                           .cornerRadius(5)
                           .foregroundStyle(.primary)
                   }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(coin88.koreanName)
                   // .foregroundStyle(.blac)
                    .font(.title3)
                    .bold()
                
                Text(coin88.market)
                 //   .foregroundStyle(.black)
                
                
            }
        }
    }
}



struct MainPriceInfoView: View {
    
    var coin88: UpBitMarket
    @ObservedObject var socketViewModel: SocketViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
                 
                 // 실시간 가격 표시
                 if let coin = socketViewModel.coins.first(where: { $0.code == coin88.market }) {
                     Text(formatPrice(coin.trade_price, for: coin88.market))
                         .font(.largeTitle.bold())
                         .foregroundStyle(.primary)
                 } else if let price = coin88.price {
                     Text(formatPrice(price, for: coin88.market))
                         .font(.largeTitle.bold())
                         .foregroundStyle(.primary)
                 } else {
                     Text("가격 없음")
                         .font(.largeTitle.bold())
                         .foregroundStyle(.white)
                 }

     

            // 실시간 가격을 이용한 change_price 변동액 표시
            if let coin = socketViewModel.coins.first(where: { $0.code == coin88.market }) {
                let changePrice = coin.trade_price - coin.prev_closing_price
                let formattedChangePrice = String(format: "%.2f", changePrice).convertToCurrencyFormat()

                Text("\(changePrice > 0 ? "+" : "")\(formattedChangePrice)")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(changePrice < 0 ? .blue : .red)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background {
                        Capsule()
                           // .fill(changePrice < 0 ? .red : Color("LightGreen"))
                            .fill(Color("LightGreen"))
                    }
            } else {
                Text("변동 없음")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background {
                        Capsule()
                            .fill(Color.gray)
                    }
            }

        }
    }
}



extension MainPriceInfoView {
    
    func formatPrice(_ price: Double, for market: String) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal // 3자리마다 콤마 추가
        
        func setFractionDigits(min: Int, max: Int) {
            numberFormatter.minimumFractionDigits = min
            numberFormatter.maximumFractionDigits = max
        }
        
        if market.hasPrefix("KRW") {
            if price < 1 {
                return String(price) // 소수점 전체 표시
            } else if price < 10 {
                setFractionDigits(min: 4, max: 4)
            } else if price < 10000 {
                setFractionDigits(min: 2, max: 2)
            } else {
                setFractionDigits(min: 0, max: 0)
            }
        } else if market.hasPrefix("BTC") {
            setFractionDigits(min: 8, max: 8)
        } else if market.hasPrefix("USDT") {
            if price < 1 {
                return String(price) // 소수점 전체 표시
            } else if price < 10 {
                setFractionDigits(min: 3, max: 3)
            } else {
                setFractionDigits(min: 2, max: 2)
            }
        } else {
            // 기타 카테고리는 기본적으로 소수점 없는 정수로 표시
            setFractionDigits(min: 0, max: 0)
        }

        // 가격을 3자리마다 콤마가 포함된 문자열로 변환
        return numberFormatter.string(from: NSNumber(value: price)) ?? "\(price)"
    }

    
}


extension String {
    func convertToCurrencyFormat() -> String {
        if let value = Double(self) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 2
            formatter.minimumFractionDigits = 2
            return formatter.string(from: NSNumber(value: value)) ?? self
        }
        return self
    }
}
