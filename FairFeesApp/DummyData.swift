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
                         listings: [],
                         UID: nil)
        
        let user2 = User(firstName: "Amir",
                         lastName: "Jahanlou",
                         email: "amir.jahan@gmail.com",
                         phoneNumber: 6044413431,
                         rating: 5,
                         listings: [],
                         UID: nil)
        
        self.users.append(user1)
        self.users.append(user2)
    }
    
    func createListings(){
        
        homesForSale = []
        LocationManager.theLocationManager.currentLocation = LocationManager.theLocationManager.getLocation()
        
        let homeSale1 = HomeSale(
            name: "North Van Apt",
            description: "Test Description",
            location: CLLocation.init(latitude: 49.3200, longitude: -123.0724),
            address:"1234 North Van",
            poster: users[0],
            photos: [UIImage(named: "00G0G_iZpKq2kJbr8_1200x900.jpg")!,
                     UIImage(named: "00w0w_7Xm4T55PkAP_1200x900.jpg")!,
                     UIImage(named: "00w0w_e8JqNq4nDgI_1200x900.jpg")!,
                     UIImage(named: "00404_8OmXsbv4SED_1200x900.jpg")!,
                     UIImage(named: "01010_bQE4g1cNSyD_1200x900.jpg")!,
                     UIImage(named: "01111_9LMDIdNYAfP_1200x900.jpg")!,
                     UIImage(named: "01212_1l9PZ8SjGYJ_1200x900.jpg")!],
            size: 30,
            bedroomNumber: 2,
            bathroomNumber: 2,
            UID: nil,
            price: 300000,
            owner: users[1],
            availabilityDate: Date())
        
        let homeSale2 = HomeSale(name: "West Van Apt",
                                 description: "Test Description",
                                 location: CLLocation.init(latitude: 49.3223441, longitude: -123.1117724),
                                 address:"1234 West Van",
                                 poster: users[0],
                                 photos: [UIImage(named: "00B0B_79jyoTMowLD_1200x900.jpg")!,
                                          UIImage(named: "00B0B_anRDCMQfQ3p_1200x900.jpg")!,
                                          UIImage(named: "00l0l_a0QTvRBkXQy_1200x900.jpg")!,
                                          UIImage(named: "00L0L_i9sDtSXuHjz_1200x900.jpg")!,
                                          UIImage(named: "00N0N_2MZaQK4150n_1200x900.jpg")!,
                                          UIImage(named: "00P0P_buoO9jmpb6c_1200x900.jpg")!,
                                          UIImage(named: "00W0W_bqm9ca1gKws_1200x900.jpg")!,
                                          UIImage(named: "00Y0Y_1RmFaEtv0nr_1200x900.jpg")!,
                                          UIImage(named: "00707_a4xJkZU2wIn_1200x900.jpg")!],
                                 size: 30,
                                 bedroomNumber: 2,
                                 bathroomNumber: 2,
                                 UID: nil,
                                 price: 300000,
                                 owner: users[1],
                                 availabilityDate: Date())
        
        let homeSale3 = HomeSale(name: "Downtown Apt",
                                 description: "Test Description",
                                 location: CLLocation.init(latitude: 49.278938, longitude: -123.074545),
                                 address:"1234 West Georgia",
                                 poster: users[0],
                                 photos: [UIImage(named: "00e0e_dVd4VYsuulU_1200x900.jpg")!,
                                          UIImage(named: "00k0k_ccCBmnQdSPi_1200x900.jpg")!,
                                          UIImage(named: "00L0L_j3n0Ghg3May_1200x900.jpg")!,
                                          UIImage(named: "00M0M_8j7fiZJGN04_1200x900.jpg")!,
                                          UIImage(named: "00N0N_dC0hJzZuUZr_1200x900.jpg")!,
                                          UIImage(named: "00Q0Q_2bYvj1iYMGi_1200x900.jpg")!,
                                          UIImage(named: "00S0S_hbqDmQ58qa1_1200x900.jpg")!,
                                          UIImage(named: "00V0V_1w79UkaNL93_1200x900.jpg")!,
                                          UIImage(named: "01212_lbaPCrD1wkz_1200x900.jpg")!],
                                 size: 30,
                                 bedroomNumber: 2,
                                 bathroomNumber: 2,
                                 UID: nil,
                                 price: 300000,
                                 owner: users[1],
                                 availabilityDate: Date())
        
        let homeSale4 = HomeSale(name: "East Van House",
                                 description: "Test Description",
                                 location: CLLocation.init(latitude: 49.275728, longitude: -123.090294),
                                 address:"1234 East Van",
                                 poster: users[0],
                                 photos: [UIImage(named: "00a0a_bHlb7rvOfrt_1200x900.jpg")!,
                                          UIImage(named: "00i0i_i58WRgAT0E5_1200x900.jpg")!,
                                          UIImage(named: "00l0l_38ixPXcxZhW_1200x900.jpg")!,
                                          UIImage(named: "00P0P_ei9EzDPme8E_1200x900.jpg")!,
                                          UIImage(named: "00Y0Y_dxJFwLrXD2z_1200x900.jpg")!,
                                          UIImage(named: "00101_iWfj9gmPMjJ_1200x900.jpg")!,
                                          UIImage(named: "00606_6BcSIrgOqof_1200x900.jpg")!],
                                 size: 30,
                                 bedroomNumber: 2,
                                 bathroomNumber: 2,
                                 UID: nil,
                                 price: 300000,
                                 owner: users[1],
                                 availabilityDate: Date())
        

        let homeSale5 = HomeSale(name: "Vancouver West Apt",
                                 description: "Test Description",
                                 location: CLLocation.init(latitude: 49.281439, longitude: -123.089564),
                                 address:"1234 UBC Boulevard",
                                 poster: users[0],
                                 photos: [UIImage(named: "00f0f_g4KXDGQh7wV_1200x900.jpg")!,
                                          UIImage(named: "00U0U_ALiRuz1mTx_1200x900.jpg")!],
                                 size: 30,
                                 bedroomNumber: 2,
                                 bathroomNumber: 2,
                                 UID: nil,
                                 price: 300000,
                                 owner: users[1],
                                 availabilityDate: Date())
        

        homesForSale.append(homeSale1)
        homesForSale.append(homeSale2)
        homesForSale.append(homeSale3)
        homesForSale.append(homeSale4)
        homesForSale.append(homeSale5)
    }

    
    func addListing(listing: HomeSale){
        homesForSale.append(listing)
    }
    
}
