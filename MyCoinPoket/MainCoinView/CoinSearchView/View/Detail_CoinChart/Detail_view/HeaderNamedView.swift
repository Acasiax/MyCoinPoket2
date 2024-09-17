//
//  HeaderNamedView.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/14/24.
//

import SwiftUI

struct HeaderNamedView: View {
    
    var coin88: UpBitMarket
    
    var body: some View {
        HStack(spacing: 15){
        
            Image(systemName: "star")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(coin88.koreanName)
                    .font(.callout)
                if let price = coin88.price {
                    Text("현재 가격: \(price, specifier: "%.2f")")
                        .font(.headline)
                        .foregroundStyle(.green)
                } else {
                    Text("가격 정보 없음")
                        .font(.headline)
                        .foregroundStyle(.red)
                }
         
            }
        }
    }
}



struct MainPriceInfoView: View {
    
    var coin88: UpBitMarket
    @ObservedObject var socketViewModel: SocketViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(coin88.market)
            
            // 실시간 가격 표시
            if let coin = socketViewModel.coins.first(where: { $0.code == coin88.market }) {
                Text("\(coin.trade_price)")
                    .font(.largeTitle.bold())
            } else if let price = coin88.price {
                Text(price.convertToCurrency())
                    .font(.largeTitle.bold())
            } else {
                Text("가격 없음")
                    .font(.largeTitle.bold())
            }

            // change_price 변동액 표시
            if let changePrice = coin88.change_price {
                Text("\(changePrice > 0 ? "+" : "")\(String(format: "%.2f", changePrice))")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(changePrice < 0 ? .white : .black)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background {
                        Capsule()
                            .fill(changePrice < 0 ? .red : Color("LightGreen"))
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
