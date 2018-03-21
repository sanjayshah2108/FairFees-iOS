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
                NotificationCenter.default.post(name: Notification.Name(rawValue: "noHomesForSaleKey"), object: nil)
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
        
        if (specificUser){
            let readHomeForSale = HomeSale(with: data)
            FirebaseData.sharedInstance.specificUserListings.append(readHomeForSale!)
        }
            
        else {
            
            for country in data {
                print("\(country.key)")
                
                let provinceDict = country.value as! [String:Any]
                
                for province in provinceDict {
                    print("\(province.key)")
                    let cityDict = province.value as! [String:Any]
                    
                    for city in cityDict {
                        print("\(city.key)")
                        let zipcodeDict = city.value as! [String:Any]
                        
                        for zipcode in zipcodeDict {
                            print("\(zipcode.key)")
                            let usersDict = zipcode.value as! [String:Any]
                            
                            for users in usersDict {
                                
                                let userListingsDict = users.value as! [String: Any]
                                
                                for userListing in userListingsDict {
                                
                                    let homeForSale = userListing.value as! [String: Any]
                                    let readHomeForSale = HomeSale(with: homeForSale)
                            
                                    if readHomeForSale != nil {
                                
                                        FirebaseData.sharedInstance.homesForSale.append(readHomeForSale!)
                                        print("appending Homes For Sale")
                                    }
                                    else {
                                        print("Nil found in Homes For Sale")
                                    }
                                }
                            }
                        }
                    }
                }
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
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "noUsersFoundKey"), object: nil)
                    return
                }
                for firstCharInEmail in value! {
                    print("\n\n\(firstCharInEmail.key)")
                    let firstCharDict = firstCharInEmail.value as! [String:Any]
                    
                    for secondCharInEmail in firstCharDict {
                        print("\n\n\(secondCharInEmail.key)")
                        let secondCharDict = secondCharInEmail.value as! [String:Any]
                        
                        for thirdCharInEmail in secondCharDict {
                            print("\n\n\(secondCharInEmail.key)")
                            let thirdCharDict = thirdCharInEmail.value as! [String:Any]
                            
                            self.readUser(data: thirdCharDict)
                            
                        }
                    }
                }
    
            })
        
    }
    
    class func readUser(data: [String: Any]){
        for any in data {
            let user: [String:Any] = any.value as! [String:Any]
            let UID: String = user["UID"] as! String
            let firstName: String = user["firstName"] as! String
            let lastName: String = user["lastName"] as! String
            let email: String = user["email"] as! String
            let phoneNumber: Int = user["phoneNumber"] as! Int
            let rating: Int = user["rating"] as! Int
            
            //user["listingRefs"] may have disappeared if the user's last listing was deleted, so we have to check first
            var listingRefs: [String]
            
            if (user.keys.contains("listings")){
                listingRefs = (user["listings"] as? [String])!
            }
            else {
                listingRefs = [] as [String]
            }
            
            var listings: [Listing] = []
            var index = 0
            for listingRef in listingRefs{
                
                if(listingRef == ""){
                    listingRefs.remove(at: index)
                }
                else {
                    FirebaseData.sharedInstance.specificUserListings.removeAll()
                    
                    ///ONLY PASS DATA OF SPECIFIC USER
                    //let ref = sharedInstance.homesForSaleNode.child("<#T##pathString: String##String#>")
                    let ref = FirebaseData.sharedInstance.homesForSaleNode.child(listingRef)
                    let tempHandle = ref.observe(DataEventType.value, with: { (snapshot) in
                        let value = snapshot.value as? NSDictionary;
                        
                        if ( value == nil) {
                            print("\(firstName) doesnt have any homes for sale")
                            return
                        }
                        
                        let data = value as? [String:Any]
                        readHomesForSale(data: data!, specificUser: true)
                        
                        listings = FirebaseData.sharedInstance.specificUserListings
                        
                        //let listingsForSpecificUserDownloadedNotificationKey = "listingsForSpecificUserDownloadedNotificationKey"
                        
                        // NotificationCenter.default.post(name: Notification.Name(rawValue: listingsForSpecificUserDownloadedNotificationKey), object: nil)
                    })
                    
                    
                    index = index+1
                }
            }
            
            
            
            let readUser = User(uid: UID, firstName: firstName, lastName: lastName, email: email, phoneNumber: phoneNumber, rating: rating, listings: listings)
            
            
            
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
    }
    

    
}
