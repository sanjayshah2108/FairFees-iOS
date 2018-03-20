//
//  DummyData.swift
//  FairFeesApp
//
//  Created by Sanjay Shah on 2018-03-06.
//  Copyright © 2018 Fair Fees. All rights reserved.
//

import UIKit
import CoreLocation

class DummyData: NSObject {
    
    static let theDummyData = DummyData()
    
    var users: [User]!
    var homesForSale: [HomeSale]!
    
    let date = Date()
    
    func createUsers(){
        
        users = []
        
        let user1 = User(firstName: "Sanjay",
                         lastName: "Shah",
                         email: "sanjays@gmail.com",
                         phoneNumber: 7788816399,
                         rating: 5,
                         listings: [])
        
        let user2 = User(firstName: "Amir",
                         lastName: "Jahanlou",
                         email: "amir.jahan@gmail.com",
                         phoneNumber: 6044413431,
                         rating: 5,
                         listings: [])
        
        user1.listingsRefs = [""]
        user2.listingsRefs = [""]
        
        self.users.append(user1)
        self.users.append(user2)
        
        FirebaseData.sharedInstance.currentUser = user1
    }
    
    func createListings(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: Date())
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "dd-MMM-yyyy"
        let myStringafd = formatter.string(from: yourDate!)
        
        homesForSale = []
        LocationManager.theLocationManager.currentLocation = LocationManager.theLocationManager.getLocation()
        
        let homeSale1UID = UUID().uuidString
        let homeSale1 = HomeSale(
            name: "North Van Apt",
            description: "Test Description",
            location: CLLocation.init(latitude: 49.3200, longitude: -123.0724),
            address:"1234 North Van",
            city:"Vancouver",
            province:"BC",
            country:"Canada",
            zipcode:"VH60A9",
            posterUID: users[0].email,
            photosRef: [ImageManager.uploadImage(image: UIImage(named: "00G0G_iZpKq2kJbr8_1200x900.jpg")!, userUID: users[0].email, listingUID: homeSale1UID, filename: "00G0G_iZpKq2kJbr8_1200x900.jpg"),
                        ImageManager.uploadImage(image: UIImage(named: "00w0w_7Xm4T55PkAP_1200x900.jpg")!, userUID: users[0].email, listingUID: homeSale1UID, filename: "00w0w_7Xm4T55PkAP_1200x900.jpg"),
                        ImageManager.uploadImage(image: UIImage(named: "00w0w_e8JqNq4nDgI_1200x900.jpg")!, userUID: users[0].email, listingUID: homeSale1UID, filename: "00w0w_e8JqNq4nDgI_1200x900.jpg"),
                        ImageManager.uploadImage(image: UIImage(named: "00404_8OmXsbv4SED_1200x900.jpg")!, userUID: users[0].email, listingUID: homeSale1UID, filename: "00404_8OmXsbv4SED_1200x900.jpg"),
                        ImageManager.uploadImage(image: UIImage(named: "01010_bQE4g1cNSyD_1200x900.jpg")!, userUID: users[0].email, listingUID: homeSale1UID, filename: "01010_bQE4g1cNSyD_1200x900.jpg"),
                        ImageManager.uploadImage(image: UIImage(named: "01111_9LMDIdNYAfP_1200x900.jpg")!, userUID: users[0].email, listingUID: homeSale1UID, filename: "01111_9LMDIdNYAfP_1200x900.jpg"),
                        ImageManager.uploadImage(image: UIImage(named: "01212_1l9PZ8SjGYJ_1200x900.jpg")!, userUID: users[0].email, listingUID: homeSale1UID, filename: "01212_1l9PZ8SjGYJ_1200x900.jpg")],
            
            size: 30,
            bedroomNumber: 2,
            bathroomNumber: 2,
            UID: homeSale1UID,
            price: 300000,
            ownerUID: users[1].email,
            availabilityDate: NSNumber(value: Int(NSDate().timeIntervalSince1970)))
        

        
        homeSale1.photos = []
        
        let homeSale2UID = UUID().uuidString
       let homeSale2 = HomeSale(name: "West Van Apt",
                                 description: "Test Description",
                                 location: CLLocation.init(latitude: 49.3223441, longitude: -123.1117724),
                                 address:"1234 West Van",
                                 city:"Vancouver",
                                 province:"BC",
                                 country:"Canada",
                                 zipcode:"VH60A8",
                                 posterUID: users[0].email,
                                 photosRef: [ImageManager.uploadImage(image: UIImage(named: "00B0B_79jyoTMowLD_1200x900.jpg")!, userUID: users[0].email, listingUID: homeSale2UID, filename: "00B0B_79jyoTMowLD_1200x900.jpg"),
                                             ImageManager.uploadImage(image: UIImage(named: "00B0B_anRDCMQfQ3p_1200x900.jpg")!, userUID: users[0].email, listingUID: homeSale2UID, filename: "00B0B_anRDCMQfQ3p_1200x900.jpg"),
                                             ImageManager.uploadImage(image: UIImage(named: "00l0l_a0QTvRBkXQy_1200x900.jpg")!, userUID: users[0].email, listingUID: homeSale2UID, filename: "00l0l_a0QTvRBkXQy_1200x900.jpg"),
                                             ImageManager.uploadImage(image: UIImage(named: "00L0L_i9sDtSXuHjz_1200x900.jpg")!, userUID: users[0].email, listingUID: homeSale2UID, filename: "00L0L_i9sDtSXuHjz_1200x900.jpg"),
                                             ImageManager.uploadImage(image: UIImage(named: "00N0N_2MZaQK4150n_1200x900.jpg")!, userUID: users[0].email, listingUID: homeSale2UID, filename: "00N0N_2MZaQK4150n_1200x900.jpg"),
                                             ImageManager.uploadImage(image: UIImage(named: "00P0P_buoO9jmpb6c_1200x900.jpg")!, userUID: users[0].email, listingUID: homeSale2UID, filename: "00P0P_buoO9jmpb6c_1200x900.jpg"),
                                             ImageManager.uploadImage(image: UIImage(named: "00W0W_bqm9ca1gKws_1200x900.jpg")!, userUID: users[0].email, listingUID: homeSale2UID, filename: "00W0W_bqm9ca1gKws_1200x900.jpg"),
                                             ImageManager.uploadImage(image: UIImage(named: "00Y0Y_1RmFaEtv0nr_1200x900.jpg")!, userUID: users[0].email, listingUID: homeSale2UID, filename: "00Y0Y_1RmFaEtv0nr_1200x900.jpg"),
                                             ImageManager.uploadImage(image: UIImage(named: "00707_a4xJkZU2wIn_1200x900.jpg")!, userUID: users[0].email, listingUID: homeSale2UID, filename: "00707_a4xJkZU2wIn_1200x900.jpg")],
                                 size: 30,
                                 bedroomNumber: 2,
                                 bathroomNumber: 2,
                                 UID: homeSale2UID,
                                 price: 300000,
                                 ownerUID: users[1].email,
                                 availabilityDate: NSNumber(value: Int(NSDate().timeIntervalSince1970)))

        let homeSale3UID = UUID().uuidString
        let homeSale3 = HomeSale(name: "Downtown Apt",
                                 description: "Test Description",
                                 location: CLLocation.init(latitude: 49.278938, longitude: -123.074545),
                                 address:"1234 West Georgia",
                                 city:"Vancouver",
                                 province:"BC",
                                 country:"Canada",
                                 zipcode:"VH60A7",
                                 posterUID: users[0].email,
                                 photosRef: [ImageManager.uploadImage(image:UIImage(named: "00e0e_dVd4VYsuulU_1200x900.jpg")!, userUID: users[0].email, listingUID: homeSale3UID, filename: "00e0e_dVd4VYsuulU_1200x900.jpg"),
                                             ImageManager.uploadImage(image:UIImage(named: "00k0k_ccCBmnQdSPi_1200x900.jpg")!, userUID: users[0].email, listingUID: homeSale3UID, filename: "00k0k_ccCBmnQdSPi_1200x900.jpg"),
                                             ImageManager.uploadImage(image:UIImage(named: "00L0L_j3n0Ghg3May_1200x900.jpg")!, userUID: users[0].email, listingUID: homeSale3UID, filename: "00L0L_j3n0Ghg3May_1200x900.jpg"),
                                             ImageManager.uploadImage(image: UIImage(named: "00M0M_8j7fiZJGN04_1200x900.jpg")!, userUID: users[0].email, listingUID: homeSale3UID, filename: "00M0M_8j7fiZJGN04_1200x900.jpg"),
                                             ImageManager.uploadImage(image:UIImage(named: "00Q0Q_2bYvj1iYMGi_1200x900.jpg")!, userUID: users[0].email, listingUID: homeSale3UID, filename: "00Q0Q_2bYvj1iYMGi_1200x900.jpg"),
                                             ImageManager.uploadImage(image:UIImage(named: "00N0N_dC0hJzZuUZr_1200x900.jpg")!, userUID: users[0].email, listingUID: homeSale3UID, filename: "00N0N_dC0hJzZuUZr_1200x900.jpg"),
                                             ImageManager.uploadImage(image:UIImage(named: "00S0S_hbqDmQ58qa1_1200x900.jpg")!, userUID: users[0].email, listingUID: homeSale3UID, filename: "00S0S_hbqDmQ58qa1_1200x900.jpg"),
                                             ImageManager.uploadImage(image:UIImage(named: "00V0V_1w79UkaNL93_1200x900.jpg")!, userUID: users[0].email, listingUID: homeSale3UID, filename: "00V0V_1w79UkaNL93_1200x900.jpg"),
                                             ImageManager.uploadImage(image:UIImage(named: "01212_lbaPCrD1wkz_1200x900.jpg")!, userUID: users[0].email, listingUID: homeSale3UID, filename: "01212_lbaPCrD1wkz_1200x900.jpg")],
                                 size: 30,
                                 bedroomNumber: 2,
                                 bathroomNumber: 2,
                                 UID: homeSale3UID,
                                 price: 300000,
                                 ownerUID: users[1].email,
                                 availabilityDate: NSNumber(value: Int(NSDate().timeIntervalSince1970)))

        let homeSale4UID = UUID().uuidString
        let homeSale4 = HomeSale(name: "East Van House",
                                 description: "Test Description",
                                 location: CLLocation.init(latitude: 49.275728, longitude: -123.090294),
                                 address:"1234 East Van",
                                 city:"Vancouver",
                                 province:"BC",
                                 country:"Canada",
                                 zipcode:"VH60A7",
                                 posterUID: users[0].email,
                                 photosRef: [ImageManager.uploadImage(image: UIImage(named: "00a0a_bHlb7rvOfrt_1200x900.jpg")!, userUID: users[0].email, listingUID: homeSale4UID, filename: "00a0a_bHlb7rvOfrt_1200x900.jpg"),
                                             ImageManager.uploadImage(image: UIImage(named: "00i0i_i58WRgAT0E5_1200x900.jpg")!, userUID: users[0].email, listingUID: homeSale4UID, filename: "00i0i_i58WRgAT0E5_1200x900.jpg"),
                                             ImageManager.uploadImage(image: UIImage(named: "00P0P_ei9EzDPme8E_1200x900.jpg")!, userUID: users[0].email, listingUID: homeSale4UID, filename: "00P0P_ei9EzDPme8E_1200x900.jpg"),
                                             ImageManager.uploadImage(image: UIImage(named: "00l0l_38ixPXcxZhW_1200x900.jpg")!, userUID: users[0].email, listingUID: homeSale4UID, filename: "00l0l_38ixPXcxZhW_1200x900.jpg"),
                                             ImageManager.uploadImage(image: UIImage(named: "00Y0Y_dxJFwLrXD2z_1200x900.jpg")!, userUID: users[0].email, listingUID: homeSale4UID, filename: "00Y0Y_dxJFwLrXD2z_1200x900.jpg"),
                                             ImageManager.uploadImage(image: UIImage(named: "00101_iWfj9gmPMjJ_1200x900.jpg")!, userUID: users[0].email, listingUID: homeSale4UID, filename: "00101_iWfj9gmPMjJ_1200x900.jpg"),
                                             ImageManager.uploadImage(image: UIImage(named: "00606_6BcSIrgOqof_1200x900.jpg")!, userUID: users[0].email, listingUID: homeSale4UID, filename: "00606_6BcSIrgOqof_1200x900.jpg")],
                                 size: 30,
                                 bedroomNumber: 2,
                                 bathroomNumber: 2,
                                 UID: homeSale4UID,
                                 price: 300000,
                                 ownerUID: users[1].email,
                                 availabilityDate: NSNumber(value: Int(NSDate().timeIntervalSince1970)))


        let homeSale5UID = UUID().uuidString
        let homeSale5 = HomeSale(name: "Vancouver West Apt",
                                 description: "Test Description",
                                 location: CLLocation.init(latitude: 49.281439, longitude: -123.089564),
                                 address:"1234 UBC Boulevard",
                                 city:"Vancouver",
                                 province:"BC",
                                 country:"Canada",
                                 zipcode:"VH60B9",
                                 posterUID: users[0].email,
                                 photosRef: [ImageManager.uploadImage(image: UIImage(named: "00f0f_g4KXDGQh7wV_1200x900.jpg")!, userUID: users[0].email, listingUID: homeSale5UID, filename: "00f0f_g4KXDGQh7wV_1200x900.jpg"),
                                             ImageManager.uploadImage(image: UIImage(named: "00U0U_ALiRuz1mTx_1200x900.jpg")!, userUID: users[0].email, listingUID: homeSale5UID, filename: "00U0U_ALiRuz1mTx_1200x900.jpg")],
                                 size: 30,
                                 bedroomNumber: 2,
                                 bathroomNumber: 2,
                                 UID: homeSale5UID,
                                 price: 300000,
                                 ownerUID: users[1].email,
                                 availabilityDate: NSNumber(value: Int(NSDate().timeIntervalSince1970)))
        

        homesForSale.append(homeSale1)
        WriteFirebaseData.writeHomesForSale(homeForSale: homeSale1)
        
        homesForSale.append(homeSale2)
        WriteFirebaseData.writeHomesForSale(homeForSale: homeSale2)
        
        homesForSale.append(homeSale3)
        WriteFirebaseData.writeHomesForSale(homeForSale: homeSale3)
        
        homesForSale.append(homeSale4)
        WriteFirebaseData.writeHomesForSale(homeForSale: homeSale4)
        
        homesForSale.append(homeSale5)
        WriteFirebaseData.writeHomesForSale(homeForSale: homeSale5)
    }

    
    func addListing(listing: HomeSale){
        homesForSale.append(listing)
    }
    
}
