//
//  MyCoinPoketApp.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/13/24.
//

import SwiftUI
import LocalAuthentication

@main
struct MyCoinPoketApp: App {
    @AppStorage("isBioAuthEnabled") private var isBioAuthEnabled: Bool = false // 생체인증 상태 저장
    @AppStorage("isDarkMode") private var isDarkMode = false // 앱 전체에 다크모드 상태를 저장
    
    @State private var isSplashActive: Bool = false // 스플래시 화면 전환 상태

    var body: some Scene {
         WindowGroup {
             if isSplashActive {
                 IntoMainScreen() // 스플래시 이후의 화면
                     .preferredColorScheme(isDarkMode ? .dark : .light)
             } else {
                 SplashView(isActive: $isSplashActive) // 스플래쉬 화면 표시
                     .preferredColorScheme(isDarkMode ? .dark : .light)
             }
         }
     }
 }

import SwiftUI
import LocalAuthentication

struct IntoMainScreen: View {
    @State private var isActive = false
    @State private var isAuthAttempted = false
    @AppStorage("isBioAuthEnabled") private var isBioAuthEnabled: Bool = false // 생체인증 상태 저장
    @StateObject private var passwordViewModel = PasswordViewModel() // 비밀번호 관리 뷰 모델
    @State private var showPasswordSheet = false // 비밀번호 입력 창 표시 여부
    @State private var enteredPassword = "" // 사용자가 입력한 비밀번호
    @State private var alertMessage = "" // 얼럿 메시지 내용
    @State private var showAlert = false // 잘못된 비밀번호 입력 시 표시될 얼럿 여부

    var body: some View {
        if isActive {
            ContentView() // 메인 화면으로 전환
        } else {
            VStack {
                Text("본인 인증이 필요합니다")
                    .font(.Cafe24Ohsquare(size: 27))
                    .bold()
                    .foregroundColor(.white)
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
            .sheet(isPresented: $showPasswordSheet) {
                PasswordInputView(passwordViewModel: passwordViewModel, enteredPassword: $enteredPassword, onPasswordCorrect: {
                    withAnimation {
                        isActive = true // 비밀번호가 올바르면 메인 화면으로 전환
                    }
                })
                .presentationDetents([.fraction(0.4), .large]) // 높이를 화면의 40%와 전체 중 선택 가능하게 설정
                .presentationDragIndicator(.visible) // 드래그 인디케이터를 보여줌
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("오류"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("확인"))
                )
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
                        // 생체인증 실패 시 비밀번호 입력 창 표시
                        if let error = evaluateError {
                            print("생체인증 실패:", error.localizedDescription)
                            showPasswordSheet = true
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
                    showPasswordSheet = true
                }
            }
        }
    }
}

struct PasswordInputView: View {
    @ObservedObject var passwordViewModel: PasswordViewModel
    @Binding var enteredPassword: String
    var onPasswordCorrect: () -> Void
    @Environment(\.dismiss) var dismiss // 모달을 닫기 위한 환경 변수
    @State private var showAlert = false // 잘못된 비밀번호 입력 시 표시될 얼럿 여부
    @State private var isKeyboardVisible = false // 키보드가 보이는지 여부

    var body: some View {
        VStack {
            Text("비밀번호를 입력해주세요.")
                .font(.Cafe24Ohsquare(size: 26))
                .bold()
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .foregroundStyle(.white)
                .padding()

            SecureField("비밀번호", text: $enteredPassword)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .onTapGesture {
                                    isKeyboardVisible = true // 키보드가 올라오면 상태를 true로 설정
                                }
            

            Button(action: {
                            if enteredPassword == passwordViewModel.existingPassword {
                                onPasswordCorrect()
                                dismiss() // 모달 닫기
                            } else {
                                // 비밀번호가 틀리면 얼럿 표시
                                enteredPassword = ""
                                showAlert = true
                            }
                        }) {
                            Text("확인")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding()
                        .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("오류"),
                                message: Text("잘못된 비밀번호입니다. 다시 시도해주세요."),
                                dismissButton: .default(Text("확인"))
                            )
                        }

            .onAppear {
                passwordViewModel.loadPassword()
                // 키체인에 비밀번호가 있는지 확인
                if let existingPassword = passwordViewModel.existingPassword {
                    print("키체인 비번:\(existingPassword)") // 키체인 비밀번호 출력
                }
            }
            .padding()
        }
        .padding()
        .padding(.top, 70)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.black.opacity(0.5).ignoresSafeArea())
        .onTapGesture {
                    hideKeyboard()
                    isKeyboardVisible = false
                }
        .onAppear {
            passwordViewModel.loadPassword()
            // 키체인에 비밀번호가 있는지 확인
            if let existingPassword = passwordViewModel.existingPassword {
                print("키체인 비번:\(existingPassword)") // 키체인 비밀번호 출력
            }
        }
    }
}

extension PasswordInputView {
    private func hideKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
}
