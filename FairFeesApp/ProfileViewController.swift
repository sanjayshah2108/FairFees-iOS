//
//  ProfileViewController.swift
//  FairFeesApp
//
//  Created by Sanjay Shah on 2018-03-22.
//  Copyright © 2018 Fair Fees. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var nameLabel: UILabel!
    var emailLabel: UILabel!
   

    var listingsTableView: UITableView!
    var myHomeSales: [HomeSale]!
    var myHomeRentals: [HomeRental]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Profile"
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
        
        setupProfileLabels()
     
        setupListingsTableView()
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
    func setupProfileLabels(){
        
        nameLabel = UILabel()
        nameLabel.text = FirebaseData.sharedInstance.currentUser?.firstName
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        emailLabel = UILabel()
        emailLabel.text = FirebaseData.sharedInstance.currentUser?.email
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emailLabel)
    }

    func setupListingsTableView(){
        
        listingsTableView = UITableView()
        listingsTableView.delegate = self
        listingsTableView.dataSource = self
        listingsTableView.layer.borderColor = UIColor.black.cgColor
        listingsTableView.layer.borderWidth = 3
        listingsTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(listingsTableView)
        
        listingsTableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "homeTableViewCell")
    }
    
    func setupConstraints(){
        //nameLabel
        NSLayoutConstraint(item: nameLabel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 100).isActive = true
        NSLayoutConstraint(item: nameLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        //emailLabel
        NSLayoutConstraint(item: emailLabel, attribute: .top, relatedBy: .equal, toItem: nameLabel, attribute: .bottom, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: emailLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        //tableView
        NSLayoutConstraint(item: listingsTableView, attribute: .top, relatedBy: .equal, toItem: emailLabel, attribute: .bottom, multiplier: 1, constant: 100).isActive = true
        NSLayoutConstraint(item: listingsTableView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: listingsTableView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: listingsTableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section
        {
        case 0:
            return myHomeSales.count
           // return (FirebaseData.sharedInstance.currentUser?.listings.filter { $0 is HomeSale }.count)!
        case 1:
            return myHomeRentals.count
            //return (FirebaseData.sharedInstance.currentUser?.listings.filter { $0 is HomeRental }.count)!
        default:
            return 0
        }
        
        //return (FirebaseData.sharedInstance.currentUser?.listings.count)!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        switch section
        {
        case 0:
            return "For Sale"
        case 1:
            return "For Rent"
        default:
            return "Other"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Use ProfileListingsTableViewCell if we need a different format
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeTableViewCell") as! HomeTableViewCell
        
        if(indexPath.section == 0){
            
            let homeSale = myHomeSales[indexPath.row]
            
            cell.bedroomsLabel.text = String(homeSale.bedroomNumber)
            cell.bathroomsLabel.text = String(homeSale.bathroomNumber)
            cell.priceLabel.text = String(homeSale.price)
            cell.nameLabel.text = homeSale.name
            cell.addressLabel.text = homeSale.address
            cell.sizeLabel.text = String((homeSale.size)!)
            cell.leftImageView.sd_setImage(with: Storage.storage().reference().child((homeSale.photoRefs[0])))
        }
        if(indexPath.section == 1){
            let homeRental = myHomeRentals[indexPath.row]
            
            cell.bedroomsLabel.text = String(homeRental.bedroomNumber)
            cell.bathroomsLabel.text = String(homeRental.bathroomNumber)
            cell.priceLabel.text = String(homeRental.monthlyRent)
            cell.nameLabel.text = homeRental.name
            cell.addressLabel.text = homeRental.address
            cell.sizeLabel.text = String((homeRental.size)!)
            cell.leftImageView.sd_setImage(with: Storage.storage().reference().child((homeRental.photoRefs[0])))
        }
        
    
        cell.leftImageView.contentMode = .scaleAspectFill
        cell.leftImageView.clipsToBounds = true
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editPostViewController = EditPostViewController()
        editPostViewController.listingToEdit = FirebaseData.sharedInstance.currentUser?.listings[indexPath.row]
        
        self.navigationController?.pushViewController(editPostViewController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete){
            var listingToEdit: Listing? = nil
            if(indexPath.section == 0){
                listingToEdit = myHomeSales[indexPath.row]
            }
            else if(indexPath.section == 1){
                listingToEdit = myHomeRentals[indexPath.row]
            }
            
           deleteListing(listing: listingToEdit!, indexPath: indexPath)
        }
        
        
    }
    
//    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
//        return "Remove"
//    }
    
    func deleteListing(listing: Listing, indexPath: IndexPath){
        
        var homeSaleToEdit: HomeSale? = nil
        var homeRentalToEdit: HomeRental? = nil
        
        if(indexPath.section == 0){
            homeSaleToEdit = listing as? HomeSale
        }
        else if(indexPath.section == 1){
             homeRentalToEdit = listing as? HomeRental
        }
        
        let deleteOrDeactivateAlert = UIAlertController(title: "What would you like to do?", message: "You could choose to either deactivate or delete your listing. If you deactivate, you can re-enlist it again. If you delete, you can't reverse that", preferredStyle: .alert)
        
        let deactivateAction = UIAlertAction(title: "Deactivate this listing", style: .default, handler:{ (action) in
            listing.active = false
            
            if(indexPath.section == 0){
                WriteFirebaseData.writeHomesForSale(homeForSale: homeSaleToEdit!)
            }
            else if(indexPath.section == 1){
                WriteFirebaseData.writeHomesForRent(homeForRent: homeRentalToEdit!)
            }
            
            let cell = self.listingsTableView.cellForRow(at: indexPath) as! HomeTableViewCell
            //change this to strikethrough
            cell.priceLabel.text = "Deactive"
        })
        let deleteAction = UIAlertAction(title: "Delete this listing", style: .default, handler: { (action) in
            
            print("Delete")
            self.listingsTableView.reloadData()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        deleteOrDeactivateAlert.addAction(deactivateAction)
        deleteOrDeactivateAlert.addAction(deleteAction)
        deleteOrDeactivateAlert.addAction(cancelAction)
        
        present(deleteOrDeactivateAlert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteButton = UITableViewRowAction(style: .default, title: "Remove") { (action, indexPath) in
           tableView.dataSource?.tableView!(tableView, commit: .delete, forRowAt: indexPath)
            return
        }
        deleteButton.backgroundColor = UIColor.black
        return [deleteButton]
    }
    
    func reActivateListing(listing: Listing, indexPath: IndexPath){
        
    }
}
