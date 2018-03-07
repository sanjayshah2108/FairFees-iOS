//
//  User.swift
//  FairFeesApp
//
//  Created by Sanjay Shah on 2018-03-06.
//  Copyright © 2018 Fair Fees. All rights reserved.
//

import UIKit

class User: NSObject {

    var userFirstName: String
    var userLastName: String
    var userEmail: String
    var userPhoneNumber: Int
    var userListings: [Listing]
    var userRating: Int
    var userUID: String
    
    init(firstName:String,
         lastName:String,
         email:String,
         phoneNumber:Int,
         rating: Int,
         listings: [Listing],
         UID:String?) {
        
        self.userFirstName = firstName
        self.userLastName = lastName
        self.userEmail = email
        self.userPhoneNumber = phoneNumber
        self.userListings = listings
        self.userRating = rating
        
        if (UID == nil){
            userUID = UUID().uuidString
        }
        else {
            userUID = UID!
        }
    }

    
}
