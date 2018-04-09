//
//  MyReviewsTableViewController.swift
//  FairFeesApp
//
//  Created by Sanjay Shah on 2018-04-09.
//  Copyright © 2018 Fair Fees. All rights reserved.
//

import UIKit

class MyReviewsTableViewController: UITableViewController {

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

        cell.reviewTextLabel.text = FirebaseData.sharedInstance.currentUser?.reviews[indexPath.row].text
        cell.reviewerNameLabel.text = FirebaseData.sharedInstance.currentUser?.reviews[indexPath.row].reviewerName
        cell.upvotesLabel.text = String((FirebaseData.sharedInstance.currentUser?.reviews[indexPath.row].upvotes)!)
        cell.downvotesLabel.text = String((FirebaseData.sharedInstance.currentUser?.reviews[indexPath.row].downvotes)!)

        return cell
        
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
