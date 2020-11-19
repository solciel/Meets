//
//  HomeViewController.swift
//  Meets
//
//  Created by Rafael Alfonzo Marcelino on 11/11/20.
//  Copyright © 2020 Rafael Alfonzo. All rights reserved.
//

import UIKit
import GoogleSignIn

class HomeViewController: UIViewController {
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    @IBOutlet weak var signOutButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        GIDSignIn.sharedInstance()?.presentingViewController = self

        // Automatically sign in the user.
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
        NotificationCenter.default.addObserver(self,
                selector: #selector(self.receiveToggleAuthUINotification(_:)),
                name: NSNotification.Name(rawValue: "ToggleAuthUINotification"),
                object: nil)
        
        toggleAuthUI()
        
        
    }
    

    @IBAction func logout(_ sender: Any) {
        
        //UserDefaults.standard.set(false, forKey: "loggedIn")
        let defaultsData = UserDefaults.standard
        let dictionary = defaultsData.dictionaryRepresentation()
        dictionary.keys.forEach {key in defaultsData.removeObject(forKey: key)}
        Switch.updateRoot()
    }
    
    
    func toggleAuthUI() {
        if let _ = GIDSignIn.sharedInstance()?.currentUser?.authentication {
          // Signed in
          signInButton.isHidden = true
          signOutButton.isHidden = false
        } else {
          signInButton.isHidden = false
          signOutButton.isHidden = true
        }
        
        self.view.setNeedsDisplay()
      }
    
    @IBAction func didTapSignOut(_ sender: AnyObject) {
        GIDSignIn.sharedInstance().signOut()
        // [START_EXCLUDE silent]
        toggleAuthUI()
        // [END_EXCLUDE]
      }
    
    @objc func receiveToggleAuthUINotification(_ notification: NSNotification) {
        if notification.name.rawValue == "ToggleAuthUINotification" {
          self.toggleAuthUI()
        
          }
        }
}
