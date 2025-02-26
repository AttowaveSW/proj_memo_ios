//
//  SecondViewController.swift
//  memo
//
//  Created by Kim seonmi on 2/26/25.
//

import UIKit
import Lottie

/* 버튼 누르면 이동하는 뷰~ */
class SecondViewController: UIViewController {
    let animationView: LottieAnimationView = {
        let animview = LottieAnimationView(name: "clap") /* 박수치는 이미지~ */
        animview.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        animview.contentMode = .scaleAspectFill
        return animview
    }()
    
    /* 뷰가 생성되었을 때~ */
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        view.addSubview(animationView)
        animationView.center = view.center
        
        /* 애니메이션 실행! */
        animationView.play{ (finish) in
            print("애니메이션이 끝났당.")
        }
    }
}
