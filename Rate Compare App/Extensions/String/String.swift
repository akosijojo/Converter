//
//  String.swift
//  Rate Compare App
//
//  Created by Jojo Destreza on 9/12/19.
//  Copyright © 2019 Jojo Destreza. All rights reserved.
//

import UIKit

extension String {
    
    var expression: NSExpression {
        return NSExpression(format: self)
    }
    
    var isValidEmail: Bool {
        return NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: self)
    }
    
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    func countryName() -> String {
        if let name = (Locale.current as NSLocale).displayName(forKey: .countryCode, value: self) {
            // Country name was found
            return name
        } else {
            // Country name cannot be found
            return self
        }
        
    }
    
    func countryCode()-> String {
        if let name = Locale.current.localizedString(forCurrencyCode: self){
            // Country name was found
            return name
        } else {
            // Country name cannot be found
            return self
        }
    }
 
    func getRegionCode() -> String{
        var text: String = self
        let endIndex = text.index(text.endIndex, offsetBy: -1)
        let truncated = text.substring(to: endIndex)
        return truncated
    }
    
    func getCurrencySymbol() -> String? {
        let locale = NSLocale(localeIdentifier: self)
        if locale.displayName(forKey: .currencySymbol, value: self) == self {
            let newlocale = NSLocale(localeIdentifier: self.dropLast() + "_en")
            return newlocale.displayName(forKey: .currencySymbol, value: self)
        }
        return locale.displayName(forKey: .currencySymbol, value: self)
    }
    
    
    func listCountriesAndCurrencies() {
        let localeIds = Locale.availableIdentifiers
        var countryCurrency = [String: String]()
        for localeId in localeIds {
            let locale = Locale(identifier: localeId)
            
            if let country = locale.regionCode, country.characters.count == 2 {
                if let currency = locale.currencySymbol {
                    countryCurrency[country] = currency
                }
            }
        }
        
        let sorted = countryCurrency.keys.sorted()
        for country in sorted {
            let currency = countryCurrency[country]!
//            if self ==
            print("country: \(country), currency: \(currency)")
        }
    }
    
    func stringConvertWithoutEncoded() -> String {
        var msg: String = self.replacingOccurrences(of: "PHP_EOL", with: "\n")
        msg = msg.replacingOccurrences(of: "\r\n", with: "\n")
        msg = msg.replacingOccurrences(of: "&ntilde;", with: "ñ")
        msg = msg.replacingOccurrences(of: "&Ntilde;", with: "Ñ")
        msg = msg.replacingOccurrences(of: "&amp;ntilde;", with: "ñ")
        msg = msg.replacingOccurrences(of: "&amp;Ntilde;", with: "Ñ")
        msg = msg.replacingOccurrences(of: "&amp;", with: "&")
        msg = msg.replacingOccurrences(of: "&amp;&amp;", with: "&")
        msg = msg.replacingOccurrences(of: "\\'", with: "'")
//        msg = msg.htmlUnescape()
        
        return msg
    }
    
    
    func convertComputation() -> String {
        var msg: String = self.replacingOccurrences(of: "×", with: " * ")
        msg = msg.replacingOccurrences(of: "÷", with: " / ")
        msg = msg.replacingOccurrences(of: "+", with: " + ")
        msg = msg.replacingOccurrences(of: "-", with: " - ")
        return msg
    }
    
}


