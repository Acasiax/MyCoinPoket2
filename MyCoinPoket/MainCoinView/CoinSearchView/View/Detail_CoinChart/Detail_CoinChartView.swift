//
//  Home.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/13/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct Detail_CoinChartView: View {
    var coin88: UpBitMarket
    
    @State var currentCoin: String = "BTC"

    @Namespace var animation
    @StateObject var appModel: AppViewModel = AppViewModel()
    var body: some View {
        VStack{
            HeaderNamedView(coin88: coin88)
                .frame(maxWidth: .infinity, alignment: .leading)

            MainPriceInfoView(coin88: coin88)
                .frame(maxWidth: .infinity, alignment: .leading)

            // MARK: 라인 그래프
            GraphView(market: coin88.market, appModel: appModel)
                Controls()  // 구매/판매 버튼

        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
                    appModel.fetchWeeklyCandles(for: coin88.market)  // 화면이 나타날 때 주간 시세 데이터 가져오기
                }
    }
    
 
    // MARK: 컨트롤 (구매/판매 버튼)
    @ViewBuilder
    func Controls() -> some View {
        HStack(spacing: 20) {
            Button {} label: {
                Text("Sell")
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background{
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(.blue)
                    }
            }
            
            Button {} label: {
                Text("Buy")  // 구매 버튼
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background{
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color("LightGreen"))
                    }
            }
        }
    }
}








import SwiftUI

// MARK: Double 형식을 통화 형식으로 변환하는 확장 기능
extension Double {
    func convertToCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        return formatter.string(from: .init(value: self)) ?? ""  // 숫자를 통화 형식으로 변환
    }
}




#Preview {
    Home_CoinSearchView(appModel: AppViewModel())
}

