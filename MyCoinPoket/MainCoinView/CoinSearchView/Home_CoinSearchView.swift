//
//  CoinSearchView.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/13/24.
//

import SwiftUI

struct Home_CoinSearchView: View {

    @State private var text = ""
    @State var market: [UpBitMarket] = []
    @State var isStarred = false
    @ObservedObject var appModel: AppViewModel
    @State var selectedItem: UpBitMarket? = nil

    @State var selectedCategory: String = "KRW"
    
    // 코인 필터링 로직: 선택한 카테고리에 따라 필터링
    var filterCoinName: [UpBitMarket] {
        let filteredByCategory = selectedCategory == "전체" ? market : market.filter { $0.market.hasPrefix(selectedCategory) }
        return text.isEmpty ? filteredByCategory : filteredByCategory.filter { $0.koreanName.contains(text) }
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack{
                    Text("시세")
                        .naviTitleStyle()
                    Spacer()
                }
                // 검색 필드
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("코인 이름을 검색해보세요", text: $text)
                        .padding(.vertical, 8)
                }
                .background(Color(.systemGray4))
                .cornerRadius(10)
                
                .padding(.horizontal, 10)
                .padding(.bottom)
                //  .background(Color.green)
               
                .cornerRadius(10)
                .padding([.leading, .trailing], 16)
                
                // 카테고리 버튼 뷰
                categoryButtonsView()
                
                ScrollView {
                    CoinListView(
                        filterCoinName: filterCoinName,
                        selectedItem: $selectedItem,
                        appModel: appModel,
                        loadCoinPrice: loadCoinPrice
                    )
                }
                .foregroundStyle(.primary)
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarTitleTextColor(.black)
                .background {
                   // Color.white.ignoresSafeArea()
                    Color("BasicWhite").ignoresSafeArea()
                }
//                .background {
//                    Color("LightGrayBG").ignoresSafeArea()
//                }
            }
            .background {
                //Color("LightGrayBG").ignoresSafeArea()
                Color("BasicWhite").ignoresSafeArea()
            }
            .task {
                do {
                    let result = try await UpbitAPIManager.fetchMarket()
                    market = result
                } catch {
                    print("에러 fetching market: \(error)")
                }
            }
        }
    }

    // 주간 시세 데이터를 가져오는 함수
    func fetchGraphData(for item: UpBitMarket) async {
        await appModel.fetchWeeklyCandles(for: item.market)
        print(item.market)
    }
}

#Preview {
    Home_CoinSearchView(appModel: AppViewModel())
}
