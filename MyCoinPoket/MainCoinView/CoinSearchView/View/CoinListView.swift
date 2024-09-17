//
//  CoinListView.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/14/24.
//
//["KRW-BTC", "KRW-ETH", "KRW-NEO", "KRW-MTL", "KRW-XRP", "KRW-ETC", "KRW-SNT", "KRW-WAVES", "KRW-XEM", "KRW-QTUM", "KRW-LSK", "KRW-STEEM", "KRW-XLM", "KRW-ARDR", "KRW-ARK", "KRW-STORJ", "KRW-GRS"]
import SwiftUI

struct CoinListView: View {
    
    let filterCoinName: [UpBitMarket]
    @Binding var selectedItem: UpBitMarket?
    @ObservedObject var appModel: AppViewModel
    let loadCoinPrice: (UpBitMarket) async -> Void
    
    @StateObject var viewModel = SocketViewModel()
    
    var body: some View {
        LazyVStack {
            ForEach(filterCoinName, id: \.id) { item in
                NavigationLink(destination: Detail_CoinChartView(coin88: item)) {
                    rowView(item)
                }
                Divider()
                    .background(Color.gray)
            }
            .task {
                print("==")
                // 모든 코인의 market 값을 배열로 수집하여 한 번에 WebSocketManager로 전달
                let marketCodes = filterCoinName.map { $0.market }
                WebSocketManager.shared.send(marketCodes: marketCodes)
            }
        }
    }

    @State private var showBorder = false

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
            
            GraphView2(market: item.market, appModel: appModel)
                .scaleEffect(0.8)
            
            VStack(alignment: .trailing) {
                // 가격 및 변동률 표시
                if let coin = viewModel.coins.first(where: { $0.code == item.market }) {
                    let price = coin.trade_price
                    let prevPrice = coin.prev_closing_price

                    // 가격 색상 결정 함수 호출
                    let priceColor = calculatePriceColor(price: price, prevPrice: prevPrice)

                    // 가격 텍스트
                  //  Text("\(Int(price))원")
                    Text("\(price)원")
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
                if let changeRate = viewModel.coins.first(where: { $0.code == item.market })?.signed_change_rate {
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
