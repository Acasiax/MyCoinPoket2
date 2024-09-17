//
//  SocketViewModel.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/17/24.
//

import SwiftUI
import Combine

class SocketViewModel: ObservableObject {
    
    @Published var coins: [MarketPrice33] = []  // 여러 코인의 가격 정보
    private var previousPrices: [String: Double] = [:]  // 이전 가격을 저장
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        WebSocketManager.shared.openWebSocket()

        WebSocketManager.shared.tickerSubject
            .receive(on: DispatchQueue.main)
            .filter { [weak self] ticker in
                guard let self = self else { return false }
                let previousPrice = self.previousPrices[ticker.code]
                return previousPrice != ticker.trade_price  // 가격이 변동된 경우에만 업데이트
            }
            .sink { [weak self] ticker in
                guard let self = self else { return }
                
                // 해당 코인의 정보를 업데이트
                if let index = self.coins.firstIndex(where: { $0.code == ticker.code }) {
                    self.coins[index] = ticker
                } else {
                    self.coins.append(ticker)  // 새로운 코인일 경우 추가
                }
            }
            .store(in: &cancellable)

    }
    
    deinit {
        WebSocketManager.shared.closeWebSocket()
    }
}


