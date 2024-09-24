//
//  ForturnHeaderView.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/24/24.
//

import SwiftUI

struct ForturnHeaderView: View {
    
    @ObservedObject var serverData: ServerViewModel
    
    var body: some View {
        VStack {
            Text("ChatGpt로\n오늘의 운세 확인하기")
                .font(.largeTitle)
                .multilineTextAlignment(.center)
            .fontWeight(.heavy)
                .foregroundColor(.white)
                .padding()
            
            Spacer()
            
            Text("현재상태")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            Text(serverData.isConnected ? "준비되지 않음" : "준비됨")
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(.top, 5)
                .padding(.bottom, 20)
        }
    }
}


