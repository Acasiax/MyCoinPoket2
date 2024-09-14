//
//  TabViewModel.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/13/24.
//

import SwiftUI

class TabViewModel: ObservableObject {
    @Published var tabs: [TabModel] = [
        .init(id: TabModel.Tab.coin),
        .init(id: TabModel.Tab.bitcoin),
        .init(id: TabModel.Tab.nft),
        .init(id: TabModel.Tab.crypto),
        .init(id: TabModel.Tab.privacy)
    ]
    @Published var activeTab: TabModel.Tab = .coin
    @Published var tabBarScrollState: TabModel.Tab?
    @Published var progress: CGFloat = .zero
    @Published var isDragging: Bool = false
    @Published var delayTask: DispatchWorkItem?

    // 탭 진행 상태 계산을 처리하는 헬퍼 함수
    func calculateTabProgress(_ tab: TabModel.Tab, rect: CGRect, size: CGSize) {
        if let index = tabs.firstIndex(where: { $0.id == activeTab }), activeTab == tab, !isDragging {
            let offsetX = rect.minX - (size.width * CGFloat(index))
            progress = -offsetX / size.width
        }
    }

    // 탭 선택을 처리하는 헬퍼 함수
    func selectTab(_ tab: TabModel.Tab, viewModel: NewsSearchViewModel) {
        delayTask?.cancel()
        delayTask = nil

        isDragging = true

        withAnimation(.easeInOut(duration: 0.3)) {
            activeTab = tab
            tabBarScrollState = tab
            progress = CGFloat(tabs.firstIndex(where: { $0.id == tab }) ?? 0)
        }

        delayTask = .init { self.isDragging = false }

        if let delayTask {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: delayTask)
        }

        viewModel.fetchNews(for: tab.rawValue)
    }
}

