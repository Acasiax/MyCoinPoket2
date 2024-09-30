//
//  FearGreedViewModel.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/24/24.
//

import SwiftUI

class FearGreedViewModel: ObservableObject {
    
    @Published var currentIndex: FearGreedIndex?
    @Published var yesterdayIndex: FearGreedIndex?
    @Published var lastWeekIndex: FearGreedIndex?
    @Published var lastMonthIndex: FearGreedIndex?
    @Published var indexItem: [IndexItem] = [] // indexItem 배열에 데이터 저장
    @Published var selectedIndexType: String = "현재"

    func fetchFearGreedIndex() {
        FearGreedNetworkManager.fetchFearGreedIndex { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    // 최신, 어제, 지난주, 지난달 데이터 가져오기
                    self.currentIndex = response.data.first
                    self.yesterdayIndex = response.data[1]
                    self.lastWeekIndex = response.data[7]
                    self.lastMonthIndex = response.data[29]
                    
                    // indexItem 배열 업데이트
                    self.updateindexItem()
                }
            case .failure(let error):
                print("에러 발생: \(error.localizedDescription)")
            }
        }
    }
        
    func updateindexItem() {
        self.indexItem = []
        
        // 현재 공포 및 탐욕 지수 추가
        if let currentIndex = currentIndex {
            indexItem.append(IndexItem(
                icon: "flame.fill",
                title: "현재 공포 및 탐욕 지수",
                subTitle: Date.formatTimestamp(currentIndex.timestamp),
                amount: currentIndex.value
            ))
        }
        
        if let yesterdayIndex = yesterdayIndex {
            indexItem.append(IndexItem(
                icon: "flame.fill",
                title: "어제 공포 및 탐욕 지수",
                subTitle: Date.formatTimestamp(yesterdayIndex.timestamp),
                amount: yesterdayIndex.value
            ))
        }
        
        if let lastWeekIndex = lastWeekIndex {
            indexItem.append(IndexItem(
                icon: "flame.fill",
                title: "지난주 공포 및 탐욕 지수",
                subTitle: Date.formatTimestamp(lastWeekIndex.timestamp),
                amount: lastWeekIndex.value
            ))
        }
     
        if let lastMonthIndex = lastMonthIndex {
            print(lastMonthIndex)
            indexItem.append(IndexItem(
                icon: "flame.fill",
                title: "29일 전 공포 및 탐욕 지수",
                subTitle: Date.formatTimestamp(lastMonthIndex.timestamp),
                amount: lastMonthIndex.value
            ))
        }
    }
}

