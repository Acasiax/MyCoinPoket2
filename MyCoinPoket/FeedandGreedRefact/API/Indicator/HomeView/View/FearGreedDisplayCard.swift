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
            Text("현재 크립토 공포 지수")
                .fontWeight(.heavy)
                .foregroundStyle(Color(CustomColors.darkBlue))
                .font(.title3)
                .padding(8)
                .background{
                    Color.blue.opacity(0.2)
                }.cornerRadius(10)
            
            
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
                    .foregroundColor(.black)
                    .padding(.top, 5)
            } else {
                Text("Loading data...")
                    .onAppear {
                        viewModel.fetchFearGreedIndex()
                    }
            }
            
        }
        .padding(.top, 50)
        .frame(maxWidth: .infinity)
//        .frame(height: 340)

        .padding(.top, 15)
        .padding(.horizontal, 15)
    }
}


#Preview {
    FearGreedHomeView()
}


