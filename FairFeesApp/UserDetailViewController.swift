//
//  UserDetailViewController.swift
//  FairFeesApp
//
//  Created by Sanjay Shah on 2018-03-26.
//  Copyright © 2018 Fair Fees. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    weak var currentUser: User!
    
    var nameLabel: UILabel!
    var userProfileImageView: UIImageView!
    var callButton: UIButton!
    var emailButton: UIButton!
    var ratingView: StarRatingView!
    var ratingsContainerView: UIView!
    var reviewCountLabel: UILabel!
    var listings: [Listing]!
    var listingsReviewsSegmentedControl: UISegmentedControl!
    var addReviewButton: UIButton!
    
    var childContainerView: UIView!
    var userListingsTableViewController: ListingsTableViewController!
    var userReviewsTableViewController: ReviewsTableViewController!


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        self.navigationController?.navigationBar.tintColor = UIColor.blue
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        setupUserProfileImage()
        setupLabels()
        setupRatingsView()
        setupSegmentedControl()
        setupChildViewControllers()
        setupButtons()
        setupConstraints()
    }

    func setupUserProfileImage(){
        userProfileImageView = UIImageView()
        userProfileImageView.backgroundColor = UIColor.gray
        userProfileImageView.layer.borderColor = UIColor.black.cgColor
        userProfileImageView.layer.borderWidth = 3
        userProfileImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userProfileImageView)
    }
    func setupLabels(){
        nameLabel = UILabel()
        nameLabel.backgroundColor = UIColor.white
        nameLabel.text = currentUser.firstName + " " + currentUser.lastName
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
    
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
        
        addReviewButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        addReviewButton.setTitle("Add a review", for: .normal)
        addReviewButton.setTitleColor(UIColor.blue, for: .normal)
        addReviewButton.addTarget(self, action: #selector(addReview), for: .touchUpInside)
        userReviewsTableViewController.tableView.tableFooterView = addReviewButton
        
        
//        reviewsButton = UIButton()
//        reviewsButton.setTitle("Reviews", for: .normal)
//        reviewsButton.setTitleColor(UIColor.blue, for: .normal)
//        reviewsButton.addTarget(self, action: #selector(segueToReviews), for: .touchUpInside)
//        reviewsButton.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(reviewsButton)
        
    }
    func setupRatingsView(){
        ratingsContainerView = UIView()
        ratingsContainerView.isUserInteractionEnabled = false
        ratingsContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        ratingView = StarRatingView()
        ratingView.redraw(withRating: currentUser.rating)
        ratingView.clipsToBounds = true
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        
        reviewCountLabel = UILabel()
        reviewCountLabel.text = String(currentUser.reviews.count)
        reviewCountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(reviewCountLabel)
        ratingsContainerView.addSubview(ratingView)
        view.addSubview(ratingsContainerView)
    }
    
    func setupSegmentedControl(){
        
        listingsReviewsSegmentedControl = UISegmentedControl()
        listingsReviewsSegmentedControl.insertSegment(withTitle: "Listings", at: 0, animated: false)
        listingsReviewsSegmentedControl.insertSegment(withTitle: "Reviews", at: 1, animated: false)
        listingsReviewsSegmentedControl.selectedSegmentIndex = 0
        listingsReviewsSegmentedControl.addTarget(self, action: #selector(switchListingsReviewsTableView), for: .valueChanged)
        listingsReviewsSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(listingsReviewsSegmentedControl)
    }
    
//    func setupTableView(){
//        listingsTableView = UITableView()
//        listingsTableView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(listingsTableView)
//        listingsTableView.delegate = self
//        listingsTableView.dataSource = self
//
//        listingsTableView.register(UINib(nibName: "UserDetailListingsTableViewCell", bundle: nil), forCellReuseIdentifier: "userDetailListingTableViewCell")
//    }
    
    @objc func switchListingsReviewsTableView(){
        switch listingsReviewsSegmentedControl.selectedSegmentIndex {
        case 0:
            print("Slide in Listings")
            transition(from: userReviewsTableViewController, to: userListingsTableViewController, duration: 0.3, options: .curveEaseIn,
                       animations: nil,
                       completion: { finished in
                        //self.myReviewsTableViewController.removeFromParentViewController()
                        self.userListingsTableViewController.didMove(toParentViewController: self)
                        //self.addViewControllerAsChildViewController(childViewController: self.myListingsTableViewController)
            })
            
        case 1:
            print("Slide in Reviews")
            transition(from: userListingsTableViewController, to: userReviewsTableViewController, duration: 0.3, options: .curveEaseIn,
                       animations: nil,
                       completion: { finished in
                        // self.myListingsTableViewController.removeFromParentViewController()
                        
                        self.userReviewsTableViewController.didMove(toParentViewController: self)
                        //self.addViewControllerAsChildViewController(childViewController: self.myReviewsTableViewController)
            })
        default:
            print("Shouldnt run")
        }
    }
    
    func setupChildViewControllers(){
        
        childContainerView = UIView()
        childContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(childContainerView)
        
        userReviewsTableViewController = ReviewsTableViewController()
        userReviewsTableViewController.currentUser = currentUser
        addViewControllerAsChildViewController(childViewController: userReviewsTableViewController)
        
        userListingsTableViewController = ListingsTableViewController()
        userListingsTableViewController.currentUser = currentUser
        addViewControllerAsChildViewController(childViewController: userListingsTableViewController)
    }
    
    func addViewControllerAsChildViewController(childViewController: UIViewController){
        
        addChildViewController(childViewController)
        childContainerView.addSubview(childViewController.view)
        childViewController.view.frame = childContainerView.bounds
        childViewController.didMove(toParentViewController: self)
    }

    
    func setupConstraints(){
        
        //userImageView
        NSLayoutConstraint(item: userProfileImageView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 100).isActive = true
        NSLayoutConstraint(item: userProfileImageView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: userProfileImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50).isActive = true
        NSLayoutConstraint(item: userProfileImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50).isActive = true
        
        //nameLabel
        NSLayoutConstraint(item: nameLabel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 100).isActive = true
        NSLayoutConstraint(item: nameLabel, attribute: .leading, relatedBy: .equal, toItem: userProfileImageView, attribute: .trailing, multiplier: 1, constant: 30).isActive = true
        
        //callButton
        NSLayoutConstraint(item: callButton, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 50).isActive = true
        NSLayoutConstraint(item: callButton, attribute: .trailing, relatedBy: .equal, toItem: emailButton, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: callButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 70).isActive = true
        NSLayoutConstraint(item: callButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
        
        //emailButton
        NSLayoutConstraint(item: emailButton, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 50).isActive = true
        NSLayoutConstraint(item: emailButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: emailButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 70).isActive = true
        NSLayoutConstraint(item: emailButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
        
      
  
//        //containerView
//        NSLayoutConstraint(item: ratingView, attribute: .top, relatedBy: .equal, toItem: nameLabel, attribute: .bottom, multiplier: 1, constant: 20).isActive = true
//        NSLayoutConstraint(item: ratingView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 30).isActive = true
//        NSLayoutConstraint(item: ratingView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 30).isActive = true
//        NSLayoutConstraint(item: ratingView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50).isActive = true
        
        //ratingsView
        NSLayoutConstraint(item: ratingView, attribute: .top, relatedBy: .equal, toItem: nameLabel, attribute: .bottom, multiplier: 1, constant: 80).isActive = true
        NSLayoutConstraint(item: ratingView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 50).isActive = true
        NSLayoutConstraint(item: ratingView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -50).isActive = true
        NSLayoutConstraint(item: ratingView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
        
        //reviewCountLabel
        NSLayoutConstraint(item: reviewCountLabel, attribute: .centerY, relatedBy: .equal, toItem: ratingView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: reviewCountLabel, attribute: .leading, relatedBy: .equal, toItem: ratingView, attribute: .trailing, multiplier: 1, constant: 20).isActive = true
        
        
        //reviewsButton
//        NSLayoutConstraint(item: reviewsButton, attribute: .top, relatedBy: .equal, toItem: ratingView, attribute: .bottom, multiplier: 1, constant: 20).isActive = true
//        NSLayoutConstraint(item: reviewsButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100).isActive = true
//        NSLayoutConstraint(item: reviewsButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: reviewsButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        
        //listingsReviewsSegmentedControl
        NSLayoutConstraint(item: listingsReviewsSegmentedControl, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25).isActive = true
        NSLayoutConstraint(item: listingsReviewsSegmentedControl, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: listingsReviewsSegmentedControl, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: listingsReviewsSegmentedControl, attribute: .bottom, relatedBy: .equal, toItem: childContainerView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        
        //containerView
        NSLayoutConstraint(item: childContainerView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: childContainerView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: childContainerView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: childContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        //reviewsTableview
//        NSLayoutConstraint(item: userReviewsTableViewController.tableView, attribute: .leading, relatedBy: .equal, toItem: childContainerView, attribute: .leading, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: userReviewsTableViewController.tableView, attribute: .trailing, relatedBy: .equal, toItem: childContainerView, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: userReviewsTableViewController.tableView, attribute: .top, relatedBy: .equal, toItem: childContainerView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        
        //addReviewButton
        //NSLayoutConstraint(item: addReviewButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
//        NSLayoutConstraint(item: addReviewButton, attribute: .leading, relatedBy: .equal, toItem: userReviewsTableViewController.tableView, attribute: .leading, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: addReviewButton, attribute: .trailing, relatedBy: .equal, toItem: userReviewsTableViewController.tableView, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: addReviewButton, attribute: .top, relatedBy: .equal, toItem: userReviewsTableViewController.tableView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: addReviewButton, attribute: .bottom, relatedBy: .equal, toItem: userReviewsTableViewController.view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        
        //tableViewController
//        NSLayoutConstraint(item: listingsTableView, attribute: .top, relatedBy: .equal, toItem: reviewsButton, attribute: .bottom, multiplier: 1, constant: 30).isActive = true
//        NSLayoutConstraint(item: listingsTableView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: listingsTableView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: listingsTableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
    }
    
    @objc func callAction(){
        
    }
    
    @objc func emailAction(){
        
    }
    
    @objc func addReview(){
        
    }
    
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return currentUser.listingsRefs.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "userDetailListingTableViewCell") as! UserDetailListingsTableViewCell
//
//        cell.listingNameLabel.text = currentUser.listings[indexPath.row].name
//
//        return cell
//    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
