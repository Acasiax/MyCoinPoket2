//
//  WebSocketManager.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/17/24.
//

import SwiftUI
import Combine

class WebSocketManager: NSObject {
    
    static let shared = WebSocketManager()
    
    private var websocket: URLSessionWebSocketTask?
    private var currentMarketCodes: Set<String> = []  // 현재 요청된 코인 마켓 코드
    private var reconnectAttempts = 0  // 재연결 시도 횟수
    private let maxReconnectAttempts = 5  // 최대 재연결 시도 횟수
    var tickerSubject = PassthroughSubject<MarketPrice33, Never>()
    
    func openWebSocket() {
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        let url = URL(string: UpbitAPI.openWebSocketURL)!
        websocket = session.webSocketTask(with: url)
        websocket?.resume()
    }
    
    func closeWebSocket() {
        websocket?.cancel(with: .goingAway, reason: nil)
        websocket = nil
    }


    func send(marketCodes: [String]) {
        let data = """
        [
          {"ticket":"test example"},
          {"type":"ticker", "codes":\(marketCodes)},
          {"format":"DEFAULT"}
        ]
        """
        websocket?.send(.string(data), completionHandler: { error in
            if let error = error {
                print("전송 오류: \(error)")
            } else {
                print("전송 성공")
            }
        })
    }

    func receive() {
        guard let websocket = websocket else {
            print("웹소켓이 연결되지 않았습니다. 데이터를 받을 수 없습니다.")
            return
        }
        
        websocket.receive { result in
            switch result {
            case .success(let message):
                switch message {
                case .data(let data):
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("수신된 데이터: \(jsonString)")
                        
                        // TOO_MANY_REQUEST 에러 확인 및 처리
                        if jsonString.contains("TOO_MANY_REQUEST") {
                            self.handleTooManyRequests()  // 요청이 너무 많을 때 처리
                        }
                    }
                    
                    if let decodedTicker = try? JSONDecoder().decode(MarketPrice33.self, from: data) {
                        self.tickerSubject.send(decodedTicker)  // 수신한 데이터를 방출
                    } else {
                        print("디코딩 실패")
                    }
                default:
                    print("알 수 없는 메시지를 받았습니다.")
                }
            case .failure(let error):
                print("수신 오류: \(error.localizedDescription)")
                self.reconnectWebSocket()  // 연결 끊김 시 재연결
            }
            
            self.receive()  // 수신을 계속 대기
        }
    }

    func reconnectWebSocket() {
        guard reconnectAttempts < maxReconnectAttempts else {
            print("재연결 시도를 5번 했으나 실패하여 웹소켓을 종료합니다.")
            closeWebSocket()  // 최대 재연결 시도 후 연결 종료
            return
        }

        reconnectAttempts += 1  // 재연결 시도 횟수 증가
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            print("웹소켓 재연결 시도 중... (\(self.reconnectAttempts)번째 시도)")
            self.openWebSocket() // 웹소켓 재연결
            // 필요한 경우 다시 marketCodes 전송
        }
    }
    
    func handleTooManyRequests() {
        print("너무 많은 요청을 보냈습니다. 10초 후에 다시 시도합니다.")
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.send(marketCodes: Array(self.currentMarketCodes))  // 저장된 marketCodes로 다시 시도
        }
    }
}

extension WebSocketManager: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("웹소켓 연결됨")
        reconnectAttempts = 0  // 연결 성공 시 재연결 시도 횟수 초기화
        receive()  // 연결 후 데이터 수신 시작
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("웹소켓 연결 종료됨")
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}




//import SwiftUI
//import Combine
//
//class WebSocketManager: NSObject {
//    
//    static let shared = WebSocketManager()
//    
//    private var websocket: URLSessionWebSocketTask?
//    private var currentMarketCodes: Set<String> = []  // 현재 요청된 코인 마켓 코드
//    var tickerSubject = PassthroughSubject<MarketPrice33, Never>()
//    
//    func openWebSocket() {
//        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
//        let url = URL(string: UpbitAPI.openWebSocketURL)!
//        websocket = session.webSocketTask(with: url)
//        websocket?.resume()
//    }
//    
//    func closeWebSocket() {
//        websocket?.cancel(with: .goingAway, reason: nil)
//        websocket = nil
//    }
//
//
//    func send(marketCodes: [String]) {
//        let data = """
//        [
//          {"ticket":"test example"},
//          {"type":"ticker", "codes":\(marketCodes)},
//          {"format":"DEFAULT"}
//        ]
//        """
//        websocket?.send(.string(data), completionHandler: { error in
//            if let error = error {
//                print("전송 오류: \(error)")
//            } else {
//                print("전송 성공")
//            }
//        })
//    }
//
//    func receive() {
//        guard let websocket = websocket else {
//            print("웹소켓이 연결되지 않았습니다. 데이터를 받을 수 없습니다.")
//            return
//        }
//        
//        websocket.receive { result in
//            switch result {
//            case .success(let message):
//                switch message {
//                case .data(let data):
//                    if let jsonString = String(data: data, encoding: .utf8) {
//                        print("수신된 데이터: \(jsonString)")
//                        
//                        // TOO_MANY_REQUEST 에러 확인 및 처리
//                        if jsonString.contains("TOO_MANY_REQUEST") {
//                            self.handleTooManyRequests()  // 요청이 너무 많을 때 처리
//                        }
//                    }
//                    
//                    if let decodedTicker = try? JSONDecoder().decode(MarketPrice33.self, from: data) {
//                        self.tickerSubject.send(decodedTicker)  // 수신한 데이터를 방출
//                    } else {
//                        print("디코딩 실패")
//                    }
//                default:
//                    print("알 수 없는 메시지를 받았습니다.")
//                }
//            case .failure(let error):
//                print("수신 오류: \(error.localizedDescription)")
//                self.reconnectWebSocket()  // 연결 끊김 시 재연결
//            }
//            
//            self.receive()  // 수신을 계속 대기
//        }
//    }
//
//    func reconnectWebSocket() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            print("웹소켓 재연결 시도 중...")
//            self.openWebSocket() // 웹소켓 재연결
//            // 필요한 경우 다시 marketCodes 전송
//        }
//    }
//
//    
//    func handleTooManyRequests() {
//        print("너무 많은 요청을 보냈습니다. 10초 후에 다시 시도합니다.")
//        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
//            self.send(marketCodes: Array(self.currentMarketCodes))  // 저장된 marketCodes로 다시 시도
//        }
//    }
//}
//
//extension WebSocketManager: URLSessionWebSocketDelegate {
//    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
//        print("웹소켓 연결됨")
//        receive()  // 연결 후 데이터 수신 시작
//    }
//    
//    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
//        print("웹소켓 연결 종료됨")
//    }
//}
//
//extension Array {
//    func chunked(into size: Int) -> [[Element]] {
//        stride(from: 0, to: count, by: size).map {
//            Array(self[$0..<Swift.min($0 + size, count)])
//        }
//    }
//}
//
