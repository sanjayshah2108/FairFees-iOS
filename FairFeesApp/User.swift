//
//  User.swift
//  FairFeesApp
//
//  Created by Sanjay Shah on 2018-03-06.
//  Copyright © 2018 Fair Fees. All rights reserved.
//

import UIKit

class User: NSObject {

    var firstName: String
    var lastName: String
    var email: String
    var phoneNumber: Int
    var listings: [Listing]
    var rating: Int
    var listingsRefs: [String]!
    
    init(firstName:String,
         lastName:String,
         email:String,
         phoneNumber:Int,
         rating: Int,
         listings: [Listing]) {
    
        
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phoneNumber = phoneNumber
        self.listings = listings
        self.rating = rating
        self.listingsRefs = []
        
    }
    
    convenience init?(with inpDict:[String:Any]) {
        guard
            let inpFirstName: String = inpDict["firstName"] as? String,
            let inpLastName: String = inpDict["lastName"] as? String,
            let inpEmail: String = inpDict["email"] as? String,
            let inpPhoneNumber: Int = inpDict["phoneNumber"] as! Int,
            let inpRating: Int = inpDict["rating"] as! Int,
            
            //let inpProfileImage: String = inpDict["profileImage"] as? String ?? "",
            var inpListings:[Listing] = inpDict["listings"] as? [Listing] else
        {
            print("Error: Dictionary is not in the correct format")
            return nil
        }
        
//        var index = 0
//        for i in listings{
//
//            if(i == ""){
//                inpListings.remove(at: index)
//            }
//            else {
//                index = index+1
//            }
//        }
        
        self.init(firstName: inpFirstName, lastName: inpLastName, email: inpEmail, phoneNumber: inpPhoneNumber, rating: inpRating , listings: inpListings)
    }
    
    
    func toDictionary() -> [String:Any] {
        let userDict:[String:Any] = [ "email":self.email,
                                      "phoneNumber": self.phoneNumber,
                                      "firstName":self.firstName,
                                      "lastName": self.lastName,
                                      "rating":self.rating,
                                      //"profileImage":self.profileImage,
                                      "listings":self.listingsRefs ]
        return userDict
    }

    
}
