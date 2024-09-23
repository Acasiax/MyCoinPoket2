//
//  TabBarView.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/13/24.
//

import SwiftUI

struct TabBarView: View {
    @ObservedObject var tabBarVM: TabBarViewModel
    @ObservedObject var newExpenseViewModel : NewExpenseViewModel
    
    var body: some View {
        HStack(spacing: 0) {
            
            TabButton(tab: .Home, title: "홈")
            
            TabButton(tab: .Wallet, title: "지갑")
                .offset(x: -10)
            
            AddButton()
                .offset(y: -30)
            
            TabButton(tab: .News, title: "뉴스")
                .offset(x: 10)
            
            TabButton(tab: .Person, title: "프로필")
        }
        
        .background(
            Color.white
                .clipShape(CustomCurveShape())
                .shadow(color: Color.black.opacity(0.06), radius: 5, x: -5, y: -5)
                .ignoresSafeArea(.container, edges: .bottom)
        )
    }
}





extension TabBarView {
    
    @ViewBuilder
    func TabButton(tab: MainTab, title: String) -> some View {
        Button(action: {
            withAnimation {
                tabBarVM.currentTab = tab
            }
        }) {
            VStack {
                Image(systemName: tab.rawValue)
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                    .foregroundColor(tabBarVM.currentTab == tab ? Color.blue : Color.gray.opacity(0.5))
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(tabBarVM.currentTab == tab ? Color.blue : Color.gray.opacity(0.5))
            }
            .frame(maxWidth: .infinity)
        }
    }
    
   
    @ViewBuilder
       func AddButton() -> some View {
           // Home_AddAssetView로 이동하는 네비게이션 링크 추가
           NavigationLink(destination: Home_AddAssetView(newExpenseViewModel: newExpenseViewModel, tabBarVM: tabBarVM)) {
               Image(systemName: "plus")
                   .resizable()
                   .renderingMode(.template)
                   .aspectRatio(contentMode: .fit)
                   .frame(width: 26, height: 26)
                   .foregroundColor(.white)
                   .offset(x: -1)
                   .padding(18)
                   .background(Color.blue)
                   .clipShape(Circle())
                   .shadow(color: Color.black.opacity(0.04), radius: 5, x: 5, y: 5)
                   .shadow(color: Color.black.opacity(0.04), radius: 5, x: -5, y: -5)
           }
       }
   }




#Preview {
    ContentView()
}

