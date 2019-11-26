//
//  SignUp Data.swift
//  Rate Compare App
//
//  Created by Jojo Destreza on 9/25/19.
//  Copyright © 2019 Jojo Destreza. All rights reserved.
//

import Foundation

struct UsersData : Codable {
    var id : Int
    var firstname : String
    var lastname : String
    var birthdate : String?
    var contact : String?
    var email : String
    var token : String
}


struct UsersDataList {
    var firstName : String
    var lastName : String
    var bdate : String
    var age : String
    var contact : String
    var email : String
    var password : String
}
