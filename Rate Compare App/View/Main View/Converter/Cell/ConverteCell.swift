//
//  ConverterCell.swift
//  Rate Compare App
//
//  Created by Jojo Destreza on 9/12/19.
//  Copyright © 2019 Jojo Destreza. All rights reserved.
//

import UIKit
import FlagKit

protocol ConverterCellProtocol : class {
    func conCLickCalculator(cell: ConverterCell)
}
class ConverterCell: BaseCell<CountryListArray> {
    
    override var data: CountryListArray? {
        didSet{
            let regionCode = data?.currency.getRegionCode()
            let flag = Flag(countryCode: regionCode ?? "")!
            let originalImage = flag.originalImage
            self.countryImage.image = originalImage
            self.countryName.text = data?.currency
            self.countryCurrency.text = "\(data?.currency.countryCode() ?? "")"
            self.amount = self.data?.amount ?? 0
      
            if let rate = data?.rate {
                let totalRate = (baseRate?.rate ?? 0) / rate
                self.computation.text = "1 \(self.data?.currency ?? "") = \(String(format: "%.4f", totalRate)) \(self.baseRate?.currency ?? "")"
            }
            
           let countrySymbol = data?.currency.getCurrencySymbol() ?? ""
            self.countryRate.text = "\(countrySymbol) \(String(format: "%.4f", (data?.amount ?? 0.0)))"
           
        }
    }
    
    var amount: Double = 0
    var delegate : ConverterCellProtocol?
    
    var baseRate : CountryListArray?
    
    var index : Int = 0 {
        didSet{
            showHideView(onFirst: index == 0 ? true : false)
        }
    }
    
    lazy var mainView : UIView = {
        let v = UIView()
        v.layer.cornerRadius = 10
        v.layer.borderColor = Config().colors.blueBgColor.cgColor
        v.layer.borderWidth = 1
        return v
    }()
    
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
        return lbl
    }()
    
    lazy var countryCurrency : UILabel = {
        let lbl = UILabel()
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.2
        lbl.font = UIFont(name: Fonts.regular, size: 14)
        lbl.text = ""
        return lbl
    }()
    
    lazy var countryRate : UILabel = {
        let lbl = UILabel()
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.2
        lbl.font = UIFont(name: Fonts.bold, size: 14)
        lbl.text = ""
        lbl.textAlignment = .right
        return lbl
    }()
    
    lazy var computation : UILabel = {
        let lbl = UILabel()
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.2
        lbl.font = UIFont(name: Fonts.regular, size: 14)
        lbl.text = "0000"
        lbl.textAlignment = .right
        return lbl
    }()
    
    lazy var calculator : UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "calculator")?.withRenderingMode(.alwaysTemplate)
        img.contentMode = .scaleAspectFit
        img.layer.masksToBounds = true
        img.tintColor = Config().colors.whiteBackground
        img.isUserInteractionEnabled = true
        return img
    }()

    override func setupView() {

        self.addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.bottom.equalTo(self)
        }
        
        mainView.addSubview(countryImage)
        countryImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(mainView)
            make.leading.equalTo(mainView).offset(10)
            make.width.equalTo(self.frame.height - 20)
            make.height.equalTo(self.frame.height - 20 )
        }
        
        countryImage.layer.cornerRadius = (self.frame.height - 20) / 2
        
        mainView.addSubview(countryName)
        countryName.snp.makeConstraints { (make) in
            make.top.equalTo(mainView).offset(20)
            make.leading.equalTo(countryImage.snp.trailing).offset(10)
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
        
        mainView.addSubview(countryCurrency)
        countryCurrency.snp.makeConstraints { (make) in
            make.top.equalTo(countryName.snp.bottom)
            make.leading.equalTo(countryImage.snp.trailing).offset(10)
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
        
        mainView.addSubview(countryRate)
        countryRate.snp.makeConstraints { (make) in
            make.top.equalTo(mainView).offset(20)
            make.leading.equalTo(countryName.snp.trailing).offset(10)
            make.trailing.equalTo(mainView).offset(-10)
            make.height.equalTo(20)
        }
        
        mainView.addSubview(computation)
        computation.snp.makeConstraints { (make) in
            make.top.equalTo(countryRate.snp.bottom)
            make.leading.equalTo(countryName.snp.trailing).offset(10)
            make.trailing.equalTo(mainView).offset(-10)
            make.height.equalTo(20)
        }
        
        mainView.addSubview(calculator)
        calculator.snp.makeConstraints { (make) in
            make.top.equalTo(countryRate.snp.bottom)
            make.width.equalTo(20)
            make.trailing.equalTo(mainView).offset(-20)
            make.height.equalTo(20)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(calculatorAction))
        calculator.addGestureRecognizer(tap)
    }
    
    @objc func calculatorAction() {
        self.delegate?.conCLickCalculator(cell: self)
    }
    
    func showHideView(onFirst: Bool) {
        
        if onFirst {
            calculator.isHidden = false
            computation.isHidden = true
            mainView.backgroundColor = Config().colors.blueBgColor
            countryName.textColor = Config().colors.whiteBackground
            countryCurrency.textColor = Config().colors.whiteBackground
            countryRate.textColor = Config().colors.whiteBackground
        }else {
            calculator.isHidden = true
            computation.isHidden = false
            mainView.backgroundColor = Config().colors.whiteBackground
            countryName.textColor = Config().colors.blackBgColor
            countryCurrency.textColor = Config().colors.blackBgColor
            countryRate.textColor = Config().colors.blackBgColor
        }
        
    }
    
  
}



class CalculatorCell: BaseCell<CountryList> {
    
    var amount : Double = 0.0
    var convertToRate : Double = 0.0
    
    override var data: CountryList? {
        didSet{
            let regionCode = data?.currency.getRegionCode()
            let flag = Flag(countryCode: regionCode ?? "")!
            let originalImage = flag.originalImage
            self.countryImage.image = originalImage
            self.countryName.text = data?.currency
            self.countryCurrency.text = "\(data?.currency.countryCode() ?? "")"
            
            if let rate = data?.rate {
                let totalRate = convertToRate / rate
                let amountConvert = amount / totalRate
                self.countryRate.text = String(format: "%.4f", amountConvert)
                self.computation.text = String(format: "%.4f", totalRate)
                
            }
            
            //            let identifiers : NSArray = NSLocale.availableLocaleIdentifiers as NSArray
            //            let locale = NSLocale(localeIdentifier: "en_US")
            //            var list = NSMutableString()
            //            for identifier in identifiers {
            //                let name = locale.displayName(forKey: NSLocale.Key.identifier, value: identifier)!
            //                list.append("\(identifier)\t\(name)\n")
            //            }
            //            print("LIST OF CURRENCY \(list) == =00=0=0\("ff".listCountriesAndCurrencies())")
        }
    }
    
    
    var index : Int = 0 {
        didSet{
            showHideView(onFirst: index == 0 ? true : false)
        }
    }
    
    lazy var mainView : UIView = {
        let v = UIView()
        v.layer.cornerRadius = 10
        v.layer.borderColor = Config().colors.blueBgColor.cgColor
        v.layer.borderWidth = 1
        return v
    }()
    
    lazy var countryImage : UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        
        img.layer.masksToBounds = true
        img.image = UIImage(named: "google_red")
        return img
    }()
    
    lazy var countryName : UILabel = {
        let lbl = UILabel()
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.2
        lbl.font = UIFont(name: Fonts.bold, size: 14)
        lbl.text = "USD"
        return lbl
    }()
    
    lazy var countryCurrency : UILabel = {
        let lbl = UILabel()
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.2
        lbl.font = UIFont(name: Fonts.regular, size: 14)
        lbl.text = "US Dollar"
        return lbl
    }()
    
    lazy var countryRate : UILabel = {
        let lbl = UILabel()
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.2
        lbl.font = UIFont(name: Fonts.bold, size: 14)
        lbl.text = "$1.0000"
        lbl.textAlignment = .right
        return lbl
    }()
    
    lazy var computation : UILabel = {
        let lbl = UILabel()
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.2
        lbl.font = UIFont(name: Fonts.regular, size: 14)
        lbl.text = "1 USD = 00000 XXX"
        lbl.textAlignment = .right
        return lbl
    }()
    
    lazy var calculator : UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "calculator")?.withRenderingMode(.alwaysTemplate)
        img.contentMode = .scaleAspectFit
        img.layer.masksToBounds = true
        img.tintColor = Config().colors.whiteBackground
        return img
    }()
    
    
    override func setupView() {
        
        self.addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.bottom.equalTo(self)
        }
        
        mainView.addSubview(countryImage)
        countryImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(mainView)
            make.leading.equalTo(mainView).offset(10)
            make.width.equalTo(self.frame.height - 20)
            make.height.equalTo(self.frame.height - 20 )
        }
        
        countryImage.layer.cornerRadius = (self.frame.height - 20) / 2
        
        mainView.addSubview(countryName)
        countryName.snp.makeConstraints { (make) in
            make.top.equalTo(mainView).offset(10)
            make.leading.equalTo(countryImage.snp.trailing).offset(10)
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
        
        mainView.addSubview(countryCurrency)
        countryCurrency.snp.makeConstraints { (make) in
            make.top.equalTo(countryName.snp.bottom)
            make.leading.equalTo(countryImage.snp.trailing).offset(10)
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
        
        mainView.addSubview(countryRate)
        countryRate.snp.makeConstraints { (make) in
            make.top.equalTo(mainView).offset(10)
            make.leading.equalTo(countryName.snp.trailing).offset(10)
            make.trailing.equalTo(mainView).offset(-10)
            make.height.equalTo(20)
        }
        
        mainView.addSubview(computation)
        computation.snp.makeConstraints { (make) in
            make.top.equalTo(countryRate.snp.bottom)
            make.leading.equalTo(countryName.snp.trailing).offset(10)
            make.trailing.equalTo(mainView).offset(-10)
            make.height.equalTo(20)
        }
        
        mainView.addSubview(calculator)
        calculator.snp.makeConstraints { (make) in
            make.top.equalTo(countryRate.snp.bottom)
            make.width.equalTo(20)
            make.trailing.equalTo(mainView).offset(-20)
            make.height.equalTo(20)
        }
        
    }
    
    func showHideView(onFirst: Bool) {
        
        if onFirst {
            calculator.isHidden = false
            computation.isHidden = true
            mainView.backgroundColor = Config().colors.blueBgColor
            countryName.textColor = Config().colors.whiteBackground
            countryCurrency.textColor = Config().colors.whiteBackground
            countryRate.textColor = Config().colors.whiteBackground
        }else {
            calculator.isHidden = true
            computation.isHidden = false
            mainView.backgroundColor = Config().colors.whiteBackground
            countryName.textColor = Config().colors.blackBgColor
            countryCurrency.textColor = Config().colors.blackBgColor
            countryRate.textColor = Config().colors.blackBgColor
        }
        
    }
    
}
