//
//  ListingDetailViewController.swift
//  FairFeesApp
//
//  Created by Sanjay Shah on 2018-03-07.
//  Copyright © 2018 Fair Fees. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps
import FirebaseStorageUI
import MessageUI

class ListingDetailViewController: UIViewController, GMSMapViewDelegate, UIScrollViewDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {

    var navigationBarHeight: CGFloat!
    
    var storageRef: StorageReference!
    weak var currentListing: Listing!
    weak var currentHomeSale: HomeSale!
    weak var currentHomeRental: HomeRental!
    weak var posterUser: User!
    weak var landlordUser: User!

    var imageViewCarousel: UIImageView!
    var imageViewPageControl: UIPageControl!
    var addressLabel: UILabel!
    var descriptionLabel: UILabel!
    var mapView: GMSMapView!
    var distanceLabel: UILabel!
    var directionsButton: UIButton!
    var landlordButton: UIButton!
    var posterButton: UIButton!
    
    var shareBarButton: UIBarButtonItem!
    
    var contactButtonsStackView: UIStackView!
    var callButton: UIButton!
    var emailButton: UIButton!
    var compareButton: UIButton!
    
    var detailsScrollView: UIScrollView!
    var scrollContentView: UIView!
    
    var featuresView: UIView!
    var featuresHorizontalStackView: UIStackView!
    var priceLabel: UILabel!
    var sizeLabel: UILabel!
    var bedroomLabel: UILabel!
    var bathroomLabel: UILabel!
    var yearBuiltLabel: UILabel!
    
    var imageViewCarouselLeftSwipeGesture: UISwipeGestureRecognizer!
    var imageViewCarouselRightSwipeGesture: UISwipeGestureRecognizer!
    var imageViewCarouselExpandPinchGesture: UIPinchGestureRecognizer!
    var imageViewCarouselExpandTapGesture: UITapGestureRecognizer!
    
    var enlargedMapTopConstraint: NSLayoutConstraint!
    var enlargedMapHeightConstraint: NSLayoutConstraint!
    var minimizedMapTopConstraint: NSLayoutConstraint!
    var minimizedMapHeightConstraint: NSLayoutConstraint!
    
    var enlargedImageContainerView: UIView!
    var tempImageView: UIImageView!
    var newImageView: ImageScrollView!
    
    var photoIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.clipsToBounds = true
        view.backgroundColor = UIColor.white
        navigationBarHeight = self.navigationController?.navigationBar.frame.height
        
        storageRef = Storage.storage().reference()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        
        posterUser = FirebaseData.sharedInstance.users.first(where: { $0.UID == currentListing.posterUID })
        
        setupImageView()
        setupButtons()
        setupScrollView()
        setupLabels()
        setupMapView()
        
        setupConstraints()
        //view.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    override func viewDidLayoutSubviews() {
        
       // scrollContentView.layoutIfNeeded() //set a frame based on constraints
        detailsScrollView.contentSize = CGSize(width: scrollContentView.frame.width, height: scrollContentView.frame.height)
        detailsScrollView.setNeedsLayout()
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setupImageView(){
        let storageRef = Storage.storage().reference()
        imageViewCarousel = UIImageView()
        imageViewCarousel.isUserInteractionEnabled = true
        photoIndex = 0
        imageViewCarousel.sd_setImage(with: storageRef.child(currentListing.photoRefs[photoIndex]), placeholderImage: nil)
        
        imageViewCarousel.contentMode = .scaleAspectFill
        imageViewCarousel.clipsToBounds = true
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 300)
        gradient.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        gradient.locations = [0.0, 0.7]
        imageViewCarousel.layer.addSublayer(gradient)
        
        imageViewCarousel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageViewCarousel)
    
        imageViewCarouselLeftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeThroughImages))
        imageViewCarouselLeftSwipeGesture.direction = .left
        imageViewCarousel.addGestureRecognizer(imageViewCarouselLeftSwipeGesture)
        imageViewCarouselRightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeThroughImages))
        imageViewCarouselRightSwipeGesture.direction = .right
        imageViewCarousel.addGestureRecognizer(imageViewCarouselRightSwipeGesture)
        imageViewCarouselExpandTapGesture = UITapGestureRecognizer(target: self, action: #selector(fullscreenImage))
        imageViewCarousel.addGestureRecognizer(imageViewCarouselExpandTapGesture)
        imageViewCarouselExpandPinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchImageToFullscreen))
        
        imageViewCarousel.addGestureRecognizer(imageViewCarouselExpandPinchGesture)
        
        imageViewPageControl = UIPageControl()
        imageViewPageControl.currentPage = 0
        imageViewPageControl.numberOfPages = currentListing.photoRefs.count
        imageViewPageControl.pageIndicatorTintColor = UIColor.gray
        imageViewPageControl.currentPageIndicatorTintColor = UIColor.white
        imageViewPageControl.translatesAutoresizingMaskIntoConstraints = false
        imageViewCarousel.addSubview(imageViewPageControl)
    }
    
    func setupButtons(){
    
        shareBarButton = UIBarButtonItem(barButtonSystemItem: .action , target: self, action: #selector(shareListing))
        self.navigationItem.rightBarButtonItem = shareBarButton
        
        posterButton = UIButton()
        posterButton.setTitle("Listed by: \(posterUser.displayName)", for: .normal)
        posterButton.setTitleColor(UIColor.white, for: .normal)
        posterButton.backgroundColor = UIColor.blue
        posterButton.translatesAutoresizingMaskIntoConstraints = false
        posterButton.addTarget(self, action: #selector(segueToPosterUser), for: .touchUpInside)
        view.addSubview(posterButton)
        
        landlordButton = UIButton()
        landlordButton.setTitleColor(UIColor.blue, for: .normal)
        landlordButton.translatesAutoresizingMaskIntoConstraints = false
        landlordButton.addTarget(self, action: #selector(segueToLandlordUser), for: .touchUpInside)
      
        if(currentListing.isKind(of: HomeRental.self)){
            let currentHomeRental = currentListing as! HomeRental
            landlordButton.setTitle("Poster: \(currentHomeRental.landlordUID)", for: .normal)
        }
        else if (currentListing.isKind(of: HomeSale.self)){
            let currentHomeSale = currentListing as! HomeSale
            landlordButton.setTitle("Poster: \(currentHomeSale.ownerUID)", for: .normal)
        }
        
        setupContactButtons()
    }

    
    func setupContactButtons(){
        contactButtonsStackView = UIStackView()
        contactButtonsStackView.axis = .horizontal
        contactButtonsStackView.distribution = .fillEqually
        contactButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contactButtonsStackView)
        
        callButton = UIButton()
        callButton.setTitle("Call", for: .normal)
        callButton.setTitleColor(UIColor.white, for: .normal)
        callButton.backgroundColor = UIColor.blue
        callButton.addTarget(self, action: #selector(callPoster), for: .touchUpInside)
        contactButtonsStackView.addArrangedSubview(callButton)
        
        emailButton = UIButton()
        emailButton.setTitle("Email", for: .normal)
        emailButton.setTitleColor(UIColor.white, for: .normal)
        emailButton.backgroundColor = UIColor.blue
        emailButton.addTarget(self, action: #selector(emailPoster), for: .touchUpInside)
        contactButtonsStackView.addArrangedSubview(emailButton)
        
        compareButton = UIButton()
        compareButton.setTitle("Compare", for: .normal)
        compareButton.setTitleColor(UIColor.white, for: .normal)
        compareButton.backgroundColor = UIColor.blue
        compareButton.addTarget(self, action: #selector(addListingForComparison), for: .touchUpInside)
        contactButtonsStackView.addArrangedSubview(compareButton)
        
    }
    
    func setupScrollView(){
        
        detailsScrollView = UIScrollView()
        detailsScrollView.delegate = self
        detailsScrollView.translatesAutoresizingMaskIntoConstraints = false
        detailsScrollView.backgroundColor = .white
        //detailScrollView.contentSize = CGSize(width: view.frame.width, height: 500)
        view.addSubview(detailsScrollView)
        
        //contentScrollView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        scrollContentView = UIView()
        scrollContentView.backgroundColor = UIColor.white
        scrollContentView.translatesAutoresizingMaskIntoConstraints = false
        detailsScrollView.addSubview(scrollContentView)
        
        featuresView = UIView()
        featuresView.backgroundColor = UIColor.white
        featuresView.layer.borderWidth = 1
        featuresView.layer.borderColor = UIProperties.sharedUIProperties.primaryBlackColor.cgColor
        featuresView.translatesAutoresizingMaskIntoConstraints = false
        scrollContentView.addSubview(featuresView)

    }

    func setupLabels(){
        
        priceLabel = UILabel()
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.textAlignment = .center
        featuresView.addSubview(priceLabel)
    
        setupStackView()
        
        descriptionLabel = UILabel()
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.backgroundColor = UIColor.white
        scrollContentView.addSubview(descriptionLabel)
        descriptionLabel.text = currentListing.listingDescription
        
    }
    
    func setupStackView(){
        
        featuresHorizontalStackView = UIStackView()
        featuresHorizontalStackView.axis = .horizontal
        featuresHorizontalStackView.distribution = .fillProportionally
        featuresHorizontalStackView.layer.borderWidth = 1
        featuresHorizontalStackView.layer.borderColor = UIColor.black.cgColor
        featuresHorizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        featuresView.addSubview(featuresHorizontalStackView)
        
        sizeLabel = UILabel()
        bedroomLabel = UILabel()
        bathroomLabel = UILabel()
        yearBuiltLabel = UILabel()
        
        sizeLabel.textAlignment = .center
        bedroomLabel.textAlignment = .center
        bathroomLabel.textAlignment = .center
        yearBuiltLabel.textAlignment = .center
        
        sizeLabel.translatesAutoresizingMaskIntoConstraints = false
        bedroomLabel.translatesAutoresizingMaskIntoConstraints = false
        bathroomLabel.translatesAutoresizingMaskIntoConstraints = false
        yearBuiltLabel.translatesAutoresizingMaskIntoConstraints = false
        
        featuresHorizontalStackView.addArrangedSubview(bedroomLabel)
        featuresHorizontalStackView.addArrangedSubview(bathroomLabel)
        featuresHorizontalStackView.addArrangedSubview(yearBuiltLabel)
        featuresHorizontalStackView.addArrangedSubview(sizeLabel)
        
        if(currentListing.isKind(of: HomeRental.self)){
            let currentHomeRental = currentListing as! HomeRental
            
            priceLabel.text = "$\(currentHomeRental.monthlyRent!)/month"
            sizeLabel.text = "\(currentHomeRental.size!) sqft"
            bedroomLabel.text = "\(currentHomeRental.bedroomNumber!) beds"
            bathroomLabel.text = "\(currentHomeRental.bathroomNumber!) baths"
            yearBuiltLabel.text = "1111"
            
        }
        else if (currentListing.isKind(of: HomeSale.self)){
            let currentHomeSale = currentListing as! HomeSale
            
            priceLabel.text = "$\(currentHomeSale.price!)"
            sizeLabel.text = "\(currentHomeSale.size!) sqft"
            bedroomLabel.text = "\(currentHomeSale.bedroomNumber!) beds"
            bathroomLabel.text = "\(currentHomeSale.bathroomNumber!) baths"
            yearBuiltLabel.text = "1111"
        }
    }

    func setupMapView(){
        
        mapView = GMSMapView()
        mapView.delegate = self
        
        let camera = GMSCameraPosition.camera(withLatitude: currentListing.coordinate.latitude, longitude: currentListing.coordinate.longitude, zoom: 15.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: currentListing.coordinate.latitude, longitude: currentListing.coordinate.longitude)
        marker.map = mapView
        
        directionsButton = UIButton()
        directionsButton.addTarget(self, action: #selector(showDirections), for: .touchUpInside)
        directionsButton.setTitle("D", for: .normal)
        directionsButton.setTitle("C", for: .selected)
        directionsButton.setTitleColor(UIColor.blue, for: .normal)
        directionsButton.setTitleColor(UIColor.red, for: .selected)
        directionsButton.backgroundColor = UIColor.white
        directionsButton.layer.cornerRadius = 5
        
        directionsButton.translatesAutoresizingMaskIntoConstraints = false
        mapView.addSubview(directionsButton)
        
        distanceLabel = UILabel()
        distanceLabel.backgroundColor = UIColor.white
        distanceLabel.layer.cornerRadius = 10
        distanceLabel.textAlignment = .center
        distanceLabel.isHidden = true
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        mapView.addSubview(distanceLabel)
    
    }
    
    func setupConstraints(){
        
        //imageViewCarousel
        NSLayoutConstraint(item: imageViewCarousel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: imageViewCarousel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: imageViewCarousel, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: imageViewCarousel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: view.frame.height/3).isActive = true
        
        
        //imageViewPageControl
        NSLayoutConstraint(item: imageViewPageControl, attribute: .bottom, relatedBy: .equal, toItem: imageViewCarousel, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: imageViewPageControl, attribute: .centerX, relatedBy: .equal, toItem: imageViewCarousel, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: imageViewPageControl, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: imageViewPageControl, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        
        
        //scrollView
        NSLayoutConstraint(item: detailsScrollView, attribute: .top, relatedBy: .equal, toItem: imageViewCarousel, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: detailsScrollView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: detailsScrollView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: detailsScrollView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 500).isActive = true
        
        //scrollContentView
        NSLayoutConstraint(item: scrollContentView, attribute: .top, relatedBy: .equal, toItem: imageViewCarousel, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: scrollContentView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: view.frame.width).isActive = true
        NSLayoutConstraint(item: scrollContentView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        
        //featuresView
        NSLayoutConstraint(item: featuresView, attribute: .top, relatedBy: .equal, toItem: scrollContentView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: featuresView, attribute: .leading, relatedBy: .equal, toItem: scrollContentView, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: featuresView, attribute: .trailing, relatedBy: .equal, toItem: scrollContentView, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        
        

        //priceLabel
        NSLayoutConstraint(item: priceLabel, attribute: .top, relatedBy: .equal, toItem: featuresView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: priceLabel, attribute: .leading, relatedBy: .equal, toItem: featuresView, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: priceLabel, attribute: .trailing, relatedBy: .equal, toItem: featuresView, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: priceLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
        
        
        //horizontalStackView
        NSLayoutConstraint(item: featuresHorizontalStackView, attribute: .top, relatedBy: .equal, toItem: priceLabel, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: featuresHorizontalStackView, attribute: .leading, relatedBy: .equal, toItem: featuresView, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: featuresHorizontalStackView, attribute: .trailing, relatedBy: .equal, toItem: featuresView, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: featuresHorizontalStackView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60).isActive = true
        NSLayoutConstraint(item: featuresHorizontalStackView, attribute: .bottom, relatedBy: .equal, toItem: featuresView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    
        
        //descriptionLabel
        NSLayoutConstraint(item: descriptionLabel, attribute: .top, relatedBy: .equal, toItem: featuresHorizontalStackView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: descriptionLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: descriptionLabel, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: descriptionLabel, attribute: .bottom, relatedBy: .equal , toItem: scrollContentView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        //NSLayoutConstraint(item: descriptionLabel, attribute: .height, relatedBy: .greaterThanOrEqual , toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
    
        
        //posterButton
        NSLayoutConstraint(item: posterButton, attribute: .top, relatedBy: .equal, toItem: detailsScrollView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: posterButton, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: posterButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: posterButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
        
        //mapView
        //NSLayoutConstraint(item: mapView, attribute: .bottom, relatedBy: .equal, toItem: contactButtonsStackView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mapView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mapView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        minimizedMapTopConstraint = NSLayoutConstraint(item: mapView, attribute: .top, relatedBy: .equal, toItem: posterButton, attribute: .bottom, multiplier: 1, constant: 0)
        minimizedMapHeightConstraint = NSLayoutConstraint(item: mapView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 0.2, constant: 0)
        NSLayoutConstraint.activate([minimizedMapTopConstraint, minimizedMapHeightConstraint])
        
        
        //directionsButton
        NSLayoutConstraint(item: directionsButton, attribute: .top, relatedBy: .equal, toItem: mapView, attribute: .top, multiplier: 1, constant: 25).isActive = true
        NSLayoutConstraint(item: directionsButton, attribute: .trailing, relatedBy: .equal, toItem: mapView, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: directionsButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
        NSLayoutConstraint(item: directionsButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
        
        //distanceLabel
        NSLayoutConstraint(item: distanceLabel, attribute: .centerX, relatedBy: .equal, toItem: mapView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: distanceLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 70).isActive = true
        NSLayoutConstraint(item: distanceLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
        NSLayoutConstraint(item: distanceLabel, attribute: .bottom, relatedBy: .equal, toItem: mapView, attribute: .bottom, multiplier: 1, constant: -10).isActive = true
        
        
        //contactButtonsStackView
        NSLayoutConstraint(item: contactButtonsStackView, attribute: .top, relatedBy: .equal, toItem: mapView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: contactButtonsStackView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: contactButtonsStackView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: contactButtonsStackView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: contactButtonsStackView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
        
    }
    
    @objc func shareListing(){
        print("Share")
        
        
        let destinationUser = FirebaseData.sharedInstance.users.filter{ $0.UID == currentListing.posterUID }.first
        
        let messageController = MFMessageComposeViewController()
        messageController.messageComposeDelegate = self
        
        if (MFMessageComposeViewController.canSendText()) {
            self.present(messageController, animated: true, completion: nil)
        }
        else {
            self.showSendTextErrorAlert()
        }
        
        
        sendText(messageComposerVC: messageController)
    }
    
    func sendText(messageComposerVC: MFMessageComposeViewController){
        
        let destinationUser = FirebaseData.sharedInstance.users.filter{ $0.UID == currentListing.posterUID }.first
        
        let destinationName = destinationUser!.displayName
        let destinationPhoneNumber = String((destinationUser!.phoneNumber))
        
        let currentUserName = FirebaseData.sharedInstance.currentUser!.displayName
        let currentUserID = FirebaseData.sharedInstance.currentUser!.UID
        let currentListingName = currentListing.name
        let currentListingUID = currentListing.UID
 
        messageComposerVC.recipients = [destinationPhoneNumber]
        
        messageComposerVC.body = "Hey \(destinationName),\n\nPlease click the link below!\n\niOSFairFeesApp://?listingUID=\(currentListingUID!)\n\nThanks! :)\n\n"
    }
    
    func showSendTextErrorAlert() {
        let sendMailErrorAlert = UIAlertController.init(title: "Could Not Send Text", message: "Your device could not send a text.  Please check your message configuration and try again.", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        switch result {
        case .cancelled:
            break
            
        case .sent:
            //self.performSegue(withIdentifier: "unwindToInitialVC", sender: self)
            print ("Go back to mapView")
            
        case .failed:
            print ("Message sent failure")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func nextImage(imageView: UIImageView, pageControl: UIPageControl){
        if (photoIndex == currentListing.photoRefs.count-1){
            photoIndex = 0
            pageControl.currentPage = 0
        }
        else {
            photoIndex = photoIndex + 1
            pageControl.currentPage += 1
        }
        imageView.sd_setImage(with: storageRef.child(currentListing.photoRefs![photoIndex!]), placeholderImage: #imageLiteral(resourceName: "placeholderImage"))
    }
    
    func previousImage(imageView: UIImageView, pageControl: UIPageControl){
        if (photoIndex == 0){
            photoIndex = currentListing.photoRefs.count-1
            pageControl.currentPage = currentListing.photoRefs.count-1
        }
        else {
            photoIndex = photoIndex - 1
            pageControl.currentPage -= 1
        }
       imageView.sd_setImage(with: storageRef.child(currentListing.photoRefs[photoIndex]), placeholderImage: #imageLiteral(resourceName: "placeholderImage"))
    }

    @objc func swipeThroughImages(gesture: UISwipeGestureRecognizer){
    
        if (gesture.direction == .left){
            nextImage(imageView: imageViewCarousel, pageControl: imageViewPageControl)
            print("swiped left")
        }
        
        else if (gesture.direction == .right){
            previousImage(imageView: imageViewCarousel, pageControl: imageViewPageControl)
            print("swiped right")
        }
    }
    
    @objc func segueToPosterUser(sender: UIButton){
        
        let userDetailViewController = UserDetailViewController()
        userDetailViewController.currentUser = posterUser
        
        self.navigationController?.pushViewController(userDetailViewController, animated: true)
    }
    
    @objc func segueToLandlordUser(sender: UIButton){
        
        let userDetailViewController = UserDetailViewController()
        userDetailViewController.currentUser = landlordUser
        
        self.navigationController?.pushViewController(userDetailViewController, animated: true)
    }
    
    @objc func callPoster(){
        
        guard let number = URL(string: "tel://" + "\(posterUser.phoneNumber)") else { return }
        UIApplication.shared.open(number)
    }
    
    @objc func emailPoster(){
        
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        let destinationUser = FirebaseData.sharedInstance.users.filter{ $0.UID == currentListing.posterUID }.first

            //show error if the VC cant send mail
            if MFMailComposeViewController.canSendMail()
            {
                self.present(mailComposerVC, animated: true, completion: nil)
            } else {
                self.showSendMailErrorAlert()
            }
        
        sendMail(mailComposerVC: mailComposerVC, destinationUser: destinationUser!)
    }
    
    func sendMail(mailComposerVC: MFMailComposeViewController, destinationUser: User){
        
        let destinationEmail = destinationUser.email
        let destinationName = destinationUser.displayName
        
        let currentUserName = FirebaseData.sharedInstance.currentUser!.displayName

        let currentListingName = currentListing.name!
        let currentListingAddress = currentListing.address!
        
        //mailVC properties
        mailComposerVC.setToRecipients([destinationEmail])
        mailComposerVC.setSubject("U-List: \(currentListingName) inquiry")
        mailComposerVC.setMessageBody("Hey \(destinationName),\n\nI'm interested in your listing at \(currentListingAddress).\n\nThanks!\n\n\(currentUserName)", isHTML: false)
        
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
    
    @objc func addListingForComparison(){
        
//        let homeVC = self.navigationController?.viewControllers[0] as! HomeViewController
//        homeVC.listingsToCompare.append(currentListing)
        
        if(guestUser){
            present(AlertDefault.showAlert(title: "Sorry", message: "You need to sign in to use this feature"), animated: true, completion: nil)
            return
        }
        
        var listingPath: String = ""
        
        if currentListing is HomeSale {
            listingPath = "/forSale/homesForSale/\(currentListing.country!)/\(currentListing.province!)/\(currentListing.city!)/\(currentListing.zipcode!)/\(currentListing.posterUID!)/\(currentListing.UID!)"
        }
        
        else if currentListing is HomeRental {
            
            listingPath = "/forRent/homesForRent/\(currentListing.country!)/\(currentListing.province!)/\(currentListing.city!)/\(currentListing.zipcode!)/\(currentListing.posterUID!)/\(currentListing.UID!)"

        }
        
        FirebaseData.sharedInstance.currentUser?.compareStackListings.append(currentListing)
        FirebaseData.sharedInstance.currentUser?.compareStackListingRefs.append(listingPath)
        
        WriteFirebaseData.write(user: FirebaseData.sharedInstance.currentUser!)
        
        let compareListingAlert = UIAlertController(title: "Successfully Added", message: "Would you like to view all?", preferredStyle: .alert)
        
        let compareAction = UIAlertAction(title: "Yes", style: .default, handler: {(action) in
      
            let compareVC = CompareListingsViewController()
          //  compareVC.listingsArray = homeVC.listingsToCompare
            
            self.present(compareVC, animated: true, completion: nil)
    
        })
        
        let exploreAction = UIAlertAction(title: "No, keep exploring", style: .default, handler: nil)
        
        compareListingAlert.addAction(compareAction)
        compareListingAlert.addAction(exploreAction)
        
        present(compareListingAlert, animated: true, completion: nil)
    }
    
    
    
    @objc func showDirections(){
        
        
        let destinationLocation = currentListing.location
        let originLocation = LocationManager.theLocationManager.getLocation()
        
        DirectionsManager.theDirectionsManager.mapView = mapView
        DirectionsManager.theDirectionsManager.distanceLabel = distanceLabel
        
        if !(directionsButton.isSelected){
            directionsButton.isSelected = true
            
            self.navigationController?.navigationBar.isHidden = true
            
            UIView.animate(withDuration: 1, animations: {
                self.enlargedMapTopConstraint = NSLayoutConstraint(item: self.mapView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0)
                self.enlargedMapHeightConstraint = NSLayoutConstraint(item: self.mapView, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 1, constant: 0)
                
                NSLayoutConstraint.deactivate([self.minimizedMapTopConstraint, self.minimizedMapHeightConstraint])
                NSLayoutConstraint.activate([self.enlargedMapTopConstraint, self.enlargedMapHeightConstraint])
                
                DirectionsManager.theDirectionsManager.activePolylines = []
                DirectionsManager.theDirectionsManager.getPolylineRoute(from: originLocation, to: destinationLocation!)
                
                self.view.layoutIfNeeded()
                
            }, completion: { finished in
              
 
                self.distanceLabel.isHidden = false
            
            })
            
        }
        
        else {
         
            UIView.animate(withDuration: 1, animations: {
                
                self.distanceLabel.isHidden = true
                
                NSLayoutConstraint.deactivate([self.enlargedMapTopConstraint, self.enlargedMapHeightConstraint])
                NSLayoutConstraint.activate([self.minimizedMapTopConstraint, self.minimizedMapHeightConstraint])
                
                self.view.layoutIfNeeded()
                
                DirectionsManager.theDirectionsManager.removePath()
                
                let update = GMSCameraUpdate.setTarget(self.currentListing.coordinate, zoom: 15.0)
                self.mapView.animate(with: update)
                
                
            }, completion: { finished in
                
                self.directionsButton.isSelected = false
    

                self.navigationController?.navigationBar.isHidden = false
            })
         
        }
    }
    
    @objc func pinchImageToFullscreen(sender: UIPinchGestureRecognizer){
        
        if (sender.scale > 1){
            fullscreenImage()
        }
    }
    
    
    //fullcreen image methods
    @objc func fullscreenImage() {
        

        
            tempImageView = UIImageView()
            tempImageView.sd_setImage(with: storageRef.child(currentListing.photoRefs[photoIndex]), placeholderImage: nil)
        
        if(currentListing.photoRefs[photoIndex] != ""){
            
            let enlargedImageContainerView = UIView()
            enlargedImageContainerView.frame = UIScreen.main.bounds
            enlargedImageContainerView.backgroundColor = UIColor.black
            self.view.addSubview(enlargedImageContainerView)
            
            let minimizeFullscreenButton = UIButton()
            minimizeFullscreenButton.setTitle("Min", for: .normal)
            minimizeFullscreenButton.setTitleColor(UIColor.white, for: .normal)
            minimizeFullscreenButton.addTarget(self, action: #selector(dismissFullscreenImage), for: .touchUpInside)
            minimizeFullscreenButton.translatesAutoresizingMaskIntoConstraints = false
            enlargedImageContainerView.addSubview(minimizeFullscreenButton)
            
            NSLayoutConstraint(item: minimizeFullscreenButton, attribute: .centerX, relatedBy: .equal, toItem: enlargedImageContainerView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: minimizeFullscreenButton, attribute: .top, relatedBy: .equal, toItem: enlargedImageContainerView, attribute: .top, multiplier: 1, constant: 10).isActive = true
            
            
            newImageView = ImageScrollView()
            newImageView.translatesAutoresizingMaskIntoConstraints = true
            newImageView.frame = enlargedImageContainerView.frame
            newImageView.backgroundColor = .clear
            
            newImageView.presentingVC = self
            enlargedImageContainerView.addSubview(newImageView)
            
            newImageView.display(image: tempImageView.image!)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeThroughEnlargedImages))
            swipeRight.direction = .right
            let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeThroughEnlargedImages))
            swipeLeft.direction = .left
            
            enlargedImageContainerView.addGestureRecognizer(tap)
            enlargedImageContainerView.addGestureRecognizer(swipeRight)
            enlargedImageContainerView.addGestureRecognizer(swipeLeft)
            
            //       let collapsePinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
            
            self.navigationController?.isNavigationBarHidden = true
            
        }
        else {
            let alert = AlertDefault.showAlert(title: "No image", message: "There is no image to show")
            present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func swipeThroughEnlargedImages(gesture: UISwipeGestureRecognizer){
        
        if (gesture.direction == .left){
            nextImage(imageView: tempImageView, pageControl: newImageView.imageViewPageControl)
        }
            
        else if (gesture.direction == .right){
            previousImage(imageView: tempImageView, pageControl: newImageView.imageViewPageControl)
        }

        newImageView.display(image: tempImageView.image!)
    }
    
    @objc func dismissFullscreenImage(_ sender: UIPinchGestureRecognizer) {
        
        self.navigationController?.isNavigationBarHidden = false
        imageViewCarousel.sd_setImage(with: storageRef.child(currentListing.photoRefs[photoIndex]), placeholderImage: nil)
        imageViewPageControl.currentPage = photoIndex
        sender.view?.removeFromSuperview()
    }
}
