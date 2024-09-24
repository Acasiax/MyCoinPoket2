//
//  SpeedoMeter.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/24/24.
//

import SwiftUI

struct SpeedoMeter: View {
    
    @Binding var progress: CGFloat
    var color: Color
    
    var body: some View {
        GeometryReader{ proxy in
            let size = proxy.size
            BackgroundCapsules(size: size)
           
            ColorCapsules(size: size, progress: progress, color: color)
            
            // 나침반 바늘
            IndicatorShape()
                .fill(color)
                .modifier(IndicatorShapeStyleModifier(progress: $progress, color: color))

        }
        .padding(.top)
        .padding(10)
       // .background(.gray)
    }
}

struct BackgroundCapsules: View {
    
    var size: CGSize
    
    var body: some View {
        
        ZStack{
            ForEach(1...180, id: \.self) { index in
                let deg = CGFloat(index) * 1
                Capsule()
                    .fill(.gray.opacity(0.25))
                    .frame(width: 40, height: 4)
                    .offset(x: -(size.width - 40) / 2)
                    .rotationEffect(.init(degrees: deg))
            }
            
        }.frame(width: size.width, height: size.height, alignment: .bottom)
    }
}


struct ColorCapsules: View {
   
    var size: CGSize
    var progress: CGFloat
    var color: Color
    
    var body: some View {
        
        ZStack {
            // 동적으로 변화하는 색상의 링
            ForEach(1...180, id: \.self) { index in
                let deg = CGFloat(index) * 1
                Capsule()
                    .fill(deg < 60 ? Color.red : (deg >= 60 && deg < 120 ? Color.orange : Color.green))
                    .frame(width: 40, height: 4)
                    .offset(x: -(size.width - 40) / 2)
                    .rotationEffect(.init(degrees: deg))
            }
        }
        .frame(width: size.width, height: size.height, alignment: .bottom)
        .mask {
            Circle()
                .trim(from: 0, to: (progress / 2) + 0.002)
                .stroke(color, lineWidth: 40)
                .frame(width: size.width - 40, height: size.width - 40)
                .offset(y: -(size.height) / 2)
                .rotationEffect(.init(degrees: 180))
        }
    }
}
 

#Preview {
    FearGreedHomeView()
//    SpeedoMeter(progress: .constant(0.5), color: .red)
//        .preferredColorScheme(.dark)
}

