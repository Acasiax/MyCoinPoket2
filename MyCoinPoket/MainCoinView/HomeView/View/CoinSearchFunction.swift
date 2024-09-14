//
//  CoinSearchFunction.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/14/24.
//

import SwiftUI

extension CoinSearchView {

    // 카테고리 버튼 뷰
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
       

    // 버튼 스타일을 모디파이어로 분리
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
   
    
    
       func listView() -> some View {
           LazyVStack {
               ForEach(filterCoinName, id: \.id) { item in
                   NavigationLink(destination: Home_CoinChartView(coin88: item)) {
                       rowView(item)
                           .onAppear {
                               selectedItem = item
                           }
                   }
                   Divider()
                       .background(Color.gray)
               }
           }
       }
    

//    func horizontalBannerView() -> some View {
//        ScrollView(.horizontal) {
//            HStack {
//                ForEach(filterCoinName, id: \.id) { item in
//                    bannerView(item)
//                }
//            }
//            .scrollTargetLayout()
//        }
//        .scrollTargetBehavior(.viewAligned)
//        .scrollIndicators(.hidden)
//    }
//    
//    func bannerView(_ banner: UpBitMarket) -> some View {
//        VStack{
//            ZStack {
//                RoundedRectangle(cornerRadius: 25)
//                    .fill(banner.color)
//                    .overlay(alignment: .leading) {
//                        Circle()
//                            .fill(.white.opacity(0.3))
//                            .scaleEffect(2)
//                            .offset(x: -60, y: 10.0)
//                    }
//                    .clipShape(RoundedRectangle(cornerRadius: 25))
//                    .frame(height: 150)
//                    .padding()
//                
//                VStack(alignment: .leading) {
//                    Spacer()
//                    Text(banner.koreanName)
//                        .font(.callout)
//                    Text(banner.market)
//                        .font(.title).bold()
//                }
//                .foregroundStyle(.white)
//                .padding(40)
//                .frame(maxWidth: .infinity, alignment: .leading)
//            }
//        }
//    }
//    
    func rowView(_ item: UpBitMarket) -> some View {
        HStack {
       
            Rectangle()
                .frame(width: 5, height: 20)
                .cornerRadius(5)
                .foregroundColor(colorForChange(item.change))
            
            VStack(alignment: .leading) {
                Text(item.koreanName)
                    .font(.system(size: 14))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    
                Text(item.market)
                    .font(.caption)
                    .foregroundStyle(.gray)
                
                
            }
            
            Spacer()
            
            // 주간 시세 데이터를 활용한 그래프 뷰, 코인 마켓을 전달
            GraphView2(market: item.market, appModel: appModel)
                .scaleEffect(0.8)
            // .frame(width: 130, height: 100)
            
            VStack(alignment: .trailing){
                
                if let itemPrice = item.price {
                    Text("$\(itemPrice, specifier: "%.2f")")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(.black)
                        
                } else {
                    Text("로딩 중...")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .task {
                            await loadCoinPrice(for: item)
                        }
                }
                if let changeRate = item.change_rate {
                    Text("주간변동율: \(changeRate, specifier: "%.2f")")
                        .font(.caption)
                        .foregroundStyle(.green)
                }
            }
            
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 5)
    }

    // item.change 값에 따라 색상 반환
    func colorForChange(_ change: String?) -> Color {
        switch change {
        case "EVEN": // 보합
            return Color.gray
        case "RISE": //상승
            return Color.green
        case "FALL": // 하락
            return Color.red
        default:
            return Color.gray // 기본 값
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
                        market[index].price = firstMarket.trade_price // 가격 업데이트
                        market[index].change_rate = firstMarket.change_rate
                        market[index].change_price = firstMarket.change_price
                        market[index].change = firstMarket.change
                        
                        // 가격 업데이트 후 주간 시세 데이터 가져오기
                        await fetchGraphData(for: item)
                    }
                }
            }
        } catch {
          //  print("Error fetching price for \(item.market): \(error)")
        }
    }


}
