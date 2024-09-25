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
    
    var body: some View {
        VStack(spacing: 0) {
     //       ZStack(alignment: .top) {
//                HomeHeaderView()
//                    .frame(maxWidth: .infinity, alignment: .top)
                
                FearGreedDisplayCard(viewModel: viewModel, progress: $progress)
                    .frame(maxWidth: .infinity, alignment: .top)
     //       }
            
            FearGredIndexItemScroll(viewModel: viewModel, progress: $progress)
                .padding(.horizontal, -40)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(
            ZStack {
                Color(CustomColors.lightGray)
                    .ignoresSafeArea()
                
                LinearGradient(colors: [
                    Color.blue.opacity(0.4),
                    Color.blue.opacity(0.2),
                    Color.blue.opacity(0.1),
                ] + Array(repeating: Color.clear, count: 5),
                startPoint: .topTrailing,
                endPoint: .bottomLeading
                )
                .ignoresSafeArea(edges: .top)
            }
        )
    }
}


#Preview {
    FearGreedHomeView()
}

