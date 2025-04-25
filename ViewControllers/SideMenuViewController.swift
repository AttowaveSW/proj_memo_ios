//
//  SideMenuViewController.swift
//  memo
//
//  Created by Kim seonmi on 4/18/25.
//

import UIKit

class SideMenuViewController: UIViewController {
    @IBOutlet weak var versionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 앱 버전 정보 표시
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
           let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            versionLabel.text = "버전 \(version) (\(build))"
        }
    }
    
    // "개발자 정보" 버튼
    @IBAction func openDeveloperInfo(_ sender: UIButton) {
        // 스토리보드에서 DeveloperInfoViewController 인스턴스화
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let developerInfoVC = storyboard.instantiateViewController(withIdentifier: "DeveloperInfoViewController") as? DeveloperInfoViewController {
            
            // 현재 사이드메뉴를 닫고 개발자 정보 화면으로 전환
            dismiss(animated: true) {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let rootNav = windowScene.windows.first?.rootViewController as? UINavigationController {
                    rootNav.pushViewController(developerInfoVC, animated: true)
                }
            }
        }
    }
    
    // "지도를 보여줄게용" 버튼
    @IBAction func didTapMapButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let mapVC = storyboard.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController {
            // 현재 사이드메뉴를 닫고 지도를 보여주는 화면으로 전환
            dismiss(animated: true) {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let rootNav = windowScene.windows.first?.rootViewController as? UINavigationController {
                    rootNav.pushViewController(mapVC, animated: true)
                }
            }
        }
    }
    
    // "설정" 버튼
    @IBAction func didTapSettings(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let settingsVC = storyboard.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController {
            // 현재 사이드메뉴를 닫고 설정 화면으로 전환
            dismiss(animated: true) {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let rootNav = windowScene.windows.first?.rootViewController as? UINavigationController {
                    rootNav.pushViewController(settingsVC, animated: true)
                }
            }
        }
    }
}
