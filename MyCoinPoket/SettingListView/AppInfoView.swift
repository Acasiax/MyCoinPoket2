//
//  AppInfoView.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 10/1/24.
//

import SwiftUI

struct AppInfoView: View {
        var body: some View {
            List {
                Section(header: Text("앱 정보")) {
                    HStack {
                        Text("앱 이름")
                        Spacer()
                        Text("코인생활")
                    }
                    HStack {
                        Text("버전")
                        Spacer()
                        Text(appVersion)
                    }
                    HStack {
                        Text("저작권")
                        Spacer()
                        Text("© 2024 yunji Lee")
                    }
                }
            }
            .navigationTitle("앱 정보")
        }
        // 앱의 버전 정보 가져오기
        private var appVersion: String {
            if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                return version
            } else {
                return "정보 없음"
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
