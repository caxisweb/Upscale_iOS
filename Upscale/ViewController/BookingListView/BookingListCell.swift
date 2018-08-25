//
//  BookingListCell.swift
//  Upscale
//
//  Created by Developer on 14/04/17.
//  Copyright © 2017 krutik. All rights reserved.
//

import UIKit

class BookingListCell: UITableViewCell
{

    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var viewHeart: UIView!
    @IBOutlet var lblSpaceType: UILabel!
    
    @IBOutlet var viewRating: FloatRatingView!
    
    @IBOutlet var lblReviews: UILabel!
    @IBOutlet var lblUser: UILabel!
    
    @IBOutlet var viewLeft: UIView!
    @IBOutlet var lblHour: UILabel!
    @IBOutlet var lblKM: UILabel!
    @IBOutlet var imgPoint: UIImageView!
    @IBOutlet var imgHeart: UIImageView!
    @IBOutlet var btnHeart: UIButton!
    
    @IBOutlet var imgWifi: UIImageView!
    @IBOutlet var imgCall: UIImageView!
    @IBOutlet var imgMail: UIImageView!
    @IBOutlet var imgWork: UIImageView!
    
    @IBOutlet var viewShare: UIView!
    
    @IBOutlet var btnBook: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
