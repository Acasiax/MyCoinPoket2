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
    @Environment(\.colorScheme) var colorScheme //아이폰 자체내에 현재 색깔 모드가 무엇인지
    @AppStorage("isDarkMode") private var isDarkMode = false //사용자가 앱내에서 설정했는지
    func makeUIView(context: Context) -> WKWebView {
        
        let webView = WKWebView()
        
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
                "interval": "1",
                "timezone": "Etc/UTC",
                "theme": "\(theme)",
                "style": "1",
                "locale": "en",
                "container_id": "tradingview_abcde"
            });
            </script>
        </body>
        </html>
        """
        webView.loadHTMLString(htmlString, baseURL: nil)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // 필요시 업데이트 처리
    }
}

struct Home: View {
    
    var coin88: UpBitMarket
    @ObservedObject var socketViewModel: SocketViewModel
    
    var body: some View {
        TradingViewWebView(coin88: coin88, socketViewModel: socketViewModel)
    }
}


