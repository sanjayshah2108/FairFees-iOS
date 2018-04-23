//
//  ShareListing.swift
//  FairFeesApp
//
//  Created by Sanjay Shah on 2018-04-20.
//  Copyright © 2018 Fair Fees. All rights reserved.
//

import UIKit

class ShareListing: NSObject {
    
    var urlToParse: URL!
    
    func updateDataBeforeParsing(url: URL){
        
        urlToParse = url
        
        NotificationCenter.default.addObserver(self, selector: #selector(parseURLAndDisplayListing), name: NSNotification.Name(rawValue: "rentalHomesDownloadCompleteNotificationKey"), object: nil)
        
        ReadFirebaseData.readHomesForSale()
        ReadFirebaseData.readHomesForRent()
        
        //parseURLAndDisplayListing()
    }
    
    @objc func parseURLAndDisplayListing(){
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "rentalHomesDownloadCompleteNotificationKey"), object: nil)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let navController = appDelegate.window?.rootViewController as! UINavigationController
        navController.popToRootViewController(animated: false)
        
        var currentVC: UIViewController
        currentVC = navController.viewControllers[0] as! HomeViewController
        
        //dismiss any presentedViewControllers
        if (currentVC.presentedViewController != nil){
            currentVC.presentedViewController?.dismiss(animated: true, completion: nil)
        }
    
        let fullQuery = String("\(urlToParse.query!)")
        
        //find listing
        let listingStartIndex = fullQuery.index(fullQuery.startIndex, offsetBy: 11)
        let listingEndIndex = fullQuery.index(fullQuery.startIndex, offsetBy: 47)
        let listingRange = listingStartIndex..<listingEndIndex
        
        let substringListingUID = fullQuery[listingRange]
        print(substringListingUID)
        
        let listingUID: String! = String(substringListingUID)
        var listing: Listing
        

        if(FirebaseData.sharedInstance.homesForRent.filter{ $0.UID == listingUID}.first != nil){
            listing = FirebaseData.sharedInstance.homesForRent.filter{ $0.UID == listingUID}.first!
        }
       
        else {
            listing = FirebaseData.sharedInstance.homesForSale.filter{ $0.UID == listingUID}.first!
        }
        
        let listingDetailVC = ListingDetailViewController()
        listingDetailVC.currentListing = listing
        
        navController.pushViewController(listingDetailVC, animated: false)
    }
}
