//
//  ConverterViewModel.swift
//  Rate Compare App
//
//  Created by Jojo Destreza on 9/16/19.
//  Copyright © 2019 Jojo Destreza. All rights reserved.
//

import UIKit


class ConverterViewModel  {
    var model : ConverterModel?
    
    var onSuccessGettingList : ((DataClass?) -> Void)?
    var onSuccessGettingAlertList : (([AlertDataList]) -> Void)?
    var onSuccessGettingRatesHistory : (([RatesData]?) -> Void)?
    var onSuccessGettingNewsList : (([MarketAnalysisData]?) -> Void)?
//    var onSuccessGettingNewsList : ((AlertDataList?) -> Void)?
    var onErrorHandling : ((StatusList?) -> Void)?
    
    func getDataList(param: [String:Any]) {
        
        guard let dataModel = model else { return }
        
        let completionHandler = { (data: DataClass?,status: StatusList?) in
            if let result = data {
                self.onSuccessGettingList?(result)
            }else {
                self.onErrorHandling?(data == nil ? status : nil)
            }
        }
        
        dataModel.getAllList(param: param, completionHandler: completionHandler)
    }
    
    func getAlertList(param: [String:Any]) {
        
        guard let dataModel = model else { return }
        
        let completionHandler = { (data: [AlertDataList]?,status: StatusList?) in
            if let result = data {
                self.onSuccessGettingAlertList?(result)
            }else {
                self.onErrorHandling?(data == nil ? status : nil)
            }
        }
        
        dataModel.geAlertList(param: param, completionHandler: completionHandler)
    }
    
    func getDataNewsList(param: [String:Any]) {
        
        guard let dataModel = model else { return }
        
        let completionHandler = { (data: [MarketAnalysisData]?,status: StatusList?) in
            if let result = data {
                self.onSuccessGettingNewsList?(result)
            }else {
                self.onErrorHandling?(data == nil ? status : nil)
            }
        }
        
        dataModel.geCurrencyNews(param: param, completionHandler: completionHandler)
    }
    
    func getRatesHistory(param: [String:Any]) {
        
        guard let dataModel = model else { return }
        
        let completionHandler = { (data: [RatesData]?,status: StatusList?) in
            if let result = data {
                self.onSuccessGettingRatesHistory?(result)
            }else {
                self.onErrorHandling?(data == nil ? status : nil)
            }
        }
        
        dataModel.geRatesHistory(param: param, completionHandler: completionHandler)
    }
    
    func saveRateAlert(param: [String:Any]) {
        
        guard let dataModel = model else { return }
        
        let completionHandler = { (data: AlertDataList?,status: StatusList?) in
            if let result = data {
                self.onSuccessGettingAlertList?([result])
                self.onErrorHandling?(status)
            }else {
                self.onErrorHandling?(data == nil ? status : nil)
            }
        }
        
        dataModel.saveRateAlert(param: param, completionHandler: completionHandler)
    }
    
    func deleteRateAlert(param: [String:Any]) {
        
        guard let dataModel = model else { return }
        
        let completionHandler = { (status: StatusList?) in
            if let stat = status {
                self.onErrorHandling?(status)
            }
        }
        dataModel.deleteRateAlert(param: param, completionHandler: completionHandler)
    }
    
    func getDataFromLocal() -> DataClass? {
        if let data = UserDefaults.standard.value(forKey: localArray.dataClassList) as? Data {
            let dataList = try? JSONDecoder().decode(DataClass.self, from: data)
            return dataList
        }
        return nil
    }
    
    func getComparedDataFromLocal() -> CompareData? {
        if let data = UserDefaults.standard.value(forKey: localArray.comparedData) as? Data {
            let dataList = try? JSONDecoder().decode(CompareData.self, from: data)
            return dataList
        }
        
        return CompareData(base : "USD",symbols : "CAD")
        
    }
    
    func getUsersDataFromLocal() -> UsersData? {
        if let data = UserDefaults.standard.value(forKey: localArray.userAccount) as? Data {
            let dataList = try? JSONDecoder().decode(UsersData.self, from: data)
            return dataList
        }
        return nil
        
    }
    
    func getChartsDataFromLocal() -> RatesDataArray? {
        if let data = UserDefaults.standard.value(forKey: localArray.chartsData) as? Data {
            let dataList = try? JSONDecoder().decode(RatesDataArray.self, from: data)
            print("get charts data")
            return dataList
        }
        print("no charts data")
        return nil
    }
    
    func removeUsersData()  {
        UserDefaults.standard.removeObject(forKey: localArray.userAccount)
        UserDefaults.standard.removeObject(forKey: localArray.comparedData)
        UserDefaults.standard.removeObject(forKey: localArray.dataClassList)
        UserDefaults.standard.removeObject(forKey: localArray.amountSet)
    }
}
