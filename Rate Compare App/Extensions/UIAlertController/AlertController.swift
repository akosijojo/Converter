//
//  AlertController.swift
//  Rate Compare App
//
//  Created by Jojo Destreza on 9/16/19.
//  Copyright © 2019 Jojo Destreza. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func alert(_ buttonTitle: String, _ title: String, _ message: String, action: @escaping (UIAlertAction) -> Void) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: action))
        return alert
    }
    
    func alertWithActions(_ ok: String, _ cancel: String,_ title: String, _ message: String, actionOk: @escaping (UIAlertAction) -> Void, actionCancel: @escaping (UIAlertAction) -> Void) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: cancel, style: .default, handler: actionCancel))
        alert.addAction(UIAlertAction(title: ok, style: .default, handler: actionOk))
        return alert
    }
    
}
