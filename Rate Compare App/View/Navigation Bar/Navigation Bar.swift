//
//  Navigation Bar.swift
//  Rate Compare App
//
//  Created by Jojo Destreza on 9/9/19.
//  Copyright © 2019 Jojo Destreza. All rights reserved.
//

import UIKit

struct System {
    static func clearNavigationBar(forBar navBar: UINavigationBar) {
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
    }
    
    static func showNavigationBar(forBar navBar: UINavigationBar) {
        navBar.setBackgroundImage(UIImage(named: ""), for: .default)
        navBar.shadowImage = UIImage(named: "")
        navBar.isTranslucent = true
    }
}
