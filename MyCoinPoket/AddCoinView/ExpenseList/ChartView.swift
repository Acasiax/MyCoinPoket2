//
//  ChartView.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/24/24.
//

import SwiftUI
import Charts

struct ChartView: View {
    @ObservedObject var newExpenseViewModel: NewExpenseViewModel
    @State private var trigger: Bool = false
    @State private var chartType: ChartType = .pie
    
    var body: some View {
        NavigationStack {
            
            LazyVStack {
                Section("차트 종류") {
                    Picker("", selection: $chartType) {
                        ForEach(ChartType.allCases, id: \.rawValue) {
                            Text($0.rawValue)
                                .tag($0)
                            
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("나의 포트폴리오") {
                    Chart {
                        ForEach(newExpenseViewModel.expenses) { expense in
                           
                            if chartType == .pie {
                                SectorMark(
                                    angle: .value("총소비가격", expense.isAnimated ? expense.totalPurchaseAmount : 0),
                                    innerRadius: .fixed(61),
                                    angularInset: 1
                                )
                                .foregroundStyle(by: .value("Remark", expense.coinName))
                            } else if chartType == .bar {
                                BarMark(
                                    x: .value("코인 이름", expense.coinName),
                                    y: .value("결과값", expense.isAnimated ? expense.totalPurchaseAmount : 0)
                                )
                                .foregroundStyle(by: .value("Remark", expense.coinName))
                                
                            } else if chartType == .line {
                                LineMark(
                                    x: .value("코인 이름", expense.coinName),
                                    y: .value("결과값", expense.isAnimated ? expense.totalPurchaseAmount : 0)
                                )
                                .interpolationMethod(.catmullRom)
                                .foregroundStyle(.green.gradient)
                                .symbol {
                                    Circle()
                                        .fill(.green)
                                        .frame(width: 10, height: 10)
                                }
                                .opacity(expense.isAnimated ? 1 : 0)
                            }
                            // isAnimated 값이 변경될 때 차트를 다시 렌더링
//                             .onChange(of: expense.isAnimated) { newValue in
//                                        print("isAnimated 변경됨: \(newValue)")
//                                    }
                          
                        }
                    }
                    .chartYScale(domain: 0...(newExpenseViewModel.expenses.map { $0.resultPrice }.max() ?? 12000))
                    .frame(height: 250)
                    .chartLegend(chartType == .bar ? .hidden : .visible)
                    .onAppear {
               
                        // 여기서 모든 총 가격을 프린트
                        for expense in newExpenseViewModel.expenses {
                            print("총 가격:", expense.totalPurchaseAmount)
                        }
                            
                    }
                    
                }


            }
            .navigationTitle("내 자산 포트폴리오")
         //   .onAppear(perform: resetChartAnimation)
            .onAppear(perform: animateChart)
            .onChange(of: newExpenseViewModel.expenses) {
                animateChart()
            }

            .onChange(of: trigger) {
                resetChartAnimation()
                
               // DispatchQueue.main.asyncAfter(deadline: .now() + 5.3) {
                    animateChart()
              //  }
            }

            .onChange(of: chartType) {
              //  resetChartAnimation()
           //     animateChart()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("업데이트") {
                        trigger.toggle()
                    }
                }
            }
        }
    }
    
    // MARK: Animating Chart
    private func animateChart() {
        print(#function)
        
      //  DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            for (index, _) in newExpenseViewModel.expenses.enumerated() {
                print("expense.isAnimated(\(index)): \(newExpenseViewModel.expenses[index].isAnimated)")
                
                if !newExpenseViewModel.expenses[index].isAnimated {
                    let delay = Double(index) * 0.05
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                        // 상태 변화와 함께 차트 업데이트
                       withAnimation(.easeInOut(duration: 0.5)) {
                            newExpenseViewModel.expenses[index].isAnimated = true
                         
                            print("expense.isAnimated📍(\(index)): \(newExpenseViewModel.expenses[index].isAnimated)")
                      }
                    }
                }
            }
        }
   // }

    
    


    
    // MARK: Resetting Chart Animation
    private func resetChartAnimation() {
        print(#function)
        for index in newExpenseViewModel.expenses.indices {
            newExpenseViewModel.expenses[index].isAnimated = false
          
            print("무야호")
            print(newExpenseViewModel.expenses[index].isAnimated)
        }
      //  isAnimated = false
    }


    
    // 날짜 포맷팅 함수
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    enum ChartType: String, CaseIterable {
        case pie = "원형"
        case bar = "막대기"
        case line = "선"
       
    }
}


#Preview {
    ChartView(newExpenseViewModel: NewExpenseViewModel())
}




