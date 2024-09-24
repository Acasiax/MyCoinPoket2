//
//  ChatViewModel.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/24/24.
//

import SwiftUI
import Combine
import Alamofire

final class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var userInput: String = ""
    
    // OpenAI에 메시지 보내기
    func sendUserMessage() {
        let userMessage = ChatMessage(message: userInput, isUser: true)
        messages.append(userMessage)
        
        // OpenAI API에 전달할 메시지 데이터
        let requestMessages: [[String: String]] = [
            ["role": "system", "content": "You are a helpful assistant."],
            ["role": "user", "content": userInput]
        ]
        
        // Alamofire를 사용하여 라우터 패턴으로 API 요청 보내기
        AF.request(OpenAIRouter.sendMessage(messages: requestMessages))
            .responseDecodable(of: OpenAIResponse.self) { response in
                switch response.result {
                case .success(let result):
                    if let botMessage = result.choices.first?.message.content {
                        self.receiveBotMessage(botMessage)
                    }
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
    }
    
    // Bot 메시지를 처리하는 함수
    private func receiveBotMessage(_ message: String) {
        let botMessage = ChatMessage(message: message, isUser: false)
        messages.append(botMessage)
        userInput = ""  // 입력 필드를 비웁니다.
    }
}



