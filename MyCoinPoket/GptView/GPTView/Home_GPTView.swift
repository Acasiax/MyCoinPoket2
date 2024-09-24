//
//  Home_GPTView.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/24/24.
//

import SwiftUI

struct Home_GPTView: View {
    @StateObject private var viewModel = ChatViewModel()
    
    var body: some View {
        VStack {
            // 채팅 메시지를 리스트로 보여주기
            ScrollView {
                ForEach(viewModel.messages) { message in
                    HStack {
                        if message.isUser {
                            Spacer()
                            Text(message.message)
                                .padding()
                                .background(Color.blue.opacity(0.3))
                                .cornerRadius(10)
                                .padding(.leading, 40)
                        } else {
                            Text(message.message)
                                .padding()
                                .background(Color.gray.opacity(0.3))
                                .cornerRadius(10)
                                .padding(.trailing, 40)
                            Spacer()
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            
            // 입력 필드와 전송 버튼
            HStack {
                TextField("메세지를 입력해보세요...", text: $viewModel.userInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("전송") {
                    viewModel.sendUserMessage()
                }
                .padding()
                .disabled(viewModel.userInput.isEmpty)
            }
            .padding()
        }
        .padding()
    }
}

