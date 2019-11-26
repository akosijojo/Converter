//
//  ConverterModel.swift
//  Rate Compare App
//
//  Created by Jojo Destreza on 9/16/19.
//  Copyright © 2019 Jojo Destreza. All rights reserved.
//

import UIKit

class ConverterModel {
    
    let jsonUrlString = "\(AppConfig().url)"
    let getData = "/getEquivalentRates"
    let getCurrencyNews = "/getCurrencyNews"
    let getAlertList = "/getAlertList"
    let getRatesHistory = "/getRatesHistory"
    let createAlert = "/createAlert"
    let deleteAlert = "/deleteRateAlert"
    
    func saveToLocal(data: DataClass?) {
        UserDefaults.standard.setStruct(data, forKey: localArray.dataClassList)
    }
    
    func getAllList(param: [String:Any],completionHandler: @escaping (DataClass?,StatusList?) -> ()) {
        NetworkService<RequestStatusList<DataClass>>().networkRequest(param, jsonUrlString: jsonUrlString + getData) { (data,status) in
            if let dataList = data {
                if let list = dataList.data{
//                    self.saveToLocal(data: dataList.data)
                    completionHandler(list, nil)
                }else {
                    completionHandler(nil, StatusList(status: data?.status ?? 0,title: "", message: data?.message ?? "", tag: nil))
                }
            }else {
                completionHandler(nil, StatusList(status: status?.status ?? 0,title: status?.title ?? "", message: status?.message ?? "", tag: nil))
            }
        }
    }
    
    func geAlertList(param: [String:Any],completionHandler: @escaping ([AlertDataList]?,StatusList?) -> ()) {
        NetworkService<RequestStatusList<[AlertDataList]>>().networkRequest(param, jsonUrlString: jsonUrlString + getAlertList) { (data,status) in
            
            if let dataList = data?.data {
//                if let list = dataList{
                    //                    self.saveToLocal(data: dataList.data)
                    completionHandler(dataList, nil)
//                }else {
//                    completionHandler(nil, StatusList(status: data?.status ?? 0,title: "", message: data?.message ?? "", tag: nil))
//                }
            }else {
                completionHandler(nil, StatusList(status: status?.status ?? 0,title: status?.title ?? "", message: status?.message ?? "", tag: nil))
            }
        }
    }
    
    func geCurrencyNews(param: [String:Any],completionHandler: @escaping ([MarketAnalysisData]?,StatusList?) -> ()) {
        NetworkService<RequestStatusList<[MarketAnalysisData]>>().networkRequest(param, jsonUrlString: jsonUrlString + getCurrencyNews) { (data,status) in
            if let dataList = data {
                if let list = dataList.data{
                    //                    self.saveToLocal(data: dataList.data)
                    completionHandler(list, nil)
                }else {
                    completionHandler(nil, StatusList(status: data?.status ?? 0,title: "", message: data?.message ?? "", tag: nil))
                }
            }else {
                completionHandler(nil, StatusList(status: status?.status ?? 0,title: status?.title ?? "", message: status?.message ?? "", tag: nil))
            }
        }
    }
    
    func geRatesHistory(param: [String:Any],completionHandler: @escaping ([RatesData]?,StatusList?) -> ()) {
        NetworkService<RequestStatusList<[RatesData]>>().networkRequest(param, jsonUrlString: jsonUrlString + getRatesHistory) { (data,status) in
            if let dataList = data {
                if let list = dataList.data{
//                    print("DATA GET :  \(list)")
                    //                    self.saveToLocal(data: dataList.data)
                    completionHandler(list, nil)
                }else {
                    completionHandler(nil, StatusList(status: data?.status ?? 0,title: "", message: data?.message ?? "", tag: nil))
                }
            }else {
                completionHandler(nil, StatusList(status: status?.status ?? 0,title: status?.title ?? "", message: status?.message ?? "", tag: nil))
            }
        }
    }
    
    func saveRateAlert(param: [String:Any],completionHandler: @escaping (AlertDataList?,StatusList?) -> ()) {
        NetworkService<RequestStatusList<AlertDataList>>().networkRequest(param, jsonUrlString: jsonUrlString + createAlert) { (data,status) in
            if let dataList = data {
                if let list = dataList.data{
//                    print("DATA GET :  \(list)")
//                    //                    self.saveToLocal(data: dataList.data)
                    completionHandler(list, StatusList(status: dataList.status, title: "", message: dataList.message, tag: nil))
                }else {
                    completionHandler(nil, StatusList(status: data?.status ?? 0,title: "", message: data?.message ?? "", tag: nil))
                }
            }else {
                completionHandler(nil, StatusList(status: status?.status ?? 0,title: status?.title ?? "", message: status?.message ?? "", tag: nil))
            }
        }
    }
    
    func deleteRateAlert(param: [String:Any],completionHandler: @escaping (StatusList?) -> ()) {
        NetworkService<RequestStatusList<DataClass>>().networkRequest(param, jsonUrlString: jsonUrlString + deleteAlert) { (data,status) in
            if let dataList = data {
                completionHandler(StatusList(status: data?.status ?? 0,title: "", message: data?.message ?? "", tag: nil))
            }else {
                completionHandler(StatusList(status: status?.status ?? 0,title: status?.title ?? "", message: status?.message ?? "", tag: nil))
            }
        }
    }
    
}
