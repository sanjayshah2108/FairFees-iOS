//
//  ProfileViewController.swift
//  FairFeesApp
//
//  Created by Sanjay Shah on 2018-03-22.
//  Copyright © 2018 Fair Fees. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    var nameLabel: UILabel!
    var nameTextField: UITextField!
    var emailLabel: UILabel!
    var emailTextField: UITextField!
    var profileImageView: UIImageView!
    var phoneNumberLabel: UILabel!
    var phoneNumberTextField: UITextField!
    var listingsReviewsSegmentedControl: UISegmentedControl!
   

   // var listingsTableView: UITableView!
    var myHomeSales: [HomeSale]!
    var myHomeRentals: [HomeRental]!
    
    var childContainerView: UIView!
    var myListingsTableViewController: MyListingsTableViewController!
    var myReviewsTableViewController: MyReviewsTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Profile"
        view.backgroundColor = UIColor.white
        
        myHomeSales = []
        myHomeRentals = []
        
        for listing in (FirebaseData.sharedInstance.currentUser?.listings)! {
            if (listing is HomeSale){
                myHomeSales.append(listing as! HomeSale)
            }
            else if (listing is HomeRental){
                myHomeRentals.append(listing as! HomeRental)
            }
        }
        
        setupProfileImage()
        setupProfileLabels()
        setupSegmentedControl()
        setupChildViewControllers()
        //setupListingsTableView()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
         ReadFirebaseData.readCurrentUser(user: FirebaseData.sharedInstance.currentUser!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupProfileImage(){
        profileImageView = UIImageView()
        profileImageView.backgroundColor = UIColor.black
    }
    func setupProfileLabels(){
        
        nameLabel = UILabel()
        nameLabel.text = FirebaseData.sharedInstance.currentUser?.firstName
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        emailLabel = UILabel()
        emailLabel.text = FirebaseData.sharedInstance.currentUser?.email
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emailLabel)
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
    
    @objc func switchListingsReviewsTableView(){
        switch listingsReviewsSegmentedControl.selectedSegmentIndex {
        case 0:
            print("Slide in Listings")
            transition(from: myReviewsTableViewController, to: myListingsTableViewController, duration: 0.3, options: .curveEaseIn,
                       animations: nil,
                       completion: { finished in
                        //self.myReviewsTableViewController.removeFromParentViewController()
                        self.myListingsTableViewController.didMove(toParentViewController: self)
                        //self.addViewControllerAsChildViewController(childViewController: self.myListingsTableViewController)
            })
            
        case 1:
            print("Slide in Reviews")
            transition(from: myListingsTableViewController, to: myReviewsTableViewController, duration: 0.3, options: .curveEaseIn,
                       animations: nil,
                       completion: { finished in
                       // self.myListingsTableViewController.removeFromParentViewController()
                        
                        self.myReviewsTableViewController.didMove(toParentViewController: self)
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
        
        myReviewsTableViewController = MyReviewsTableViewController()
        self.addViewControllerAsChildViewController(childViewController: myReviewsTableViewController)

        myListingsTableViewController = MyListingsTableViewController()
        self.addViewControllerAsChildViewController(childViewController: myListingsTableViewController)
        
        
        
    }
    
    func addViewControllerAsChildViewController(childViewController: UIViewController){
        
        addChildViewController(childViewController)
        childContainerView.addSubview(childViewController.view)
        childViewController.view.frame = childContainerView.bounds
        childViewController.didMove(toParentViewController: self)
    }

//    func setupListingsTableView(){
//        
//        listingsTableView = UITableView()
//        listingsTableView.delegate = self
//        listingsTableView.dataSource = self
//        listingsTableView.layer.borderColor = UIColor.black.cgColor
//        listingsTableView.layer.borderWidth = 3
//        listingsTableView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(listingsTableView)
//        
//        listingsTableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "homeTableViewCell")
//    }
    
    func setupConstraints(){
        //nameLabel
        NSLayoutConstraint(item: nameLabel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 100).isActive = true
        NSLayoutConstraint(item: nameLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        //emailLabel
        NSLayoutConstraint(item: emailLabel, attribute: .top, relatedBy: .equal, toItem: nameLabel, attribute: .bottom, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: emailLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
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
        
//        //tableView
//        NSLayoutConstraint(item: listingsTableView, attribute: .top, relatedBy: .equal, toItem: emailLabel, attribute: .bottom, multiplier: 1, constant: 100).isActive = true
//        NSLayoutConstraint(item: listingsTableView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: listingsTableView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: listingsTableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    }
    

}
