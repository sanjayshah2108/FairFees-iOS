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

class ListingDetailViewController: UIViewController, GMSMapViewDelegate {
    
    var navigationBarHeight: CGFloat!
    
    weak var currentListing: HomeSale!

    var imageViewCarousel: UIImageView!
    var imageViewPageControl: UIPageControl!
    var nextImageButton: UIButton!
    var previousImageButton: UIButton!
    var addressLabel: UILabel!
    var descriptionLabel: UILabel!
    //var mapView: MKMapView!
    var mapView: GMSMapView!
    var directionsButton: UIButton!
    
    var featuresView: UIView!
    var priceLabel: UILabel!
    var sizeLabel: UILabel!
    var bedroomLabel: UILabel!
    var bathroomLabel: UILabel!
    
    var imageViewCarouselLeftSwipeGesture: UISwipeGestureRecognizer!
    var imageViewCarouselRightSwipeGesture: UISwipeGestureRecognizer!
    var imageViewCarouselExpandPinchGesture: UIPinchGestureRecognizer!
    var imageViewCarouselExpandTapGesture: UITapGestureRecognizer!
    
    var photoIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationBarHeight = self.navigationController?.navigationBar.frame.height
    
        self.title = currentListing.name
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
        imageViewCarousel.isUserInteractionEnabled = true
        imageViewCarousel.backgroundColor = UIColor.blue
        photoIndex = 0
        imageViewCarousel.image = currentListing.photos[photoIndex]
        imageViewCarousel.contentMode = .scaleAspectFill
        imageViewCarousel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageViewCarousel)
    
        imageViewCarouselLeftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeThroughImages))
        imageViewCarouselLeftSwipeGesture.direction = .left
        imageViewCarousel.addGestureRecognizer(imageViewCarouselLeftSwipeGesture)
        imageViewCarouselRightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeThroughImages))
        imageViewCarouselRightSwipeGesture.direction = .right
        imageViewCarousel.addGestureRecognizer(imageViewCarouselRightSwipeGesture)
        
//        imageViewCarouselExpandPinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(fullscreenImage))
//        imageViewCarousel.addGestureRecognizer(imageViewCarouselExpandPinchGesture)
//        
        imageViewCarouselExpandTapGesture = UITapGestureRecognizer(target: self, action: #selector(fullscreenImage))
        imageViewCarousel.addGestureRecognizer(imageViewCarouselExpandTapGesture)
        
        nextImageButton = UIButton(type: .custom)
        nextImageButton.setTitle("Next", for: .normal)
        nextImageButton.backgroundColor = UIProperties.sharedUIProperties.primaryGrayColor
        nextImageButton.addTarget(self, action: #selector(nextImage), for: .touchUpInside)
        nextImageButton.layer.cornerRadius = 3
        nextImageButton.translatesAutoresizingMaskIntoConstraints = false
        imageViewCarousel.addSubview(nextImageButton)
        
        previousImageButton = UIButton(type: .custom)
        previousImageButton.setTitle("Prev.", for: .normal)
        previousImageButton.backgroundColor = UIProperties.sharedUIProperties.primaryGrayColor
        previousImageButton.addTarget(self, action: #selector(previousImage), for: .touchUpInside)
        previousImageButton.layer.cornerRadius = 3
        previousImageButton.translatesAutoresizingMaskIntoConstraints = false
        imageViewCarousel.addSubview(previousImageButton)
        
        imageViewPageControl = UIPageControl()
        imageViewPageControl.currentPage = 0
        imageViewPageControl.numberOfPages = currentListing.photos.count
        imageViewPageControl.pageIndicatorTintColor = UIColor.gray
        imageViewPageControl.currentPageIndicatorTintColor = UIColor.white
        imageViewPageControl.translatesAutoresizingMaskIntoConstraints = false
        imageViewCarousel.addSubview(imageViewPageControl)
        
    }
    
    func setupLabels(){
        addressLabel = UILabel()
        addressLabel.textAlignment = .center
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.backgroundColor = UIColor.white
        addressLabel.text = currentListing.address
        view.addSubview(addressLabel)
        
        setupFeatureLabels()
        
        descriptionLabel = UILabel()
        descriptionLabel.textAlignment = .center
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
        
        priceLabel.text = "$\(currentListing.price!)"
        sizeLabel.text = "\(currentListing.size!) SF"
        bedroomLabel.text = "\(currentListing.bedroomNumber!) Bed"
        bathroomLabel.text = "\(currentListing.bathroomNumber!) Bath"
        
        
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
        
//        mapView = MKMapView()
//        mapView.delegate = MapViewDelegate.theMapViewDelegate
//        MapViewDelegate.theMapViewDelegate.theMapView = mapView
//
//        let span = MKCoordinateSpanMake(0.009, 0.009)
//    MapViewDelegate.theMapViewDelegate.theMapView.setRegion(MKCoordinateRegionMake(currentListing.coordinate, span) , animated: true)
//
//        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "listingMarkerView")
//        mapView.addAnnotation(currentListing)
//        mapView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(mapView)
    }
    
    func setupConstraints(){
        
        //imageViewCarousel
        NSLayoutConstraint(item: imageViewCarousel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: navigationBarHeight).isActive = true
        NSLayoutConstraint(item: imageViewCarousel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: imageViewCarousel, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        
        //nextImageButton
        NSLayoutConstraint(item: nextImageButton, attribute: .bottom, relatedBy: .equal, toItem: imageViewCarousel, attribute: .bottom, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: nextImageButton, attribute: .trailing, relatedBy: .equal, toItem: imageViewCarousel, attribute: .trailing, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: nextImageButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: nextImageButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        
        //previousImageButton
        NSLayoutConstraint(item: previousImageButton, attribute: .bottom, relatedBy: .equal, toItem: imageViewCarousel, attribute: .bottom, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: previousImageButton, attribute: .leading, relatedBy: .equal, toItem: imageViewCarousel, attribute: .leading, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: previousImageButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: previousImageButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        
        //imageViewPageControl
        NSLayoutConstraint(item: imageViewPageControl, attribute: .bottom, relatedBy: .equal, toItem: imageViewCarousel, attribute: .bottom, multiplier: 1, constant: -5).isActive = true
        NSLayoutConstraint(item: imageViewPageControl, attribute: .centerX, relatedBy: .equal, toItem: imageViewCarousel, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: imageViewPageControl, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: imageViewPageControl, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        
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
        NSLayoutConstraint(item: descriptionLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: descriptionLabel, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: descriptionLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        
        //mapView
        NSLayoutConstraint(item: mapView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mapView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mapView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mapView, attribute: .top, relatedBy: .equal, toItem: descriptionLabel, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mapView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 0.3, constant: 0).isActive = true
        
        //directionsButton
        NSLayoutConstraint(item: directionsButton, attribute: .top, relatedBy: .equal, toItem: mapView, attribute: .top, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: directionsButton, attribute: .trailing, relatedBy: .equal, toItem: mapView, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: directionsButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
        NSLayoutConstraint(item: directionsButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
    }
    
    @objc func nextImage(){
        if (photoIndex == currentListing.photos.count-1){
            photoIndex = 0
            imageViewPageControl.currentPage = 0
        }
        else {
            photoIndex = photoIndex + 1
            imageViewPageControl.currentPage += 1
        }
        
        imageViewCarousel.image = currentListing.photos[photoIndex]
    }
    
    @objc func previousImage(){
        if (photoIndex == 0){
            photoIndex = currentListing.photos.count-1
            imageViewPageControl.currentPage = currentListing.photos.count-1
        }
        else {
            photoIndex = photoIndex - 1
            imageViewPageControl.currentPage -= 1
        }
    
        imageViewCarousel.image = currentListing.photos[photoIndex]
    }

    @objc func swipeThroughImages(gesture: UISwipeGestureRecognizer){
    
        if (gesture.direction == .left){
            nextImage()
            print("swiped left")
        }
        
        else if (gesture.direction == .right){
            previousImage()
            print("swiped right")
        }
    }
    
    @objc func showDirections(){
        
        let destinationLocation = currentListing.location
        let originLocation = LocationManager.theLocationManager.getLocation()
        
        DirectionsManager.theDirectionsManager.mapView = mapView
        
        if !(directionsButton.isSelected){
            
            directionsButton.isSelected = true

            DirectionsManager.theDirectionsManager.getPolylineRoute(from: originLocation, to: destinationLocation!)
        }
        
        else {
            directionsButton.isSelected = false
            
            DirectionsManager.theDirectionsManager.removePath()
            
            let update = GMSCameraUpdate.setTarget(currentListing.coordinate, zoom: 15.0)
            self.mapView.animate(with: update)
        }
        
    }
    
    //fullcreen image methods -- NOT BEING USED AT THE MOMENT
    @objc func fullscreenImage() {
    
        let newImageView = ImageScrollView()
        newImageView.translatesAutoresizingMaskIntoConstraints = true
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        
        newImageView.display(image: currentListing.photos[photoIndex])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        sender.view?.removeFromSuperview()
    }
}
