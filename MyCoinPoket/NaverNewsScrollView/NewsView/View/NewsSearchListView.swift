//
//  NewsSearchListView.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/13/24.
//

import Foundation
import SwiftUI
import Alamofire
import SwiftSoup

struct NewsSearchListView: View {
    
    @ObservedObject var viewModel: NewsSearchViewModel
    
    var body: some View {
        List(viewModel.newsResults, id: \.link) { news in
            NavigationLink(destination: NewsDetailView(news: news)) {
                VStack(alignment: .leading) {
                    // 기사 이미지
                    newsImageView(for: news)
                    
                    // 기사 제목
                    Text(news.title)
                        .font(.headline)
                        .padding(.top, 5)
                    
                    // 기사 설명
                    Text(news.description)
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                        .lineLimit(3)
                        .padding(.top, 2)
                }
                
                .onAppear {
                    // 이미지 불러오기
                    viewModel.fetchImage(for: news) { imageUrl in
                        if let index = viewModel.newsResults.firstIndex(where: { $0.link == news.link }) {
                            viewModel.newsResults[index].imageUrl = imageUrl
                        }
                    }
                    
                    // 마지막 뉴스 항목이 나타나면 다음 페이지 로드
                    if news == viewModel.newsResults.last && viewModel.canLoadMore() {
                        viewModel.fetchNews(for: viewModel.activeTab.rawValue, isLoadMore: true)
                    }
                }
              .padding(.vertical, 10)
                
            }
            
        }
    }
    
    // AsyncImage 렌더링 함수
    func newsImageView(for news: NewsItem) -> some View {
        if let imageUrl = news.imageUrl, let url = validateUrl(imageUrl) {
            return AnyView(
                AsyncImage(url: url) { result in
                    switch result {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            //.background(Color.red)
                            .frame(width: 270, height: 120)
                            .cornerRadius(10)
                        
                        
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                           // .frame(height: 200)
                            .frame(width: 100, height: 100)
                            .cornerRadius(10)
                    @unknown default:
                        EmptyView()
                    }
                }
            )
        } else {
            return AnyView(EmptyView())
        }
    }
    
    // URL 검증 및 프로토콜 추가 함수
    func validateUrl(_ imageUrl: String?) -> URL? {
        guard let imageUrl = imageUrl else { return nil }
        // URL이 http 또는 https로 시작하지 않으면 기본 프로토콜 추가
        let validUrl = imageUrl.hasPrefix("http") ? imageUrl : "https:\(imageUrl)"
        return URL(string: validUrl)
    }
}



#Preview {
   Home_NewsView()
}

