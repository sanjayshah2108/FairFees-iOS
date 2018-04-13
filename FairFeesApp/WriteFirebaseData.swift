//
//  WriteFirebaseData.swift
//  FairFeesApp
//
//  Created by Sanjay Shah on 2018-03-20.
//  Copyright © 2018 Fair Fees. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseDatabase

class WriteFirebaseData: NSObject {

    class func write(user:User) {
        let userEmail = user.email
        
        let firstCharOfUserEmail = String(userEmail[userEmail.index(userEmail.startIndex, offsetBy: 0)])
        let SecondCharOfUserEmail = String(userEmail[userEmail.index(userEmail.startIndex, offsetBy: 1)])
        let ThirdCharOfUserEmail = String(userEmail[userEmail.index(userEmail.startIndex, offsetBy: 2)])
        FirebaseData.sharedInstance.usersNode.child(firstCharOfUserEmail).child(SecondCharOfUserEmail).child(ThirdCharOfUserEmail).child(user.UID).setValue(user.toDictionary())
    }
    
    class func writeListings(listing: Listing){
        if (listing.isKind(of: HomeSale.self)){
            let homeSaleToWrite = listing as! HomeSale
            writeHomesForSale(homeForSale: homeSaleToWrite)
        }
        
        else if(listing.isKind(of: HomeRental.self)){
            let homeRentalToWrite = listing as! HomeRental
            writeHomesForRent(homeForRent: homeRentalToWrite)
        }
    }
    
    class func writeHomesForSale(homeForSale:HomeSale) {
        
        let user = FirebaseData.sharedInstance.currentUser!
        
        let listingPath = "/forSale/homesForSale/\(homeForSale.country!)/\(homeForSale.province!)/\(homeForSale.city!)/\(homeForSale.zipcode!)/\(user.UID!)/\(homeForSale.UID!)"
      
        //            if sharedInstance.currentUser!.listings.first == "" {
        //                sharedInstance.currentUser!.listings.remove(at: 0)
        //            }
        
        //if we are editing a post, we dont want to add another listingRef to the user
        if !(FirebaseData.sharedInstance.currentUser!.listingsRefs.contains(listingPath)){
            FirebaseData.sharedInstance.currentUser!.listingsRefs.append(listingPath)
        }
        
        FirebaseData.sharedInstance.listingsNode.child(listingPath).setValue(homeForSale.toDictionary())
        
        write(user: FirebaseData.sharedInstance.currentUser!)
    }
    
    class func writeHomesForRent(homeForRent: HomeRental){
        
        let user = FirebaseData.sharedInstance.currentUser!
        
        let listingPath = "/forRent/homesForRent/\(homeForRent.country!)/\(homeForRent.province!)/\(homeForRent.city!)/\(homeForRent.zipcode!)/\(user.UID!)/\(homeForRent.UID!)"
        
        
        //            if sharedInstance.currentUser!.listings.first == "" {
        //                sharedInstance.currentUser!.listings.remove(at: 0)
        //            }
        
        //if we are editing a post, we dont want to add another listingRef to the user
        if !(FirebaseData.sharedInstance.currentUser!.listingsRefs.contains(listingPath)){
            FirebaseData.sharedInstance.currentUser!.listingsRefs.append(listingPath)
        }
        
        FirebaseData.sharedInstance.listingsNode.child(listingPath).setValue(homeForRent.toDictionary())
        
        write(user: FirebaseData.sharedInstance.currentUser!)
    }
    
}
