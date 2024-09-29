//
//  CoinListView.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/14/24.
//

import SwiftUI

struct CoinListView: View {
    
    let filterCoinName: [UpBitMarket]
    @Binding var selectedItem: UpBitMarket?
    @ObservedObject var appModel: AppViewModel
    let loadCoinPrice: (UpBitMarket) async -> Void
    
    @StateObject var socketViewModel = SocketViewModel()
    @State private var showBorder = false
    
    var body: some View {
        LazyVStack {
            ForEach(filterCoinName, id: \.id) { item in
                NavigationLink(destination: Detail_CoinChartView(coin88: item, socketViewModel: socketViewModel)) {
                    rowView(item)
                }
                Divider()
                    .background(Color.gray)
            }
            .task {
                print("==")
                let marketCodes = filterCoinName.map { $0.market }
                WebSocketManager.shared.send(marketCodes: marketCodes)
            }
        }
    }
    




    func rowView(_ item: UpBitMarket) -> some View {
       
        HStack {
              if let coin = socketViewModel.coins.first(where: { $0.code == item.market }) {
                  let price = coin.trade_price
                  let prevPrice = coin.prev_closing_price

                  Rectangle()
                      .frame(width: 5, height: 20)
                      .cornerRadius(5)
                      .foregroundColor(price > prevPrice ? .red : (price < prevPrice ? .blue : .primary))
              } else {
                  Rectangle()
                      .frame(width: 5, height: 20)
                      .cornerRadius(5)
                      .foregroundColor(.primary)
              }
            
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
            
            GraphView2(market: item.market, appModel: appModel)
                .scaleEffect(0.8)
            
            VStack(alignment: .trailing) {
                // 가격 및 변동률 표시
                if let coin = socketViewModel.coins.first(where: { $0.code == item.market }) {
                    let price = coin.trade_price
                    let prevPrice = coin.prev_closing_price

                    // 가격 색상 결정 함수 호출
                    let priceColor = calculatePriceColor(price: price, prevPrice: prevPrice)

                    // 가격 텍스트

                   // Text("\(price)")
                    Text(formatPrice(price, for: item.market))
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(priceColor)
                        .padding(8) // 패딩을 추가해 테두리가 잘 보이도록 설정
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(showBorder ? priceColor : Color.clear, lineWidth: 0.5) // 테두리 색상 결정
                        )
                        .onChange(of: price) { _ in
                            withAnimation(.easeInOut(duration: 1.0)) {
                                showBorder = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                withAnimation(.easeInOut) {
                                    showBorder = false
                                }
                            }
                        }
                } else {
                    Text("가격 로딩 중...")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }

                // 변동률 텍스트
                if let changeRate = socketViewModel.coins.first(where: { $0.code == item.market })?.signed_change_rate {
                    Text("주간변동율: \(changeRate, specifier: "%.2f")%")
                        .font(.caption)
                        .foregroundStyle(.green)
                } else {
                    Text("가격 로딩 중...")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 5)
    }

    // 전일 종가와 비교하여 색상 결정
    func calculatePriceColor(price: Double, prevPrice: Double) -> Color {
        if price > prevPrice {
            return .red // 상승 시 빨간색
        } else if price < prevPrice {
            return .blue   // 하락 시 파란색
        } else {
            return .primary  // 동일할 경우 기본 색상
        }
    }

    func colorForChange(_ change: String?) -> Color {
        switch change {
        case "EVEN": // 보합
            return Color.gray
        case "RISE": // 상승
            return Color.red
        case "FALL": // 하락
            return Color.blue
        default:
            return Color.gray // 기본 값
        }
    }
}




extension CoinListView {
    
    func formatPrice(_ price: Double, for market: String) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal // 3자리마다 콤마 추가
        
        if market.hasPrefix("KRW") {
            if price < 1 {
                return String(price) // 소수점 전체 표시
            } else if price < 10 {
                numberFormatter.minimumFractionDigits = 4
                numberFormatter.maximumFractionDigits = 4
            } else if price < 10000 {
                numberFormatter.minimumFractionDigits = 2
                numberFormatter.maximumFractionDigits = 2
            } else {
                numberFormatter.minimumFractionDigits = 0
                numberFormatter.maximumFractionDigits = 0
            }
        } else if market.hasPrefix("BTC") {
            numberFormatter.minimumFractionDigits = 8
            numberFormatter.maximumFractionDigits = 8
        } else if market.hasPrefix("USDT") {
            if price < 1 {
                return String(price) // 소수점 전체 표시
            } else if price < 10 {
                numberFormatter.minimumFractionDigits = 3
                numberFormatter.maximumFractionDigits = 3
            } else {
                numberFormatter.minimumFractionDigits = 2
                numberFormatter.maximumFractionDigits = 2
            }
        } else {
            // 기타 카테고리는 기본적으로 소수점 없는 정수로 표시
            numberFormatter.minimumFractionDigits = 0
            numberFormatter.maximumFractionDigits = 0
        }

        // 가격을 3자리마다 콤마가 포함된 문자열로 변환
        return numberFormatter.string(from: NSNumber(value: price)) ?? "\(price)"
    }

    
}
