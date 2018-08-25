//
//  ThankYouView.swift
//  Upscale
//
//  Created by INFORAAM on 19/06/17.
//  Copyright © 2017 krutik. All rights reserved.
//

import UIKit

class ThankYouView: UIViewController
{
    //MARK:- OUtlet
    
    @IBOutlet var btnThankYou: UIButton!
    @IBOutlet var btnAddMore: UIButton!
    
    
    
    //MARK:-
    //MARK:-
    override func viewDidLoad()
    {
        super.viewDidLoad()

        
        btnThankYou.layer.cornerRadius = btnThankYou.frame.size.height / 2
        btnAddMore.layer.cornerRadius = btnAddMore.frame.size.height / 2
        
        let strThaankYou : String = "Thank You".localized
        let strAddMore : String = "Add More Space".localized
        
        btnThankYou.setTitle(strThaankYou, for: .normal)
        btnAddMore.setTitle(strAddMore, for: .normal)
    }

    //MARK:- 
    
    @IBAction func btnThankYou(_ sender: Any)
    {
        let desiredViewController = self.navigationController!.viewControllers.filter { $0 is ViewController }.first!
        self.navigationController!.popToViewController(desiredViewController, animated: true)
    }
    
    @IBAction func btnAddMore(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }

}
