//
//  FearGreedDisplayCard.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/24/24.
//

import SwiftUI

struct FearGreedDisplayCard: View {
    
    @ObservedObject var viewModel = FearGreedViewModel()
    @Binding var progress: CGFloat
    
    var body: some View {
        VStack{
            Text("\(viewModel.selectedIndexType) 크립토 공포 지수")
                .fontWeight(.heavy)
                .foregroundStyle(Color.white)
                .font(.title3)
                .padding(.horizontal)
                .padding(.vertical)
//                .background{
//                    Color.blue.opacity(0.2)
//                }
                
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.white)
                            .opacity(0.1)
                            .background(
                                Color.white
                                    .opacity(0.08)
                                    .blur(radius: 10)
                            )
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(
                                        LinearGradient(gradient: Gradient(colors: [
                                            Color("Purple"),
                                            Color("Purple").opacity(0.5),
                                            .clear,
                                            .clear,
                                            Color("LightBlue")
                                        ]), startPoint: .topLeading, endPoint: .bottomTrailing),
                                        lineWidth: 2.5
                                    )
                                    .padding(2)
                            )
                            .shadow(color: .black.opacity(0.1), radius: 5, x: -5, y: -5)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
                    }
                )
              //  .cornerRadius(10)
            
            
            if let index = viewModel.currentIndex {
                
               // let currentValue = CGFloat(90)
                let currentValue = CGFloat(Double(index.value) ?? 0)
              
                AnimatedNumberText(value: currentValue, font: .system(size: 35, weight: .black))
                    .foregroundColor(getColor(for: CGFloat(Double(index.value) ?? 0)))
                    .padding(.top, 5)
                    .padding(.bottom, 150)
                    .lineLimit(1)
               
               
                SpeedoMeter(progress: $progress, color: getColor(for: currentValue))
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1.5)) {
                            progress = currentValue / 100
                        }
                    }
                    
                
                Text("날짜: \(Date.formatTimestamp(index.timestamp))")
                    .font(.caption)
                    .foregroundStyle(.lightGreen)
                    .padding(.top, 5)
                    .padding(.bottom, 5)
            } else {
                Text("Loading data...")
                    .onAppear {
                        viewModel.fetchFearGreedIndex()
                    }
            }
            
        }
        .padding(.top, 15)  // 중복된 top padding 제거
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 15)
    }
}


#Preview {
    FearGreedHomeView()
}


