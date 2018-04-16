//
//  MyReviewsTableViewController.swift
//  FairFeesApp
//
//  Created by Sanjay Shah on 2018-04-09.
//  Copyright © 2018 Fair Fees. All rights reserved.
//

import UIKit
import Firebase

class MyReviewsTableViewController: UITableViewController, ReviewTableViewCellDelegate {

    let storageRef = Storage.storage().reference()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.layer.borderColor = UIColor.black.cgColor
        tableView.layer.borderWidth = 3
        
        tableView.register(UINib(nibName: "ReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "reviewTableViewCell")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
       return (FirebaseData.sharedInstance.currentUser?.reviews.count)!
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewTableViewCell", for: indexPath) as! ReviewTableViewCell
        cell.delegate = self
        
        let review = FirebaseData.sharedInstance.currentUser?.reviews[indexPath.row]
        let reviewer = FirebaseData.sharedInstance.users.filter{ $0.UID == review?.reviewerUID}.first

        cell.reviewTextLabel.text = review?.text
        cell.reviewerProfileImageView.sd_setImage(with: storageRef.child((reviewer?.profileImageRef)!), placeholderImage: nil)
        cell.reviewerNameLabel.text = review?.reviewerName
        cell.upvotesLabel.text = String((review?.upvotes)!)
        cell.downvotesLabel.text = String((review?.downvotes)!)
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
            cell.reportDeleteButton.setTitle("Delete", for: .normal)
        }

        return cell
        
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

    
    func deleteReview(_ sender: UIButton) {
        print("This delegate method shouldnt run from this view controller, because we shouldnt be able to review ourselves anyways")
    }
    func getCurrentCellIndexPath(_ sender: UIButton) -> IndexPath? {
        let buttonPosition = sender.convert(CGPoint.zero, to: tableView)
        if let indexPath: IndexPath = tableView.indexPathForRow(at: buttonPosition) {
            return indexPath
        }
        return nil
    }
    
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

