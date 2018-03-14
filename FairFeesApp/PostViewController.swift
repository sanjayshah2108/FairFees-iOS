//
//  PostViewController.swift
//  FairFeesApp
//
//  Created by Sanjay Shah on 2018-03-08.
//  Copyright © 2018 Fair Fees. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlaces
import GooglePlacePicker

class PostViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate, GMSPlacePickerViewControllerDelegate {
    
    
    var navigationBarHeight: CGFloat!

    var nameTextField: UITextField!
    var priceTextField: UITextField!
    var sizeTextField: UITextField!
    var bedroomNumberTextField: UITextField!
    var bathroomNumberTextField: UITextField!
    var descriptionTextField: UITextView!
    var countryTextField: UITextField!
    var cityTextField: UITextField!
    var provinceTextField: UITextField!
    var addressTextField: UITextField!
    var zipcodeTextField: UITextField!
    
    var customBedroomStepper: UIView!
    var bedroomMinusButton: UIButton!
    var bedroomPlusButton: UIButton!
    var bedroomNumberLabel: UILabel!
    var bedroomNumber: Int!
    
    var customBathroomStepper: UIView!
    var bathroomPlusButton: UIButton!
    var bathroomMinusButton: UIButton!
    var bathroomNumberLabel: UILabel!
    var bathroomNumber: Int!
    
    var addressInstructionLabel: UILabel!
    
    var submitButton: UIBarButtonItem!
    var locationButton: UIButton!
    var addPhotosButton: UIButton!
    var photosArray: [UIImage]!
    var photoCollectionView: UICollectionView!

    var location: CLLocation!
    
    var tapGesture: UITapGestureRecognizer!
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        self.navigationItem.title = "New Listing"
        submitButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(submitPost))
        self.navigationItem.rightBarButtonItem = submitButton
        navigationBarHeight = (self.navigationController?.navigationBar.frame.maxY)!
        
        setupTextFields()
        setupSteppers()
        setupLabels()
        setupLocationButton()
        setupPhotosButton()
        setupCollectionView()
        setupConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupTextFields(){
        
        nameTextField = UITextField()
        nameTextField.delegate = self
        nameTextField.frame = CGRect.zero
        nameTextField.layer.borderWidth = 1
        nameTextField.layer.borderColor = UIColor.gray.cgColor
        nameTextField.layer.cornerRadius = 3
        nameTextField.placeholder = "Name"
        nameTextField.textAlignment = .center
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameTextField)
        
        priceTextField = UITextField()
        priceTextField.delegate = self
        priceTextField.frame = CGRect.zero
        priceTextField.layer.borderWidth = 1
        priceTextField.layer.borderColor = UIColor.gray.cgColor
        priceTextField.layer.cornerRadius = 3
        priceTextField.placeholder = "Price"
        priceTextField.textAlignment = .center
        priceTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(priceTextField)
        
        sizeTextField = UITextField()
        sizeTextField.delegate = self
        sizeTextField.frame = CGRect.zero
        sizeTextField.layer.borderWidth = 1
        sizeTextField.layer.borderColor = UIColor.gray.cgColor
        sizeTextField.layer.cornerRadius = 3
        sizeTextField.placeholder = "Size (SF)"
        sizeTextField.textAlignment = .center
        sizeTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sizeTextField)
        
//        bedroomNumberTextField = UITextField()
//        bedroomNumberTextField.delegate = self
//        bedroomNumberTextField.frame = CGRect.zero
//        bedroomNumberTextField.layer.borderWidth = 1
//        bedroomNumberTextField.layer.borderColor = UIColor.gray.cgColor
//        bedroomNumberTextField.layer.cornerRadius = 3
//        bedroomNumberTextField.placeholder = "No. of Bedrooms"
//        bedroomNumberTextField.textAlignment = .center
//        bedroomNumberTextField.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(bedroomNumberTextField)
//
//        bathroomNumberTextField = UITextField()
//        bathroomNumberTextField.delegate = self
//        bathroomNumberTextField.frame = CGRect.zero
//        bathroomNumberTextField.layer.borderWidth = 1
//        bathroomNumberTextField.layer.borderColor = UIColor.gray.cgColor
//        bathroomNumberTextField.layer.cornerRadius = 3
//        bathroomNumberTextField.placeholder = "No. of Bathrooms"
//        bathroomNumberTextField.textAlignment = .center
//        bathroomNumberTextField.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(bathroomNumberTextField)
        
        descriptionTextField = UITextView()
        descriptionTextField.delegate = self
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
        cityTextField.delegate = self
        cityTextField.frame = CGRect.zero
        cityTextField.layer.borderWidth = 1
        cityTextField.layer.borderColor = UIColor.gray.cgColor
        cityTextField.layer.cornerRadius = 3
        cityTextField.placeholder = "City"
        cityTextField.textAlignment = .center
        cityTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cityTextField)
        
        countryTextField = UITextField()
        countryTextField.delegate = self
        countryTextField.frame = CGRect.zero
        countryTextField.layer.borderWidth = 1
        countryTextField.layer.borderColor = UIColor.gray.cgColor
        countryTextField.layer.cornerRadius = 3
        countryTextField.placeholder = "Country"
        countryTextField.textAlignment = .center
        countryTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(countryTextField)
        
        provinceTextField = UITextField()
        provinceTextField.delegate = self
        provinceTextField.frame = CGRect.zero
        provinceTextField.layer.borderWidth = 1
        provinceTextField.layer.borderColor = UIColor.gray.cgColor
        provinceTextField.layer.cornerRadius = 3
        provinceTextField.placeholder = "Province"
        provinceTextField.textAlignment = .center
        provinceTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(provinceTextField)
        
        addressTextField = UITextField()
        addressTextField.delegate = self
        addressTextField.frame = CGRect.zero
        addressTextField.layer.borderWidth = 1
        addressTextField.layer.borderColor = UIColor.gray.cgColor
        addressTextField.layer.cornerRadius = 3
        addressTextField.placeholder = "Address"
        addressTextField.textAlignment = .center
        addressTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addressTextField)
        
        zipcodeTextField = UITextField()
        zipcodeTextField.delegate = self
        zipcodeTextField.frame = CGRect.zero
        zipcodeTextField.layer.borderWidth = 1
        zipcodeTextField.layer.borderColor = UIColor.gray.cgColor
        zipcodeTextField.layer.cornerRadius = 3
        zipcodeTextField.placeholder = "Zipcode"
        zipcodeTextField.textAlignment = .center
        zipcodeTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(zipcodeTextField)
        
    }
    
    func setupSteppers(){
        setupBedroomStepper()
        setupBathroomStepper()
    }
    
    func setupBedroomStepper(){
        customBedroomStepper = UIView()
        customBedroomStepper.frame = CGRect.zero
        customBedroomStepper.layer.borderColor = UIColor.blue.cgColor
        customBedroomStepper.layer.borderWidth = 1
        customBedroomStepper.layer.cornerRadius = 3
        customBedroomStepper.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customBedroomStepper)
        
        bedroomMinusButton = UIButton()
        bedroomMinusButton.addTarget(self, action: #selector(reduceCount), for: .touchUpInside)
        bedroomMinusButton.setTitle("-", for: .normal)
        bedroomMinusButton.backgroundColor = UIColor.blue
        bedroomMinusButton.layer.cornerRadius = 3
        bedroomMinusButton.translatesAutoresizingMaskIntoConstraints = false
        customBedroomStepper.addSubview(bedroomMinusButton)
        
        bedroomNumberLabel = UILabel()
        bedroomNumberLabel.textAlignment = .center
        bedroomNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        bedroomNumber = 0
        bedroomNumberLabel.text = "Bedroom #"
        bedroomNumberLabel.textColor = UIColor.gray
        bedroomNumberLabel.font = UIFont(name: "Avenir-Light", size: 10)
        customBedroomStepper.addSubview(bedroomNumberLabel)
        
        bedroomPlusButton = UIButton()
        bedroomPlusButton.addTarget(self, action: #selector(addCount), for: .touchUpInside)
        bedroomPlusButton.setTitle("+", for: .normal)
        bedroomPlusButton.backgroundColor = UIColor.blue
        bedroomPlusButton.layer.cornerRadius = 3
        bedroomPlusButton.translatesAutoresizingMaskIntoConstraints = false
        customBedroomStepper.addSubview(bedroomPlusButton)
    }

    func setupBathroomStepper(){
        customBathroomStepper = UIView()
        customBathroomStepper.frame = CGRect.zero
        customBathroomStepper.layer.borderColor = UIColor.blue.cgColor
        customBathroomStepper.layer.borderWidth = 1
        customBathroomStepper.layer.cornerRadius = 5
        customBathroomStepper.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customBathroomStepper)
        
        bathroomMinusButton = UIButton()
        bathroomMinusButton.addTarget(self, action: #selector(reduceCount), for: .touchUpInside)
        bathroomMinusButton.backgroundColor = UIColor.blue
        bathroomMinusButton.layer.cornerRadius = 3
        bathroomMinusButton.setTitle("-", for: .normal)
        bathroomMinusButton.translatesAutoresizingMaskIntoConstraints = false
        customBathroomStepper.addSubview(bathroomMinusButton)
        
        bathroomNumberLabel = UILabel()
        bathroomNumberLabel.textAlignment = .center
        bathroomNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        bathroomNumber = 0
        bathroomNumberLabel.text = "Bathroom #"
        bathroomNumberLabel.textColor = UIColor.gray
        bathroomNumberLabel.font = UIFont(name: "Avenir-Light", size: 10)
        customBathroomStepper.addSubview(bathroomNumberLabel)
        
        bathroomPlusButton = UIButton()
        bathroomPlusButton.addTarget(self, action: #selector(addCount), for: .touchUpInside)
        bathroomPlusButton.backgroundColor = UIColor.blue
        bathroomPlusButton.layer.cornerRadius = 3
        bathroomPlusButton.setTitle("+", for: .normal)
        bathroomPlusButton.translatesAutoresizingMaskIntoConstraints = false
        customBathroomStepper.addSubview(bathroomPlusButton)
    }
    
    func setupLocationButton(){
        locationButton = UIButton()
        locationButton.setTitle("Pick Location", for: .normal)
        locationButton.titleLabel?.textAlignment = .left
        //locationButton.addTarget(self, action: #selector(showMapForSelectingLocation), for: .touchUpInside)
        locationButton.addTarget(self, action: #selector(pickPlace), for: .touchUpInside)
        locationButton.backgroundColor = UIColor.blue
        locationButton.layer.cornerRadius = 4
        locationButton.layer.borderColor = UIColor.blue.cgColor
        locationButton.layer.borderWidth = 3
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(locationButton)
    }
    
    func setupLabels(){
        addressInstructionLabel = UILabel()
        addressInstructionLabel.text = "Fill out address or"
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
        addPhotosButton.backgroundColor = UIColor.blue
        addPhotosButton.layer.cornerRadius = 4
        addPhotosButton.layer.borderColor = UIColor.blue.cgColor
        addPhotosButton.layer.borderWidth = 3
        addPhotosButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addPhotosButton)
    }
    
    func setupCollectionView(){
        
        photosArray = []
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize.init(width: 50, height: 50)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 5.0
        photoCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.addSubview(photoCollectionView)

        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        photoCollectionView.backgroundColor = UIColor.white
        
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        photoCollectionView.layer.borderWidth = 2
        photoCollectionView.layer.borderColor = UIProperties.sharedUIProperties.primaryBlackColor.cgColor
    }
    
    func setupConstraints(){
        
        //nameTextField
        NSLayoutConstraint(item: nameTextField, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: (navigationBarHeight + 10)).isActive = true
        NSLayoutConstraint(item: nameTextField, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: nameTextField, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing , multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: nameTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        
        //priceTextField
        NSLayoutConstraint(item: priceTextField, attribute: .top, relatedBy: .equal, toItem: nameTextField, attribute: .bottom , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: priceTextField, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: priceTextField, attribute: .trailing, relatedBy: .equal, toItem: sizeTextField, attribute: .leading , multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: priceTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        
        //sizeTextField
        NSLayoutConstraint(item: sizeTextField, attribute: .top, relatedBy: .equal, toItem: nameTextField, attribute: .bottom , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: sizeTextField, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing , multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: sizeTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: sizeTextField, attribute: .width, relatedBy: .equal, toItem: priceTextField, attribute: .width, multiplier: 1, constant: 0).isActive = true
        
        
        //bedroomsNumberStepper
        NSLayoutConstraint(item: customBedroomStepper, attribute: .top, relatedBy: .equal, toItem: priceTextField, attribute: .bottom , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: customBedroomStepper, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: customBedroomStepper, attribute: .trailing, relatedBy: .equal, toItem: customBathroomStepper, attribute: .leading , multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: customBedroomStepper, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        
        NSLayoutConstraint(item: bedroomMinusButton, attribute: .top, relatedBy: .equal, toItem: customBedroomStepper, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: bedroomMinusButton, attribute: .leading, relatedBy: .equal, toItem: customBedroomStepper, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: bedroomMinusButton, attribute: .trailing, relatedBy: .equal, toItem: bedroomNumberLabel, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: bedroomMinusButton, attribute: .bottom, relatedBy: .equal, toItem: customBedroomStepper, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: bedroomNumberLabel, attribute: .top, relatedBy: .equal, toItem: customBedroomStepper, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: bedroomNumberLabel, attribute: .width, relatedBy: .equal, toItem: bedroomMinusButton, attribute: .width, multiplier: 1.5, constant: 0).isActive = true
        NSLayoutConstraint(item: bedroomNumberLabel, attribute: .trailing, relatedBy: .equal, toItem: bedroomPlusButton, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: bedroomNumberLabel, attribute: .bottom, relatedBy: .equal, toItem: customBedroomStepper, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: bedroomPlusButton, attribute: .top, relatedBy: .equal, toItem: customBedroomStepper, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: bedroomPlusButton, attribute: .width, relatedBy: .equal, toItem: bedroomMinusButton, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: bedroomPlusButton, attribute: .trailing, relatedBy: .equal, toItem: customBedroomStepper, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: bedroomPlusButton, attribute: .bottom, relatedBy: .equal, toItem: customBedroomStepper, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        
        //bathroomsNumberStepper
        NSLayoutConstraint(item: customBathroomStepper, attribute: .top, relatedBy: .equal, toItem: sizeTextField, attribute: .bottom , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: customBathroomStepper, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing , multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: customBathroomStepper, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: customBathroomStepper, attribute: .width, relatedBy: .equal, toItem: customBedroomStepper, attribute: .width, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: bathroomMinusButton, attribute: .top, relatedBy: .equal, toItem: customBathroomStepper, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: bathroomMinusButton, attribute: .leading, relatedBy: .equal, toItem: customBathroomStepper, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: bathroomMinusButton, attribute: .trailing, relatedBy: .equal, toItem: bathroomNumberLabel, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: bathroomMinusButton, attribute: .bottom, relatedBy: .equal, toItem: customBathroomStepper, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: bathroomNumberLabel, attribute: .top, relatedBy: .equal, toItem: customBathroomStepper, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: bathroomNumberLabel, attribute: .width, relatedBy: .equal, toItem: bathroomMinusButton, attribute: .width, multiplier: 1.5, constant: 0).isActive = true
        NSLayoutConstraint(item: bathroomNumberLabel, attribute: .trailing, relatedBy: .equal, toItem: bathroomPlusButton, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: bathroomNumberLabel, attribute: .bottom, relatedBy: .equal, toItem: customBathroomStepper, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: bathroomPlusButton, attribute: .top, relatedBy: .equal, toItem: customBathroomStepper, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: bathroomPlusButton, attribute: .width, relatedBy: .equal, toItem: bathroomMinusButton, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: bathroomPlusButton, attribute: .trailing, relatedBy: .equal, toItem: customBathroomStepper, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: bathroomPlusButton, attribute: .bottom, relatedBy: .equal, toItem: customBathroomStepper, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        //descriptionTextField
        NSLayoutConstraint(item: descriptionTextField, attribute: .top, relatedBy: .equal, toItem: customBathroomStepper, attribute: .bottom , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: descriptionTextField, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: descriptionTextField, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing , multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: descriptionTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        
        //addressInstructionLabel
        NSLayoutConstraint(item: addressInstructionLabel, attribute: .top, relatedBy: .equal, toItem: descriptionTextField, attribute: .bottom, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: addressInstructionLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading , multiplier: 1, constant: 10).isActive = true
       
        NSLayoutConstraint(item: addressInstructionLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        
        
        
        //addressTextField
        NSLayoutConstraint(item: addressTextField, attribute: .top, relatedBy: .equal, toItem: addressInstructionLabel, attribute: .bottom , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: addressTextField, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: addressTextField, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing , multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: addressTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        
        //cityTextField
        NSLayoutConstraint(item: cityTextField, attribute: .top, relatedBy: .equal, toItem: addressTextField, attribute: .bottom , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: cityTextField, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: cityTextField, attribute: .trailing, relatedBy: .equal, toItem: provinceTextField, attribute: .leading , multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: cityTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        
        //provinceTextField
        NSLayoutConstraint(item: provinceTextField, attribute: .top, relatedBy: .equal, toItem: addressTextField, attribute: .bottom , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: provinceTextField, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing , multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: provinceTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: provinceTextField, attribute: .width, relatedBy: .equal, toItem: cityTextField, attribute: .width, multiplier: 1, constant: 0).isActive = true
        
        //countryTextField
        NSLayoutConstraint(item: countryTextField, attribute: .top, relatedBy: .equal, toItem: cityTextField, attribute: .bottom , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: countryTextField, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: countryTextField, attribute: .trailing, relatedBy: .equal, toItem: zipcodeTextField, attribute: .leading , multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: countryTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        
        //zipCodeTextField
        NSLayoutConstraint(item: zipcodeTextField, attribute: .top, relatedBy: .equal, toItem: cityTextField, attribute: .bottom , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: zipcodeTextField, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing , multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: zipcodeTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: zipcodeTextField, attribute: .width, relatedBy: .equal, toItem: countryTextField, attribute: .width, multiplier: 1, constant: 0).isActive = true
        
        
        //locationButton
        NSLayoutConstraint(item: locationButton, attribute: .top, relatedBy: .equal, toItem: descriptionTextField, attribute: .bottom, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: locationButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 150).isActive = true
         NSLayoutConstraint(item: locationButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing , multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: locationButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        
        //addPhotosButton
        NSLayoutConstraint(item: addPhotosButton, attribute: .top, relatedBy: .equal, toItem: zipcodeTextField, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: addPhotosButton, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: addPhotosButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: addPhotosButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        
        //photoCollectionView
        NSLayoutConstraint(item: photoCollectionView, attribute: .top, relatedBy: .equal, toItem: addPhotosButton, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: photoCollectionView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: photoCollectionView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: photoCollectionView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -10).isActive = true
        
    }
    
    @objc func addCount(sender: UIButton){
        if (sender.superview == customBedroomStepper){
            bedroomNumber = bedroomNumber + 1
            bedroomNumberLabel.text = String(bedroomNumber)
            bedroomNumberLabel.textColor = UIColor.black
            
            
        }
        else if (sender.superview == customBathroomStepper){
            bathroomNumber = bathroomNumber + 1
            bathroomNumberLabel.text = String(bathroomNumber)
            bathroomNumberLabel.textColor = UIColor.black
        }
    }
    
    @objc func reduceCount(sender: UIButton){
        if (sender.superview == customBedroomStepper){
            
            if(bedroomNumber == 1){
                bedroomNumber = 0
                bedroomNumberLabel.text = "Bedroom #"
                bedroomNumberLabel.textColor = UIColor.gray
            }
            
            else {
                bedroomNumber = bedroomNumber - 1
                bedroomNumberLabel.text = String(bedroomNumber)
                bedroomNumberLabel.textColor = UIColor.black
            }
        }
        else if (sender.superview == customBathroomStepper){
            
            if(bathroomNumber == 1){
                bathroomNumber = 0
                bathroomNumberLabel.text = "Bathroom #"
                bathroomNumberLabel.textColor = UIColor.gray
            }
            else {
                bathroomNumber = bathroomNumber - 1
                bathroomNumberLabel.text = String(bathroomNumber)
                bathroomNumberLabel.textColor = UIColor.black
            }
        }
    }
    
    @objc func showMapForSelectingLocation(){

        let postMapViewController = PostMapViewController()
        self.navigationController?.pushViewController(postMapViewController, animated: true)
    }
    
    @objc func addPhotos(){
        presentImagePickerAlert()
    }
    
    @objc func submitPost(){
        
        let post = HomeSale(name: nameTextField.text!, description: descriptionTextField.text!, location: location, address: addressTextField.text!, poster: DummyData.theDummyData.users[0], photos: photosArray, size: Int(sizeTextField.text!)!, bedroomNumber: Int(bedroomNumberTextField.text!)!, bathroomNumber: Int(bathroomNumberTextField.text!)!, UID: nil, price: Int(priceTextField.text!)!, owner: DummyData.theDummyData.users[0], availabilityDate: Date())
        
        DummyData.theDummyData.addListing(listing: post)
        
        self.navigationController?.popViewController(animated: true)
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
        photosArray.append(myImage!)
        dismiss(animated: true, completion: nil)
        photoCollectionView.reloadData()
    }
    
    func presentImagePickerAlert() {
        
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
    
    
    //photoCollectionViewDelegate methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        photoCollectionView.register(UINib(nibName: "PostPhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "photoCollectionViewCell")
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCollectionViewCell", for: indexPath) as! PostPhotoCollectionViewCell
        
        cell.cellImageView.image = photosArray[indexPath.row]
        cell.cellImageView.contentMode = .scaleAspectFill
        cell.cellImageView.layer.borderColor = UIProperties.sharedUIProperties.primaryBlackColor.cgColor
        cell.cellImageView.layer.borderWidth = 2
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let changePhotoAlert = UIAlertController(title: "View or Delete Photo?", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        

        let viewAction = UIAlertAction(title: "View Photo", style: UIAlertActionStyle.default, handler:{ (action) in
                self.fullscreenImage(image: self.photosArray[indexPath.item])
                
            })
            
        let changeAction = UIAlertAction(title: "Delete Photo", style: UIAlertActionStyle.destructive, handler:{ (action) in
            self.photosArray.remove(at: indexPath.item)
            self.photoCollectionView.reloadData()
            })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        changePhotoAlert.addAction(viewAction)
        changePhotoAlert.addAction(changeAction)
        changePhotoAlert.addAction(cancelAction)
        
        self.present(changePhotoAlert, animated: true, completion: nil)
    }
    
    
    @objc func pickPlace(sender: UIButton) {
        let config = GMSPlacePickerConfig(viewport: nil)
        let placePicker = GMSPlacePickerViewController(config: config)
        placePicker.delegate = self
        
        present(placePicker, animated: true, completion: nil)
    }
    
    // To receive the results from the place picker 'self' will need to conform to
    // GMSPlacePickerViewControllerDelegate and implement this code.
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        
        location = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        
        if (place.addressComponents != nil){
        
            for component in place.addressComponents! {
                if(component.type == "route"){
                    addressTextField.text = component.name
                }
                if (component.type == "locality") {
                    cityTextField.text = component.name
                }
                if (component.type == "country") {
                    countryTextField.text = component.name
                }
                if (component.type == "postal_code"){
                    zipcodeTextField.text = component.name
                }
                if (component.type == "administrative_area_level_1"){
                    provinceTextField.text = component.name
                }
            }
        }
        
        else {
            reverseGeocode(location: location)
        }
    }
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        
        print("No place selected")
    }
    
    func reverseGeocode(location: CLLocation){
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            if (placemarks!.count > 0) {
                let pm = placemarks![0]
                
                if(pm.thoroughfare != nil && pm.subThoroughfare != nil){
                    // not all places have thoroughfare & subThoroughfare so validate those values

                    self.addressTextField.text = pm.subThoroughfare! + " " + pm.thoroughfare!
                    self.cityTextField.text = pm.locality
                    self.provinceTextField.text = pm.administrativeArea
                    self.countryTextField.text = pm.country
                    self.zipcodeTextField.text = pm.postalCode
            
                }
                else if(pm.subThoroughfare != nil) {
                    
                    self.addressTextField.text = pm.thoroughfare!
                    self.cityTextField.text = pm.locality
                    self.provinceTextField.text = pm.administrativeArea
                    self.countryTextField.text = pm.country
                    self.zipcodeTextField.text = pm.postalCode
                }
                    
                else {
                    print("Problem with the data received from geocoder")
                }
            }
            else {
                print("Problem with the data received from geocoder")
            }
        })
        
    }
    
    
        
    
    //textView methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.view.removeGestureRecognizer(tapGesture)
        
    }
    
    func textViewDidBeginEditing (_ textView: UITextView) {
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        if descriptionTextField.textColor == .lightGray && descriptionTextField.isFirstResponder {
            descriptionTextField.text = nil
            descriptionTextField.textColor = .black
        }
    }
    
    func textViewDidEndEditing (_ textView: UITextView) {
        
        self.view.removeGestureRecognizer(tapGesture)
        
        if descriptionTextField.text.isEmpty || descriptionTextField.text == "" {
            descriptionTextField.textColor = .lightGray
            descriptionTextField.text = "Optional Description"
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        nameTextField.resignFirstResponder()
        priceTextField.resignFirstResponder()
        sizeTextField.resignFirstResponder()
        //bedroomNumberTextField.resignFirstResponder()
        //bathroomNumberTextField.resignFirstResponder()
        descriptionTextField.resignFirstResponder()
        addressTextField.resignFirstResponder()
        cityTextField.resignFirstResponder()
        countryTextField.resignFirstResponder()
        provinceTextField.resignFirstResponder()
        zipcodeTextField.resignFirstResponder()
        
    }
    
    //fullcreen image methods
    func fullscreenImage(image: UIImage) {
        
        let newImageView = UIImageView(image: image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true

    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        sender.view?.removeFromSuperview()
    }
    
}
