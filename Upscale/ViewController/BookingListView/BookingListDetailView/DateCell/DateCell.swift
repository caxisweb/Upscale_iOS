//
//  DateCell.swift
//  Upscale
//
//  Created by Krutik V. Poojara on 26/03/18.
//  Copyright © 2018 krutik. All rights reserved.
//

import UIKit

class DateCell: UITableViewCell
{
    
    @IBOutlet var lblName: UILabel!
    
    @IBOutlet var btnMinus: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
