//
//  CoinDetailFieldsView.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/24/24.
//

import SwiftUI

struct CoinDetailFieldsView: View {
    @ObservedObject var viewModel: NewExpenseViewModel
    @Binding var selectedCategory: String
    @State private var activeTextField: ActiveTextField = .none

    enum ActiveTextField {
        case none, numberOfCoins, buyPrice
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // 구매수량 필드
            HStack {
                Text("구매수량")
                    .fontWeight(.bold)
                    .frame(width: 70, alignment: .leading)

                TextField("0", text: $viewModel.numberOfCoins)
                    .disabled(true) // 기본 키보드 비활성화
                    .font(.system(size: 30))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 230)
                    .background {
                        Capsule().fill(Color("BG"))
                    }
                    .onTapGesture {
                        activeTextField = .numberOfCoins
                    }
                    .padding(.top)
                    .overlay(
                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(activeTextField == .numberOfCoins ? .blue : .clear)
                            .padding(.top, 45)
                    )
            }

            // 구매가 입력 필드
            HStack {
                Text("구매가")
                    .fontWeight(.bold)
                    .frame(width: 70, alignment: .leading)

                HStack {
                    Picker("Currency", selection: $viewModel.selectedCurrency) {
                        Text("KRW").tag("KRW")
                        Text("USD").tag("USD")
                    }
                    .pickerStyle(MenuPickerStyle())

                    TextField("0", text: $viewModel.buyPrice)
                        .disabled(true) // 기본 키보드 비활성화
                        .font(.system(size: 30))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 230)
                        .background {
                            Capsule().fill(Color("BG"))
                        }
                        .onTapGesture {
                            activeTextField = .buyPrice
                        }
                        .overlay(
                            Rectangle()
                                .frame(height: 2)
                                .foregroundColor(activeTextField == .buyPrice ? .blue : .clear)
                                .padding(.top, 45)
                        )
                }
            }

            // 총액 필드
            HStack {
                Text("총액")
                    .fontWeight(.bold)
                TextField("0", text: $viewModel.resultPrice)
                    .font(.system(size: 30))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    .disabled(true) // 결과값 수정 불가
                    .frame(maxWidth: .infinity)
                    .background {
                        Capsule().fill(Color("BG"))
                    }
                    .padding(.horizontal, 20)
                   // .padding(.top)
            }
        }

        // 실시간 코인가격 필드
        VStack(alignment: .center) {
            HStack(alignment: .center) {
                Text("실시간 코인가격")
                    .fontWeight(.bold)

                if selectedCategory == "KRW" {
                    if let price = Double(viewModel.livePrice) {
                        if price < 1000 {
                            Text(String(format: "%.2f", price))
                        } else {
                            Text("\(NSNumber(value: price), formatter: NumberFormatter.withCommas)")
                        }
                    } else {
                        Text("0")
                    }
                } else {
                    Text(viewModel.livePrice)
                }

                // 수익 또는 손실 상태 표시
                if let buyPrice = Double(viewModel.buyPrice), let livePrice = Double(viewModel.livePrice), buyPrice != 0 {
                    if buyPrice < livePrice {
                        Text("수익입니다")
                            .foregroundColor(.green)
                    } else if buyPrice > livePrice {
                        Text("손실입니다")
                            .foregroundColor(.red)
                    } else {
                        Text("변동 없음")
                            .foregroundColor(.gray)
                    }
                } else {
                    Text("")
                }
            }
            .padding(.top, 5)
            .padding(.bottom, -5)
        }

        // CustomDecimalPad always visible
        VStack(alignment: .center) {
            CustomDecimalPad(text: bindingForActiveTextField())
        }
    }

    private func bindingForActiveTextField() -> Binding<String> {
        switch activeTextField {
        case .numberOfCoins:
            return $viewModel.numberOfCoins
        case .buyPrice:
            return $viewModel.buyPrice
        case .none:
            return .constant("") // No active text field
        }
    }
}

struct CustomDecimalPad: View {
    @Binding var text: String

    let buttons: [[String]] = [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"],
        [".", "0", "⌫"]
    ]

    var body: some View {
        VStack {
            ForEach(buttons, id: \.self) { row in
                HStack {
                    ForEach(row, id: \.self) { button in
                        Button(action: {
                            handleButtonPress(button: button)
                        }) {
                            Text(button)
                                .font(.system(size: 24))
                                .frame(width: 80, height: 80)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                        }
                    }
                }
            }
        }
        .padding()
    }

    private func handleButtonPress(button: String) {
        switch button {
        case "⌫":
            if !text.isEmpty {
                text.removeLast()
            }
        case ".":
            if !text.contains(".") {
                text.append(".")
            }
        default:
            text.append(button)
        }
    }
}



struct CheckBox: View {
    @ObservedObject var viewModel: NewExpenseViewModel
    @State private var isProfit: Bool = false
    @State private var isLoss: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: "arrow.up.arrow.down")
                .foregroundColor(.gray)
                .padding(.leading, 5)
            
            Toggle(isOn: $isProfit) {
                Text("수익")
            }
            .toggleStyle(CheckBoxStyle())
            .disabled(isLoss) // 손실이 체크되어 있을 때는 수익을 선택할 수 없도록 비활성화
            
            Toggle(isOn: $isLoss) {
                Text("손실")
            }
            .toggleStyle(CheckBoxStyle())
            .disabled(isProfit) // 수익이 체크되어 있을 때는 손실을 선택할 수 없도록 비활성화
            
            Spacer()
        }
        .padding()
        .background(Color(.white)) // 배경색 지정
        .cornerRadius(10)
        .onChange(of: viewModel.buyPrice) {
            updateProfitOrLoss()
        }
        .onChange(of: viewModel.livePrice) {
            updateProfitOrLoss()
        }
    }
    
    // 수익과 손실을 계산하는 메서드
    func updateProfitOrLoss() {
        if let buyPrice = Double(viewModel.buyPrice), let livePrice = Double(viewModel.livePrice) {
            if buyPrice > livePrice {
                isProfit = false
                isLoss = true
            } else if buyPrice < livePrice {
                isProfit = true
                isLoss = false
            } else {
                isProfit = false
                isLoss = false
            }
        }
    }
}

// 체크박스 스타일 정의
struct CheckBoxStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }) {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                    .foregroundColor(configuration.isOn ? .green : .gray)
                configuration.label
            }
        }
    }
}

// 커스텀 수정자 정의
extension View {
    func applyProfitLossStyle() -> some View {
        self
            .font(.system(size: 15))
            .padding(.horizontal, 30)
            .frame(maxWidth: .infinity) // 최대 너비 설정
//            .background(
//                RoundedRectangle(cornerRadius: 12, style: .continuous)
//                    .fill(Color.white)
//            )
            
           
    }
}
