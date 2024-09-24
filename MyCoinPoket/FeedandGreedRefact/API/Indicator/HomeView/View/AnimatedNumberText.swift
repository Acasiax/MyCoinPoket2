//
//  AnimatedNumberText.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/24/24.
//

import SwiftUI

struct AnimatedNumberText: Animatable, View {
    
    var value: CGFloat
    var font: Font
    var floatingPoint: Int = 2
  
    
    var animatableData: CGFloat {
    get { value }
    set { value = newValue }
}

var body: some View {
    Text("\(String(format: "%.\(floatingPoint)f", value))")
        .font(font)
}
    
    
}


#Preview{
  FearGreedHomeView()
}

