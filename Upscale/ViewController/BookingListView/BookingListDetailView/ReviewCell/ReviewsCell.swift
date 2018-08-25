//
//  ReviewsCell.swift
//  Upscale
//
//  Created by Developer on 20/04/17.
//  Copyright © 2017 krutik. All rights reserved.
//

import UIKit

class ReviewsCell: UITableViewCell
{
    
    @IBOutlet var imgUser: UIImageView!
    @IBOutlet var lblaName: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblComments: UILabel!
    
    @IBOutlet var viewReting: FloatRatingView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
