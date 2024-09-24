//
//  OpenAIHeader.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/24/24.
//

import Foundation

enum OpenAIHeader: String {
    case authorization = "Authorization"
    case contentType = "Content-Type"
}


enum OpenAIRequestParameter: String {
    case model = "model"
    case messages = "messages"
    case maxCompletionTokens = "max_completion_tokens"
    case temperature = "temperature"
}


