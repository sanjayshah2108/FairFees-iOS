//
//  ReviewTableViewCell.swift
//  FairFeesApp
//
//  Created by Sanjay Shah on 2018-03-28.
//  Copyright © 2018 Fair Fees. All rights reserved.
//

import UIKit

protocol ReviewTableViewCellDelegate: class {
    func upvoteAction(_ sender: UIButton)
    func downvoteAction(_ sender: UIButton)
}

class ReviewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var reviewTextLabel: UILabel!
    
    @IBOutlet weak var starRatingContainerView: UIView!
    var starRatingView: StarRatingView!
    
    @IBOutlet weak var reviewerProfileImageView: UIImageView!
    @IBOutlet weak var reviewerNameLabel: UILabel!
    @IBOutlet weak var reportDeleteButton: UIButton!
    
    @IBOutlet weak var upvotesLabel: UILabel!
    @IBOutlet weak var upvoteButton: UIButton!
    
    @IBOutlet weak var downvotesLabel: UILabel!
    @IBOutlet weak var downvoteButton: UIButton!
    
    weak var delegate: ReviewTableViewCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        upvoteButton.setTitle("up", for: .normal)
        upvoteButton.setTitle("UP", for: .selected)
        upvoteButton.addTarget(self, action: #selector(upvoteAction), for: .touchUpInside)
        
        downvoteButton.setTitle("down", for: .normal)
        downvoteButton.setTitle("DOWN", for: .selected)
        downvoteButton.addTarget(self, action: #selector(downvoteAction), for: .touchUpInside)
        
        starRatingView = StarRatingView(frame: starRatingContainerView.bounds)
        starRatingContainerView.addSubview(starRatingView)
        starRatingView.isUserInteractionEnabled = false
        
        reportDeleteButton.addTarget(self, action: #selector(reportOrDelete), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func upvoteAction(sender: UIButton){
        delegate?.upvoteAction(sender)
    }
    
    @objc func downvoteAction(sender: UIButton){
        delegate?.downvoteAction(sender)
    }
    
    @objc func reportOrDelete(sender: UIButton){
        
        if(sender.title(for: .normal) == "Report"){
            
            print("report")
            
        }
        else {
            
            print("delete")
        }
        
    }
    
}
