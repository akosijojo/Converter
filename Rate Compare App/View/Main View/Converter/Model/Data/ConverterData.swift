//
//  ConverterData.swift
//  Rate Compare App
//
//  Created by Jojo Destreza on 9/16/19.
//  Copyright © 2019 Jojo Destreza. All rights reserved.
//

import UIKit



// MARK: - DataClass
struct DataClass : Codable {
    var date: Int
    var list: [CountryList]
    
    func convertData() -> DataClassArray {
        return DataClassArray(date: date, list: list.map({ $0.convertData()}) )
    }
}

struct DataClassArray  {
    var date: Int
    var list: [CountryListArray]
    
    func convertData() -> DataClass {
        return DataClass(date: date, list: list.map({ $0.convertData()}) )
    }
    
    func removeDataWith(data : [CountryListArray]) -> [CountryListArray] {
        var dataChecked :  [CountryListArray] = []
        for x in list {
            let index = data.index(where: { (result) -> Bool in
                return result.currency == x.currency
            })
            
            if index == nil {
                dataChecked.append(x)
            }
            
            print("CHECK DATA : \(index) == \(x.currency)")
        }
        
        return dataChecked
    }
}

struct DataClassCodable : Codable {
    let date: Int
    let list: [CountryListCodable]
}


// MARK: - List
struct CountryList : Codable {
    var country_name : String
    var currency     : String
    var rate         : Double
    
    func convertData() -> CountryListArray {
        return CountryListArray(country_name: country_name, currency: currency, rate: rate, amount: 0.0)
    }
}

struct CountryListArray  {
    var country_name : String = ""
    var currency     : String = ""
    var rate         : Double = 0.0
    var amount       : Double = 0.0
    
    func convertData() -> CountryList {
        return CountryList(country_name: country_name, currency: currency, rate: rate)
    }
}

struct CurrencyList : Codable {
    var base : CountryList?
    var country : CountryList?
}



struct DynamicCountryList {
    
    var country_name : String
    var currency     : String
    var rate         : Double
    var amountValue  : Double = 0.0
    
    init(country_name : String,
         currency     : String,
         rate         : Double,
         amount       : Double = 0.0) {
        self.country_name = country_name
        self.currency     = currency
        self.rate         = rate
        self.amountValue  = amount
    }
}

// MARK: - List
struct CountryListCodable : Codable{
    var country_name : String
    var currency     : String
    var rate         : Double
    
    init(country_name : String , currency : String, rate : Double) {
        self.country_name  = country_name
        self.currency  = country_name
        self.rate  = rate
    }
}
