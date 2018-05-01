//
//  ReadFirebaseData.swift
//  FairFeesApp
//
//  Created by Sanjay Shah on 2018-03-20.
//  Copyright © 2018 Fair Fees. All rights reserved.
//
import UIKit
import Firebase

class ReadFirebaseData: NSObject
{
    static var homesForSaleHandle: UInt? = nil
    static var homesForRentHandle: UInt? = nil
    static var myUserData: [String: Any]!
    
    //read all homesForSale
    class func readHomesForSale()
    {
        //We will need this if statement if we have autoLogin
        if ( Auth.auth().currentUser == nil)
        {
            
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
            
            let homesForSaleDownloadCompleteNotificationKey = "homesForSaleDownloadCompleteNotificationKey"
            NotificationCenter.default.post(name: Notification.Name(rawValue: homesForSaleDownloadCompleteNotificationKey), object: nil)
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
    
    class func readHomesForRent() {
        
        //We will need this if statement if we have autoLogin
        if ( Auth.auth().currentUser == nil)
        {
            
        }
        
        let ref = FirebaseData.sharedInstance.homesForRentNode
        
        let tempHandle = ref.observe(DataEventType.value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary;
            
            //first, clear all
            FirebaseData.sharedInstance.homesForRent.removeAll()
            
            if ( value == nil) {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "noHomesForRentKey"), object: nil)
                return
            }
            
            let data = value as? [String:Any]
            
            //get individual homesForRent data and append to local data
            readHomeForRent(data: data!, specificUser: false)
            
            let rentalHomesDownloadCompleteNotificationKey = "rentalHomesDownloadCompleteNotificationKey"
            NotificationCenter.default.post(name: Notification.Name(rawValue: rentalHomesDownloadCompleteNotificationKey), object: nil)
        })
        
        if homesForRentHandle != nil {
            ref.removeObserver(withHandle: homesForRentHandle!)
        }
        homesForRentHandle = tempHandle
    }
    
    fileprivate class func readHomeForRent(data:[String:Any], specificUser: Bool) {
        
        //appending a specific user's homesForSale to that user's local data.
        if (specificUser){
            let readHomeForRent = HomeRental(with: data)
            if (readHomeForRent != nil) {
                FirebaseData.sharedInstance.specificUserListings.append(readHomeForRent!)
            }
        }
            
            //appending all homesForRent to local data
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
                                    let homeForRent = userListing.value as! [String: Any]
                                    
                                    let readHomeForRent = HomeRental(with: homeForRent)
                                    
                                    if readHomeForRent != nil {
                                        FirebaseData.sharedInstance.homesForRent.append(readHomeForRent!)
                                    }
                                    else {
                                        print("The homeForRent is nil")
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
                    for firstCharInUID in value! {
                        let firstCharDict = firstCharInUID.value as! [String:Any]
    
                        for secondCharInUID in firstCharDict {
                            let secondCharDict = secondCharInUID.value as! [String:Any]
    
                            for thirdCharInUID in secondCharDict {
                                let thirdCharDict = thirdCharInUID.value as! [String:Any]
    
                                for user in thirdCharDict{
                                    let userData = user.value as! [String: Any]
                                    self.readUser(userData: userData)
                                }
    
                            }
                        }
                    }
                })
        }
    
    //read an individual user
    class func readUser(userData: [String: Any]){
        
        let UID: String = userData["UID"] as! String
        let displayName: String = userData["displayName"] as! String
        let email: String = userData["email"] as! String
        let phoneNumber: Int = userData["phoneNumber"] as! Int
        let rating: Int = userData["rating"] as! Int
        let typeOfUser: [String: Bool] = userData["typeOfUser"] as! [String: Bool]
        let profileImageRef: String = userData["profileImageRef"] as! String
        
        let reviewsDict: [String: [String: Any]]
        var reviews: [Review] = []
        
        //reviewDict may have disappeared from the FB DB if the last one was deleted, so just check first
        if (userData.keys.contains("reviews")){
            reviewsDict =  userData["reviews"] as! [String : [String: Any]]
        }
        else {
            reviewsDict = [:]
        }
        
        for (key, value) in reviewsDict{
            
            let reviewUID = value["UID"] as! String
            let text = value["text"] as! String
            let reviewerUID = value["reviewerUID"] as! String
            let reviewerName = value["reviewerName"] as! String
            let upvotes = value["upvotes"] as! Int
            let downvotes = value["downvotes"] as! Int
            let rating = value["rating"] as! Int
            
            var votesDict: [String: [String: Any]]
            var votes: [Vote] = []
            
            //votesDict may have disappeared from the FB DB if the last one was deleted, so just check first
            if (value.keys.contains("votes")){
                votesDict = value["votes"] as! [String: [String: Any]]
            }
            else {
                votesDict = [:]
            }
            
            for (key, value) in votesDict{
                let typeOfVote: String = value["type"] as! String
                let voterUID: String = value["voterUID"] as! String
                
                let vote:Vote = Vote(type: typeOfVote, voterUID: voterUID)
                
                votes.append(vote)
            }
            
            let rev = Review(uid: reviewUID, text: text, upvotes: upvotes, downvotes: downvotes, reviewerUID: reviewerUID, reviewerName: reviewerName, rating: rating, votes: votes)
            
            reviews.append(rev)
        }
        
        var listingRefs: [String]
        
        //user["listingRefs"] may have disappeared in the Firebase DB if the user deleted his only listing, so we have to check first.
        if (userData.keys.contains("listings")){
            listingRefs = (userData["listings"] as? [String])!
        }
        else {
            
            listingRefs = [] as [String]
            
            //create the user with no listings
            let readUser = User(uid: UID, displayName: displayName, email: email, phoneNumber: phoneNumber, rating: rating, listings: [], typeOfUser: typeOfUser, reviews: reviews, profileImageRef: profileImageRef)
            
            FirebaseData.sharedInstance.users.append(readUser)
            
            //if someone is signed in, set the current users details
            if (Auth.auth().currentUser != nil) {
                if (UID == Auth.auth().currentUser?.uid){
                    FirebaseData.sharedInstance.currentUser = readUser
                }
            }
        }
        
        //since the user data on Firebase only contains the references to the listings, we have to append them  manually to the user's local data.
        
        //first, clear the specificUserListings array.
        FirebaseData.sharedInstance.specificUserListings.removeAll()
        
        var listings: [Listing] = []
        for listingRef in listingRefs{
            
            //if there's a blank listingRef, don't include it.
            if(listingRef == ""){
                listingRefs.remove(at: listingRefs.index(of: listingRef)!)
            }
            else {
                
                let ref = FirebaseData.sharedInstance.listingsNode.child(listingRef)
                ref.observe(DataEventType.value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary;
                    
                    if ( value == nil) {
                        print("This listing doesn't exist")
                        return
                    }
                    
                    //find out if its a sale or rental
                    let startIndex = listingRef.index(listingRef.startIndex, offsetBy: 17)
                    let endIndex = listingRef.index(listingRef.startIndex, offsetBy: 21)
                    let range = startIndex..<endIndex
                    
                    let typeOfListing = listingRef[range]
                    
                    //append this listing to specificUserListings
                    let data = value as? [String:Any]
                    
                    if typeOfListing == "Sale" {
                        readHomeForSale(data: data!, specificUser: true)
                    }
                    if typeOfListing == "Rent" {
                        readHomeForRent(data: data!, specificUser: true)
                    }
                    
                    //if this homeSale is the last one in the listingRefs
                    if (
                        listingRefs.index(of: listingRef) == listingRefs.count-1){
                        
                        listings = FirebaseData.sharedInstance.specificUserListings
                        
                        //create the user with all the listings
                        let readUser = User(uid: UID, displayName: displayName, email: email, phoneNumber: phoneNumber, rating: rating, listings: listings, typeOfUser: typeOfUser, reviews: reviews, profileImageRef: profileImageRef)
                        
                        readUser.listingsRefs = listingRefs
                        
                        //if this user has been read before, overwrite him, otherwise append him
                        if(FirebaseData.sharedInstance.users.contains(where: {$0.UID == readUser.UID})){
                            let index = FirebaseData.sharedInstance.users.index(where: {$0.UID == readUser.UID})
                            
                            FirebaseData.sharedInstance.users[index!] = readUser
                        }
                        else {
                            FirebaseData.sharedInstance.users.append(readUser)
                        }
                        
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "userDownloadedKey"), object: nil)
                        
                        //if someone is signed in, set the current users details
                        if (Auth.auth().currentUser != nil) {
                            if (UID == Auth.auth().currentUser?.uid){
                                FirebaseData.sharedInstance.currentUser = readUser
                                myUserData = userData
                                
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "userListingsDownloadedKey"), object: nil)
                                
                            }
                        }
                        return
                    }
                })
            }
        }
    }
    
    class func readUser(userUID: String){
        
        // let userEmail = user.email
        
        let firstCharOfUserUID = String(userUID[userUID.index(userUID.startIndex, offsetBy: 0)])
        let secondCharOfUserUID = String(userUID[userUID.index(userUID.startIndex, offsetBy: 1)])
        let thirdCharOfUserUID = String(userUID[userUID.index(userUID.startIndex, offsetBy: 2)])
        FirebaseData.sharedInstance.usersNode.child(firstCharOfUserUID).child(secondCharOfUserUID).child(thirdCharOfUserUID).child(userUID)
            .observeSingleEvent(of: .value, with: { (snapshot) in
                
                let value = snapshot.value as? NSDictionary
                
                if ( value == nil) {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "user not found"), object: nil)
                    return
                }
                
                let userData = value as! [String: Any]
                
                //we can only compile the compareStack after the user's listings have been compiled in readUser()
                NotificationCenter.default.addObserver(self, selector: #selector(readCompareStack), name: NSNotification.Name(rawValue: "userListingsDownloadedKey"), object: nil)
                
                self.readUser(userData: userData)
                
            })
    }
    
    class func readCurrentUser(user: User){
        
        let userEmail = user.email
        let userUID = user.UID!
        
        let firstCharOfUserUID = String(userUID[userUID.index(userUID.startIndex, offsetBy: 0)])
        let secondCharOfUserUID = String(userUID[userUID.index(userUID.startIndex, offsetBy: 1)])
        let thirdCharOfUserUID = String(userUID[userUID.index(userUID.startIndex, offsetBy: 2)])
        FirebaseData.sharedInstance.usersNode.child(firstCharOfUserUID).child(secondCharOfUserUID).child(thirdCharOfUserUID).child(userUID)
            .observeSingleEvent(of: .value, with: { (snapshot) in
                
                let value = snapshot.value as? NSDictionary
                
                if ( value == nil) {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "user not found"), object: nil)
                    return
                }
                
                let userData = value as! [String: Any]
                
                //we can only compile the compareStack after the user's listings have been compiled in readUser()
                NotificationCenter.default.addObserver(self, selector: #selector(readCompareStack), name: NSNotification.Name(rawValue: "userListingsDownloadedKey"), object: nil)
                
                self.readUser(userData: userData)
                
            })
    }
    
    
    //this method is only called from readCurrentUser because we dont need other users compareStack info
    @objc class func readCompareStack(){
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "userListingsDownloadedKey"), object: nil)
        
        var compareStackRefs: [String]
        
        let userData = myUserData
        
        //user["compareStackRefs"] may have disappeared in the Firebase DB if the user deleted his only comparison, so we have to check first.
        if (userData?.keys.contains("compareStack"))!{
            compareStackRefs = (userData!["compareStack"] as? [String])!
        }
        else {
            compareStackRefs = [] as [String]
        }
        
        FirebaseData.sharedInstance.currentUser?.compareStackListingRefs = compareStackRefs
        
        //first, clear the specificUserListings array.
        FirebaseData.sharedInstance.specificUserListings.removeAll()
        
        var compareStackListings: [Listing] = []
        
        for compareListingRef in compareStackRefs{
            
            //if there's a blank compareListingRef, don't include it, and remove it from the refs
            if(compareListingRef == ""){
                compareStackRefs.remove(at: compareStackRefs.index(of: compareListingRef)!)
            }
            else {
                
                let ref = FirebaseData.sharedInstance.listingsNode.child(compareListingRef)
                ref.observe(DataEventType.value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary;
                    
                    if ( value == nil) {
                        print("This listing doesn't exist")
                        return
                    }
                    
                    //find out if its a sale or rental
                    let startIndex = compareListingRef.index(compareListingRef.startIndex, offsetBy: 17)
                    let endIndex = compareListingRef.index(compareListingRef.startIndex, offsetBy: 21)
                    let range = startIndex..<endIndex
                    
                    let typeOfListing = compareListingRef[range]
                    
                    //append this listing to specificUserListings
                    let data = value as? [String:Any]
                    
                    if typeOfListing == "Sale" {
                        readHomeForSale(data: data!, specificUser: true)
                    }
                    if typeOfListing == "Rent" {
                        readHomeForRent(data: data!, specificUser: true)
                    }
                    
                    //if this listing is the last one in the compareStackRefs
                    if (compareStackRefs.index(of: compareListingRef) == compareStackRefs.count-1){
                        
                        compareStackListings = FirebaseData.sharedInstance.specificUserListings
                        
                        FirebaseData.sharedInstance.currentUser?.compareStackListings = compareStackListings
                        
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "compareStackDownloadedKey"), object: nil)
                        
                        return
                    }
                })
            }
        }
    }
    
}
