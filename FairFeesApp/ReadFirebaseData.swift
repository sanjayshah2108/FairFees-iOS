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

    static var listingsHandle:UInt? = nil
    static var homesForSaleHandle: UInt? = nil
    
    class func readHomesForSale() {
        if ( Auth.auth().currentUser == nil)
        {
            return
        }
        
        let ref = FirebaseData.sharedInstance.homesForSaleNode
        
        let tempHandle = ref.observe(DataEventType.value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary;
            
            if ( value == nil) {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "noOfferedItemsInCategoryKey"), object: nil)
                return
            }
            FirebaseData.sharedInstance.listings.removeAll()
            
            let data = value as? [String:Any]
            readHomesForSale(data: data!, specificUser: false)
            
            let myDownloadCompleteNotificationKey = "myDownloadCompleteNotificationKey"
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: myDownloadCompleteNotificationKey), object: nil)
        })
        
        if listingsHandle != nil {
            ref.removeObserver(withHandle: listingsHandle!)
        }
        listingsHandle = tempHandle
        
    }
    
    fileprivate class func readHomesForSale(data:[String:Any], specificUser: Bool) {
        for any in data {
            let homeForSale: [String:Any] = any.value as! [String:Any]
            let readHomeForSale = HomeSale(with: homeForSale)
            
            if readHomeForSale != nil {
                
                if (specificUser){
                    FirebaseData.sharedInstance.specificUserListings.append(readHomeForSale!)
                }
                else {
                    FirebaseData.sharedInstance.homesForSale.append(readHomeForSale!)
                }
                print("appending Homes For Sale")
            }
            else {
                print("Nil found in Homes For Sale")
            }
        }
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
    
    
    
    class func readUsers() {
        if ( Auth.auth().currentUser == nil) {
            return
        }
        
        FirebaseData.sharedInstance.users.removeAll()
        FirebaseData.sharedInstance.usersNode
            .observeSingleEvent(of: .value, with: { (snapshot) in
                
                let value = snapshot.value as? NSDictionary
                
                if ( value == nil) {
                    return
                }
                
                for any in (value?.allValues)! {
                    let user: [String:Any] = any as! [String:Any]
                    let UID: String = user["UID"] as! String
                    let firstName: String = user["firstName"] as! String
                    let lastName: String = user["lastName"] as! String
                    let email: String = user["email"] as! String
                    let phoneNumber: Int = user["phoneNumber"] as! Int
                    let rating: Int = user["rating"] as! Int
                    var listingRefs: [String]
                    var listings: [Listing] = []
                    
                    if (user.keys.contains("listings")){
                        listingRefs = (user["listings"] as? [String])!
                    }
                    else {
                        listingRefs = [] as [String]
                    }
                    
                    var index = 0
                    for i in listingRefs{
                        
                        if(i == ""){
                            listingRefs.remove(at: index)
                        }
                        else {
                            ///ONLY PASS DATA OF SPECIFIC USER
                            //let ref = sharedInstance.homesForSaleNode.child("<#T##pathString: String##String#>")
                            let ref = FirebaseData.sharedInstance.homesForSaleNode
                            let tempHandle = ref.observe(DataEventType.value, with: { (snapshot) in
                                let value = snapshot.value as? NSDictionary;
                                
                                if ( value == nil) {
                                    print("No homes for sale")
                                    return
                                }
                                FirebaseData.sharedInstance.specificUserListings.removeAll()
                                
                                let data = value as? [String:Any]
                                readHomesForSale(data: data!, specificUser: true)
                                
                                let myDownloadCompleteNotificationKey = "myDownloadCompleteNotificationKey"
                                
                                NotificationCenter.default.post(name: Notification.Name(rawValue: myDownloadCompleteNotificationKey), object: nil)
                            })
                            
                            listings = FirebaseData.sharedInstance.specificUserListings
                            index = index+1
                        }
                    }
                    
                    
                    
                    let readUser = User(firstName: firstName, lastName: lastName, email: email, phoneNumber: phoneNumber, rating: rating, listings: listings)
                    
                    
                    
                    FirebaseData.sharedInstance.users.append(readUser)
                    print("appending items")
                    
                    //uncomment when we have a log in
                    //                    if (userUID == Auth.auth().currentUser?.uid){
                    //
                    //                        sharedInstance.currentUser = readUser
                    //
                    //                        storeCurrentUsersItems(userUID: userUID)
                    //                    }
                    
                }
                let myUsersDownloadNotificationKey = "myUsersDownloadNotificationKey"
                NotificationCenter.default.post(name: Notification.Name(rawValue: myUsersDownloadNotificationKey), object: nil)
            })
        
    }
    

    
}
