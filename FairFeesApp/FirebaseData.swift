//
//  FirebaseData.swift
//  
//
//  Created by Sanjay Shah on 2018-03-19.
//

import Foundation
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

    
    public override init() {
        usersNode = Database.database().reference().child("users")
        listingsNode = Database.database().reference().child("listings")
        homesForSaleNode = Database.database().reference().child("listings").child("forSale").child("homesForSale")
    }
}
