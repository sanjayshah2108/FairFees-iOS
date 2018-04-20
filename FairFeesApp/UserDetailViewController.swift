//
//  UserDetailViewController.swift
//  FairFeesApp
//
//  Created by Sanjay Shah on 2018-03-26.
//  Copyright © 2018 Fair Fees. All rights reserved.
//

import UIKit
import MessageUI
import Firebase

class UserDetailViewController: UIViewController, UITextViewDelegate, MFMailComposeViewControllerDelegate {
    
    let storageRef = Storage.storage().reference()
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
    
    var newReviewContainerView: UIView!
    var newReviewTextView: UITextView!
    var newReviewSubmitButton: UIButton!
    var newReviewCancelButton: UIButton!
    var newReviewStarRatingView: StarRatingView!
    var newReviewStarRatingContainerView: UIView!


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
        userProfileImageView.sd_setImage(with: storageRef.child(currentUser.profileImageRef), placeholderImage: nil)
        userProfileImageView.backgroundColor = UIColor.gray
        userProfileImageView.layer.borderColor = UIColor.black.cgColor
        userProfileImageView.layer.borderWidth = 3
        userProfileImageView.contentMode = .scaleAspectFill
        userProfileImageView.clipsToBounds = true
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
        callButton.addTarget(self, action: #selector(callUser), for: .touchUpInside)
        view.addSubview(callButton)
        
        emailButton = UIButton()
        emailButton.setTitle("Email", for: .normal)
        emailButton.setTitleColor(UIColor.blue, for: .normal)
        emailButton.translatesAutoresizingMaskIntoConstraints = false
        emailButton.addTarget(self, action: #selector(emailUser), for: .touchUpInside)
        view.addSubview(emailButton)
        
        addReviewButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        addReviewButton.setTitle("Add a review", for: .normal)
        addReviewButton.setTitleColor(UIColor.blue, for: .normal)
        addReviewButton.addTarget(self, action: #selector(addReview), for: .touchUpInside)
        userReviewsTableViewController.tableView.tableFooterView = addReviewButton
        
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

    @objc func switchListingsReviewsTableView(){
        switch listingsReviewsSegmentedControl.selectedSegmentIndex {
        case 0:
            print("Slide in Listings")
            transition(from: userReviewsTableViewController, to: userListingsTableViewController, duration: 0.3, options: .curveEaseIn,
                       animations: nil,
                       completion: { finished in
                        self.userListingsTableViewController.didMove(toParentViewController: self)
            })
            
        case 1:
            print("Slide in Reviews")
            transition(from: userListingsTableViewController, to: userReviewsTableViewController, duration: 0.3, options: .curveEaseIn,
                       animations: nil,
                       completion: { finished in
                        self.userReviewsTableViewController.didMove(toParentViewController: self)
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
        

        //ratingsView
        NSLayoutConstraint(item: ratingView, attribute: .top, relatedBy: .equal, toItem: nameLabel, attribute: .bottom, multiplier: 1, constant: 80).isActive = true
        NSLayoutConstraint(item: ratingView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 50).isActive = true
        NSLayoutConstraint(item: ratingView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -50).isActive = true
        NSLayoutConstraint(item: ratingView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
        
        //reviewCountLabel
        NSLayoutConstraint(item: reviewCountLabel, attribute: .centerY, relatedBy: .equal, toItem: ratingView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: reviewCountLabel, attribute: .leading, relatedBy: .equal, toItem: ratingView, attribute: .trailing, multiplier: 1, constant: 20).isActive = true
        
        
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
        
        
    }
    
    @objc func callUser(){
        
        guard let number = URL(string: "tel://" + "\(currentUser.phoneNumber)") else { return }
        UIApplication.shared.open(number)
    }
    
    @objc func emailUser(){
        
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self

        //show error if the VC cant send mail
        if MFMailComposeViewController.canSendMail()
        {
            self.present(mailComposerVC, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
        
        sendMail(mailComposerVC: mailComposerVC)
    }
    
    func sendMail(mailComposerVC: MFMailComposeViewController){
        
        let destinationEmail = currentUser.email
        let destinationName = currentUser.firstName
        
        let currentUserName = FirebaseData.sharedInstance.currentUser!.firstName
    
        //mailVC properties
        mailComposerVC.setToRecipients([destinationEmail])
        mailComposerVC.setSubject("U-List: Listings inquiry")
        mailComposerVC.setMessageBody("Hey \(destinationName),\n\nI'm interested in some of your listings.\n\nThanks!\n\n\(currentUserName)", isHTML: false)
        
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController.init(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        switch result {
        case .cancelled:
            break
            
        case .saved:
            print ("Go back")
            
        case .sent:
            print ("Go back")
            
        case .failed:
            print ("Mail sent failure: \([error!.localizedDescription])")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func addReview(){
        

        //container view
        newReviewContainerView = UIView()
        newReviewContainerView.isUserInteractionEnabled = true
        newReviewContainerView.backgroundColor = UIColor.white
        newReviewContainerView.layer.cornerRadius = 5
        newReviewContainerView.layer.borderColor = UIColor.lightGray.cgColor
        newReviewContainerView.layer.borderWidth = 1
        newReviewContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(newReviewContainerView)
       
 
        //textField
        newReviewTextView = UITextView()
        newReviewTextView.delegate = self
        newReviewTextView.text = "Add a review"
        newReviewTextView.textAlignment = .center
        newReviewTextView.textColor = UIColor.gray
        newReviewTextView.layer.cornerRadius = 3
        newReviewTextView.layer.borderColor = UIColor.lightGray.cgColor
        newReviewTextView.layer.borderWidth = 1
        newReviewTextView.translatesAutoresizingMaskIntoConstraints = false
        newReviewContainerView.addSubview(newReviewTextView)
        
        //submit button
        newReviewSubmitButton = UIButton()
        newReviewSubmitButton.setTitle("Submit", for: .normal)
        newReviewSubmitButton.setTitleColor(UIColor.blue, for: .normal)
        newReviewSubmitButton.addTarget(self, action: #selector(submitNewReview), for: .touchUpInside)
        newReviewSubmitButton.translatesAutoresizingMaskIntoConstraints = false
        newReviewContainerView.addSubview(newReviewSubmitButton)
        
        //cancelButton
        newReviewCancelButton = UIButton()
        newReviewCancelButton.setTitle("Cancel", for: .normal)
        newReviewCancelButton.setTitleColor(UIColor.blue, for: .normal)
        newReviewCancelButton.addTarget(self, action: #selector(cancelNewReview), for: .touchUpInside)
        newReviewCancelButton.translatesAutoresizingMaskIntoConstraints = false
        newReviewContainerView.addSubview(newReviewCancelButton)
        
        //starRatingContainerView
        newReviewStarRatingContainerView = UIView()
        newReviewStarRatingContainerView.translatesAutoresizingMaskIntoConstraints = false
        newReviewContainerView.addSubview(newReviewStarRatingContainerView)
        
        //starRating
        newReviewStarRatingView = StarRatingView()
        newReviewStarRatingView.translatesAutoresizingMaskIntoConstraints = false
        newReviewStarRatingContainerView.addSubview(newReviewStarRatingView)
        
        setupNewReviewConstraints()
        
        //newReviewTextView.becomeFirstResponder()
    }
    
    func setupNewReviewConstraints(){
    
        
        //container view
        NSLayoutConstraint(item: newReviewContainerView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: newReviewContainerView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 100).isActive = true
        NSLayoutConstraint(item: newReviewContainerView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant:300).isActive = true
        NSLayoutConstraint(item: newReviewContainerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300).isActive = true
        
        //starRatingContainerView
        NSLayoutConstraint(item: newReviewStarRatingContainerView, attribute: .top, relatedBy: .equal, toItem: newReviewContainerView, attribute: .top, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: newReviewStarRatingContainerView, attribute: .leading, relatedBy: .equal, toItem: newReviewContainerView, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: newReviewStarRatingContainerView, attribute: .trailing, relatedBy: .equal, toItem: newReviewContainerView, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: newReviewStarRatingContainerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
        
        //starRating
        NSLayoutConstraint(item: newReviewStarRatingView, attribute: .top, relatedBy: .equal, toItem: newReviewStarRatingContainerView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: newReviewStarRatingView, attribute: .leading, relatedBy: .equal, toItem: newReviewStarRatingContainerView, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: newReviewStarRatingView, attribute: .trailing, relatedBy: .equal, toItem: newReviewStarRatingContainerView, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: newReviewStarRatingView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
        
        //textField
        NSLayoutConstraint(item: newReviewTextView, attribute: .top, relatedBy: .equal, toItem: newReviewStarRatingView, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: newReviewTextView, attribute: .leading, relatedBy: .equal, toItem: newReviewContainerView, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: newReviewTextView, attribute: .trailing, relatedBy: .equal, toItem: newReviewContainerView, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: newReviewTextView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 80).isActive = true
        
        //submit button
        NSLayoutConstraint(item: newReviewSubmitButton, attribute: .top, relatedBy: .equal, toItem: newReviewTextView, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: newReviewSubmitButton, attribute: .leading, relatedBy: .equal, toItem: newReviewContainerView, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: newReviewSubmitButton, attribute: .trailing, relatedBy: .equal, toItem: newReviewContainerView, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: newReviewSubmitButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true

        //cancelButton
        NSLayoutConstraint(item: newReviewCancelButton, attribute: .top, relatedBy: .equal, toItem: newReviewSubmitButton, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: newReviewCancelButton, attribute: .leading, relatedBy: .equal, toItem: newReviewContainerView, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: newReviewCancelButton, attribute: .trailing, relatedBy: .equal, toItem: newReviewContainerView, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: newReviewCancelButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
  
        
        
    }
    
    @objc func cancelNewReview(){
        
        for subview in newReviewContainerView.subviews{
            subview.removeFromSuperview()
        }
        
        newReviewContainerView.isHidden = true
        newReviewContainerView = nil
    }
    
    @objc func submitNewReview(){
        
        guard (newReviewStarRatingView.rating != nil) else {
            
            present(AlertDefault.showAlert(title: "Sorry", message: "You must add a rating"), animated: true, completion: nil)
            return
        }
        
        guard (newReviewTextView.text != "") else {
            
            present(AlertDefault.showAlert(title: "Sorry", message: "Your review is empty"), animated: true, completion: nil)
            return
        }
        
        
        //by using users UID as the reviewUID, a user can only review someone once!
        let newReview = Review(uid: (FirebaseData.sharedInstance.currentUser?.UID)!, text: newReviewTextView.text, upvotes: 0, downvotes: 0, reviewerUID: (FirebaseData.sharedInstance.currentUser?.UID)!, reviewerName: (FirebaseData.sharedInstance.currentUser?.firstName)! + " " + (FirebaseData.sharedInstance.currentUser?.lastName)!, rating: newReviewStarRatingView.rating, votes: [])
        
        currentUser.reviews.append(newReview)
        
        var sumOfRatings = 0
        
        for review in currentUser.reviews {
           sumOfRatings = sumOfRatings + review.rating
        }
        
        let avgOfRatings = sumOfRatings/currentUser.reviews.count
        currentUser.rating = avgOfRatings
        
        WriteFirebaseData.write(user: currentUser)
        
        present(AlertDefault.showAlert(title: "Success", message: "Your review has been submitted"), animated: true, completion: nil)
        
        userReviewsTableViewController.tableView.reloadData()
        
        for subview in newReviewContainerView.subviews{
            subview.removeFromSuperview()
        }
        
        newReviewContainerView.isHidden = true
        newReviewContainerView = nil
        
    }
    
    //textView delegate methods
    func textViewDidBeginEditing (_ textView: UITextView) {
        
        if newReviewTextView.textColor == .lightGray && newReviewTextView.isFirstResponder {
            newReviewTextView.text = ""
            newReviewTextView.textColor = .black
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
