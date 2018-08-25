//
//  WishListCell.swift
//  Upscale
//
//  Created by Krutik V. Poojara on 15/02/18.
//  Copyright © 2018 krutik. All rights reserved.
//

import UIKit

class WishListCell: UITableViewCell
{
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblType: UILabel!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblKM: UILabel!
    @IBOutlet var lblPrice: UILabel!
    
    @IBOutlet var btnBook: UIButton!
    
    @IBOutlet var viewHeart: UIView!
    @IBOutlet var imgeHeart: UIImageView!
    @IBOutlet var btnHeart: UIButton!
    
    @IBOutlet var lblPerson: UILabel!
    @IBOutlet var viewRating: FloatRatingView!
    
    @IBOutlet var lblRate: UILabel!
    
    @IBOutlet var viewHistory: UIView!
    @IBOutlet var viewShare: UIView!
//    @IBOutlet var viewEdit: UIView!
    @IBOutlet var viewDelete: UIView!
    
    @IBOutlet var btnShare: UIButton!
//    @IBOutlet var btnEdit: UIButton!
    @IBOutlet var btnDelete: UIButton!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
