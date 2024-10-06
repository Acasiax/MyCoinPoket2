//
//  ContentView.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/13/24.
//

import SwiftUI
import LocalAuthentication

struct ContentView: View {
    @StateObject private var tabBarVM = TabBarViewModel()
    @StateObject private var newExpenseViewModel = NewExpenseViewModel()
    @StateObject private var tabViewModel = TabViewModel()
    @StateObject private var newsViewModel = NewsSearchViewModel()
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 배경색 설정
                Color.clear
                    .ignoresSafeArea()
                
                VStack {
                    switch tabBarVM.currentTab {
                    case .Home:
                       // HomeTest333()
                      //  Home_CoinSearchView(appModel: AppViewModel())
                        Home_CoinSearchView(
                            appModel: AppViewModel(),
                            newExpenseViewModel: newExpenseViewModel,
                            tabBarVM: tabBarVM
                        )

                    case .Wallet:
                        ExpenseListView(viewModel: newExpenseViewModel)
                       // ExpenseListView()
                    case .News:
                        Home_NewsView(tabViewModel: tabViewModel, viewModel: newsViewModel)
                    case .GPTForturn:
                        SettingListView()
                    case .greed:
                        FearGreedHomeView()
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
}



#Preview {
    ContentView()
}
