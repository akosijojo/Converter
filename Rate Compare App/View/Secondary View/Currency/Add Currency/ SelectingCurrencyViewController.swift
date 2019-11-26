//
//  SelectingCurrencyViewController.swift
//  Rate Compare App
//
//  Created by Jojo Destreza on 9/26/19.
//  Copyright © 2019 Jojo Destreza. All rights reserved.
//

import UIKit

class SelectingCurrencyViewController : AddCurrencyViewController {

    var tag : Int?
    var navTitle : String = ""
    
    override func getData() {
        self.viewModel?.onSuccessGettingList = { [weak self] data in
            self?.checkSameData(data: data?.convertData())
            self?.stopLoading()
        }
        
        self.viewModel?.onErrorHandling = { [weak self] error in
            print("ERROR : \(error?.message)")
            if let stat = error {
                self?.showErrorAlert(status: stat)
            }
        }
        
        let base = self.data.count > 0 ?  self.data[0].currency : "USD"
        var param: [String: Any] = ["base": base,"euro_handling" : 1]
        self.viewModel?.getDataList(param: param)
        
        
    }
    
    func checkSameData(data: DataClassArray?) {
        if let list = data?.list {
            
            let datalist = removeDataWith(data: self.data,list: list)
            
            self.dataList = DataClassArray(date: data?.date ?? 0 , list: datalist)
            self.dataListSaved = self.dataList
        }
    }
    
    func removeDataWith(data : [CountryListArray],list : [CountryListArray]) -> [CountryListArray] {
        var dataChecked :  [CountryListArray] = []
        for x in list {
            let index = data.index(where: { (result) -> Bool in
                return result.currency == x.currency
            })
            
            if index == nil {
                dataChecked.append(x)
            }
            
        }
        
        return dataChecked
    }
    
    override func setUpNavigationBar() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "arrow_left")?.withRenderingMode(.alwaysTemplate), for: .normal)
        backButton.setTitle(navTitle, for: .normal)
        backButton.titleLabel?.font = UIFont(name: Fonts.bold, size: 20)
        backButton.sizeToFit()
        backButton.tintColor = Config().colors.whiteBackground
        backButton.titleLabel?.textColor = Config().colors.whiteBackground
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        let leftButton = UIBarButtonItem(customView: backButton)
        
        self.navigationItem.leftBarButtonItem = leftButton
        
        
        let b1 = UIBarButtonItem(image: UIImage(named: "search")?.withRenderingMode(.alwaysTemplate),style: .plain, target: self, action: #selector(searchCurrency))
        b1.tintColor = Config().colors.whiteBackground
        
        self.navigationItem.rightBarButtonItem = b1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? CurrencyListCheckBoxCell else {
            return UICollectionViewCell()
        }
        cell.checkBox.isHidden = true
        cell.data = dataList?.list[indexPath.row]
        cell.indexPath = indexPath.row
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("DID SELECT : \(indexPath.row) \(self.data.count > 2)")
       
        self.returnSelectedData(data:dataList?.list[indexPath.row])
    }
    
    func returnSelectedData(data: CountryListArray?) {
        
        if let dataRecieved = data {
            if let vc = vc as? CompareViewController {
                if let tags = tag {
                    if tags == 1 {
                        print("BASE CHANGES : \(dataRecieved.currency)")
                        vc.saveCompared.base = dataRecieved.currency
                    }else {
                        print("SYMBOLS CHANGES : \(dataRecieved.currency)")
                        vc.saveCompared.symbols = dataRecieved.currency
//                        vc.data?.list = [dataRecieved]
                    }
                    vc.requestData()
                }
                
            }
            
            
            if let vc = vc as? CreateAlertViewController {
                if let tags = tag {
                    if tags == 1 {
                        print("BASE CHANGES : \(dataRecieved.currency)")
                        vc.saveCompared.base = dataRecieved.currency
                    }else {
                        print("SYMBOLS CHANGES : \(dataRecieved.currency)")
                        vc.saveCompared.symbols = dataRecieved.currency
                        //                        vc.data?.list = [dataRecieved]
                    }
                    vc.requestData()
                    
                }
                
            }
            
            if let vc = vc as? ChartsViewController {
                if let tags = tag {
                    if tags == 1 {
                        print("BASE CHANGES : \(dataRecieved.currency)")
                        vc.saveCompared.base = dataRecieved.currency
                    }else {
                        print("SYMBOLS CHANGES : \(dataRecieved.currency)")
                        vc.saveCompared.symbols = dataRecieved.currency
                        //                        vc.data?.list = [dataRecieved]
                    }
                    vc.requestData()
                    
                }
                
            }
        }
        
        self.navigationController?.popViewController(animated: true)
       
    }
    
}
