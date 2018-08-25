//
//  WishListView.swift
//  Upscale
//
//  Created by INFORAAM on 25/05/17.
//  Copyright © 2017 krutik. All rights reserved.
//

import UIKit
import Toaster
import Alamofire
import SwiftyJSON
import MBProgressHUD
import DatePickerDialog

class WishListView: BaseViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate
{
    @IBOutlet var viewNavigation: UIView!

    @IBOutlet var tblView: UITableView!
    
    var loadingNotification : MBProgressHUD!
    var json : JSON!
    var strMessage : String!
    
//    var app = AppDelegate()

    var arrWishList : [Any] = []
    
    var strDate = String()
    var strFrom = String()
    var strTo = String()
    
    var strLanguage = "English"
    let defaults = UserDefaults.standard

    var strName = String()
    var spaceID = Int()
    var strLocation = String()
    var capacityID = Int()
    var strPrice = String()
    
    //MARK:-
    //MARK:-
    override func viewDidLoad()
    {
        super.viewDidLoad()
//        app = UIApplication.shared.delegate as! AppDelegate
        self.navigationController?.isNavigationBarHidden = true

        if DeviceType.IS_IPHONE_X
        {
            self.viewNavigation.frame = CGRect(x:self.viewNavigation.frame.origin.x, y: self.viewNavigation.frame.origin.y, width:self.viewNavigation.frame.size.width, height:88)
            self.tblView.frame = CGRect(x:self.tblView.frame.origin.x, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height, width:self.tblView.frame.size.width, height:self.view.frame.size.height -  self.viewNavigation.frame.size.height)
        }
        
        tblView.dataSource = self
        tblView.delegate = self

        if self.app.isConnectedToInternet()
        {
            self.getFavoriteListAPI()
        }
        else
        {
            Toast(text: "Internet Connetion in not availble.Try Again").show()
        }
        
        if self.defaults.string(forKey: "selectedLanguage") != nil
        {
            self.strLanguage = (self.defaults.value(forKey: "selectedLanguage") as! String)
        }
       
    }

    @IBAction func btnBack(_ sender: Any)
    {
//        if let navController = self.navigationController
//        {
//            navController.popViewController(animated: true)
//        }
        self.onSlideMenuButtonPressed(sender as! UIButton)
    }
    
    //MARK:- TablViwe
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.arrWishList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell : WishListCell!
        cell = tblView.dequeueReusableCell(withIdentifier: "WishListCell") as! WishListCell!
        if cell == nil
        {
            cell = Bundle.main.loadNibNamed("WishListCell", owner: self, options: nil)?[0] as! WishListCell!
        }
        
        var arrValue = JSON(self.arrWishList)

        let strName : String = arrValue[indexPath.row]["name"].stringValue
        let strLocation : String = arrValue[indexPath.row]["location"].stringValue
        let strPrice : String = arrValue[indexPath.row]["price"].stringValue

        let strKM : String = arrValue[indexPath.row]["distance"].stringValue
        let strUser : String = arrValue[indexPath.row]["capacity"].stringValue
        let strRating : String = arrValue[indexPath.row]["rating"].stringValue

        cell.lblName.text = strName
        cell.lblAddress.text = strLocation
        cell.lblPrice.text = strPrice
        cell.lblKM.text = strKM
        cell.lblPerson.text = strUser

        cell.lblRate.isHidden = true
        
        cell.viewRating.emptyImage = UIImage(named: "StarLight.png")
        cell.viewRating.fullImage = UIImage(named: "star.png")
        
        cell.viewRating.contentMode = UIViewContentMode.scaleAspectFit
        cell.viewRating.maxRating = 5
        cell.viewRating.minRating = 1
        cell.viewRating.editable = false
        cell.viewRating.halfRatings = false
        cell.viewRating.backgroundColor = UIColor.clear
        cell.viewRating.rating = Float(strRating)!
        
        cell.viewHeart.layer.cornerRadius = 3
        cell.viewHistory.isHidden = true
        
        cell.btnBook.setTitle("Book Now".localized, for: .normal)
        cell.btnBook.addTarget(self, action: #selector(btnBookAction), for: .touchUpInside)
        cell.btnBook.tag = indexPath.row
        
        cell.btnHeart.addTarget(self, action: #selector(btnLikeAction), for: .touchUpInside)
        cell.btnHeart.tag = indexPath.row
        
        cell.selectionStyle = .none
        tblView.rowHeight = cell.frame.size.height
        
        return cell
    }
    
    func btnLikeAction(sender: UIButton!)
    {
        var arrValue = JSON(self.arrWishList)
        let spaceID : Int = arrValue[sender.tag]["space_id"].intValue
        
        if self.app.isConnectedToInternet()
        {
            self.InsertFavoriteAPI(spaceID: spaceID)
        }
        else
        {
            Toast(text: "Internet Connetion in not availble.Try Again").show()
        }
    }
    
    func btnBookAction(sender:UIButton)
    {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "BookingListDetailView") as! BookingListDetailView
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    //MARK:- FavoriteList API
    func getFavoriteListAPI()
    {
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: false)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading..."
        loadingNotification.dimBackground = true
        
        let parameters: Parameters = ["user_id": self.app.strUserId,
                                      "lat":self.app.lat,
                                      "long":self.app.long]
        print(JSON(parameters))
        
        Alamofire.request("\(self.app.strBaseAPI)fetch_favorite.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            debugPrint(response)
            
            if response.response?.statusCode == 200
            {
                self.loadingNotification.hide(animated: true)
                
                if response.result.isSuccess == true
                {
                    if let value = response.result.value
                    {
                        self.json = JSON(value)
                        print(self.json)
                        
                        let strStatus : String = self.json["status"].stringValue
                        self.strMessage = self.json["message"].stringValue
                        
                        if strStatus == "1"
                        {
                            self.arrWishList = self.json["favorite"].arrayValue
                            print(JSON(self.arrWishList))
                            self.tblView.reloadData()
                            self.tblView.setContentOffset(CGPoint.zero, animated: true)
                        }
                        else
                        {
                            Toast(text: self.strMessage).show()
                        }
                    }
                }
                else
                {
                    Toast(text: "Request time out.").show()
                    self.loadingNotification.hide(animated: true)
                }
            }
            else
            {
                print(response.result.error.debugDescription)
                Toast(text: "Request time out.").show()
                self.loadingNotification.hide(animated: true)
            }
        }
    }

    func InsertFavoriteAPI(spaceID : Int)
    {
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: false)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading..."
        loadingNotification.dimBackground = true
        
        let parameters: Parameters = ["user_id": self.app.strUserId,
                                      "space_id": spaceID]
        
        print(JSON(parameters))
        Alamofire.request("\(self.app.strBaseAPI)insert_favorite.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            debugPrint(response)
            
            if response.response?.statusCode == 200
            {
                self.loadingNotification.hide(animated: true)
                
                if response.result.isSuccess == true
                {
                    if let value = response.result.value
                    {
                        self.json = JSON(value)
                        print(self.json)
                        
                        let strStatus : String = self.json["status"].stringValue
                        self.strMessage = self.json["message"].stringValue
                        
                        if strStatus == "1"
                        {
                            self.getFavoriteListAPI()
                        }
                        else
                        {
                            Toast(text: self.strMessage).show()
                        }
                    }
                }
                else
                {
                    Toast(text: "Request time out.").show()
                    self.loadingNotification.hide(animated: true)
                }
            }
            else
            {
                print(response.result.error.debugDescription)
                Toast(text: "Request time out.").show()
                self.loadingNotification.hide(animated: true)
            }
        }
    }
    
}
