//
//  AnemitiesCell.swift
//  Upscale
//
//  Created by Developer on 20/04/17.
//  Copyright © 2017 krutik. All rights reserved.
//

import UIKit

class AnemitiesCell: UICollectionViewCell
{

    @IBOutlet var imgType: UIImageView!
    @IBOutlet var lblName: UILabel!
    
    
    let defaults = UserDefaults.standard
    
    var strLanguage = "English"

    
    override func awakeFromNib() {
        super.awakeFromNib()

        if self.defaults.string(forKey: "language") != nil
        {
            self.strLanguage = (self.defaults.value(forKey: "language") as! String)
        }
        if strLanguage == "Arabic"
        {
            lblName.textAlignment = .right
        }
    }

}
