//
//  MoneyTransferViewController.swift
//  Rate Compare App
//
//  Created by Jojo Destreza on 11/21/19.
//  Copyright © 2019 Jojo Destreza. All rights reserved.
//

import UIKit
import FlagKit


class MoneyTransferViewController: BaseMainViewController {
   
    var viewMoreExpanded : Bool = false
    
    lazy var scrollView : UIScrollView = {
        let scroll = UIScrollView()
        return scroll
    }()
    
    lazy var topView : UIView = {
        let v = UIView()
        return v
    }()
    
    lazy var topDesc : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: Fonts.bold, size: 20)
        lbl.numberOfLines = 0
        lbl.text = "Find a better provider now"
        return lbl
    }()
    
    lazy var fromCurLabel : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: Fonts.regular, size: 14)
        lbl.text = "  From Currency"
        lbl.layer.cornerRadius = 5
        lbl.backgroundColor = Config().colors.lightGraybackground
        lbl.layer.masksToBounds = true
        return lbl
    }()
    
    lazy var toCurLabel : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: Fonts.regular, size: 14)
        lbl.text = "  To Currency"
        lbl.layer.cornerRadius = 5
        lbl.backgroundColor = Config().colors.lightGraybackground
        lbl.layer.masksToBounds = true
        return lbl
    }()
    
    lazy var txt1 : CustomInputFieldWithLabel = {
        let txt = CustomInputFieldWithLabel()
        txt.label.font = UIFont(name: Fonts.regular, size: 10)
        txt.textField.font = UIFont(name: Fonts.regular, size: 16)
        txt.label.text = "Send"
        txt.textField.placeholder = ""
        txt.textField.setLeftPadding(10)
        return txt
    }()
    
    var refreshBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("Refresh", for: .normal)
        btn.setTitleColor(Config().colors.whiteBackground, for: .normal)
        btn.backgroundColor = Config().colors.blueBgColor
        btn.layer.cornerRadius = 10
        btn.titleLabel?.font = UIFont(name: Fonts.regular, size: 16)
        return btn
    }()
    
    lazy var bottomView : UIView = {
        let v = UIView()
        v.layer.borderColor = Config().colors.blueBgColor.cgColor
        v.layer.borderWidth = 1
        v.layer.cornerRadius = 5
        return v
    }()
    
    lazy var botTitleView : UIView = {
        let v = UIView()
        v.backgroundColor = Config().colors.lightGraybackground
        return v
    }()
    
    lazy var botImageView : UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFit
        v.layer.masksToBounds = true
        v.image = UIImage(named: "Login_icon")
        return v
    }()
    
    lazy var botViewMore : UILabel = {
        let v = UILabel()
        v.text = "More Info"
        v.font = UIFont(name: Fonts.regular, size: 14)
        v.textAlignment = .center
        v.tag = 1
        return v
    }()
    
    lazy var botMainRate : CustomTextFieldWithLabelTop = {
        let txt = CustomTextFieldWithLabelTop()
        txt.label.text = "500 AUD ="
        txt.labelView.tag = 1
        txt.labelView.text = "568 BGN"
        txt.labelView.textColor = Config().colors.grayBackground
        txt.labelView.isUserInteractionEnabled = true
        txt.line.backgroundColor = Config().colors.borderColor
        return txt
    }()
    
    lazy var exchangeRate : CustomLabelWithDescHorizontal = {
        let view =  CustomLabelWithDescHorizontal()
        view.label.text = "Exchange Rate:"
        view.desc.text = "1.1367"
        return view
    }()
    
    lazy var fees : CustomLabelWithDescHorizontal = {
        let view =  CustomLabelWithDescHorizontal()
        view.label.text = "Fees:"
        view.desc.text = "0 AUD"
        return view
    }()
    
    lazy var line : UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = Config().colors.lightGraybackground
        return lbl
    }()
    
    lazy var paymentOptions : CustomLabelWithDescHorizontal = {
        let view =  CustomLabelWithDescHorizontal()
        view.label.text = "Payment Options"
        view.label.textAlignment = .left
        view.desc.text = "Bank Deposit"
        return view
    }()
    
    lazy var withdrawOptions : CustomLabelWithDescHorizontal = {
        let view =  CustomLabelWithDescHorizontal()
        view.label.text = "Withdraw Options"
        view.label.textAlignment = .left
        view.desc.text = "Bank Deposit"
        return view
    }()
    
    lazy var processingTime : CustomLabelWithDescHorizontal = {
        let view =  CustomLabelWithDescHorizontal()
        view.label.text = "Processing Time"
        view.label.textAlignment = .left
        view.desc.text = "1 working day"
        return view
    }()
    
    lazy var speed : CustomLabelWithDescHorizontal = {
        let view =  CustomLabelWithDescHorizontal()
        view.label.text = "Speed"
        view.label.textAlignment = .left
        view.desc.text = "1-4 working days"
        return view
    }()
    
    var gotoTransfer : UIButton = {
        let btn = UIButton()
        btn.setTitle("Go to Money Transfer", for: .normal)
        btn.setTitleColor(Config().colors.whiteBackground, for: .normal)
        btn.backgroundColor = Config().colors.greenBgColor
        btn.layer.cornerRadius = 10
        btn.titleLabel?.font = UIFont(name: Fonts.regular, size: 16)
        return btn
    }()
    
    lazy var botExpandedView : UIView = {
        let v = UIView()
//        v.backgroundColor = Config().colors.lightGraybackground
        v.backgroundColor = .cyan
        return v
    }()
    
    
    override func setUpNavigationBar() {
        setUpTitleView(text: "International Money Transfer")
        
        self.tabBarController?.navigationItem.rightBarButtonItems = nil
    }
    
    override func setUpOnViewDidLoad() {
        self.hidesKeyboardOnTapArround()
    }

    override func setUpView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(-40)
            make.leading.trailing.equalTo(view)
            make.bottom.equalTo(view.layoutMarginsGuide.snp.bottom)
        }
        
        let topTitleHeight : CGFloat = topDesc.text?.height(withConstrainedWidth: view.frame.width - 40, font: UIFont(name: Fonts.bold, size: 20)!) ?? 40
        
        scrollView.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.top.equalTo(scrollView)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(280 + topTitleHeight)
        }

        topView.addSubview(topDesc)
        topDesc.snp.makeConstraints { (make) in
            make.top.equalTo(topView).offset(10)
            make.leading.equalTo(topView)//.offset(20)
            make.trailing.equalTo(topView)//.offset(-20)
            make.height.equalTo(topTitleHeight)
        }
        
        topView.addSubview(txt1)
        txt1.snp.makeConstraints { (make) in
            make.top.equalTo(topDesc.snp.bottom).offset(20)
            make.leading.equalTo(topView)//.offset(20)
            make.trailing.equalTo(topView)//.offset(-20)
            make.height.equalTo(60)
        }
        
        topView.addSubview(fromCurLabel)
        fromCurLabel.snp.makeConstraints { (make) in
            make.top.equalTo(txt1.snp.bottom).offset(20)
            make.leading.equalTo(topView)//.offset(20)
            make.trailing.equalTo(topView)//.offset(-20)
            make.height.equalTo(40)
        }
        fromCurLabel.layer.cornerRadius = 5
        
        topView.addSubview(toCurLabel)
        toCurLabel.snp.makeConstraints { (make) in
            make.top.equalTo(fromCurLabel.snp.bottom).offset(10)
            make.leading.equalTo(topView)//.offset(20)
            make.trailing.equalTo(topView)//.offset(-20)
            make.height.equalTo(40)
        }
        toCurLabel.layer.cornerRadius = 5
        
        topView.addSubview(refreshBtn)
        refreshBtn.snp.makeConstraints { (make) in
            make.top.equalTo(toCurLabel.snp.bottom).offset(20)
            make.leading.equalTo(topView)//.offset(20)
            make.trailing.equalTo(topView)//.offset(-20)
            make.height.equalTo(40)
        }
        refreshBtn.layer.cornerRadius = 5
        
        scrollView.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(410)
            make.bottom.equalTo(scrollView).offset(-20)
        }
        
        ////////////////////////
        bottomView.addSubview(botTitleView)
        botTitleView.snp.makeConstraints { (make) in
            make.top.equalTo(bottomView)
            make.leading.trailing.equalTo(bottomView)
            make.height.equalTo(80)
        }
        
            botTitleView.addSubview(botImageView)
            botImageView.snp.makeConstraints { (make) in
                make.top.equalTo(botTitleView).offset(5)
                make.height.equalTo(50)
                make.width.equalTo(botTitleView).multipliedBy(0.5)
                make.centerX.equalTo(botTitleView)
            }
        
        
            botTitleView.addSubview(botViewMore)
            botViewMore.snp.makeConstraints { (make) in
                make.top.equalTo(botImageView.snp.bottom)
                make.bottom.equalTo(botTitleView).offset(-5)
                make.leading.equalTo(botTitleView).offset(20)
                make.trailing.equalTo(botTitleView).offset(-20)
            }
        /////////////////////
        
        bottomView.addSubview(botMainRate)
        botMainRate.snp.makeConstraints { (make) in
            make.top.equalTo(botTitleView.snp.bottom).offset(20)
            make.centerX.equalTo(bottomView)
            make.width.equalTo(100)
            make.height.equalTo(60)
        }
        
        bottomView.addSubview(exchangeRate)
        exchangeRate.snp.makeConstraints { (make) in
            make.top.equalTo(botMainRate.snp.bottom).offset(20)
            make.leading.equalTo(bottomView).offset(20)
            make.trailing.equalTo(bottomView).offset(-20)
            make.height.equalTo(20)
        }
        
        bottomView.addSubview(fees)
        fees.snp.makeConstraints { (make) in
            make.top.equalTo(exchangeRate.snp.bottom).offset(10)
            make.leading.equalTo(bottomView).offset(20)
            make.trailing.equalTo(bottomView).offset(-20)
            make.height.equalTo(20)
        }
        
        bottomView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.top.equalTo(fees.snp.bottom).offset(20)
            make.leading.equalTo(bottomView).offset(20)
            make.trailing.equalTo(bottomView).offset(-20)
            make.height.equalTo(1)
        }
        
        bottomView.addSubview(paymentOptions)
        paymentOptions.snp.makeConstraints { (make) in
            make.top.equalTo(line.snp.bottom).offset(10)
            make.leading.equalTo(bottomView).offset(20)
            make.trailing.equalTo(bottomView).offset(-20)
            make.height.equalTo(20)
        }
        
        bottomView.addSubview(withdrawOptions)
        withdrawOptions.snp.makeConstraints { (make) in
            make.top.equalTo(paymentOptions.snp.bottom)
            make.leading.equalTo(bottomView).offset(20)
            make.trailing.equalTo(bottomView).offset(-20)
            make.height.equalTo(20)
        }
        
        bottomView.addSubview(processingTime)
        processingTime.snp.makeConstraints { (make) in
            make.top.equalTo(withdrawOptions.snp.bottom)
            make.leading.equalTo(bottomView).offset(20)
            make.trailing.equalTo(bottomView).offset(-20)
            make.height.equalTo(20)
        }
        
        bottomView.addSubview(speed)
        speed.snp.makeConstraints { (make) in
            make.top.equalTo(processingTime.snp.bottom)
            make.leading.equalTo(bottomView).offset(20)
            make.trailing.equalTo(bottomView).offset(-20)
            make.height.equalTo(20)
        }
        
        bottomView.addSubview(gotoTransfer)
        gotoTransfer.snp.makeConstraints { (make) in
            make.top.equalTo(speed.snp.bottom).offset(10)
            make.leading.equalTo(bottomView).offset(20)
            make.trailing.equalTo(bottomView).offset(-20)
            make.height.equalTo(40)
        }
        
        bottomView.addSubview(botExpandedView)
        botExpandedView.snp.makeConstraints { (make) in
            make.top.equalTo(gotoTransfer.snp.bottom).offset(20)
            make.leading.trailing.equalTo(bottomView)
            make.height.equalTo(0)
        }
        
        
        let viewMoreTap = UITapGestureRecognizer(target: self, action: #selector(viewMoreAction))
        botViewMore.isUserInteractionEnabled = true
        botViewMore.addGestureRecognizer(viewMoreTap)
    }
    
    @objc func viewMoreAction(_ sender: UIGestureRecognizer ) {
        let height : CGFloat = !viewMoreExpanded ? 600 : 410
        viewMoreExpanded = viewMoreExpanded ? false : true
        
        UIView.animate(withDuration: 1.0) {
            self.bottomView.snp.updateConstraints { (make) in
                make.height.equalTo(height)
            }
            if self.viewMoreExpanded {
                self.botExpandedView.snp.remakeConstraints { (make) in
                    make.top.equalTo(self.gotoTransfer.snp.bottom).offset(20)
                    make.leading.trailing.equalTo(self.bottomView)
                    make.bottom.equalTo(self.bottomView)
                }
            }else {
                self.botExpandedView.snp.remakeConstraints { (make) in
                    make.top.equalTo(self.gotoTransfer.snp.bottom).offset(20)
                    make.leading.trailing.equalTo(self.bottomView)
                    make.height.equalTo(0)
                }
            }
            self.view.layoutIfNeeded()
        }
    }
}




class CustomLabelWithDescHorizontal : UIView {
    lazy var label : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: Fonts.bold, size: 14)
        lbl.textAlignment = .right
        return lbl
    }()
    
    lazy var desc : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: Fonts.regular, size: 14)
        lbl.textAlignment = .center
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView() {
        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.leading.equalTo(self)
            make.width.equalTo(self).multipliedBy(0.5)
            make.bottom.equalTo(self)
        }
        addSubview(desc)
        desc.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.leading.equalTo(label.snp.trailing).offset(20)
            make.trailing.equalTo(self)
            make.bottom.equalTo(self)
        }
    }
}
