//
//  Color Configurations.swift
//  Rate Compare App
//
//  Created by Jojo Destreza on 9/9/19.
//  Copyright © 2019 Jojo Destreza. All rights reserved.

import UIKit

protocol ColorContract {
    var whiteBackground: UIColor { get }
    var lightGraybackground: UIColor { get }
    var borderColor: UIColor { get }
    var grayBackground: UIColor { get }
    var orangeBackground: UIColor { get }
    var lightOrangeBackground: UIColor { get }
    var redBgColor: UIColor { get }
    var blueBgColor: UIColor { get }
    var lightBlueBgColor : UIColor { get }
    var darkBlueBgColor : UIColor { get }
    var textColorDark : UIColor { get }
    var textColorLight : UIColor { get }
    var blackBgColor: UIColor { get }
    var navButtonColors: UIColor { get }
    var greenBgColor: UIColor { get }
    
   
//    Font Family
//    Brandon Text Regular, 400
//    Brandon Text Medium, 500
//    Brandon Text Bold, 600
//
//    Default button bgcolor:   #2176EB
//    Gmail button bgcolor:   #EB2B32
}

struct Config {
    let colors: ColorContract = ColorSet() as ColorContract
    let screenWidth : CGFloat  = UIScreen.main.bounds.width
    let screenHeight : CGFloat  = UIScreen.main.bounds.height
    var bottomScreenInset : CGFloat {
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let bottomPadding = window?.safeAreaInsets.bottom ?? 0
            return bottomPadding
        }
        return 0
    }
    
}

struct ColorSet: ColorContract {
    
    public var whiteBackground: UIColor {
        return UIColor.white
    }
    
    public var lightGraybackground: UIColor {
        return UIColor(hex: "f7f7f7")
    }
    
    public var borderColor: UIColor {
        return UIColor(hex: "EDF1F5")
    }
    
    public var grayBackground: UIColor {
        return UIColor(hex: "48494b")
    }
    
    public var lightOrangeBackground: UIColor {
        return UIColor(hex: "c56200")
    }
    
    public var orangeBackground: UIColor {
        return UIColor(hex: "fc6600")
    }
    
    public var redBgColor: UIColor {
        return UIColor(hex: "EB2B32")
    }
    
    public var blueBgColor: UIColor {
        return UIColor(hex: "2176EB")
    }
    
    public var lightBlueBgColor: UIColor {
        return UIColor(hex: "80ccff")
    }
    
    public var darkBlueBgColor: UIColor {
        return UIColor(hex: "1153ad")
    }
    
    public var textColorDark: UIColor {
        return UIColor(hex: "464E58")
    }
    
    public var textColorLight: UIColor {
        return UIColor(hex: "A9B7D1")
    }
    
    public var blackBgColor: UIColor {
        return UIColor(hex: "00000")
    }
    
    public var navButtonColors: UIColor {
        return UIColor(hex: "fc6600")
    }
    
    public var greenBgColor: UIColor {
        return UIColor(hex: "009933")
    }
    
}

extension UIColor {
    convenience init(hex: String) {
        let scanner                 = Scanner(string: hex)
        scanner.scanLocation        = 0
        
        var rgbValue: UInt64        = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r                       = (rgbValue & 0xff0000) >> 16
        let g                       = (rgbValue & 0xff00) >> 8
        let b                       = rgbValue & 0xff
        
        self.init(
            red                     : CGFloat(r) / 0xff,
            green                   : CGFloat(g) / 0xff,
            blue                    : CGFloat(b) / 0xff, alpha: 1
        )
    }
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}



//public var eventBackground: UIColor {
//    return UIColor(hex: "4993ED")
//}
//
//public var darkTextColor: UIColor {
//    return UIColor(hex: "464E58")
//}
//
//public var lightTextColor: UIColor {
//    return UIColor(hex: "A9B7D1")
//}
//
//public var holidayBackground: UIColor {
//    return UIColor(hex: "E0464C")
//}
//
//public var textViewTextColor: UIColor {
//    return UIColor(hex: "99A2AD")
//}
//
//public var textViewBackground: UIColor {
//    return UIColor(hex: "F7F7F7")
//}
//
//public var chatNameColor: UIColor {
//    return UIColor(hex: "464E58")
//}
//
//public var chatTitleColor: UIColor {
//    return UIColor(hex: "707984")
//}
//
//public var chatBorder: UIColor {
//    return UIColor(hex: "F0F1F4")
//}
//
//public var whitebackground: UIColor {
//    return UIColor.white
//}
//
//public var orangeColor: UIColor {
//    return UIColor(hex: "F67F5A")
//}
//public var darkorangeColor: UIColor {
//    return UIColor(hex: "F67F5A")
//}
//public var lightorangeColor: UIColor {
//    return UIColor(hex: "F3BAA9")
//}
//
//public var mainTextColor: UIColor {
//    return UIColor(hex: "353A50")
//}
//
//public var secondaryTextColor: UIColor {
//    return UIColor(hex: "999FB4")
//}
//
//public var commentBackground: UIColor {
//    return UIColor(hex: "fafafa")
//}
//
//public var commentTint: UIColor {
//    return UIColor(hex: "9FABBF")
//}
//
//public var yellowBackground: UIColor {
//    return UIColor(hex: "ffce02")
//}
//
//public var redBackground: UIColor {
//    return UIColor(hex: "db2828")
//}
//
//public var greenBackground: UIColor {
//    return UIColor(hex: "21ba45")
//}
//
//public var textRedColor: UIColor {
//    return UIColor(hex: "E74C3C")
//}
//
//public var textGreenColor: UIColor {
//    return UIColor(hex: "2ECC71")
//}
//
//public var redColor: UIColor {
//    return UIColor(hex: "D92D2D")
//}
//
//public var pureBlueColor: UIColor {
//    return UIColor(hex: "008FF7")
//}
//
//public var blueColor: UIColor {
//    return UIColor(hex: "4D97E6")
//}
//
//public var fieldColor: UIColor {
//    return UIColor(hex: "BEC7D7")
//}
//
//public var textColor1: UIColor {
//    return UIColor(hex: "686F8B")
//}
//
//public var textColor2: UIColor {
//    return UIColor(hex: "9FABBF")
//}
//
//public var borderColor: UIColor {
//    return UIColor(hex: "DFE4F5")
//}
//
//public var colorBackground: UIColor {
//    return UIColor(hex: "EDF1F5")
//}
//
//public var feedItemBG: UIColor {
//    return UIColor.rgb(red: 255, green: 255, blue: 255)
//}
//
//public var colorTint: UIColor {
//    return UIColor.rgb(red: 0, green: 0, blue: 0)
//}
//
//public var buttonColor: UIColor {
//    return UIColor.rgb(red: 255, green: 102, blue: 35)
//}
//
//public var assessmentColor: UIColor {
//    return UIColor(hex: "A6D1F8")
//}
//
//public var homeworkColor: UIColor {
//    return UIColor(hex: "C5ACFF")
//}
//
//public var seatworkColor: UIColor {
//    return UIColor(hex: "FDC3A1")
//}
