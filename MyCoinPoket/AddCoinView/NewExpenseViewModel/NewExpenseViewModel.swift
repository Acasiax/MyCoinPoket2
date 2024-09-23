//
//  NewExpenseViewModel.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/24/24.
//

import Foundation
import Combine

// MARK: - Expense Model And Sample Data
class Expense: Identifiable, ObservableObject, Hashable {
    var id = UUID().uuidString
    @Published  var coinName: String // 코인 이름
    @Published  var coinMarketName: String // 코인 마켓 이름
    @Published  var numberOfCoins: Double // 보유한 코인의 수량
    @Published var buyPrice: Double // 구매할 때 가격
    @Published var resultPrice: Double // 구매할 때 코인의 수량 * 구매할 때 가격 = 내가 지불한 금액
    @Published var date: Date
    @Published var myselectedType: ExpenseType = .all
    @Published var isAnimated: Bool = true

    @Published var livePrice: String
    @Published var profitRatePersent: Double = 0.0 //수익률
    @Published var myResult:  Double = 0.0 //평가손익 (그래서 내 돈의 결과)

    // 총 매수 금액 속성 추가
       @Published var totalPurchaseAmount: Double = 0.0

    // 평가금액 계산: 코인 수량 * 실시간 가격
    @Published var evaluationAmount: Double = 0.0
    
    
    //매수평균가
    @Published var averagePurchasePrice: Double = 0.0
    
    
    var wowexpenseType: ExpenseType {
        if myResult > 0 {
            return .income
        } else {
            return .expense
        }
    }

    
    
    init(coinName: String, coinMarketName: String, numberOfCoins: Double, buyPrice: Double, resultPrice: Double, date: Date, selectedType: ExpenseType, livePrice: String = "0", profitLoss: String = "", evaluationAmount: Double = 0) {
        self.coinName = coinName
        self.coinMarketName = coinMarketName
        self.numberOfCoins = numberOfCoins
        self.buyPrice = buyPrice
        self.resultPrice = resultPrice
        self.date = date
       // self.selectedType = selectedType
        self.myselectedType = .expense
        self.livePrice = livePrice
        self.totalPurchaseAmount = resultPrice
        self.evaluationAmount = evaluationAmount
        
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Expense, rhs: Expense) -> Bool {
        return lhs.id == rhs.id
    }
}




enum ExpenseType: String {
    case income = "수익"
    case expense = "손실"
    case all = "ALL"
}

var sample_expenses: [Expense] = [
   Expense(coinName: "도지코인", coinMarketName: "KRW-DOGE", numberOfCoins: 1, buyPrice: 200, resultPrice: 200, date: Date(timeIntervalSince1970: 1652987245), selectedType: .income)
]

// MARK: - ViewModel
class NewExpenseViewModel: ObservableObject {
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
    @Published var expenses: [Expense] = sample_expenses
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
        observeWebSocket() // 웹소켓 관찰 시작
        observeWebSocket1() //자산 추가할때 실시간 값 나오게 하는거
      
    }
    

    
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
    
    
    // 모든 `Expense` 객체의 `coinMarketName`을 수집하여 웹소켓에 전송하는 함수
       func fetchLivePriceForAllCoins() {
           // expenses 배열에서 모든 coinMarketName을 추출하여 배열로 만든다.
           let allMarketCodes = expenses.map { $0.coinMarketName }
           
           // 중복된 마켓 코드를 제거하기 위해 Set으로 변환 후 다시 배열로 변환
           let uniqueMarketCodes = Array(Set(allMarketCodes))
           
           // 웹소켓에 전송
           WebSocketManager.shared.send(marketCodes: uniqueMarketCodes)
           
           print("웹소켓에 전송된 마켓 코드: \(uniqueMarketCodes)")
       }
    
    
    
    // 웹소켓 관찰
    func observeWebSocket() {
        
         WebSocketManager.shared.openWebSocket()

         WebSocketManager.shared.tickerSubject
             .receive(on: DispatchQueue.main)
             .sink { [weak self] ticker in
                 guard let self = self else { return }
                // print("수신된 티커 데이터: \(ticker.code), 가격: \(ticker.trade_price)")
                 
                 // 모든 Expense 객체의 coinMarketName과 수신된 ticker의 code를 비교하여 업데이트
                 for expense in self.expenses {
                     if expense.coinMarketName == ticker.code {
                         expense.livePrice = String(ticker.trade_price) // 실시간 가격을 업데이트
                     //    print("업데이트된 \(expense.coinName)의 실시간 가격: \(expense.livePrice)")
                         updateEvaluationAmount(for: expense) //평가금액
                         updateaveragePurchasePrice(for: expense) //평균매수가
                         updateprofitLoss(for: expense) //수익률
                         updateMyResult(for: expense)
                         
                     }
                 }
             }
             .store(in: &cancellable)
     }
     
    
    // 실시간 가격을 받아온 후에 저장하는 로직
    func saveExpense(coinName: String, coinMarketName: String, numberOfCoins: Double, buyPrice: Double, resultPrice: Double, date: Date, selectedType: ExpenseType) {
        print(#function)
        // 이미 동일한 coinMarketName을 가진 Expense가 있는지 확인
        if let existingExpenseIndex = findExistingExpense(coinMarketName: coinMarketName) {
            
            let existingExpense = self.expenses[existingExpenseIndex]
            
            // 새로운 코인 추가 후 총 매수 금액 계산
              calculateTotalPurchaseAmount88(for: coinMarketName, newNumberOfCoins: numberOfCoins, newBuyPrice: buyPrice)
          
         
            
            // 기존 Expense가 있으면 업데이트
            updateExistingExpense(index: existingExpenseIndex, numberOfCoins: numberOfCoins, buyPrice: buyPrice)
            
            
            updateEvaluationAmount(for: existingExpense)
            
            resetFields()
            
            
        } else {
            // 없으면 새로운 Expense 추가
            addNewExpense(coinName: coinName, coinMarketName: coinMarketName, numberOfCoins: numberOfCoins, buyPrice: buyPrice, resultPrice: resultPrice, date: date, selectedType: selectedType)
            
            
            
        }
        
        // 업데이트 또는 추가 후 모든 코인의 실시간 가격 요청
        fetchLivePriceForAllCoins()
    }

    
    private func addNewExpense(coinName: String, coinMarketName: String, numberOfCoins: Double, buyPrice: Double, resultPrice: Double, date: Date, selectedType: ExpenseType) {
        print(#function)
        // 새로운 Expense 생성 및 추가
        let newExpense = Expense(
           
            coinName: coinName,
            coinMarketName: coinMarketName,
            numberOfCoins: numberOfCoins,
            buyPrice: buyPrice,
            resultPrice: resultPrice,
            date: date,
            selectedType: selectedType
        )

        // 배열에 추가
        self.expenses.append(newExpense)
      //  print(newExpense)
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




