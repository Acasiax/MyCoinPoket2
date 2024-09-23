//
//  ExpenseCalculator.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/24/24.
//

import SwiftUI

extension NewExpenseViewModel {
    
    func updateEvaluationAmount(for expense: Expense) {
      //  print(#function)
        // livePrice를 Double로 변환할 수 있는지 확인
        if let livePriceValue = Double(expense.livePrice) {
            // 코인 수량과 실시간 가격을 출력
         //   print("코인 수량: \(expense.numberOfCoins)")
           // print("실시간 가격: \(livePriceValue)")
            
            // 평가 금액 계산
            expense.evaluationAmount = expense.numberOfCoins * livePriceValue
            
            // 계산된 평가 금액 출력
        //    print("계산된 평가 금액: \(expense.evaluationAmount)")
        } else {
            // livePrice가 유효한 숫자가 아닌 경우 경고 메시지 출력
            print("실패: 실시간 가격을 Double로 변환할 수 없습니다. livePrice: \(expense.livePrice)")
        }
    }

    
    
    func updateaveragePurchasePrice(for expense: Expense) {
      //  print("총매수금액 \(expense.totalPurchaseAmount)")
      //  print("총매수량 \(expense.numberOfCoins)")
        
        if expense.numberOfCoins != 0 {
            let averagePrice = expense.totalPurchaseAmount / expense.numberOfCoins
            expense.averagePurchasePrice = averagePrice
        } else {
            expense.averagePurchasePrice = 0 // 매수량이 0일 경우 처리
        }
    }

    


    // 수익률 계산
    // 수익률 계산
    func updateprofitLoss(for expense: Expense) {

        if expense.totalPurchaseAmount != 0 {
            let profitLossValue = (expense.evaluationAmount - expense.totalPurchaseAmount) / expense.totalPurchaseAmount * 100
            expense.profitRatePersent = profitLossValue
            
            // Print statements for debugging
//            print("총 매수 금액: \(expense.totalPurchaseAmount)")
//            print("평가 금액: \(expense.evaluationAmount)")
         //   print("수익률: \(String(format: "%.2f", profitLossValue))%")
        } else {
            expense.profitRatePersent = 0 // 매수 금액이 0일 경우 수익률 0으로 처리
          //  print("총 매수 금액이 0입니다. 수익률을 계산할 수 없습니다.")
        }
    }


    
    func updateMyResult(for expense: Expense) {
        
      //  print("===🩵===")
        
        expense.myResult = expense.evaluationAmount - expense.totalPurchaseAmount
        
    }
    
    
    
      // 코인의 수량과 구매 가격을 입력받아 총 구매 금액을 계산하는 함수
      func calculateTotalPurchaseAmount(numberOfCoins: Double, purchasePrice: Double) -> Double {
         // print(#function)
         
          let totalPurchaseAmount = numberOfCoins * purchasePrice
      
          return totalPurchaseAmount
      }


      
      func calculateResult() {
         // print(#function)
          let numberOfCoinsValue = Double(numberOfCoins) ?? 0
          let buyPriceValue = Double(buyPrice) ?? 0
          let livePriceValue = Double(livePrice) ?? 0
      //    let resultPriceValue = Double(resultPrice) ?? 0

          // 총 구매 금액을 계산하는 함수를 호출하여 값 할당
          let totalPurchaseAmount = calculateTotalPurchaseAmount(numberOfCoins: numberOfCoinsValue, purchasePrice: buyPriceValue)
        
          // KRW와 USD에 따른 결과값 계산
          if selectedCurrency == "KRW" {
              resultPrice = String(format: "%.0f", totalPurchaseAmount)
          } else if selectedCurrency == "USD" {
              resultPrice = String(format: "%.2f", totalPurchaseAmount)
          }

          // 구매가와 실시간 가격을 비교하여 수익/손실 선택 자동화
//          if livePriceValue > buyPriceValue {
//              selectedType = .income // 수익
//          } else if livePriceValue < buyPriceValue {
//              selectedType = .expense // 손실
//          }
//
         
          
      }

      

     
    // 동일한 coinMarketName을 가진 Expense의 인덱스를 찾는 메서드
      func findExistingExpense(coinMarketName: String) -> Int? {
          return self.expenses.firstIndex(where: { $0.coinMarketName == coinMarketName })
      }
    
    
    

      func updateExistingExpense(index: Int, numberOfCoins: Double, buyPrice: Double) {
          // 기존 Expense 업데이트
          let existingExpense = self.expenses[index]
          existingExpense.numberOfCoins += numberOfCoins
          
          // 코인 수량을 업데이트한 후 resultPrice를 재계산
          existingExpense.resultPrice = calculateTotalPurchaseAmount(numberOfCoins: existingExpense.numberOfCoins, purchasePrice: buyPrice)
          
          
          
          // 실시간 가격, 수익/손실 등 기타 값 업데이트
          existingExpense.livePrice = self.livePrice

          
          // 필요 시 수익/손실 유형도 업데이트
          existingExpense.myselectedType = selectedType
      }
      
      
      
   
 
    // 총 매수 금액을 계산하는 함수
    func calculateTotalPurchaseAmount88(for coinMarketName: String, newNumberOfCoins: Double, newBuyPrice: Double) {
//        print("=== 총 매수 금액 계산 시작 ===")
//        print("입력된 코인 마켓 이름: \(coinMarketName)")
//        print("입력된 코인 수량: \(newNumberOfCoins)")
//        print("입력된 매수가: \(newBuyPrice)")
        
        // 동일한 코인 마켓 이름을 가진 Expense가 있는지 확인
        if let existingExpenseIndex = findExistingExpense(coinMarketName: coinMarketName) {
            let existingExpense = self.expenses[existingExpenseIndex]

//            print("기존에 존재하는 코인 발견: \(existingExpense.coinName) (\(existingExpense.coinMarketName))")
//            print("기존 resultPrice: \(existingExpense.resultPrice)")
//            print("기존 총 매수 금액: \(existingExpense.totalPurchaseAmount)")

            // 새로 계산된 매수 금액 (수량 x 매수가)
            let newResultPrice = newNumberOfCoins * newBuyPrice

//            print("새로 계산된 매수 금액 (수량 x 매수가): \(newResultPrice)")

            // 총 매수 금액 = 기존 총 매수 금액 + 새로운 매수 금액
            existingExpense.totalPurchaseAmount += newResultPrice
//            print("새로운 총 매수 금액 (기존 + 새로운): \(existingExpense.totalPurchaseAmount)")
            
        } else {
            // 해당 코인이 없으면 새로운 매수 금액만 계산
            let newResultPrice = newNumberOfCoins * newBuyPrice
            totalPurchaseAmount = newResultPrice
          //  print("해당 코인이 없어 새로운 매수 금액만 계산: \(totalPurchaseAmount)")
        }
        
        print("=== 총 매수 금액 계산 완료 ===")
    }


      
    
}


