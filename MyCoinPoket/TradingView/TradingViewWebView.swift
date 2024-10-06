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
        webView.scrollView.isScrollEnabled = false
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if context.coordinator.lastInterval != selectedInterval {
            context.coordinator.lastInterval = selectedInterval
            loadChart(webView: uiView)
        }
    }

    private func loadChart(webView: WKWebView) {
        let components = coin88.market.split(separator: "-")
        var formattedMarket = ""

        if components.count == 2 {
            formattedMarket = String(components[1] + components[0])
        } else {
            formattedMarket = coin88.market.replacingOccurrences(of: "-", with: "")
        }

        let theme = isDarkMode ? "dark" : (colorScheme == .dark ? "dark" : "light")

        let htmlString = """
        <html><head>
        <meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no, viewport-fit=cover'>
        <style>
            body {
                margin: 0;
                background-color: #1F2630;
            }
            .container {
                width: 100vw;
                height: 100vh;
            }
        </style>
        </head>
        <body>
        <!-- TradingView Widget BEGIN -->
        <div class="tradingview-widget-container">
            <div id="tradingview_abcde"></div>
            <script type="text/javascript" src="https://s3.tradingview.com/tv.js"></script>
            <script type="text/javascript">
            new TradingView.widget({
                "autosize": true,
                "symbol": "UPBIT:\(formattedMarket)",
                "interval": "\(selectedInterval)",
                "timezone": "Etc/UTC",
                "theme": "\(theme)",
                "style": "1",
                "locale": "ko",
                "container_id": "tradingview_abcde",
                "fullscreen": false,
                "allow_symbol_change": true,
                "save_image": false,
                "range": "all",
                "timeframe": "1D",
            });

            window.onload = function() {
                var chartDiv = document.getElementById('tradingview_abcde');
            
            };
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
    @State private var selectedInterval = "240" // 기본적으로 4시간 간격 선택
    @Namespace private var animation
    
    var intervalDisplayName: String {
        switch selectedInterval {
        case "1": return "1분"
        case "3": return "3분"
        case "5": return "5분"
        case "15": return "15분"
        case "30": return "30분"
        case "60": return "1시간"
        case "240": return "4시간"
        case "D": return "일간"
        case "W": return "주간"
        case "M": return "월간"
        default: return "4시간"
        }
    }

    var body: some View {
        GeometryReader { geometry in
            VStack {
                // 시간 선택 섹션
                HStack {
                    // "시간" 메뉴
                    Menu {
                        Button("1분", action: { selectedInterval = "1" })
                        Button("3분", action: { selectedInterval = "3" })
                        Button("5분", action: { selectedInterval = "5" })
                        Button("15분", action: { selectedInterval = "15" })
                        Button("30분", action: { selectedInterval = "30" })
                        Button("1시간", action: { selectedInterval = "60" })
                        Button("4시간", action: { selectedInterval = "240" }) // 4시간 추가
                    } label: {
                        Text(intervalDisplayName)
                            .fontWeight(.semibold)
                            .foregroundColor(selectedInterval == "1" || selectedInterval == "3" || selectedInterval == "5" || selectedInterval == "15" || selectedInterval == "30" || selectedInterval == "60" || selectedInterval == "240" ? .white : .black)
                            .opacity(selectedInterval == "1" || selectedInterval == "3" || selectedInterval == "5" || selectedInterval == "15" || selectedInterval == "30" || selectedInterval == "60" || selectedInterval == "240" ? 1 : 0.7)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background {
                                if selectedInterval == "1" || selectedInterval == "3" || selectedInterval == "5" || selectedInterval == "15" || selectedInterval == "30" || selectedInterval == "60" || selectedInterval == "240" {
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.blue]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                    
                                }
                            }
                    }

                    // "일", "주", "월" 버튼
                    ForEach(["일", "주", "월"], id: \.self) { interval in
                        Text(interval)
                            .fontWeight(.semibold)
                            .foregroundStyle(selectedInterval == intervalIdentifier(for: interval) ? .white : .black)
                            .opacity(selectedInterval == intervalIdentifier(for: interval) ? 1 : 0.7)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background {
                                if selectedInterval == intervalIdentifier(for: interval) {
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.blue]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .matchedGeometryEffect(id: "TAB", in: animation)
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation {
                                    selectedInterval = intervalIdentifier(for: interval)
                                }
                            }
                    }
                }
                .padding(5)
                .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color("BG"))
                }
                //.padding(.horizontal)

                // 차트 뷰
                TradingViewWebView(coin88: coin88, socketViewModel: socketViewModel, selectedInterval: $selectedInterval)
                    .edgesIgnoringSafeArea(.all)
                    .background(Color.purple)
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .top)
        }
    }

    // "일", "주", "월"에 해당하는 시간 간격을 반환하는 함수
    private func intervalIdentifier(for interval: String) -> String {
        switch interval {
        case "일":
            return "D"
        case "주":
            return "W"
        case "월":
            return "M"
        default:
            return "D"
        }
    }
}
