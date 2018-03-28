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
    var ratingView: StarRatingView!
    var ratingsContainerView: UIView!
    var listings: [Listing]!
    var listingsTableView: UITableView!
    
    var reviewsButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        self.navigationController?.navigationBar.tintColor = UIColor.blue
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.black]
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
    }
    
    
    func setupButtons(){
        
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
        
        //nameLabel
        NSLayoutConstraint(item: nameLabel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 50).isActive = true
        NSLayoutConstraint(item: nameLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
  
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
