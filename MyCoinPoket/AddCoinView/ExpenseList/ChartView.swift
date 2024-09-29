//
//  ChartView.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/24/24.
//

import SwiftUI
import Charts
import RealmSwift

struct ChartView: View {
    var expenses: [Expense]
    @Binding var chartType: ChartType
    
    var body: some View {
        
        VStack {
            
            Picker("Chart Type", selection: $chartType) {
                ForEach(ChartType.allCases, id: \.self) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            // 도넛 차트 가운데에 텍스트 추가
           
            
            switch chartType {
            case .pie:
                PieChartView(expenses: expenses)
            case .bar:
                BarChartView(expenses: expenses)
                
            }
        }
    }
}

struct PieChartView: View {
    var expenses: [Expense]
    
    var body: some View {
        VStack {
            ZStack {
                Chart {
                    ForEach(expenses) { expense in
                        SectorMark(
                            angle: .value("Coin Holding Quantity", expense.numberOfCoins), // 보유 수량을 기준으로 설정
                            innerRadius: .ratio(0.5),
                            angularInset: 2
                        )
                        .foregroundStyle(by: .value("Coin", expense.coinName))
                    }
                }
                .frame(height: 300)
                .padding()
                
                // 도넛 차트 가운데에 텍스트 추가
                Text("보유수량")
                    .font(.system(size: 15))
                    
            }
        }
    }
}


struct BarChartView: View {
    var expenses: [Expense]
    
    var body: some View {
        Chart {
            ForEach(expenses) { expense in
                BarMark(
                    x: .value("Coin", expense.coinName),
                    y: .value("Holding Quantity", expense.numberOfCoins) // Y축을 보유 수량으로 설정
                )
                .foregroundStyle(by: .value("Coin", expense.coinName))
            }
        }
        .frame(height: 300)
        .padding()
    }
}
