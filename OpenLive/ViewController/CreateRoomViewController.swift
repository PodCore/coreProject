//
//  MainViewController.swift
//  OpenLive
//
//  Created by GongYuhua on 6/25/16.
//  Copyright © 2016 Agora. All rights reserved.
//

import UIKit
import AgoraRtcEngineKit

class CreateRoomViewController: UIViewController {

    @IBOutlet weak var upLoadImgLabel: UILabel!
    @IBOutlet weak var roomImg: UIImageView!
    @IBOutlet weak var roomNameTextField: UITextField!
    fileprivate var videoProfile = AgoraRtcVideoProfile._VideoProfile_360P
    var roomImgStr: String?
    
    @objc func pickRoomTapped(_ gestureRecgonize: UITapGestureRecognizer) {
        self.selectImg()
    }

    @IBAction func createRoomTapped(_ sender: UIButton) {
        if self.roomImgStr == nil {
            let alertView = AlertView(alertTitle: "photo empty alert", alertMsg: "Please select a photo for your live room")
            alertView.delegate = self
            alertView.configureView(proceedMsg: "Select image", cancelMsg: "Use default image")
            self.present(alertView.alertController, animated: true, completion: nil)
            
        }
        join(withRole: .clientRole_Broadcaster)
    }
    
    func selectImg() {
        CameraHandler.shared.showActionSheet(vc: self)
        CameraHandler.shared.imagePickedBlock = { (image) in
            DispatchQueue.main.async {
                self.roomImg.image = image
                self.upLoadImgLabel.isHidden = true
            }
            let imgData: NSData = UIImagePNGRepresentation(image!)! as NSData
            self.roomImgStr = imgData.base64EncodedString(options: .lineLength64Characters)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        roomImg.isUserInteractionEnabled = true
        let tapped = UITapGestureRecognizer(target: self, action: #selector(pickRoomTapped(_:)))
        roomImg.addGestureRecognizer(tapped)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueId = segue.identifier else {
            return
        }
        
        switch segueId {
        case "mainToSettings":
            let settingsVC = segue.destination as! SettingsViewController
            settingsVC.videoProfile = videoProfile
            settingsVC.delegate = self
        case "mainToLive":
            let liveVC = segue.destination as! LiveRoomViewController
            liveVC.roomName = roomNameTextField.text
            liveVC.videoProfile = videoProfile
            liveVC.roomImage = self.roomImgStr
            if let value = sender as? NSNumber, let role = AgoraRtcClientRole(rawValue: value.intValue) {
                liveVC.clientRole = role
            }
            liveVC.delegate = self
        default:
            break
        }
    }
}

extension CreateRoomViewController: PassAlertActionDelegate {
    func alertActionForOk() {
        self.selectImg()
    }
    
    func alertActionForCancle() {
        self.roomImgStr = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS2ggZKW9Cn6kVzXsRC_EeWzMq_wElFOvv1TYMbDfYyaKJxQWL3"
        DispatchQueue.main.async {
            self.upLoadImgLabel.isHidden = true
        }
    }
}

private extension CreateRoomViewController {
    func join(withRole role: AgoraRtcClientRole) {
        performSegue(withIdentifier: "mainToLive", sender: NSNumber(value: role.rawValue as Int))
    }
}

extension CreateRoomViewController: SettingsVCDelegate {
    func settingsVC(_ settingsVC: SettingsViewController, didSelectProfile profile: AgoraRtcVideoProfile) {
        videoProfile = profile
        dismiss(animated: true, completion: nil)
    }
}
//  for navigate to live room VC
extension CreateRoomViewController: LiveRoomVCDelegate {
    func liveVCNeedClose(_ liveVC: LiveRoomViewController) {
        let _ = navigationController?.popViewController(animated: true)
    }
}

extension CreateRoomViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let string = textField.text , !string.isEmpty {
            join(withRole: .clientRole_Broadcaster)
        }
        
        return true
    }
}
