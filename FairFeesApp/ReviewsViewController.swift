//
//  ReviewsViewController.swift
//  FairFeesApp
//
//  Created by Sanjay Shah on 2018-03-28.
//  Copyright © 2018 Fair Fees. All rights reserved.
//

import UIKit

class ReviewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var currentUser: User!
    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        tableView = UITableView(frame: CGRect(x: 0, y: 40, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height-40)), style: .plain)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "ReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "reviewTableViewCell")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewTableViewCell") as! ReviewTableViewCell
        
        cell.reviewerNameLabel.text = currentUser.reviews[indexPath.row].reviewerName + " says:"
        cell.reviewTextLabel.text = currentUser.reviews[indexPath.row].text
        cell.upvotesLabel.text = "Up: \(String((currentUser.reviews[indexPath.row].upvotes)!))"
        cell.downvotesLabel.text = "Down: \(String((currentUser.reviews[indexPath.row].downvotes)!))"
        
        return cell
       
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentUser.reviews.count
    }
}
