//
//  MainTapEnum.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/13/24.
//

import Foundation

enum MainTab: String {
    case Home = "house.fill"
    case Wallet = "creditcard.fill"
    case News = "newspaper.fill"
    case Person = "person.fill"
}

class TabBarViewModel: ObservableObject {
    @Published var currentTab: MainTab = .Home
}

