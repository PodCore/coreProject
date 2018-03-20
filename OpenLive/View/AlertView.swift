//
//  AlertView.swift
//  OpenLive
//
//  Created by Sky Xu on 3/19/18.
//  Copyright © 2018 Agora. All rights reserved.
//

import Foundation
import UIKit

protocol PassAlertActionDelegate: class {
    func alertActionForOk()
     func alertActionForCancle()
}
class AlertView {
    let alertTitle: String
    let alertMsg: String
    
    init(alertTitle: String, alertMsg: String) {
        self.alertTitle = alertTitle
        self.alertMsg = alertMsg
    }
    weak var delegate: PassAlertActionDelegate?
    
   lazy var alertController = UIAlertController(title: alertTitle, message: alertMsg, preferredStyle: .alert)
    
    func configureView(proceedMsg: String, cancelMsg: String) {
       
        alertController.addAction(UIAlertAction(title: proceedMsg, style: .default, handler: { (action: UIAlertAction!) in
            self.delegate?.alertActionForOk()
//            self.alertController.dismiss(animated: true, completion: nil)
        }))
        
        alertController.addAction(UIAlertAction(title: cancelMsg, style: .cancel, handler: { (action: UIAlertAction!) in
            self.delegate?.alertActionForCancle()
//            self.alertController.dismiss(animated: true, completion: nil)
        }))
    }
    
}
