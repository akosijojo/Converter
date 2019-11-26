//
//  Loading.swift
//  Rate Compare App
//
//  Created by Jojo Destreza on 9/25/19.
//  Copyright © 2019 Jojo Destreza. All rights reserved.
//

import UIKit

extension UIViewController {
    func showLoading() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
            
            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.style = UIActivityIndicatorView.Style.gray
            loadingIndicator.startAnimating();
            
            alert.view.addSubview(loadingIndicator)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func hideLoading() {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }

}
