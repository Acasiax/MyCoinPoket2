//
//  ExtFunc.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/24/24.
//

import SwiftUI

extension View {
    
    // 색상 결정 함수
    func getColor(for value: CGFloat) -> Color {
        switch value {
        case 0..<20:
            return Color.red // 공포 (빨간색)
        case 20..<50:
            return Color.orange // 약한 공포 (주황색)
        case 50..<80:
            return Color.yellow // 탐욕 (노란색)
        default:
            return Color.green // 강한 탐욕 (녹색)
        }
    }
}

// Date 타입에 대한 확장: 타임스탬프를 사람이 읽을 수 있는 형식으로 변환하는 기능
extension Date {
    static func formatTimestamp(_ timestamp: String) -> String {
        if let timeInterval = Double(timestamp) {
            let date = Date(timeIntervalSince1970: timeInterval)
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ko_KR") // 한국어 로케일 설정
            dateFormatter.dateFormat = "yyyy년 M월 d일" // 원하는 형식 설정
            return dateFormatter.string(from: date)
        }
        return "날짜를 변환할 수 없습니다."
    }
}


