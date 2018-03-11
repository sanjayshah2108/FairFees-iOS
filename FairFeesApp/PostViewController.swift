//
//  PostViewController.swift
//  FairFeesApp
//
//  Created by Sanjay Shah on 2018-03-08.
//  Copyright © 2018 Fair Fees. All rights reserved.
//

import UIKit
import CoreLocation

class PostViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    
    var navigationBarHeight: CGFloat!
    var tabBarHeight: CGFloat!
    
    var submitButton: UIBarButtonItem!

    var nameTextField: UITextField!
    var priceTextField: UITextField!
    var sizeTextField: UITextField!
    var bedroomNumberTextField: UITextField!
    var bathroomNumberTextField: UITextField!
    var descriptionTextField: UITextView!
    
    var addressInstructionLabel: UILabel!
    
    var locationButton: UIButton!
    var addPhotosButton: UIButton!
    var photosArray: [UIImage]!
    var photoCollectionView: UICollectionView!
    
    var countryTextField: UITextField!
    var cityTextField: UITextField!
    var provinceTextField: UITextField!
    var addressTextField: UITextField!
    var zipcodeTextField: UITextField!
    
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
        tabBarHeight = self.tabBarController?.tabBar.frame.height
        
        setupTextFields()
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
        
        bedroomNumberTextField = UITextField()
        bedroomNumberTextField.delegate = self
        bedroomNumberTextField.frame = CGRect.zero
        bedroomNumberTextField.layer.borderWidth = 1
        bedroomNumberTextField.layer.borderColor = UIColor.gray.cgColor
        bedroomNumberTextField.layer.cornerRadius = 3
        bedroomNumberTextField.placeholder = "No. of Bedrooms"
        bedroomNumberTextField.textAlignment = .center
        bedroomNumberTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bedroomNumberTextField)
        
        bathroomNumberTextField = UITextField()
        bathroomNumberTextField.delegate = self
        bathroomNumberTextField.frame = CGRect.zero
        bathroomNumberTextField.layer.borderWidth = 1
        bathroomNumberTextField.layer.borderColor = UIColor.gray.cgColor
        bathroomNumberTextField.layer.cornerRadius = 3
        bathroomNumberTextField.placeholder = "No. of Bathrooms"
        bathroomNumberTextField.textAlignment = .center
        bathroomNumberTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bathroomNumberTextField)
        
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
        addPhotosButton.backgroundColor = UIProperties.sharedUIProperties.primaryGrayColor
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
        NSLayoutConstraint(item: locationButton, attribute: .top, relatedBy: .equal, toItem: descriptionTextField, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
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
        NSLayoutConstraint(item: photoCollectionView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -(tabBarHeight+10)).isActive = true
        
    }
    
    @objc func showMapForSelectingLocation(){

        let postMapViewController = PostMapViewController()
        self.navigationController?.pushViewController(postMapViewController, animated: true)
    }
    
    @objc func addPhotos(){
        presentImagePickerAlert()
    }
    
    @objc func submitPost(){
        
        //let post = HomeSale(name: nameTextField.text!, description: descriptionTextField.text!, location: location, address: addressTextField.text!, poster: nil, photos: [], size: sizeTextField.text!, bedroomNumber: bedroomNumberTextField.text!, bathroomNumber: bathroomNumberTextField.text!, UID: nil, price: priceTextField.text!, owner: nil, availabilityDate: nil)
        
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
        bedroomNumberTextField.resignFirstResponder()
        bathroomNumberTextField.resignFirstResponder()
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
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
}
