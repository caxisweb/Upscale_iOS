//
//  AboutUsView.swift
//  Upscale
//
//  Created by INFORAAM on 12/05/17.
//  Copyright © 2017 krutik. All rights reserved.
//

import UIKit
import SwiftyJSON

class AboutUsView: BaseViewController,UITableViewDelegate,UITableViewDataSource
{
    
    
    //MARK:- Outlet
    @IBOutlet var viewNavigation: UIView!

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var lblFirst: UILabel!
    @IBOutlet var tblView: UITableView!
    
    @IBOutlet var lblSecond: UILabel!

    @IBOutlet var imgAbout: UIImageView!
    
    var arrAbout : [Dictionary<String,String>] = []

    var tblHeight = CGFloat()
    
    var SECOND = "About".localized
    
    let defaults = UserDefaults.standard
    
    var strLanguage = "English"

    //MARK:-
    //MARK:-
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true

        if DeviceType.IS_IPHONE_X
        {
            self.viewNavigation.frame = CGRect(x:self.viewNavigation.frame.origin.x, y: self.viewNavigation.frame.origin.y, width:self.viewNavigation.frame.size.width, height:88)
            self.scrollView.frame = CGRect(x:self.scrollView.frame.origin.x, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height, width:self.scrollView.frame.size.width, height:self.view.frame.size.height -  self.viewNavigation.frame.size.height)
        }
        
        if self.defaults.string(forKey: "selectedLanguage") != nil
        {
            self.strLanguage = (self.defaults.value(forKey: "selectedLanguage") as! String)
        }
        
        self.lblFirst.text = SECOND
        
        arrAbout.append(["title":"+ 1000 Customers".localized, "desc":"With over 1000 members, access networking, advice, and opportunities in your ‘hood or across the planet.".localized, "icon":"Customer.png"])
        arrAbout.append(["title":"+50 Premium work spaces".localized, "desc":"You focus on your to-do’s, we take care of the rest. Enjoy included front-desk service, utilities, refreshments, and more.".localized, "icon":"PWS.png"])
        arrAbout.append(["title":"H24 Support".localized, "desc":"We’ve become experts in what you need to get work done happily—from brainstorming rooms to phone booths and terraces. Provided by 24/H Live chat support through website.".localized, "icon":"Support.png"])
        
        print(JSON(self.arrAbout))
        
        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.tblView.isUserInteractionEnabled = false
        self.tblView.reloadData()

    }
    
    //MARK:-
    @IBAction func btnMenu(_ sender: Any)
    {
        self.onSlideMenuButtonPressed(sender as! UIButton)
    }
    
    func setScrollviewForLastView()
    {
        for viewAll: UIView in scrollView.subviews
        {
            if viewAll.tag == 100
            {
                scrollView.contentSize = CGSize(width: CGFloat(scrollView.frame.size.width), height: CGFloat(viewAll.frame.origin.y + viewAll.frame.size.height + 10))
            }
        }
    }

    //MARK:- TablView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.arrAbout.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell : AboutUsCell!
        cell = tblView.dequeueReusableCell(withIdentifier: "AboutUsCell") as! AboutUsCell!
        if cell == nil
        {
            cell = Bundle.main.loadNibNamed("AboutUsCell", owner: self, options: nil)?[0] as! AboutUsCell!
        }
        
        let strDesc : String = self.arrAbout[indexPath.row]["desc"]!

        let strImage : String = arrAbout[indexPath.row]["icon"]!
        let image : UIImage = UIImage(named: strImage)!
        
        let str : String = self.arrAbout[indexPath.row]["title"]!

        cell.lblTitle.text = str
        cell.lblDesc.text = strDesc
        cell.imgProfile.image = image
        
        if self.strLanguage == "ar"
        {
            cell.lblDesc.textAlignment = .right
        }
        else
        {
            cell.lblDesc.textAlignment = .left
        }
        
        let rectFirst = cell.lblDesc.text?.boundingRect(with: CGSize(width: CGFloat(cell.lblDesc.frame.size.width), height: CGFloat(5000)), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: cell.lblDesc.font], context: nil)
        
        cell.lblDesc.frame = CGRect(x:cell.lblDesc.frame.origin.x, y: cell.lblDesc.frame.origin.y, width:cell.lblDesc.frame.size.width, height:(rectFirst?.height)!)

        tblView.rowHeight = cell.lblDesc.frame.origin.y + cell.lblDesc.frame.size.height + 10
        
        tblHeight = tblHeight + tblView.rowHeight
        
        if indexPath.row == arrAbout.count-1
        {
            self.SetAllDetails()
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func SetAllDetails()
    {
        let rectFirst = self.lblFirst.text?.boundingRect(with: CGSize(width: CGFloat(self.lblFirst.frame.size.width), height: CGFloat(5000)), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: self.lblFirst.font], context: nil)
        
        self.lblFirst.frame = CGRect(x:self.lblFirst.frame.origin.x, y: self.lblFirst.frame.origin.y, width:self.lblFirst.frame.size.width, height:(rectFirst?.height)!)
        
        self.tblView.frame = CGRect(x:self.tblView.frame.origin.x, y: self.lblFirst.frame.origin.y + self.lblFirst.frame.size.height + 10, width:self.tblView.frame.size.width, height:tblHeight)
        
        self.lblSecond.isHidden = true
        
        self.imgAbout.frame = CGRect(x:self.imgAbout.frame.origin.x, y: self.tblView.frame.origin.y + self.tblView.frame.size.height + 10, width:self.imgAbout.frame.size.width, height:self.imgAbout.frame.size.height)
        
        self.setScrollviewForLastView()
    }

}
