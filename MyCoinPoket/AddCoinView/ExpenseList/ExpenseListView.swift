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


import SwiftUI
import RealmSwift


struct ExpenseListView: View {
    @ObservedResults(Expense.self) var realmExpenses
    @ObservedObject var viewModel: NewExpenseViewModel
 
    @State private var timer: Timer? = nil
    
    var body: some View {
        List {
            ForEach(realmExpenses) { expense in
                let expenseViewModel = viewModel.getExpenseViewModel(for: expense)
                ExpenseRowView(expense: expense, viewModel: expenseViewModel)
            }
        }
        .onAppear {
            print("======")
            fetchLivePriceForAllCoins()
            startTimer()
            
        }
        .onDisappear {
                   stopTimer()
               }
       

    }

    
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
    
   
    
}

struct ExpenseRowView: View {
    @ObservedRealmObject var expense: Expense
    @ObservedObject var viewModel: ExpenseViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text("코인 이름: \(expense.coinName)")
            Text("마켓 이름: \(expense.coinMarketName)")
            Text("보유수량: \(expense.numberOfCoins)")
            Text("총매입가격: \(expense.totalPurchaseAmount)")
            
            Text("실시간 가격: \(viewModel.livePrice)") // 실시간 가격은 ViewModel에서 가져옵니다.
            Text("평가금액: \(calculateEvaluationAmount())")
            Text("평균매수가: \(calculateAveragePurchasePrice())")
            Text("수익률: \(calculateProfitLoss())%")
            Text("평가손익: \(calculateMyResult())")
        }
    }
}

  
extension ExpenseRowView {
    
    // 평가 금액 = 현재코인 가격 * 보유 코인 갯수
       private func calculateEvaluationAmount() -> Double {
           let numberOfCoins = expense.numberOfCoins // Realm에서 최신 보유수량 값 사용
           let livePrice = Double(viewModel.livePrice) ?? 0.0
           return numberOfCoins * livePrice
       }
    
    
    
    //평균매수가
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



//import SwiftUI
//import RealmSwift
//
//struct ExpenseListView: View {
//    //@ObservedObject var newExpenseViewModel: NewExpenseViewModel
//    @StateObject var newExpenseViewModel = NewExpenseViewModel()
//
//    @Namespace var animation
//    @ObservedResults(Expense.self) var expenses
//  var filteredExpenses: [NewExpenseViewModel] {
//        // 사용자가 세그먼트 컨트롤에서 "전체"를 선택한 경우, 모든 expenses를 반환
//        if newExpenseViewModel.selectedType == .all {
//            return newExpenseViewModel.expenseViewModels
//        } else {
//            // 사용자가 "수익" 또는 "손실"을 선택한 경우, 해당 wowexpenseType과 일치하는 expenses만 필터링하여 반환
//            return newExpenseViewModel.expenses.filter { $0.wowexpenseType == newExpenseViewModel.selectedType }
//        }
//    }
//    
//    var body: some View {
//        VStack{
//            HStack(spacing: -15) {
//                Image(.logo)
//                    .resizable()
//                    .frame(width: 40, height: 40)
//                    .padding(.leading, 10)
//                
//                Text("내 자산 포트폴리오")
//                    .naviTitleStyle()
//                Spacer()
//            }
//           // .background(Color.green)
//            
//            
//            ChartView(newExpenseViewModel: newExpenseViewModel)
//                .padding(.horizontal, 15)
//               
//             
//      
//            
//            ScrollView {
//                CustomSegmentedControl()
//                    .padding(.top)
//                
//                LazyVStack(alignment: .leading, spacing: 12) {
//                    ForEach(filteredExpenses) { expense in
//                        ExpenseRowView(expense: expense, viewModel: newExpenseViewModel)
//                            .padding(.horizontal, 10)
//                            .padding(.vertical, 20)
//                           // .background(Color.gray.opacity(0.1))
//                            .background {
//                                Color("BG").ignoresSafeArea()
//                            }
//                            .cornerRadius(10)
//                    }
//                    .animation(.easeInOut, value: filteredExpenses)
//                    .padding(.horizontal, 20)
//                }
//                .padding(.top)
//            }
//           // .navigationTitle("저장된 자산")
//        }
//        //.background(Color.yellow)
//    }
//    
//
//
//}
//
//
//
//// 새로운 ExpenseRowView🔥
//struct ExpenseRowView: View {
//    @ObservedObject var expense: Expense // Expense가 클래스이므로 @ObservedObject 사용
//    @ObservedObject var viewModel: NewExpenseViewModel
//
//    var body: some View {
//        VStack {
//            HStack {
//                Text(expense.coinName)
//                    .fontWeight(.bold)
//                Text(expense.coinMarketName)
//                    .foregroundStyle(.gray)
//
//                Spacer()
//
//                VStack(alignment: .trailing) {
//                    Text("평가손익  \(expense.myResult)원")
//                        .font(.callout)
//                    
//                    Text("수익률  \(expense.profitRatePersent)")
//                        .font(.callout)
//                    Text("실시간 현재가  \(expense.livePrice)원")
//                        .font(.callout)
//                    Text("날짜  \(formatDate(expense.date))")
//                        .font(.caption)
//                    Text("방금추가한 총액: \(expense.resultPrice)")
//                        .font(.caption)
//                }
//            }
//
//            Divider()
//
//            VStack(spacing: 10) {
//                HStack {
//                    VStack(alignment: .leading) {
//                        Text("보유수량  (마켓티커)")
//                            .foregroundStyle(.gray)
//                        Text("\(expense.numberOfCoins)개")
//                    }
//                    Spacer()
//                    VStack(alignment: .trailing) {
//                        Text("매수평균가")
//                            .foregroundStyle(.gray)
//                        Text("\(expense.averagePurchasePrice)원") // 매수평균가 계산된 값 사용
//                    }
//                }
//
//                HStack {
//                    VStack(alignment: .leading) {
//                        Text("평가금액")
//                            .foregroundStyle(.gray)
//                        Text("평가 금액: \(expense.evaluationAmount, specifier: "%.2f")원") // 평가금액 계산된 값 사용
//                    }
//                    Spacer()
//                    VStack(alignment: .trailing) {
//                        Text("매수금액")
//                            .foregroundStyle(.gray)
//                        Text("\(expense.totalPurchaseAmount)원") // 매수금액 값 사용
//                    }
//                }
//            }
//        }
//        .frame(maxWidth: .infinity)
//        .padding(.horizontal, 10)
//        .padding(.vertical, 20)
//        .background(Color.gray.opacity(0.1))
//        .cornerRadius(10)
//    }
//
//    private func formatDate(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        return formatter.string(from: date)
//    }
//}
//
//
//
//
//extension ExpenseListView {
//    
//    @ViewBuilder
//    func CustomSegmentedControl() -> some View {
//        HStack(spacing: 0) {
//            ForEach([ExpenseType.all,  ExpenseType.expense, ExpenseType.income], id: \.rawValue) { tab in
//                Text(tab.rawValue.capitalized)
//                    .fontWeight(.semibold)
//                    .foregroundStyle(newExpenseViewModel.selectedType == tab ? .white : .black)
//                    .opacity(newExpenseViewModel.selectedType == tab ? 1 : 0.7)
//                    .padding(.vertical, 12)
//                    .frame(maxWidth: .infinity)
//                    .background {
//                        if newExpenseViewModel.selectedType == tab {
//                            RoundedRectangle(cornerRadius: 10, style: .continuous)
//                                .fill(
//                                    LinearGradient(colors: [
//                                        Color("Gradient1"),
//                                        Color("Gradient2"),
//                                        Color("Gradient3")
//                                    ], startPoint: .topLeading, endPoint: .bottomTrailing)
//                                )
//                                .matchedGeometryEffect(id: "TAB", in: animation)
//                        }
//                    }
//                    .contentShape(Rectangle())
//                    .onTapGesture {
//                        withAnimation {
//                            newExpenseViewModel.selectedType = tab
//                        }
//                    }
//            }
//        }
//        .padding(5)
//        .background {
//                  RoundedRectangle(cornerRadius: 10, style: .continuous) // 배경을 둥글게 처리
//                      .fill(Color("BG")) // 둥근 모서리 안쪽에 배경 색상을 설정
//                     // .shadow(radius: 5) // 그림자 추가 (선택 사항)
//              }
//    }
//}
//
//
//extension ExpenseListView {
//    func formatDate(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.locale = Locale(identifier: "ko_KR")
//        formatter.dateFormat = "yyyy/M/d일"
//        return formatter.string(from: date)
//    }
//}
//
//
