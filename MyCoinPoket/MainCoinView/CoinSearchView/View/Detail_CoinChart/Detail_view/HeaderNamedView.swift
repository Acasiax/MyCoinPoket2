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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(coin88.market)
            
            // price 옵셔널 바인딩 (price가 있으면 통화 형식으로 변환, 없으면 "가격 없음" 표시)
            if let price = coin88.price {
                Text(price.convertToCurrency())
                    .font(.largeTitle.bold())
            } else {
                Text("가격 없음")  // 가격이 nil일 경우 표시
                    .font(.largeTitle.bold())
            }

            // change_price 옵셔널 바인딩 (변화액이 있는지 확인)
            if let changePrice = coin88.change_price {
                // 이익/손실 표시
                Text("\(changePrice > 0 ? "+" : "")\(String(format: "%.2f", changePrice))")  // 가격 변동 표시
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
                Text("변동 없음")  // 변화액이 nil일 경우 표시
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background {
                        Capsule()
                            .fill(Color.gray)  // 변화 정보가 없을 때 배경 색상 설정
                    }
            }
        }
    }
}
