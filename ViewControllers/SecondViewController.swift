//
//  SecondViewController.swift
//  memo
//
//  Created by Kim seonmi on 2/26/25.
//

import UIKit
import Lottie

/* 버튼 누르면 이동하는 SecondView */
class SecondViewController: UIViewController {
    
    @IBOutlet weak var memoTableView: UITableView!
    
    let animationView: LottieAnimationView = {
        let animview         = LottieAnimationView(name: "clap") /* 박수치는 이미지~ */
        animview.frame       = CGRect(x: 0, y: 0, width: 400, height: 400)
        animview.contentMode = .scaleAspectFill
        return animview
    }()
    
    /* 뷰가 생성되었을 때~ */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.memoTableView.delegate   = self
        self.memoTableView.dataSource = self
        self.memoTableView.register(UITableViewCell.self, forCellReuseIdentifier: "memoCell")

        // Do any additional setup after loading the view.

        // 5week, memoTableView 띄워야 하므로 애니메이션은 주석처리합니다.
        //view.addSubview(animationView)
        //animationView.center = view.center
        
        /* 애니메이션 실행! */
        //animationView.play{ (finish) in
        //    print("애니메이션이 끝났당.")
        //}
    }
}

/* tableView logic을 분리, extension 사용 */
extension SecondViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Memo.testMemoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memoCell", for: indexPath)
        
        let memo                   = Memo.testMemoList[indexPath.row] // 해당 행의 메모를 가져옴
        cell.textLabel?.text       = (memo.title) // title 표시
        cell.detailTextLabel?.text = "\(memo.date)" // date 표시
        
        return cell
    }
}
