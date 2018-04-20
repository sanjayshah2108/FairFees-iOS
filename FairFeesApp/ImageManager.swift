//
//  ImageManager.swift
//  FairFeesApp
//
//  Created by Sanjay Shah on 2018-03-19.
//  Copyright © 2018 Fair Fees. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class ImageManager: NSObject {
    
    //need to give a listingPath userEmail/UID subbucket
    class func uploadListingImage(image:UIImage, userEmail:String, listingUID:String, filename:String) -> String {
        let storageRef = Storage.storage().reference()
        let firstCharOfUserEmail = userEmail[userEmail.index(userEmail.startIndex, offsetBy: 0)]
        let secondCharOfUserEmail = userEmail[userEmail.index(userEmail.startIndex, offsetBy: 1)]
        let thirdCharOfUserEmail = userEmail[userEmail.index(userEmail.startIndex, offsetBy: 2)]
        let storagePath = "\(firstCharOfUserEmail)/\(secondCharOfUserEmail)/\(thirdCharOfUserEmail)/\(userEmail)/\(listingUID)\(filename)"
        
        let imageData:Data = UIImageJPEGRepresentation(image, 0.2)!
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        storageRef.child(storagePath).putData(imageData, metadata: metadata)
        
        return storagePath
    }
    
    class func uploadProfileImage(image:UIImage, userEmail:String, filename:String) -> String {
        let storageRef = Storage.storage().reference()
        let firstCharOfUserEmail = userEmail[userEmail.index(userEmail.startIndex, offsetBy: 0)]
        let secondCharOfUserEmail = userEmail[userEmail.index(userEmail.startIndex, offsetBy: 1)]
        let thirdCharOfUserEmail = userEmail[userEmail.index(userEmail.startIndex, offsetBy: 2)]
        let storagePath = "\(firstCharOfUserEmail)/\(secondCharOfUserEmail)/\(thirdCharOfUserEmail)/\(userEmail)\(filename)"
        
        let imageData:Data = UIImageJPEGRepresentation(image, 0.2)!
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        storageRef.child(storagePath).putData(imageData, metadata: metadata)
        
        return storagePath
    }

}
