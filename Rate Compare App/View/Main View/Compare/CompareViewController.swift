//
//  CompareViewController.swift
//  Rate Compare App
//
//  Created by Jojo Destreza on 9/9/19.
//  Copyright © 2019 Jojo Destreza. All rights reserved.
//

import UIKit
import FlagKit

struct CompareData : Codable {
    var base : String
    var symbols : String
}

class CompareViewController: BaseMainViewController {
    var viewModel : ConverterViewModel?
    var saveCompared : CompareData = CompareData(base: "USD", symbols: "CAD") {
        didSet{
            print("DATA LOCAL COMPARED")
            let regionCode2 = self.saveCompared.base.getRegionCode()
            let flag2 = Flag(countryCode: regionCode2 ?? "")!
            let originalImage2 = flag2.originalImage
            self.btn1.imageView.image = originalImage2
            self.btn1.label.text =  self.saveCompared.base
            
            let regionCode = self.saveCompared.symbols.getRegionCode()
            let flag = Flag(countryCode: regionCode ?? "")!
            let originalImage = flag.originalImage
            self.btn2.imageView.image = originalImage
            self.btn2.label.text =  self.saveCompared.symbols
//            self.calculateCost()
        
            self.txt1.labelView.text = "\(self.saveCompared.base.getCurrencySymbol() ?? "") \(String(format: "%.4f", self.paidInput))"
            self.txt2.labelView.text = "\(self.saveCompared.symbols.getCurrencySymbol() ?? "") \(String(format: "%.4f",self.receiveInput))"
            
            self.costLabel.labelView.text = "\(self.saveCompared.base.getCurrencySymbol() ?? "") 0.00% or 0.0000 \(self.saveCompared.symbols)"
            UserDefaults.standard.setStruct(saveCompared, forKey: localArray.comparedData)
        }
    }
    
    var data : DataClassArray? {
        didSet {
            DispatchQueue.main.async {
                print("CHANGES DATA : \(self.data?.list[0].rate)")
                self.marketRate.labelView.text = "1 \(self.saveCompared.base) = \(String(format: "%.4f", self.data?.list[0].rate ?? 0.0)) \(self.saveCompared.symbols)"
                let dateString = self.data?.date.timeIntervalToFormatedDate(format: "dd MMM, yyyy hh:mm a ")
                self.marketRate.labelBottom.text = "As of \(dateString ?? "")"
                self.calculateCost()
                
            }
        }
    }
    
    lazy var scrollView : UIScrollView = {
        let scroll = UIScrollView()
        return scroll
    }()
    
    lazy var btnView : UIView = {
        let scroll = UIView()
        return scroll
    }()
    
    var paidInput : Double = 0 {
        didSet{
            self.txt1.labelView.text = (self.saveCompared.base.getCurrencySymbol() ?? "") + String(format: "%.4f", self.paidInput)
            self.calculateCost()
        }
    }
    
    var receiveInput : Double = 0 {
        didSet{
            self.txt2.labelView.text = (self.saveCompared.symbols.getCurrencySymbol() ?? "") + String(format: "%.4f", self.receiveInput)
            self.calculateCost()
        }
    }
    
    lazy var btn1 : CustomImageViewButton = {
        let btn = CustomImageViewButton()
        btn.label.text = "USD"
        btn.backgroundColor = Config().colors.whiteBackground
        btn.layer.cornerRadius = 20
        btn.layer.borderColor = Config().colors.blueBgColor.cgColor
        btn.layer.borderWidth = 1
        btn.tag = 1
        btn.isUserInteractionEnabled = true
        return btn
    }()
    
    lazy var arrow : UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "arrow_right")?.withRenderingMode(.alwaysTemplate)
        v.tintColor = Config().colors.blueBgColor
        return v
    }()
    
    lazy var btn2 : CustomImageViewButton = {
        let btn = CustomImageViewButton()
        btn.label.text = "CAD"
        btn.backgroundColor = Config().colors.whiteBackground
        btn.layer.cornerRadius = 20
        btn.layer.borderColor = Config().colors.blueBgColor.cgColor
        btn.layer.borderWidth = 1
        btn.tag = 2
        btn.isUserInteractionEnabled = true
        return btn
    }()
 
    lazy var txt1 : CustomTextFieldWithLabelTop = {
        let txt = CustomTextFieldWithLabelTop()
        txt.label.text = "You Paid"
        txt.labelView.tag = 1
        txt.labelView.text = "0.0000"
        txt.labelView.textColor = Config().colors.grayBackground
        txt.labelView.isUserInteractionEnabled = true
        txt.line.backgroundColor = Config().colors.borderColor
        return txt
    }()
    
    
    lazy var txt2 : CustomTextFieldWithLabelTop = {
        let txt = CustomTextFieldWithLabelTop()
        txt.label.text = "You Received"
        txt.labelView.tag = 2
        txt.labelView.text = "0.0000"
        txt.labelView.textColor = Config().colors.grayBackground
        txt.labelView.isUserInteractionEnabled = true
        txt.line.backgroundColor = Config().colors.borderColor
        return txt
    }()
    
    lazy var mainView : UIView = {
        let scroll = UIView()
        return scroll
    }()
    
    lazy var costLabel : CustomTextFieldWithLabelTop = {
        let txt = CustomTextFieldWithLabelTop()
        txt.label.text = "Your Cost"
        txt.labelView.text = "0.00% or 0.0000"
        return txt
    }()
    
    lazy var marketRate : CustomTextFieldWithLabelTop = {
        let txt = CustomTextFieldWithLabelTop()
        txt.label.text = "Mid-market rate"
        txt.labelView.text = "Loading..."
        return txt
    }()
    
    
    lazy var transactionRate : CustomTextFieldWithLabelTop = {
        let txt = CustomTextFieldWithLabelTop()
        txt.label.text = "Your transaction rate"
        txt.labelView.text = "No Amount specified"
        txt.labelView.font = UIFont(name: Fonts.medium, size: 18)
        txt.labelView.textColor = Config().colors.grayBackground
        return txt
    }()
    
    let cellId = "cell id"
  
    override func setUpNavigationBar() {
        setUpTitleView(text: "Compare")
        
        self.tabBarController?.navigationItem.rightBarButtonItems = nil
//        defaultBarButton = UIBarButtonItem(image: UIImage(named: "bell")?.withRenderingMode(.alwaysTemplate),style: .plain, target: self, action: #selector(bellAction))
//        defaultBarButton.tintColor = Config().colors.whiteBackground
//        //        currencyBarButton.image: UIImage(named: "currency")?.withRenderingMode(.alwaysTemplate),style: .plain, target: self, action: #selector(currencyAction)
//        self.tabBarController?.navigationItem.rightBarButtonItems = [defaultBarButton]
    }
    
    override func setUpOnViewDidLoad() {
        if let data = self.viewModel?.getComparedDataFromLocal() {
            saveCompared = data
        }
        
        setUpListener()
    }
    
    func setUpListener() {
        self.viewModel?.onSuccessGettingList = { [weak self] data in
           self?.data = data?.convertData()
        }
        
        self.viewModel?.onErrorHandling = { [weak self] error in
            DispatchQueue.main.async {
                print("ERRORRRRRRRRRRR")
                self?.alert(btn: "OK", title: "", msg: error?.message ?? "Something went wrong")
            }
        }
        
        self.requestData()
    }
    
    func requestData() {
        let base = saveCompared.base
        let symbols = saveCompared.symbols
        let param : [String:Any] = ["base": base, "symbols" : symbols, "euro_handling" : 0]
        self.viewModel?.getDataList(param: param)
    }
    
    func alert(btn: String,title: String,msg: String) {
        if self.viewIfLoaded?.window != nil {
            let alert = self.alert(btn, title, msg) { (action) in
                
            }
            //        self.present(alert, animated: true, completion: nil)
            self.navigationController?.present(alert, animated: true, completion: nil)
            
        }

    }
    
    func calculateCost() {
//        (receive/market _rate) / paid x 100 = answer
//        100 - answer = percentage
//
        print("CALCULATING COST")
//        (paid x market_rate) x (percentage/100) = total cost
        if paidInput != 0 && receiveInput != 0 {
            if let list = self.data?.list[0]{
                let ans = (receiveInput / list.rate) / self.paidInput * 100
                let percentage = 100 - ans
                
                let cost = (paidInput * list.rate) * (percentage/100)
                
                self.costLabel.labelView.text = "\(self.saveCompared.base.getCurrencySymbol() ?? "") \(String(format: "%.2f", percentage))% or \(String(format: "%.4f", cost)) \(list.currency)"
                
//                if paidInput != 0 && receiveInput != 0 {
                    let transRate = receiveInput / paidInput
                    self.transactionRate.labelView.text = "\(self.saveCompared.base.getCurrencySymbol() ?? "") 1 = \(String(format: "%.4f", transRate)) \(list.currency)"
//                }
            }
            
        }
    
    }
    
    override func setUpView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(-40)
            }else {
                make.top.equalTo(view)
            }
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        scrollView.addSubview(btnView)
        btnView.backgroundColor = Config().colors.lightGraybackground
        btnView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(scrollView).offset(-40) // - 10
            }else {
                make.top.equalTo(scrollView).offset(10)
            }
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.height.equalTo(150)
        }
        
        btnView.addSubview(btn1)
        btn1.snp.makeConstraints { (make) in
            make.top.equalTo(btnView).offset(20)
            make.leading.equalTo(btnView).offset(40)
            make.width.equalTo(view.frame.width / 3)
            make.height.equalTo(40)
        }
        
        btnView.addSubview(arrow)
        arrow.snp.makeConstraints { (make) in
            make.width.equalTo(20)
            make.top.equalTo(btnView).offset(30)
            make.centerX.equalTo(btnView)
            make.height.equalTo(20)
        }
        
        btnView.addSubview(btn2)
        btn2.snp.makeConstraints { (make) in
            make.top.equalTo(btnView).offset(20)
            make.trailing.equalTo(btnView).offset(-40)
            make.width.equalTo(view.frame.width / 3)
            make.height.equalTo(40)
        }
        
        btnView.addSubview(txt1)
        txt1.snp.makeConstraints { (make) in
            make.top.equalTo(btn1.snp.bottom).offset(20)
            make.leading.equalTo(btnView).offset(40)
            make.width.equalTo(100)
            make.height.equalTo(60)
        }
        
        txt1.showUnderline()
        
        btnView.addSubview(txt2)
        txt2.snp.makeConstraints { (make) in
            make.top.equalTo(btn2.snp.bottom).offset(20)
            make.trailing.equalTo(btnView).offset(-40)
            make.width.equalTo(100)
            make.height.equalTo(60)
        }
        
        txt2.showUnderline()
        
        scrollView.addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.top.equalTo(btnView.snp.bottom)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.bottom.equalTo(scrollView)
        }
        
        mainView.addSubview(costLabel)
        costLabel.snp.makeConstraints { (make) in
            make.top.equalTo(mainView).offset(20)
            make.leading.equalTo(mainView).offset(20)
            make.trailing.equalTo(mainView).offset(-20)
            make.height.equalTo(60)
        }
        
        costLabel.showUnderline()
        
        mainView.addSubview(marketRate)
        marketRate.snp.makeConstraints { (make) in
            make.top.equalTo(costLabel.snp.bottom).offset(20)
            make.leading.equalTo(mainView).offset(20)
            make.trailing.equalTo(mainView).offset(-20)
            make.height.equalTo(80)
        }
        
        marketRate.showUnderlabelBottom()
        
        mainView.addSubview(transactionRate)
        transactionRate.snp.makeConstraints { (make) in
            make.top.equalTo(marketRate.snp.bottom).offset(20)
            make.leading.equalTo(mainView).offset(20)
            make.trailing.equalTo(mainView).offset(-20)
            make.height.equalTo(60)
        }
        
        
        transactionRate.showUnderline()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(showCal))
        txt1.labelView.addGestureRecognizer(tap)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(showCal))
        txt2.labelView.addGestureRecognizer(tap2)
        
        
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(selectCurrency))
        btn1.addGestureRecognizer(tap3)
        
        
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(selectCurrency))
        btn2.addGestureRecognizer(tap4)
     }
    
    @objc func showCal(_ sender: UIGestureRecognizer) {
        print("CLICKED")
        let vTag = sender.view?.tag
        let controller = CalculatorViewController(img:  vTag == 1 ? btn1.imageView.image : btn2.imageView.image, name:  vTag == 1 ? btn1.label.text ?? "" : btn2.label.text ?? "", currency: vTag == 1 ? self.saveCompared.base.countryCode() : self.data?.list[0].currency.countryCode() ?? "" ,vc: self,amount: vTag == 1 ? paidInput : receiveInput)
        tabBarController?.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func selectCurrency(_ sender : UIGestureRecognizer) {
        let tag = sender.view?.tag
        var data : [CountryListArray] = [CountryListArray(country_name : self.saveCompared.base ,currency: self.saveCompared.base , rate: 0, amount:0),CountryListArray(country_name :  self.saveCompared.symbols ,currency: self.saveCompared.symbols , rate: 0, amount:0)]

        let controller = SelectingCurrencyViewController(data: data, vc: self)
        controller.tag = tag
        controller.navTitle = tag == 1 ? " From Currency" : " To Currency"
        controller.viewModel = ConverterViewModel()
        controller.viewModel?.model = ConverterModel()
        self.tabBarController?.navigationController?.pushViewController(controller, animated: true)
       
    }

}

