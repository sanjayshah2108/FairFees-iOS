//
//  Review.swift
//  FairFeesApp
//
//  Created by Sanjay Shah on 2018-03-27.
//  Copyright © 2018 Fair Fees. All rights reserved.
//

import UIKit

class Review: NSObject {

    var UID: String!
    var text: String!
    var upvotes: Int!
    var downvotes: Int!
    var reviewerUID: String!
    var reviewerName: String!
    var rating: Int!
    var votes: [Vote]!
    //var votesDict: [String: Any]!
    
    init(uid:String,
         text:String,
         upvotes:Int,
         downvotes: Int,
         reviewerUID: String,
         reviewerName: String,
         rating: Int,
         votes: [Vote]) {
        
        self.UID = uid
        self.text = text
        self.upvotes = upvotes
        self.downvotes = downvotes
        self.reviewerUID = reviewerUID
        self.reviewerName = reviewerName
        self.rating = rating
        self.votes = votes
        //self.votesDict = [:]
    }
    

    func toDictionary() -> [String:Any] {
        
        var votesDict: [String: Any] = [:]
        
        for vote in votes{
            //votesDict.append(vote.toDictionary())
            let voteDict:[String: Any] = vote.toDictionary()
            votesDict["\(vote.type!)_\(vote.voterUID!)"] = voteDict
        }
        
        let reviewDict:[String:Any] = ["UID":self.UID,
                                      "text":self.text,
                                      "upvotes": self.upvotes,
                                      "downvotes":self.downvotes,
                                      "reviewerUID": self.reviewerUID,
                                      "reviewerName":self.reviewerName,
                                      "rating": self.rating,
                                      "votes": votesDict]
        
        return reviewDict
    }
    
    
}
