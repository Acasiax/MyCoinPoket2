//
//  NewsDetailView.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/13/24.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        WKWebView()
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

struct NewsDetailView: View {
    let news: NewsItem
    
    var body: some View {
        VStack {
            if let url = URL(string: news.link) {
                WebView(url: url)
                    .edgesIgnoringSafeArea(.all)
            } else {
                Text("유효하지 않은 URL입니다.")
                    .foregroundStyle(.red)
            }
        }
        .navigationBarTitle("", displayMode: .inline)
       
    }
}

