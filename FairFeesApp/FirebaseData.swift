//
//  FirebaseData.swift
//  
//
//  Created by Sanjay Shah on 2018-03-19.
//

import UIKit
import FirebaseDatabase
import Firebase

class FirebaseData: NSObject {

    static let sharedInstance = FirebaseData()

    public var currentUser: User? = nil
  
    public var listings: [Listing] = []
    public var homesForSale: [HomeSale] = []
    public var users: [User] = []
    var specificUserListings: [Listing] = []
    
    public var listingsNode: DatabaseReference
    public var homesForSaleNode: DatabaseReference
    public var usersNode: DatabaseReference
    
    static var listingsHandle:UInt? = nil
    static var homesForSaleHandle: UInt? = nil
    
    public override init() {
        usersNode = Database.database().reference().child("users")
        listingsNode = Database.database().reference().child("listings")
        homesForSaleNode = Database.database().reference().child("listings").child("homes").child("homesForSale")
        
    }
    
    class func readHomesForSale() {
        if ( Auth.auth().currentUser == nil)
        {
            return
        }
        
        let ref = sharedInstance.homesForSaleNode
        
        let tempHandle = ref.observe(DataEventType.value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary;
            
            if ( value == nil) {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "noOfferedItemsInCategoryKey"), object: nil)
                return
            }
            sharedInstance.listings.removeAll()
            
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
                    sharedInstance.specificUserListings.append(readHomeForSale!)
                }
                else {
                    sharedInstance.homesForSale.append(readHomeForSale!)
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
        
        sharedInstance.users.removeAll()
        sharedInstance.usersNode
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
                            let ref = sharedInstance.homesForSaleNode
                            let tempHandle = ref.observe(DataEventType.value, with: { (snapshot) in
                                let value = snapshot.value as? NSDictionary;
                                
                                if ( value == nil) {
                                    print("No homes for sale")
                                    return
                                }
                                sharedInstance.specificUserListings.removeAll()
                                
                                let data = value as? [String:Any]
                                readHomesForSale(data: data!, specificUser: true)
                                
                                let myDownloadCompleteNotificationKey = "myDownloadCompleteNotificationKey"
                                
                                NotificationCenter.default.post(name: Notification.Name(rawValue: myDownloadCompleteNotificationKey), object: nil)
                            })
                            
                            listings = sharedInstance.specificUserListings
                            index = index+1
                        }
                    }
                    

                    
                    let readUser = User(firstName: firstName, lastName: lastName, email: email, phoneNumber: phoneNumber, rating: rating, listings: listings)
                        
    
                    
                    sharedInstance.users.append(readUser)
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
    
    class func write(user:User) {
        let userEmail = user.email
        
        let firstCharOfUserEmail = String(userEmail[userEmail.index(userEmail.startIndex, offsetBy: 0)])
        let SecondCharOfUserEmail = String(userEmail[userEmail.index(userEmail.startIndex, offsetBy: 1)])
        let ThirdCharOfUserEmail = String(userEmail[userEmail.index(userEmail.startIndex, offsetBy: 2)])
        
        sharedInstance.usersNode.child(firstCharOfUserEmail).child(SecondCharOfUserEmail).child(ThirdCharOfUserEmail).setValue(user.toDictionary())
        
    }
    
    class func writeHomesForSale(homeForSale:HomeSale) {
        
        //let user = AppData.sharedInstance.currentUser!
        let user = DummyData.theDummyData.users[0]
        
        print("# of listings: \(user.listings.count)")
        let listingPath:String = "\(homeForSale.country!)/\(homeForSale.province!)/\(homeForSale.city!)/\(homeForSale.zipcode!)/\(user.lastName)/\(homeForSale.UID!)"
        var listingRef:String
        
            listingRef = "listing/sale/homesForSale/"
            listingRef.append(listingPath)
        
//            if sharedInstance.currentUser!.listings.first == "" {
//                sharedInstance.currentUser!.listings.remove(at: 0)
//            }
            sharedInstance.currentUser!.listingsRefs.append(listingRef)
        
        
        Database.database().reference().child(listingRef).setValue(homeForSale.toDictionary())
        
        let userEmail = user.email
        
        let firstCharOfUserEmail = String(userEmail[userEmail.index(userEmail.startIndex, offsetBy: 0)])
        let SecondCharOfUserEmail = String(userEmail[userEmail.index(userEmail.startIndex, offsetBy: 1)])
        let ThirdCharOfUserEmail = String(userEmail[userEmail.index(userEmail.startIndex, offsetBy: 2)])
    
        sharedInstance.usersNode.child(firstCharOfUserEmail).child(SecondCharOfUserEmail).child(ThirdCharOfUserEmail).setValue(sharedInstance.currentUser?.toDictionary())
    }
    
    
}
