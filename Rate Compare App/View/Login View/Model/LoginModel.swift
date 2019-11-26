//
//  LoginModel.swift
//  Rate Compare App
//
//  Created by Jojo Destreza on 9/23/19.
//  Copyright © 2019 Jojo Destreza. All rights reserved.
//

import UIKit

class LoginModel {
     let jsonUrlString = "\(AppConfig().url)"
    let logIn = "/login"
    let logFb = "/facebookLogin"
    let getCode = "/getcode"
    let signUp = "/signup"
    
    func login(param: [String:Any],completionHandler: @escaping (UsersData?,StatusList?) -> ()) {
        NetworkService<RequestStatusList<UsersData>>().networkRequest(param, jsonUrlString: jsonUrlString + logIn) { (data,status) in
            if let dataReceived = data {
                if let dataList = dataReceived.data {
                    completionHandler(dataList,nil)
                    return
                }
            }
            completionHandler(nil,StatusList(status: data?.status ?? 0, title: "",message: data?.message ?? "Something went wrong",tag: nil))
    
        }
    }
    
    func loginFb(param: [String:Any],completionHandler: @escaping (UsersData?,StatusList?) -> ()) {
        NetworkService<RequestStatusList<UsersData>>().networkRequest(param, jsonUrlString: jsonUrlString + logFb) { (data,status) in
            if let dataReceived = data {
                if let dataList = dataReceived.data {
                    completionHandler(dataList,nil)
                    return
                }
            }
            completionHandler(nil,StatusList(status: data?.status ?? 0, title: "",message: data?.message ?? "Something went wrong",tag: nil))
            
        }
    }
    
    func getVerificationCode(param: [String:Any],completionHandler: @escaping (StatusList?) -> ()) {
        NetworkService<RequestStatusList<UsersData>>().networkRequest(param, jsonUrlString: jsonUrlString + getCode) { (data,status) in
            
            completionHandler(StatusList(status: data?.status ?? 0, title: "",message: data?.message ?? "Something went wrong",tag: nil))
        }
    }
    
    func signUp(param: [String:Any],completionHandler: @escaping (UsersData?,StatusList?) -> ()) {
        NetworkService<RequestStatusList<UsersData>>().networkRequest(param, jsonUrlString: jsonUrlString + signUp) { (data,status) in
            if let dataReceived = data {
                if let dataList = dataReceived.data {
                    completionHandler(dataList,nil)
                    return
                }
            }
            completionHandler(nil,StatusList(status: data?.status ?? 0, title: "",message: data?.message ?? "Something went wrong",tag: nil))
            
        }
    }
    
    func saveToLocal(data: UsersData?) {
        UserDefaults.standard.setStruct(data, forKey: localArray.userAccount)
        print("SAVING TO LOCAL : \(data?.email)")
    }
    
    
}
