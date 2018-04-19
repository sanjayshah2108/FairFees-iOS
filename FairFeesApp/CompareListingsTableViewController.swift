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
        
 
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

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
        
        if (indexPath == chosenRowIndex){
            
            //CHANGE THIS TO new prototype Cell
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
        
        //DirectionsManager
        
        tableView.reloadData()
        tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        
        let parentVC = parent as! CompareListingsViewController
      
        DirectionsManager.theDirectionsManager.mapView = parentVC.mapView
        
        
        //if one or both of the tableViews havent been selected, we need to check, and set the activePolylines
        if (parentVC.leftPolyline != nil) && (parentVC.rightPolyline != nil){
            DirectionsManager.theDirectionsManager.activePolylines = [parentVC.leftPolyline, parentVC.rightPolyline]
        }
            
        else if(parentVC.leftPolyline != nil){
            DirectionsManager.theDirectionsManager.activePolylines = [parentVC.leftPolyline]
        }
        else if (parentVC.rightPolyline != nil){
            DirectionsManager.theDirectionsManager.activePolylines = [parentVC.rightPolyline]
        }
        else {
            DirectionsManager.theDirectionsManager.activePolylines = []
        }
        
        
        //if the left table was clicked on, remove the old leftPolyline
        if (tableViewID == 0){
            
          DirectionsManager.theDirectionsManager.distanceLabel = parentVC.leftDistanceLabel
            
            if (parentVC.leftPolyline != nil) {
                parentVC.leftPolyline.map = nil
               // DirectionsManager.theDirectionsManager.activePolylines.removeAll()


            }
        }
            
        //if the right table was clicked on, remove the old rightPolyline
        else if (tableViewID == 1){
            
            DirectionsManager.theDirectionsManager.distanceLabel = parentVC.rightDistanceLabel
            
            if (parentVC.rightPolyline != nil) {
                parentVC.rightPolyline.map = nil
               // DirectionsManager.theDirectionsManager.activePolylines.removeAll()

            }
        }
        
        DirectionsManager.theDirectionsManager.getPolylineRoute(from: LocationManager.theLocationManager.currentLocation, to: listingsArray[indexPath.row].location)
    
        //addObserver
        NotificationCenter.default.addObserver(self, selector: #selector(addedPolyline), name: NSNotification.Name(rawValue: "polylineAddedKey"), object: nil)
        
      
        
    }
    
    @objc func addedPolyline(){
        
        let parentVC = parent as! CompareListingsViewController
        
        if (tableViewID == 0){
            parentVC.leftPolyline = DirectionsManager.theDirectionsManager.polylineToShow
        }
            
        else if (tableViewID == 1){
            parentVC.rightPolyline = DirectionsManager.theDirectionsManager.polylineToShow
        }
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "polylineAddedKey"), object: nil)

        
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
