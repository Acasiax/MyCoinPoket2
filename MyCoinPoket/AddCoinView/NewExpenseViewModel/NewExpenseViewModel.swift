//
//  NewExpenseViewModel.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/24/24.
//

import Foundation
import Combine
import RealmSwift

// MARK: - ViewModel
class ExpenseViewModel: Identifiable, ObservableObject, Hashable {
    let id: ObjectId
    @Published var coinName: String
    @Published var coinMarketName: String
    @Published var numberOfCoins: Double
    @Published var totalPurchaseAmount: Double
    @Published var livePrice: String
    @Published var profitRatePercent: Double = 0.0
    @Published var myResult: Double = 0.0
    @Published var selectedType: ExpenseType = .all

    // 평가금액 계산: 코인 수량 * 실시간 가격
    @Published var evaluationAmount: Double = 0.0

    var wowexpenseType: ExpenseType {
        return myResult > 0 ? .income : .expense
    }

    init(expense: Expense) {
      
        self.id = expense.id
        self.coinName = expense.coinName
        self.coinMarketName = expense.coinMarketName
        self.numberOfCoins = expense.numberOfCoins
        self.totalPurchaseAmount = expense.totalPurchaseAmount
        self.livePrice = "0" // 초기값 설정
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: ExpenseViewModel, rhs: ExpenseViewModel) -> Bool {
        return lhs.id == rhs.id
    }
}





enum ExpenseType: String {
    case income = "수익"
    case expense = "손실"
    case all = "ALL"
}

var sample_expenses: [Expense] = [
  // Expense(coinName: "도지코인", coinMarketName: "KRW-DOGE", numberOfCoins: 1, buyPrice: 200, resultPrice: 200, date: Date(timeIntervalSince1970: 1652987245), selectedType: .income)
]

// MARK: - ViewModel
class NewExpenseViewModel: ObservableObject {
    @ObservedResults(Expense.self) var realmExpenses
    //@Published var expenseViewModels: [ExpenseViewModel] = []
    @Published var expenseViewModels: [ObjectId: ExpenseViewModel] = [:]
    // 총 구입한 매수 금액을 저장할 변수
    @Published var totalPurchaseAmount: Double = 0.0
    @Published var resultPrice: String = ""
    @Published var profitLoss: String = ""
    @Published var rateOfReturn: String = ""
    @Published var averagePurchasePrice: String = ""
    @Published var livePrice: String = "0" // 실시간 현재가
    @Published var coinName: String = ""
    @Published var coinMarketName: String = "" // 마켓 이름
    @Published var selectedType: ExpenseType = .all
    @Published var date: Date = Date()
    @Published var isNavigate: Bool = false
    //  @Published var expenses: [Expense] = sample_expenses
    @Published var selectedCurrency: String = "KRW"
    @Published var totalPriceByMarket: [String: Double] = [:]
    @Published var averagePriceByMarket: [String: Double] = [:]
    
    @Published var numberOfCoins: String = "" {
        didSet {
            calculateResult()
        }
    }
    
    @Published var buyPrice: String = "" {
        didSet {
            calculateResult()
        }
    }
    
    
    private var cancellable = Set<AnyCancellable>()
    
    
    init() {
           updateExpenseViewModels()

           realmExpenses.observe { [weak self] changes in
               guard let self = self else { return }
               switch changes {
               case .initial, .update:
                   self.updateExpenseViewModels()
               case .error(let error):
                   print("Realm 변경 오류: \(error.localizedDescription)")
               }
           }
           
           observeWebSocket()
           observeWebSocket1()
       }

       private func updateExpenseViewModels() {
           for expense in realmExpenses {
               if expenseViewModels[expense.id] == nil {
                   expenseViewModels[expense.id] = ExpenseViewModel(expense: expense)
               }
           }
       }
       
       func getExpenseViewModel(for expense: Expense) -> ExpenseViewModel {
           if let existingViewModel = expenseViewModels[expense.id] {
               return existingViewModel
           } else {
               let newViewModel = ExpenseViewModel(expense: expense)
               expenseViewModels[expense.id] = newViewModel
               return newViewModel
           }
       }


 

    
    
//    init() {
//  
//        
//        fetchLivePriceForAllCoins()
//        // 초기화 시, Realm에서 가져온 expenses를 ExpenseViewModel로 변환
//        self.expenseViewModels = realmExpenses.map { ExpenseViewModel(expense: $0) }
//        
//        observeWebSocket() // 웹소켓 관찰 시작
//        observeWebSocket1() //자산 추가할때 실시간 값 나오게 하는거
//      
//    }
    

    
    // 웹소켓을 통해 실시간 가격을 업데이트하는 메서드 (이거는 struct NewExpense에 사용하는 거임)
    func observeWebSocket1() {
        WebSocketManager.shared.openWebSocket()
        
        WebSocketManager.shared.tickerSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] ticker in
                guard let self = self else { return }
              //  print("수신된 티커 데이터: \(ticker.code), 가격: \(ticker.trade_price)")
                // 현재 저장하려는 코인 마켓에 맞는 실시간 가격을 업데이트
                if ticker.code == self.coinMarketName {
                  //  print("===\(String(ticker.trade_price))")
                    self.livePrice = String(ticker.trade_price)
                    // 실시간 가격을 받은 후에 계산을 실행
                    self.calculateResult()
                   
                }
            }
            .store(in: &cancellable)
    }
    
    
    // 모든 Expense 객체의 coinMarketName을 수집하여 웹소켓에 전송하는 함수🌟
        func fetchLivePriceForAllCoins() {
            // expenses 배열에서 모든 coinMarketName을 추출하여 배열로 만든다.
            let allMarketCodes = realmExpenses.map { $0.coinMarketName }
            
            // 중복된 마켓 코드를 제거하기 위해 Set으로 변환 후 다시 배열로 변환
            let uniqueMarketCodes = Array(Set(allMarketCodes))
            
            // 웹소켓에 전송
            WebSocketManager.shared.send(marketCodes: uniqueMarketCodes)
            
            print("웹소켓에 전송된 마켓 코드: \(uniqueMarketCodes)")
        }
     
    
    
    // 웹소켓 관찰
    // 웹소켓 관찰🌟
    
    func observeWebSocket() {
        WebSocketManager.shared.openWebSocket()

        WebSocketManager.shared.tickerSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] ticker in
                guard let self = self else { return }
                if let viewModel = self.expenseViewModels.values.first(where: { $0.coinMarketName == ticker.code }) {
                    viewModel.livePrice = String(ticker.trade_price)
                    //viewModel.evaluationAmount = viewModel.numberOfCoins * (Double(viewModel.livePrice) ?? 0.0)
                   // updateEvaluationAmount(for: expenseViewModel)
                }
            }
            .store(in: &cancellable)
    }

    
//    func observeWebSocket() {
//         
//          WebSocketManager.shared.openWebSocket()
//
//          WebSocketManager.shared.tickerSubject
//              .receive(on: DispatchQueue.main)
//              .sink { [weak self] ticker in
//                  guard let self = self else { return }
//                //  print("수신된 티커 데이터: \(ticker.code), 가격: \(ticker.trade_price)")
//             
////                   모든 Expense 객체의 coinMarketName과 수신된 ticker의 code를 비교하여 업데이트
//                  for expenseViewModel in self.expenseViewModels {
//                      if expenseViewModel.coinMarketName == ticker.code {
//                          
//                          expenseViewModel.livePrice = String(ticker.trade_price) // 실시간 가격을 업데이트
//                         print("업데이트된 \(expenseViewModel.coinName)의 실시간 가격: \(expenseViewModel.livePrice)")
//                          
//                          updateEvaluationAmount(for: expenseViewModel) //평가금액
////                          updateaveragePurchasePrice(for: expense) //평균매수가
////                          updateprofitLoss(for: expense) //수익률
////                          updateMyResult(for: expense)
//                          
//                      }
//                  }
//              }
//              .store(in: &cancellable)
//      }
    
    
//    func observeWebSocket() {
//           WebSocketManager.shared.openWebSocket()
//           WebSocketManager.shared.tickerSubject
//               .receive(on: DispatchQueue.main)
//               .sink { [weak self] ticker in
//                   guard let self = self else { return }
//                     print("수신된 티커 데이터: \(ticker.code), 가격: \(ticker.trade_price)")
//                   // 모든 ExpenseViewModel의 coinMarketName과 수신된 ticker의 code를 비교하여 업데이트
//                   for expenseViewModel in self.expenseViewModels {
//                       if expenseViewModel.coinMarketName == ticker.code {
//                           expenseViewModel.livePrice = String(ticker.trade_price)
//                           expenseViewModel.evaluationAmount = expenseViewModel.numberOfCoins * (Double(expenseViewModel.livePrice) ?? 0.0)
//                           expenseViewModel.myResult = expenseViewModel.evaluationAmount - expenseViewModel.totalPurchaseAmount
//                           expenseViewModel.profitRatePercent = (expenseViewModel.myResult / expenseViewModel.totalPurchaseAmount) * 100
//                       }
//                   }
//               }
//               .store(in: &cancellable)
//       }

    
//    func observeWebSocket() {
//        
//         WebSocketManager.shared.openWebSocket()
//
//         WebSocketManager.shared.tickerSubject
//             .receive(on: DispatchQueue.main)
//             .sink { [weak self] ticker in
//                 guard let self = self else { return }
//                // print("수신된 티커 데이터: \(ticker.code), 가격: \(ticker.trade_price)")
//                 
//                 // 모든 Expense 객체의 coinMarketName과 수신된 ticker의 code를 비교하여 업데이트
//                 for expense in self.expenses {
//                     if expense.coinMarketName == ticker.code {
//                         expense.livePrice = String(ticker.trade_price) // 실시간 가격을 업데이트
//                         print("업데이트된 \(expense.coinName)의 실시간 가격: \(expense.livePrice)")
//                         updateEvaluationAmount(for: expense) //평가금액
//                         updateaveragePurchasePrice(for: expense) //평균매수가
//                         updateprofitLoss(for: expense) //수익률
//                         updateMyResult(for: expense)
//                         
//                     }
//                 }
//             }
//             .store(in: &cancellable)
//     }
     
    
    // 실시간 가격을 받아온 후에 저장하는 로직
    func saveExpense(coinName: String, coinMarketName: String, numberOfCoins: Double, buyPrice: Double, resultPrice: Double, date: Date, selectedType: ExpenseType) {
        print(#function)
        
        do {
            let realm = try Realm()
            
            // 동일한 coinMarketName을 가진 Expense가 있는지 확인
            if let existingExpense = realm.objects(Expense.self).filter("coinMarketName == %@", coinMarketName).first {
                
                // 새로운 코인 추가 후 총 매수 금액 계산 (트랜잭션은 calculateTotalPurchaseAmount88에서 처리)
                calculateTotalPurchaseAmount88(for: coinMarketName, newNumberOfCoins: numberOfCoins, newBuyPrice: buyPrice)
                
                // 보유수량 업데이트
                updateExistingExpense(existingExpense: existingExpense, numberOfCoins: numberOfCoins, buyPrice: buyPrice)
                
                // 평가 금액 업데이트 (이 작업도 트랜잭션 없이 수행 가능)
              //  updateEvaluationAmount(for: existingExpense)
                
                resetFields()
                
            } else {
                // 없으면 새로운 Expense 추가
                addNewExpense(coinName: coinName, coinMarketName: coinMarketName, numberOfCoins: numberOfCoins, buyPrice: buyPrice, resultPrice: resultPrice, date: date, selectedType: selectedType)
            }
            
            // 업데이트 또는 추가 후 모든 코인의 실시간 가격 요청
            fetchLivePriceForAllCoins()
            
        } catch {
            print("Realm 트랜잭션 오류: \(error.localizedDescription)")
        }
    }






    //새로운 코인일때!
    private func addNewExpense(coinName: String, coinMarketName: String, numberOfCoins: Double, buyPrice: Double, resultPrice: Double, date: Date, selectedType: ExpenseType) {
        print(#function)
        
        let newExpense = Expense(
            coinName: coinName,
            coinMarketName: coinMarketName,
            numberOfCoins: numberOfCoins,
            buyPrice: buyPrice,
            resultPrice: resultPrice,
            totalPurchaseAmount: resultPrice // 초기화 시 totalPurchaseAmount는 resultPrice로 설정
        )
        
        // Realm 트랜잭션을 사용하여 데이터를 저장
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(newExpense)
            }
        } catch {
            print("Realm에 데이터를 저장하는 중 오류 발생: \(error)")
        }

        // 필드 초기화 함수 호출
        resetFields()
    }

  
    // 선택한 코인 마켓을 사용하여 웹소켓에 요청
    func fetchLivePriceForCoin() {
        WebSocketManager.shared.send(marketCodes: [coinMarketName])
    }
    

    // 필드 초기화 함수
    func resetFields() {
        coinName = ""
        coinMarketName = ""
        numberOfCoins = ""
        buyPrice = ""
        resultPrice = ""
        profitLoss = ""
        rateOfReturn = ""
        selectedType = .all
        date = Date()
    }
}




