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
import Firebase

class PostViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate, GMSPlacePickerViewControllerDelegate {
    
    var navigationBarHeight: CGFloat!
    
    var submitButton: UIBarButtonItem!

    var promptLabel: UILabel!
    
    var sellOrLeaseSegmentedControl: UISegmentedControl!
    
    var nameTextField: UITextField!
    var priceTextField: UITextField!
    var sizeTextField: UITextField!
    var bedroomNumberTextField: UITextField!
    var bathroomNumberTextField: UITextField!
    var descriptionTextField: UITextView!
    
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
    
    var locationButton: UIButton!
    
    var countryTextField: UITextField!
    var cityTextField: UITextField!
    var provinceTextField: UITextField!
    var streetNameTextField: UITextField!
    var streetNumberTextField: UITextField!
    var zipcodeTextField: UITextField!
    
    var mainImageView: UIImageView!
    var photosArray: [UIImage]!
    var photoCollectionView: UICollectionView!
    
    var nextButton: UIButton!
    var previousButton: UIButton!
    var stepIndex: Int!

    var location: CLLocation!
    
    var tapGesture: UITapGestureRecognizer!
    var imagePicker: UIImagePickerController!
    
    var sellOrRentSegmentedControlTopConstraintInStep: NSLayoutConstraint!
    var sellOrRentSegmentedControlTopConstraintInPreview: NSLayoutConstraint!
    
    var nameTextFieldTopConstraintInStep: NSLayoutConstraint!
    var nameTextFieldTopConstraintInPreview: NSLayoutConstraint!
    
    var locationButtonTopConstraintInStep: NSLayoutConstraint!
    var locationButtonTopConstraintInPreview: NSLayoutConstraint!
    
    var mainImageViewTopConstraintInStep: NSLayoutConstraint!
    var mainImageViewTopConstraintInPreview: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        self.navigationItem.title = "New Listing"
        self.navigationItem.titleView?.tintColor = UIColor.black
        submitButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(submitPost))
        self.navigationItem.rightBarButtonItem = submitButton
        navigationBarHeight = (self.navigationController?.navigationBar.frame.maxY)!
        
        setupSteppers()
        setupTextFields()
        setupLabels()
        setupLocationButton()
        setupCollectionView()
        setupSegmentedControls()
        setupButtons()
        
        setupConstraints()
        
        setupInitialUI()
        setupFirstStepUI()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //this func makes everything hidden
    func setupInitialUI(){
        
        nextButton.isHidden = true
        previousButton.isHidden = true
        
        promptLabel.isHidden = true
        sellOrLeaseSegmentedControl.isHidden = true
        
        nameTextField.isHidden = true
        priceTextField.isHidden = true
        sizeTextField.isHidden = true
        descriptionTextField.isHidden = true
        countryTextField.isHidden = true
        cityTextField.isHidden = true
        provinceTextField.isHidden = true
        streetNameTextField.isHidden = true
        streetNumberTextField.isHidden = true
        zipcodeTextField.isHidden = true
        
        customBedroomStepper.isHidden = true
        bedroomMinusButton.isHidden = true
        bedroomPlusButton.isHidden = true
        bedroomNumberLabel.isHidden = true
        
        customBathroomStepper.isHidden = true
        bathroomPlusButton.isHidden = true
        bathroomMinusButton.isHidden = true
        bathroomNumberLabel.isHidden = true

        locationButton.isHidden = true
        
        mainImageView.isHidden = true
        photoCollectionView.isHidden = true
    }
    
    func setupFirstStepUI(){
        
        setupInitialUI()
        stepIndex = 0
        
        promptLabel.isHidden = false
        promptLabel.text = "What kind of listing is this?"
        
        sellOrLeaseSegmentedControl.isHidden = false

        nextButton.isHidden = false
        nextButton.setTitle("Add Details", for: .normal)
        previousButton.isHidden = true
       
    }
    
    func setupSecondStepUI(){
        
        setupInitialUI()
        
        promptLabel.isHidden = false
        promptLabel.text = "Add details of the listing"
        
        sellOrLeaseSegmentedControl.isHidden = true
        
        nameTextFieldTopConstraintInPreview.isActive = false
        nameTextFieldTopConstraintInStep.isActive = true
        
        nameTextField.isHidden = false
        descriptionTextField.isHidden = false
        priceTextField.isHidden = false
        sizeTextField.isHidden = false
        
        customBedroomStepper.isHidden = false
        bedroomMinusButton.isHidden = false
        bedroomPlusButton.isHidden = false
        bedroomNumberLabel.isHidden = false
        
        customBathroomStepper.isHidden = false
        bathroomPlusButton.isHidden = false
        bathroomMinusButton.isHidden = false
        bathroomNumberLabel.isHidden = false
        
        nextButton.isHidden = false
        nextButton.setTitle("Add Photos", for: .normal)
        previousButton.isHidden = false
        previousButton.setTitle("Type of Listing", for: .normal)
        
    }
    
    func setupThirdStepUI(){
        
        setupInitialUI()
        promptLabel.isHidden = false
        promptLabel.text = "Add some photos"
        
        mainImageViewTopConstraintInPreview.isActive = false
        
        mainImageViewTopConstraintInStep.isActive = true
        
        mainImageView.isHidden = false
        photoCollectionView.isHidden = false
        
        nextButton.isHidden = false
        nextButton.setTitle("Select a location", for: .normal)
        previousButton.isHidden = false
        previousButton.setTitle("Back to details", for: .normal)
        
    }
    
    func setupFourthStepUI(){
        
        pickPlace()
        
        setupInitialUI()
        promptLabel.isHidden = false
        promptLabel.text = "Where is it located?"
        
        locationButtonTopConstraintInPreview.isActive = false
        locationButtonTopConstraintInStep.isActive = true
        
        locationButton.isHidden = false
        countryTextField.isHidden = false
        cityTextField.isHidden = false
        provinceTextField.isHidden = false
        streetNameTextField.isHidden = false
        streetNumberTextField.isHidden = false
        zipcodeTextField.isHidden = false
        
        nextButton.isHidden = false
        nextButton.setTitle("Preview", for: .normal)
        previousButton.isHidden = false
        previousButton.setTitle("Back to photos", for: .normal)
        
        
    }
    
    func setupPreviewUI(){
        
        nextButton.isHidden = true
        previousButton.isHidden = true
        
        promptLabel.isHidden = true
        
        sellOrLeaseSegmentedControl.isHidden = false
        
        sellOrRentSegmentedControlTopConstraintInStep.isActive = false
        sellOrRentSegmentedControlTopConstraintInPreview = NSLayoutConstraint(item: sellOrLeaseSegmentedControl, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: (navigationBarHeight + 10))
        sellOrRentSegmentedControlTopConstraintInPreview.isActive = true
        
        
        nameTextFieldTopConstraintInStep.isActive = false
        nameTextFieldTopConstraintInPreview = NSLayoutConstraint(item: nameTextField, attribute: .top, relatedBy: .equal, toItem: sellOrLeaseSegmentedControl, attribute: .bottom, multiplier: 1, constant: 15)
        nameTextFieldTopConstraintInPreview.isActive = true
        
        nameTextField.isHidden = false
        priceTextField.isHidden = false
        sizeTextField.isHidden = false
        descriptionTextField.isHidden = false
        
        locationButton.isHidden = false
        locationButtonTopConstraintInStep.isActive = false
        locationButtonTopConstraintInPreview = NSLayoutConstraint(item: locationButton, attribute: .top, relatedBy: .equal, toItem: customBedroomStepper, attribute: .bottom, multiplier: 1, constant: 15)
        locationButtonTopConstraintInPreview.isActive = true
        
        countryTextField.isHidden = false
        cityTextField.isHidden = false
        provinceTextField.isHidden = false
        streetNameTextField.isHidden = false
        streetNumberTextField.isHidden = false
        zipcodeTextField.isHidden = false
        
        customBedroomStepper.isHidden = false
        bedroomMinusButton.isHidden = false
        bedroomPlusButton.isHidden = false
        bedroomNumberLabel.isHidden = false
        
        customBathroomStepper.isHidden = false
        bathroomPlusButton.isHidden = false
        bathroomMinusButton.isHidden = false
        bathroomNumberLabel.isHidden = false
        
        mainImageView.isHidden = false
        
        mainImageViewTopConstraintInStep.isActive = false
        mainImageViewTopConstraintInPreview = NSLayoutConstraint(item: mainImageView, attribute: .top, relatedBy: .equal, toItem: zipcodeTextField, attribute: .bottom, multiplier: 1, constant: 20)
        mainImageViewTopConstraintInPreview.isActive = true
        
        photoCollectionView.isHidden = false
    }
    
    func setupSegmentedControls(){
        sellOrLeaseSegmentedControl = UISegmentedControl()
        sellOrLeaseSegmentedControl.insertSegment(withTitle: "Sell", at: 0, animated: false)
        sellOrLeaseSegmentedControl.insertSegment(withTitle: "Rent", at: 1, animated: false)
        sellOrLeaseSegmentedControl.addTarget(self, action: #selector(changedSellOrLeaseSegment), for: .valueChanged)
        sellOrLeaseSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sellOrLeaseSegmentedControl)
    }

    func setupTextFields(){
        
        nameTextField = UITextField()
        nameTextField.delegate = self
        nameTextField.frame = CGRect.zero
        nameTextField.layer.borderWidth = 1
        nameTextField.layer.borderColor = UIColor.gray.cgColor
        nameTextField.layer.cornerRadius = 3
        nameTextField.placeholder = "Name (Only visible to you)"
        nameTextField.textAlignment = .center
        nameTextField.font = UIFont(name: "Avenir-Light", size: 15)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameTextField)
        
        priceTextField = UITextField()
        priceTextField.delegate = self
        priceTextField.frame = CGRect.zero
        priceTextField.keyboardType = .numberPad
        priceTextField.layer.borderWidth = 1
        priceTextField.layer.borderColor = UIColor.gray.cgColor
        priceTextField.layer.cornerRadius = 3
        priceTextField.placeholder = "Price"
        priceTextField.textAlignment = .center
        priceTextField.font = UIFont(name: "Avenir-Light", size: 15)
        priceTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(priceTextField)
        
        sizeTextField = UITextField()
        sizeTextField.delegate = self
        sizeTextField.frame = CGRect.zero
        sizeTextField.keyboardType = .numberPad
        sizeTextField.layer.borderWidth = 1
        sizeTextField.layer.borderColor = UIColor.gray.cgColor
        sizeTextField.layer.cornerRadius = 3
        sizeTextField.placeholder = "Size (SF)"
        sizeTextField.textAlignment = .center
        sizeTextField.font = UIFont(name: "Avenir-Light", size: 15)
        sizeTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sizeTextField)
        
        descriptionTextField = UITextView()
        descriptionTextField.delegate = self
        descriptionTextField.frame = CGRect.zero
        descriptionTextField.layer.borderWidth = 1
        descriptionTextField.layer.borderColor = UIColor.gray.cgColor
        descriptionTextField.layer.cornerRadius = 3
        descriptionTextField.text = "Description"
        descriptionTextField.textColor = UIColor.lightGray
        descriptionTextField.textAlignment = .center
        descriptionTextField.font = UIFont(name: "Avenir-Light", size: 15)
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
        cityTextField.font = UIFont(name: "Avenir-Light", size: 15)
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
        countryTextField.font = UIFont(name: "Avenir-Light", size: 15)
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
        provinceTextField.font = UIFont(name: "Avenir-Light", size: 15)
        provinceTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(provinceTextField)
        
        streetNameTextField = UITextField()
        streetNameTextField.delegate = self
        streetNameTextField.frame = CGRect.zero
        streetNameTextField.layer.borderWidth = 1
        streetNameTextField.layer.borderColor = UIColor.gray.cgColor
        streetNameTextField.layer.cornerRadius = 3
        streetNameTextField.placeholder = "Street Name"
        streetNameTextField.textAlignment = .center
        streetNameTextField.font = UIFont(name: "Avenir-Light", size: 15)
        streetNameTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(streetNameTextField)
        
        streetNumberTextField = UITextField()
        streetNumberTextField.delegate = self
        streetNumberTextField.frame = CGRect.zero
        streetNumberTextField.layer.borderWidth = 1
        streetNumberTextField.layer.borderColor = UIColor.gray.cgColor
        streetNumberTextField.layer.cornerRadius = 3
        streetNumberTextField.placeholder = "Street No."
        streetNumberTextField.textAlignment = .center
        streetNumberTextField.font = UIFont(name: "Avenir-Light", size: 15)
        streetNumberTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(streetNumberTextField)
        
        zipcodeTextField = UITextField()
        zipcodeTextField.delegate = self
        zipcodeTextField.frame = CGRect.zero
        zipcodeTextField.layer.borderWidth = 1
        zipcodeTextField.layer.borderColor = UIColor.gray.cgColor
        zipcodeTextField.layer.cornerRadius = 3
        zipcodeTextField.placeholder = "Zipcode"
        zipcodeTextField.textAlignment = .center
        zipcodeTextField.font = UIFont(name: "Avenir-Light", size: 15)
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
        customBedroomStepper.layer.borderColor = UIColor.gray.cgColor
        customBedroomStepper.layer.borderWidth = 1
        customBedroomStepper.layer.cornerRadius = 3
        customBedroomStepper.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customBedroomStepper)
        
        bedroomMinusButton = UIButton()
        bedroomMinusButton.addTarget(self, action: #selector(reduceCount), for: .touchUpInside)
        bedroomMinusButton.setTitle("-", for: .normal)
        bedroomMinusButton.backgroundColor = UIColor.white
        bedroomMinusButton.setTitleColor(UIColor.blue, for: .normal)
        bedroomMinusButton.setTitleColor(UIColor.gray, for: .disabled)
        bedroomMinusButton.isEnabled = false
        bedroomMinusButton.layer.borderColor = UIColor.blue.cgColor
        bedroomMinusButton.layer.borderWidth = 2
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
        bedroomPlusButton.backgroundColor = UIColor.white
        bedroomPlusButton.setTitleColor(UIColor.blue, for: .normal)
        bedroomPlusButton.layer.borderColor = UIColor.blue.cgColor
        bedroomPlusButton.layer.borderWidth = 2
        bedroomPlusButton.layer.cornerRadius = 3
        bedroomPlusButton.translatesAutoresizingMaskIntoConstraints = false
        customBedroomStepper.addSubview(bedroomPlusButton)
    }

    func setupBathroomStepper(){
        customBathroomStepper = UIView()
        customBathroomStepper.frame = CGRect.zero
        customBathroomStepper.layer.borderColor = UIColor.gray.cgColor
        customBathroomStepper.layer.borderWidth = 1
        customBathroomStepper.layer.cornerRadius = 5
        customBathroomStepper.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customBathroomStepper)
        
        bathroomMinusButton = UIButton()
        bathroomMinusButton.addTarget(self, action: #selector(reduceCount), for: .touchUpInside)
        bathroomMinusButton.backgroundColor = UIColor.white
        bathroomMinusButton.setTitleColor(UIColor.blue, for: .normal)
        bathroomMinusButton.setTitleColor(UIColor.gray, for: .disabled)
        bathroomMinusButton.isEnabled = false
        bathroomMinusButton.layer.cornerRadius = 3
        bathroomMinusButton.layer.borderColor = UIColor.blue.cgColor
        bathroomMinusButton.layer.borderWidth = 2
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
        bathroomPlusButton.backgroundColor = UIColor.white
        bathroomPlusButton.setTitleColor(UIColor.blue, for: .normal)
        bathroomPlusButton.layer.cornerRadius = 3
        bathroomPlusButton.layer.borderColor = UIColor.blue.cgColor
        bathroomPlusButton.layer.borderWidth = 2
        bathroomPlusButton.setTitle("+", for: .normal)
        bathroomPlusButton.translatesAutoresizingMaskIntoConstraints = false
        customBathroomStepper.addSubview(bathroomPlusButton)
    }
    
    func setupLocationButton(){
        locationButton = UIButton()
        locationButton.setTitle("Select on Map", for: .normal)
        locationButton.titleLabel?.font = UIFont(name: "Avenir-Light", size: 15)
        locationButton.setTitleColor(UIColor.blue, for: .normal)
        locationButton.titleLabel?.textAlignment = .left
        locationButton.addTarget(self, action: #selector(pickPlace), for: .touchUpInside)
        locationButton.backgroundColor = UIColor.white
        locationButton.layer.cornerRadius = 4
        locationButton.layer.borderColor = UIColor.blue.cgColor
        locationButton.layer.borderWidth = 1
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(locationButton)
    }
    
    func setupLabels(){
        
        promptLabel = UILabel()
        promptLabel.font = UIFont(name: "Avenir-Light", size: 15)
        promptLabel.textAlignment = .center
        promptLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(promptLabel)
    }
    
    
    func setupCollectionView(){
        
        photosArray = []
        
        mainImageView = UIImageView()
        mainImageView.backgroundColor = UIColor.gray
        mainImageView.contentMode = .scaleAspectFit
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainImageView)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize.init(width: 150, height: 150)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 5.0
        photoCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.addSubview(photoCollectionView)

        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        photoCollectionView.backgroundColor = UIColor.white
        
        photoCollectionView.register(UINib(nibName: "PostPhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "photoCollectionViewCell")
        
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    func setupButtons(){
        
        nextButton = UIButton()
        nextButton.setTitle("Next", for: .normal)
        nextButton.setTitleColor(UIColor.blue, for: .normal)
        nextButton.addTarget(self, action: #selector(nextStep), for: .touchUpInside)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nextButton)
        
        previousButton = UIButton()
        previousButton.setTitle("Previous", for: .normal)
        previousButton.setTitleColor(UIColor.blue, for: .normal)
        previousButton.addTarget(self, action: #selector(previousStep), for: .touchUpInside)
        previousButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(previousButton)
    }
    
    @objc func nextStep(){
        
        stepIndex = stepIndex + 1
        
        switch stepIndex {
        case 0:
            setupFirstStepUI()
        case 1:
            setupSecondStepUI()
        case 2:
            setupThirdStepUI()
        case 3:
            setupFourthStepUI()
        case 4:
            setupPreviewUI()
        default:
            print("Shouldnt run")
        }
    }
    
    @objc func previousStep(){
        
        stepIndex = stepIndex - 1
        
        switch stepIndex {
        case 0:
            setupFirstStepUI()
        case 1:
            setupSecondStepUI()
        case 2:
            setupThirdStepUI()
        case 3:
            setupFourthStepUI()
        case 4:
            setupPreviewUI()
        default:
            print("Shouldnt run")
        }
    }
    
    func setupConstraints(){
        
        //promptLabel
        NSLayoutConstraint(item: promptLabel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: (navigationBarHeight + 10)).isActive = true
        NSLayoutConstraint(item: promptLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: promptLabel, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing , multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: promptLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        
        //sellOrRentSegmentControl
        sellOrRentSegmentedControlTopConstraintInStep = NSLayoutConstraint(item: sellOrLeaseSegmentedControl, attribute: .top, relatedBy: .equal, toItem: promptLabel, attribute: .bottom, multiplier: 1, constant: 10)
        
        sellOrRentSegmentedControlTopConstraintInStep.isActive = true
        
        NSLayoutConstraint(item: sellOrLeaseSegmentedControl, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: sellOrLeaseSegmentedControl, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing , multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: sellOrLeaseSegmentedControl, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        
        //nameTextField
        nameTextFieldTopConstraintInPreview = NSLayoutConstraint(item: nameTextField, attribute: .top, relatedBy: .equal, toItem: sellOrLeaseSegmentedControl, attribute: .bottom, multiplier: 1, constant: 15)
        nameTextFieldTopConstraintInStep = NSLayoutConstraint(item: nameTextField, attribute: .top, relatedBy: .equal, toItem: promptLabel, attribute: .bottom, multiplier: 1, constant: 10)
        nameTextFieldTopConstraintInStep.isActive = false
        nameTextFieldTopConstraintInPreview.isActive = true
        NSLayoutConstraint(item: nameTextField, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: nameTextField, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing , multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: nameTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        
        
        
        //priceTextField
        NSLayoutConstraint(item: priceTextField, attribute: .top, relatedBy: .equal, toItem: descriptionTextField, attribute: .bottom , multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: priceTextField, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: priceTextField, attribute: .trailing, relatedBy: .equal, toItem: sizeTextField, attribute: .leading , multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: priceTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        
        //sizeTextField
        NSLayoutConstraint(item: sizeTextField, attribute: .top, relatedBy: .equal, toItem: descriptionTextField, attribute: .bottom , multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: sizeTextField, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing , multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: sizeTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: sizeTextField, attribute: .width, relatedBy: .equal, toItem: priceTextField, attribute: .width, multiplier: 1, constant: 0).isActive = true
        
        
        //bedroomsNumberStepper
        NSLayoutConstraint(item: customBedroomStepper, attribute: .top, relatedBy: .equal, toItem: priceTextField, attribute: .bottom , multiplier: 1, constant: 8).isActive = true
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
        NSLayoutConstraint(item: customBathroomStepper, attribute: .top, relatedBy: .equal, toItem: sizeTextField, attribute: .bottom , multiplier: 1, constant: 8).isActive = true
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
        NSLayoutConstraint(item: descriptionTextField, attribute: .top, relatedBy: .equal, toItem: nameTextField, attribute: .bottom , multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: descriptionTextField, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: descriptionTextField, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing , multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: descriptionTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        
        
        
        //locationButton
        locationButtonTopConstraintInPreview = NSLayoutConstraint(item: locationButton, attribute: .top, relatedBy: .equal, toItem: customBedroomStepper, attribute: .bottom, multiplier: 1, constant: 15)
        
        locationButtonTopConstraintInStep = NSLayoutConstraint(item: locationButton, attribute: .top, relatedBy: .equal, toItem: promptLabel, attribute: .bottom, multiplier: 1, constant: 10)
        
        locationButtonTopConstraintInStep.isActive = false
        locationButtonTopConstraintInPreview.isActive = true
        
        NSLayoutConstraint(item: locationButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: locationButton, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: locationButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        
        //streetNumberTextField
        NSLayoutConstraint(item: streetNumberTextField, attribute: .top, relatedBy: .equal, toItem: locationButton, attribute: .bottom , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: streetNumberTextField, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: streetNumberTextField, attribute: .trailing, relatedBy: .equal, toItem: streetNameTextField, attribute: .leading , multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: streetNumberTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        
        //streetNameTextField
        NSLayoutConstraint(item: streetNameTextField, attribute: .top, relatedBy: .equal, toItem: locationButton, attribute: .bottom , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: streetNameTextField, attribute: .width, relatedBy: .equal, toItem: streetNumberTextField, attribute: .width , multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: streetNameTextField, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing , multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: streetNameTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        
        //cityTextField
        NSLayoutConstraint(item: cityTextField, attribute: .top, relatedBy: .equal, toItem: streetNameTextField, attribute: .bottom , multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: cityTextField, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: cityTextField, attribute: .trailing, relatedBy: .equal, toItem: provinceTextField, attribute: .leading , multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: cityTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        
        //provinceTextField
        NSLayoutConstraint(item: provinceTextField, attribute: .top, relatedBy: .equal, toItem: streetNameTextField, attribute: .bottom , multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: provinceTextField, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing , multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: provinceTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: provinceTextField, attribute: .width, relatedBy: .equal, toItem: cityTextField, attribute: .width, multiplier: 1, constant: 0).isActive = true
        
        //countryTextField
        NSLayoutConstraint(item: countryTextField, attribute: .top, relatedBy: .equal, toItem: cityTextField, attribute: .bottom , multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: countryTextField, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: countryTextField, attribute: .trailing, relatedBy: .equal, toItem: zipcodeTextField, attribute: .leading , multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: countryTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        
        //zipCodeTextField
        NSLayoutConstraint(item: zipcodeTextField, attribute: .top, relatedBy: .equal, toItem: cityTextField, attribute: .bottom , multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: zipcodeTextField, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing , multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: zipcodeTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: zipcodeTextField, attribute: .width, relatedBy: .equal, toItem: countryTextField, attribute: .width, multiplier: 1, constant: 0).isActive = true
        
        //mainImageView
        mainImageViewTopConstraintInPreview = NSLayoutConstraint(item: mainImageView, attribute: .top, relatedBy: .equal, toItem: zipcodeTextField, attribute: .bottom, multiplier: 1, constant: 20)
        
        mainImageViewTopConstraintInStep = NSLayoutConstraint(item: mainImageView, attribute: .top, relatedBy: .equal, toItem: promptLabel, attribute: .bottom, multiplier: 1, constant: 10)
        
        mainImageViewTopConstraintInStep.isActive = false
        
        mainImageViewTopConstraintInPreview.isActive = true
        
        NSLayoutConstraint(item: mainImageView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: mainImageView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: mainImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100).isActive = true

        
        //photoCollectionView
        NSLayoutConstraint(item: photoCollectionView, attribute: .top, relatedBy: .equal, toItem: mainImageView, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: photoCollectionView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: photoCollectionView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: photoCollectionView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100).isActive = true
        
        //previousButton
        NSLayoutConstraint(item: previousButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
        NSLayoutConstraint(item: previousButton, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: previousButton, attribute: .width, relatedBy: .equal, toItem: nextButton, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: previousButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -10).isActive = true
        
        //nextButton
        NSLayoutConstraint(item: nextButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
        NSLayoutConstraint(item: nextButton, attribute: .leading, relatedBy: .equal, toItem: previousButton, attribute: .trailing, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: nextButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: nextButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -10).isActive = true
        
        
    }
    
    @objc func changedSellOrLeaseSegment(sender: UISegmentedControl){
        
        if (sender.selectedSegmentIndex == 0){
            priceTextField.placeholder = "Price"
        }
        else if (sender.selectedSegmentIndex == 1){
            priceTextField.placeholder = "Monthly Rent"
        }
    }
    
    @objc func addCount(sender: UIButton){
        if (sender.superview == customBedroomStepper){
            bedroomNumber = bedroomNumber + 1
            bedroomNumberLabel.text = String(bedroomNumber)
            bedroomNumberLabel.textColor = UIColor.black
            bedroomMinusButton.isEnabled = true
        }
        else if (sender.superview == customBathroomStepper){
            bathroomNumber = bathroomNumber + 1
            bathroomNumberLabel.text = String(bathroomNumber)
            bathroomNumberLabel.textColor = UIColor.black
            bathroomMinusButton.isEnabled = true
        }
    }
    
    @objc func reduceCount(sender: UIButton){
        if (sender.superview == customBedroomStepper){
            
            if(bedroomNumber == 1){
                bedroomNumber = 0
                bedroomNumberLabel.text = "Bedroom #"
                bedroomNumberLabel.textColor = UIColor.gray
                bedroomMinusButton.isEnabled = false
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
                bathroomMinusButton.isEnabled = false
            }
            else {
                bathroomNumber = bathroomNumber - 1
                bathroomNumberLabel.text = String(bathroomNumber)
                bathroomNumberLabel.textColor = UIColor.black
            }
        }
    }
    
    @objc func addPhotos(){
        presentImagePickerAlert()
    }
    
    @objc func submitPost(){
        if (validateFields()){
        
            var photoRefs: [String] = []
            
            if sellOrLeaseSegmentedControl.selectedSegmentIndex == 0 {
        
                 let homeSalePost = HomeSale(name: nameTextField.text!, description: descriptionTextField.text!, location: location!, address: streetNumberTextField.text! + " " + streetNameTextField.text!, city: cityTextField.text!, province: provinceTextField.text!, country: countryTextField.text!, zipcode: zipcodeTextField.text!, posterUID: (FirebaseData.sharedInstance.currentUser?.UID)!, photoRefs: [""], size: Int(sizeTextField.text!)!, bedroomNumber: bedroomNumber!, bathroomNumber: bathroomNumber!, UID: nil, price: Int(priceTextField.text!)!, ownerUID: (FirebaseData.sharedInstance.currentUser?.UID)!, availabilityDate: NSNumber(value: Int(NSDate().timeIntervalSince1970)), active: true)
                
                for index in 0..<photosArray.count {
                    let storagePath = "\(homeSalePost.UID!)/\(index)"
                    
                    let photoRefStr = ImageManager.uploadListingImage(image: photosArray[index],
                                                               userEmail: (FirebaseData.sharedInstance.currentUser?.email)!, listingUID: homeSalePost.UID,
                                                               filename: storagePath)
                    photoRefs.append(photoRefStr)
                    
                }
                homeSalePost.photoRefs = photoRefs
                
                WriteFirebaseData.writeHomesForSale(homeForSale: homeSalePost)
                
            }
            else if sellOrLeaseSegmentedControl.selectedSegmentIndex == 1 {
                
                 let homeRentalPost = HomeRental(name: nameTextField.text!, description: descriptionTextField.text!, location: location!, address: streetNumberTextField.text! + " " + streetNameTextField.text!, city: cityTextField.text!, province: provinceTextField.text!, country: countryTextField.text!, zipcode: zipcodeTextField.text!, posterUID: (FirebaseData.sharedInstance.currentUser?.UID)!, photoRefs: [""], size: Int(sizeTextField.text!)!, bedroomNumber: bedroomNumber!, bathroomNumber: bathroomNumber!, UID: nil, monthlyRent: Int(priceTextField.text!)!, rentalTerm: 12, landlordUID: (FirebaseData.sharedInstance.currentUser?.UID)!, availabilityDate: NSNumber(value: Int(NSDate().timeIntervalSince1970)), active: true)
                
                
                for index in 0..<photosArray.count {
                    let storagePath = "\(homeRentalPost.UID!)/\(index)"
                    
                    let photoRefStr = ImageManager.uploadListingImage(image: photosArray[index],
                                                               userEmail: (FirebaseData.sharedInstance.currentUser?.email)!, listingUID: homeRentalPost.UID,
                                                               filename: storagePath)
                    photoRefs.append(photoRefStr)
                    
                }
                homeRentalPost.photoRefs = photoRefs
                
                WriteFirebaseData.writeHomesForRent(homeForRent: homeRentalPost)
            }
            let successAlert = AlertDefault.showAlert(title: "Confirmed", message: "Your listing has been successfully submitted, and can be viewed now")
            
            present(successAlert, animated: true, completion: nil)
        
            self.navigationController?.popViewController(animated: true)
            
        }
    }
    
    func validateFields() -> Bool{
        
        guard (nameTextField.text != "") else {
            present(AlertDefault.showAlert(title: "Whoops", message: "You must add a title"), animated: true, completion: nil)
            return false
        }
        guard (priceTextField.text != "") else {
            present(AlertDefault.showAlert(title: "Whoops", message: "You must add a price"), animated: true, completion: nil)
            return false
        }
        guard (sizeTextField.text != "") else {
            present(AlertDefault.showAlert(title: "Whoops", message: "You must add a size"), animated: true, completion: nil)
            return false
        }
        guard (bedroomNumber > 0) else {
            present(AlertDefault.showAlert(title: "Whoops", message: "Number of bedrooms must be at least 1"), animated: true, completion: nil)
            return false
        }
        guard (bathroomNumber > 0) else {
            present(AlertDefault.showAlert(title: "Whoops", message: "Number of bathrooms must be at least 1"), animated: true, completion: nil)
            return false
        }
        
        guard (descriptionTextField.text != "") else {
            present(AlertDefault.showAlert(title: "Whoops", message: "You must add a description"), animated: true, completion: nil)
            return false
        }
        
        guard (streetNameTextField.text != "") else {
            present(AlertDefault.showAlert(title: "Whoops", message: "You must add a street name"), animated: true, completion: nil)
            return false
        }
        
        guard (streetNumberTextField.text != "") else {
            present(AlertDefault.showAlert(title: "Whoops", message: "You must add a street number"), animated: true, completion: nil)
            return false
        }
        
        guard (cityTextField.text != "") else {
            present(AlertDefault.showAlert(title: "Whoops", message: "You must add a city"), animated: true, completion: nil)
            return false
        }
        guard (provinceTextField.text != "") else {
            present(AlertDefault.showAlert(title: "Whoops", message: "You must add a province"), animated: true, completion: nil)
            return false
        }
        guard (zipcodeTextField.text != "") else {
            present(AlertDefault.showAlert(title: "Whoops", message: "You must add a zipcode"), animated: true, completion: nil)
            return false
        }
        guard (countryTextField.text != "") else {
            present(AlertDefault.showAlert(title: "Whoops", message: "You must add a zipcode"), animated: true, completion: nil)
            return false
        }
        guard (photosArray.count > 0) else {
            present(AlertDefault.showAlert(title: "Whoops", message: "You must add at least one photo"), animated: true, completion: nil)
            return false
        }
        
        return true        
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
        return photosArray.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCollectionViewCell", for: indexPath) as! PostPhotoCollectionViewCell
        
        cell.cellImageView.layer.borderColor = UIProperties.sharedUIProperties.primaryBlackColor.cgColor
        cell.cellImageView.layer.borderWidth = 1
        
        if(indexPath.item == photosArray.count){
            cell.cellImageView.image = #imageLiteral(resourceName: "plusPlaceholder")
            cell.cellImageView.contentMode = .scaleAspectFit
        }
        
        else {
            
            cell.cellImageView.image = photosArray[indexPath.row]
            cell.cellImageView.contentMode = .scaleAspectFill
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let changePhotoAlert = UIAlertController(title: "View or Delete Photo?", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
    
        let viewAction = UIAlertAction(title: "View Photo", style: UIAlertActionStyle.default, handler:{ (action) in
                    
            let imageScrollView = ImageScrollView()
            imageScrollView.display(image: self.photosArray[indexPath.item])
                
            })
            
        let changeAction = UIAlertAction(title: "Delete Photo", style: UIAlertActionStyle.destructive, handler:{ (action) in
            self.photosArray.remove(at: indexPath.item)
            self.photoCollectionView.reloadData()
            })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        changePhotoAlert.addAction(viewAction)
        changePhotoAlert.addAction(changeAction)
        changePhotoAlert.addAction(cancelAction)
        
        if(indexPath.item == photosArray.count){
            presentImagePickerAlert()
        }
        
        else {
            self.present(changePhotoAlert, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
            return CGSize(width: 100, height: 100)
    }
    
    //placePicker methods
    @objc func pickPlace() {
        let config = GMSPlacePickerConfig(viewport: nil)
        let placePicker = GMSPlacePickerViewController(config: config)
        placePicker.delegate = self
        
        present(placePicker, animated: true, completion: nil)
    }
    
    
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        
        location = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        reverseGeocode(location: location)
    
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

                    self.streetNameTextField.text =  pm.thoroughfare!
                    self.streetNumberTextField.text = pm.subThoroughfare!
                    self.cityTextField.text = pm.locality
                    self.provinceTextField.text = pm.administrativeArea
                    self.countryTextField.text = pm.country
                    self.zipcodeTextField.text = pm.postalCode
            
                }
                else if(pm.subThoroughfare != nil) {
                    
                    self.streetNameTextField.text = pm.thoroughfare!
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
        descriptionTextField.resignFirstResponder()
        streetNameTextField.resignFirstResponder()
        streetNumberTextField.resignFirstResponder()
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
