//
//  ContentView.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/13/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var tabBarVM = TabBarViewModel()
    @StateObject private var newExpenseViewModel = NewExpenseViewModel()
    @StateObject private var tabViewModel = TabViewModel()
    @StateObject private var newsViewModel = NewsSearchViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                switch tabBarVM.currentTab {
                case .Home:
                    Home_CoinSearchView(appModel: AppViewModel())
                case .Wallet:
                    ExpenseListView(newExpenseViewModel: newExpenseViewModel)
                case .News:
                    Home_NewsView(tabViewModel: tabViewModel, viewModel: newsViewModel) // 수정
                case .GPTForturn:
                    SettingListView()
                   // FearGreedHomeView()
                  //  ForturnView()
                  
                case .greed:
                    FearGreedHomeView()
                 //   ForturnView()
                }
                
                // 탭바는 항상 아래에 배치
                TabBarView(tabBarVM: tabBarVM, newExpenseViewModel: newExpenseViewModel)
                
                // tabBarVM.currentTab이 변경될 때 실행
                          .onChange(of: tabBarVM.currentTab) { newTab in
                              if newTab == .News {
                                  newsViewModel.fetchNews(for: tabViewModel.activeTab.rawValue) // News 탭에서만 fetchNews 호출
                              }
                          }
            }
            
        }
    }
}

#Preview {
    ContentView()
}
