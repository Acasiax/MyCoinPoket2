//
//  SettingListView.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/24/24.
//

import SwiftUI

struct SettingListView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false // 다크모드 상태 저장
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("설정")
                    .naviTitleStyle()
                
                List {
                    NavigationLink(destination: FearGreedHomeView()) {
                        Text("크립토 공포/ 탐욕 지수 확인하기")
                    }
//                    NavigationLink(destination: ForturnView()) {
//                        Text("GPT 비트코인 주간 운세")
//                    }
//                    NavigationLink(destination: DetailView(itemName: "아이템 3")) {
//                        Text("초기화")
//                    }
                    
                    // 다크모드 토글
                    Toggle(isOn: $isDarkMode) {
                        Text("다크모드")
                    }
                }
            }
        }
    }
}

struct DetailView: View {
    var itemName: String

    var body: some View {
        Text("\(itemName)의 상세 화면")
            .font(.largeTitle)
            .navigationTitle(itemName)
    }
}

#Preview {
    SettingListView()
        .preferredColorScheme(.dark)
}
