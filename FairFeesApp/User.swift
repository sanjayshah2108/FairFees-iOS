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
    var UID: String
    
    init(firstName:String,
         lastName:String,
         email:String,
         phoneNumber:Int,
         rating: Int,
         listings: [Listing],
         UID:String?) {
        
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phoneNumber = phoneNumber
        self.listings = listings
        self.rating = rating
        
        if (UID == nil){
            self.UID = UUID().uuidString
        }
        else {
            self.UID = UID!
        }
    }

    
}
