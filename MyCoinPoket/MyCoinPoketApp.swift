//
//  MyCoinPoketApp.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/13/24.
//

import SwiftUI

@main
struct MyCoinPoketApp: App {
    
    @AppStorage("isDarkMode") private var isDarkMode = false // 앱 전체에 다크모드 상태를 저장
    
//    init() {
//           Thread.sleep(forTimeInterval: 5)
//       }
//    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(isDarkMode ? .dark : .light) // 다크 모드 여부에 따라 설정
          //  Home_NewsView()
        }
    }
}


