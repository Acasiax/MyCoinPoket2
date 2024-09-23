//
//  ExpenseListView.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/24/24.
//

import SwiftUI

struct ExpenseListView: View {
    @ObservedObject var newExpenseViewModel: NewExpenseViewModel
    @Namespace var animation
   
  var filteredExpenses: [Expense] {
        // 사용자가 세그먼트 컨트롤에서 "전체"를 선택한 경우, 모든 expenses를 반환
        if newExpenseViewModel.selectedType == .all {
            return newExpenseViewModel.expenses
        } else {
            // 사용자가 "수익" 또는 "손실"을 선택한 경우, 해당 wowexpenseType과 일치하는 expenses만 필터링하여 반환
            return newExpenseViewModel.expenses.filter { $0.wowexpenseType == newExpenseViewModel.selectedType }
        }
    }
    
    var body: some View {
        
        
        ChartView(newExpenseViewModel: newExpenseViewModel)
            .padding(.horizontal, 15)
         
  
        
        ScrollView {
            CustomSegmentedControl()
                .padding(.top)
            
            LazyVStack(alignment: .leading, spacing: 12) {
                ForEach(filteredExpenses) { expense in
                    ExpenseRowView(expense: expense, viewModel: newExpenseViewModel)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 20)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                }
                .animation(.easeInOut, value: filteredExpenses)
                .padding(.horizontal, 20)
            }
            .padding(.top)
        }
        .navigationTitle("저장된 자산")
    }
    


}



// 새로운 ExpenseRowView🔥
struct ExpenseRowView: View {
    @ObservedObject var expense: Expense // Expense가 클래스이므로 @ObservedObject 사용
    @ObservedObject var viewModel: NewExpenseViewModel

    var body: some View {
        VStack {
            HStack {
                Text(expense.coinName)
                    .fontWeight(.bold)
                Text(expense.coinMarketName)
                    .foregroundStyle(.gray)

                Spacer()

                VStack(alignment: .trailing) {
                    Text("평가손익  \(expense.myResult)원")
                        .font(.callout)
                    
                    Text("수익률  \(expense.profitRatePersent)")
                        .font(.callout)
                    Text("실시간 현재가  \(expense.livePrice)원")
                        .font(.callout)
                    Text("날짜  \(formatDate(expense.date))")
                        .font(.caption)
                    Text("방금추가한 총액: \(expense.resultPrice)")
                        .font(.caption)
                }
            }

            Divider()

            VStack(spacing: 10) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("보유수량  (마켓티커)")
                            .foregroundStyle(.gray)
                        Text("\(expense.numberOfCoins)개")
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("매수평균가")
                            .foregroundStyle(.gray)
                        Text("\(expense.averagePurchasePrice)원") // 매수평균가 계산된 값 사용
                    }
                }

                HStack {
                    VStack(alignment: .leading) {
                        Text("평가금액")
                            .foregroundStyle(.gray)
                        Text("평가 금액: \(expense.evaluationAmount, specifier: "%.2f")원") // 평가금액 계산된 값 사용
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("매수금액")
                            .foregroundStyle(.gray)
                        Text("\(expense.totalPurchaseAmount)원") // 매수금액 값 사용
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

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}




extension ExpenseListView {
    
    @ViewBuilder
    func CustomSegmentedControl() -> some View {
        HStack(spacing: 0) {
            ForEach([ExpenseType.all,  ExpenseType.expense, ExpenseType.income], id: \.rawValue) { tab in
                Text(tab.rawValue.capitalized)
                    .fontWeight(.semibold)
                    .foregroundStyle(newExpenseViewModel.selectedType == tab ? .white : .black)
                    .opacity(newExpenseViewModel.selectedType == tab ? 1 : 0.7)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background {
                        if newExpenseViewModel.selectedType == tab {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(
                                    LinearGradient(colors: [
                                        Color("Gradient1"),
                                        Color("Gradient2"),
                                        Color("Gradient3")
                                    ], startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                                .matchedGeometryEffect(id: "TAB", in: animation)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation {
                            newExpenseViewModel.selectedType = tab
                        }
                    }
            }
        }
        .padding(5)
        .background {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(.white)
        }
    }
}


extension ExpenseListView {
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy/M/d일"
        return formatter.string(from: date)
    }
}


