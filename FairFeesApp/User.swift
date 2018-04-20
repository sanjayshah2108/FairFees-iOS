//
//  User.swift
//  FairFeesApp
//
//  Created by Sanjay Shah on 2018-03-06.
//  Copyright © 2018 Fair Fees. All rights reserved.
//

import UIKit

class User: NSObject {

    var UID:String!
    var firstName: String
    var lastName: String
    var email: String
    var phoneNumber: Int
    var listings: [Listing]
    var listingsRefs: [String]!
    var rating: Int
    var typeOfUser: [String : Bool]!
    var reviews: [Review]
    var reviewsDict : [String: Any]!
    var profileImageRef: String!
    var compareStackListings: [Listing]!
    var compareStackListingRefs: [String]!
    
    init(uid:String,
         firstName:String,
         lastName:String,
         email:String,
         phoneNumber:Int,
         rating: Int,
         listings: [Listing],
         typeOfUser: [String: Bool],
         reviews: [Review],
         profileImageRef: String) {
    
        self.UID = uid
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phoneNumber = phoneNumber
        self.listings = listings
        self.rating = rating
        self.listingsRefs = []
        self.typeOfUser = typeOfUser
        self.reviews = reviews
        self.reviewsDict = [:]
        self.compareStackListings = []
        self.compareStackListingRefs = []
        self.profileImageRef = profileImageRef
        
    }
    
    //used when creating a user from FirebaseData
    convenience init?(with inpDict:[String:Any]) {
        guard
            let inpUID: String = inpDict["UID"] as? String,
            let inpFirstName: String = inpDict["firstName"] as? String,
            let inpLastName: String = inpDict["lastName"] as? String,
            let inpEmail: String = inpDict["email"] as? String,
            let inpPhoneNumber: Int = inpDict["phoneNumber"] as? Int,
            let inpRating: Int = inpDict["rating"] as? Int,
            let inpTypeOfUser: [String: Bool] = inpDict["typeOfUser"] as? [String: Bool],
            let inpListings:[Listing] = inpDict["listings"] as? [Listing],
            let inpProfileImageRef: String = inpDict["profileImageRef"] as? String,
            let inpCompareStackListings: [Listing] = inpDict["compareStack"] as? [Listing],
            let inpReviews: [Review] = inpDict[""] as? [Review] else
        {
            print("Error: Dictionary is not in the correct format")
            return nil
        }

        self.init(uid: inpUID, firstName: inpFirstName, lastName: inpLastName, email: inpEmail, phoneNumber: inpPhoneNumber, rating: inpRating , listings: inpListings, typeOfUser: inpTypeOfUser, reviews: inpReviews, profileImageRef: inpProfileImageRef)
    }
    
    
    //used for writing userData to Firebase
    func toDictionary() -> [String:Any] {
        
        for review in reviews {
            let reviewDict:[String: Any] = review.toDictionary()
            self.reviewsDict["\(review.UID!)"] = reviewDict
        }
        
        
        let userDict:[String:Any] = [ "UID":self.UID,
                                      "email":self.email,
                                      "phoneNumber": self.phoneNumber,
                                      "firstName":self.firstName,
                                      "lastName": self.lastName,
                                      "rating":self.rating,
                                      "listings":self.listingsRefs,
                                      "compareStack": self.compareStackListingRefs,
                                      "reviews": self.reviewsDict,
                                      "profileImageRef": self.profileImageRef,
                                      "typeOfUser": self.typeOfUser]
        return userDict
    }
 
}
