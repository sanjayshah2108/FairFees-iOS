//
//  EditPostViewController.swift
//  FairFeesApp
//
//  Created by Sanjay Shah on 2018-03-21.
//  Copyright © 2018 Fair Fees. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorageUI
import FirebaseStorage

class EditPostViewController: PostViewController {
    
    weak var listingToEdit: Listing!
    weak var homeSaleToEdit: HomeSale!
    weak var homeRentalToEdit: HomeRental!

    override func viewDidLoad() {
        
        //set the type of listing
        if(listingToEdit.isKind(of: HomeRental.self)){
            homeRentalToEdit = listingToEdit as! HomeRental
            listingToEdit = homeRentalToEdit
        }
        else if (listingToEdit.isKind(of: HomeSale.self)){
            homeSaleToEdit = listingToEdit as! HomeSale
            listingToEdit = homeSaleToEdit
        }
        
        super.viewDidLoad()
        self.title = listingToEdit.name
        location = listingToEdit.location
        
        setupSellOrLeaseSegmentControl()

        setupPreviewUI()
    }
    
    override func setupTextFields() {
        
        nameTextField = UITextField()
        nameTextField.delegate = self
        nameTextField.frame = CGRect.zero
        nameTextField.layer.borderWidth = 1
        nameTextField.layer.borderColor = UIColor.gray.cgColor
        nameTextField.layer.cornerRadius = 3
        nameTextField.text = listingToEdit.name
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
        if(listingToEdit.isKind(of: HomeRental.self)){
            priceTextField.text = String((homeRentalToEdit.monthlyRent)!)
        }
        else if (listingToEdit.isKind(of: HomeSale.self)){
            priceTextField.text = String((homeSaleToEdit.price)!)
        }
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
        if(listingToEdit.isKind(of: HomeRental.self)){
            sizeTextField.text = String((homeRentalToEdit.size)!)
        }
        else if (listingToEdit.isKind(of: HomeSale.self)){
            sizeTextField.text = String((homeSaleToEdit.size)!)
        }
        
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
        if (listingToEdit.listingDescription == ""){
            descriptionTextField.text = "Description"
            descriptionTextField.textColor = UIColor.lightGray
        }
        else {
        descriptionTextField.text = listingToEdit.listingDescription
        descriptionTextField.textColor = UIColor.black
        }
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
        cityTextField.text = listingToEdit.city
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
        countryTextField.text = listingToEdit.country
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
        provinceTextField.text = listingToEdit.province
        provinceTextField.textAlignment = .center
        provinceTextField.font = UIFont(name: "Avenir-Light", size: 15)
        provinceTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(provinceTextField)
        
        streetNumberTextField = UITextField()
        streetNumberTextField.delegate = self
        streetNumberTextField.frame = CGRect.zero
        streetNumberTextField.layer.borderWidth = 1
        streetNumberTextField.layer.borderColor = UIColor.gray.cgColor
        streetNumberTextField.layer.cornerRadius = 3
        streetNumberTextField.text = listingToEdit.address
        streetNumberTextField.textAlignment = .center
        streetNumberTextField.font = UIFont(name: "Avenir-Light", size: 15)
        streetNumberTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(streetNumberTextField)
        
        streetNameTextField = UITextField()
        streetNameTextField.delegate = self
        streetNameTextField.frame = CGRect.zero
        streetNameTextField.layer.borderWidth = 1
        streetNameTextField.layer.borderColor = UIColor.gray.cgColor
        streetNameTextField.layer.cornerRadius = 3
        streetNameTextField.text = listingToEdit.address
        streetNameTextField.textAlignment = .center
        streetNameTextField.font = UIFont(name: "Avenir-Light", size: 15)
        streetNameTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(streetNameTextField)
        
        zipcodeTextField = UITextField()
        zipcodeTextField.delegate = self
        zipcodeTextField.frame = CGRect.zero
        zipcodeTextField.layer.borderWidth = 1
        zipcodeTextField.layer.borderColor = UIColor.gray.cgColor
        zipcodeTextField.layer.cornerRadius = 3
        zipcodeTextField.text = listingToEdit.zipcode
        zipcodeTextField.textAlignment = .center
        zipcodeTextField.font = UIFont(name: "Avenir-Light", size: 15)
        zipcodeTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(zipcodeTextField)
        
        if(listingToEdit.isKind(of: HomeRental.self)){
            bedroomNumberLabel.text = String((homeRentalToEdit.bedroomNumber)!)
            bedroomNumber = homeRentalToEdit.bedroomNumber
            bathroomNumberLabel.text = String((homeRentalToEdit.bathroomNumber)!)
            bathroomNumber = homeRentalToEdit.bathroomNumber
        }
        else if (listingToEdit.isKind(of: HomeSale.self)){
            bedroomNumberLabel.text = String((homeSaleToEdit.bedroomNumber)!)
            bedroomNumber = homeSaleToEdit.bedroomNumber
            bathroomNumberLabel.text = String((homeSaleToEdit.bathroomNumber)!)
            bathroomNumber = homeSaleToEdit.bathroomNumber
        }
        
        bedroomNumberLabel.textColor = UIColor.black
        bathroomNumberLabel.textColor = UIColor.black
    }
    
    func setupSellOrLeaseSegmentControl(){
        if(listingToEdit.isKind(of: HomeRental.self)){
            sellOrLeaseSegmentedControl.selectedSegmentIndex = 1
        }
        else if (listingToEdit.isKind(of: HomeSale.self)){
            sellOrLeaseSegmentedControl.selectedSegmentIndex = 0
        }
        sellOrLeaseSegmentedControl.isEnabled = false
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func validateFields() -> Bool{
        
        guard (nameTextField.text != "") else {
            let alert = UIAlertController(title: "Whoops", message: "You must add a title", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
            return false
        }
        guard (priceTextField.text != "") else {
            let alert = UIAlertController(title: "Whoops", message: "You must add a price", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
            return false
        }
        guard (sizeTextField.text != "") else {
            let alert = UIAlertController(title: "Whoops", message: "You must add a size", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
            return false
        }
        guard (bedroomNumber > 0) else {
            let alert = UIAlertController(title: "Whoops", message: "Number of bedrooms must be at least 1", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
            return false
        }
        guard (bathroomNumber > 0) else {
            let alert = UIAlertController(title: "Whoops", message: "Number of bathrooms must be at least 1", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
            return false
        }
        
        guard (descriptionTextField.text != "") else {
            let alert = UIAlertController(title: "Whoops", message: "You must add a description", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
            return false
        }
        
        guard (streetNameTextField.text != "") else {
            let alert = UIAlertController(title: "Whoops", message: "You must add a street name", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
            return false
        }
        
        guard (streetNumberTextField.text != "") else {
            let alert = UIAlertController(title: "Whoops", message: "You must add a street number", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
            return false
        }
        guard (cityTextField.text != "") else {
            let alert = UIAlertController(title: "Whoops", message: "You must add a city", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
            return false
        }
        guard (provinceTextField.text != "") else {
            let alert = UIAlertController(title: "Whoops", message: "You must add a province", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
            return false
        }
        guard (zipcodeTextField.text != "") else {
            let alert = UIAlertController(title: "Whoops", message: "You must add a zipcode", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
            return false
        }
        guard (countryTextField.text != "") else {
            let alert = UIAlertController(title: "Whoops", message: "You must add a country", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
            return false
        }
        guard ((photosArray.count + listingToEdit.photoRefs.count) > 0) else {
            let alert = UIAlertController(title: "Whoops", message: "You must add a photo", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
            return false
        }
        
        return true
    }
    
    @objc override func submitPost(){
        if (validateFields()){
            
            var photoRefs: [String] = []
            
            if sellOrLeaseSegmentedControl.selectedSegmentIndex == 0 {
                
                let homeSalePost = HomeSale(name: nameTextField.text!, description: descriptionTextField.text!, location: location!, address: streetNumberTextField.text! + " " + streetNameTextField.text!, city: cityTextField.text!, province: provinceTextField.text!, country: countryTextField.text!, zipcode: zipcodeTextField.text!, posterUID: (FirebaseData.sharedInstance.currentUser?.UID)!, photoRefs: [""], size: Int(sizeTextField.text!)!, bedroomNumber: bedroomNumber!, bathroomNumber: bathroomNumber!, UID: homeSaleToEdit.UID, price: Int(priceTextField.text!)!, ownerUID: (FirebaseData.sharedInstance.currentUser?.UID)!, availabilityDate: NSNumber(value: Int(NSDate().timeIntervalSince1970)), active: true)
                
                for index in 0..<photosArray.count {
                    let storagePath = "\(homeSalePost.UID!)/\(index)"
                    
                    let photoRefStr = ImageManager.uploadImage(image: photosArray[index],
                                                               userUID: (FirebaseData.sharedInstance.currentUser?.email)!, listingUID: homeSalePost.UID,
                                                               filename: storagePath)
                    photoRefs.append(photoRefStr)
                    
                }
                homeSaleToEdit.photoRefs.append(contentsOf: photoRefs)
                homeSalePost.photoRefs = homeSaleToEdit.photoRefs
                
                WriteFirebaseData.writeHomesForSale(homeForSale: homeSalePost)
                
            }
            else if sellOrLeaseSegmentedControl.selectedSegmentIndex == 1 {
                
                let homeRentalPost = HomeRental(name: nameTextField.text!, description: descriptionTextField.text!, location: location!, address: streetNumberTextField.text! + " " + streetNameTextField.text!, city: cityTextField.text!, province: provinceTextField.text!, country: countryTextField.text!, zipcode: zipcodeTextField.text!, posterUID: (FirebaseData.sharedInstance.currentUser?.UID)!, photoRefs: [""], size: Int(sizeTextField.text!)!, bedroomNumber: bedroomNumber!, bathroomNumber: bathroomNumber!, UID: homeRentalToEdit.UID, monthlyRent: Int(priceTextField.text!)!, rentalTerm: 12, landlordUID: (FirebaseData.sharedInstance.currentUser?.UID)!, availabilityDate: NSNumber(value: Int(NSDate().timeIntervalSince1970)), active: true)
                
                
                for index in 0..<photosArray.count {
                    let storagePath = "\(homeRentalPost.UID!)/\(index)"
                    
                    let photoRefStr = ImageManager.uploadImage(image: photosArray[index],
                                                               userUID: (FirebaseData.sharedInstance.currentUser?.email)!, listingUID: homeRentalPost.UID,
                                                               filename: storagePath)
                    photoRefs.append(photoRefStr)
                    
                }
                homeRentalToEdit.photoRefs.append(contentsOf: photoRefs)
                homeRentalPost.photoRefs = homeRentalToEdit.photoRefs
                
                WriteFirebaseData.writeHomesForRent(homeForRent: homeRentalPost)
            }
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let storageRef = Storage.storage().reference()
  
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCollectionViewCell", for: indexPath) as! PostPhotoCollectionViewCell
        
        if(indexPath.item < self.listingToEdit.photoRefs.count){
            cell.cellImageView.sd_setImage(with: storageRef.child(listingToEdit.photoRefs[indexPath.item]), placeholderImage: nil)
        }
        else { cell.cellImageView.image = self.photosArray[indexPath.item - self.listingToEdit.photoRefs.count]}
        
        cell.cellImageView.contentMode = .scaleAspectFill
        
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return listingToEdit.photoRefs.count + super.photosArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let changePhotoAlert = UIAlertController(title: "View or Delete Photo?", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        
        let viewAction = UIAlertAction(title: "View Photo", style: UIAlertActionStyle.default, handler:{ (action) in
            
            let tempImageView = UIImageView()
            if(indexPath.item < self.listingToEdit.photoRefs.count){
                tempImageView.sd_setImage(with: Storage.storage().reference().child(self.listingToEdit.photoRefs[indexPath.item]), placeholderImage: nil)
                
            }
            else { tempImageView.image = self.photosArray[indexPath.item - self.listingToEdit.photoRefs.count]}
            
            let imageScrollView = ImageScrollView()
            imageScrollView.display(image: tempImageView.image!)
            
        })
        
        let changeAction = UIAlertAction(title: "Delete Photo", style: UIAlertActionStyle.destructive, handler:{ (action) in
            
            if(indexPath.item < self.listingToEdit.photoRefs.count){
                self.listingToEdit.photoRefs.remove(at: indexPath.item)
            }
            else { self.photosArray.remove(at: indexPath.item - self.listingToEdit.photoRefs.count)}
            self.photoCollectionView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        changePhotoAlert.addAction(viewAction)
        changePhotoAlert.addAction(changeAction)
        changePhotoAlert.addAction(cancelAction)
        
        self.present(changePhotoAlert, animated: true, completion: nil)
    }
}
