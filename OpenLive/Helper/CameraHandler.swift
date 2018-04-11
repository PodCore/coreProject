//
//  CameraHandler.swift
//  OpenLive
//
//  Created by Sky Xu on 2/21/18.
//  Copyright © 2018 Agora. All rights reserved.
//

import Foundation
import UIKit

class CameraHandler: NSObject {
    
    static let shared = CameraHandler()
    fileprivate var currentVC: UIViewController!
    
    var imagePickedBlock: ((UIImage?) -> Void)?
    
    //    convert img data we fetched from server to UIImage
    func convertBase64ToImgStr(encodedImgData: String) -> UIImage {
        let imgData = NSData(base64Encoded: encodedImgData, options: .ignoreUnknownCharacters) as Data?
        var image: UIImage!
        if let imgData = imgData {
            image = UIImage(data: imgData)
        }
        return image!
    }
    
//    pick from camera view
    func camera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .camera
            currentVC.present(myPickerController, animated: true, completion: nil)
        }
    }
//    pick from photolibrary
    func photoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .photoLibrary
            currentVC.present(myPickerController, animated: true, completion: nil)
        }
    }
    
//    create alert controller and add three action to it
    func showActionSheet(vc: UIViewController) {
        currentVC = vc
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert: UIAlertAction) in
            self.camera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (alert: UIAlertAction) in
            self.photoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancle", style: .cancel, handler: nil))
//        present actionsheet to current VC
        vc.present(actionSheet, animated: true, completion: nil)
    }
}
//extension class for 
extension CameraHandler: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        currentVC.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] {
            self.imagePickedBlock?(image as! UIImage)
        } else {
            print("sth went wrong for pick image")
        }
        currentVC.dismiss(animated: true, completion: nil)
    }
}


