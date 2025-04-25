//
//  UserDefaults.swift
//  memo
//
//  Created by Kim seonmi on 4/23/25.
//

import UIKit

// UserDefaults 확장, UIColor를 저장하고 불러오는 기능을 추가
extension UserDefaults {
    // UIColor를 UserDefaults에 저장하는 함수
    func setColor(_ color: UIColor?, forKey key: String) {
        guard let color = color else { return } // color가 nil이면 아무 작업도 하지 않음
        
        // UIColor를 data 형태로 변환(archiving)
        let data = try? NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
        
        // 변환된 data를 UserDefaults에 저장
        set(data, forKey: key)
    }

    // UserDefaults에서 UIColor를 불러오는 함수
    func colorForKey(_ key: String) -> UIColor? {
        // 해당 키로 저장된 data가 없으면 nil을 반환 함
        guard let data = data(forKey: key) else { return nil }
        // 저장된 data를 UIColor로 변환해서 반환 함
        return try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data)
    }
}

