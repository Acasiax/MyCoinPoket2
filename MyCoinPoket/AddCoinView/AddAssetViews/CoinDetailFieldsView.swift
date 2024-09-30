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
    
    var body: some View {
        VStack(spacing: 20) {
            // 구매수량 필드
            HStack {
                Text("구매수량")
                    .fontWeight(.bold)
                TextField("0", text: $viewModel.numberOfCoins)
                    .font(.system(size: 30))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                    .background {
                        Text(viewModel.numberOfCoins == "" ? "0" : viewModel.numberOfCoins)
                            .font(.system(size: 30))
                            .opacity(0)
                    }
                    .frame(maxWidth: .infinity)
                    .background {
                        Capsule().fill(.white)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top)
            }
            
            // 구매가 입력 필드
            HStack {
                Text("구매가")
                    .fontWeight(.bold)
                
                HStack {
                    Picker("Currency", selection: $viewModel.selectedCurrency) {
                        Text("KRW").tag("KRW")
                        Text("USD").tag("USD")
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(width: 90)
                    
                    TextField("0", text: $viewModel.buyPrice)
                        .font(.system(size: 30))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                }
                .background {
                    Text(viewModel.buyPrice == "" ? "0" : viewModel.buyPrice)
                        .font(.system(size: 30))
                        .opacity(0)
                }
                .frame(maxWidth: .infinity)
                .background {
                    Capsule().fill(.white)
                }
                .padding(.horizontal, 20)
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
                        Capsule().fill(.white)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top)
            }
            
            // 실시간 코인가격 필드
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
                //  }
                
                // 수익 또는 손실 상태 표시
                // CheckBox(viewModel: viewModel)
                if let buyPrice = Double(viewModel.buyPrice), let livePrice = Double(viewModel.livePrice), buyPrice != 0 {
                    if buyPrice < livePrice {
                        Text("수익입니다")
                           // .applyProfitLossStyle()
                        
                            .foregroundColor(.green)
                    } else if buyPrice > livePrice {
                        Text("손실입니다")
                         //   .applyProfitLossStyle()
                            .foregroundColor(.red)
                    } else {
                        Text("변동 없음")
                          //  .applyProfitLossStyle()
                            .foregroundColor(.gray)
                    }
                } else {
                    Text("")
                    //    .applyProfitLossStyle()
                    
                }
                
                
            }
            
            Label {
                DatePicker("", selection: $viewModel.date, displayedComponents: [.date])
                    .datePickerStyle(.graphical)
                    .labelsHidden()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
            } icon: { }
            .background {
                RoundedRectangle(cornerRadius: 12, style: .continuous).fill(.white)
            }
            .scaleEffect(0.9)
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
