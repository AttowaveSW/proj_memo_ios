//
//  ViewController.swift
//  memo
//
//  Created by Kim seonmi on 2/18/25.
//

import UIKit
import Lottie
import CoreLocation
import CoreBluetooth
import Photos
import UserNotifications
import Network
import AdSupport
import AppTrackingTransparency

class MainViewController: UIViewController, CLLocationManagerDelegate, CBCentralManagerDelegate, UNUserNotificationCenterDelegate {
    var locationManager: CLLocationManager!
    var bluetoothManager: CBCentralManager?

    @IBOutlet weak var splashImg: UIImageView!
    
    /* 뷰가 생성되었을 때~ */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* 위치 권한 허용 */
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        /* Photo 권한 허용 */
        requestPhotoLibraryPermission()
        
        /* Bluetooth 권한 허용*/
        requestBluetoothPermission()

        /* Network 권한 허용 */
        requestNetworkPermission()
        
        /* noti 권한 허용 후 앱 추적 권한 허용하기 */
        requestNotiAndTrackingPermission()
        
        //1. 사용자 인터랙션 활성화
        splashImg.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        splashImg.addGestureRecognizer(tapGesture)
    }
    
    /*=============== Network 권한 허용 ===============*/
    private func requestNetworkPermission() {
        let connection = NWConnection(
            host: "google.com",  // 로컬 네트워크 접근을 위한 임의의 IP
            port: 80,
            using: .tcp
        )
            
        connection.stateUpdateHandler = { state in
            switch state {
            case .setup:
                print("네트워크 연결 설정 중")
            case .waiting(let error):
                print("네트워크 연결 대기 중: \(error.localizedDescription)")
            case .preparing:
                print("네트워크 준비 중")
            case .ready:
                print("네트워크 연결 가능 ✅")
            case .failed(let error):
                print("네트워크 연결 실패 ❌: \(error.localizedDescription)")
                self.showSettingsNetworkAlert()
            default:
                break
            }
        }

        connection.start(queue: DispatchQueue.global())
    }

    private func showSettingsNetworkAlert() {
        let alert = UIAlertController(
            title: "네트워크 권한 필요",
            message: "이 앱은 로컬 네트워크 접근이 필요합니다. 설정에서 권한을 허용해주세요.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        })

        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))

        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    /*=============== Bluetooth 권한 허용 ===============*/
    private func requestBluetoothPermission(){
        bluetoothManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("블루투스 상태 : 알 수 없음")
        case .resetting:
            print("블루투스 상태 : 리셋 중")
        case .unsupported:
            print("블루투스가 지원되지 않음")
        case .unauthorized:
            print("블루투스 권한이 없음 ")
        case .poweredOff:
            print("블루투스가 꺼져있음")
        case .poweredOn:
            break//fatalError("예상치 못한 블루투스 상태")
        default:
            break
        }
    }
    
    func requestPhotoLibraryPermission(){
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization { _ in}
        }
    }
    
    /*=============== noti & 추적 권한 허용 ===============*/
    private func requestNotiAndTrackingPermission(){
        let n = NotificationHandler()
        n.askNotificationPermission {
            // 다른 권한 요청 창보다 늦게 띄우기
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if #available(iOS 14, *) {
                    ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                        switch status {
                        case .authorized:        // 허용됨
                            print("Authorized")
                            print("IDFA = \(ASIdentifierManager.shared().advertisingIdentifier)")    // IDFA 접근
                        case .denied:        // 거부됨
                            print("Denied")
                        case .notDetermined:    // 결정되지 않음
                            print("Not Determined")
                        case .restricted:        // 제한됨
                            print("Restricted")
                        @unknown default:        // 알려지지 않음
                            print("Unknown")
                        }
                    })
                }
            }
        }
    }
      
    class NotificationHandler{
        //Permission function
        func askNotificationPermission(completion: @escaping ()->Void){
            //Permission to send notifications
            let center = UNUserNotificationCenter.current()
            // Request permission to display alerts and play sounds.
            center.requestAuthorization(options: [.alert, .badge, .sound])
            { (granted, error) in
                // Enable or disable features based on authorization.
                completion()
            }
        }
    }
    
    /*=============== 위치 권한 허용 ===============*/
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("✅ 위치 권한 허용됨")
        case .denied, .restricted:
            print("🚫 위치 권한 거부됨")
        default:
            print("⚠️ 위치 권한 상태 변경됨")
        }
    }
    
    @objc func imageTapped(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        print("이미지를 클릭했다!") //테스트용 로그
        
        if let secondVC = storyboard.instantiateViewController(identifier: "SecondViewController") as? SecondViewController {
            secondVC.modalPresentationStyle = .fullScreen
            present(secondVC, animated: true, completion: nil)
        } else {
            print("SecondViewController를 찾을 수 없습니다!")
        }
    }
}

