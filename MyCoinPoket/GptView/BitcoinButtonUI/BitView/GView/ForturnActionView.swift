//
//  ForturnActionView.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/24/24.
//

import SwiftUI

struct ForturnActionView: View {
    
    // 부모 뷰에서 전달받을 상태 변수들
      @Binding var rotationAngle: Double
      @Binding var statusText: String
      
      var startProcess: () -> Void // 프로세스를 시작하는 액션 전달
      
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
            VStack {
                // 버튼: 비트코인 이미지 및 상태 텍스트
                Button(action: {
                    startProcess() // 프로세스 시작
                }, label: {
                    VStack(spacing: 15) {
                        Image("Bitcoin_3D") // 비트코인 이미지
                            .resizable()
                            .frame(width: 100, height: 100)
                        
                        // 상태 텍스트
                        Text(statusText)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding(50)
                    .clipShape(Circle()) // 원형 버튼 모양
                    .padding(15)
                    .background(
                        ZStack {
                            // 회전 효과가 적용된 외곽 원
                            Circle()
                                .stroke(lineWidth: 10)
                                .fill(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple, Color.red, Color.mint, Color.indigo, Color.pink, Color.blue]), startPoint: .top, endPoint: .bottom))
                                .blur(radius: 10)
                                .opacity(0.3)
                                .rotationEffect(.degrees(rotationAngle)) // 회전 효과 적용
                                .onAppear {
                                    withAnimation(Animation.linear(duration: 5).repeatForever(autoreverses: false)) {
                                        rotationAngle = 360 // 360도 회전 애니메이션
                                    }
                                }
                            
                            // 두 번째 외곽 원
                            Circle()
                                .stroke(lineWidth: 5)
                                .fill(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple, Color.red, Color.mint, Color.indigo, Color.pink, Color.blue]), startPoint: .top, endPoint: .bottom))
                                .blur(radius: 20)
                        }
                    )
                    .clipShape(Circle())
                    .padding(15)
                    .background(
                        ZStack {
                            // 세 번째 외곽 원
                            Circle()
                                .stroke(lineWidth: 10)
                                .fill(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple, Color.red, Color.mint, Color.indigo, Color.pink, Color.blue]), startPoint: .top, endPoint: .bottom))
                                .blur(radius: 10)
                                .opacity(0.8)
                            
                            // 네 번째 외곽 원
                            Circle()
                            
                                .stroke(lineWidth: 5)
                                .fill(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple, Color.red, Color.mint, Color.indigo, Color.pink, Color.blue]), startPoint: .top, endPoint: .bottom))
                                .blur(radius: 20)
                                .rotationEffect(.degrees(rotationAngle)) // 회전 효과 적용
                                .onAppear {
                                    withAnimation(Animation.linear(duration: 5).repeatForever(autoreverses: false)) {
                                        rotationAngle = 360 // 360도 회전 애니메이션
                                    }
                                }
                        }
                    )
                    .clipShape(Circle())
                    
                })
                .offset(y: -65)
                .padding(.bottom, -65)
                
                Spacer()
              
                // 하단 버튼: 비트코인 시세 확인 버튼
                Button {
                    startProcess() // 클릭 시 프로세스 시작
                } label: {
                    Text("비트코인 시세 확인하기")
                        .foregroundStyle(.white)
                }
                .padding()
                
                Spacer()
            }
        }
    }
}


