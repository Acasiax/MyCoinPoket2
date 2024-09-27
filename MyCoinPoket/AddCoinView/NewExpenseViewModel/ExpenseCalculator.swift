//
//  ExpenseCalculator.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/24/24.
//

import SwiftUI
import RealmSwift

extension NewExpenseViewModel {
    
    func updateEvaluationAmount(for expense: Expense) {
         // Realm 객체가 관리되고 있는 상태인지 확인
         if let realm = expense.realm {
             // Realm에 관리되는 객체이므로 트랜잭션 내에서 수정해야 함
             do {
                 try realm.write {
                     if let livePriceValue = Double(expense.livePrice) {
                         // 평가 금액 계산
                         expense.evaluationAmount = expense.numberOfCoins * livePriceValue
                     } else {
                         print("실패: 실시간 가격을 Double로 변환할 수 없습니다. livePrice: \(expense.livePrice)")
                     }
                 }
             } catch {
                 print("Realm 트랜잭션 오류: \(error.localizedDescription)")
             }
         } else {
             // Realm에 관리되지 않는 객체일 경우, 직접 수정 가능
             if let livePriceValue = Double(expense.livePrice) {
                 // 평가 금액 계산
                 expense.evaluationAmount = expense.numberOfCoins * livePriceValue
             } else {
                 print("실패: 실시간 가격을 Double로 변환할 수 없습니다. livePrice: \(expense.livePrice)")
             }
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
    func findExistingExpense(coinMarketName: String) -> Expense? {
        do {
            let realm = try Realm()
            let matchingExpense = realm.objects(Expense.self).filter("coinMarketName == %@", coinMarketName).first
            if let expense = matchingExpense {
                print("일치하는 항목 발견: \(expense.coinMarketName)")
                return expense
            } else {
                print("일치하는 항목을 찾지 못했습니다.")
                return nil
            }
        } catch {
            print("Realm에서 데이터를 조회하는 중 오류 발생: \(error.localizedDescription)")
            return nil
        }
    }



    func updateExistingExpense(existingExpense: Expense, numberOfCoins: Double, buyPrice: Double) {
        do {
            let realm = try Realm() // Realm 인스턴스 생성

            try realm.write {  // 트랜잭션 시작
                // 코인 수량을 업데이트
                existingExpense.numberOfCoins += numberOfCoins
                
                // 코인 수량을 업데이트한 후 resultPrice를 재계산
                existingExpense.resultPrice = calculateTotalPurchaseAmount(numberOfCoins: existingExpense.numberOfCoins, purchasePrice: buyPrice)
                
                // 실시간 가격, 수익/손실 등 기타 값 업데이트
                existingExpense.livePrice = self.livePrice
                
                // 필요 시 수익/손실 유형도 업데이트
                existingExpense.myselectedType = selectedType
            }  // 트랜잭션 끝
            
        } catch {
            print("Realm 트랜잭션 오류: \(error.localizedDescription)")
        }
    }



      
      
   
 
    // 총 매수 금액을 계산하는 함수

    func calculateTotalPurchaseAmount88(for coinMarketName: String, newNumberOfCoins: Double, newBuyPrice: Double) {
        print(#function)
        do {
            let realm = try Realm()

            // 동일한 코인 마켓 이름을 가진 Expense가 있는지 Realm에서 확인
            if let existingExpense = realm.objects(Expense.self).filter("coinMarketName == %@", coinMarketName).first {
                
                // 새로 계산된 매수 금액 (수량 x 매수가)
                let newResultPrice = newNumberOfCoins * newBuyPrice
                
                // Realm 트랜잭션 내에서 수정
                try realm.write {
                    // 총 매수 금액 = 기존 총 매수 금액 + 새로운 매수 금액
                    existingExpense.totalPurchaseAmount += newResultPrice
                }
                
                print("기존에 존재하는 코인 발견: \(existingExpense.coinName) (\(existingExpense.coinMarketName))")
                print("새로운 총 매수 금액 (기존 + 새로운): \(existingExpense.totalPurchaseAmount)")

            } else {
                // 해당 코인이 없으면 새로운 매수 금액만 계산
              //  let newResultPrice = newNumberOfCoins * newBuyPrice
              //  totalPurchaseAmount = newResultPrice
                print("해당 코인이 없어 새로운 매수 금액만 계산: \(totalPurchaseAmount)")
            }
            
            print("=== 총 매수 금액 계산 완료 ===")
            
        } catch {
            print("Realm 트랜잭션 오류: \(error.localizedDescription)")
        }
    }


      
    
}


