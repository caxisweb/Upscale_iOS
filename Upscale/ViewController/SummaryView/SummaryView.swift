//
//  SummaryView.swift
//  Upscale
//
//  Created by Developer on 27/04/17.
//  Copyright © 2017 krutik. All rights reserved.
//

import UIKit
import Toaster
import Alamofire
import SwiftyJSON
import MBProgressHUD

class SummaryView: BaseViewController,UITextFieldDelegate
{
    //MARK:- Outle
    
    @IBOutlet var viewTop: UIView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblDateTime: UILabel!
    
    @IBOutlet var viewHour: UIView!
    @IBOutlet var lblCostPerHour: UILabel!
    @IBOutlet var lblTags: UILabel!
    @IBOutlet var lblHour: UILabel!
    
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var txtPromoCode: UITextField!
    
    @IBOutlet var btnApply: UIButton!
    
    @IBOutlet var lblPromoCode: UILabel!
    @IBOutlet var btnTerms: UIButton!
    
    @IBOutlet var btnConfirm: UIButton!
    @IBOutlet var btnBack: UIButton!
//    @IBOutlet var lblCostPerHour: UILabel!
    @IBOutlet weak var lblternsCondition: UILabel!
    
    @IBOutlet var viewUser: UIView!
    @IBOutlet var lblUser: UILabel!
    
    @IBOutlet var viewPromoCodeDetails: UIView!
    @IBOutlet var lblPromoDiscount: UILabel!
    @IBOutlet var lblPromoPrice: UILabel!
    
    
    
    
    var check = Bool()
    
    var strName = String()
    var strLocation = String()
    var strCapacity = String()
    
    var strDate = String()
    var strFromTime = String()
    var strToTime = String()
    var strPrice = String()
    
    var strTotalPrice = String()
    var strTimeDeff = String()
    
    var spaceID = Int()
    var strRepeatType = String()
    var iDayType = Int()
    
    var loadingNotification : MBProgressHUD!
    var json : JSON!
    var strMessage : String!
    
//    var app = AppDelegate()

    
    var repeatCount = Int()
    var strDayType = String()
    
    var strPaymentType = String()
    var strEndDate = String()

    var strBookingType = String()
    var strBookingID = String()
    
    var strPromoCode = String()
    var strPromoCodeID = "0"//String()
    var strPromoPrice = "0"//String()
    var strPromoDiscount = "0"//String()
    var strPercentage = String()

    var strEsaarProductID = String()
    //MARK:-
    override func viewDidLoad()
    {
        super.viewDidLoad()
//        app = UIApplication.shared.delegate as! AppDelegate
        self.navigationController?.isNavigationBarHidden = true

        self.viewPromoCodeDetails.isHidden = true

        //
        lblName.text = strName
        lblAddress.text = strLocation
        lblDateTime.text = ("\(strDate) ,from \(strFromTime) to \(strToTime)")
        lblUser.text = strCapacity
        
        
        lblCostPerHour.text = "Cost \(strPrice) Per Hour"
        lblPrice.text = strTotalPrice
        lblHour.text = "\(strTimeDeff) h"
        
        viewTop.layer.cornerRadius = 5
        txtPromoCode.layer.cornerRadius = 5
        txtPromoCode.layer.borderWidth = 1
        txtPromoCode.layer.borderColor = UIColor.lightGray.cgColor
        txtPromoCode.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        txtPromoCode.delegate = self
        
        btnApply.layer.cornerRadius = 5
        
        if DeviceType.IS_IPHONE_5
        {
            lblCostPerHour.font = lblCostPerHour.font.withSize(11)
            
            viewHour.frame = CGRect(x: viewHour.frame.origin.x, y: viewHour.frame.origin.y + 10, width: 40, height: 40)
            viewUser.frame = CGRect(x: viewUser.frame.origin.x, y: viewUser.frame.origin.y, width: 30, height: 30)
        }
        
        btnConfirm.layer.cornerRadius = btnConfirm.layer.frame.size.height / 2
        btnBack.layer.cornerRadius = btnBack.layer.frame.size.height / 2
        viewHour.layer.cornerRadius = viewHour.layer.frame.size.height / 2
        viewUser.layer.cornerRadius = viewUser.layer.frame.size.height / 2
        
        lblternsCondition.isHidden = true
        btnTerms.isHidden = true
    }
    
    //MARK:- UITextField Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField .resignFirstResponder()
        return true
    }
    
    @IBAction func btnMenu(_ sender: Any)
    {
        if let navController = self.navigationController
        {
            navController.popViewController(animated: true)
        }
    }
    
    @IBAction func btnBack(_ sender: Any)
    {
        if let navController = self.navigationController
        {
            navController.popViewController(animated: true)
        }
    }
    
    @IBAction func btnTermsAndCondition(_ sender: Any)
    {
        if check
        {
            print("Not Selected")
            let image = UIImage(named: "off.png")
            btnTerms.setImage(image, for: UIControlState.normal)
            check = false
        }
        else
        {
            print("Selected")
            let image = UIImage(named: "on.png")
            btnTerms.setImage(image, for: UIControlState.normal)
            check = true
        }
    }
    
    @IBAction func btnApply(_ sender: Any)
    {
        txtPromoCode.resignFirstResponder()
        
        if check == false
        {
            self.strPromoCode = txtPromoCode.text!
            if self.strPromoCode.isEmpty
            {
                Toast(text: "Please Enter Promocode").show()
            }
            else
            {
                if self.app.isConnectedToInternet()
                {
                    self.getPromocodeAPI()
                }
                else
                {
                    Toast(text: "Internet Connetion in not availble.Try Again").show()
                }
            }
        }
        else
        {
            self.viewPromoCodeDetails.isHidden = true
            
            self.btnApply.setTitle("Apply", for: .normal)
            
            check = false
            self.strPromoCodeID = "0"
            self.strPromoPrice = "0"
            self.strPromoDiscount = "0"
        }
    }
    
    @IBAction func btnConfirm(_ sender: Any)
    {
        self.nextPage()
    }
    
    func nextPage()
    {
        self.strPaymentType = "1"
        
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentTypeView") as! PaymentTypeView
        VC.strBookingID = self.strBookingID
        VC.strBookingType = self.strBookingType
        VC.strEndDate = self.strEndDate
        VC.iDayType = self.iDayType
        VC.strCapacity = self.strCapacity
        VC.spaceID = self.spaceID
        VC.strDate = self.strDate
        VC.strFromTime = self.strFromTime
        VC.strToTime = self.strToTime
        VC.repeatCount = self.repeatCount
        VC.strTotalPrice = self.strTotalPrice
        VC.strPaymentType = self.strPaymentType
        VC.strPrice = self.strPrice
        VC.strTimeDeff = self.strTimeDeff
        VC.strName = self.strName
        VC.strLocation = self.strLocation
        VC.strPromoCodeID = self.strPromoCodeID
        VC.strPromoPrice = self.strPromoPrice
        VC.strPromoDiscount = self.strPromoDiscount
        VC.strPercentage = self.strPercentage
        VC.strEsaarProductID = self.strEsaarProductID
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    //MARK:- Update API
    func updateBookingAPI()
    {
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: false)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading..."
        loadingNotification.dimBackground = true
        
        print(strDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        
        let date = dateFormatter.date(from: self.strDate)
        
        dateFormatter.dateFormat = "dd-MM-yyyy"///this is you want to convert format
        let strDATE : String = dateFormatter.string(from: date!)
        print(strDATE)
        
        //{"booking_id":"4","booking_date":"05-05-2017","from_time":"11:00 AM","to_time":"03:00 PM","repeat_b":"0"}
        let parameters: Parameters = ["booking_id": self.strBookingID,
                                      "booking_date":strDATE,
                                      "from_time":self.strFromTime,
                                      "to_time":self.strToTime,
                                      "repeat":self.repeatCount,
                                      "end_date":self.strEndDate]
        print(parameters)
        
        Alamofire.request("\(self.app.strBaseAPI)edit_booking.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
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
                            Toast(text: self.strMessage).show()
                            
                            let desiredViewController = self.navigationController!.viewControllers.filter { $0 is BookingView }.first!
                            self.navigationController!.popToViewController(desiredViewController, animated: true)
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
    
    //MARK:- get promocode API
    func getPromocodeAPI()
    {
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: false)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading..."
        loadingNotification.dimBackground = true
        
        //{"user_id":"8","promocode":"x2020","space_id":"77"}
        let parameters: Parameters = ["user_id": self.app.strUserId,
                                      "promocode":strPromoCode,
                                      "space_id":self.spaceID]
        print(parameters)
        
        Alamofire.request("\(self.app.strBaseAPI)check_promocode.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
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
                            self.strPromoCodeID = self.json["promocode_id"].stringValue
                            let Amount : Int = self.json["amount"].intValue
                            var Price = Int()
                            var Discount = Int()
                            
                            self.strPercentage = self.json["type"].stringValue
                            if self.strPercentage == "percent"
                            {
                                Discount = Int(self.strTotalPrice)! * Amount/100
                            }
                            else
                            {
                                Discount = Amount
                            }
                            Price = Int(self.strTotalPrice)! - Discount

                            self.strPromoDiscount = ("\(Discount)")
                            self.strPromoPrice = ("\(Price)")
                            
                            self.lblPromoDiscount.text = self.strPromoDiscount
                            self.lblPromoPrice.text = self.strPromoPrice

                            self.getWidhofLabel(lbl: self.lblPromoDiscount)
                            self.getWidhofLabel(lbl: self.lblPromoPrice)

                            self.btnApply.setTitle("Remove", for: .normal)

                            self.check = true
                            self.viewPromoCodeDetails.isHidden = false
                        }
                        else
                        {
                            self.strPromoCodeID = "0"
                            self.strPromoPrice = "0"
                            self.strPromoDiscount = "0"

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
    
    func getWidhofLabel(lbl : UILabel)
    {
        let stringsize: CGSize = lbl.text!.size(withAttributes: [NSAttributedStringKey.font : lbl.font])
        let tabWidth = stringsize.width + 20

        lbl.frame =  CGRect(x:self.view.frame.size.width - tabWidth - 25, y: lbl.frame.origin.y, width:tabWidth, height:lbl.frame.size.height)

    }
    

}
