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

        //Firebase's sign up authentication
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
                
                //set first name as Username
                let setUsername = newUser?.createProfileChangeRequest()
                setUsername?.displayName = firstName
                
                setUsername?.commitChanges(completion:
                    { (profileError) in
                        if profileError == nil {
                            
                            //create the user locally
                            let addedUser = User(uid: newUser!.uid, firstName: firstName, lastName: lastName, email: (newUser!.email)!, phoneNumber: phoneNumber, rating: 0, listings: [], typeOfUser: ["buyer": true, "seller": true, "landlord": true, "tenant": true])
                            
                            //make this user the current user
                            FirebaseData.sharedInstance.currentUser = addedUser
                            
                            let userEmail = addedUser.email
                            let firstCharOfUserEmail = String(userEmail[userEmail.index(userEmail.startIndex, offsetBy: 0)])
                            let secondCharOfUserEmail = String(userEmail[userEmail.index(userEmail.startIndex, offsetBy: 1)])
                            let thirdCharOfUserEmail = String(userEmail[userEmail.index(userEmail.startIndex, offsetBy: 2)])
                            
                            //add this user to the Firebase user node
                            FirebaseData.sharedInstance.usersNode.child(firstCharOfUserEmail).child(secondCharOfUserEmail).child(thirdCharOfUserEmail)
                                .child(newUser!.uid)
                                .setValue(addedUser.toDictionary())
                            
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

        //Firebase's login authentication
        Auth.auth().signIn(withEmail: email,
                           password: password)
        { (authUser, loginError) in
            if loginError == nil {
                
                let userUID = Auth.auth().currentUser?.uid
                let userEmail = (Auth.auth().currentUser?.email)!
                let firstCharOfUserEmail = String(userEmail[userEmail.index(userEmail.startIndex, offsetBy: 0)])
                let secondCharOfUserEmail = String(userEmail[userEmail.index(userEmail.startIndex, offsetBy: 1)])
                let thirdCharOfUserEmail = String(userEmail[userEmail.index(userEmail.startIndex, offsetBy: 2)])
               
                //read this user's data
                
                FirebaseData.sharedInstance.usersNode.child(firstCharOfUserEmail).child(secondCharOfUserEmail).child(thirdCharOfUserEmail).child(userUID!)
                    .observeSingleEvent(of: .value, with: { (snapshot) in
                        let data = snapshot.value as? NSDictionary
                        
                        if data == nil {
                            return
                        }
                        
                        let userData: [String:Any] = data as! [String : Any]
                        
                        ReadFirebaseData.readUser(userData: userData)
        
                    })
            
                guestUser = false

                //NOT TOO SURE WHAT THIS IS FOR
                let flag = true
                completionHandler(flag)
            }
            else {
                print("login failed: \(loginError.debugDescription)")
                
                //present an alert in the LoginViewController
                if var topController: LoginViewController = UIApplication.shared.keyWindow?.rootViewController as? LoginViewController {
                    while let presentedViewController = topController.presentedViewController {
                        topController = presentedViewController as! LoginViewController
                    }
                    
                    if ((loginError?.localizedDescription)! ==  "The password is invalid or the user does not have a password.") {
                        
                        let wrongPasswordAlert = UIAlertController(title: "Login failed", message: "Wrong password", preferredStyle: .alert)
                        let okayAction = UIAlertAction(title: "Try again", style: .default, handler: nil)
                        wrongPasswordAlert.addAction(okayAction)
                        
                        topController.present(wrongPasswordAlert, animated: true, completion: nil)
        
                    }
                        
                    else if ((loginError?.localizedDescription)! == "The email address is badly formatted."){
                        
                        let invalidEmailAlert = UIAlertController(title: "Invalid email", message: "Enter a valid email", preferredStyle: .alert)
                        let okayAction = UIAlertAction(title: "Try again", style: .default, handler: nil)
                        invalidEmailAlert.addAction(okayAction)
                        
                        topController.present(invalidEmailAlert, animated: true, completion: nil)
                        
                        
                    }
                        
                    else if ((loginError?.localizedDescription)! == "There is no user record corresponding to this identifier. The user may have been deleted."){
                        
                        let emailNotRegisteredAlert = UIAlertController(title: "No account associated with this email", message: "You need to sign up first", preferredStyle: .alert)
                        let signupAction = UIAlertAction(title: "Sign up", style: .default, handler: { (alert: UIAlertAction!) in
                            
                            topController.setToSignUp()
                            
                        })
                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                        emailNotRegisteredAlert.addAction(signupAction)
                        emailNotRegisteredAlert.addAction(cancelAction)
                        topController.present(emailNotRegisteredAlert, animated: true, completion: nil)
                        
                    }
                    else {
                        
                        let loginFailedAlert = UIAlertController(title: "Login failed", message: "Have you verified your account?", preferredStyle: .alert)
                        let okayAction = UIAlertAction(title: "Yes, try again", style: .default, handler: nil)
                        loginFailedAlert.addAction(okayAction)
                        
                        topController.present(loginFailedAlert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}
