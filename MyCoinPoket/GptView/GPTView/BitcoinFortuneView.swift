//
//  BitcoinFortuneView.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/24/24.
//

import SwiftUI

struct BitcoinFortuneView: View {
    @State private var showFortune = false
    
    var body: some View {
        ZStack {
            // 배경에 비트코인 심볼과 네온 장식
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.gray.opacity(0.7)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            // 배경에 흐릿한 비트코인 아이콘 (현재는 정적)
            VStack {
                Spacer()
                Image(systemName: "bitcoinsign.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(Color.yellow.opacity(0.5))
                    .blur(radius: 5)
                    .offset(x: -100, y: -150)
                Spacer()
            }
            
            VStack {
                // "비트코인 운세 확인" 버튼
                Button(action: {
                    withAnimation {
                        showFortune.toggle()
                    }
                }) {
                    Text("비트코인 운세 확인")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .top, endPoint: .bottom))
                                .shadow(radius: 10)
                        )
                        .padding()
                }
                .padding(.bottom, 40)
                
                Spacer()
            }
            
            // 운세 카드 모달
            if showFortune {
                VStack {
                    Spacer()
                    VStack {
                        Text("이번 주, 비트코인의 운명이 당신에게 미소 짓고 있습니다!")
                            .font(.title2)
                            .multilineTextAlignment(.center)
                            .padding()
                        HStack(spacing: 20) {
                            Image(systemName: "bitcoinsign.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.yellow)
                            Image(systemName: "star.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.yellow)
                        }
                        .padding(.bottom, 20)
                        
                        // 닫기 버튼
                        Button(action: {
                            withAnimation {
                                showFortune.toggle()
                            }
                        }) {
                            Text("닫기")
                                .font(.headline)
                                .foregroundColor(.blue)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.red)
                                )
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .cornerRadius(25)
                    .shadow(radius: 20)
                    .padding()
                }
                .transition(.move(edge: .bottom))
            }
        }
    }
}

struct BitcoinFortuneView_Previews: PreviewProvider {
    static var previews: some View {
        BitcoinFortuneView()
    }
}

