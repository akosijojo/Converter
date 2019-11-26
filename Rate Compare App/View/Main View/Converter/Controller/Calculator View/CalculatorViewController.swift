//
//  CalculatorViewController.swift
//  Rate Compare App
//
//  Created by Jojo Destreza on 9/16/19.
//  Copyright © 2019 Jojo Destreza. All rights reserved.
//

import UIKit

class CalculatorViewController : UIViewController {
    
    
    var changesOnAmount : Bool = false
    var onLoad : Bool = true
    var vc : UIViewController?
    var wholeInput : Double = 0
    var perNewNumber : String = ""
    var performMath : Bool = false
    var inputString : Double = 0.0
    lazy var countryImage : UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.layer.masksToBounds = true
        img.backgroundColor = Config().colors.lightGraybackground
        return img
    }()
    
    lazy var countryName : UILabel = {
        let lbl = UILabel()
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.2
        lbl.font = UIFont(name: Fonts.bold, size: 14)
        lbl.text = ""
        lbl.textColor = .black
        return lbl
    }()
    
    lazy var countryCurrency : UILabel = {
        let lbl = UILabel()
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.2
        lbl.font = UIFont(name: Fonts.regular, size: 14)
        lbl.text = ""
        lbl.textColor = .black
        return lbl
    }()
    
    lazy var mainView : UIView = {
        let v = UIView()
        return v
    }()
    
    lazy var textField : UITextField = {
        let txt = UITextField()
        txt.adjustsFontSizeToFitWidth = true
        txt.minimumFontSize = 0.2
        txt.font = UIFont(name: Fonts.regular, size: 30)
        txt.placeholder = "0"
        txt.textAlignment = .right
        txt.isEnabled = false
        return txt
    }()
    
    lazy var buttonsView : UIView = {
        let v = UIView()
        return v
    }()
    
    lazy var btn1 : UIButton = {
        let btn = UIButton()
        btn.setTitleColor(Config().colors.blackBgColor, for: .normal)
        btn.setTitle("1", for: .normal)
        btn.titleLabel?.font = UIFont(name: Fonts.medium, size: 30)
        btn.addTarget(self, action: #selector(onClickButton(_:)), for: .touchUpInside)
        btn.tag = 1
        return btn
    }()
    
    lazy var btn2 : UIButton = {
        let btn = UIButton()
        btn.setTitleColor(Config().colors.blackBgColor, for: .normal)
        btn.setTitle("2", for: .normal)
        btn.titleLabel?.font = UIFont(name: Fonts.medium, size: 30)
        btn.addTarget(self, action: #selector(onClickButton(_:)), for: .touchUpInside)
        btn.tag = 2
        return btn
    }()
    
    lazy var btn3 : UIButton = {
        let btn = UIButton()
        btn.setTitleColor(Config().colors.blackBgColor, for: .normal)
        btn.setTitle("3", for: .normal)
        btn.titleLabel?.font = UIFont(name: Fonts.medium, size: 30)
        btn.addTarget(self, action: #selector(onClickButton(_:)), for: .touchUpInside)
        btn.tag = 3
        return btn
    }()
    
    lazy var btn4 : UIButton = {
        let btn = UIButton()
        btn.setTitleColor(Config().colors.blackBgColor, for: .normal)
        btn.setTitle("4", for: .normal)
        btn.titleLabel?.font = UIFont(name: Fonts.medium, size: 30)
        btn.addTarget(self, action: #selector(onClickButton(_:)), for: .touchUpInside)
        btn.tag = 4
        return btn
    }()
    
    lazy var btn5 : UIButton = {
        let btn = UIButton()
        btn.setTitleColor(Config().colors.blackBgColor, for: .normal)
        btn.setTitle("5", for: .normal)
        btn.titleLabel?.font = UIFont(name: Fonts.medium, size: 30)
        btn.addTarget(self, action: #selector(onClickButton(_:)), for: .touchUpInside)
        btn.tag = 5
        return btn
    }()
    
    lazy var btn6 : UIButton = {
        let btn = UIButton()
        btn.setTitleColor(Config().colors.blackBgColor, for: .normal)
        btn.setTitle("6", for: .normal)
        btn.titleLabel?.font = UIFont(name: Fonts.medium, size: 30)
        btn.addTarget(self, action: #selector(onClickButton(_:)), for: .touchUpInside)
        btn.tag = 6
        return btn
    }()
    
    lazy var btn7 : UIButton = {
        let btn = UIButton()
        btn.setTitleColor(Config().colors.blackBgColor, for: .normal)
        btn.setTitle("7", for: .normal)
        btn.titleLabel?.font = UIFont(name: Fonts.medium, size: 30)
        btn.addTarget(self, action: #selector(onClickButton(_:)), for: .touchUpInside)
        btn.tag = 7
        return btn
    }()
    
    lazy var btn8 : UIButton = {
        let btn = UIButton()
        btn.setTitleColor(Config().colors.blackBgColor, for: .normal)
        btn.setTitle("8", for: .normal)
        btn.titleLabel?.font = UIFont(name: Fonts.medium, size: 30)
        btn.addTarget(self, action: #selector(onClickButton(_:)), for: .touchUpInside)
        btn.tag = 8
        return btn
    }()
    
    lazy var btn9 : UIButton = {
        let btn = UIButton()
        btn.setTitleColor(Config().colors.blackBgColor, for: .normal)
        btn.setTitle("9", for: .normal)
        btn.titleLabel?.font = UIFont(name: Fonts.medium, size: 30)
        btn.addTarget(self, action: #selector(onClickButton(_:)), for: .touchUpInside)
        btn.tag = 9
        return btn
    }()
    
    lazy var btn0 : UIButton = {
        let btn = UIButton()
        btn.setTitleColor(Config().colors.blackBgColor, for: .normal)
        btn.setTitle("0", for: .normal)
        btn.titleLabel?.font = UIFont(name: Fonts.medium, size: 30)
        btn.addTarget(self, action: #selector(onClickButton(_:)), for: .touchUpInside)
        btn.tag = 0
        return btn
    }()
    
    
    lazy var btnPoint : UIButton = {
        let btn = UIButton()
        btn.setTitleColor(Config().colors.blackBgColor, for: .normal)
        btn.setTitle(".", for: .normal)
        btn.titleLabel?.font = UIFont(name: Fonts.medium, size: 40)
        btn.addTarget(self, action: #selector(onClickPoint(_:)), for: .touchUpInside)
        btn.tag = 16
        return btn
    }()
    
    lazy var btnDel : UIButton = {
        let btn = UIButton()
        btn.setTitleColor(Config().colors.blackBgColor, for: .normal)
        btn.setTitle("Del", for: .normal)
        btn.titleLabel?.font = UIFont(name: Fonts.regular, size: 16)
        btn.addTarget(self, action: #selector(onClickChangesInput(_:)), for: .touchUpInside)
        btn.tag = 15
        return btn
    }()
    
    
    lazy var btnDone : UIButton = {
        let btn = UIButton()
        btn.setTitle("DONE", for: .normal)
        btn.titleLabel?.font = UIFont(name: Fonts.medium, size: 16)
        btn.backgroundColor = Config().colors.blueBgColor
        btn.setTitleColor(Config().colors.whiteBackground, for: .normal)
        btn.addTarget(self, action: #selector(btnDoneAction), for: .touchUpInside)
        return btn
    }()
    
    lazy var btnClear : UIButton = {
        let btn = UIButton()
        btn.setTitle("AC", for: .normal)
        btn.titleLabel?.font = UIFont(name: Fonts.medium, size:16)
//        btn.backgroundColor = Config().colors.blueBgColor
        btn.setTitleColor(Config().colors.blueBgColor, for: .normal)
        btn.addTarget(self, action: #selector(onClickChangesInput(_:)), for: .touchUpInside)
        btn.tag = 17
        return btn
    }()
    
    
    lazy var btnPlus : UIButton = {
        let btn = UIButton()
        btn.setTitle("+", for: .normal)
        btn.titleLabel?.font = UIFont(name: Fonts.medium, size: 30)
        btn.setTitleColor(Config().colors.blueBgColor, for: .normal)
        btn.addTarget(self, action: #selector(onClickOperations(_:)), for: .touchUpInside)
        btn.tag = 14
        return btn
    }()
    
    lazy var btnMinus : UIButton = {
        let btn = UIButton()
        btn.setTitle("-", for: .normal)
        btn.titleLabel?.font = UIFont(name: Fonts.medium, size: 30)
        btn.setTitleColor(Config().colors.blueBgColor, for: .normal)
        btn.addTarget(self, action: #selector(onClickOperations(_:)), for: .touchUpInside)
        btn.tag = 13
        return btn
    }()
    
    
    lazy var btnMultiply : UIButton = {
        let btn = UIButton()
        btn.setTitle("×", for: .normal)
        btn.titleLabel?.font = UIFont(name: Fonts.medium, size: 30)
        btn.setTitleColor(Config().colors.blueBgColor, for: .normal)
        btn.addTarget(self, action: #selector(onClickOperations(_:)), for: .touchUpInside)
        btn.tag = 12
        return btn
    }()
    
    lazy var btnDivide : UIButton = {
        let btn = UIButton()
        btn.setTitle("÷", for: .normal)
        btn.titleLabel?.font = UIFont(name: Fonts.medium, size: 30)
        btn.setTitleColor(Config().colors.blueBgColor, for: .normal)
        btn.addTarget(self, action: #selector(onClickOperations(_:)), for: .touchUpInside)
        btn.tag = 11
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpView()
        navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
    }
    
    init(img: UIImage? = nil,name: String? = nil,currency: String? = nil,vc: UIViewController,amount: Double) {
        super.init(nibName: nil, bundle: nil)
        print("ITEMS : \(name) , \(currency)")
        self.countryImage.image = img
        self.countryName.text = name
        self.countryCurrency.text = currency
        self.vc = vc
        self.textField.text = "\(String(format: "%.4f", amount))"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "arrow_left")?.withRenderingMode(.alwaysTemplate), for: .normal)
        backButton.setTitle(" Back", for: .normal)
        backButton.titleLabel?.font = UIFont(name: Fonts.bold, size: 20)
        backButton.sizeToFit()
        backButton.tintColor = Config().colors.whiteBackground
        backButton.titleLabel?.textColor = Config().colors.whiteBackground
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        let leftButton = UIBarButtonItem(customView: backButton)
        
        self.navigationItem.leftBarButtonItem = leftButton
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if textField.text != "" && changesOnAmount {
            let text = self.textField.text?.convertComputation() ?? ""
               if let res = text.expression.expressionValue(with: Double.self, context: nil) as? Double {
                    print("CONVERTED COMPUTATION : \(text)  == \(res)")
                    if let vc = vc as? ConverterViewController {
                        if let result = res as? Double {
                            vc.amount = result
                        }
                    }else  if let vc = vc as? CompareViewController {
                        if let result = res as? Double {
                            if (self.countryName.text ?? "") == vc.saveCompared.base {
                                vc.paidInput = result
                            }else {
                                vc.receiveInput = result
                            }
                        }
                    }
                
                
                
              }
        }
       
    }
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setUpView() {
        view.addSubview(countryImage)
        countryImage.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalTo(view).offset(20)
            make.width.equalTo(60)
            make.height.equalTo(60)
        }
        
        countryImage.layer.cornerRadius = 60 / 2
        
       view.addSubview(countryName)
        countryName.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalTo(countryImage.snp.trailing).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(20)
        }
        
        view.addSubview(countryCurrency)
        countryCurrency.snp.makeConstraints { (make) in
            make.top.equalTo(countryName.snp.bottom)
            make.leading.equalTo(countryImage.snp.trailing).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(20)
        }
        
        view.addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.top.equalTo(countryImage.snp.bottom).offset(10)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(150)
        }
        
        mainView.addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.leading.equalTo(mainView)
            make.trailing.equalTo(mainView)
            make.bottom.equalTo(mainView)
        }
        
        view.addSubview(buttonsView)
        buttonsView.snp.makeConstraints { (make) in
            make.height.equalTo(view).multipliedBy(0.5)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        
        let width = (Config().screenWidth - 40) / 4
        let height = (view.safeAreaLayoutGuide.layoutFrame.height / 2) / 5
        
       lastLayer(width: width,height: height)
       thirdLayer(width: width,height: height)
       secondLayer(width: width,height: height)
       firstLayer(width: width,height: height)
        
    }
    
    func firstLayer(width: CGFloat,height: CGFloat) {
        buttonsView.addSubview(btn7)
//        btn7.backgroundColor = .red
        btn7.snp.makeConstraints { (make) in
            make.top.equalTo(buttonsView)
            make.width.equalTo(width)
            make.trailing.equalTo(btn8.snp.leading)
            make.height.equalTo(height)
        }
        
        buttonsView.addSubview(btn4)
//        btn4.backgroundColor = .cyan
        btn4.snp.makeConstraints { (make) in
            make.top.equalTo(btn7.snp.bottom)
            make.width.equalTo(width)
            make.trailing.equalTo(btn5.snp.leading)
            make.height.equalTo(height)
        }
        
        buttonsView.addSubview(btn1)
//        btn1.backgroundColor = .yellow
        btn1.snp.makeConstraints { (make) in
            make.top.equalTo(btn4.snp.bottom)
            make.width.equalTo(width)
            make.trailing.equalTo(btn2.snp.leading)
            make.height.equalTo(height)
        }
        
        buttonsView.addSubview(btn0)
//        btn0.backgroundColor = .purple
        btn0.snp.makeConstraints { (make) in
            make.top.equalTo(btn1.snp.bottom)
            make.width.equalTo(width)
            make.trailing.equalTo(btnPoint.snp.leading)
            make.height.equalTo(height)
        }
        
    }
    
    
    func secondLayer(width: CGFloat,height: CGFloat) {
        buttonsView.addSubview(btn8)
//        btn8.backgroundColor = .red
        btn8.snp.makeConstraints { (make) in
            make.top.equalTo(buttonsView)
            make.width.equalTo(width)
            make.trailing.equalTo(btn9.snp.leading)
            make.height.equalTo(height)
        }
        
        buttonsView.addSubview(btn5)
//        btn5.backgroundColor = .cyan
        btn5.snp.makeConstraints { (make) in
            make.top.equalTo(btn8.snp.bottom)
            make.width.equalTo(width)
            make.trailing.equalTo(btn6.snp.leading)
            make.height.equalTo(height)
        }
        
        buttonsView.addSubview(btn2)
//        btn2.backgroundColor = .yellow
        btn2.snp.makeConstraints { (make) in
            make.top.equalTo(btn5.snp.bottom)
            make.width.equalTo(width)
            make.trailing.equalTo(btn3.snp.leading)
            make.height.equalTo(height)
        }
        
        buttonsView.addSubview(btnPoint)
//        btnPoint.backgroundColor = .purple
        btnPoint.snp.makeConstraints { (make) in
            make.top.equalTo(btn2.snp.bottom).offset(height / 6)
            make.width.equalTo(width)
            make.trailing.equalTo(btnDel.snp.leading)
            make.height.equalTo(height / 2)
        }
        
    }
    
    
    func thirdLayer(width: CGFloat,height: CGFloat) {
        buttonsView.addSubview(btn9)
//        btn9.backgroundColor = .red
        btn9.snp.makeConstraints { (make) in
            make.top.equalTo(buttonsView)
            make.width.equalTo(width)
            make.trailing.equalTo(btnDivide.snp.leading)
            make.height.equalTo(height)
        }
        
        buttonsView.addSubview(btn6)
//        btn6.backgroundColor = .cyan
        btn6.snp.makeConstraints { (make) in
            make.top.equalTo(btn9.snp.bottom)
            make.width.equalTo(width)
            make.trailing.equalTo(btnMultiply.snp.leading)
            make.height.equalTo(height)
        }
        
        buttonsView.addSubview(btn3)
//        btn3.backgroundColor = .yellow
        btn3.snp.makeConstraints { (make) in
            make.top.equalTo(btn6.snp.bottom)
            make.width.equalTo(width)
            make.trailing.equalTo(btnMinus.snp.leading)
            make.height.equalTo(height)
        }
        
        buttonsView.addSubview(btnDel)
//        btnDel.backgroundColor = .purple
        btnDel.snp.makeConstraints { (make) in
            make.top.equalTo(btn3.snp.bottom)
            make.width.equalTo(width)
            make.trailing.equalTo(btnPlus.snp.leading)
            make.height.equalTo(height)
        }
        
        buttonsView.addSubview(btnClear)
        //        btnDel.backgroundColor = .purple
        btnClear.snp.makeConstraints { (make) in
            make.top.equalTo(btnDel.snp.bottom)
            make.width.equalTo(width)
            make.trailing.equalTo(btnDone.snp.leading)
            make.height.equalTo(height)
        }
        
    }
    
    
    func lastLayer(width: CGFloat,height: CGFloat) {
        buttonsView.addSubview(btnDivide)
//        btnDivide.backgroundColor = .red
        btnDivide.snp.makeConstraints { (make) in
            make.top.equalTo(buttonsView.snp.top)
            make.width.equalTo(width)
            make.trailing.equalTo(buttonsView)
            make.height.equalTo(height)
        }
        
        buttonsView.addSubview(btnMultiply)
//        btnMultiply.backgroundColor = .cyan
        btnMultiply.snp.makeConstraints { (make) in
            make.top.equalTo(btnDivide.snp.bottom)
            make.width.equalTo(width)
            make.trailing.equalTo(buttonsView)
            make.height.equalTo(height)
        }
        
        buttonsView.addSubview(btnMinus)
//        btnMinus.backgroundColor = .yellow
        btnMinus.snp.makeConstraints { (make) in
            make.top.equalTo(btnMultiply.snp.bottom)
            make.width.equalTo(width)
            make.trailing.equalTo(buttonsView)
            make.height.equalTo(height)
        }
        
        buttonsView.addSubview(btnPlus)
//        btnPlus.backgroundColor = .purple
        btnPlus.snp.makeConstraints { (make) in
            make.top.equalTo(btnMinus.snp.bottom)
            make.width.equalTo(width)
            make.trailing.equalTo(buttonsView)
            make.height.equalTo(height)
        }
        
        buttonsView.addSubview(btnDone)
        btnDone.backgroundColor = Config().colors.blueBgColor
        btnDone.snp.makeConstraints { (make) in
            make.top.equalTo(btnPlus.snp.bottom).offset(height / 4)
            make.width.equalTo(width)
            make.trailing.equalTo(buttonsView)
            make.height.equalTo(height / 2)
        }
        
        btnDone.layer.cornerRadius = 5
    }
    
    @objc func btnDoneAction() {
        returnTextField(set: "")
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func onClickButton(_ btn : UIButton) {
        if (textField.text?.count ?? 0) < 12 {
            if onLoad {
                textField.text = ""
                onLoad = false
            }
            textField.text = (textField.text ?? "") + String(describing: btn.tag)
        }
        
        if !changesOnAmount {
            changesOnAmount = true
        }
    }
    
    @objc func onClickOperations(_ btn : UIButton) {
        if textField.text != "" && (textField.text?.count ?? 0) < 12 {
            
            print("LAST CHAR : \(textField.text?.last)")
            if btn.tag == 13 {
                returnTextField(set: "-")
            }else if btn.tag == 14 {
                returnTextField(set: "+")
            }else if btn.tag == 11 {
                returnTextField(set: "÷")
            }else if btn.tag == 12 {
               returnTextField(set: "×")
            }
            performMath = true
        }
    }
    
    func returnTextField(set: String) {
        if (textField.text?.last) == "÷" || (textField.text?.last) == "×" || (textField.text?.last) == "+" || (textField.text?.last) == "-"{
            textField.text?.removeLast()
        }else if (textField.text?.last) == "." {
            textField.text = (textField.text ?? "") + "0"
        }else {
            
        }
        textField.text = (textField.text ?? "") + set
        
    }
    
    @objc func onClickChangesInput(_ btn : UIButton) {
        if textField.text != "" {
            if btn.tag == 17 {
                textField.text = ""
            }else if btn.tag == 15 {
                textField.text?.removeLast()
            }else {
                
            }
        }
       
    }
    
    @objc func onClickPoint(_ btn : UIButton) {
        let text = (textField.text ?? "") + "."
//        print("VALID DOUBLE : \(text.doubleValue)")
        if text.doubleValue != nil || performMath {
            textField.text = text
            performMath = false
        }
    }
}

extension String {
    struct NumFormatter {
        static let instance = NumberFormatter()
    }
    
    var doubleValue: Double? {
        return NumFormatter.instance.number(from: self)?.doubleValue
    }
    
    var integerValue: Int? {
        return NumFormatter.instance.number(from: self)?.intValue
    }
}

