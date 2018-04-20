//
//  CompareListingsTableViewController.swift
//  FairFeesApp
//
//  Created by Sanjay Shah on 2018-04-18.
//  Copyright © 2018 Fair Fees. All rights reserved.
//

import UIKit
import Firebase

class CompareListingsTableViewController: UITableViewController {

    var listingsArray: [Listing]!
    var chosenRowIndex: IndexPath!
    
    //left TableView is 0
    //right TableView is 1
    var tableViewID: Int!
    
    var leftListingImageView: UIImageView!
    var leftListingPriceLabel: UILabel!
    var leftListingSizeLabel: UILabel!
    var leftListingBedroomsLabel: UILabel!
    var leftListingBathroomsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "CompareListingsSmallTableViewCell", bundle: nil), forCellReuseIdentifier: "compareListingsSmallTableViewCell")
        tableView.register(UINib(nibName: "CompareListingsLargeTableViewCell", bundle: nil), forCellReuseIdentifier: "compareListingsLargeTableViewCell")
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listingsArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let storageRef = Storage.storage().reference()
        
        //largeCell
        if (indexPath == chosenRowIndex){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "compareListingsLargeTableViewCell", for: indexPath) as! CompareListingsLargeTableViewCell
            
            let listing = listingsArray[indexPath.row]
            
            if (listing is HomeSale){
                let homeSale = listing as! HomeSale
                cell.priceLabel.text = "$\(homeSale.price!)"
                cell.bedroomsLabel.text = "\(homeSale.bedroomNumber!) br"
                cell.bathroomsLabel.text = "\(homeSale.bathroomNumber!) ba"
            }
            else if (listing is HomeRental){
                let homeRental = listing as! HomeRental
                cell.priceLabel.text = "$\(homeRental.monthlyRent!)/month"
                cell.bedroomsLabel.text = "\(homeRental.bedroomNumber!) br"
                cell.bathroomsLabel.text = "\(homeRental.bathroomNumber!) ba"
            }
            
            cell.sizeLabel.text = String((listing.size)!) + "sqft"
            cell.mainImageView.sd_setImage(with: storageRef.child(listing.photoRefs[0]))
            
            return cell
        }
            
        //smallCells
        else {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "compareListingsSmallTableViewCell", for: indexPath) as! CompareListingsSmallTableViewCell
            
            let listing = listingsArray[indexPath.row]
            
            cell.leftImageView.sd_setImage(with: storageRef.child(listing.photoRefs[0]))
        
            if (listing is HomeSale){
                let homeSale = listing as! HomeSale
                cell.priceLabel.text = "$\(homeSale.price!)"
            }
            else if (listing is HomeRental){
                let homeRental = listing as! HomeRental
                cell.priceLabel.text = "$\(homeRental.monthlyRent!)/month"
            }
    
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath == chosenRowIndex){
            return tableView.frame.height
        }
        else {
            return 50
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        chosenRowIndex = indexPath
        
        tableView.reloadData()
        tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        
        let listing = listingsArray[indexPath.row]
    
        let parentVC = parent as! CompareListingsViewController
        parentVC.addOverlaysToMap(tableViewID: tableViewID , listing: listing)
   
    }

}
