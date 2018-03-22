//
//  ReadFirebaseData.swift
//  FairFeesApp
//
//  Created by Sanjay Shah on 2018-03-20.
//  Copyright © 2018 Fair Fees. All rights reserved.
//

import UIKit
import Firebase

class ReadFirebaseData: NSObject {

    static var homesForSaleHandle: UInt? = nil
    
    //read all homesForSale
    class func readHomesForSale() {
        //?? Do we need this
        if ( Auth.auth().currentUser == nil)
        {
            return
        }
        
        let ref = FirebaseData.sharedInstance.homesForSaleNode
        
        let tempHandle = ref.observe(DataEventType.value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary;
            
            //first, clear all
            FirebaseData.sharedInstance.homesForSale.removeAll()
            
            if ( value == nil) {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "noHomesForSaleKey"), object: nil)
                return
            }
            
            let data = value as? [String:Any]
            
            //get individual homesForSale data and append to local data
            readHomeForSale(data: data!, specificUser: false)
            
            let myDownloadCompleteNotificationKey = "myDownloadCompleteNotificationKey"
            NotificationCenter.default.post(name: Notification.Name(rawValue: myDownloadCompleteNotificationKey), object: nil)
        })
        
        if homesForSaleHandle != nil {
            ref.removeObserver(withHandle: homesForSaleHandle!)
        }
        homesForSaleHandle = tempHandle
        
    }
    
    fileprivate class func readHomeForSale(data:[String:Any], specificUser: Bool) {
        
        //appending a specific user's homesForSale to that user's local data.
        if (specificUser){
            let readHomeForSale = HomeSale(with: data)
            FirebaseData.sharedInstance.specificUserListings.append(readHomeForSale!)
        }
        
        //appending all homesForSale to local data
        else {
            
            //refer to Firebase Data structure to understand these for loops
            for country in data {
                let provinceDict = country.value as! [String:Any]
                for province in provinceDict {
                    let cityDict = province.value as! [String:Any]
                    for city in cityDict {
                        let zipcodeDict = city.value as! [String:Any]
                        for zipcode in zipcodeDict {
                            let usersDict = zipcode.value as! [String:Any]
                            for users in usersDict {
                                let userListingsDict = users.value as! [String: Any]
                                for userListing in userListingsDict {
                                    let homeForSale = userListing.value as! [String: Any]
                                    
                                    let readHomeForSale = HomeSale(with: homeForSale)
                            
                                    if readHomeForSale != nil {
                                        FirebaseData.sharedInstance.homesForSale.append(readHomeForSale!)
                                    }
                                    else {
                                        print("The homeForSale is nil")
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    //read all users
    class func readUsers() {
        
        //do we need this??
        if ( Auth.auth().currentUser == nil) {
            return
        }
        
        //first, clear all.
        FirebaseData.sharedInstance.users.removeAll()
        
        FirebaseData.sharedInstance.usersNode
            .observeSingleEvent(of: .value, with: { (snapshot) in
                
                let value = snapshot.value as? NSDictionary
                
                if ( value == nil) {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "noUsersFoundKey"), object: nil)
                    return
                }
                
                //refer to Firebase data structure to understand these for loops.
                for firstCharInEmail in value! {
                    let firstCharDict = firstCharInEmail.value as! [String:Any]
                    
                    for secondCharInEmail in firstCharDict {
                        let secondCharDict = secondCharInEmail.value as! [String:Any]
                        
                        for thirdCharInEmail in secondCharDict {
                            let thirdCharDict = thirdCharInEmail.value as! [String:Any]
                            
                            self.readUser(data: thirdCharDict)
                        }
                    }
                }
            })
    }
    
    //read an individual user
    class func readUser(data: [String: Any]){
        for any in data {
            
            let user: [String:Any] = any.value as! [String:Any]
            let UID: String = user["UID"] as! String
            let firstName: String = user["firstName"] as! String
            let lastName: String = user["lastName"] as! String
            let email: String = user["email"] as! String
            let phoneNumber: Int = user["phoneNumber"] as! Int
            let rating: Int = user["rating"] as! Int
            
            
            //user["listingRefs"] may have disappeared in the Firebase DB if the user deleted his only listing, so we have to check first.
            var listingRefs: [String]
            
            if (user.keys.contains("listings")){
                listingRefs = (user["listings"] as? [String])!
            }
            else {
                listingRefs = [] as [String]
            }
            
            //since the user data on Firebase only contains the references to the listings, we have to append them  manually to the user's local data.
            var listings: [Listing] = []
            var index = 0
            for listingRef in listingRefs{
                
                //if there's a blank listingRef, don't include it.
                if(listingRef == ""){
                    listingRefs.remove(at: index)
                }
                else {
                    //first, clear the specificUserListings array.
                    FirebaseData.sharedInstance.specificUserListings.removeAll()
                    
                    let ref = FirebaseData.sharedInstance.homesForSaleNode.child(listingRef)
                    ref.observe(DataEventType.value, with: { (snapshot) in
                        let value = snapshot.value as? NSDictionary;
                        
                        if ( value == nil) {
                            print("This homeForSale doesn't exist")
                            return
                        }
                        
                        //append this homeForSale to specificUserListings
                        let data = value as? [String:Any]
                        readHomeForSale(data: data!, specificUser: true)
                        
                        listings = FirebaseData.sharedInstance.specificUserListings
                    })
                    index = index+1
                }
            }
            
            //create the user with all the listings
            let readUser = User(uid: UID, firstName: firstName, lastName: lastName, email: email, phoneNumber: phoneNumber, rating: rating, listings: listings)
            
            FirebaseData.sharedInstance.users.append(readUser)
       
            //set the current user
            if (UID == Auth.auth().currentUser?.uid){
                FirebaseData.sharedInstance.currentUser = readUser
            }
            
        }
        let myUsersDownloadNotificationKey = "myUsersDownloadNotificationKey"
        NotificationCenter.default.post(name: Notification.Name(rawValue: myUsersDownloadNotificationKey), object: nil)
    }
    
    
    //    class func readListings() {
    //        if ( Auth.auth().currentUser == nil)
    //        {
    //            return
    //        }
    //
    //        let ref:DatabaseReference
    //
    //        let tempHandle = ref.observe(DataEventType.value, with: { (snapshot) in
    //            let value = snapshot.value as? NSDictionary;
    //
    //            if ( value == nil) {
    //                NotificationCenter.default.post(name: Notification.Name(rawValue: "noOfferedItemsInCategoryKey"), object: nil)
    //                return
    //            }
    //            sharedInstance.listings.removeAll()
    //
    //            let data = value as? [String:Any]
    //            readListing(data: data!)
    //
    //            let myDownloadCompleteNotificationKey = "myDownloadCompleteNotificationKey"
    //
    //            NotificationCenter.default.post(name: Notification.Name(rawValue: myDownloadCompleteNotificationKey), object: nil)
    //        })
    //
    //        if listingsHandle != nil {
    //            ref.removeObserver(withHandle: listingsHandle!)
    //        }
    //        listingsHandle = tempHandle
    //
    //    }
    //
    //    fileprivate class func readListing(data:[String:Any]) {
    //        for any in data {
    //            let listing: [String:Any] = any.value as! [String:Any]
    //            let readListing =
    //            if readListing != nil {
    //
    //                listings.append(readListing!)
    //                print("appending Listings")
    //            }
    //            else {
    //                print("Nil found in Listings")
    //            }
    //        }
    //    }
    
}
