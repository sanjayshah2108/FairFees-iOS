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

    override func viewDidLoad() {
        
        
        homeSaleToEdit = listingToEdit as! HomeSale
        super.viewDidLoad()
        self.title = homeSaleToEdit.name
       

        // Do any additional setup after loading the view.
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
        priceTextField.text = String((homeSaleToEdit.price)!)
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
        sizeTextField.text = String((homeSaleToEdit.size)!)
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
        descriptionTextField.text = homeSaleToEdit.listingDescription
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
        cityTextField.text = homeSaleToEdit.city
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
        countryTextField.text = homeSaleToEdit.country
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
        provinceTextField.text = homeSaleToEdit.province
        provinceTextField.textAlignment = .center
        provinceTextField.font = UIFont(name: "Avenir-Light", size: 15)
        provinceTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(provinceTextField)
        
        addressTextField = UITextField()
        addressTextField.delegate = self
        addressTextField.frame = CGRect.zero
        addressTextField.layer.borderWidth = 1
        addressTextField.layer.borderColor = UIColor.gray.cgColor
        addressTextField.layer.cornerRadius = 3
        addressTextField.text = homeSaleToEdit.address
        addressTextField.textAlignment = .center
        addressTextField.font = UIFont(name: "Avenir-Light", size: 15)
        addressTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addressTextField)
        
        zipcodeTextField = UITextField()
        zipcodeTextField.delegate = self
        zipcodeTextField.frame = CGRect.zero
        zipcodeTextField.layer.borderWidth = 1
        zipcodeTextField.layer.borderColor = UIColor.gray.cgColor
        zipcodeTextField.layer.cornerRadius = 3
        zipcodeTextField.text = homeSaleToEdit.zipcode
        zipcodeTextField.textAlignment = .center
        zipcodeTextField.font = UIFont(name: "Avenir-Light", size: 15)
        zipcodeTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(zipcodeTextField)
        
        bedroomNumberLabel.text = String((homeSaleToEdit.bedroomNumber)!)
        bedroomNumberLabel.textColor = UIColor.black
        bathroomNumberLabel.text = String((homeSaleToEdit.bathroomNumber)!)
        bathroomNumberLabel.textColor = UIColor.black
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let storageRef = Storage.storage().reference()
        
        //photoCollectionView.register(UINib(nibName: "PostPhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "photoCollectionViewCell")
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCollectionViewCell", for: indexPath) as! PostPhotoCollectionViewCell
        
        cell.cellImageView.sd_setImage(with: storageRef.child(listingToEdit.photoRefs[indexPath.item]), placeholderImage: nil)
        cell.cellImageView.contentMode = .scaleAspectFill
        
        return cell
        
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return listingToEdit.photoRefs.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let changePhotoAlert = UIAlertController(title: "View or Delete Photo?", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        
        let viewAction = UIAlertAction(title: "View Photo", style: UIAlertActionStyle.default, handler:{ (action) in
            
            let tempImageView = UIImageView()
            tempImageView.sd_setImage(with: Storage.storage().reference().child(self.listingToEdit.photoRefs[indexPath.item]), placeholderImage: nil)
            
            let imageScrollView = ImageScrollView()
            imageScrollView.display(image: tempImageView.image!)
            
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


}
