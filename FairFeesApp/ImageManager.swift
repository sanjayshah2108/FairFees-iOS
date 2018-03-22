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
    
    class func uploadImage(image:UIImage, userUID:String, listingUID:String, filename:String) -> String {
        let storageRef = Storage.storage().reference()
        let firstCharOfUserUID = userUID[userUID.index(userUID.startIndex, offsetBy: 0)]
        let SecondCharOfUserUID = userUID[userUID.index(userUID.startIndex, offsetBy: 1)]
        let ThirdCharOfUserUID = userUID[userUID.index(userUID.startIndex, offsetBy: 2)]
        let storagePath = "\(firstCharOfUserUID)/\(SecondCharOfUserUID)/\(ThirdCharOfUserUID)/\(listingUID)\(filename)"
        
        let imageData:Data = UIImageJPEGRepresentation(image, 0.2)!
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        storageRef.child(storagePath).putData(imageData, metadata: metadata)
        
        return storagePath
    }

}
