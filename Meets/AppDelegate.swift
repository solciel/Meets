//
//  AppDelegate.swift
//  Meets
//
//  Created by Rafael Alfonzo Marcelino on 10/29/20.
//  Copyright © 2020 Rafael Alfonzo. All rights reserved.
//

import UIKit
import CoreData
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Initialize sign-in
        let scopes = ["https://mail.google.com/"]//services to be used
        
          GIDSignIn.sharedInstance().clientID = "1079553011975-e84l8f23dv1d76covt9pa46ga4sn4qb5.apps.googleusercontent.com"
          GIDSignIn.sharedInstance().delegate = self
          GIDSignIn.sharedInstance()?.scopes = scopes
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
      if let error = error {
        if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
          print("The user has not signed in before or they have since signed out.")
        } else {
          print("\(error.localizedDescription)")
        }
        return
      }
      // Perform any operations on signed in user here.
      let userId = user.userID                  // For client-side use only!
      let idToken = user.authentication.idToken // Safe to send to the server
      let fullName = user.profile.name
      let givenName = user.profile.givenName
      let familyName = user.profile.familyName
      let email = user.profile.email
    
        if let token = idToken {
            UserDefaults.standard.set(token, forKey: "token")
        }
        if let firstname = givenName {
            UserDefaults.standard.set(firstname, forKey: "firstName")
        }
        if let lastname = familyName {
            UserDefaults.standard.set(lastname, forKey: "lastName")
        }
      
    
        
        NotificationCenter.default.post(
              name: Notification.Name(rawValue: "ToggleAuthUINotification"),
              object: nil,
              userInfo: ["statusText": "Signed in user:\n\(fullName!)"])
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
      // Perform any operations when the user disconnects from app here.
      // ...
    NotificationCenter.default.post(
          name: Notification.Name(rawValue: "ToggleAuthUINotification"),
          object: nil,
          userInfo: ["statusText": "User has disconnected."])
    }


}

