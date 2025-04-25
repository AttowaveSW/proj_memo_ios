//
//  DeveloperInfoViewController.swift
//  memo
//
//  Created by Kim seonmi on 4/22/25.
//

import UIKit
import WebKit

class DeveloperInfoViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = URL(string: "https://www.google.com") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}
