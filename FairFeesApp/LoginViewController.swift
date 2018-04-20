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

class LoginViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var rememberMeKey = "rememberMe"
    
    let maxPasswordLength = 20
    let minPasswordLength = 8
    let signupTitleString = "Create Account"
    let loginTitleString = "Log In"
    let signupButtonString = "Sign Up"
    let loginButtonString = "Go!"
    let signupSwitchString = "Already have an account?"
    let loginSwitchString = "Don't have an account yet?"
    let signupSwitchButtonString = "Go to the login screen"
    let loginSwitchButtonString = "Go to the sign up screen"
    let loginPasswordLabelString = "Password"
    let signupPasswordLabelString = "Password (8-20 characters)"
    
    var titleLabel: UILabel!
    var toggleLabel: UILabel!
    
    var promptLabel: UILabel!
    var loginRegisterSegmentedControl: UISegmentedControl!
    
    var firstNameLabel: UILabel!
    var lastNameLabel: UILabel!
    var emailLabel: UILabel!
    var passwordLabel: UILabel!
    var phoneNumberLabel: UILabel!
    var confirmPasswordLabel: UILabel!
    var rememberMeLabel: UILabel!
    
    var firstNameTextfield: UITextField!
    var lastNameTextfield: UITextField!
    var emailTextfield: UITextField!
    var phoneNumberTextField: UITextField!
    var passwordTextfield: UITextField!
    var confirmPasswordTextfield: UITextField!
    
    var profileImageView: UIImageView!
    var addPhotoButton: UIButton!
    
    var rememberMeSwitch: UISwitch!
    
    var goButton: UIButton!
    var toggleButton: UIButton!
    var guestLoginButton: UIButton!
    
    var forgotPasswordButton: UIButton!
    
    var imagePicker: UIImagePickerController!
    
    var tapGesture: UITapGestureRecognizer!
    
    var emailTextFieldTopConstraintAtLogin: NSLayoutConstraint!
    var emailTextFieldTopConstraintAtRegister: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupLabels()
        setupSegmentedControl()
        setupSwitches()
        setupTextFields()
        setupButtons()
        setupImageView()
        setupConstraints()
        setToLogIn()
    }
    
    func setupLabels(){
        
        promptLabel = UILabel()
        promptLabel.text = "What would you like to do?"
        promptLabel.font = UIFont(name: "Avenir-Light", size: 20)
        promptLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(promptLabel)
        
        firstNameLabel = UILabel()
        lastNameLabel = UILabel()
        emailLabel = UILabel()
        phoneNumberLabel = UILabel()
        passwordLabel = UILabel()
        confirmPasswordLabel = UILabel()
        
        rememberMeLabel = UILabel()
        rememberMeLabel.text = "Remember Me"
        rememberMeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rememberMeLabel)
    }
    
    func setupSegmentedControl(){
        loginRegisterSegmentedControl = UISegmentedControl()
        loginRegisterSegmentedControl.insertSegment(withTitle: "Login", at: 0, animated: false)
        loginRegisterSegmentedControl.insertSegment(withTitle: "Register", at: 1, animated: false)
        loginRegisterSegmentedControl.selectedSegmentIndex = 0
        loginRegisterSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        loginRegisterSegmentedControl.addTarget(self, action: #selector(toggleScreen), for: .valueChanged)
        view.addSubview(loginRegisterSegmentedControl)
    }
    
    func setupTextFields(){
        firstNameTextfield = UITextField()
        firstNameTextfield.delegate = self
        firstNameTextfield.placeholder = "First Name"
        firstNameTextfield.textAlignment = .center
        firstNameTextfield.layer.borderColor = UIColor.lightGray.cgColor
        firstNameTextfield.layer.borderWidth = 1
        firstNameTextfield.layer.cornerRadius = 2
        firstNameTextfield.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(firstNameTextfield)
        
        lastNameTextfield = UITextField()
        lastNameTextfield.delegate = self
        lastNameTextfield.placeholder = "Last Name"
        lastNameTextfield.textAlignment = .center
        lastNameTextfield.layer.borderColor = UIColor.lightGray.cgColor
        lastNameTextfield.layer.borderWidth = 1
        lastNameTextfield.layer.cornerRadius = 2
        lastNameTextfield.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lastNameTextfield)
        
        passwordTextfield = UITextField()
        passwordTextfield.delegate = self
        passwordTextfield.placeholder = "Password"
        passwordTextfield.textAlignment = .center
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
        emailTextfield.textAlignment = .center
        emailTextfield.layer.borderColor = UIColor.lightGray.cgColor
        emailTextfield.layer.borderWidth = 1
        emailTextfield.layer.cornerRadius = 2
        emailTextfield.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emailTextfield)
        
        confirmPasswordTextfield = UITextField()
        confirmPasswordTextfield.delegate = self
        confirmPasswordTextfield.placeholder = "Re-type password"
        confirmPasswordTextfield.textAlignment = .center
        confirmPasswordTextfield.layer.borderColor = UIColor.lightGray.cgColor
        confirmPasswordTextfield.layer.borderWidth = 1
        confirmPasswordTextfield.layer.cornerRadius = 2
        confirmPasswordTextfield.clearsOnBeginEditing = true
        confirmPasswordTextfield.isSecureTextEntry = true
        confirmPasswordTextfield.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(confirmPasswordTextfield)
        
        phoneNumberTextField = UITextField()
        phoneNumberTextField.delegate = self
        phoneNumberTextField.keyboardType = .numberPad
        phoneNumberTextField.placeholder = "Phone Number"
        phoneNumberTextField.textAlignment = .center
        phoneNumberTextField.layer.borderColor = UIColor.lightGray.cgColor
        phoneNumberTextField.layer.borderWidth = 1
        phoneNumberTextField.layer.cornerRadius = 2
        phoneNumberTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(phoneNumberTextField)
        
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
        
        guestLoginButton = UIButton()
        guestLoginButton.setTitle("Log in as guest", for: .normal)
        guestLoginButton.setTitleColor(view.tintColor, for: .normal)
        guestLoginButton.titleLabel?.font = UIFont(name: "Avenir-Light", size: 14)
        guestLoginButton.layer.borderWidth = 1.0
        guestLoginButton.layer.borderColor = view.tintColor.cgColor
        guestLoginButton.layer.cornerRadius = 3.0
        guestLoginButton.backgroundColor = UIColor.white
        guestLoginButton.addTarget(self, action: #selector(guestLogin), for: .touchUpInside)
        guestLoginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(guestLoginButton)
        
        goButton = UIButton()
        goButton.setTitle(signupButtonString, for: .normal)
        goButton.setTitleColor(UIColor.white, for: .normal)
        goButton.titleLabel?.font = UIFont(name: "Avenir-Light", size: 17)
        goButton.addTarget(self, action: #selector(goPressed), for: .touchUpInside)
        goButton.layer.borderWidth = 1.0
        goButton.layer.cornerRadius = 3.0
        goButton.backgroundColor = view.tintColor
        goButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(goButton)
        
        addPhotoButton = UIButton()
        addPhotoButton.setTitle("Add Photo", for: .normal)
        addPhotoButton.setTitleColor(UIColor.white, for: .normal)
        addPhotoButton.titleLabel?.font = UIFont(name: "Avenir-Light", size: 14)
        addPhotoButton.addTarget(self, action: #selector(presentImagePickerAlert), for: .touchUpInside)
        addPhotoButton.tintColor = UIProperties.sharedUIProperties.primaryGrayColor
        addPhotoButton.layer.borderWidth = 1.0
        addPhotoButton.layer.cornerRadius = 3.0
        addPhotoButton.backgroundColor = view.tintColor
        addPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addPhotoButton)
        
        forgotPasswordButton = UIButton()
        forgotPasswordButton.setTitle("Forgot your password?", for: .normal)
        forgotPasswordButton.setTitleColor(view.tintColor, for: .normal)
        forgotPasswordButton.titleLabel?.font = UIFont(name: "Avenir-Light", size: 12)
        forgotPasswordButton.addTarget(self, action: #selector(forgotPassword), for: .touchUpInside)
        forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(forgotPasswordButton)
        
    }
    
    func setupImageView(){
    
        profileImageView = UIImageView()
        profileImageView.contentMode = .scaleToFill
        profileImageView.layer.borderColor = UIColor.black.cgColor
        profileImageView.layer.borderWidth = 2
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileImageView)
        
    }
    
    func setupConstraints(){
        
        //promptLabel
        NSLayoutConstraint(item: promptLabel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: promptLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: promptLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        
        //loginRegisterSegment
        NSLayoutConstraint(item: loginRegisterSegmentedControl, attribute: .top, relatedBy: .equal, toItem: promptLabel, attribute: .bottom, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: loginRegisterSegmentedControl, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: loginRegisterSegmentedControl, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: loginRegisterSegmentedControl, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200).isActive = true
        
        //guestLoginButton
        NSLayoutConstraint(item: guestLoginButton, attribute: .top, relatedBy: .equal, toItem: loginRegisterSegmentedControl, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: guestLoginButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: guestLoginButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: guestLoginButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200).isActive = true
        
        //profileImageView
        NSLayoutConstraint(item: profileImageView, attribute: .top, relatedBy: .equal, toItem: guestLoginButton, attribute: .bottom, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: profileImageView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: profileImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100).isActive = true
        NSLayoutConstraint(item: profileImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100).isActive = true
        
        //addPhotoButton
        NSLayoutConstraint(item: addPhotoButton, attribute: .top, relatedBy: .equal, toItem: profileImageView, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: addPhotoButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: addPhotoButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100).isActive = true
        NSLayoutConstraint(item: addPhotoButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        
        //firstNameTextField
        NSLayoutConstraint(item: firstNameTextfield, attribute: .top, relatedBy: .equal, toItem: addPhotoButton, attribute: .bottom, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: firstNameTextfield, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: firstNameTextfield, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300).isActive = true
        
        //LastNameTextField
        NSLayoutConstraint(item: lastNameTextfield, attribute: .top, relatedBy: .equal, toItem: firstNameTextfield, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: lastNameTextfield, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: lastNameTextfield, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300).isActive = true
        
        //emailTextfield
        emailTextFieldTopConstraintAtRegister = NSLayoutConstraint(item: emailTextfield, attribute: .top, relatedBy: .equal, toItem: lastNameTextfield, attribute: .bottom, multiplier: 1, constant: 10)
        emailTextFieldTopConstraintAtLogin = NSLayoutConstraint(item: emailTextfield, attribute: .top, relatedBy: .equal, toItem: guestLoginButton, attribute: .bottom, multiplier: 1, constant: 50)
        emailTextFieldTopConstraintAtRegister.isActive = false
        emailTextFieldTopConstraintAtLogin.isActive = true
        
        NSLayoutConstraint(item: emailTextfield, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: emailTextfield, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300).isActive = true
        
        //phoneNumberTextField
        NSLayoutConstraint(item: phoneNumberTextField, attribute: .top, relatedBy: .equal, toItem: emailTextfield, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: phoneNumberTextField, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: phoneNumberTextField, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300).isActive = true
        
        //passwordTextField
        NSLayoutConstraint(item: passwordTextfield, attribute: .top, relatedBy: .equal, toItem: phoneNumberTextField, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: passwordTextfield, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: passwordTextfield, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300).isActive = true
        
        //confirmPasswordTextField
        NSLayoutConstraint(item: confirmPasswordTextfield, attribute: .top, relatedBy: .equal, toItem: passwordTextfield, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: confirmPasswordTextfield, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: confirmPasswordTextfield, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300).isActive = true
        
        //forgotPasswordButton
        NSLayoutConstraint(item: forgotPasswordButton, attribute: .top, relatedBy: .equal, toItem: passwordTextfield, attribute: .bottom, multiplier: 1, constant: 7).isActive = true
        NSLayoutConstraint(item: forgotPasswordButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: forgotPasswordButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 150).isActive = true
        
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


    }
    
    @objc func toggleScreen() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            setToLogIn()
        }
        else if loginRegisterSegmentedControl.selectedSegmentIndex == 1 {
            setToSignUp()
        }
    }
    
    func setToSignUp() {
        passwordLabel.text =  signupPasswordLabelString
        goButton.setTitle(signupButtonString, for: .normal)
        firstNameLabel.isHidden = false
        firstNameTextfield.isHidden = false
        lastNameLabel.isHidden = false
        lastNameTextfield.isHidden = false
        phoneNumberLabel.isHidden = false
        phoneNumberTextField.isHidden = false
        confirmPasswordTextfield.isHidden = false
        confirmPasswordLabel.isHidden = false
        
        forgotPasswordButton.isHidden = true
        
        profileImageView.isHidden = false
        addPhotoButton.isHidden = false
        
        emailTextFieldTopConstraintAtLogin.isActive = false
        emailTextFieldTopConstraintAtRegister.isActive = true
    }
    
    func setToLogIn() {
        passwordLabel.text = loginPasswordLabelString
        goButton.setTitle(loginButtonString, for: .normal)
        firstNameLabel.isHidden = true
        firstNameTextfield.isHidden = true
        lastNameLabel.isHidden = true
        lastNameTextfield.isHidden = true
        phoneNumberLabel.isHidden = true
        phoneNumberTextField.isHidden = true
        confirmPasswordTextfield.isHidden = true
        confirmPasswordLabel.isHidden = true
        
        forgotPasswordButton.isHidden = false
        
        profileImageView.isHidden = true
        addPhotoButton.isHidden = true
        
        emailTextFieldTopConstraintAtRegister.isActive = false
        emailTextFieldTopConstraintAtLogin.isActive = true
      
    }
    
    //used for remembering a users email
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
    
        if loginRegisterSegmentedControl.selectedSegmentIndex == 1 {
            
            //put guards here
            
            let profileImagePath = ImageManager.uploadProfileImage(image: profileImageView.image!, userEmail: emailTextfield.text!, filename: "profileImage")
            
            if (validateInputOf(textfield: confirmPasswordTextfield).valid) {
                AuthenticationManager.signUp(withEmail: emailTextfield.text!, password: passwordTextfield.text!, firstName: firstNameTextfield.text!, lastName: lastNameTextfield.text!, phoneNumber: Int(phoneNumberTextField.text!)!, profileImageRef: profileImagePath, completionHandler: { (success) -> Void in
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
            
            
        else if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            
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
    

    //this method makes sure password and confirm password both match if someone is signing up
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
    
    @objc func forgotPassword(){
        
        let forgotPasswordAlert = UIAlertController(title: "Forgot your password?", message: "Enter your email address to reset your password", preferredStyle: .alert)
        
        forgotPasswordAlert.addTextField(configurationHandler: {(textField) in
            textField.text = self.emailTextfield.text
        })
        
        let okayAction = UIAlertAction(title: "Send", style: .default, handler: {(action) in
            
            Auth.auth().sendPasswordReset(withEmail: forgotPasswordAlert.textFields![0].text!) { (error) in
                
                if error != nil
                {
                    let failureAlert = AlertDefault.showAlert(title: "Sorry", message: "Error: \(error!)")
                    self.present(failureAlert, animated: true, completion: nil)
                }
                else
                {
                    let successAlert = AlertDefault.showAlert(title: "Sent", message: "We've sent you an email to reset your password")
                    self.present(successAlert, animated: true, completion: nil)
                }
            }
            
        })
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        forgotPasswordAlert.addAction(okayAction)
        forgotPasswordAlert.addAction(cancelAction)
        present(forgotPasswordAlert, animated: true, completion: nil)
        
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
        phoneNumberTextField.resignFirstResponder()
    }
    
    //imagePicker delegate methods
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let myImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        if myImage != nil {
            print("image loaded: \(myImage!)")
        }
        profileImageView.image = myImage
        dismiss(animated: true, completion: nil)
    }
    
    @objc func presentImagePickerAlert() {
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let photoSourceAlert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler:{ (action) in
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.default, handler:{ (action) in
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        photoSourceAlert.addAction(cameraAction)
        photoSourceAlert.addAction(photoLibraryAction)
        photoSourceAlert.addAction(cancelAction)
        
        self.present(photoSourceAlert, animated: true, completion: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
