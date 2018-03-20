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
    let signupButtonString = "Let's do this!"
    let loginButtonString = "Go!"
    let signupSwitchString = "Already have an account?"
    let loginSwitchString = "Don't have an account yet?"
    let signupSwitchButtonString = "Go to the login screen"
    let loginSwitchButtonString = "Go to the sign up screen"
    let loginPasswordLabelString = "Password"
    let signupPasswordLabelString = "Password (8-20 characters)"
    
    weak var titleLabel: UILabel!
    weak var switchLabel: UILabel!
    weak var firstNameLabel: UILabel!
    weak var lastNameLabel: UILabel!
    weak var emailLabel: UILabel!
    weak var passwordLabel: UILabel!
    weak var confirmPasswordLabel: UILabel!
    
    weak var firstNameTextfield: UITextField!
    weak var lastNameTextfield: UITextField!
    weak var emailTextfield: UITextField!
    
    weak var passwordTextfield: UITextField!
    weak var confirmPasswordTextfield: UITextField!

    weak var rememberMeSwitch: UISwitch!
    
    weak var goButton: UIButton!
    weak var toggleButton: UIButton!
    weak var guestLoginButton: UIButton!
    
    var tapGesture: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabels()
        setupSwitches()
        setupTextFields()
        setupButtons()
        
        setToLogIn()
    }
    
    func setupLabels(){
        titleLabel = UILabel()
        titleLabel.text = loginTitleString
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        firstNameLabel = UILabel()
        lastNameLabel = UILabel()
        emailLabel = UILabel()
        passwordLabel = UILabel()
        confirmPasswordLabel = UILabel()
        
        switchLabel = UILabel()
        switchLabel.text = signupSwitchString
        switchLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(switchLabel)
    }
    
    func setupTextFields(){
        firstNameTextfield = UITextField()
        firstNameTextfield.delegate = self
        firstNameTextfield.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(firstNameTextfield)
        
        lastNameTextfield = UITextField()
        lastNameTextfield.delegate = self
        lastNameTextfield.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lastNameTextfield)
        
        passwordTextfield = UITextField()
        passwordTextfield.delegate = self
        passwordTextfield.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(passwordTextfield)
        
        emailTextfield = UITextField()
        emailTextfield.delegate = self
        emailTextfield.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emailTextfield)
        
        confirmPasswordTextfield = UITextField()
        confirmPasswordTextfield.delegate = self
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
        toggleButton.addTarget(self, action: #selector(toggleScreen), for: .touchUpInside)
        toggleButton.translatesAutoresizingMaskIntoConstraints = false
        toggleButton.tintColor = UIProperties.sharedUIProperties.primaryGrayColor
        view.addSubview(toggleButton)
        
        guestLoginButton = UIButton()
        guestLoginButton.setTitle("Log in as guest", for: .normal)
        guestLoginButton.tintColor = UIProperties.sharedUIProperties.primaryRedColor
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
        switchLabel.text = signupSwitchString
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
        switchLabel.text = loginSwitchString
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
        else if textfield === passwordTextfield {
            if confirmPasswordTextfield.isHidden == true {
                validated = true
            }
            else if passwordTextfield.text == confirmPasswordTextfield.text {
                validated = true
            }
            else {
                reason = "Passwords do not match"
                mismatchingPasswordsAlert()
                
            }
        }
        return (validated, reason)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField === passwordTextfield || textField === confirmPasswordTextfield {
            if textField.text!.count + string.count > maxPasswordLength {
                return false
            }
        }
        else if textField === emailTextfield {
            //
        }
        return true
    }
    
    func loginSuccess() {
        
        performSegue(withIdentifier: "continueToHome", sender: self)
    }
    
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
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        lastNameTextfield.resignFirstResponder()
        firstNameTextfield.resignFirstResponder()
        passwordTextfield.resignFirstResponder()
        confirmPasswordTextfield.resignFirstResponder()
        emailTextfield.resignFirstResponder()
    }
    
    func mismatchingPasswordsAlert(){
        let mismatchingPasswordsAlert = UIAlertController(title: "Oops", message: "Passwords don't match", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Try again", style: .default, handler: nil)
        mismatchingPasswordsAlert.addAction(okayAction)
        present(mismatchingPasswordsAlert, animated: true, completion: nil)
    }
    
    @objc func guestLogin(sender: UIButton) {
        
        loggedInBool = true
        guestUser = true
        self.loginSuccess()
    }
    
    @objc func goPressed(sender: UIButton) {
        
        if titleLabel.text == signupTitleString {
           
            if (validateInputOf(textfield: passwordTextfield).valid) {
                print("Signing up...")
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
    
            if validateInputOf(textfield: emailTextfield).valid &&
                validateInputOf(textfield: passwordTextfield).valid {
                print("Logging in...")
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
                else {
                    
                }
            }
            else {
                print("Login failed: invalid input")
                let loginFailedAlert = UIAlertController(title: "Login failed", message: "Incorrect Email or Password", preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "Try again", style: .default, handler: nil)
                loginFailedAlert.addAction(okayAction)
                present(loginFailedAlert, animated: true, completion: nil)
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
