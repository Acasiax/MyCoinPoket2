//
//  FearGreedDTO.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/24/24.
//

import Foundation

struct FearGreedResponse: Codable {
    let data: [FearGreedIndex]
}

struct FearGreedIndex: Codable {
    let value: String
    let timestamp: String
    let value_classification: String
}

struct IndexItem: Identifiable {
    var id = UUID().uuidString
    var icon: String
    var title: String
    var subTitle: String
    var amount: String
}

