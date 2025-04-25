//
//  SecondViewController.swift
//  memo
//
//  Created by Kim seonmi on 2/26/25.
//

import UIKit
import Lottie
import SideMenu

// 버튼 누르면 이동하는 SecondView
class SecondViewController: UIViewController {

    @IBOutlet weak var memoTableView: UITableView!
    
    @IBAction func didTapMenuButton(_ sender: UIBarButtonItem) {
        if let menu = SideMenuManager.default.leftMenuNavigationController {
            present(menu, animated: true, completion: nil)
        }
    }
    
    let animationView: LottieAnimationView = {
        let animview         = LottieAnimationView(name: "clap") // 박수치는 이미지
        animview.frame       = CGRect(x: 0, y: 0, width: 400, height: 400)
        animview.contentMode = .scaleAspectFill
        return animview
    }()
    
    // 뷰가 생성되었을 때
    override func viewDidLoad() {
        super.viewDidLoad()

        let menuVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SideMenuNavigationController") as! SideMenu.SideMenuNavigationController
        SideMenuManager.default.leftMenuNavigationController = menuVC

        menuVC.presentationStyle = .menuSlideIn // SecondView는 가만히 있고 sidemenu만 나오기
        menuVC.presentationStyle.onTopShadowOpacity = 0.5 // 배경 어둡게 효과

        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.view, forMenu: .left)

        MemoManager.shared.loadMemoList()
        
        self.memoTableView.delegate   = self
        self.memoTableView.dataSource = self
        self.memoTableView.register(UITableViewCell.self, forCellReuseIdentifier: "memoCell")
        
        // 왼쪽 상단의 뒤로가기버튼 숨김
        self.navigationItem.hidesBackButton = true

        // Do any additional setup after loading the view.

        // 5week, memoTableView 띄워야 하므로 애니메이션은 주석처리합니다.
        //view.addSubview(animationView)
        //animationView.center = view.center
        
        /* 애니메이션 실행! */
        //animationView.play{ (finish) in
        //    print("애니메이션이 끝났당.")
        //}
    }
    
    // 화면이 다시 나타날 때(뒤로 왔을 때) 테이블 뷰를 새로고침
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            
        // 저장된 시간순으로 정렬(최신이 위로)
        MemoManager.shared.memoList.sort {
            $0.date > $1.date
        }
        
        print("메모 갯수: \(MemoManager.shared.memoList.count)")
        memoTableView.reloadData() //리스트 업데이트
    }
    
    // + 버튼 눌렀을 때, 새로운 메모를 생성 함
    @IBAction func addMemo(_ sender: UIBarButtonItem) {
        let newMemo = Memo(title: "", content: "") // 새로운 빈 메모 생성

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let memoVC = storyboard.instantiateViewController(withIdentifier: "MemoViewController") as? MemoViewController {
            memoVC.memo      = newMemo   // 새 메모 전달
            memoVC.isNewMemo = true // 새 메모인지 확인할 수 있도록 설정
            print("새로운 메모 생성됨, isNewMemo = \(memoVC.isNewMemo)")
            navigationController?.pushViewController(memoVC, animated: true)
        }
    }
}

// tableView logic을 분리, extension 사용
extension SecondViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MemoManager.shared.memoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memoCell", for: indexPath)
        
        let memo                   = MemoManager.shared.memoList[indexPath.row] // 해당 행의 메모를 가져옴
        cell.textLabel?.text       = (memo.title) // title 표시
        cell.detailTextLabel?.text = "\(memo.date)" // date 표시
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMemo = MemoManager.shared.memoList[indexPath.row] // 선택한 메모를 가져옴
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // "Main"은 스토리보드 파일 이름
        if let memoVC = storyboard.instantiateViewController(withIdentifier: "MemoViewController") as? MemoViewController {
            memoVC.memo      = selectedMemo  // 선택한 메모를 전달
            memoVC.isNewMemo = false    // 기존 메모이므로 false 설정
            navigationController?.pushViewController(memoVC, animated: true) // 화면 이동
        }
    }
    
    // 메모리스트에서 스와이프해서 삭제하기
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // 1.메모 리스트에서 삭제
            MemoManager.shared.memoList.remove(at: indexPath.row)

            // 2.저장
            MemoManager.shared.saveMemoList()

            // 3.테이블 뷰에서 셀 삭제
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

}
