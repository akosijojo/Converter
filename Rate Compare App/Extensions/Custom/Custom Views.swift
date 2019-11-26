//
//  Custom Views.swift
//  Rate Compare App
//
//  Created by Jojo Destreza on 9/12/19.
//  Copyright © 2019 Jojo Destreza. All rights reserved.
//

import UIKit


class CustomTextFieldWithLabel : UIView {
    
    lazy var label : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: Fonts.regular, size: 14)
        lbl.textAlignment = .left
        return lbl
    }()
    
    lazy var textField : TextField = {
        let txt = TextField()
        txt.placeholder = ""
        txt.layer.borderWidth = 1
        txt.layer.borderColor = Config().colors.borderColor.cgColor
        txt.font = UIFont(name: Fonts.regular, size: 16)
        txt.clearButtonMode = .whileEditing
        txt.layer.cornerRadius = 5
        return txt
    }()
    
    let imageViewR : UIImageView = {
        let i = UIImageView()
        i.isUserInteractionEnabled = true
        return i
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView() {
        self.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.height.equalTo(20)
        }
        
        self.addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.top.equalTo(label.snp.bottom).offset(10)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.height.equalTo(40)
        }
     
    }
    
    
    func showRightImageView() {
        textField.clearButtonMode = .never
        textField.addSubview(imageViewR)
        imageViewR.snp.makeConstraints { (make) in
            make.trailing.equalTo(textField).offset(-10)
            make.centerY.equalTo(textField)
            make.width.height.equalTo(20)
        }
        textField.padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 30)
    }

}

class CustomButtonBottom : UIView {
    
    var btn : UIButton = {
        let btn = UIButton()
        btn.setTitle("Submit", for: .normal)
        btn.setTitleColor(Config().colors.whiteBackground, for: .normal)
        btn.backgroundColor = Config().colors.blueBgColor
        return btn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView()  {
        self.addSubview(btn)
        let bottomPadding = Config().bottomScreenInset
        btn.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.leading.equalTo(self).offset(bottomPadding > 0 ? 10 : 0)
            make.trailing.equalTo(self).offset(bottomPadding > 0 ? -10 : 0)
            make.bottom.equalTo(self)
        }
        btn.layer.cornerRadius = bottomPadding > 0 ? 10 : 0
        
    }
    
}

class Custom2Button : UIView {
    
    var btn1 : UIButton = {
        let btn = UIButton()
        btn.setTitle("Cancel", for: .normal)
        btn.setTitleColor(Config().colors.blackBgColor, for: .normal)
        btn.backgroundColor = .clear
        btn.titleLabel?.font = UIFont(name: Fonts.regular, size: 14)
        return btn
    }()
    
    var btn2 : UIButton = {
        let btn = UIButton()
        btn.setTitle("Agree", for: .normal)
        btn.setTitleColor(Config().colors.whiteBackground, for: .normal)
        btn.backgroundColor = Config().colors.blueBgColor
        btn.layer.cornerRadius = 5
        btn.titleLabel?.font = UIFont(name: Fonts.regular, size: 14)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView()  {
        self.backgroundColor = Config().colors.lightGraybackground
        self.addSubview(btn1)
        btn1.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(20)
            make.width.equalTo((Config().screenWidth - 60) / 2)
            make.leading.equalTo(self).offset(20)
            make.bottom.equalTo(self).offset(-20)
        }
        
        self.addSubview(btn2)
        btn2.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(20)
            make.width.equalTo((Config().screenWidth - 60) / 2)
            make.trailing.equalTo(self).offset(-20)
            make.bottom.equalTo(self).offset(-20)
        }
    }
    
    
}




class CustomTextFieldwithImage : UIView {
    
    let textField : UITextField = {
        let t = UITextField()
        return t
    }()
    
    let imageViewL : UIImageView = {
        let i = UIImageView()
        return i
    }()
    
    let imageViewR : UIImageView = {
        let i = UIImageView()
        i.isUserInteractionEnabled = true
        return i
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView() {
        addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.height.equalTo(self)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-50)
        }
        
        addSubview(imageViewR)
        imageViewR.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.height.equalTo(20)
            make.trailing.equalTo(self).offset(-20)
            make.width.equalTo(20)
        }
        
    }
    
}

class CustomTextFieldWithLabelTop : UIView {
    
    lazy var label : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: Fonts.regular, size: 12)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.2
        lbl.textAlignment = .center
        return lbl
    }()
    
    lazy var labelView : UILabel = {
        let lbl = UILabel()
        lbl.font =  UIFont(name: Fonts.bold, size: 20)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.2
        lbl.textAlignment = .center
        return lbl
    }()
    
    lazy var labelBottom : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: Fonts.regular, size: 12)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.2
        lbl.textAlignment = .center
        lbl.textColor = Config().colors.redBgColor
        return lbl
    }()
    
    lazy var line : UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = Config().colors.lightGraybackground
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
            make.trailing.equalTo(self)
            make.height.equalTo(20)
        }
        
        addSubview(labelView)
        labelView.snp.makeConstraints { (make) in
            make.top.equalTo(label.snp.bottom)
            make.centerX.equalTo(self)
            make.width.equalTo(self)
            make.bottom.equalTo(self).offset(-1)
        }
    }
    
    func showUnderline() {
        addSubview(line)
        line.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self)
            make.height.equalTo(1)
            make.bottom.equalTo(self)
        }
    }
    
    func showUnderlabelBottom() {
        labelView.snp.updateConstraints { (make) in
            make.bottom.equalTo(self).offset(-26)
        }
        addSubview(line)
        line.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self)
            make.height.equalTo(1)
            make.bottom.equalTo(self)
        }
        addSubview(labelBottom)
        labelBottom.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self)
            make.height.equalTo(20)
            make.bottom.equalTo(line.snp.top).offset(-5)
        }
        
        
    }
}


class CustomTextFieldWithLabelTopEditable : CustomTextFieldWithLabelTop {
    
    lazy var textField : UITextField = {
        let lbl = UITextField()
        lbl.font =  UIFont(name: Fonts.bold, size: 20)
        //        lbl.adjustsFontSizeToFitWidth = true
        //        lbl.minimumFontSize = 0.8
        lbl.textAlignment = .center
        return lbl
    }()
    
    
    override func setUpView() {
        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.height.equalTo(20)
        }
        
        addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.top.equalTo(label.snp.bottom)
            make.centerX.equalTo(self)
            make.width.equalTo(self)
            make.bottom.equalTo(self)
        }
    }
}


class CustomInputFieldWithLabel : UIView {
    lazy var label : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: Fonts.regular, size: 12)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.2
        return lbl
    }()
    
    lazy var textField : UITextField = {
        let txt = UITextField()
        txt.font =  UIFont(name: Fonts.bold, size: 20)
        //        lbl.adjustsFontSizeToFitWidth = true
        //        lbl.minimumFontSize = 0.8
        txt.layer.cornerRadius = 5
        txt.layer.borderWidth = 1
        txt.layer.borderColor = UIColor.gray.cgColor
        return txt
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView() {
        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.height.equalTo(20)
        }
        
        addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.top.equalTo(label.snp.bottom)
            make.centerX.equalTo(self)
            make.width.equalTo(self)
            make.bottom.equalTo(self)
        }
    }
}


class CustomButtonView : UIView {
    lazy var button : UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont(name: Fonts.regular, size: 14)
        btn.setTitleColor(Config().colors.blackBgColor, for: .normal)
        return btn
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView() {
        addSubview(button)
        button.snp.makeConstraints { (make) in
            make.top.leading.equalTo(self)
            make.trailing.bottom.equalTo(self)
        }
        button.layer.cornerRadius = 15
    }
}

class CustomImageViewButton : UIView {
    var height : CGFloat = 0
    
    lazy var imageView : UIImageView = {
        let img = UIImageView()
        img.backgroundColor = Config().colors.lightGraybackground
        img.contentMode = .scaleAspectFit
        img.layer.masksToBounds = true
        return img
    }()
    
    lazy var label : UILabel = {
        let l = UILabel()
        l.font =   UIFont(name: Fonts.bold, size: 14)
        l.textColor = Config().colors.blackBgColor
        l.adjustsFontSizeToFitWidth = true
        l.minimumScaleFactor = 0.4
        return l
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView() {
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.width.height.equalTo(30)
            make.leading.equalTo(self).offset(20)
        }
        imageView.layer.cornerRadius = 15
        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(10)
            make.trailing.equalTo(self).offset(-20)
            make.leading.equalTo(imageView.snp.trailing).offset(10)
            make.bottom.equalTo(self).offset(-10)
        }
    }
}



class CustomButtonViewWithImage : CustomButtonView {
    lazy var imageView : UIImageView = {
        let img = UIImageView()
        img.layer.masksToBounds = true
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    
    override func setUpView() {
        addSubview(button)
        button.snp.makeConstraints { (make) in
            make.top.leading.equalTo(self)
            make.trailing.bottom.equalTo(self)
        }
        button.layer.cornerRadius = 15
    }
}


