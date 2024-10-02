//
//  SettingListView.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/24/24.
//


import SwiftUI
import LocalAuthentication

struct SettingListView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false // 다크모드 상태 저장
    @AppStorage("isBioAuthEnabled") private var isBioAuthEnabled: Bool = false // 생체인증 상태 저장
    @AppStorage("isAuthAttempted") private var isAuthAttempted: Bool = false // 생체인증 시도 상태 저장 (앱 재실행 시에도 유지)
    @State private var isPasswordSetupViewPresented = false // 비밀번호 설정 뷰 띄우기
    
    @StateObject private var viewModel = PasswordViewModel()
    @State private var showPasswordSetting = false
    @State private var showAlreadyPassword = false
    @State private var buttonText: String = "비밀번호 기본초기"
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("설정")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
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
                        ShareLink(item: URL(string: "https://apps.apple.com/kr/app/%EA%B0%80%EC%83%81%EC%9E%90%EC%82%B0-%EC%BD%94%EC%9D%B8-%ED%8F%AC%ED%8A%B8%ED%8F%B4%EB%A6%AC%EC%98%A4-%EC%95%B1-%EC%BD%94%EC%9D%B8%EC%83%9D%ED%99%9C/id6720724248")!) {
                            
                            Text("친구에게 추천하기")
                        }
//                        Button(action: {
//                            // 리뷰 작성하기 기능 구현
//                        }) {
//                            Text("리뷰 작성하기")
//                        }
//                        
//                        Button(action: {
//                            // 문의하기 기능 구현
//                        }) {
//                            Text("문의하기")
//                        }
//                        
                        NavigationLink(destination: AppInfoView()) {
                            Text("앱 정보")
                        }
                    }
                }
                .onAppear {
                    viewModel.loadPassword()
                    // 키체인에 비밀번호가 있는지 확인
                    if let existingPassword = viewModel.existingPassword {
                        print("키체인 비번:\(existingPassword)") // 키체인 비밀번호 출력
                    }
                    buttonText = viewModel.existingPassword != nil ? "기존 비밀번호가 있네요" : "비밀번호 신규 생성"
                }
                .sheet(isPresented: $showPasswordSetting) {
                    PasswordSetting1(viewModel: viewModel, showPasswordSetting: $showPasswordSetting, showAlreadyPassword: $showAlreadyPassword) // 비밀번호 설정 뷰 모달
                }
                .sheet(isPresented: $showAlreadyPassword) {
                    AlreadyPassword(viewModel: viewModel, showAlreadyPassword: $showAlreadyPassword) // 기존 비밀번호 입력 뷰 모달
                }
            }
        }
        .background(Color.clear.ignoresSafeArea()) // 배경 검정색
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
                // 인증 성공 시 비밀번호 설정 또는 기존 비밀번호 입력 뷰로 이동
                DispatchQueue.main.async {
                    isAuthAttempted = false // 성공 후 인증 시도 상태 해제
                    if viewModel.existingPassword != nil {
                        showAlreadyPassword = true // 기존 비밀번호 입력 뷰 모달 표시
                    } else {
                        showPasswordSetting = true // 비밀번호 설정 뷰 모달 표시
                    }
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
