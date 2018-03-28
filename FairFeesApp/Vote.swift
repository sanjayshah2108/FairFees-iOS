//
//  Vote.swift
//  FairFeesApp
//
//  Created by Sanjay Shah on 2018-03-27.
//  Copyright © 2018 Fair Fees. All rights reserved.
//

import UIKit

class Vote: NSObject {

    var type: String!
    var voterUID: String!
    
    init(type:String,
         voterUID:String) {
        
        self.type = type
        self.voterUID = voterUID
    }
    
    func toDictionary() -> [String:Any] {
        let voteDict:[String:Any] = ["type":self.type,
                                     "voterUID":self.voterUID]
        
        return voteDict
    }
}
