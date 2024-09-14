//
//  LineGraph2.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/13/24.
//

import SwiftUI

struct LineGraph2: View {
    // 플롯의 데이터 배열
    var data: [Double]
    // 수익 여부 (true: 수익, false: 손실)
    var profit: Bool = false
    
    @State var currentPlot = ""
    
    // 오프셋 크기
    @State var offset: CGSize = .zero
    
    @State var showPlot = false
    
    @State var translation: CGFloat = 0
    
    @GestureState var isDrag: Bool = false
    
    // 그래프 애니메이션 진행 상태
    @State var graphProgress: CGFloat = 0
    
    var body: some View {
        
        GeometryReader { proxy in
   
            // 높이와 너비 계산
            let height = proxy.size.height
            let width = (proxy.size.width) / CGFloat(data.count - 1)
            
            // 최대 및 최소 값 가져오기
            let maxPoint = (data.max() ?? 0)
            let minPoint = data.min() ?? 0
            
            // 데이터를 좌표로 변환
            let points = data.enumerated().compactMap { item -> CGPoint in
                
                // 진행 상태 계산 후 높이에 곱해줌
                let progress = (item.element - minPoint) / (maxPoint - minPoint)
                
                let pathHeight = progress * (height - 50)
                
                // 너비 계산
                let pathWidth = width * CGFloat(item.offset)
                
                // 그래프의 피크를 위로 보이게 하기 위해 y 좌표를 조정
                return CGPoint(x: pathWidth, y: +pathHeight + height)
            }
            
            ZStack {
                
                // 플롯을 점으로 변환
                
                // 애니메이션 그래프 경로
                AnimatedGraphPath(progress: graphProgress, points: points)
                .fill(
                    // 그라데이션 색상 설정
                    LinearGradient(colors: [
                        profit ? Color("Profit") : Color("Loss"),
                        profit ? Color("Profit") : Color("Loss"),
                    ], startPoint: .leading, endPoint: .trailing)
                )
                
                // 경로 배경 색상 설정
                FillBG()
                // 모양을 클리핑
                    .clipShape(
                        Path { path in
                            // 점을 따라 경로 그리기
                            path.move(to: CGPoint(x: 0, y: 10))
                            path.addLines(points)
                            path.addLine(to: CGPoint(x: proxy.size.width, y: height))
                            path.addLine(to: CGPoint(x: 0, y: height))
                        }
                    )
                    .opacity(graphProgress)
            }
            .overlay(
                // 드래그 지표
                VStack(spacing: 0) {
                    
                    Text(currentPlot)
                        .font(.caption.bold())
                        .foregroundColor(.white)
                        .padding(.vertical, 6)
                        .frame(width: 100)
                        .background(Color("Gradient1"), in: Capsule())
                        .offset(x: translation < 10 ? 30 : 0)
                        .offset(x: translation > (proxy.size.width - 60) ? -30 : 0)
                    
                    Rectangle()
                        .fill(Color("Gradient1"))
                        .frame(width: 1, height: 40)
                        .padding(.top)
                    
                    Circle()
                        .fill(Color("Gradient1"))
                        .frame(width: 22, height: 22)
                        .overlay(
                            Circle()
                                .fill(.white)
                                .frame(width: 10, height: 10)
                        )
                    
                    Rectangle()
                        .fill(Color("Gradient1"))
                        .frame(width: 1, height: 50)
                }
                // 고정된 프레임
                // 제스처 계산을 위한 프레임
                .frame(width: 80, height: 170)
                // 위치 조정
                .offset(y: 70)
                .offset(offset)
                .opacity(showPlot ? 1 : 0),
                alignment: .bottomLeading
            )
            .contentShape(Rectangle())
            .gesture(DragGesture().onChanged({ value in
                withAnimation { showPlot = true }
                
                let translation = value.location.x
                
                // 인덱스 계산
                let index = max(min(Int((translation / width).rounded() + 1), data.count - 1), 0)
                
                currentPlot = data[index].convertToCurrency()
                self.translation = translation
                
                // 오프셋 업데이트 (그래프 위치에 맞추기)
                offset = CGSize(width: points[index].x - 40, height: points[index].y - height)
                
            }).onEnded({ value in
                withAnimation { showPlot = false }
                
            }).updating($isDrag, body: { value, out, _ in
                out = true
            }))
        }
        // 제스처 변경 감지 시 플롯 숨기기
        .padding(.horizontal, 10)
        .onChange(of: isDrag) { newValue in
            if !isDrag { showPlot = false }
        }
        // 애니메이션 적용 (그래프 표시)
        .onAppear {
//            print("==")
//            print("Prices: \(data)")
//            print("Profit: \(profit)")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 1.2)) {
                    graphProgress = 1
                }
            }
        }
        // 데이터가 변경될 때마다 애니메이션 재시작
        .onChange(of: data) { newValue in
            graphProgress = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 1.2)) {
                    graphProgress = 1
                }
            }
        }
    }
    
    // 배경 색상 설정
    @ViewBuilder
    func FillBG() -> some View {
        let color = profit ? Color("Profit") : Color("Loss")
        LinearGradient(colors: [
            color.opacity(0.4),
            color.opacity(0.3),
            color.opacity(0.2)
        ] + Array(repeating: color.opacity(0.2), count: 4)
        + Array(repeating: Color.clear, count: 2), startPoint: .top, endPoint: .bottom)
    }
}

#Preview {
    CoinSearchView(appModel: AppViewModel())
        .preferredColorScheme(.dark)
}


