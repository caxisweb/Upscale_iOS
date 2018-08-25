//
//  ReviewView.swift
//  Upscale
//
//  Created by Developer on 05/05/17.
//  Copyright © 2017 krutik. All rights reserved.
//

import UIKit
import Toaster
import Alamofire
import SwiftyJSON
import MBProgressHUD


class ReviewView: UIViewController,UITableViewDataSource,UITableViewDelegate
{
    
    @IBOutlet var tblView: UITableView!
    
    var loadingNotification : MBProgressHUD!
    var json : JSON!
    var strMessage : String!
    
    var app = AppDelegate()

    var arrReview : [Any] = []
    var spaceID = Int()

    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        app = UIApplication.shared.delegate as! AppDelegate
        self.navigationController?.isNavigationBarHidden = true

        tblView.delegate = self
        tblView.dataSource = self
        
//        spaceID = 1
        
        if self.app.isConnectedToInternet()
        {
            self.getReviewListAPI()
        }
        else
        {
            Toast(text: "Internet Connetion in not availble.Try Again").show()
        }
    
    }
    
    @IBAction func btnBack(_ sender: Any)
    {
        if let navController = self.navigationController
        {
            navController.popViewController(animated: true)
        }
    }
    

    //MARK:- TableView methods
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrReview.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell:ReviewsCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "ReviewsCell") as! ReviewsCell!
        
        if cell == nil
        {
            cell = Bundle.main.loadNibNamed("ReviewsCell", owner: self, options: nil)?[0] as! ReviewsCell
        }
        
        cell.viewReting.emptyImage = UIImage(named: "star copy.png")
        cell.viewReting.fullImage = UIImage(named: "star.png")
        
        cell.viewReting.contentMode = UIViewContentMode.scaleAspectFit
        cell.viewReting.maxRating = 5
        cell.viewReting.minRating = 1
        cell.viewReting.editable = false
        cell.viewReting.halfRatings = true
        cell.viewReting.backgroundColor = UIColor.clear
        
        var arrValue = JSON(self.arrReview)
        
        let strName : String = arrValue[indexPath.row]["user_name"].stringValue
        let strReview : String = arrValue[indexPath.row]["review"].stringValue
        let rate : Float = arrValue[indexPath.row]["rate"].floatValue
        let strDateTime : String = arrValue[indexPath.row]["datetime"].stringValue
        
        cell.viewReting.rating = rate
        
        cell.lblaName.text = strName
        cell.lblComments.text = strReview
        
        cell.lblDate.text = strDateTime
        cell.lblComments.clipsToBounds = true
        cell.lblComments.numberOfLines = 0
        
        let rect = cell.lblComments.text?.boundingRect(with: CGSize(width: CGFloat(cell.lblComments.frame.size.width), height: CGFloat(500)), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: cell.lblComments.font], context: nil)
        
        cell.lblComments.frame = CGRect(x: CGFloat(cell.lblComments.frame.origin.x), y: CGFloat(cell.lblComments.frame.origin.y), width: CGFloat(cell.lblComments.frame.size.width), height: CGFloat((rect?.size.height)!))
        
        cell.selectionStyle = .none
        tblView.rowHeight = cell.lblComments.frame.origin.x + cell.lblComments.frame.size.height + 5 ///cell.frame.size.height
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 5
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        let footerView = UIView()
        footerView.layer.backgroundColor = UIColor.clear.cgColor
        
        return footerView
    }
    
    func getReviewListAPI()
    {
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: false)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading..."
        loadingNotification.dimBackground = true
        
        
        // {"space_id": "1", "limit": "2"}
        let parameters: Parameters = ["space_id": self.spaceID]
        print(parameters)
        
        Alamofire.request("\(self.app.strBaseAPI)fetch_review.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
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
                            self.arrReview.removeAll()
                            
                            self.arrReview = self.json["review"].arrayValue
                            
                            self.tblView.reloadData()
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
