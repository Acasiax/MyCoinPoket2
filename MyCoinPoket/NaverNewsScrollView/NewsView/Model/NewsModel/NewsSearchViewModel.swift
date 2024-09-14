//
//  NewsSearchViewModel.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/13/24.
//

import SwiftUI
import SwiftSoup
import Alamofire

class NewsSearchViewModel: ObservableObject {
    @Published var newsResults: [NewsItem] = []
    @Published var activeTab: TabModel.Tab = .coin
    @Published var isLoading: Bool = false
    private var currentPage = 1
    private var totalResults = 0
    private var displayCount = 20
    
    //MARK: - 네이버 뉴스 서버 가져오기
       func fetchNews(for query: String, isLoadMore: Bool = false) {
           guard !isLoading else { return }
           
           isLoading = true
           
           if isLoadMore {
               currentPage += 1
           } else {
               currentPage = 1
               newsResults = []
           }
           
           let startIndex = (currentPage - 1) * displayCount + 1
           
           // NewsRouter를 사용하여 요청 생성
           let request = NaverNewsRouter.search(query: query, start: startIndex, display: displayCount)
           
           AF.request(request)
               .validate()
               .responseDecodable(of: NewsResponse.self) { response in
                   DispatchQueue.main.async {
                       switch response.result {
                       case .success(let newsResponse):
                           let cleanNews = newsResponse.items.map { newsItem in
                               var cleanedItem = newsItem
                               cleanedItem.title = self.stripHTMLTags(from: newsItem.title)
                               cleanedItem.description = self.stripHTMLTags(from: newsItem.description)
                               return cleanedItem
                           }
                           if isLoadMore {
                               self.newsResults.append(contentsOf: cleanNews)
                           } else {
                               self.newsResults = cleanNews
                           }
                           self.totalResults = newsResponse.total
                       case .failure(let error):
                           print("Error: \(error.localizedDescription)")
                       }
                       self.isLoading = false
                   }
               }
       }
    

    private func stripHTMLTags(from text: String) -> String {
        do {
            let cleanText = try SwiftSoup.parse(text).text()
            return cleanText
        } catch {
            print("Failed to parse HTML: \(error)")
            return text // 파싱에 실패하면 원래 텍스트 반환
        }
    }
    
    //MARK: - 페이지네이션
    func canLoadMore() -> Bool {
        return newsResults.count < totalResults && !isLoading
    }

    
    //MARK: - 기사 원문의 이미지 크롤링
    func fetchImage(for newsItem: NewsItem, completion: @escaping (String?) -> Void) {
        AF.request(newsItem.link).responseString { response in
            switch response.result {
            case .success(let html):
                do {
                    let document = try SwiftSoup.parse(html)
                    if let ogImage = try document.select("meta[property=og:image]").first()?.attr("content") {
                        completion(ogImage)
                    } else {
                        completion(nil)
                    }
                } catch {
                    print("HTML parsing failed: \(error)")
                    completion(nil)
                }
            case .failure(let error):
                print("Failed to fetch HTML: \(error)")
                completion(nil)
            }
        }
    }
}



