//
//  IndicatorShapeStyleModifier.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/24/24.
//

import SwiftUI

struct IndicatorShapeStyleModifier: ViewModifier {
   
  @Binding var progress: CGFloat
   var color: Color
   
   func body(content: Content) -> some View {
       content
           .overlay(
           Circle()
               .fill(color)
               .frame(width: 30, height: 30)
               .overlay {
                   Circle()
                       .fill(Color("BG"))
                       .padding(6)
               }
               .offset(y: 53)
           )
           .frame(width: 25)
           .padding(.top, -120)
           .rotationEffect(.init(degrees: -90), anchor: .bottom)
           .rotationEffect(.init(degrees: progress * 180), anchor: .bottom)
           .offset(y: -5)
           .offset(x: 160)
   }
   
}


#Preview{
    FearGreedHomeView()
}

