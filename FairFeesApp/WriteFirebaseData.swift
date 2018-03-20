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
        FirebaseData.sharedInstance.usersNode.child(firstCharOfUserEmail).child(SecondCharOfUserEmail).child(ThirdCharOfUserEmail).setValue(user.toDictionary())
        
    }
    
    class func writeHomesForSale(homeForSale:HomeSale) {
        
        //let user = AppData.sharedInstance.currentUser!
        let user = DummyData.theDummyData.users[0]
        
        let listingPath = "/\(homeForSale.country!)/\(homeForSale.province!)/\(homeForSale.city!)/\(homeForSale.zipcode!)/\(user.firstName)/\(homeForSale.UID!)"
      
        
        //            if sharedInstance.currentUser!.listings.first == "" {
        //                sharedInstance.currentUser!.listings.remove(at: 0)
        //            }
        
        FirebaseData.sharedInstance.currentUser!.listingsRefs.append(listingPath)
        FirebaseData.sharedInstance.homesForSaleNode.child(listingPath).setValue(homeForSale.toDictionary())
        
        let userEmail = user.email
        
        let firstCharOfUserEmail = String(userEmail[userEmail.index(userEmail.startIndex, offsetBy: 0)])
        let SecondCharOfUserEmail = String(userEmail[userEmail.index(userEmail.startIndex, offsetBy: 1)])
        let ThirdCharOfUserEmail = String(userEmail[userEmail.index(userEmail.startIndex, offsetBy: 2)])
        
        FirebaseData.sharedInstance.usersNode.child(firstCharOfUserEmail).child(SecondCharOfUserEmail).child(ThirdCharOfUserEmail).setValue(FirebaseData.sharedInstance.currentUser?.toDictionary())
    }
    
}
