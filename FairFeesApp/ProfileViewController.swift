//
//  ProfileViewController.swift
//  FairFeesApp
//
//  Created by Sanjay Shah on 2018-03-22.
//  Copyright © 2018 Fair Fees. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var firstNameLabel: UILabel!
    var firstNameTextField: UITextField!
    var lastNameLabel: UILabel!
    var lastNameTextField: UITextField!
    var emailLabel: UILabel!
    var emailTextField: UITextField!
    var profileImageView: UIImageView!
    var phoneNumberLabel: UILabel!
    var phoneNumberTextField: UITextField!
    var listingsReviewsSegmentedControl: UISegmentedControl!
    
    var addProfileImageButton: UIButton!
    var saveButton: UIButton!
   
    var myHomeSales: [HomeSale]!
    var myHomeRentals: [HomeRental]!
    
    var childContainerView: UIView!
    var myListingsTableViewController: MyListingsTableViewController!
    var myReviewsTableViewController: MyReviewsTableViewController!
    
    var tapGesture: UITapGestureRecognizer!
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Profile"
        self.navigationItem.titleView?.tintColor = UIColor.black
        view.backgroundColor = UIColor.white
        
        
        myHomeSales = []
        myHomeRentals = []
        
        for listing in (FirebaseData.sharedInstance.currentUser?.listings)! {
            if (listing is HomeSale){
                myHomeSales.append(listing as! HomeSale)
            }
            else if (listing is HomeRental){
                myHomeRentals.append(listing as! HomeRental)
            }
        }
        
        setupProfileImageView()
        setupProfileLabels()
        setupButtons()
        setupSegmentedControl()
        setupChildViewControllers()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
         ReadFirebaseData.readCurrentUser(user: FirebaseData.sharedInstance.currentUser!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupProfileImageView(){
        profileImageView = UIImageView()
        profileImageView.backgroundColor = UIColor.gray
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.borderColor = UIColor.black.cgColor
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileImageView)
    }
    func setupProfileLabels(){
        
        firstNameLabel = UILabel()
        firstNameLabel.text = "First Name"
        firstNameLabel.font = UIFont(name: "Avenir-Light", size: 13)
        firstNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(firstNameLabel)
        
        firstNameTextField = UITextField()
        firstNameTextField.delegate = self
        firstNameTextField.text = FirebaseData.sharedInstance.currentUser?.firstName
        firstNameTextField.textAlignment = .left
        firstNameTextField.layer.borderColor = UIColor.lightGray.cgColor
        firstNameTextField.layer.borderWidth = 1
        firstNameTextField.layer.cornerRadius = 2
        firstNameTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(firstNameTextField)
        
        lastNameLabel = UILabel()
        lastNameLabel.text = "Last Name"
        lastNameLabel.font = UIFont(name: "Avenir-Light", size: 13)
        lastNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lastNameLabel)
        
        lastNameTextField = UITextField()
        lastNameTextField.delegate = self
        lastNameTextField.text = FirebaseData.sharedInstance.currentUser?.lastName
        lastNameTextField.textAlignment = .left
        lastNameTextField.layer.borderColor = UIColor.lightGray.cgColor
        lastNameTextField.layer.borderWidth = 1
        lastNameTextField.layer.cornerRadius = 2
        lastNameTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lastNameTextField)
         
        emailLabel = UILabel()
        emailLabel.text = "Contact Email"
        emailLabel.font = UIFont(name: "Avenir-Light", size: 13)
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emailLabel)
        
        emailTextField = UITextField()
        emailTextField.delegate = self
        emailTextField.text = FirebaseData.sharedInstance.currentUser?.email
        emailTextField.textAlignment = .left
        emailTextField.layer.borderColor = UIColor.lightGray.cgColor
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.cornerRadius = 2
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emailTextField)
        
        phoneNumberLabel = UILabel()
        phoneNumberLabel.text = "Phone number"
        phoneNumberLabel.font = UIFont(name: "Avenir-Light", size: 13)
        phoneNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(phoneNumberLabel)
        
        phoneNumberTextField = UITextField()
        phoneNumberTextField.delegate = self
        phoneNumberTextField.text = String((FirebaseData.sharedInstance.currentUser?.phoneNumber)!)
        phoneNumberTextField.textAlignment = .left
        phoneNumberTextField.layer.borderColor = UIColor.lightGray.cgColor
        phoneNumberTextField.layer.borderWidth = 1
        phoneNumberTextField.layer.cornerRadius = 2
        phoneNumberTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(phoneNumberTextField)
    }
    
    func setupButtons(){
        
        addProfileImageButton = UIButton()
        addProfileImageButton.backgroundColor = view.tintColor
        addProfileImageButton.addTarget(self, action: #selector(presentImagePickerAlert), for: .touchUpInside)
        addProfileImageButton.setTitle("Change", for: .normal)
        addProfileImageButton.titleLabel?.font = UIFont(name: "Avenir-Light", size: 16)
        addProfileImageButton.setTitleColor(UIColor.white, for: .normal)
        addProfileImageButton.layer.cornerRadius = 3
        addProfileImageButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addProfileImageButton)
        
        saveButton = UIButton()
        saveButton.backgroundColor = view.tintColor
        saveButton.addTarget(self, action: #selector(saveDetails), for: .touchUpInside)
        saveButton.setTitle("Save", for: .normal)
        saveButton.titleLabel?.font = UIFont(name: "Avenir-Light", size: 16)
        saveButton.setTitleColor(UIColor.white, for: .normal)
        saveButton.layer.cornerRadius = 3
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(saveButton)
    
    }
    
    func setupSegmentedControl(){
        
        listingsReviewsSegmentedControl = UISegmentedControl()
        listingsReviewsSegmentedControl.insertSegment(withTitle: "Listings", at: 0, animated: false)
        listingsReviewsSegmentedControl.insertSegment(withTitle: "Reviews", at: 1, animated: false)
        listingsReviewsSegmentedControl.selectedSegmentIndex = 0
        listingsReviewsSegmentedControl.addTarget(self, action: #selector(switchListingsReviewsTableView), for: .valueChanged)
        listingsReviewsSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(listingsReviewsSegmentedControl)
    }
    
    @objc func switchListingsReviewsTableView(){
        switch listingsReviewsSegmentedControl.selectedSegmentIndex {
        case 0:
            print("Slide in Listings")
            transition(from: myReviewsTableViewController, to: myListingsTableViewController, duration: 0.3, options: .curveEaseIn,
                       animations: nil,
                       completion: { finished in
                        //self.myReviewsTableViewController.removeFromParentViewController()
                        self.myListingsTableViewController.didMove(toParentViewController: self)
                        //self.addViewControllerAsChildViewController(childViewController: self.myListingsTableViewController)
            })
            
        case 1:
            print("Slide in Reviews")
            transition(from: myListingsTableViewController, to: myReviewsTableViewController, duration: 0.3, options: .curveEaseIn,
                       animations: nil,
                       completion: { finished in
                       // self.myListingsTableViewController.removeFromParentViewController()
                        
                        self.myReviewsTableViewController.didMove(toParentViewController: self)
                        //self.addViewControllerAsChildViewController(childViewController: self.myReviewsTableViewController)
            })
        default:
            print("Shouldnt run")
        }
    }

    
    func setupChildViewControllers(){
        
        childContainerView = UIView()
        childContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(childContainerView)
        
        myReviewsTableViewController = MyReviewsTableViewController()
        self.addViewControllerAsChildViewController(childViewController: myReviewsTableViewController)

        myListingsTableViewController = MyListingsTableViewController()
        self.addViewControllerAsChildViewController(childViewController: myListingsTableViewController)
        
        
        
    }
    
    func addViewControllerAsChildViewController(childViewController: UIViewController){
        
        addChildViewController(childViewController)
        childContainerView.addSubview(childViewController.view)
        childViewController.view.frame = childContainerView.bounds
        childViewController.didMove(toParentViewController: self)
    }

    func setupConstraints(){
        //profileImageView
        NSLayoutConstraint(item: profileImageView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 70).isActive = true
        NSLayoutConstraint(item: profileImageView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: profileImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 90).isActive = true
        NSLayoutConstraint(item: profileImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 90).isActive = true
        
        //changePhotoButton
        NSLayoutConstraint(item: addProfileImageButton, attribute: .top, relatedBy: .equal, toItem: profileImageView, attribute: .bottom, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: addProfileImageButton, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: addProfileImageButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 90).isActive = true
        NSLayoutConstraint(item: addProfileImageButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        
        //firstNameLabel
        NSLayoutConstraint(item: firstNameLabel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 70).isActive = true
        NSLayoutConstraint(item: firstNameLabel, attribute: .leading, relatedBy: .equal, toItem: profileImageView, attribute: .trailing, multiplier: 1, constant: 25).isActive = true
        
        //firstNameTextField
        NSLayoutConstraint(item: firstNameTextField, attribute: .top, relatedBy: .equal, toItem: firstNameLabel, attribute: .bottom, multiplier: 1, constant: 3).isActive = true
        NSLayoutConstraint(item: firstNameTextField, attribute: .leading, relatedBy: .equal, toItem: profileImageView, attribute: .trailing, multiplier: 1, constant: 25).isActive = true
        NSLayoutConstraint(item: firstNameTextField, attribute: .trailing, relatedBy: .equal, toItem: lastNameTextField, attribute: .leading, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: firstNameTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        
        //lastNameLabel
        NSLayoutConstraint(item: lastNameLabel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 70).isActive = true
        NSLayoutConstraint(item: lastNameLabel, attribute: .leading, relatedBy: .equal, toItem: firstNameTextField, attribute: .trailing, multiplier: 1, constant: 10).isActive = true
        
        //lastNameTextField
        NSLayoutConstraint(item: lastNameTextField, attribute: .top, relatedBy: .equal, toItem: firstNameLabel, attribute: .bottom, multiplier: 1, constant: 3).isActive = true
        NSLayoutConstraint(item: lastNameTextField, attribute: .width, relatedBy: .equal, toItem: firstNameTextField, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: lastNameTextField, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: lastNameTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        
        //emailLabel
        NSLayoutConstraint(item: emailLabel, attribute: .top, relatedBy: .equal, toItem: firstNameTextField, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: emailLabel, attribute: .leading, relatedBy: .equal, toItem: profileImageView, attribute: .trailing, multiplier: 1, constant: 25).isActive = true
        
        //emailTextField
        NSLayoutConstraint(item: emailTextField, attribute: .top, relatedBy: .equal, toItem: emailLabel, attribute: .bottom, multiplier: 1, constant: 3).isActive = true
        NSLayoutConstraint(item: emailTextField, attribute: .leading, relatedBy: .equal, toItem: profileImageView, attribute: .trailing, multiplier: 1, constant: 25).isActive = true
        NSLayoutConstraint(item: emailTextField, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: emailTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        
        //phonNumberLabel
        NSLayoutConstraint(item: phoneNumberLabel, attribute: .top, relatedBy: .equal, toItem: emailTextField, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: phoneNumberLabel, attribute: .leading, relatedBy: .equal, toItem: profileImageView, attribute: .trailing, multiplier: 1, constant: 25).isActive = true
        
        //phoneNumberTextField
        NSLayoutConstraint(item: phoneNumberTextField, attribute: .top, relatedBy: .equal, toItem: phoneNumberLabel, attribute: .bottom, multiplier: 1, constant: 3).isActive = true
        NSLayoutConstraint(item: phoneNumberTextField, attribute: .leading, relatedBy: .equal, toItem: profileImageView, attribute: .trailing, multiplier: 1, constant: 25).isActive = true
        NSLayoutConstraint(item: phoneNumberTextField, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: phoneNumberTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        
        //saveButton
        NSLayoutConstraint(item: saveButton, attribute: .top, relatedBy: .equal, toItem: phoneNumberTextField, attribute: .bottom, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: saveButton, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: saveButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: saveButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        
        //listingsReviewsSegmentedControl
        NSLayoutConstraint(item: listingsReviewsSegmentedControl, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25).isActive = true
        NSLayoutConstraint(item: listingsReviewsSegmentedControl, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: listingsReviewsSegmentedControl, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: listingsReviewsSegmentedControl, attribute: .bottom, relatedBy: .equal, toItem: childContainerView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        
        //containerView
        NSLayoutConstraint(item: childContainerView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: childContainerView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: childContainerView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: childContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
    }
    
    @objc func saveDetails(){
        
        //contactEmail changed only alert
        if(emailTextField.text != FirebaseData.sharedInstance.currentUser?.email){
            
            present(AlertDefault.showAlert(title: "Login Email not changed", message: "Your contact email has been updated. The email you use to login in however, cannot be changed"), animated: true, completion: nil)
        }
        
        FirebaseData.sharedInstance.currentUser?.firstName = firstNameTextField.text!
        FirebaseData.sharedInstance.currentUser?.lastName = lastNameTextField.text!
        FirebaseData.sharedInstance.currentUser?.email = emailTextField.text!
        FirebaseData.sharedInstance.currentUser?.phoneNumber = Int(phoneNumberTextField.text!)!
        
        WriteFirebaseData.write(user: FirebaseData.sharedInstance.currentUser!)
        
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
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        firstNameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
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
    


}
