//
//  NewModelDTO.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/13/24.
//

import Foundation

struct NewsResponse: Decodable {
    let display: Int
    let items: [NewsItem]
    let lastBuildDate: String
    let start: Int
    let total: Int
}


struct NewsItem: Decodable, Identifiable, Equatable {
    var id: String { link }
    var title: String
    var originallink: String
    let link: String
    var description: String
    let pubDate: String
    var imageUrl: String?
}



