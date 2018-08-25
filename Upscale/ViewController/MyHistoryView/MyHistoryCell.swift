//
//  MyHistoryCell.swift
//  Upscale
//
//  Created by Developer on 29/04/17.
//  Copyright © 2017 krutik. All rights reserved.
//

import UIKit

class MyHistoryCell: UITableViewCell
{
    
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblDate: UILabel!
    
    @IBOutlet var viewUser: UIView!
    @IBOutlet var lblUser: UILabel!
    @IBOutlet var lblCost: UILabel!
    
    @IBOutlet var lblTotalPrice: UILabel!

    @IBOutlet var viewHour: UIView!
    @IBOutlet var lblHour: UILabel!
    
    @IBOutlet var viewSelect: UIView!
    @IBOutlet var btnDelete: UIButton!
    @IBOutlet var btnEdit: UIButton!
    @IBOutlet var btnShare: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
