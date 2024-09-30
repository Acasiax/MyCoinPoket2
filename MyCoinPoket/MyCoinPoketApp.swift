//
//  MyCoinPoketApp.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/13/24.
//

import SwiftUI

//@main
//struct MyCoinPoketApp: App {
//    
//    @AppStorage("isDarkMode") private var isDarkMode = false // 앱 전체에 다크모드 상태를 저장
//    
////    init() {
////           Thread.sleep(forTimeInterval: 1)
////       }
////    
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//                .preferredColorScheme(isDarkMode ? .dark : .light) // 다크 모드 여부에 따라 설정
//          //  Home_NewsView()
//        }
//    }
//}


@main
struct MyCoinPoketApp: App {
    
    @AppStorage("isDarkMode") private var isDarkMode = false // 앱 전체에 다크모드 상태를 저장
    
    var body: some Scene {
        WindowGroup {
            SplashScreen() // 스플래쉬 화면을 먼저 표시
                .preferredColorScheme(isDarkMode ? .dark : .light) // 다크 모드 여부에 따라 설정
        }
    }
}


struct SplashScreen: View {
    @State private var isActive = false

    var body: some View {
        if isActive {
            ContentView() // 메인 화면으로 전환
        } else {
            SplashView(isActive: $isActive) // 스플래쉬 화면 표시
        }
    }
}
