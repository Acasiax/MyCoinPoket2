//
//  SettingListView.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/24/24.
//

//import SwiftUI
//
//struct SettingListView: View {
//    @AppStorage("isDarkMode") private var isDarkMode = false // 다크모드 상태 저장
//    
//    var body: some View {
//        NavigationStack {
//            VStack(alignment: .leading) {
//                Text("설정")
//                    .naviTitleStyle()
//                
//                List {
//                    NavigationLink(destination: FearGreedHomeView()) {
//                        Text("크립토 공포/ 탐욕 지수 확인하기")
//                    }
//                    //                    NavigationLink(destination: ForturnView()) {
//                    //                        Text("GPT 비트코인 주간 운세")
//                    //                    }
//                    //                    NavigationLink(destination: DetailView(itemName: "아이템 3")) {
//                    //                        Text("초기화")
//                    //                    }
//                    
//                  
//                    
//                    
//                    // 다크모드 토글
//                    Toggle(isOn: $isDarkMode) {
//                        Text("다크모드")
//                    }
//                    
//             
//                        Section(header: Text("정보")) {
//                            ShareLink(item: URL(string: "https://yourappurl.com")!) {
//                                Text("친구에게 추천하기")
//                            }
//                            Button(action: {
//                                // 리뷰 작성하기 기능 구현
//                            }) {
//                                Text("리뷰 작성하기")
//                            }
//                            
//                            Button(action: {
//                                // 문의하기 기능 구현
//                            }) {
//                                Text("문의하기")
//                            }
//                            
//                            NavigationLink(destination: AppInfoView()) {
//                                Text("앱 정보")
//                            }
//                        }
//                        
//                    }
//                }
//            }
//        }
//    
//    


import SwiftUI
import LocalAuthentication

struct SettingListView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false // 다크모드 상태 저장
    @AppStorage("isBioAuthEnabled") private var isBioAuthEnabled: Bool = false // 생체인증 상태 저장
    @AppStorage("isAuthAttempted") private var isAuthAttempted: Bool = false // 생체인증 시도 상태 저장 (앱 재실행 시에도 유지)
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("설정")
                    .naviTitleStyle()
                
                List {
                    NavigationLink(destination: FearGreedHomeView()) {
                        Text("크립토 공포/ 탐욕 지수 확인하기")
                    }
                    
                    // 다크모드 토글
                    Toggle(isOn: $isDarkMode) {
                        Text("다크모드")
                    }
                    
                    // 생체인증 토글
                    Toggle(isOn: $isBioAuthEnabled) {
                        Text("생체인증 사용")
                    }
                    .onChange(of: isBioAuthEnabled) { newValue in
                        if newValue && !isAuthAttempted {
                            // 생체인증 켤 때 인증 시도
                            checkBioAuth()
                        } else if !newValue {
                            // 생체인증 끌 때 바로 false로 설정
                            isBioAuthEnabled = false
                        }
                    }
                    
                    Section(header: Text("정보")) {
                        ShareLink(item: URL(string: "https://yourappurl.com")!) {
                            Text("친구에게 추천하기")
                        }
                        Button(action: {
                            // 리뷰 작성하기 기능 구현
                        }) {
                            Text("리뷰 작성하기")
                        }
                        
                        Button(action: {
                            // 문의하기 기능 구현
                        }) {
                            Text("문의하기")
                        }
                        
                        NavigationLink(destination: AppInfoView()) {
                            Text("앱 정보")
                        }
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
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            // 생체인증이 지원되지 않는 경우 처리
            isBioAuthEnabled = false
            return
        }
        
        isAuthAttempted = true // 인증 시도 상태 설정
        
        Task {
            do {
                try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "보안을 위한 본인 인증이 필요합니다.")
                // 인증 성공 시 토글 유지
                DispatchQueue.main.async {
                    isAuthAttempted = false // 성공 후 인증 시도 상태 해제
                }
            } catch {
                // 인증 실패 시 토글 해제
                DispatchQueue.main.async {
                    isBioAuthEnabled = false
                    isAuthAttempted = false // 실패 후 인증 시도 상태 해제
                }
                print("인증 실패:", error.localizedDescription)
            }
        }
    }
}





//#Preview {
//    SettingListView()
//        .preferredColorScheme(.dark)
//}
