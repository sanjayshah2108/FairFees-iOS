//
//  AuthenticationManager.swift
//  FairFeesApp
//
//  Created by Sanjay Shah on 2018-03-20.
//  Copyright © 2018 Fair Fees. All rights reserved.
//

import UIKit
import Firebase

class AuthenticationManager: NSObject {

    class func signUp(withEmail email:String, password:String, firstName:String, lastName: String, phoneNumber: Int, completionHandler: @escaping (_ success: Bool) -> Void )  {
        print("Signing up with email: \(email), password: \(password)")
        print("Registering with firebase")
        Auth.auth().createUser(withEmail: email,
                               password: password)
        { (newUser, registerError) in
            if registerError == nil {
                let flag = true
                completionHandler(flag)
                Auth.auth().currentUser?.sendEmailVerification(completion: { (verifyError) in
                    if (verifyError != nil) {
                        print("Error sending verification email: \(String(describing: verifyError))")
                    }
                    else {
                        print("Email sent")
                    }
                })
                let setUsername = newUser?.createProfileChangeRequest()
                setUsername?.displayName = firstName
                
                setUsername?.commitChanges(completion:
                    { (profileError) in
                        if profileError == nil {
                            let addedUser = User(firstName: firstName, lastName: lastName, email: (newUser?.email)!, phoneNumber: phoneNumber, rating: 0, listings: [])
                            
                            
                            FirebaseData.sharedInstance.currentUser = addedUser
                            
                            FirebaseData.sharedInstance.usersNode
                                .child(newUser!.uid)
                                .setValue(addedUser.toDictionary())
                            print("Sign up successful")
                            //AuthenticationManager.addToKeychain(email: email, password: password)
                            guestUser = false
                        }
                        else {
                            print("Error setting profile name: \(String(describing: profileError))")
                        }
                })
            }
            else {
                print("Error registering with Firebase: \(String(describing: registerError))")
            }
        }
    }
    
    class func login(withEmail email:String, password:String, completionHandler: @escaping (_ success: Bool) -> Void) {
        print("Logging in with email: \(email), password: \(password)")
        
        print("Logging in to Firebase...")
        Auth.auth().signIn(withEmail: email,
                           password: password)
        { (authUser, loginError) in
            if loginError == nil {
                let userUID = Auth.auth().currentUser?.uid
                FirebaseData.sharedInstance.usersNode.child(userUID!)
                    .observeSingleEvent(of: .value, with: { (snapshot) in
                        let data = snapshot.value as? NSDictionary
                        
                        if data == nil {
                            return
                        }
                        
                        let userData: [String:Any] = data as! [String : Any]
                        
                        FirebaseData.sharedInstance.currentUser = User(with: userData)
                    })
                print("Login Successful")
                guestUser = false
                //addToKeychain(email: email, password: password)
                let flag = true
                completionHandler(flag)
            }
            else {
                print("login failed: \(loginError.debugDescription)")
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                
                let mainVC = appDelegate.window?.rootViewController as! LoginViewController
                
                let loginFailedAlert = UIAlertController(title: "Login failed", message: "Incorrect Email or Password", preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "Try again", style: .default, handler: nil)
                loginFailedAlert.addAction(okayAction)
                mainVC.present(loginFailedAlert, animated: true, completion: nil)
                
            }
        }
    }
    
}
