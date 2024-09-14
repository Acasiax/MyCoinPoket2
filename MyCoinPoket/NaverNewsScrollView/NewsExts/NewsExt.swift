//
//  NewsExt.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/13/24.
//

import Foundation
import SwiftUI

struct RectKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

extension View {
    @ViewBuilder
    func rect(completion: @escaping (CGRect) -> ()) -> some View {
        self
            .overlay {
                GeometryReader {
                    let rect = $0.frame(in: .scrollView(axis: .horizontal))
                    
                    Color.clear
                        .preference(key: RectKey.self, value: rect)
                        .onPreferenceChange(RectKey.self, perform: completion)
                }
            }
    }
}


import SwiftUI

extension CGFloat {
    func interpolate(inputRange: [CGFloat], outputRange: [CGFloat]) -> CGFloat {
       // 값이 초기 입력 범위보다 작을 경우
        let x = self
        let length = inputRange.count - 1
        if x <= inputRange[0] { return outputRange[0] }
        
        for index in 1...length {
            let x1 = inputRange[index - 1]
            let x2 = inputRange[index]
            
            let y1 = outputRange[index - 1]
            let y2 = outputRange[index]
            
           //선형 보간 공식: y1 + ((y2-y1) / (x2-x1)) * (x-x1)
            if x <= inputRange[index] {
                let y = y1 + ((y2-y1) / (x2-x1)) * (x-x1)
                return y
            }
        }
        
        // 값이 최대 입력 범위를 초과할 경우
        return outputRange[length]
    }
}

