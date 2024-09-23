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
    
    var body: some View {
        NavigationStack {
            VStack {
                switch tabBarVM.currentTab {
                case .Home:
                    Home_CoinSearchView(appModel: AppViewModel())
                case .Wallet:
                    ExpenseListView(newExpenseViewModel: newExpenseViewModel)
                case .News:
                    Home_NewsView()
                case .Person:
                    Home_CoinSearchView(appModel: AppViewModel())
                }
                
                // 탭바는 항상 아래에 배치
                TabBarView(tabBarVM: tabBarVM)
            }
        }
    }
}

#Preview {
    ContentView()
}
