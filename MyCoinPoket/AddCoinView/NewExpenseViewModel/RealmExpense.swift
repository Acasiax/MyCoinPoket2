//
//  RealmExpense.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/28/24.
//

//import Foundation
//import Combine
//import RealmSwift
//
//class Expense: Object, ObjectKeyIdentifiable {
//    @Persisted(primaryKey: true) var id: ObjectId
//    @Persisted var coinName: String = "" // 코인 이름
//    @Persisted var coinMarketName: String = "" // 코인 마켓 이름
//    @Persisted var numberOfCoins: Double = 0.0 // 보유한 코인의 수량
//    @Persisted var totalPurchaseAmount: Double = 0.0 // 총 매수 금액
//    @Persisted var buyPrice: Double = 0.0
//    @Persisted var resultPrice: Double = 0.0
//    
//    convenience init(coinName: String, coinMarketName: String, numberOfCoins: Double, buyPrice: Double, resultPrice: Double, totalPurchaseAmount: Double) {
//        self.init()  // Realm의 기본 이니셜라이저 호출
//        self.coinName = coinName
//        self.coinMarketName = coinMarketName
//        self.numberOfCoins = numberOfCoins
//        self.buyPrice = buyPrice
//        self.resultPrice = resultPrice
//        self.totalPurchaseAmount = totalPurchaseAmount
//        
//    }
//}

