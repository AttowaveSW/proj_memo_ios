//
//  Model.swift
//  memo
//
//  Created by Kim seonmi on 3/20/25.
//

import Foundation

class Memo {
    var title: String? // 제목
    var content: String? // 내용
    var date: Date // 메모 저장 날짜
    
    init(title: String? = nil, content: String? = nil) {
        self.title = title
        self.content = content
        date = Date()
    }
    
    static var testMemoList = [
        Memo(title:"메모1", content: "테스트 메모입니다. 리스트로 만들어주세요"),
        Memo(title:"메모2", content: "테스트 두번째 메모입니다. 데이터 소스로 사용해주세요")
    ]
}
