//
//  UserDetailViewController.swift
//  FairFeesApp
//
//  Created by Sanjay Shah on 2018-03-26.
//  Copyright © 2018 Fair Fees. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    weak var currentUser: User!
    
    var nameLabel: UILabel!
    var userProfileImageView: UIImageView!
    var callButton: UIButton!
    var emailButton: UIButton!
    var ratingView: StarRatingView!
    var ratingsContainerView: UIView!
    var reviewCountLabel: UILabel!
    var listings: [Listing]!
    var listingsTableView: UITableView!
    
    var reviewsButton: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        self.navigationController?.navigationBar.tintColor = UIColor.blue
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        setupLabels()
        setupButtons()
        setupRatingsView()
        setupTableView()
        setupConstraints()
    }

    func setupLabels(){
        nameLabel = UILabel()
        nameLabel.backgroundColor = UIColor.white
        nameLabel.text = currentUser.firstName + " " + currentUser.lastName
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        userProfileImageView = UIImageView()
        userProfileImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userProfileImageView)
    }
    
    
    func setupButtons(){
        
        callButton = UIButton()
        callButton.setTitle("Call", for: .normal)
        callButton.setTitleColor(UIColor.blue, for: .normal)
        callButton.translatesAutoresizingMaskIntoConstraints = false
        callButton.addTarget(self, action: #selector(callAction), for: .touchUpInside)
        view.addSubview(callButton)
        
        emailButton = UIButton()
        emailButton.setTitle("Email", for: .normal)
        emailButton.setTitleColor(UIColor.blue, for: .normal)
        emailButton.translatesAutoresizingMaskIntoConstraints = false
        emailButton.addTarget(self, action: #selector(emailAction), for: .touchUpInside)
        view.addSubview(emailButton)
        
        reviewsButton = UIButton()
        reviewsButton.setTitle("Reviews", for: .normal)
        reviewsButton.setTitleColor(UIColor.blue, for: .normal)
        reviewsButton.addTarget(self, action: #selector(segueToReviews), for: .touchUpInside)
        reviewsButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(reviewsButton)
        
    }
    func setupRatingsView(){
        ratingsContainerView = UIView()
        ratingsContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        ratingView = StarRatingView()
        ratingView.clipsToBounds = true
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        
        reviewCountLabel = UILabel()
        reviewCountLabel.text = String(currentUser.reviews.count)
        reviewCountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(reviewCountLabel)
        ratingsContainerView.addSubview(ratingView)
        view.addSubview(ratingsContainerView)
    }
    
    func setupTableView(){
        listingsTableView = UITableView()
        listingsTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(listingsTableView)
        listingsTableView.delegate = self
        listingsTableView.dataSource = self
        
        listingsTableView.register(UINib(nibName: "UserDetailListingsTableViewCell", bundle: nil), forCellReuseIdentifier: "userDetailListingTableViewCell")
    }
    
    func setupConstraints(){
        
        //userImageView
        NSLayoutConstraint(item: userProfileImageView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 50).isActive = true
        NSLayoutConstraint(item: userProfileImageView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: userProfileImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50).isActive = true
        NSLayoutConstraint(item: userProfileImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50).isActive = true
        
        //nameLabel
        NSLayoutConstraint(item: nameLabel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 50).isActive = true
        NSLayoutConstraint(item: nameLabel, attribute: .leading, relatedBy: .equal, toItem: userProfileImageView, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        
        //callButton
        NSLayoutConstraint(item: callButton, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 50).isActive = true
        NSLayoutConstraint(item: callButton, attribute: .trailing, relatedBy: .equal, toItem: emailButton, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: callButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: callButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
        
        //emailButton
        NSLayoutConstraint(item: emailButton, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 50).isActive = true
        NSLayoutConstraint(item: emailButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: emailButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: emailButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
  
//        //containerView
//        NSLayoutConstraint(item: ratingView, attribute: .top, relatedBy: .equal, toItem: nameLabel, attribute: .bottom, multiplier: 1, constant: 20).isActive = true
//        NSLayoutConstraint(item: ratingView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 30).isActive = true
//        NSLayoutConstraint(item: ratingView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 30).isActive = true
//        NSLayoutConstraint(item: ratingView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50).isActive = true
        
        //ratingsView
        NSLayoutConstraint(item: ratingView, attribute: .top, relatedBy: .equal, toItem: nameLabel, attribute: .bottom, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: ratingView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 50).isActive = true
        NSLayoutConstraint(item: ratingView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -50).isActive = true
        NSLayoutConstraint(item: ratingView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
        
        //reviewCountLabel
        NSLayoutConstraint(item: reviewCountLabel, attribute: .centerY, relatedBy: .equal, toItem: ratingView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: reviewCountLabel, attribute: .leading, relatedBy: .equal, toItem: ratingView, attribute: .trailing, multiplier: 1, constant: 20).isActive = true
        
        
        //reviewsButton
        NSLayoutConstraint(item: reviewsButton, attribute: .top, relatedBy: .equal, toItem: ratingView, attribute: .bottom, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: reviewsButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100).isActive = true
        NSLayoutConstraint(item: reviewsButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: reviewsButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        
        
        
        //tableViewController
        NSLayoutConstraint(item: listingsTableView, attribute: .top, relatedBy: .equal, toItem: reviewsButton, attribute: .bottom, multiplier: 1, constant: 30).isActive = true
        NSLayoutConstraint(item: listingsTableView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: listingsTableView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: listingsTableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
    }
    
    @objc func callAction(){
        
    }
    
    @objc func emailAction(){
        
    }
    
    @objc func segueToReviews(){
        let reviewVC = ReviewsViewController()
        reviewVC.currentUser = currentUser
            
        self.navigationController?.pushViewController(reviewVC, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentUser.listingsRefs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userDetailListingTableViewCell") as! UserDetailListingsTableViewCell
        
        cell.listingNameLabel.text = currentUser.listings[indexPath.row].name
        
        return cell
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
