//
//  ServerViewModel.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/24/24.
//

import SwiftUI

class ServerViewModel: ObservableObject {

    @Published var servers = [
        
        Server(name: "비트코인 주간 운세 확인"),
        Server(name: "이더리움 주간 운세 확인"),
        Server(name: "비트코인 주간 운세 확인"),
        Server(name: "France"),
        Server(name: "Germany"),
        Server(name: "Singapore"),
    ]
    
    
    @Published var isConnected = false
    @Published var showSheet = false
    
    @Published var currentServer = Server(name: "비트코인 주간 운세 확인")
}

