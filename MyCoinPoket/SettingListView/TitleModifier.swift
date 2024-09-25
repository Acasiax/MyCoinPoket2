//
//  TitleModifier.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/25/24.
//

import SwiftUI

struct TitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 30))
            .bold()
            .padding(.top)
            .padding(.leading, 20)
    }
}


extension View {
    func naviTitleStyle() -> some View {
        self.modifier(TitleModifier())
    }
}
