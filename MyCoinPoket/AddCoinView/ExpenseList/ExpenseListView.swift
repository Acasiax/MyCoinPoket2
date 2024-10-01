//
//  ExpenseListView.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/24/24.
//


import Foundation
import Combine
import RealmSwift

class Expense: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var coinName: String = "" // 코인 이름
    @Persisted var coinMarketName: String = "" // 코인 마켓 이름
    @Persisted var numberOfCoins: Double = 0.0 // 보유한 코인의 수량
    @Persisted var totalPurchaseAmount: Double = 0.0 // 총 매수 금액
    @Persisted var buyPrice: Double = 0.0
    @Persisted var resultPrice: Double = 0.0
    
    convenience init(coinName: String, coinMarketName: String, numberOfCoins: Double, buyPrice: Double, resultPrice: Double, totalPurchaseAmount: Double) {
        self.init()  // Realm의 기본 이니셜라이저 호출
        self.coinName = coinName
        self.coinMarketName = coinMarketName
        self.numberOfCoins = numberOfCoins
        self.buyPrice = buyPrice
        self.resultPrice = resultPrice
        self.totalPurchaseAmount = totalPurchaseAmount
        
    }
}

enum ChartType: String, CaseIterable {
    case pie = "원형"
    case bar = "막대"
  //  case line = "선"
}


import SwiftUI
import RealmSwift

struct ExpenseListView: View {
    @ObservedResults(Expense.self) var realmExpenses
    @ObservedObject var viewModel: NewExpenseViewModel
    @Namespace private var animation
    @State private var chartType: ChartType = .pie
    @State private var timer: Timer? = nil
    @State private var isChartExpanded: Bool = false // 차트 보임 여부 상태

    
    var filteredExpenses: [Expense] {
        switch viewModel.selectedType {
        case .all:
            return Array(realmExpenses)
        case .income:
            return realmExpenses.filter { expense in
                calculateMyResult(expense: expense) > 0
            }
        case .expense:
            return realmExpenses.filter { expense in
                calculateMyResult(expense: expense) <= 0
            }
        }
    }

    var body: some View {
        
        VStack{
            HStack {
                Text("내 자산 포트폴리오")
                    .naviTitleStyle()
                Spacer()
            }
            //  .background(Color.green)
            
            
           // ScrollView {
//                ChartView(expenses: Array(realmExpenses), chartType: $chartType)
//                ChartView(chartType: $chartType)
//                    .padding(.horizontal, 15)
                
             //   ScrollView {
            
            
            
            HStack {
                        Text("보유자산 포트폴리오")
                            .font(.headline)
                        Spacer()
                        Image(systemName: isChartExpanded ? "chevron.up" : "chevron.down")
                            .onTapGesture {
                                withAnimation {
                                    isChartExpanded.toggle() // 차트 보임 여부 변경
                                }
                            }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.15))
                    .cornerRadius(10)
                    .padding(.horizontal)

                    if isChartExpanded {
                        ChartView(chartType: $chartType)
                            .padding(.horizontal, 15)
                    }
            
            
            
                    
                    CustomSegmentedControl()
                        .padding(.top)
                    
//                    LazyVStack(alignment: .leading, spacing: 12) {
//                        ForEach(filteredExpenses) { expense in
//                            let expenseViewModel = viewModel.getExpenseViewModel(for: expense)
//                            ExpenseRowView(expense: expense, viewModel: expenseViewModel)
//                                .padding(.horizontal, 10)
//                                .padding(.vertical, 20)
//                            // .background(Color.gray.opacity(0.1))
//                                .background {
//                                    Color("BG").ignoresSafeArea()
//                                }
//                                .cornerRadius(10)
//                        }
//                        .onDelete(perform: deleteExpense)
//                       
//                    }
                List {
                    ForEach(filteredExpenses) { expense in
                        let expenseViewModel = viewModel.getExpenseViewModel(for: expense)
                        ExpenseRowView(expense: expense, viewModel: expenseViewModel)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 20)
                            .background {
                                Color("BG").ignoresSafeArea()
                               // Color.blue.ignoresSafeArea()
                            }
                            .cornerRadius(10)
                    }
                    .onDelete(perform: deleteExpense)
                }
                .cornerRadius(10)
                .listStyle(PlainListStyle())

                   // .padding()
             //   }
                
                .onAppear {
                    print("======")
                    viewModel.updateExpenseViewModels()
                    fetchLivePriceForAllCoins()
                    startTimer()
                }
                .onDisappear {
                    stopTimer()
                }
            }
        }
  //  }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            fetchLivePriceForAllCoins()
        }
    }
       
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func fetchLivePriceForAllCoins() {
        let allMarketCodes = realmExpenses.map { $0.coinMarketName }
        let uniqueMarketCodes = Array(Set(allMarketCodes))
        WebSocketManager.shared.send(marketCodes: uniqueMarketCodes)
        print("웹소켓에 보낸 거 \(uniqueMarketCodes)")
    }
    
    // Realm에서 객체 삭제하는 함수
      private func deleteExpense(at offsets: IndexSet) {
          offsets.map { filteredExpenses[$0] }.forEach { expense in
              viewModel.deleteExpense(expense: expense)
          }
      }

    
    private func calculateMyResult(expense: Expense) -> Double {
        let livePrice = Double(viewModel.getExpenseViewModel(for: expense).livePrice) ?? 0.0
        let evaluationAmount = expense.numberOfCoins * livePrice
        return evaluationAmount - expense.totalPurchaseAmount
    }
}


extension ExpenseListView {
    @ViewBuilder
    func CustomSegmentedControl() -> some View {
        HStack(spacing: 0) {
            ForEach([ExpenseType.all, ExpenseType.expense, ExpenseType.income], id: \.rawValue) { tab in
                Text(tab.rawValue.capitalized)
                    .fontWeight(.semibold)
                    .foregroundColor(viewModel.selectedType == tab ? .white : .black)
                    .opacity(viewModel.selectedType == tab ? 1 : 0.7)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background {
                        if viewModel.selectedType == tab {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(
                                    LinearGradient(
                                                   gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.blue]),
                                                   startPoint: .topLeading,
                                                   endPoint: .bottomTrailing
                                               )
                                )
                                .matchedGeometryEffect(id: "TAB", in: animation)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation {
                            viewModel.selectedType = tab
                        }
                    }
            }
        }
        .padding(5)
        .background {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color("BG"))
        }
    }
}
    


struct ExpenseRowView: View {
    @ObservedRealmObject var expense: Expense
    @ObservedObject var viewModel: ExpenseViewModel

    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading){
                    Text(expense.coinName)
                        .fontWeight(.bold)
                    Text(expense.coinMarketName)
                        .foregroundColor(.gray)
                }

                Spacer()

                VStack(alignment: .trailing) {
                    Text("평가손익: \(calculateMyResult(), specifier: "%.2f")원")
                        .font(.callout)
                    
                    Text("수익률: \(calculateProfitLoss(), specifier: "%.2f")%")
                        .font(.callout)
                 //   Text("실시간 현재가: \(viewModel.livePrice)원")
                    Text("실시간 현재가: \(formattedPrice(viewModel.livePrice))원")
                        .font(.callout)
               
                }
            }

            Divider()

            VStack(spacing: 10) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("보유수량")
                            .foregroundColor(.gray)
                        Text("\(expense.numberOfCoins)개")
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("매수평균가")
                            .foregroundColor(.gray)
                        Text("\(calculateAveragePurchasePrice(), specifier: "%.2f")원")
                    }
                }

                HStack {
                    VStack(alignment: .leading) {
                        Text("평가금액")
                            .foregroundColor(.gray)
                        Text("\(calculateEvaluationAmount(), specifier: "%.2f")원")
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("매수금액")
                            .foregroundColor(.gray)
                        Text("\(expense.totalPurchaseAmount)원")
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 10)
        .padding(.vertical, 20)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }

 
}

extension ExpenseRowView {
    
    //세자리 콤마 함수
    private func formattedPrice(_ price: String) -> String {
        guard let priceDouble = Double(price) else {
            return price
        }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        if priceDouble < 1 {
            numberFormatter.minimumFractionDigits = 0
            numberFormatter.maximumFractionDigits = 10 // 소수점 이하 전체 표시
        } else if priceDouble < 10 {
            numberFormatter.minimumFractionDigits = 4
            numberFormatter.maximumFractionDigits = 4
        } else if priceDouble < 10_000 {
            numberFormatter.minimumFractionDigits = 2
            numberFormatter.maximumFractionDigits = 2
        } else {
            numberFormatter.minimumFractionDigits = 0
            numberFormatter.maximumFractionDigits = 0
        }
        
        return numberFormatter.string(from: NSNumber(value: priceDouble)) ?? price
    }

    
    // 평가 금액 = 현재코인 가격 * 보유 코인 갯수
    private func calculateEvaluationAmount() -> Double {
        let numberOfCoins = expense.numberOfCoins // Realm에서 최신 보유수량 값 사용
        let livePrice = Double(viewModel.livePrice) ?? 0.0
        return numberOfCoins * livePrice
    }

    // 평균매수가
    private func calculateAveragePurchasePrice() -> Double {
        let totalPurchaseAmount = expense.totalPurchaseAmount // Realm에서 최신 총 매입 금액 사용
        let numberOfCoins = expense.numberOfCoins // Realm에서 최신 보유수량 값 사용
        
        if numberOfCoins != 0 {
            return totalPurchaseAmount / numberOfCoins
        } else {
            return 0.0 // 매수량이 0일 경우 평균 매수가는 0으로 설정
        }
    }
    
    // 수익률 = (평가 금액 - 총 매입 금액) / 총 매입 금액 * 100
    private func calculateProfitLoss() -> Double {
        let evaluationAmount = calculateEvaluationAmount() // 평가 금액 계산
        let totalPurchaseAmount = expense.totalPurchaseAmount // Realm에서 최신 총 매입 금액 사용

        if totalPurchaseAmount != 0 {
            let profitLossValue = (evaluationAmount - totalPurchaseAmount) / totalPurchaseAmount * 100
            return profitLossValue
        } else {
            return 0.0 // 총 매입 금액이 0일 경우 수익률은 0으로 설정
        }
    }
    
    // 평가 손익 = 평가 금액 - 총 매입 금액
    private func calculateMyResult() -> Double {
        let evaluationAmount = calculateEvaluationAmount() // 평가 금액 계산
        let totalPurchaseAmount = expense.totalPurchaseAmount // Realm에서 최신 총 매입 금액 사용
        return evaluationAmount - totalPurchaseAmount
    }
}
