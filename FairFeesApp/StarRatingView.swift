//
//  StarRatingView.swift
//  FairFeesApp
//
//  Created by Sanjay Shah on 2018-03-26.
//  Copyright © 2018 Fair Fees. All rights reserved.
//

import UIKit

class StarRatingView: UIView {
    
    var shouldSetupConstraints = true
    var panGestureRecognizer: UIPanGestureRecognizer!
    var tapGestureRecognizer: UITapGestureRecognizer!
    
    var backgroundView: UIView!
    var star1: UIImageView!
    var star2: UIImageView!
    var star3: UIImageView!
    var star4: UIImageView!
    var star5: UIImageView!
    
    var rating: Int!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundView = UIView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = UIColor.white
        self.addSubview(backgroundView)
        
        star1 = UIImageView(image: #imageLiteral(resourceName: "unfilledStar"))
        star1.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(star1)
        star2 = UIImageView(image: #imageLiteral(resourceName: "unfilledStar"))
        star2.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(star2)
        star3 = UIImageView(image: #imageLiteral(resourceName: "unfilledStar"))
        star3.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(star3)
        star4 = UIImageView(image: #imageLiteral(resourceName: "unfilledStar"))
        star4.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(star4)
        star5 = UIImageView(image: #imageLiteral(resourceName: "unfilledStar"))
        star5.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(star5)
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapAStar))
        backgroundView.addGestureRecognizer(tapGestureRecognizer)
        
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panAcrossStars))
        backgroundView.addGestureRecognizer(panGestureRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func tapAStar(sender: UITapGestureRecognizer){
        let location = sender.location(in: backgroundView)
        
        if (location.x > 30){
            star1.image = #imageLiteral(resourceName: "filledStar")
            rating = 1
        }
        if (location.x > 60){
            star2.image = #imageLiteral(resourceName: "filledStar")
            rating = 2
        }
        if (location.x > 90){
            star3.image = #imageLiteral(resourceName: "filledStar")
            rating = 3
        }
        if (location.x > 120){
            star4.image = #imageLiteral(resourceName: "filledStar")
            rating = 4
        }
        if (location.x > 150){
            star5.image = #imageLiteral(resourceName: "filledStar")
            rating = 5
        }
        
        if (location.x < 150){
            star5.image = #imageLiteral(resourceName: "unfilledStar")
            rating = 4
        }
        if (location.x < 120){
            star4.image = #imageLiteral(resourceName: "unfilledStar")
            rating = 3
        }
        if (location.x < 90){
            star3.image = #imageLiteral(resourceName: "unfilledStar")
            rating = 2
        }
        if (location.x < 60){
            star2.image = #imageLiteral(resourceName: "unfilledStar")
            rating = 1
        }
        if (location.x < 30){
            star1.image = #imageLiteral(resourceName: "unfilledStar")
            rating = 0
        }

    }
    
    @objc func panAcrossStars(sender: UIPanGestureRecognizer){
        
        let location = sender.location(in: backgroundView)
        
        if (location.x > 30){
            star1.image = #imageLiteral(resourceName: "filledStar")
            rating = 1
        }
        if (location.x > 60){
            star2.image = #imageLiteral(resourceName: "filledStar")
            rating = 2
        }
        if (location.x > 90){
            star3.image = #imageLiteral(resourceName: "filledStar")
            rating = 3
        }
        if (location.x > 120){
            star4.image = #imageLiteral(resourceName: "filledStar")
            rating = 4
        }
        if (location.x > 150){
            star5.image = #imageLiteral(resourceName: "filledStar")
            rating = 5
        }
        
        if (location.x < 150){
            star5.image = #imageLiteral(resourceName: "unfilledStar")
            rating = 4
        }
        if (location.x < 120){
            star4.image = #imageLiteral(resourceName: "unfilledStar")
            rating = 3
        }
        if (location.x < 90){
            star3.image = #imageLiteral(resourceName: "unfilledStar")
            rating = 2
        }
        if (location.x < 60){
            star2.image = #imageLiteral(resourceName: "unfilledStar")
            rating = 1
        }
        if (location.x < 30){
            star1.image = #imageLiteral(resourceName: "unfilledStar")
            rating = 0
        }
    }
    
    override func updateConstraints() {
        if(shouldSetupConstraints) {
            
            NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: self.superview, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: self.superview, attribute: .top, multiplier: 1, constant: 0).isActive = true
            //NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: self.superview, attribute: .leading, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: self.superview, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: self.superview, attribute: .width, multiplier: 1, constant: 0).isActive = true
            //NSLayoutConstraint(item: backgroundView, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
            //NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: self.superview, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
            
            NSLayoutConstraint(item: backgroundView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: backgroundView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: backgroundView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true
            //NSLayoutConstraint(item: backgroundView, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: backgroundView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
            
//            NSLayoutConstraint(item: backgroundView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50).isActive = true
//            NSLayoutConstraint(item: backgroundView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
//            NSLayoutConstraint(item: backgroundView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true
//            //NSLayoutConstraint(item: backgroundView, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
//            NSLayoutConstraint(item: backgroundView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300).isActive = true
            

            NSLayoutConstraint(item: star1, attribute: .top, relatedBy: .equal, toItem: backgroundView, attribute: .top, multiplier: 1, constant: 0).isActive = true
            //NSLayoutConstraint(item: star1, attribute: .leading, relatedBy: .equal, toItem: backgroundView, attribute: .leading, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: star1, attribute: .height, relatedBy: .equal, toItem: backgroundView, attribute: .height, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: star1, attribute: .width, relatedBy: .equal, toItem: backgroundView, attribute: .height, multiplier: 1, constant: 0).isActive = true
            
            NSLayoutConstraint(item: star2, attribute: .top, relatedBy: .equal, toItem: backgroundView, attribute: .top, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: star2, attribute: .leading, relatedBy: .equal, toItem: star1, attribute: .trailing, multiplier: 1, constant: 5).isActive = true
            NSLayoutConstraint(item: star2, attribute: .height, relatedBy: .equal, toItem: backgroundView, attribute: .height, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: star2, attribute: .width, relatedBy: .equal, toItem: backgroundView, attribute: .height, multiplier: 1, constant: 0).isActive = true
            
            NSLayoutConstraint(item: star3, attribute: .top, relatedBy: .equal, toItem: backgroundView, attribute: .top, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: star3, attribute: .leading, relatedBy: .equal, toItem: star2, attribute: .trailing, multiplier: 1, constant: 5).isActive = true
            NSLayoutConstraint(item: star3, attribute: .height, relatedBy: .equal, toItem: backgroundView, attribute: .height, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: star3, attribute: .width, relatedBy: .equal, toItem: backgroundView, attribute: .height, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: star3, attribute: .centerX, relatedBy: .equal, toItem: backgroundView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true

            NSLayoutConstraint(item: star4, attribute: .top, relatedBy: .equal, toItem: backgroundView, attribute: .top, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: star4, attribute: .leading, relatedBy: .equal, toItem: star3, attribute: .trailing, multiplier: 1, constant: 5).isActive = true
            NSLayoutConstraint(item: star4, attribute: .height, relatedBy: .equal, toItem: backgroundView, attribute: .height, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: star4, attribute: .width, relatedBy: .equal, toItem: backgroundView, attribute: .height, multiplier: 1, constant: 0).isActive = true
            
            NSLayoutConstraint(item: star5, attribute: .top, relatedBy: .equal, toItem: backgroundView, attribute: .top, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: star5, attribute: .leading, relatedBy: .equal, toItem: star4, attribute: .trailing, multiplier: 1, constant: 5).isActive = true
            NSLayoutConstraint(item: star5, attribute: .height, relatedBy: .equal, toItem: backgroundView, attribute: .height, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: star5, attribute: .width, relatedBy: .equal, toItem: backgroundView, attribute: .height, multiplier: 1, constant: 0).isActive = true
            
            //NSLayoutConstraint(item: star5, attribute: .trailing, relatedBy: .equal, toItem: backgroundView, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
            
            
                shouldSetupConstraints = false
        }
        super.updateConstraints()
    }
    
}
