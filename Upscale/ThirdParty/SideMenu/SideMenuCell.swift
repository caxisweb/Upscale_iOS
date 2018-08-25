//
//  SideMenuCell.swift
//  DrawarMenu
//
//  Created by Developer on 23/11/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit

class SideMenuCell: UITableViewCell
{

    //MARK:- Outlet
    @IBOutlet var imgProfile: UIImageView!
    
    @IBOutlet var lblName: UILabel!
    
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var imgLogo: UIImageView!
    
    @IBOutlet var imgSidebaar: UIImageView!
    
    @IBOutlet weak var viewDetails: UIView!
    
    @IBOutlet weak var btnEnglish: UIButton!
    @IBOutlet var btnArabic: UIButton!
    @IBOutlet weak var lblCount: UILabel!
    
    @IBOutlet var btnLogout: UIButton!
    @IBOutlet var btnLanguage: UIButton!
    
    @IBOutlet var imgLogout: UIImageView!
    //MARK:-
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
