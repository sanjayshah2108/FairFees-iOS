//
//  PostViewController.swift
//  FairFeesApp
//
//  Created by Sanjay Shah on 2018-03-08.
//  Copyright © 2018 Fair Fees. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {
    
    var navigationBarHeight: CGFloat!
    var tabBarHeight: CGFloat!

    var nameTextField: UITextField!
    var priceTextField: UITextField!
    var sizeTextField: UITextField!
    var bedroomNumberTextField: UITextField!
    var bathroomNumberTextField: UITextField!
    var descriptionTextField: UITextView!
    
    var addressInstructionLabel: UILabel!
    
    var locationButton: UIButton!
    var addPhotosButton: UIButton!
    
    var countryTextField: UITextField!
    var cityTextField: UITextField!
    var provinceTextField: UITextField!
    var addressTextField: UITextField!
    var zipcodeTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.navigationItem.title = "New Listing"
        navigationBarHeight = (self.navigationController?.navigationBar.frame.maxY)!
        tabBarHeight = self.tabBarController?.tabBar.frame.height
        
        setupTextFields()
        setupLabels()
        setupLocationButton()
        setupPhotosButton()
        setupConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupTextFields(){
        
        nameTextField = UITextField()
        nameTextField.frame = CGRect.zero
        nameTextField.layer.borderWidth = 1
        nameTextField.layer.borderColor = UIColor.gray.cgColor
        nameTextField.layer.cornerRadius = 3
        nameTextField.placeholder = "Name"
        nameTextField.textAlignment = .center
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameTextField)
        
        priceTextField = UITextField()
        priceTextField.frame = CGRect.zero
        priceTextField.layer.borderWidth = 1
        priceTextField.layer.borderColor = UIColor.gray.cgColor
        priceTextField.layer.cornerRadius = 3
        priceTextField.placeholder = "Price"
        priceTextField.textAlignment = .center
        priceTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(priceTextField)
        
        sizeTextField = UITextField()
        sizeTextField.frame = CGRect.zero
        sizeTextField.layer.borderWidth = 1
        sizeTextField.layer.borderColor = UIColor.gray.cgColor
        sizeTextField.layer.cornerRadius = 3
        sizeTextField.placeholder = "Size (SF)"
        sizeTextField.textAlignment = .center
        sizeTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sizeTextField)
        
        bedroomNumberTextField = UITextField()
        bedroomNumberTextField.frame = CGRect.zero
        bedroomNumberTextField.layer.borderWidth = 1
        bedroomNumberTextField.layer.borderColor = UIColor.gray.cgColor
        bedroomNumberTextField.layer.cornerRadius = 3
        bedroomNumberTextField.placeholder = "No. of Bedrooms"
        bedroomNumberTextField.textAlignment = .center
        bedroomNumberTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bedroomNumberTextField)
        
        bathroomNumberTextField = UITextField()
        bathroomNumberTextField.frame = CGRect.zero
        bathroomNumberTextField.layer.borderWidth = 1
        bathroomNumberTextField.layer.borderColor = UIColor.gray.cgColor
        bathroomNumberTextField.layer.cornerRadius = 3
        bathroomNumberTextField.placeholder = "No. of Bathrooms"
        bathroomNumberTextField.textAlignment = .center
        bathroomNumberTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bathroomNumberTextField)
        
        descriptionTextField = UITextView()
        descriptionTextField.frame = CGRect.zero
        descriptionTextField.layer.borderWidth = 1
        descriptionTextField.layer.borderColor = UIColor.gray.cgColor
        descriptionTextField.layer.cornerRadius = 3
        descriptionTextField.text = "Description"
        descriptionTextField.textColor = UIColor.gray
        descriptionTextField.textAlignment = .center
        descriptionTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionTextField)
        
        cityTextField = UITextField()
        cityTextField.frame = CGRect.zero
        cityTextField.layer.borderWidth = 1
        cityTextField.layer.borderColor = UIColor.gray.cgColor
        cityTextField.layer.cornerRadius = 3
        cityTextField.placeholder = "City"
        cityTextField.textAlignment = .center
        cityTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cityTextField)
        
        countryTextField = UITextField()
        countryTextField.frame = CGRect.zero
        countryTextField.layer.borderWidth = 1
        countryTextField.layer.borderColor = UIColor.gray.cgColor
        countryTextField.layer.cornerRadius = 3
        countryTextField.placeholder = "Country"
        countryTextField.textAlignment = .center
        countryTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(countryTextField)
        
        provinceTextField = UITextField()
        provinceTextField.frame = CGRect.zero
        provinceTextField.layer.borderWidth = 1
        provinceTextField.layer.borderColor = UIColor.gray.cgColor
        provinceTextField.layer.cornerRadius = 3
        provinceTextField.placeholder = "Province"
        provinceTextField.textAlignment = .center
        provinceTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(provinceTextField)
        
        addressTextField = UITextField()
        addressTextField.frame = CGRect.zero
        addressTextField.layer.borderWidth = 1
        addressTextField.layer.borderColor = UIColor.gray.cgColor
        addressTextField.layer.cornerRadius = 3
        addressTextField.placeholder = "Address"
        addressTextField.textAlignment = .center
        addressTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addressTextField)
        
        zipcodeTextField = UITextField()
        zipcodeTextField.frame = CGRect.zero
        zipcodeTextField.layer.borderWidth = 1
        zipcodeTextField.layer.borderColor = UIColor.gray.cgColor
        zipcodeTextField.layer.cornerRadius = 3
        zipcodeTextField.placeholder = "Zipcode"
        zipcodeTextField.textAlignment = .center
        zipcodeTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(zipcodeTextField)
        
    }
    
    func setupLocationButton(){
        locationButton = UIButton()
        locationButton.setTitle("Pick Location:", for: .normal)
        locationButton.titleLabel?.textAlignment = .left
        locationButton.addTarget(self, action: #selector(showMapForSelectingLocation), for: .touchUpInside)
        locationButton.backgroundColor = UIColor.blue
        locationButton.layer.cornerRadius = 4
        locationButton.layer.borderColor = UIColor.blue.cgColor
        locationButton.layer.borderWidth = 3
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(locationButton)
    }
    
    func setupLabels(){
        addressInstructionLabel = UILabel()
        addressInstructionLabel.text = "Fill out address or pick location"
        addressInstructionLabel.font = UIFont(name: "Avenir-Light", size: 15)
        addressInstructionLabel.textAlignment = .left
        addressInstructionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addressInstructionLabel)
    }
    
    func setupPhotosButton(){
        addPhotosButton = UIButton()
        addPhotosButton.setTitle("Add Photos", for: .normal)
        addPhotosButton.titleLabel?.textAlignment = .center
        addPhotosButton.addTarget(self, action: #selector(addPhotos), for: .touchUpInside)
        addPhotosButton.backgroundColor = UIProperties.sharedUIProperties.primaryGrayColor
        addPhotosButton.layer.cornerRadius = 4
        addPhotosButton.layer.borderColor = UIColor.blue.cgColor
        addPhotosButton.layer.borderWidth = 3
        addPhotosButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addPhotosButton)
    }
    
    func setupConstraints(){
        
        //nameTextField
        NSLayoutConstraint(item: nameTextField, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: (navigationBarHeight + 10)).isActive = true
        NSLayoutConstraint(item: nameTextField, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: nameTextField, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing , multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: nameTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 15).isActive = true
        
        //priceTextField
        NSLayoutConstraint(item: priceTextField, attribute: .top, relatedBy: .equal, toItem: nameTextField, attribute: .bottom , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: priceTextField, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: priceTextField, attribute: .trailing, relatedBy: .equal, toItem: sizeTextField, attribute: .leading , multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: priceTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 15).isActive = true
        
        //sizeTextField
        NSLayoutConstraint(item: sizeTextField, attribute: .top, relatedBy: .equal, toItem: nameTextField, attribute: .bottom , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: sizeTextField, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing , multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: sizeTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: sizeTextField, attribute: .width, relatedBy: .equal, toItem: priceTextField, attribute: .width, multiplier: 1, constant: 0).isActive = true
        
        //bedroomsNumberTextField
        NSLayoutConstraint(item: bedroomNumberTextField, attribute: .top, relatedBy: .equal, toItem: priceTextField, attribute: .bottom , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: bedroomNumberTextField, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: bedroomNumberTextField, attribute: .trailing, relatedBy: .equal, toItem: bathroomNumberTextField, attribute: .leading , multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: bedroomNumberTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 15).isActive = true
        
        //bathroomsNumberTextField
        NSLayoutConstraint(item: bathroomNumberTextField, attribute: .top, relatedBy: .equal, toItem: sizeTextField, attribute: .bottom , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: bathroomNumberTextField, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing , multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: bathroomNumberTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: bathroomNumberTextField, attribute: .width, relatedBy: .equal, toItem: bedroomNumberTextField, attribute: .width, multiplier: 1, constant: 0).isActive = true
        
        //descriptionTextField
        NSLayoutConstraint(item: descriptionTextField, attribute: .top, relatedBy: .equal, toItem: bathroomNumberTextField, attribute: .bottom , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: descriptionTextField, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: descriptionTextField, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing , multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: descriptionTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        
        //addressInstructionLabel
        NSLayoutConstraint(item: addressInstructionLabel, attribute: .top, relatedBy: .equal, toItem: descriptionTextField, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: addressInstructionLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: addressInstructionLabel, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing , multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: addressInstructionLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 15).isActive = true
        
        //addressTextField
        NSLayoutConstraint(item: addressTextField, attribute: .top, relatedBy: .equal, toItem: addressInstructionLabel, attribute: .bottom , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: addressTextField, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: addressTextField, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing , multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: addressTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 15).isActive = true
        
        //cityTextField
        NSLayoutConstraint(item: cityTextField, attribute: .top, relatedBy: .equal, toItem: addressTextField, attribute: .bottom , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: cityTextField, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: cityTextField, attribute: .trailing, relatedBy: .equal, toItem: provinceTextField, attribute: .leading , multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: cityTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 15).isActive = true
        
        //provinceTextField
        NSLayoutConstraint(item: provinceTextField, attribute: .top, relatedBy: .equal, toItem: addressTextField, attribute: .bottom , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: provinceTextField, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing , multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: provinceTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: provinceTextField, attribute: .width, relatedBy: .equal, toItem: cityTextField, attribute: .width, multiplier: 1, constant: 0).isActive = true
        
        //countryTextField
        NSLayoutConstraint(item: countryTextField, attribute: .top, relatedBy: .equal, toItem: cityTextField, attribute: .bottom , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: countryTextField, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: countryTextField, attribute: .trailing, relatedBy: .equal, toItem: zipcodeTextField, attribute: .leading , multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: countryTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 15).isActive = true
        
        //zipCodeTextField
        NSLayoutConstraint(item: zipcodeTextField, attribute: .top, relatedBy: .equal, toItem: cityTextField, attribute: .bottom , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: zipcodeTextField, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing , multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: zipcodeTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: zipcodeTextField, attribute: .width, relatedBy: .equal, toItem: countryTextField, attribute: .width, multiplier: 1, constant: 0).isActive = true
        
        
        //locationButton
        NSLayoutConstraint(item: locationButton, attribute: .top, relatedBy: .equal, toItem: countryTextField, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: locationButton, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: locationButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: locationButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        
        //addPhotosButton
        NSLayoutConstraint(item: addPhotosButton, attribute: .top, relatedBy: .equal, toItem: locationButton, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: addPhotosButton, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: addPhotosButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: addPhotosButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -(tabBarHeight+10)).isActive = true
        
    }
    
    @objc func showMapForSelectingLocation(){
        print("show map")
        
        let postMapViewController = PostMapViewController()
        
        self.navigationController?.pushViewController(postMapViewController, animated: true)
    }
    
    @objc func addPhotos(){
        print("Add photos")
    }
}
