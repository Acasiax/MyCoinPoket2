//
//  TabBarView.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/13/24.
//

import SwiftUI

struct TabBarView: View {
    @ObservedObject var tabBarVM: TabBarViewModel
    @ObservedObject var newExpenseViewModel: NewExpenseViewModel
    @Environment(\.colorScheme) var colorScheme
    @State private var isPressed: Bool = false
    @State private var navigateToAddAsset: Bool = false

    var body: some View {
        HStack(spacing: 0) {
            
            TabButton(tab: .Home, title: "홈")
            
            TabButton(tab: .Wallet, title: "지갑")
                .offset(x: -10)
            
            AddButton()
                .offset(y: -30)
            
            TabButton(tab: .News, title: "뉴스")
                .offset(x: 10)
            
            TabButton(tab: .GPTForturn, title: "설정")
        }
        .background(
            (colorScheme == .light ? Color.white : Color.clear)
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
        ZStack {
            NavigationLink(destination: Home_AddAssetView(newExpenseViewModel: newExpenseViewModel, tabBarVM: tabBarVM), isActive: $navigateToAddAsset) {
                EmptyView()
            }
            Button(action: {
                withAnimation(.spring(response: 0.18, dampingFraction: 0.8, blendDuration: 0)) {
                    isPressed = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.19) {
                    withAnimation {
                        isPressed = false
                        navigateToAddAsset = true
                    }
                }
            }) {
                Image(systemName: "plus")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: isPressed ? 22 : 26, height: isPressed ? 22 : 26) // 크기 변화
                    .foregroundColor(.white)
                    .offset(x: -1)
                    .padding(18)
                    .background(Color.blue)
                    .clipShape(Circle())
                    .shadow(color: Color.black.opacity(0.04), radius: 5, x: 5, y: 5)
                    .shadow(color: Color.black.opacity(0.04), radius: 5, x: -5, y: -5)
            }
            .scaleEffect(isPressed ? 0.9 : 1.0) // 애니메이션으로 살짝 작아졌다가 커짐
        }
    }
}

