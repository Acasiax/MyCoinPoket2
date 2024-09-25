//
//  NewsView.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/13/24.
//

import SwiftUI

struct NewsView: View {

    @ObservedObject var tabViewModel: TabViewModel
    @ObservedObject var viewModel: NewsSearchViewModel

    var body: some View {
        GeometryReader { geo in
            let size = geo.size

            TabView(selection: $tabViewModel.activeTab) {
                NewsSearchListView(viewModel: viewModel)
                    .modifier(TabModifier(tab: .coin, size: size, tabViewModel: tabViewModel))

                NewsSearchListView(viewModel: viewModel)
                    .modifier(TabModifier(tab: .bitcoin, size: size, tabViewModel: tabViewModel))

                NewsSearchListView(viewModel: viewModel)
                    .modifier(TabModifier(tab: .nft, size: size, tabViewModel: tabViewModel))

                NewsSearchListView(viewModel: viewModel)
                    .modifier(TabModifier(tab: .crypto, size: size, tabViewModel: tabViewModel))
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .allowsHitTesting(!tabViewModel.isDragging)
            .onChange(of: tabViewModel.activeTab) { oldValue, newValue in
                guard tabViewModel.tabBarScrollState != newValue else { return }
                withAnimation(.snappy) {
                    tabViewModel.tabBarScrollState = newValue
                }
                viewModel.fetchNews(for: newValue.rawValue)
            }
        }
    }
}


struct TabModifier: ViewModifier {
    let tab: TabModel.Tab
    let size: CGSize
    let tabViewModel: TabViewModel

    func body(content: Content) -> some View {
        content
            .tag(tab)
            .frame(width: size.width, height: size.height)
            .rect { tabViewModel.calculateTabProgress(tab, rect: $0, size: size) }
    }
}




//#Preview {
//    Home_NewsView()
//}
//
