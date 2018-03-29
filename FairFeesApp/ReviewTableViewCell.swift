//
//  ReviewTableViewCell.swift
//  FairFeesApp
//
//  Created by Sanjay Shah on 2018-03-28.
//  Copyright © 2018 Fair Fees. All rights reserved.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var reviewTextLabel: UILabel!
    
    @IBOutlet weak var reviewerNameLabel: UILabel!
    
    @IBOutlet weak var upvotesLabel: UILabel!
    
    @IBOutlet weak var downvotesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
