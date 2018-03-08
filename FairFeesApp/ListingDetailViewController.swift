//
//  ListingDetailViewController.swift
//  FairFeesApp
//
//  Created by Sanjay Shah on 2018-03-07.
//  Copyright © 2018 Fair Fees. All rights reserved.
//

import UIKit
import MapKit

class ListingDetailViewController: UIViewController {
    
    var navigationBarHeight: CGFloat!
    var tabBarHeight: CGFloat!
    
    weak var currentListing: HomeSale!

    var imageViewCarousel: UIImageView!
    var addressLabel: UILabel!
    var descriptionLabel: UILabel!
    var mapView: MKMapView!
    
    var featuresView: UIView!
    var priceLabel: UILabel!
    var sizeLabel: UILabel!
    var bedroomLabel: UILabel!
    var bathroomLabel: UILabel!
    
    var imageCarouselSwipeGesture: UISwipeGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBarHeight = self.navigationController?.navigationBar.frame.height
        tabBarHeight = self.tabBarController?.tabBar.frame.height
    
        self.title = currentListing.listingName
        setupImageView()
        setupLabels()
        setupMapView()
        
        setupConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setupImageView(){
        
        imageViewCarousel = UIImageView()
        imageViewCarousel.backgroundColor = UIColor.blue
        imageViewCarousel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageViewCarousel)
    
        imageCarouselSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeThroughImages))
        imageViewCarousel.addGestureRecognizer(imageCarouselSwipeGesture)
    }
    
    func setupLabels(){
        addressLabel = UILabel()
        addressLabel.textAlignment = .center
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.backgroundColor = UIColor.white
        addressLabel.text = currentListing.listingAddress
        view.addSubview(addressLabel)
        
        setupFeatureLabels()
        
        descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.backgroundColor = UIColor.white
        view.addSubview(descriptionLabel)
        descriptionLabel.text = currentListing.listingDescription
    }
    
    func setupFeatureLabels(){
        
        featuresView = UIView()
        featuresView.backgroundColor = UIColor.white
        featuresView.layer.borderWidth = 1
        featuresView.layer.borderColor = UIProperties.sharedUIProperties.primaryBlackColor.cgColor
        featuresView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(featuresView)
        
        priceLabel = UILabel()
        sizeLabel = UILabel()
        bedroomLabel = UILabel()
        bathroomLabel = UILabel()
        
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        sizeLabel.translatesAutoresizingMaskIntoConstraints = false
        bedroomLabel.translatesAutoresizingMaskIntoConstraints = false
        bathroomLabel.translatesAutoresizingMaskIntoConstraints = false
        
        featuresView.addSubview(priceLabel)
        featuresView.addSubview(sizeLabel)
        featuresView.addSubview(bedroomLabel)
        featuresView.addSubview(bathroomLabel)
        
        priceLabel.text = "$\(currentListing.salePrice!)"
        sizeLabel.text = "\(currentListing.listingSize!) SF"
        bedroomLabel.text = "\(currentListing.homeBedroomNumber!) Bed"
        bathroomLabel.text = "\(currentListing.homeBathroomNumber!) Bath"
        
        
    }
    func setupMapView(){
        
        mapView = MKMapView()
        mapView.delegate = MapViewDelegate.theMapViewDelegate
        MapViewDelegate.theMapViewDelegate.theMapView = mapView
        
        let span = MKCoordinateSpanMake(0.009, 0.009)
    MapViewDelegate.theMapViewDelegate.theMapView.setRegion(MKCoordinateRegionMake(currentListing.coordinate, span) , animated: true)
        
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "listingMarkerView")
        mapView.addAnnotation(currentListing)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
    }
    
    func setupConstraints(){
        
        //imageViewCarousel
        NSLayoutConstraint(item: imageViewCarousel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: navigationBarHeight).isActive = true
        NSLayoutConstraint(item: imageViewCarousel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: imageViewCarousel, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        
        //addressLabel
        NSLayoutConstraint(item: addressLabel, attribute: .top, relatedBy: .equal, toItem: imageViewCarousel, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: addressLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: addressLabel, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: addressLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
        
        //featuresView
        NSLayoutConstraint(item: featuresView, attribute: .top, relatedBy: .equal, toItem: addressLabel, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: featuresView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: featuresView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: featuresView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60).isActive = true
        
        //priceLabel
        NSLayoutConstraint(item: priceLabel, attribute: .top, relatedBy: .equal, toItem: featuresView, attribute: .top, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: priceLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: priceLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 15).isActive = true
        
        //sizeLabel
        NSLayoutConstraint(item: sizeLabel, attribute: .top, relatedBy: .equal, toItem: featuresView, attribute: .top, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: sizeLabel, attribute: .trailing, relatedBy: .equal, toItem: featuresView, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: sizeLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 15).isActive = true
        
        //bedroomsLabel
        NSLayoutConstraint(item: bedroomLabel, attribute: .top, relatedBy: .equal, toItem: priceLabel, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: bedroomLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: bedroomLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 15).isActive = true
        
        //bathroomsLabel
        NSLayoutConstraint(item: bathroomLabel, attribute: .top, relatedBy: .equal, toItem: sizeLabel, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: bathroomLabel, attribute: .trailing, relatedBy: .equal, toItem: featuresView, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: bathroomLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 15).isActive = true
        
        //descriptionLabel
        NSLayoutConstraint(item: descriptionLabel, attribute: .top, relatedBy: .equal, toItem: featuresView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: descriptionLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: descriptionLabel, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: descriptionLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        
        //mapView
        NSLayoutConstraint(item: mapView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -tabBarHeight).isActive = true
        NSLayoutConstraint(item: mapView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mapView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mapView, attribute: .top, relatedBy: .equal, toItem: descriptionLabel, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mapView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 0.3, constant: 0).isActive = true
    }

    @objc func swipeThroughImages(gesture: UISwipeGestureRecognizer){
    
        if (gesture.direction == .left){
            print("swiped left")
        }
        
        else if (gesture.direction == .right){
            print("swiped right")
        }
    }
}
