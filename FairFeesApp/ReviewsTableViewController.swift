//
//  ReviewsTableViewController.swift
//  FairFeesApp
//
//  Created by Sanjay Shah on 2018-03-28.
//  Copyright © 2018 Fair Fees. All rights reserved.
//

import UIKit

class ReviewsTableViewController: UITableViewController, ReviewTableViewCellDelegate {

    var currentUser: User!
   // var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        //tableView = UITableView(frame: CGRect(x: 0, y: 40, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height-40)), style: .plain)
        //view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "ReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "reviewTableViewCell")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewTableViewCell") as! ReviewTableViewCell
        cell.delegate = self
        
         let review = FirebaseData.sharedInstance.currentUser?.reviews[indexPath.row]
        
        cell.reviewerNameLabel.text = currentUser.reviews[indexPath.row].reviewerName
        cell.reviewTextLabel.text = currentUser.reviews[indexPath.row].text
        cell.upvotesLabel.text = "Up: \(String((currentUser.reviews[indexPath.row].upvotes)!))"
        cell.downvotesLabel.text = "Down: \(String((currentUser.reviews[indexPath.row].downvotes)!))"
        cell.starRatingView.redraw(withRating: 4)
        
        for vote in (review?.votes)!{
            if((vote.type == "upvote") && (vote.voterUID == FirebaseData.sharedInstance.currentUser?.UID)){
                cell.upvoteButton.isSelected = true
            }
            
            if((vote.type == "downvote") && (vote.voterUID == FirebaseData.sharedInstance.currentUser?.UID)){
                cell.downvoteButton.isSelected = true
            }
        }
        
        //this should technically never run when we are viewing reviews from profileView
        if(review?.reviewerUID == FirebaseData.sharedInstance.currentUser?.UID){
            cell.reportDeleteButton.setTitle("Delete Review", for: .normal)
        }
        
        return cell
       
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentUser.reviews.count
    }
    
    func upvoteAction(_ sender: UIButton) {
        if let indexPath = getCurrentCellIndexPath(sender) {
            
            let cell = tableView.cellForRow(at: indexPath) as! ReviewTableViewCell
            
            let review = FirebaseData.sharedInstance.currentUser?.reviews[indexPath.row]
            
            if(cell.upvoteButton.isSelected){
                
                review?.upvotes! -= 1
                cell.upvoteButton.isSelected = false
                
                let index = review?.votes.index(where:{($0.voterUID == FirebaseData.sharedInstance.currentUser?.UID) && ($0.type == "upvote")})
                review?.votes.remove(at: index!)
            }
            else {
                review?.upvotes! += 1
                cell.upvoteButton.isSelected = true
                review?.votes.append(Vote(type: "upvote", voterUID: (FirebaseData.sharedInstance.currentUser?.UID)!))
            }
            
            WriteFirebaseData.write(user: FirebaseData.sharedInstance.currentUser!)
        }
        tableView.reloadData()
    }
    
    func downvoteAction(_ sender: UIButton) {
        if let indexPath = getCurrentCellIndexPath(sender) {
            
            let cell = tableView.cellForRow(at: indexPath) as! ReviewTableViewCell
            
            let review = FirebaseData.sharedInstance.currentUser?.reviews[indexPath.row]
            
            if(cell.downvoteButton.isSelected){
                
                review?.downvotes! += 1
                cell.downvoteButton.isSelected = false
                
                let index = review?.votes.index(where:{($0.voterUID == FirebaseData.sharedInstance.currentUser?.UID) && ($0.type == "downvote")})
                review?.votes.remove(at: index!)
            }
            else {
                review?.downvotes! -= 1
                cell.downvoteButton.isSelected = true
                
                review?.votes.append(Vote(type: "downvote", voterUID: (FirebaseData.sharedInstance.currentUser?.UID)!))
            }
            
            WriteFirebaseData.write(user: FirebaseData.sharedInstance.currentUser!)
        }
        tableView.reloadData()
    }
    
    func getCurrentCellIndexPath(_ sender: UIButton) -> IndexPath? {
        let buttonPosition = sender.convert(CGPoint.zero, to: tableView)
        if let indexPath: IndexPath = tableView.indexPathForRow(at: buttonPosition) {
            return indexPath
        }
        return nil
    }
    
}
