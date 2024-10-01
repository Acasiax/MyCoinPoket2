//
//  CoinSelectionView.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/24/24.
//

import SwiftUI

struct CoinSelectionView: View {
    @ObservedObject var viewModel: NewExpenseViewModel
    @Binding var coinName: String
    @Binding var coinMarketName: String
    @Binding var isShowingCoinSearch: Bool
    @Binding var searchText: String
    @Binding var market: [UpBitMarket]
    var filteredCoins: [UpBitMarket]
    let screenWidth = UIScreen.main.bounds.width
    @Binding var selectedCategory: String
    
    var body: some View {
        VStack {
            // 코인 이름 입력 필드
            Label {
                Text(coinName.isEmpty ? "코인을 선택하세요" : coinName)
                    .foregroundColor(coinName.isEmpty ? .gray : .black)
                    .padding(.leading, 10)
            } icon: {
                Image(systemName: "list.bullet.rectangle.portrait.fill")
                    .font(.title3)
                    .foregroundStyle(Color("Gray"))
            }
            .frame(width: screenWidth - 70, alignment: .leading)
            .padding(.vertical, 12)
            .padding(.horizontal, 15)
            .background {
                RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Color("BG"))
                
            }
            .onTapGesture {
                isShowingCoinSearch = true  // Sheet 열기
            }
            .sheet(isPresented: $isShowingCoinSearch) {
                CoinSearchSheet(
                    viewModel: viewModel, coinName: $coinName,
                    coinMarketName: $coinMarketName,
                    isShowingCoinSearch: $isShowingCoinSearch,
                    searchText: $searchText,
                    filteredCoins: filteredCoins,
                    market: $market, selectedCategory: $selectedCategory
                )
            }
        }
    }
}

struct CoinSearchSheet: View {
    @ObservedObject var viewModel: NewExpenseViewModel
    @Binding var coinName: String
    @Binding var coinMarketName: String
    @Binding var isShowingCoinSearch: Bool
    @Binding var searchText: String
    var filteredCoins: [UpBitMarket]
    @Binding var market: [UpBitMarket]
    @Binding var selectedCategory: String
    var body: some View {
        VStack {
            Spacer(minLength: 25)
            // 카테고리 버튼 추가
            categoryButtonsView()
            
            // 검색 필드
            TextField("코인을 검색하세요", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            // 코인 리스트
            List {
                ForEach(filteredCoins) { coin in
                    Button(action: {
                        // 코인 선택 시
                        coinName = coin.koreanName
                        coinMarketName = coin.market
                        viewModel.fetchLivePriceForCoin()
                        isShowingCoinSearch = false  // Sheet 닫기
                    }) {
                        HStack {
                            Text(coin.koreanName)
                                .fontWeight(.bold)
                            Spacer()
                            // 마켓 이름
                            Text(coin.market)
                                .foregroundStyle(.gray)
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
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
    
    
    
    // 카테고리 버튼을 추가하는 함수
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
    
    // 카테고리 버튼의 디자인 및 동작
    func categoryButton(title: String) -> some View {
        Button(action: {
            selectedCategory = title  // 선택된 카테고리 변경
        }) {
            Text(title)
                .padding(7)
                .background(selectedCategory == title ? Color.gray : Color.blue)
                .foregroundStyle(.white)
                .cornerRadius(8)
        }
    }
    
    
    // 코인 리스트를 가져오는 함수
    func fetchMarket() {
        UpbitAPIManager.fetchAllMarket { markets in
            if let markets = markets {
                self.market = markets
            } else {
                print("코인 데이터를 가져오지 못했습니다.")
            }
        }
    }
    
}

