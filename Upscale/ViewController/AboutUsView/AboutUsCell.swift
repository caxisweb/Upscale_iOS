//
//  AboutUsCell.swift
//  Upscale
//
//  Created by Krutik V. Poojara on 16/02/18.
//  Copyright © 2018 krutik. All rights reserved.
//

import UIKit

class AboutUsCell: UITableViewCell
{
    
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblDesc: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
