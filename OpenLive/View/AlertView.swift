//
//  AlertView.swift
//  OpenLive
//
//  Created by Sky Xu on 3/19/18.
//  Copyright © 2018 Sky.com. All rights reserved.
//

import Foundation
import UIKit

protocol PassAlertActionDelegate: class {
    func alertActionForOk(completion: @escaping (_ success: Bool) -> Void)
    func alertActionForCancle(completion: @escaping (_ success: Bool) -> Void)
}
class AlertView {
    let alertTitle: String
    let alertMsg: String
    public private(set) var ifSelected = false
    init(alertTitle: String, alertMsg: String) {
        self.alertTitle = alertTitle
        self.alertMsg = alertMsg
    }
    weak var delegate: PassAlertActionDelegate?
    
   lazy var alertController = UIAlertController(title: alertTitle, message: alertMsg, preferredStyle: .alert)
    
    func configureView(proceedMsg: String, cancelMsg: String) {
       
        alertController.addAction(UIAlertAction(title: proceedMsg, style: .default, handler: { (action: UIAlertAction!) in
            self.delegate?.alertActionForOk(completion: { [unowned self] (success) in
                if success {
                    self.ifSelected = true
                }
            })
        }))
        
        alertController.addAction(UIAlertAction(title: cancelMsg, style: .cancel, handler: { (action: UIAlertAction!) in
            self.delegate?.alertActionForCancle(completion: { [unowned self] (success) in
                if success {
                    self.ifSelected = true
                }
            })
        }))
    }
    
}
