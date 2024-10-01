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


//@main
//struct MyCoinPoketApp: App {
//    @AppStorage("isBioAuthEnabled") private var isBioAuthEnabled: Bool = true // 생체인증 상태 저장
//    @AppStorage("isDarkMode") private var isDarkMode = false // 앱 전체에 다크모드 상태를 저장
//    
//    var body: some Scene {
//        WindowGroup {
//            SplashScreen() // 스플래쉬 화면을 먼저 표시
//                .preferredColorScheme(isDarkMode ? .dark : .light) // 다크 모드 여부에 따라 설정
//        }
//    }
//}
//
//
//struct SplashScreen: View {
//    @State private var isActive = false
//
//    var body: some View {
//        if isActive {
//            ContentView() // 메인 화면으로 전환
//        } else {
//            SplashView(isActive: $isActive) // 스플래쉬 화면 표시
//        }
//    }
//}

import SwiftUI
import LocalAuthentication

@main
struct MyCoinPoketApp: App {
    @AppStorage("isBioAuthEnabled") private var isBioAuthEnabled: Bool = false // 생체인증 상태 저장
    @AppStorage("isDarkMode") private var isDarkMode = false // 앱 전체에 다크모드 상태를 저장

    var body: some Scene {
        WindowGroup {
            SplashScreen() // 스플래쉬 화면을 먼저 표시
                .preferredColorScheme(isDarkMode ? .dark : .light) // 다크 모드 여부에 따라 설정
        }
    }
}

import SwiftUI
import LocalAuthentication


struct SplashScreen: View {
    @State private var isActive = false
    @State private var isAuthAttempted = false
    @AppStorage("isBioAuthEnabled") private var isBioAuthEnabled: Bool = false // 생체인증 상태 저장
    
    var body: some View {
        if isActive {
            ContentView() // 메인 화면으로 전환
        } else {
               VStack {
                   Text("본인 인증이 필요합니다")
                       .font(.Cafe24Ohsquare)
                       .foregroundColor(.white) // 텍스트 색상 흰색으로 설정
                       .padding(.top, 50) // 상단에 배치
                       .padding()

                   Spacer() // 화면의 최상단에 텍스트를 고정하기 위해 Spacer 추가

                   Button(action: {
                       checkBioAuth() // 생체인증 시도
                   }) {
                       Text("생체인증 시작")
                           .padding()
                           .background(Color.blue)
                           .foregroundColor(.white)
                           .cornerRadius(10)
                   }

                   Spacer() // 하단 여백 추가
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.ignoresSafeArea()) // 전체 배경색을 검정색으로 설정
            .onAppear {
                // 앱이 시작될 때 생체인증 시도
                if isBioAuthEnabled && !isAuthAttempted {
                    checkBioAuth()
                } else {
                    // 생체인증이 비활성화된 경우 바로 메인 화면으로 전환
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
    
    // 생체인증 확인 함수
    func checkBioAuth() {
        let context = LAContext()
        context.localizedFallbackTitle = "암호 입력"
        context.localizedCancelTitle = "취소"
        var error: NSError?
        
        // 생체인증 가능 여부 확인
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            isAuthAttempted = true // 인증 시도 상태 설정

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "앱에 접근하려면 인증이 필요합니다.") { success, evaluateError in
                DispatchQueue.main.async {
                    if success {
                        // 생체인증 성공 시 메인 화면으로 전환
                        withAnimation {
                            isActive = true
                        }
                    } else {
                        // 생체인증 실패 시 처리 (여기서는 실패 메시지만 출력하고, 사용자가 재시도 가능)
                        if let error = evaluateError {
                            print("생체인증 실패:", error.localizedDescription)
                            
                            // 생체인증 잠금 시 패스코드 인증 시도
                            if (evaluateError as NSError?)?.code == LAError.biometryLockout.rawValue {
                                // 생체 인증이 잠겨있을 때 패스코드 인증 시도
                                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "생체 인증이 잠겼습니다. 패스코드를 입력해주세요.") { success, error in
                                    DispatchQueue.main.async {
                                        if success {
                                            // 패스코드 인증 성공 시 메인 화면으로 전환
                                            withAnimation {
                                                isActive = true
                                            }
                                        } else {
                                            // 패스코드 인증 실패 시 처리
                                            if let error = error {
                                                print("패스코드 인증 실패:", error.localizedDescription)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } else {
            // 생체인증을 사용할 수 없는 경우 바로 메인 화면으로 전환
            if let error = error {
                print("생체인증을 사용할 수 없습니다:", error.localizedDescription)
            }
            DispatchQueue.main.async {
                withAnimation {
                    isActive = true
                }
            }
        }
    }
}
