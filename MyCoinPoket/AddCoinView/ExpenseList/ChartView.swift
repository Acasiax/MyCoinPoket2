//
//  ChartView.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/24/24.
//

//import SwiftUI
//import Charts
//import RealmSwift
//
//struct ChartView: View {
//    @ObservedResults(Expense.self) var expenses // Realm에서 바로 데이터를 가져옴
//    @State private var trigger: Bool = false
//    @State private var chartType: ChartType = .pie
//   
//    var body: some View {
//
//        LazyVStack {
//            Section("차트 종류") {
//                Picker("", selection: $chartType) {
//                    ForEach(ChartType.allCases, id: \.rawValue) {
//                        Text($0.rawValue)
//                            .tag($0)
//                    }
//                }
//                .pickerStyle(.segmented)
//            }
//            
//            Section("나의 포트폴리오") {
//                Chart {
//                    ForEach(expenses) { expense in
//                       
//                        if chartType == .pie {
//                            SectorMark(
//                                angle: .value("총소비가격", expense.isAnimated ? expense.totalPurchaseAmount : 0),
//                                innerRadius: .fixed(61),
//                                angularInset: 1
//                            )
//                            .foregroundStyle(by: .value("Remark", expense.coinName))
//                        } else if chartType == .bar {
//                            BarMark(
//                                x: .value("코인 이름", expense.coinName),
//                                y: .value("결과값", expense.isAnimated ? expense.totalPurchaseAmount : 0)
//                            )
//                            .foregroundStyle(by: .value("Remark", expense.coinName))
//                            
//                        } else if chartType == .line {
//                            LineMark(
//                                x: .value("코인 이름", expense.coinName),
//                                y: .value("결과값", expense.isAnimated ? expense.totalPurchaseAmount : 0)
//                            )
//                            .interpolationMethod(.catmullRom)
//                            .foregroundStyle(.green.gradient)
//                            .symbol {
//                                Circle()
//                                    .fill(.green)
//                                    .frame(width: 10, height: 10)
//                            }
//                            .opacity(expense.isAnimated ? 1 : 0)
//                        }
//                    }
//                }
//                .chartYScale(domain: 0...(expenses.map { $0.resultPrice }.max() ?? 12000))
//                .frame(height: 250)
//                .chartLegend(chartType == .bar ? .hidden : .visible)
//                .onAppear {
//                    for expense in expenses {
//                        print("총 가격:", expense.totalPurchaseAmount)
//                    }
//                }
//            }
//        }
//        .onAppear(perform: animateChart)
//        .onChange(of: expenses) {
//            animateChart()
//        }
//        .onChange(of: trigger) {
//            resetChartAnimation()
//            animateChart()
//        }
//        .onChange(of: chartType) {
//            resetChartAnimation()
//            animateChart()
//        }
//    }
//
//    // MARK: Animating Chart
//    private func animateChart() {
//        print(#function)
//        
//        for (index, _) in expenses.enumerated() {
//            print("expense.isAnimated(\(index)): \(expenses[index].isAnimated)")
//            
//            if !expenses[index].isAnimated {
//                let delay = Double(index) * 0.05
//                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
//                    withAnimation(.easeInOut(duration: 0.5)) {
//                        expenses[index].isAnimated = true
//                        print("expense.isAnimated📍(\(index)): \(expenses[index].isAnimated)")
//                    }
//                }
//            }
//        }
//    }
//
//    // MARK: Resetting Chart Animation
//    private func resetChartAnimation() {
//        print(#function)
//        for index in expenses.indices {
//            expenses[index].isAnimated = false
//            print("무야호")
//            print(expenses[index].isAnimated)
//        }
//    }
//
//    // 날짜 포맷팅 함수
//    func formatDate(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        return formatter.string(from: date)
//    }
//    
//    enum ChartType: String, CaseIterable {
//        case pie = "원형"
//        case bar = "막대기"
//        case line = "선"
//    }
//}
//
//#Preview {
//    ChartView()
//}
