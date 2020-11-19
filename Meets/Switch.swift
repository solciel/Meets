//
//  File.swift
//  Meets
//
//  Created by Rafael Alfonzo Marcelino on 11/11/20.
//  Copyright © 2020 Rafael Alfonzo. All rights reserved.
//

import Foundation
import UIKit

class Switch {
    
    static func updateRoot() {
        
        let loggedIn = UserDefaults.standard.bool(forKey: "loggedIn")
        var rootViewContr : UIViewController?
        
        if(loggedIn == true) {
            rootViewContr = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "homecontrol") as! UITabBarController
        }
        else {
            rootViewContr = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "logincontrol") as! LoginViewController
        }
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
        let sceneDelegate = windowScene.delegate as? SceneDelegate else {
            return
        }
        sceneDelegate.window?.rootViewController = rootViewContr
        
    }
    
}
