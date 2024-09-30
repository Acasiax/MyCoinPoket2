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
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 15) {
                BottomContent()
                    .padding(.top)
                
            }
            
            .padding(.top, 30)
        }
        .padding(.horizontal, 10)
        .background(Color.white)
        .cornerRadius(10)
        .ignoresSafeArea(edges: .all)
        .frame(maxWidth: UIScreen.main.bounds.width - 40) // 화면 너비에서 좌우 여백
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
                    .foregroundColor(.black)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(indexItem.title)
                        .fontWeight(.bold)
                    Text(indexItem.subTitle)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(indexItem.amount)
                    .fontWeight(.bold)
                
            }
            //  .padding()
            //  .background(Color(CustomColors.lightnavy))
            .cornerRadius(10)
            .onTapGesture {
                // 선택한 공포지수 값으로 currentIndex 업데이트
                if let selectedIndex = viewModel.indexItem.firstIndex(where: { $0.id == indexItem.id }) {
                    let fearGreedIndices = [viewModel.currentIndex, viewModel.yesterdayIndex, viewModel.lastWeekIndex, viewModel.lastMonthIndex]
                    // 다른 행을 눌렀을 때도 정상적으로 값을 업데이트
                    if let fearGreedIndex = fearGreedIndices[selectedIndex] {
                        viewModel.currentIndex = fearGreedIndex
                        
                        // 선택된 인덱스 타입 업데이트
                        switch selectedIndex {
                        case 0:
                            viewModel.selectedIndexType = "현재"
                        case 1:
                            viewModel.selectedIndexType = "어제"
                        case 2:
                            viewModel.selectedIndexType = "지난주"
                        case 3:
                            viewModel.selectedIndexType = "29일 전"
                        default:
                            viewModel.selectedIndexType = "현재"
                        }
                        
                        // 프로그레스바 업데이트
                        withAnimation(.easeInOut(duration: 1.5)) {
                            progress = CGFloat(Double(fearGreedIndex.value) ?? 0) / 100
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

