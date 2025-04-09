//
//  Model.swift
//  memo
//
//  Created by Kim seonmi on 3/20/25.
//

import Foundation

class Memo: Codable {
    var title: String? // 제목
    var content: String? // 내용
    var date: Date // 메모 저장 날짜
    
    init(title: String? = nil, content: String? = nil) {
        self.title = title
        self.content = content
        date = Date()
    }
}

class MemoManager {
    static let shared = MemoManager() //싱글톤 인스턴스
    private init() {
        loadMemoList() //앱 실행 시 자동 로드
    }
    
    var memoList: [Memo] = [
        //Memo(title: "메모1", content: "테스트 메모입니다. 리스트로 만들어주세요"),
        //Memo(title: "메모2", content: "테스트 두번째 메모입니다. 데이터 소스로 사용해주세요")
    ]
    
    func saveMemoList() {
        let encoder = JSONEncoder() //swift 객체를 JSON 데이터로 바꿔주는 인코더를 만듦
        if let encoded = try? encoder.encode(memoList) { //인코딩에 실패했을 때 앱이 죽지 않고 nil을 리턴하도록 try?를 사용 함
            UserDefaults.standard.set(encoded, forKey: "memoList") //메모데이터를 디스크에 저장
        }
    }
    
    func loadMemoList() {
        if let savedData = UserDefaults.standard.data(forKey: "memoList") { //"memoList" 키로 저장된 데이터가 있는지 확인하고 불러옴.
            let decoder = JSONDecoder() //JSON 데이터를 Swift 객체로 바꿔주는 디코더를 만듦
            if let loadedMemos = try? decoder.decode([Memo].self, from: savedData) { //JSON 데이터를 [Memo]타입 배열로 디코딩을 시도하여 실패하면 nil, 성공하면 loadedMemos에 디코딩된 데이터가 담김
                memoList = loadedMemos //디코딩된 메모 배열을 앱에서 사용할 메모리스트로 지정 함
            }
        }
    }
}
