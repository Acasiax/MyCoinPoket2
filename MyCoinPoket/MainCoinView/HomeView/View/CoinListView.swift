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

    var body: some View {
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
                if let itemPrice = item.price {
                    Text("$\(itemPrice, specifier: "%.2f")")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(.black)
                } else {
                    Text("로딩 중...")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .task {
                            await loadCoinPrice(item)
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


    func colorForChange(_ change: String?) -> Color {
        switch change {
        case "EVEN": // 보합
            return Color.gray
        case "RISE": // 상승
            return Color.green
        case "FALL": // 하락
            return Color.red
        default:
            return Color.gray // 기본 값
        }
    }
}
