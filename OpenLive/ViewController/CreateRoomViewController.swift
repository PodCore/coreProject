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

    @IBOutlet weak var roomNameTextField: UITextField!
    @IBOutlet weak var roomImage: UIImageView!
    fileprivate var videoProfile = AgoraRtcVideoProfile._VideoProfile_360P
    var roomImgStr: String?
    @IBAction func pickRoomTapped(_ sender: UIButton) {
        CameraHandler.shared.showActionSheet(vc: self)
        CameraHandler.shared.imagePickedBlock = { (image) in
            self.roomImage.contentMode = .scaleAspectFill
            self.roomImage.clipsToBounds = true
            self.roomImage.image = image
            let imgData: NSData = UIImagePNGRepresentation(image)! as NSData
            self.roomImgStr = imgData.base64EncodedString(options: .lineLength64Characters)
        }
    }
    
    @IBAction func createRoomTapped(_ sender: UIButton) {
        join(withRole: .clientRole_Broadcaster)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        imagePicker.delegate = self
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
