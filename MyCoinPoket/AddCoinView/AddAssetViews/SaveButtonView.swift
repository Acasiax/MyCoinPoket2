//
//  SaveButtonView.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/24/24.
//

import SwiftUI

// 저장 버튼을 위한 뷰 구조체 분리
struct SaveButtonView: View {
    var coinName: String
    var selectedType: ExpenseType
    var purchasePrice: String
    var currentPrice: String
    var onSave: () -> Void

    var body: some View {
        Button(action: {
            onSave()
        }) {
            Text("저장")
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.vertical, 15)
                .frame(maxWidth: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(
                            LinearGradient(
                                           gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.blue]),
                                           startPoint: .topLeading,
                                           endPoint: .bottomTrailing
                                       )
                        )
                }
                .foregroundStyle(.white)
                .padding(.bottom, 10)
        }
        .disabled(coinName.isEmpty || purchasePrice.isEmpty || currentPrice.isEmpty)
        .opacity(coinName.isEmpty || purchasePrice.isEmpty || currentPrice.isEmpty ? 0.6 : 1)
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
    }
}

