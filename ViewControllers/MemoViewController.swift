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
        
        // 뒤로가기 버튼을 눌렀을 때의 처리를 위해 커스텀 버튼을 만듦
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonTapped))
        
        // 네비게이션 바에 "완료" 버튼 추가
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(saveMemoAndClose))
        
        if let memo = memo {
            memoTextView.text = memo.content // 메모 내용 표시
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
        
    @objc func saveMemoAndClose() {
        let alertController = UIAlertController(title: "저장하시겠습니까?", message: nil, preferredStyle: .alert)
        
        // "저장" 버튼
        let saveAction = UIAlertAction(title: "저장", style: .default) { _ in
            self.saveMemo() // 메모 저장
            self.navigationController?.popViewController(animated: true) // 화면 닫기
        }
            
        // "취소" 버튼
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
            // 취소를 누르면 저장하지 않고 리스트로 돌아감
            self.navigationController?.popViewController(animated: true)
        }
        
        // UIAlertController에 버튼 추가
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
            
        // 저장여부 팝업 띄우기
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func backButtonTapped() {
        guard let memo = memo else {
            navigationController?.popViewController(animated: true)
            return
        }

        let currentText = memoTextView.text ?? ""
        let trimmedText = currentText.trimmingCharacters(in: .whitespacesAndNewlines)

        // 내용이 비었거나 기존과 같으면 그냥 나감
        if trimmedText.isEmpty || trimmedText == memo.content {
            navigationController?.popViewController(animated: true)
            return
        }

        // 내용이 수정된 경우 저장여부를 확인
        let alertController = UIAlertController(title: "저장하시겠습니까?", message: nil, preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "저장", style: .default) { _ in
            self.saveMemo()
            self.navigationController?.popViewController(animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
            // 취소 시 저장하지 않고 리스트로 돌아감
            self.navigationController?.popViewController(animated: true) // 화면 닫기
        }

        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }

        
    private func saveMemo() {
        // 내용이 없으면 저장하지 않고 나감
        guard let memoText = memoTextView.text,
            !memoText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            print("메모 내용이 비어있어 저장하지 않음")
            return
        }
        
        if let memo = memo {
            memo.content = memoText
                
            // 제목은 항상 첫 줄로 자동 설정 함
            let firstLine = memoText.components(separatedBy: .newlines).first ?? ""
            memo.title = firstLine
            memo.date = Date() // 수정한 날짜로 시간 갱신
                        
            // 새로운 메모라면 리스트에 추가
            if isNewMemo, !MemoManager.shared.memoList.contains(where: { $0 === memo }) {
                MemoManager.shared.memoList.append(memo)
                print("✅새로운 메모가 추가됨: \(memo.title ?? "제목 없음")")
            }
        }
            
        //변경된 내용을 저장
        MemoManager.shared.saveMemoList()
    }
}
