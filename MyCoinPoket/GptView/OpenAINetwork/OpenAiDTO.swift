//
//  OpenAiDTO.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/24/24.
//

import Foundation
// 모델을 위한 데이터 구조체
struct ChatMessage: Identifiable {
    let id = UUID()
    let message: String
    let isUser: Bool
}

// OpenAI 응답을 위한 데이터 구조체
struct OpenAIResponse: Decodable {
    struct Choice: Decodable {
        struct Message: Decodable {
            let content: String
        }
        let message: Message
    }
    let choices: [Choice]
}


