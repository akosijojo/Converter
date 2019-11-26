//
//  Int Extension.swift
//  Rate Compare App
//
//  Created by Jojo Destreza on 9/16/19.
//  Copyright © 2019 Jojo Destreza. All rights reserved.
//

import UIKit

extension Int {
    func timeIntervalToFormatedDate(format: String) -> String {
        let currentDate = Date(timeIntervalSince1970: TimeInterval(self))
        let dateFormatter               = DateFormatter()
        dateFormatter.dateFormat        = format
//        print("CONVERT TIME : \(self) == \(dateFormatter.string(from: currentDate))")
        return dateFormatter.string(from: currentDate)
    }
}
