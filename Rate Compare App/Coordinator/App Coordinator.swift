//
//  App Coordinator.swift
//  Rate Compare App
//
//  Created by Jojo Destreza on 9/9/19.
//  Copyright © 2019 Jojo Destreza. All rights reserved.
//

import UIKit

class AppCoordinator {
    
    var window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        if let user = UserDefaults.standard.value(forKey: localArray.userAccount) {
            print("SAVE USERS DATA : \(user)")
            let navigationController = UINavigationController(
                rootViewController: CustomTabBarController()
            )
            navigationController.navigationBar.barTintColor = Config().colors.blueBgColor
            navigationController.navigationBar.tintColor  = Config().colors.blackBgColor
            navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : Config().colors.whiteBackground]
        
            self.window.rootViewController = navigationController
        awdahwdiahwdiuhawiudha iuwhduihaw iud
        
        }else {
            showLogin()
        }
     
    }
    
    func showLogin() {
        let controller = LoginViewController()
        controller.viewModel = LoginViewModel()
        controller.viewModel?.model = LoginModel()
        let navigationController = UINavigationController(
            rootViewController:controller
        )
        navigationController.navigationBar.barTintColor = Config().colors.whiteBackground
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        self.window.rootViewController = navigationController
    }
    
}
