//
//  MemoViewController.swift
//  memo
//
//  Created by Kim seonmi on 4/3/25.
//


import UIKit
import Lottie

class MemoViewController: UIViewController {
    var memo: Memo? // SecondViewController에서 전달받을 데이터
    var isNewMemo: Bool = false // 새 메모인지 check
        
    @IBOutlet weak var memoTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //네비게이션 바에 "완료" 버튼 추가
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(saveMemoAndClose))
        
        if let memo = memo {
            memoTextView.text = memo.content // 메모 내용 표시
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveMemo() // 뒤로가기 시에도 저장
    }
        
    @objc func saveMemoAndClose() {
        saveMemo() // 메모 저장
        navigationController?.popViewController(animated: true) // 화면 닫기
    }
        
    private func saveMemo() {
        if let memo = memo {
            memo.content = memoTextView.text
                
            // 제목이 비어 있다면 첫 줄을 제목으로 자동 설정
            if memo.title?.isEmpty ?? true {
                let firstLine = memoTextView.text.components(separatedBy: "\n").first ?? "새 메모"
                memo.title = firstLine
            }
                        
            // 새로운 메모라면 리스트에 추가
            if isNewMemo, !MemoManager.shared.memoList.contains(where: { $0 === memo }) {
                MemoManager.shared.memoList.append(memo)
                print("✅새로운 메모가 추가됨: \(memo.title ?? "제목 없음")")
            }
        }
            
        // 변경된 내용을 저장
        MemoManager.shared.saveMemoList()
    }
}
