//
//  BaseMainViewController.swift
//  Rate Compare App
//
//  Created by Jojo Destreza on 9/9/19.
//  Copyright © 2019 Jojo Destreza. All rights reserved.
//

import UIKit

class BaseMainViewController : UIViewController {

    var defaultBarButton = UIBarButtonItem()
    
    lazy var mainTitle : UILabel = {
        let lbl = UILabel()
        lbl.text = ""
        lbl.font = UIFont(name: Fonts.bold, size: 20)
        lbl.sizeToFit()
        lbl.textColor = .white
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpOnViewDidLoad()
        setUpView()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setUpNavigationBar()
    }
    
    func setUpTitleView(text: String) {
        mainTitle.text = text
        let leftItem = UIBarButtonItem(customView: mainTitle)
        self.tabBarController?.navigationItem.leftBarButtonItem = leftItem
    }
    
    func setUpNavigationBar() {
         defaultBarButton = UIBarButtonItem(image: UIImage(named: "bell")?.withRenderingMode(.alwaysTemplate),style: .plain, target: self, action: #selector(bellAction))
        defaultBarButton.tintColor = Config().colors.whiteBackground
        setUpNavigationRightButtons(btn: [defaultBarButton])
    }
    
    func setUpNavigationRightButtons(btn: [UIBarButtonItem]?){
        self.tabBarController?.navigationItem.rightBarButtonItems = btn
    }
    
    @objc func bellAction() {
        let controller = NotificationViewController()
        self.tabBarController?.navigationController?.pushViewController(controller, animated: true)
    }
    
    func setUpView() {
        
    }
    
    func setUpOnViewDidLoad() {
        
    }
}


