//
//  HomeViewController.swift
//  Meets
//
//  Created by Rafael Alfonzo Marcelino on 11/11/20.
//  Copyright © 2020 Rafael Alfonzo. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    @IBAction func logout(_ sender: Any) {
        
        //UserDefaults.standard.set(false, forKey: "loggedIn")
        let defaultsData = UserDefaults.standard
        let dictionary = defaultsData.dictionaryRepresentation()
        dictionary.keys.forEach {key in defaultsData.removeObject(forKey: key)}
        Switch.updateRoot()
    }
    
    
    
}
