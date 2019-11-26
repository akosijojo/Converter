//
//  TabBarController.swift
//  Rate Compare App
//
//  Created by Jojo Destreza on 9/9/19.
//  Copyright © 2019 Jojo Destreza. All rights reserved.
//

import UIKit

class CustomTabBarController : UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc1 = ConverterViewController()
        vc1.viewModel = ConverterViewModel()
        vc1.viewModel?.model = ConverterModel()
        let v1 = UINavigationController(rootViewController: vc1)
        let tb1:UITabBarItem = UITabBarItem(title: " ", image: UIImage(named: "dollar")?.withRenderingMode(.alwaysTemplate), selectedImage: UIImage(named: "dollar")?.withRenderingMode(.alwaysTemplate))
        v1.tabBarItem = tb1
        v1.interactivePopGestureRecognizer?.isEnabled = true
        v1.tabBarItem.title = ""
        
        let vc2 = ChartsViewController()
        vc2.viewModel = ConverterViewModel()
        vc2.viewModel?.model = ConverterModel()
        let v2 = UINavigationController(rootViewController: vc2)
        let tb2:UITabBarItem = UITabBarItem(title: " ", image: UIImage(named: "analytics")?.withRenderingMode(.alwaysTemplate), selectedImage: UIImage(named: "analytics")?.withRenderingMode(.alwaysTemplate))
        v2.tabBarItem = tb2
        v2.interactivePopGestureRecognizer?.isEnabled = true
        v2.tabBarItem.title = ""
        
        let vc3 = MessageViewController()
        let v3 = UINavigationController(rootViewController: vc3)
        let tb3:UITabBarItem = UITabBarItem(title: " ", image: UIImage(named: "send_money")?.withRenderingMode(.alwaysTemplate), selectedImage: UIImage(named: "send_money")?.withRenderingMode(.alwaysTemplate))
        v3.tabBarItem = tb3
        v3.interactivePopGestureRecognizer?.isEnabled = true
        v3.tabBarItem.title = ""
        
        let vc4 = CompareViewController()
        vc4.viewModel = ConverterViewModel()
        vc4.viewModel?.model = ConverterModel()
        let v4 = UINavigationController(rootViewController: vc4)
        let tb4:UITabBarItem = UITabBarItem(title: " ", image: UIImage(named: "dashboard")?.withRenderingMode(.alwaysTemplate), selectedImage: UIImage(named: "dashboard")?.withRenderingMode(.alwaysTemplate))
        v4.tabBarItem = tb4
        v4.interactivePopGestureRecognizer?.isEnabled = true
        v4.tabBarItem.title = ""
        
        let vc5 = MoneyTransferViewController()
//        vc5.viewModel = ConverterViewModel()
//        vc5.viewModel?.model = ConverterModel()
        let v5 = UINavigationController(rootViewController: vc5)
        let tb5:UITabBarItem = UITabBarItem(title: " ", image: UIImage(named: "send_money")?.withRenderingMode(.alwaysTemplate), selectedImage: UIImage(named: "send_money")?.withRenderingMode(.alwaysTemplate))
        v5.tabBarItem = tb5
        v5.interactivePopGestureRecognizer?.isEnabled = true
        v5.tabBarItem.title = ""
        
        
        let vc6 = SettingsViewController()
        vc6.viewModel = ConverterViewModel()
        vc6.viewModel?.model = ConverterModel()
        let v6 = UINavigationController(rootViewController: vc6)
        let tb6:UITabBarItem = UITabBarItem(title: " ", image: UIImage(named: "settings")?.withRenderingMode(.alwaysTemplate), selectedImage: UIImage(named: "settings")?.withRenderingMode(.alwaysTemplate))
        v6.tabBarItem = tb6
        v6.interactivePopGestureRecognizer?.isEnabled = true
        v6.tabBarItem.title = ""

        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        //v3
        viewControllers = [v1,v2,v4,v5,v6] // v3
        tabBar.barTintColor = .clear //Config().colors.whiteBackground
        tabBar.tintColor = Config().colors.blueBgColor
        
        
    }
    
    
}

