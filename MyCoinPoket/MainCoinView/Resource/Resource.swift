//
//  Resource.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/13/24.
//

import SwiftUI

extension View {
    @available(iOS 14, *)
    func navigationBarTitleTextColor(_ color: Color) -> some View {
        let uiColor = UIColor(color)
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: uiColor ]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: uiColor ]
        return self
    }
}

extension Color {
    static func random() -> Color {
        return Color(red: .random(in: 0...1),
                     green: .random(in: 0...1),
                     blue: .random(in: 0...1)
        )
    }
}

struct CustomColors {
    static let lightGray = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00) //#F5F5F5
    static let navy = Color(UIColor(red: 0.18, green: 0.21, blue: 0.38, alpha: 1.00))
    static let darkBlue = UIColor(red: 0.25, green: 0.22, blue: 0.79, alpha: 1.00)
    static let lightnavy = UIColor(red: 0.91, green: 0.92, blue: 0.97, alpha: 1.00)
}



