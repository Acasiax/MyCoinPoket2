//
//  ForturnView.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/24/24.
//

import SwiftUI

struct ForturnView: View {
    
    // 그라디언트 색상 배열 정의
    var gradient1 = [Color("gradient2"), Color("gradient3"), Color("gradient4")]
    var gradient = [Color("gradient1"), Color("gradient2"), Color("gradient3"), Color("gradient4")]
    
    @StateObject var serverData = ServerViewModel() // 서버 데이터 관리를 위한 StateObject
    @State private var navigateToDetail = false // 상세 화면으로의 네비게이션 상태 관리
    @State private var rotationAngle: Double = 0 // 회전 각도 상태 변수
    @State private var statusText = "Try ChatGPT" // 초기 상태 텍스트
    @State private var isProcessing = false // 처리 중인지 여부를 추적하는 상태 변수
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                VStack {
                    ForturnHeaderView(serverData: serverData)
                    .frame(height: UIScreen.main.bounds.height / 3.3)
                    
                    ForturnActionView(rotationAngle: $rotationAngle, statusText: $statusText, startProcess: startProcess)
                    .padding(.top, 60)
                }
                
                // 네비게이션 링크
                NavigationLink(destination: Home_GPTView(), isActive: $navigateToDetail) {
                    EmptyView()
                }
                .hidden()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                ZStack {
                    Color.black // 배경색 설정
                        .ignoresSafeArea(.all)
                }
            )
            .onAppear {
                resetStates() // 화면이 나타날 때 상태 초기화
            }
        }
    }
    
    // 상태 텍스트를 순차적으로 변경하는 함수
    private func startProcess() {
        isProcessing = true
        statusText = "Try ChatGPT"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            statusText = "주간 데이터 전송중.."
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                statusText = "응답 확인중.."
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    navigateToDetail = true // 모든 텍스트 변경 후 네비게이션
                    isProcessing = false
                }
            }
        }
    }
    
    // 뒤로 이동 시 상태를 초기화하는 함수
    private func resetStates() {
        serverData.isConnected = false
        statusText = "Try ChatGPT"
        rotationAngle = 0 // 회전 각도 초기화
    }
}








#Preview {
    ForturnView()
}






