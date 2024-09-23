//
//  Home_AddAssetView.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/24/24.
//

import SwiftUI

struct Home_AddAssetView: View {
    @ObservedObject var newExpenseViewModel : NewExpenseViewModel
    @ObservedObject var tabBarVM: TabBarViewModel
    
    @State private var isShowingCoinSearch = false // 코인 리스트 Sheet 표시 여부
    @State private var market: [UpBitMarket] = []  // API로 받아온 코인 리스트
    @State private var searchText = ""  // 검색어
    let screenWidth = UIScreen.main.bounds.width
    // 코인 필터링 로직: 선택한 카테고리에 따라 필터링
    var filteredCoins: [UpBitMarket] {
        // 1. 카테고리 필터링: 선택된 카테고리에 따라 코인 필터링
        let filteredByCategory = selectedCategory == "전체" ? market : market.filter { $0.market.hasPrefix(selectedCategory) }
        
        // 2. 검색어 필터링: 검색어가 입력되었을 때 해당하는 코인만 필터링
        return searchText.isEmpty ? filteredByCategory : filteredByCategory.filter { $0.koreanName.contains(searchText) }
    }
    
    @State var selectedCategory: String = "KRW"
    
    @Environment(\.dismiss) var dismiss // 뷰를 닫기 위한 dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    VStack(spacing: 10) {
                        // 코인 이름 입력 필드
                        CoinSelectionView(
                            viewModel: newExpenseViewModel, coinName: $newExpenseViewModel.coinName,
                            coinMarketName: $newExpenseViewModel.coinMarketName,
                            isShowingCoinSearch: $isShowingCoinSearch,
                            searchText: $searchText,
                            market: $market,
                            filteredCoins: filteredCoins,
                            selectedCategory: $selectedCategory
                        )
                        
                        //거래가 입력 필드
                        CoinDetailFieldsView(viewModel: newExpenseViewModel, selectedCategory: $selectedCategory)
                    }
                   
                    
                    // 저장 버튼
                    SaveButtonView(
                        remark: newExpenseViewModel.coinName,
                        selectedType: newExpenseViewModel.selectedType,
                        purchasePrice: newExpenseViewModel.numberOfCoins,
                        currentPrice: newExpenseViewModel.buyPrice) {
                            
                            // 저장 기능 호출
                            newExpenseViewModel.saveExpense(
                                coinName: newExpenseViewModel.coinName,
                                coinMarketName: newExpenseViewModel.coinMarketName,
                                numberOfCoins: Double(newExpenseViewModel.numberOfCoins) ?? 0,
                                buyPrice: Double(newExpenseViewModel.buyPrice) ?? 0,
                                resultPrice: Double(newExpenseViewModel.resultPrice) ?? 0,
                                date: newExpenseViewModel.date,
                                selectedType: newExpenseViewModel.selectedType
                            )
                            
                            // 네비게이션 상태 변경
                            newExpenseViewModel.isNavigate = true
                            
                            // 뷰 닫기
                            dismiss()
                        }
                    
                }
                .padding()
              
            }
            .background {
                Color("BG").ignoresSafeArea()
            }
            .navigationTitle("자산 추가하기")
            .navigationBarTitleDisplayMode(.inline)
            
//            NavigationLink(destination: ExpenseListView(newExpenseViewModel: newExpenseViewModel), isActive: $newExpenseViewModel.isNavigate) {
//                EmptyView()
//            }
        }
    }
}


extension NumberFormatter {
    static var withCommas: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter
    }
}










