//
//  LoginVIewModel.swift
//  Rate Compare App
//
//  Created by Jojo Destreza on 9/23/19.
//  Copyright © 2019 Jojo Destreza. All rights reserved.
//

import UIKit

class LoginViewModel {
    var model : LoginModel?
    
    var onSuccessGettingList : ((UsersData?) -> Void)?
    var onSuccessRequest : ((StatusList?) -> Void)?
    var onErrorHandling : ((StatusList?) -> Void)?
    
    func login(param: [String:Any],fb: Bool = false) {
        
        guard let dataModel = model else { return }
        
        let completionHandler = { (data : UsersData?,status: StatusList?) in
            
            if let dataReceived = data {
                print("DATA GET LOGIN : \(dataReceived.firstname)")
                self.onSuccessGettingList?(dataReceived)
                return
            }
            
            self.onErrorHandling?(status)
        }
        
        if fb {
            dataModel.loginFb(param: param, completionHandler: completionHandler)
        }else {
            dataModel.login(param: param, completionHandler: completionHandler)
        }
    }
    
    func getVerificationCode(param: [String:Any]) {
        
        guard let dataModel = model else { return }
        
        let completionHandler = { (status: StatusList?) in
            if status?.status == 1 {
                self.onSuccessRequest?(status)
            }else {
                 self.onErrorHandling?(status)
            }
        }
        
        dataModel.getVerificationCode(param: param, completionHandler: completionHandler)
    }
    
    func signUp(param: [String:Any]) {
        
        guard let dataModel = model else { return }
        
        let completionHandler = { (data : UsersData?,status: StatusList?) in
           
            if let dataReceived = data {
                self.onSuccessGettingList?(dataReceived)
                return
            }
            self.onErrorHandling?(status)
        }
        
        dataModel.signUp(param: param, completionHandler: completionHandler)
    }
    
    func getDataFromLocal() -> UsersData? {
        if let data = UserDefaults.standard.value(forKey: localArray.userAccount) as? Data {
            let dataList = try? JSONDecoder().decode(UsersData.self, from: data)
            return dataList
        }
        return nil
    }
    
}
