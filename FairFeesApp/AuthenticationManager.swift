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

    class func signUp(withEmail email:String, password:String, firstName:String, lastName: String, phoneNumber: Int, profileImageRef: String, completionHandler: @escaping (_ success: Bool) -> Void )  {
        
        //Firebase's sign up authentication
        Auth.auth().createUser(withEmail: email,
                               password: password)
        { (newUser, registerError) in
            if registerError == nil {
                let flag = true
                completionHandler(flag)
                Auth.auth().currentUser?.sendEmailVerification(completion: { (verifyError) in
                    if (verifyError != nil) {
                        topController(UIApplication.shared.keyWindow?.rootViewController).present(AlertDefault.showAlert(title: "Verification Email not sent", message: "Error: \(String(describing: verifyError))"), animated: true, completion: nil)
                        print("Error sending verification email: \(String(describing: verifyError))")
                    }
                    else {
                        topController(UIApplication.shared.keyWindow?.rootViewController).present(AlertDefault.showAlert(title: "Verification Email sent", message: "Click the link in the email before you log in next time"), animated: true, completion: nil)
                    }
                })
                
                //set first name as Username
                let setUsername = newUser?.createProfileChangeRequest()
                setUsername?.displayName = firstName
                
                setUsername?.commitChanges(completion:
                    { (profileError) in
                        if profileError == nil {
                            
                            //create the user locally
                            let addedUser = User(uid: newUser!.uid, displayName: firstName, email: (newUser!.email)!, phoneNumber: phoneNumber, rating: 0, listings: [], typeOfUser: ["buyer": true, "seller": true, "landlord": true, "tenant": true], reviews: [], profileImageRef: profileImageRef)
                            
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

                let flag = true
                completionHandler(flag)
            }
            else {
                print("login failed: \(loginError.debugDescription)")
                
                
                //present an alert with the error description in the LoginViewController
                if var topController: LoginViewController = topController(UIApplication.shared.keyWindow?.rootViewController) as? LoginViewController {
                    while let presentedViewController = topController.presentedViewController {
                        topController = presentedViewController as! LoginViewController
                    }
                    
                    if ((loginError?.localizedDescription)! ==  "The password is invalid or the user does not have a password.") {
                        
                        let wrongPasswordAlert = AlertDefault.showAlert(title: "Login failed", message: "Wrong password")
                        topController.present(wrongPasswordAlert, animated: true, completion: nil)
        
                    }
                        
                    else if ((loginError?.localizedDescription)! == "The email address is badly formatted."){
                        
                        let invalidEmailAlert = AlertDefault.showAlert(title: "Invalid email", message: "Enter a valid email")
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
    

    //find out which VC is using the Auth Manager
    class func topController(_ parent:UIViewController? = nil) -> UIViewController {
        if let vc = parent {
            if let tab = vc as? UITabBarController, let selected = tab.selectedViewController {
                return topController(selected)
            } else if let nav = vc as? UINavigationController, let top = nav.topViewController {
                return topController(top)
            } else if let presented = vc.presentedViewController {
                return topController(presented)
            } else {
                return vc
            }
        } else {
            return topController(UIApplication.shared.keyWindow!.rootViewController!)
        }
    }
}
