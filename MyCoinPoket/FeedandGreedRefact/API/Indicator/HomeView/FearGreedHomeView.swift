//
//  FearGreedHomeView.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/24/24.
//

import SwiftUI

struct FearGreedHomeView: View {
    
    @StateObject var viewModel = FearGreedViewModel()
    @State var progress: CGFloat = 0.5
    @Namespace var animation
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 0) {
            // Header 및 Card를 포함한 뷰
            FearGreedDisplayCard(viewModel: viewModel, progress: $progress)
                .frame(maxWidth: .infinity, alignment: .top)
            
            // 스크롤 가능한 공포 지수 항목
            FearGredIndexItemScroll(viewModel: viewModel, progress: $progress)
                .padding(.horizontal, -40)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(
            ZStack{
                LinearGradient(
                    colors: [Color("BG1"), Color("BG2")],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            }
        )
//        .background(
//            ZStack {
//                Color(CustomColors.lightGray)
//                    .ignoresSafeArea()
//                
//                LinearGradient(colors: gradientColors(for: colorScheme),
//                               startPoint: .topLeading,
//                               endPoint: .topTrailing
//                )
//                .ignoresSafeArea(edges: .top)
//            }
//        )
    }
    
    // 선택된 공포 및 탐욕 지수에 따라 그라데이션 색상 반환 (다크모드 대응)
    private func gradientColors(for colorScheme: ColorScheme) -> [Color] {
        let isDarkMode = colorScheme == .dark
        if let currentValue = viewModel.currentIndex?.value,
           let value = Double(currentValue) {
            switch value {
            case 0..<30:
                return isDarkMode ?
                    [Color.pink.opacity(0.7), Color.pink.opacity(0.5), Color.pink.opacity(0.3)] :
                    [Color.pink.opacity(0.4), Color.pink.opacity(0.2), Color.pink.opacity(0.1)]
            case 30..<60:
                return isDarkMode ?
                    [Color.orange.opacity(0.7), Color.orange.opacity(0.5), Color.orange.opacity(0.3)] :
                    [Color.orange.opacity(0.4), Color.orange.opacity(0.2), Color.orange.opacity(0.1)]
            case 60...100:
                return isDarkMode ?
                    [Color.green.opacity(0.7), Color.green.opacity(0.5), Color.green.opacity(0.3)] :
                    [Color.green.opacity(0.4), Color.green.opacity(0.2), Color.green.opacity(0.1)]
            default:
                return isDarkMode ?
                    [Color.blue.opacity(0.7), Color.blue.opacity(0.5), Color.blue.opacity(0.3)] :
                    [Color.blue.opacity(0.4), Color.blue.opacity(0.2), Color.blue.opacity(0.1)]
            }
        } else {
            return isDarkMode ?
                [Color.blue.opacity(0.7), Color.blue.opacity(0.5), Color.blue.opacity(0.3)] :
                [Color.blue.opacity(0.4), Color.blue.opacity(0.2), Color.blue.opacity(0.1)]
        }
    }
}

#Preview {
    FearGreedHomeView()
}
