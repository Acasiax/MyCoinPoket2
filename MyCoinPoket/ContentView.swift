//
//  ContentView.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/13/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var tabBarVM = TabBarViewModel()
    
    var body: some View {
        VStack {
            switch tabBarVM.currentTab {
            case .Home:
                CoinSearchView(appModel: AppViewModel())
            case .Wallet:
                CoinSearchView(appModel: AppViewModel())
            case .News:
                Home_NewsView()
            case .Person:
                CoinSearchView(appModel: AppViewModel())
            }
            
            //탭바 아래에 배치
            TabBarView(tabBarVM: tabBarVM)
        }
    }
}

#Preview {
    ContentView()
}
