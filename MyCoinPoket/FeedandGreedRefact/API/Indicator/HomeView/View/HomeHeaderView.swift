//
//  HomeHeaderView.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/24/24.
//

import SwiftUI

struct HomeHeaderView: View {
    var body: some View {
        VStack(spacing: 15){
            HStack{
                Button(action: {}, label: {
                   Image(systemName: "arrow.left")
                        .frame(width: 40, height: 40)
                        .background{
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke(.gray.opacity(0.4), lineWidth: 4)
                        }
                })
                Spacer()
                Button(action: {}, label: {
                    Image(systemName: "ellipsis")
                        .font(.title3)
                        .rotationEffect(.init(degrees: -90))
                })
            }
            .foregroundColor(.gray)
            .padding(.horizontal)
            
        }
       
    }
}


#Preview {
   FearGreedHomeView()
}

