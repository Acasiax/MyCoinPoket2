//
//  TradingViewWebView.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 10/4/24.
//

import SwiftUI
import WebKit

struct TradingViewWebView: UIViewRepresentable {
    
    var coin88: UpBitMarket
    @ObservedObject var socketViewModel: SocketViewModel
    @Binding var selectedInterval: String
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    class Coordinator {
        var lastInterval: String = ""
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        context.coordinator.lastInterval = selectedInterval
        loadChart(webView: webView)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // 현재 interval과 이전 interval이 다를 때만 업데이트
        if context.coordinator.lastInterval != selectedInterval {
            context.coordinator.lastInterval = selectedInterval
            loadChart(webView: uiView)
        }
    }

    private func loadChart(webView: WKWebView) {
        // "-"로 나누고 순서 변경 후 결합
        let components = coin88.market.split(separator: "-")
        var formattedMarket = ""
        
        if components.count == 2 {
            formattedMarket = String(components[1] + components[0]) // "ETHKRW"
        } else {
            formattedMarket = coin88.market.replacingOccurrences(of: "-", with: "") // 기본적으로 "-" 제거
        }

        print("\(formattedMarket)") // 변환된 값 확인
        
        // 현재 모드에 맞춰 테마 설정
        let theme = isDarkMode ? "dark" : (colorScheme == .dark ? "dark" : "light")
        print("\(theme)") // 현재 테마 확인
        
        let htmlString = """
        <html>
        <head>
            <script type="text/javascript" src="https://s3.tradingview.com/tv.js"></script>
        </head>
        <body>
            <div id="tradingview_abcde"></div>
            <script type="text/javascript">
            new TradingView.widget({
                "width": "100%",
                "height": "100%",
                "symbol": "UPBIT:\(formattedMarket)",
                "interval": "\(selectedInterval)",
                "timezone": "Etc/UTC",
                "theme": "\(theme)",
                "style": "1",
                "locale": "ko",
                "container_id": "tradingview_abcde"
            });
            </script>
        </body>
        </html>
        """
        webView.loadHTMLString(htmlString, baseURL: nil)
    }
}

struct Home_Trading: View {
    
    var coin88: UpBitMarket
    @ObservedObject var socketViewModel: SocketViewModel
    @State private var selectedInterval = "1" // 기본적으로 1분 간격 선택

    var body: some View {
        VStack {
            // Picker 또는 Segmented Control로 시간 간격 선택
            Picker("시간 간격 선택", selection: $selectedInterval) {
                Text("1분").tag("1")
                Text("5분").tag("5")
                Text("15분").tag("15")
                Text("30분").tag("30")
                Text("1시간").tag("60")
                Text("4시간").tag("240")
                Text("일간").tag("D")
                Text("주간").tag("W")
                Text("월간").tag("M")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            // 차트 뷰
            TradingViewWebView(coin88: coin88, socketViewModel: socketViewModel, selectedInterval: $selectedInterval)
        }
    }
}
