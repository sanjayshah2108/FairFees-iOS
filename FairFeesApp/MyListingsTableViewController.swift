//
//  MyListingsTableViewController.swift
//  FairFeesApp
//
//  Created by Sanjay Shah on 2018-04-09.
//  Copyright © 2018 Fair Fees. All rights reserved.
//

import UIKit
import Firebase

class MyListingsTableViewController: UITableViewController {
    
    var myHomeSales: [HomeSale]!
    var myHomeRentals: [HomeRental]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
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
        
        tableView.layer.borderColor = UIColor.black.cgColor
        tableView.layer.borderWidth = 3
 
        tableView.register(UINib(nibName: "MyListingsTableViewCell", bundle: nil), forCellReuseIdentifier: "myListingsTableViewCell")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section
        {
        case 0:
            return myHomeSales.count
       
        case 1:
            return myHomeRentals.count
        
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myListingsTableViewCell") as! MyListingsTableViewCell
        
        if(indexPath.section == 0){
            
            let homeSale = myHomeSales[indexPath.row]
            
            cell.nameLabel.text = homeSale.name
            cell.addressLabel.text = homeSale.address
            cell.leftImageView.sd_setImage(with: Storage.storage().reference().child((homeSale.photoRefs[0])))
            
            if !(homeSale.active){
                
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: homeSale.name)
                attributeString.addAttribute(.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                cell.nameLabel.attributedText = attributeString
            }
        }
        
        if(indexPath.section == 1){
            
            let homeRental = myHomeRentals[indexPath.row]
            
            cell.nameLabel.text = homeRental.name
            cell.addressLabel.text = homeRental.address
            cell.leftImageView.sd_setImage(with: Storage.storage().reference().child((homeRental.photoRefs[0])))
            
            if !(homeRental.active){
               
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: homeRental.name)
                attributeString.addAttribute(.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                cell.nameLabel.attributedText = attributeString
            }
        }
        
        cell.leftImageView.contentMode = .scaleAspectFill
        cell.leftImageView.clipsToBounds = true
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editPostViewController = EditPostViewController()
        editPostViewController.listingToEdit = FirebaseData.sharedInstance.currentUser?.listings[indexPath.row]
        
        self.navigationController?.pushViewController(editPostViewController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
 
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete){
            
            var listingToEdit: Listing? = nil
            
            if(indexPath.section == 0){
                listingToEdit = myHomeSales[indexPath.row]
            }
            else if(indexPath.section == 1){
                listingToEdit = myHomeRentals[indexPath.row]
            }
    
            deleteListing(listing: listingToEdit!)
        }
        
       
    }
    
    
    func deleteListing(listing: Listing){
        
        let deleteOrDeactivateAlert = UIAlertController(title: "What would you like to do?", message: "You could choose to either deactivate or delete your listing. If you deactivate, you can re-enlist it again. If you delete, you can't reverse that", preferredStyle: .alert)
        
        let deactivateAction = UIAlertAction(title: "Deactivate this listing", style: .default, handler:{ (action) in
            listing.active = false
        
            WriteFirebaseData.writeListings(listing: listing)
            self.tableView.reloadData()
        })
        
        let deleteAction = UIAlertAction(title: "Delete this listing", style: .default, handler: { (action) in
            
            print("Delete")
            self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        deleteOrDeactivateAlert.addAction(deactivateAction)
        deleteOrDeactivateAlert.addAction(deleteAction)
        deleteOrDeactivateAlert.addAction(cancelAction)
        
        present(deleteOrDeactivateAlert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        var editRowAction: UITableViewRowAction? = nil
        
        if(indexPath.section == 0){
            if (myHomeSales[indexPath.row].active){
                editRowAction = UITableViewRowAction(style: .default, title: "Remove", handler:{ (action, indexPath) in
                    tableView.dataSource?.tableView!(tableView, commit: .delete, forRowAt: indexPath)
                    return
                })
                editRowAction?.backgroundColor = UIColor.red
            }
            else {
                editRowAction = UITableViewRowAction(style: .default, title: "Activate", handler:{ (action, indexPath) in
                    self.reActivateListing(listing: self.myHomeSales[indexPath.row], indexPath: indexPath)
                })
                editRowAction?.backgroundColor = UIColor.blue
                
            }
        }
            
        else if(indexPath.section == 1){
            if (myHomeRentals[indexPath.row].active){
                editRowAction = UITableViewRowAction(style: .default, title: "Remove", handler:{ (action, indexPath) in
                    tableView.dataSource?.tableView!(tableView, commit: .delete, forRowAt: indexPath)
                    return
                })
                editRowAction?.backgroundColor = UIColor.red
            }
            else {
                editRowAction = UITableViewRowAction(style: .default, title: "Activate", handler:{ (action, indexPath) in
                    self.reActivateListing(listing: self.myHomeRentals[indexPath.row], indexPath: indexPath)
                })
                editRowAction?.backgroundColor = UIColor.blue
                
            }
        }
        
        return [editRowAction!]
    }
    
    
    func reActivateListing(listing: Listing, indexPath: IndexPath){
        
        present(AlertDefault.showAlert(title: "Re-activated", message: "Your listing has been re-activated. It will stay live for another 30 days"), animated: true, completion: nil)
        
        listing.active = true
        WriteFirebaseData.writeListings(listing: listing)
        
        tableView.reloadData()
    }
}
