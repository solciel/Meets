//
//  LoginViewController.swift
//  Meets
//
//  Created by Rafael Alfonzo Marcelino on 11/11/20.
//  Copyright © 2020 Rafael Alfonzo. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    
    
    @IBOutlet weak var password: UITextField!
    
    
    @IBOutlet weak var errorMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorMessage.isHidden = true

        // Do any additional setup after loading the view.
    }
    
    @IBAction func login(_ sender: Any) {
        
        if (username.text == nil || password.text == nil || !(username.text == "rafael.alfonzo@outlook.com" && password.text == "test")) {
            errorMessage.isHidden = false
            self.view.setNeedsDisplay()
        }
        else {
            UserDefaults.standard.set(true, forKey: "loggedIn")
            Switch.updateRoot()
        }
        
        
    }
    

}
