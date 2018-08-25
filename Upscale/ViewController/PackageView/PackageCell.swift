//
//  PackageCell.swift
//  Upscale
//
//  Created by Krutik V. Poojara on 15/02/18.
//  Copyright © 2018 krutik. All rights reserved.
//

import UIKit

class PackageCell: UITableViewCell
{

    @IBOutlet var lblPackage: UILabel!
    @IBOutlet var lblType: UILabel!
    @IBOutlet var lblPrice: UILabel!
    
    @IBOutlet var lblSubscribe: UILabel!
    
    @IBOutlet var lblCompany: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
