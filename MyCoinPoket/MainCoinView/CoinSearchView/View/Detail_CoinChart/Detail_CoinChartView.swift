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
    @ObservedObject var socketViewModel: SocketViewModel
    
    @State var currentCoin: String = "BTC"
    @State var isNavigating: Bool = false

    @Namespace var animation
    @StateObject var appModel: AppViewModel = AppViewModel()
    @ObservedObject var newExpenseViewModel: NewExpenseViewModel
    @ObservedObject var tabBarVM: TabBarViewModel
    // @Environment(\.dismiss) 속성 추가
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            // 커스텀 네비게이션 바
            HStack {
                Button(action: {
                    dismiss()  // 이전 화면으로 돌아가기
                }) {
                    Image(systemName: "arrow.left")
                        .font(.title)
                        .foregroundColor(.blue)
                }
                Spacer()
                Text(coin88.koreanName)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Spacer()
            }

            .background(Color("BasicWhite"))
           // .background(Color.clear)
            
            HeaderNamedView(coin88: coin88, socketViewModel: socketViewModel)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 10)
            
            // MainPriceInfoView에 socketViewModel 전달
            MainPriceInfoView(coin88: coin88, socketViewModel: socketViewModel)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 10)
//            // 라인 그래프
//            //GraphView(market: coin88.market, appModel: appModel)
            Home_Trading(coin88: coin88, socketViewModel: socketViewModel)
                .frame(height: 500)
                .edgesIgnoringSafeArea(.all)
                .padding(.bottom, 10)
            Controls()  // 구매/판매 버튼
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            appModel.fetchWeeklyCandles(for: coin88.market)  // 화면이 나타날 때 주간 시세 데이터 가져오기
        }
        .navigationBarHidden(true)  // 기본 네비게이션 바 숨기기
                
                // 네비게이션 링크 추가
        NavigationLink(destination: Home_AddAssetView(newExpenseViewModel: newExpenseViewModel, tabBarVM: tabBarVM), isActive: $isNavigating) {
                    EmptyView()
                }
            }

    @ViewBuilder
    func Controls() -> some View {
        HStack(spacing: 20) {
            Button {} label: {
                Text("업비트로 이동")
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(.blue)
                    }
            }
            
            Button {
                           isNavigating = true  // "포폴 추가" 버튼을 누르면 네비게이션 상태 변경
                       } label: {
                           Text("포폴 추가")
                               .fontWeight(.bold)
                               .foregroundColor(.black)
                               .frame(maxWidth: .infinity)
                               .padding(.vertical)
                               .background {
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




//#Preview {
//    Home_CoinSearchView(appModel: AppViewModel())
//}
//
