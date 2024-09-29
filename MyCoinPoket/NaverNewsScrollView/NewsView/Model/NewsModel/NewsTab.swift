//
//  NewsTab.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/13/24.
//

import SwiftUI

struct TabModel: Identifiable {
    private(set) var id: Tab
    var size: CGSize = .zero
    var minX: CGFloat = .zero
    
    enum Tab: String, CaseIterable {
        case coin = "암호화폐"
        case bitcoin = "비트코인"
        case nft = "NFT"
        case crypto = "스테이킹"
        case privacy = "에어드롭"
    }
}

