//
//  ProfileViewController.swift
//  FairFeesApp
//
//  Created by Sanjay Shah on 2018-03-22.
//  Copyright © 2018 Fair Fees. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var nameLabel: UILabel!
    var emailLabel: UILabel!
   

    var listingsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Profile"
        view.backgroundColor = UIColor.white
        
        setupProfileLabels()
     
        setupListingsTableView()
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

    func setupListingsTableView(){
        
        listingsTableView = UITableView()
        listingsTableView.delegate = self
        listingsTableView.dataSource = self
        listingsTableView.layer.borderColor = UIColor.black.cgColor
        listingsTableView.layer.borderWidth = 3
        listingsTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(listingsTableView)
        
        listingsTableView.register(UINib(nibName: "ProfileListingsTableViewCell", bundle: nil), forCellReuseIdentifier: "profileListingTableViewCell")
    }
    
    func setupConstraints(){
        //nameLabel
        NSLayoutConstraint(item: nameLabel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 100).isActive = true
        NSLayoutConstraint(item: nameLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        //emailLabel
        NSLayoutConstraint(item: emailLabel, attribute: .top, relatedBy: .equal, toItem: nameLabel, attribute: .bottom, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: emailLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        //tableView
        NSLayoutConstraint(item: listingsTableView, attribute: .top, relatedBy: .equal, toItem: emailLabel, attribute: .bottom, multiplier: 1, constant: 100).isActive = true
        NSLayoutConstraint(item: listingsTableView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: listingsTableView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: listingsTableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (FirebaseData.sharedInstance.currentUser?.listings.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileListingTableViewCell") as! ProfileListingsTableViewCell
        
        cell.listingNameLabel.text = FirebaseData.sharedInstance.currentUser?.listings[indexPath.row].name
        cell.listingImageView.sd_setImage(with: Storage.storage().reference().child((FirebaseData.sharedInstance.currentUser?.listings[indexPath.row].photoRefs[0])!))
        cell.listingImageView.contentMode = .scaleAspectFill
        cell.listingImageView.clipsToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editPostViewController = EditPostViewController()
        editPostViewController.listingToEdit = FirebaseData.sharedInstance.currentUser?.listings[indexPath.row]
        
        self.navigationController?.pushViewController(editPostViewController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
