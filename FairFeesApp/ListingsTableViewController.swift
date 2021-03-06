//
//  ListingsTableViewController.swift
//  FairFeesApp
//
//  Created by Sanjay Shah on 2018-04-11.
//  Copyright © 2018 Fair Fees. All rights reserved.
//

import UIKit
import Firebase

class ListingsTableViewController: UITableViewController {
    
    var currentUser: User!
    var homeSales: [HomeSale]!
    var homeRentals: [HomeRental]!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        homeSales = []
        homeRentals = []
        
        for listing in currentUser.listings {
            if (listing is HomeSale){
                homeSales.append(listing as! HomeSale)
            }
            else if (listing is HomeRental){
                homeRentals.append(listing as! HomeRental)
            }
        }
        tableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "homeTableViewCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return homeSales.count
        case 1:
            return homeRentals.count
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
        
        let storageRef = Storage.storage().reference()
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeTableViewCell") as! HomeTableViewCell
        
        if (indexPath.section == 0) {
 
            let homeSale = homeSales[indexPath.row]
            
            cell.bedroomsLabel.text = "\(homeSale.bedroomNumber!) br"
            cell.bathroomsLabel.text = "\(homeSale.bathroomNumber!) ba"
            cell.priceLabel.text = "$\(homeSale.price!)"
            cell.sizeLabel.text = "\(homeSale.size!) SF"
            
            cell.leftImageView.sd_setImage(with: storageRef.child(homeSale.photoRefs[0]), placeholderImage: nil)
            cell.leftImageView.contentMode = .scaleToFill
   
        }
        
        else if (indexPath.section == 1){
            
            let homeRental = homeRentals[indexPath.row]
            
            cell.bedroomsLabel.text = "\(homeRental.bedroomNumber!) br"
            cell.bathroomsLabel.text = "\(homeRental.bathroomNumber!) ba"
            cell.priceLabel.text = "$\(homeRental.monthlyRent!)/month"
            cell.sizeLabel.text = "\(homeRental.size!) SF"
            
            cell.leftImageView.sd_setImage(with: storageRef.child(homeRental.photoRefs[0]), placeholderImage: nil)
            cell.leftImageView.contentMode = .scaleToFill
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let listingDetailViewController = ListingDetailViewController()
        
        switch indexPath.section {
        case 0:
            listingDetailViewController.currentListing = homeSales[indexPath.row]
        case 1:
            listingDetailViewController.currentListing = homeRentals[indexPath.row]
        default:
            listingDetailViewController.currentListing = nil
        }
        
        self.navigationController?.pushViewController(listingDetailViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

}
