//
//  NotificationViewController.swift
//  Rate Compare App
//
//  Created by Jojo Destreza on 9/9/19.
//  Copyright © 2019 Jojo Destreza. All rights reserved.
//

import UIKit


class NotificationViewController : UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setUpNavigationBar()
    }
    
    func setUpNavigationBar() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "arrow_left")?.withRenderingMode(.alwaysTemplate), for: .normal)
        backButton.setTitle(" Rate Alert", for: .normal)
        backButton.titleLabel?.font = UIFont(name: Fonts.bold, size: 20)
        backButton.sizeToFit()
        backButton.tintColor = Config().colors.whiteBackground
        backButton.titleLabel?.textColor = Config().colors.whiteBackground
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        let leftButton = UIBarButtonItem(customView: backButton)
        
        self.navigationItem.leftBarButtonItem = leftButton
        
        
        let b1 = UIBarButtonItem(image: UIImage(named: "circle_minus")?.withRenderingMode(.alwaysTemplate),style: .plain, target: self, action: #selector(deleteCurrency))
        b1.tintColor = Config().colors.whiteBackground
        
        self.navigationItem.rightBarButtonItem = b1
    }
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func deleteCurrency() {
        
    }
    
    
}
