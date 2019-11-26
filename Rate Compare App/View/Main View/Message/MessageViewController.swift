//
//  MessageViewController.swift
//  Rate Compare App
//
//  Created by Jojo Destreza on 9/9/19.
//  Copyright © 2019 Jojo Destreza. All rights reserved.
//

import UIKit

class MessageViewController: BaseMainViewController {
    
    lazy var titleLabel : UILabel = {
        let lbl = UILabel()
        lbl.text = "Now you can \nSend money \nUsing the app!"
        lbl.font = UIFont(name: Fonts.bold, size: 30)
        lbl.sizeToFit()
        lbl.minimumScaleFactor = 0.2
        lbl.adjustsFontSizeToFitWidth = true
        lbl.textColor = .white
        lbl.numberOfLines = 3
        return lbl
    }()
    
    lazy var descLabel : UILabel = {
        let lbl = UILabel()
        lbl.text = "Takes advantages of great rates, \n no transaction fees and track your money \nuntil delivered"
        lbl.font = UIFont(name: Fonts.regular, size: 18)
        lbl.sizeToFit()
        lbl.textColor = .white
        lbl.minimumScaleFactor = 0.2
        lbl.adjustsFontSizeToFitWidth = true
        lbl.numberOfLines = 3
        return lbl
    }()
    
    lazy var getStartedButton : UIButton = {
        let btn = UIButton()
        btn.setTitle("Get Started", for: .normal)
        btn.tintColor = Config().colors.whiteBackground
        btn.titleLabel?.font = UIFont(name: Fonts.bold, size: 16)
        btn.layer.cornerRadius = 30
        btn.backgroundColor = Config().colors.darkBlueBgColor
        btn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        btn.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        btn.layer.shadowOpacity = 1.0
        btn.layer.shadowRadius = 0.0
        btn.layer.masksToBounds = false
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Config().colors.blueBgColor

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        System.clearNavigationBar(forBar: (self.tabBarController?.navigationController?.navigationBar)!)
        System.clearNavigationBar(forBar: (self.navigationController?.navigationBar)!)
        self.tabBarController?.tabBar.tintColor = Config().colors.whiteBackground
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController?.tabBar.tintColor = Config().colors.blueBgColor
        System.showNavigationBar(forBar: (self.tabBarController?.navigationController?.navigationBar)!)
        System.showNavigationBar(forBar: (self.navigationController?.navigationBar)!)
    }
  
    override func setUpNavigationBar() {
        setUpTitleView(text: "Send Money")
        
        self.tabBarController?.navigationItem.rightBarButtonItems = nil
//        defaultBarButton = UIBarButtonItem(image: UIImage(named: "bell")?.withRenderingMode(.alwaysTemplate),style: .plain, target: self, action: #selector(bellAction))
//        defaultBarButton.tintColor = Config().colors.whiteBackground
//        self.tabBarController?.navigationItem.rightBarButtonItems = [defaultBarButton]
    }
    
    override func setUpView() {
        
        view.addSubview(descLabel)
        //        descLabel.backgroundColor = .red
        descLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(view).offset(-20)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(80)
        }
        
        view.addSubview(titleLabel)
//        titleLabel.backgroundColor = .green
        titleLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(descLabel.snp.top).offset(-20)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(120)
        }
        
        view.addSubview(getStartedButton)
        getStartedButton.snp.makeConstraints { (make) in
            make.top.equalTo(descLabel.snp.bottom).offset(20)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(60)
        }
    }
}
