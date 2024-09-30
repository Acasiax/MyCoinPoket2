//
//  SplashView.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/30/24.
//

import SwiftUI

struct SplashView: View {
    @State private var imageOffset: CGFloat = 10
    @State private var isImageVisible = false
    @State private var isFirstTextVisible = false
    @State private var isSecondTextVisible = false
    @Binding var isActive: Bool // SplashScreen에서 상태 관리

    var body: some View {
        ZStack {
            Color.blue
                .edgesIgnoringSafeArea(.all)

            VStack {

                Image("바른생활런치스크린300")
                    .resizable()
                    .frame(width: 140, height: 140)
                    .offset(y: isImageVisible ? 0 : 50) // 위로 올라오는 애니메이션을 위해 초기값 설정
                    .opacity(isImageVisible ? 1 : 0) // 점차 나타나게 설정
                    .animation(
                        Animation.easeOut(duration: 1)
                            .delay(0.5),
                        value: isImageVisible
                    )

                if isFirstTextVisible {
                    Text("코인 포트폴리오 앱은?")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .animation(
                            Animation.easeInOut(duration: 1)
                                .delay(1.5),
                            value: isFirstTextVisible
                        )
                }

                if isSecondTextVisible {
                    Text("바른 코인 생활")
                        .font(.Cafe24Ohsquare)
                        .bold()
                        .foregroundColor(.white)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .animation(
                            Animation.easeInOut(duration: 1)
                                .delay(3),
                            value: isSecondTextVisible
                        )
                }
            }
            .offset(y: -100)
        }
        .onAppear {
            // 이미지 애니메이션 시작
            withAnimation {
                isImageVisible = true
            }

            // 첫 번째 텍스트 애니메이션 시작
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation {
                    isFirstTextVisible = true
                }
            }

            // 첫 번째 텍스트 사라지고 두 번째 텍스트 나타남
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    isFirstTextVisible = false
                    isSecondTextVisible = true
                }

                // 스플래시 애니메이션이 끝나면 메인 화면으로 전환
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashView(isActive: .constant(false))
    }
}
