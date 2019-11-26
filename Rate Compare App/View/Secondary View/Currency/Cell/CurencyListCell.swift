//
//  CurencyListCell.swift
//  Rate Compare App
//
//  Created by Jojo Destreza on 9/17/19.
//  Copyright © 2019 Jojo Destreza. All rights reserved.
//


import UIKit
import FlagKit

protocol CurrencyListCellProtocol : class {
    func deleteAction(cell:CurrencyListCell, indexPath : Int)
    func checkAction(cell:CurrencyListCheckBoxCell, indexPath : Int)
}

class CurrencyListCell: BaseCell<CountryListArray> {
    
    override var data: CountryListArray? {
        didSet{
            let regionCode = data?.currency.getRegionCode()
            let flag = Flag(countryCode: regionCode ?? "")!
            let originalImage = flag.originalImage
            self.countryImage.image = originalImage
            self.countryName.text = data?.currency
            self.countryCurrency.text = "\(data?.currency.countryCode() ?? "")"
        
        }
    }
    
    
    var indexPath : Int = 0
    
    var delegate : CurrencyListCellProtocol?
    
    lazy var mainView : UIView = {
        let v = UIView()
        return v
    }()
    
    lazy var deleteButton : UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "circle_minus")?.withRenderingMode(.alwaysTemplate)
        img.contentMode = .scaleAspectFit
        img.layer.masksToBounds = true
        img.tintColor = Config().colors.redBgColor
        img.isUserInteractionEnabled = true
        return img
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

    override func setupView() {
        self.addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.bottom.equalTo(self)
        }
        
        mainView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(mainView)
            make.leading.equalTo(mainView).offset(10)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        
        mainView.addSubview(countryImage)
        countryImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(mainView)
            make.leading.equalTo(deleteButton.snp.trailing).offset(10)
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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(deleteAction))
        deleteButton.addGestureRecognizer(tap)
    }
    
    @objc func deleteAction()  {
        self.delegate?.deleteAction(cell: self, indexPath: indexPath)
    }
    
}



class CurrencyListCheckBoxCell: BaseCell<CountryListArray> {
    
    override var data: CountryListArray? {
        didSet{
            let regionCode = data?.currency.getRegionCode()
            let flag = Flag(countryCode: regionCode ?? "")!
            let originalImage = flag.originalImage
            self.countryImage.image = originalImage
            self.countryName.text = data?.currency
            self.countryCurrency.text = "\(data?.currency.countryCode() ?? "")"
            
        }
    }
    
    
    var indexPath : Int = 0
    
    lazy var mainView : UIView = {
        let v = UIView()
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
    
    lazy var checkBox : UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "circle_check")?.withRenderingMode(.alwaysTemplate)
        img.contentMode = .scaleAspectFit
        img.layer.masksToBounds = true
        img.tintColor = Config().colors.greenBgColor
        img.isUserInteractionEnabled = true
        img.isHidden = true
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
        
        mainView.addSubview(checkBox)
        checkBox.snp.makeConstraints { (make) in
            make.centerY.equalTo(mainView)
            make.trailing.equalTo(mainView).offset(-10)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }

    }
    
}


