//
//  Home.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/13/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct Home: View {
    var coin88: UpBitMarket
    
    @State var currentCoin: String = "BTC"  // 현재 선택된 코인

    @Namespace var animation  // 애니메이션을 위한 네임스페이스
    @StateObject var appModel: AppViewModel = AppViewModel()  // 앱의 상태를 관리하는 모델
    var body: some View {
        VStack{
          //  if let coins = appModel.coins, let coin = appModel.currentCoin {  // 코인 데이터가 로드되면 실행
                // MARK: 샘플 UI
                HStack(spacing: 15){
                  //  AnimatedImage(url: URL(string: coin.image))  // 코인 이미지
                    Image(systemName: "star")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                    
                    VStack(alignment: .leading, spacing: 5) {  // 코인 이름과 심볼
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
                        //                        Text(coin.symbol.uppercased())
                        //                            .font(.caption)
                        //                            .foregroundColor(.gray)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                
            VStack(alignment: .leading, spacing: 8) {
                Text(coin88.market)
                
                // price 옵셔널 바인딩 (price가 있으면 통화 형식으로 변환, 없으면 "가격 없음" 표시)
                if let price = coin88.price {
                    Text(price.convertToCurrency())  // 코인의 현재 가격을 표시
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
                        .foregroundColor(changePrice < 0 ? .white : .black)  // 가격 변동에 따라 텍스트 색상 설정
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background {
                            Capsule()
                                .fill(changePrice < 0 ? .red : Color("LightGreen"))  // 가격 변동에 따라 배경 색상 설정
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

                
                .frame(maxWidth: .infinity, alignment: .leading)

           // GraphView(coin: coin88)  // 코인 그래프 뷰
            GraphView(market: coin88.market, appModel: appModel)
                Controls()  // 구매/판매 버튼
//            } else {
//                ProgressView()  // 데이터 로딩 중인 경우
//                    .tint(Color("LightGreen"))
//            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
                    appModel.fetchWeeklyCandles(for: coin88.market)  // 화면이 나타날 때 주간 시세 데이터를 가져옵니다.
                }
    }
    
    // MARK: 라인 그래프
 
    
    // MARK: 컨트롤 (구매/판매 버튼)
    @ViewBuilder
    func Controls() -> some View {
        HStack(spacing: 20) {
            Button {} label: {
                Text("Sell")  // 판매 버튼
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background{
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(.white)  // 버튼 배경 색상
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
                            .fill(Color("LightGreen"))  // 버튼 배경 색상
                    }
            }
        }
    }
}

//#Preview {
//    CoinSearchView()
//}

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
    CoinSearchView(appModel: AppViewModel())
}

