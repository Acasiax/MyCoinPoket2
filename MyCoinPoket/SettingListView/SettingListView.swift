//
//  SettingListView.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/24/24.
//

import SwiftUI

struct SettingListView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: FearGreedHomeView()) {
                    Text("크립토 공포/탐욕 지수 확인하기")
                }
                NavigationLink(destination: ForturnView()) {
                    Text("Gpt 비트코인 주간 운세")
                }
                NavigationLink(destination: DetailView(itemName: "아이템 3")) {
                    Text("아이템 3")
                }
                NavigationLink(destination: DetailView(itemName: "아이템 4")) {
                    Text("아이템 4")
                }
                NavigationLink(destination: DetailView(itemName: "아이템 5")) {
                    Text("아이템 5")
                }
            }
            .navigationTitle("리스트 항목")
        }
    }
}


#Preview {
    SettingListView()
}


struct DetailView: View {
    var itemName: String
    
    var body: some View {
        Text("\(itemName)의 상세 화면")
            .font(.largeTitle)
            .navigationTitle(itemName)
    }
}
