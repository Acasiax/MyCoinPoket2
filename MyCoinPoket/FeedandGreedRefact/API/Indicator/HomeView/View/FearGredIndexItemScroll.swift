//
//  FearGredIndexItemScroll.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/24/24.
//

import SwiftUI

struct FearGredIndexItemScroll: View {
    
    @ObservedObject var viewModel: FearGreedViewModel
    @Binding var progress: CGFloat
    
    var body: some View {
        ZStack {
            // 배경에 그라데이션 추가
            Color.clear
            .ignoresSafeArea()

            // 유리효과의 검정색 배경 레이어
            GeometryReader { proxy in
                let size = proxy.size

                Color.black
                    .opacity(0.7)
                    .blur(radius: 200)
                    .ignoresSafeArea()
            }

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 15) {
                    BottomContent()
                        .padding(.top)
                }
                .padding(.top, 30)
            }
            .padding(.horizontal, 10)
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
            .cornerRadius(25)
            .frame(maxWidth: UIScreen.main.bounds.width - 40) // 화면 너비에서 좌우 여백
            .foregroundColor(.white)
        }
    }
}


extension FearGredIndexItemScroll {
    @ViewBuilder
    func BottomContent() -> some View {
        ForEach(viewModel.indexItem) { indexItem in
            HStack(spacing: 12) {
                Image(systemName: indexItem.icon)
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 35, height: 35)
                    .foregroundStyle(Color.white)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(indexItem.title)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.white)
                    
                    Text(indexItem.subTitle)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(indexItem.amount)
                    .fontWeight(.bold)
                    .foregroundStyle(Color("LightGreen"))
                  
            }
            .cornerRadius(10)
            .onTapGesture {
                // 선택한 공포지수 값으로 currentIndex 업데이트
                if let selectedIndex = viewModel.indexItem.firstIndex(where: { $0.id == indexItem.id }) {
                    let fearGreedIndices = [viewModel.currentIndex, viewModel.yesterdayIndex, viewModel.lastWeekIndex, viewModel.lastMonthIndex]
                    
                    if let fearGreedIndex = fearGreedIndices[selectedIndex] {
                        if viewModel.currentIndex?.value != fearGreedIndex.value {
                            // 다른 인덱스를 눌렀을 때 정상적으로 업데이트
                            viewModel.currentIndex = fearGreedIndex
                            
                            // 프로그레스바 업데이트
                            withAnimation(.easeInOut(duration: 1.5)) {
                                progress = CGFloat(Double(fearGreedIndex.value) ?? 0) / 100
                            }
                        } else {
                            // 동일한 인덱스를 클릭했을 때 currentIndex를 nil로 설정한 후에 다시 설정하는 트릭
                            viewModel.currentIndex = nil
                            progress = 0
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                viewModel.currentIndex = fearGreedIndex
                                withAnimation(.easeInOut(duration: 1.5)) {
                                    progress = CGFloat(Double(fearGreedIndex.value) ?? 0) / 100
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    FearGreedHomeView()
}
