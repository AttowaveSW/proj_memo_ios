//
//  SettingsViewController.swift
//  memo
//
//  Created by Kim seonmi on 4/22/25.
//

import UIKit
import UserNotifications

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var colorPicker: UIPickerView!
    @IBOutlet weak var previewView: UIView!
    
    let colorOptions: [(name: String, color: UIColor)] = [
        ("White", .white),
        ("Yellow", .yellow),
        ("Green", .green),
        ("Cyan", .cyan),
        ("Cherry", .systemPink),
        ("Coral", UIColor(red: 1.0, green: 0.7, blue: 0.5, alpha: 1.0)),
        ("Lilac", UIColor(red: 0.9, green: 0.8, blue: 1.0, alpha: 1.0)),
        ("Mint", UIColor(red: 0.7, green: 1.0, blue: 0.9, alpha: 1.0))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkNotificationAuthorization()
        
        colorPicker.delegate = self
        colorPicker.dataSource = self

        // 저장된 색 있으면 적용
        if let savedColor = UserDefaults.standard.colorForKey("memoBackgroundColor") {
            previewView.backgroundColor = savedColor
            
            // 저장된 색이 몇 번째 인덱스인지 찾아서 선택해놓기
            if let index = colorOptions.firstIndex(where: { $0.color.isEqual(savedColor) }) {
                colorPicker.selectRow(index, inComponent: 0, animated: false)
            }
        }
    }
    
    // 알림 권한 확인해서 스위치 상태 반영
    func checkNotificationAuthorization() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.notificationSwitch.isOn = (settings.authorizationStatus == .authorized)
            }
        }
    }
    
    // 스위치 눌렀을 때 동작
    @IBAction func didToggleNotificationSwitch(_ sender: UISwitch) {
        if sender.isOn {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                DispatchQueue.main.async {
                    if !granted {
                        self.notificationSwitch.setOn(false, animated: true)
                        self.showSettingsAlert()
                    }
                }
            }
        } else {
            showSettingsAlert()
        }
    }

    // 설정 앱으로 유도하는 alert
    func showSettingsAlert() {
        let alert = UIAlertController(title: "알림 설정", message: "알림 권한을 변경하려면 설정 앱으로 이동하세요.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        })
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - PickerView 데이터소스
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return colorOptions.count
    }

    // MARK: - PickerView 델리게이트
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return colorOptions[row].name
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedColor = colorOptions[row].color
        UserDefaults.standard.setColor(selectedColor, forKey: "memoBackgroundColor")
        previewView.backgroundColor = selectedColor
        
        // 선택한 색상을 저장한다
        UserDefaults.standard.setColor(selectedColor, forKey: "memoBackgroundColor")
    }
}

