//
//  Home_NewsView.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/13/24.
//

import SwiftUI

struct Home_NewsView: View {
    @ObservedObject var tabViewModel: TabViewModel
    @ObservedObject var viewModel = NewsSearchViewModel()
    @Namespace private var animation
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    Text("뉴스")
                        .naviTitleStyle()
                        .padding(.bottom, 15)
                    Spacer()
                }
                CustomTabBar()
                
                NewsView(tabViewModel: tabViewModel, viewModel: viewModel)
            }
            .onAppear {
                print("onAppear===")
                viewModel.fetchNews(for: tabViewModel.activeTab.rawValue)
            }
            .onChange(of: tabViewModel.activeTab) {
                viewModel.fetchNews(for: tabViewModel.activeTab.rawValue)
            }
        }
    }
}

extension Home_NewsView {
    
    @ViewBuilder
    func CustomTabBar() -> some View {
        ScrollView(.horizontal) {
            HStack(spacing: 1) {
                ForEach($tabViewModel.tabs) { $tab in
                    Button(action: {
                        tabViewModel.selectTab(tab.id, viewModel: viewModel)
                    }) {
                        Text(tab.id.rawValue)
                            .fontWeight(.semibold)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 10)
                            .foregroundStyle(tabViewModel.activeTab == tab.id ? Color.white : .gray)
                            .background(
                                ZStack {
                                    if tabViewModel.activeTab == tab.id {
                                        Color.blue.opacity(0.7)
                                            .matchedGeometryEffect(id: "tabBackground", in: animation)
                                    } else {
                                        Color.clear
                                    }
                                }
                            )
                            .cornerRadius(8)
                            .contentShape(.rect)
                            .padding(.bottom, 5)
                    }
                    .buttonStyle(.plain)
                    .rect { rect in
                        tab.size = rect.size
                        tab.minX = rect.minX
                    }
                }
            }
        }
        .overlay(alignment: .bottom) {
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(.gray.opacity(0.3))
                    .frame(height: 1)
                    .padding(.horizontal, -10)

                let inputRange = tabViewModel.tabs.indices.compactMap { return CGFloat($0) }
                let outputRange = tabViewModel.tabs.compactMap { return $0.size.width }
                let outputPositionRange = tabViewModel.tabs.compactMap { return $0.minX }
                let indicatorWidth = tabViewModel.progress.interpolate(inputRange: inputRange, outputRange: outputRange)
                let indicatorPosition = tabViewModel.progress.interpolate(inputRange: inputRange, outputRange: outputPositionRange)

                Rectangle()
                    .fill(.blue)
                    .frame(width: indicatorWidth, height: 1.5)
                    .offset(x: indicatorPosition)
                    .matchedGeometryEffect(id: "tabIndicator", in: animation)
            }
        }
        .padding(.leading, 25)
        .scrollIndicators(.hidden)
    }
}

