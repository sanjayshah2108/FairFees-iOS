//
//  LoginViewController.swift
//  FairFeesApp
//
//  Created by Sanjay Shah on 2018-03-20.
//  Copyright © 2018 Fair Fees. All rights reserved.
//

import UIKit
import Firebase

public var loggedInBool: Bool!
public var guestUser: Bool!

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var rememberMeKey = "rememberMe"
  
    let maxPasswordLength = 20
    let minPasswordLength = 8
    let signupTitleString = "Create Account"
    let loginTitleString = "Log In"
    let signupButtonString = "Sign in"
    let loginButtonString = "Go!"
    let signupSwitchString = "Already have an account?"
    let loginSwitchString = "Don't have an account yet?"
    let signupSwitchButtonString = "Go to the login screen"
    let loginSwitchButtonString = "Go to the sign up screen"
    let loginPasswordLabelString = "Password"
    let signupPasswordLabelString = "Password (8-20 characters)"
    
     var titleLabel: UILabel!
     var toggleLabel: UILabel!
     var firstNameLabel: UILabel!
     var lastNameLabel: UILabel!
     var emailLabel: UILabel!
     var passwordLabel: UILabel!
     var confirmPasswordLabel: UILabel!
     var rememberMeLabel: UILabel!
    
     var firstNameTextfield: UITextField!
     var lastNameTextfield: UITextField!
     var emailTextfield: UITextField!
    
     var passwordTextfield: UITextField!
     var confirmPasswordTextfield: UITextField!

     var rememberMeSwitch: UISwitch!
    
     var goButton: UIButton!
     var toggleButton: UIButton!
     var guestLoginButton: UIButton!
    
    var tapGesture: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupLabels()
        setupSwitches()
        setupTextFields()
        setupButtons()
        setupConstraints()
        setToLogIn()
    }
    
    func setupLabels(){
        titleLabel = UILabel()
        titleLabel.text = loginTitleString
        titleLabel.font = UIFont(name: "Avenir-Light", size: 30)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        firstNameLabel = UILabel()
        lastNameLabel = UILabel()
        emailLabel = UILabel()
        passwordLabel = UILabel()
        confirmPasswordLabel = UILabel()
        
        rememberMeLabel = UILabel()
        rememberMeLabel.text = "Remember Me"
        rememberMeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rememberMeLabel)
        
        toggleLabel = UILabel()
        toggleLabel.text = signupSwitchString
        toggleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toggleLabel)
    }
    
    func setupTextFields(){
        firstNameTextfield = UITextField()
        firstNameTextfield.delegate = self
        firstNameTextfield.placeholder = "First Name"
        firstNameTextfield.layer.borderColor = UIColor.lightGray.cgColor
        firstNameTextfield.layer.borderWidth = 1
        firstNameTextfield.layer.cornerRadius = 2
        firstNameTextfield.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(firstNameTextfield)
        
        lastNameTextfield = UITextField()
        lastNameTextfield.delegate = self
        lastNameTextfield.placeholder = "Last Name"
        lastNameTextfield.layer.borderColor = UIColor.lightGray.cgColor
        lastNameTextfield.layer.borderWidth = 1
        lastNameTextfield.layer.cornerRadius = 2
        lastNameTextfield.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lastNameTextfield)
        
        passwordTextfield = UITextField()
        passwordTextfield.delegate = self
        passwordTextfield.placeholder = "Password"
        passwordTextfield.layer.borderColor = UIColor.lightGray.cgColor
        passwordTextfield.layer.borderWidth = 1
        passwordTextfield.layer.cornerRadius = 2
        passwordTextfield.clearsOnBeginEditing = true
        passwordTextfield.isSecureTextEntry = true
        passwordTextfield.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(passwordTextfield)
        
        emailTextfield = UITextField()
        emailTextfield.delegate = self
        if(UserDefaults.standard.bool(forKey: rememberMeKey) == true){
            emailTextfield.text = Auth.auth().currentUser?.email
        }
        else { emailTextfield.placeholder = "Email Address"}
        emailTextfield.layer.borderColor = UIColor.lightGray.cgColor
        emailTextfield.layer.borderWidth = 1
        emailTextfield.layer.cornerRadius = 2
        emailTextfield.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emailTextfield)
        
        confirmPasswordTextfield = UITextField()
        confirmPasswordTextfield.delegate = self
        confirmPasswordTextfield.placeholder = "Re-type password"
        confirmPasswordTextfield.layer.borderColor = UIColor.lightGray.cgColor
        confirmPasswordTextfield.layer.borderWidth = 1
        confirmPasswordTextfield.layer.cornerRadius = 2
        confirmPasswordTextfield.clearsOnBeginEditing = true
        confirmPasswordTextfield.isSecureTextEntry = true
        confirmPasswordTextfield.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(confirmPasswordTextfield)
    }
    
    func setupSwitches(){
        rememberMeSwitch = UISwitch()
        if(UserDefaults.standard.bool(forKey: rememberMeKey) == true){
            rememberMeSwitch.setOn(true, animated: false)
        }
        rememberMeSwitch.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rememberMeSwitch)
    }
    
    func setupButtons(){
        
        toggleButton = UIButton()
        toggleButton.setTitle(loginButtonString, for: .normal)
        toggleButton.backgroundColor = UIProperties.sharedUIProperties.primaryRedColor
        toggleButton.layer.borderWidth = 3.0
        toggleButton.layer.cornerRadius = 7.0
        toggleButton.addTarget(self, action: #selector(toggleScreen), for: .touchUpInside)
        toggleButton.translatesAutoresizingMaskIntoConstraints = false
        toggleButton.tintColor = UIProperties.sharedUIProperties.primaryGrayColor
        view.addSubview(toggleButton)
        
        guestLoginButton = UIButton()
        guestLoginButton.setTitle("Log in as guest", for: .normal)
        guestLoginButton.tintColor = UIProperties.sharedUIProperties.primaryRedColor
        guestLoginButton.layer.borderWidth = 3.0
        guestLoginButton.layer.cornerRadius = 7.0
        guestLoginButton.backgroundColor = UIProperties.sharedUIProperties.primaryRedColor
        guestLoginButton.addTarget(self, action: #selector(guestLogin), for: .touchUpInside)
        guestLoginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(guestLoginButton)
        
        goButton = UIButton()
        goButton.setTitle(signupButtonString, for: .normal)
        goButton.addTarget(self, action: #selector(goPressed), for: .touchUpInside)
        goButton.tintColor = UIProperties.sharedUIProperties.primaryGrayColor
        goButton.layer.borderWidth = 3.0
        goButton.layer.cornerRadius = 7.0
        goButton.backgroundColor = UIProperties.sharedUIProperties.primaryRedColor
        goButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(goButton)
        
    }
    
    func setupConstraints(){
        //titleLabel
        NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 30).isActive = true
        NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50).isActive = true
        
        //firstNameTextField
        NSLayoutConstraint(item: firstNameTextfield, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: firstNameTextfield, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: firstNameTextfield, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300).isActive = true
        
        //LastNameTextField
        NSLayoutConstraint(item: lastNameTextfield, attribute: .top, relatedBy: .equal, toItem: firstNameTextfield, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: lastNameTextfield, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: lastNameTextfield, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300).isActive = true
        
        //emailTextfield
        NSLayoutConstraint(item: emailTextfield, attribute: .top, relatedBy: .equal, toItem: lastNameTextfield, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: emailTextfield, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: emailTextfield, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300).isActive = true
        
        //passwordTextField
        NSLayoutConstraint(item: passwordTextfield, attribute: .top, relatedBy: .equal, toItem: emailTextfield, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: passwordTextfield, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: passwordTextfield, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300).isActive = true
        
        //confirmPasswordTextField
        NSLayoutConstraint(item: confirmPasswordTextfield, attribute: .top, relatedBy: .equal, toItem: passwordTextfield, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: confirmPasswordTextfield, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: confirmPasswordTextfield, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300).isActive = true
        
        //rememberMeLabel
        NSLayoutConstraint(item: rememberMeLabel, attribute: .top, relatedBy: .equal, toItem: confirmPasswordTextfield, attribute: .bottom, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: rememberMeLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20).isActive = true
        
        //rememberMeSwitch
        NSLayoutConstraint(item: rememberMeSwitch, attribute: .top, relatedBy: .equal, toItem: confirmPasswordTextfield, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: rememberMeSwitch, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -30).isActive = true
        NSLayoutConstraint(item: rememberMeSwitch, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
        
        //goButton
        NSLayoutConstraint(item: goButton, attribute: .top, relatedBy: .equal, toItem: rememberMeLabel, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: goButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: goButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
         NSLayoutConstraint(item: goButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 150).isActive = true
        
        //toggleLabel
        NSLayoutConstraint(item: toggleLabel, attribute: .top, relatedBy: .equal, toItem: goButton, attribute: .bottom, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: toggleLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        //toggleButton
        NSLayoutConstraint(item: toggleButton, attribute: .top, relatedBy: .equal, toItem: toggleLabel, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: toggleButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: toggleButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: toggleButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200).isActive = true
        
        //guestLoginButton
        NSLayoutConstraint(item: guestLoginButton, attribute: .top, relatedBy: .equal, toItem: toggleButton, attribute: .bottom, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: guestLoginButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: guestLoginButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: guestLoginButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200).isActive = true
    }
    
    @objc func toggleScreen(sender: UIButton) {
        if titleLabel.text == signupTitleString {
            setToLogIn()
        }
        else if titleLabel.text == loginTitleString {
            setToSignUp()
        }
    }
    
    func setToSignUp() {
        titleLabel.text = signupTitleString
        toggleLabel.text = signupSwitchString
        passwordLabel.text =  signupPasswordLabelString
        goButton.setTitle(signupButtonString, for: .normal)
        toggleButton.setTitle(signupSwitchButtonString, for: .normal)
        firstNameLabel.isHidden = false
        firstNameTextfield.isHidden = false
        lastNameLabel.isHidden = false
        lastNameTextfield.isHidden = false
        confirmPasswordTextfield.isHidden = false
        confirmPasswordLabel.isHidden = false
    }
    
    func setToLogIn() {
        titleLabel.text = loginTitleString
        toggleLabel.text = loginSwitchString
        passwordLabel.text = loginPasswordLabelString
        goButton.setTitle(loginButtonString, for: .normal)
        toggleButton.setTitle(loginSwitchButtonString, for: .normal)
        firstNameLabel.isHidden = true
        firstNameTextfield.isHidden = true
        lastNameLabel.isHidden = true
        lastNameTextfield.isHidden = true
        confirmPasswordTextfield.isHidden = true
        confirmPasswordLabel.isHidden = true
    }
    
    func setUserDefaults() {
        if UserDefaults.standard.bool(forKey: rememberMeKey) != rememberMeSwitch.isOn {
            UserDefaults.standard.set(rememberMeSwitch.isOn, forKey: rememberMeKey)
        }
    }
    
    @objc func guestLogin(sender: UIButton) {
        
        loggedInBool = true
        guestUser = true
        self.loginSuccess()
    }
    
    @objc func goPressed(sender: UIButton) {
    
        if titleLabel.text == signupTitleString {
            
            if (validateInputOf(textfield: confirmPasswordTextfield).valid) {
                AuthenticationManager.signUp(withEmail: emailTextfield.text!, password: passwordTextfield.text!, firstName: firstNameTextfield.text!, lastName: lastNameTextfield.text!, phoneNumber: 0, completionHandler: { (success) -> Void in
                    if success == true {
                        loggedInBool = true
                        self.loginSuccess()
                        self.setUserDefaults()
                        
                    }
                    else {
                        let signUpFailedAlert = UIAlertController(title: "Signup failed", message: "There was an error", preferredStyle: .alert)
                        let okayAction = UIAlertAction(title: "Try again", style: .default, handler: nil)
                        signUpFailedAlert.addAction(okayAction)
                        self.present(signUpFailedAlert, animated: true, completion: nil)
                    }
                })
                
                if (loggedInBool == true){
                    setUserDefaults()
                }
                else {
                    //                    let signUpFailedAlert = UIAlertController(title: "Signup failed", message: "Invalid email", preferredStyle: .alert)
                    //                    let okayAction = UIAlertAction(title: "Try again", style: .default, handler: nil)
                    //                    signUpFailedAlert.addAction(okayAction)
                    //                    present(signUpFailedAlert, animated: true, completion: nil)
                }
                
            }
            else {
                let signUpFailedAlert = UIAlertController(title: "Signup failed", message: "Invalid input", preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "Try again", style: .default, handler: nil)
                signUpFailedAlert.addAction(okayAction)
                present(signUpFailedAlert, animated: true, completion: nil)
            }
        }
            
            
        else if titleLabel.text == loginTitleString {
            
            if  validateInputOf(textfield: passwordTextfield).valid {
            
                AuthenticationManager.login(withEmail: emailTextfield.text!, password: passwordTextfield.text!, completionHandler: { (success) -> Void in
                    if success == true {
                        loggedInBool = true
                        self.loginSuccess()
                        self.setUserDefaults()
                        
                    }
                    else {
                        let loginFailedAlert = UIAlertController(title: "Login failed", message: "Incorrect Email or Password", preferredStyle: .alert)
                        let okayAction = UIAlertAction(title: "Try again", style: .default, handler: nil)
                        loginFailedAlert.addAction(okayAction)
                        self.present(loginFailedAlert, animated: true, completion: nil)
                    }
                })
                
                if (loggedInBool == true){
                    setUserDefaults()
                }
            }
            else {
                
                let loginFailedAlert = UIAlertController(title: "Login failed", message: "Incorrect Email or Password", preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "Try again", style: .default, handler: nil)
                loginFailedAlert.addAction(okayAction)
                present(loginFailedAlert, animated: true, completion: nil)
            }
        }
    }
    

    func validateInputOf(textfield:UITextField) -> (valid: Bool, reason: String?) {
        var validated = false
        var reason: String?

        if textfield === confirmPasswordTextfield {
            if passwordTextfield.text == confirmPasswordTextfield.text {
                validated = true
            }
            else {
                reason = "Passwords do not match"
                mismatchingPasswordsAlert()
            }
        }
            
            
        //maybe We dont need this else if block!
        else if textfield === passwordTextfield {
            if confirmPasswordTextfield.isHidden == true {
                validated = true
            }
            else if passwordTextfield.text == confirmPasswordTextfield.text {
                validated = true
            }
            //else if confirmPasswordTextField is not hidden i.e User is signing up, and textfields dont match
            else {
                reason = "Passwords do not match"
                mismatchingPasswordsAlert()
                
            }
        }
        return (validated, reason)
    }
    
    
    func mismatchingPasswordsAlert(){
        let mismatchingPasswordsAlert = UIAlertController(title: "Oops", message: "Passwords don't match", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Try again", style: .default, handler: nil)
        mismatchingPasswordsAlert.addAction(okayAction)
        present(mismatchingPasswordsAlert, animated: true, completion: nil)
    }
    
    
    func loginSuccess() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //textField delegate methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.view.removeGestureRecognizer(tapGesture)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField === passwordTextfield || textField === confirmPasswordTextfield {
            if textField.text!.count + string.count > maxPasswordLength {
                return false
            }
        }
        return true
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        lastNameTextfield.resignFirstResponder()
        firstNameTextfield.resignFirstResponder()
        passwordTextfield.resignFirstResponder()
        confirmPasswordTextfield.resignFirstResponder()
        emailTextfield.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
