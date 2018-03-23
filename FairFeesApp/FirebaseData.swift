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
    public var homesForRent: [HomeRental] = []
    public var users: [User] = []
    public var specificUserListings: [Listing] = []
    
    public var listingsNode: DatabaseReference
    public var forSaleNode: DatabaseReference
    public var forRentNode: DatabaseReference
    public var homesForSaleNode: DatabaseReference
    public var homesForRentNode: DatabaseReference
    public var usersNode: DatabaseReference

    
    public override init() {
        usersNode = Database.database().reference().child("users")
        listingsNode = Database.database().reference().child("listings")
        forRentNode = Database.database().reference().child("listings").child("forRent")
        forSaleNode = Database.database().reference().child("listings").child("forSale")
        homesForSaleNode = Database.database().reference().child("listings").child("forSale").child("homesForSale")
        homesForRentNode = Database.database().reference().child("listings").child("forRent").child("homesForRent")
        
    }
}
