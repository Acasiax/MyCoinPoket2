//
//  FaceIDPasswordView.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 10/2/24.
//

import SwiftUI
import Security // 키체인 사용을 위한 임포트

// ViewModel for managing password operations
class PasswordViewModel: ObservableObject {
    @Published var existingPassword: String?
    
    func loadPassword() {
        existingPassword = loadPasswordFromKeychain()
    }

    private func loadPasswordFromKeychain() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "userPassword",
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var dataTypeRef: AnyObject? = nil
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        if status == errSecSuccess {
            if let passwordData = dataTypeRef as? Data,
               let password = String(data: passwordData, encoding: .utf8) {
                return password
            }
        }
        return nil
    }

    func savePassword(_ password: String) {
        let data = password.data(using: .utf8)!
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "userPassword",
            kSecValueData as String: data
        ]
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }
}



import SwiftUI

struct AlreadyPassword: View {
    @ObservedObject var viewModel: PasswordViewModel
    @Binding var showAlreadyPassword: Bool
    @State private var password: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var navigateToPasswordSetting: Bool = false
    @FocusState private var isFocused: Bool // Focus 상태 변수 추가

    var body: some View {
        NavigationStack {
            VStack {
                Text("기존의 비밀번호를 입력해주세요.")
                    .font(.system(size: 23, weight: .regular))
                    .bold()
                    .foregroundStyle(.white)
                    .padding(.bottom, 40)
                
                HStack(spacing: 20) {
                    ForEach(0..<4, id: \.self) { index in
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                            .frame(width: 20, height: 20)
                            .background(
                                Circle()
                                    .fill(index < password.count ? Color.white : Color.clear)
                                    .frame(width: 20, height: 20)
                            )
                    }
                }
                .padding(.bottom, 30)
                
                // 숨겨진 TextField를 사용하여 숫자 입력을 받음
                TextField("", text: $password)
                    .keyboardType(.numberPad)
                    .focused($isFocused)
                    .onChange(of: password) { newValue in
                        if newValue.count > 4 {
                            password = String(newValue.prefix(4))
                        }
                    }
                    .opacity(0) // 화면에 보이지 않도록 숨김 처리
                    .frame(width: 0, height: 0) // 차지하는 공간을 최소화

                Spacer()
                
                Button("확인") {
                    let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    if trimmedPassword == viewModel.existingPassword {
                        alertMessage = "비밀번호가 일치합니다."
                        showAlert = true
                    } else {
                        alertMessage = "비밀번호가 일치하지 않습니다."
                        showAlert = true
                    }
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("알림"), message: Text(alertMessage),
                          dismissButton: .default(Text("확인")) {
                              if alertMessage == "비밀번호가 일치합니다." {
                                  navigateToPasswordSetting = true
                              }
                          })
                }
                
                // PasswordSetting1으로의 네비게이션
                NavigationLink(destination: PasswordSetting1(viewModel: viewModel, showPasswordSetting: $showAlreadyPassword, showAlreadyPassword: $showAlreadyPassword), isActive: $navigateToPasswordSetting) {
                    EmptyView()
                }
                .hidden()
            }
            .padding()
            .padding(.top, 70)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color.black, ignoresSafeAreaEdges: .all)
            .onTapGesture {
                // 화면 터치 시 키보드 토글
                if isFocused {
                    isFocused = false
                } else {
                    isFocused = true
                }
            }
        }
        .onAppear {
            // 화면이 나타나면 키보드 올리기
            isFocused = true
        }
    }
}

import SwiftUI

struct PasswordSetting1: View {
    @ObservedObject var viewModel: PasswordViewModel
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var isConfirming: Bool = false
    @State private var showAlert: Bool = false
    @State private var showSuccessMessage: Bool = false
    @FocusState private var isFocused: Bool
    @Environment(\.dismiss) var dismiss // 모달 닫기 환경 변수 추가
    @Binding var showPasswordSetting: Bool // 비밀번호 설정 뷰 모달을 닫기 위한 바인딩 추가
    @Binding var showAlreadyPassword: Bool // AlreadyPassword 모달을 닫기 위한 바인딩 추가

    var body: some View {
        VStack(alignment: .center) {
            Text(isConfirming ? "비밀번호를 다시 입력해주세요." : "비밀번호를 생성해주세요.")
                .font(.system(size: 23, weight: .regular))
                .bold()
                .foregroundStyle(.white)
                .padding(.bottom, 40)

            VStack {
                // 새 비밀번호 시각적 표시
                HStack(spacing: 20) {
                    ForEach(0..<4, id: \.self) { index in
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                            .frame(width: 20, height: 20)
                            .background(
                                Circle()
                                    .fill(index < newPassword.count ? Color.white : Color.clear)
                                    .frame(width: 20, height: 20)
                            )
                    }
                }
                .padding(.bottom, 30)

                // 비밀번호 확인 시각적 표시
                if isConfirming {
                    HStack(spacing: 20) {
                        ForEach(0..<4, id: \.self) { index in
                            Circle()
                                .stroke(Color.white, lineWidth: 2)
                                .frame(width: 20, height: 20)
                                .background(
                                    Circle()
                                        .fill(index < confirmPassword.count ? Color.white : Color.clear)
                                        .frame(width: 20, height: 20)
                                )
                        }
                    }
                    .padding(.bottom, 30)
                }

                // 숨겨진 TextField로 입력 받기
                TextField("", text: isConfirming ? $confirmPassword : $newPassword)
                    .keyboardType(.numberPad)
                    .focused($isFocused)
                    .onChange(of: newPassword) { newValue in
                        if newValue.count > 4 {
                            newPassword = String(newValue.prefix(4))
                        }
                    }
                    .onChange(of: confirmPassword) { newValue in
                        if newValue.count > 4 {
                            confirmPassword = String(newValue.prefix(4))
                        }
                    }
                    .opacity(0) // 화면에 보이지 않도록 숨김 처리
                    .frame(width: 0, height: 0) // 차지하는 공간 최소화
            }

            Spacer()

            Button(isConfirming ? "저장" : "다음") {
                if isConfirming {
                    if newPassword == confirmPassword {
                        viewModel.savePassword(newPassword)
                        showSuccessMessage = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showSuccessMessage = false
                            resetInputFields()
                            dismiss() // PasswordSetting1 모달 닫기
                            showPasswordSetting = false // PasswordSetting1 모달도 닫기
                            showAlreadyPassword = false // AlreadyPassword 모달도 닫기
                        }
                    } else {
                        showAlert = true
                    }
                } else {
                    isConfirming = true
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("비밀번호 확인"), message: Text("비밀번호가 일치하지 않습니다."), dismissButton: .default(Text("확인")))
            }
            .overlay(
                Group {
                    if showSuccessMessage {
                        Text("비밀번호가 등록되었습니다.")
                            .font(.headline)
                            .padding()
                            .background(Color.green.opacity(0.8))
                            .cornerRadius(10)
                            .transition(.slide)
                    }
                }
            )
        }
        .padding()
        .padding(.top, 70)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.black, ignoresSafeAreaEdges: .all)
        .onAppear {
            // Reset fields when view appears
            resetInputFields()
        }
    }

    private func resetInputFields() {
        newPassword = ""
        confirmPassword = ""
        isConfirming = false
        isFocused = true
    }
}


//#Preview {
//    StartView()
//}
//
