//
//  PaymentTypeView.swift
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

class PaymentTypeView: BaseViewController,UITextFieldDelegate,UIWebViewDelegate
{
    //MARK:- Outlet
    @IBOutlet var btnCashOnArrive: UIButton!
    @IBOutlet var btnVisa: UIButton!
    
    @IBOutlet var viewDetail: UIView!

    @IBOutlet var txtCardName: UITextField!
    @IBOutlet var txtCardNumber: UITextField!
    @IBOutlet var txtMonth: UITextField!
    @IBOutlet var txtYear: UITextField!
    @IBOutlet var txtVarificationCode: UITextField!
    
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblNumber: UILabel!
    @IBOutlet var lblExpDate: UILabel!
    
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var btnPay: UIButton!
    
    @IBOutlet var viewPopUp: UIView!
    @IBOutlet var webView: UIWebView!
    
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
    var strPaymentType = String()

    var strBookingType = String()
    var strBookingID = String()
    
    var loadingNotification : MBProgressHUD!
    var json : JSON!
    var strMessage : String!
    
//    var app = AppDelegate()
    
    var repeatCount = Int()
    var strDayType = String()
    var iDayType = Int()
    var strEndDate = String()

    var strPromoCodeID = String()
    var strPromoPrice = String()
    var strPromoDiscount = String()
    var strEsaarProductID = String()

    var strPaymentOptions = String()
    var strPercentage = String()
    var strURL = String()

    override func viewDidLoad()
    {
        super.viewDidLoad()
//        app = UIApplication.shared.delegate as! AppDelegate
        self.navigationController?.isNavigationBarHidden = true
    
        btnCashOnArrive.layer.borderWidth = 1
        btnCashOnArrive.layer.borderColor = UIColor.darkGray.cgColor
        
        btnVisa.layer.borderWidth = 1
        btnVisa.layer.borderColor = UIColor.darkGray.cgColor

        self.textFiledDesign(txt: txtCardName)
        self.textFiledDesign(txt: txtCardNumber)
        self.textFiledDesign(txt: txtMonth)
        self.textFiledDesign(txt: txtYear)
        self.textFiledDesign(txt: txtVarificationCode)

        self.buttonCornerRadiation(btn: btnBack)
        self.buttonCornerRadiation(btn: btnPay)
        self.buttonCornerRadiation(btn: btnCashOnArrive)
        self.buttonCornerRadiation(btn: btnVisa)
        
//        btnVisa.isHidden = true
        viewDetail.isHidden = true
        
        viewPopUp.isHidden = true

        print("Name : \(self.strName)")
    }
    
    func textFiledDesign(txt : UITextField)
    {
        txt.layer.cornerRadius = 5
        txt.layer.borderWidth = 1
        txt.layer.borderColor = UIColor.lightGray.cgColor
        txt.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)

        txt.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField .resignFirstResponder()
        return true
    }
    
    func buttonCornerRadiation(btn : UIButton)
    {
        btn.layer.cornerRadius = btn.layer.frame.size.height / 2
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
    
    @IBAction func btnPay(_ sender: Any)
    {
        if strBookingType == "Edit"
        {
            self.updateBook()
        }
        else
        {
            self.insertBook()
        }
    }
    
    @IBAction func btnCashOnArriveAction(_ sender: Any)
    {
        if strBookingType == "Edit"
        {
            self.updateBook()
        }
        else
        {
            self.insertBook()
        }
    }
    
    func insertBook()
    {
        if self.app.isConnectedToInternet()
        {
            self.insertBookingAPI()
        }
        else
        {
            Toast(text: "Internet Connetion in not availble.Try Again").show()
        }
    }
    
    func updateBook()
    {
        if self.app.isConnectedToInternet()
        {
            self.updateBookingAPI()
        }
        else
        {
            Toast(text: "Internet Connetion in not availble.Try Again").show()
        }
    }
    
    
    //MARK:- Insert strTotalPrice
    func insertBookingAPI()
    {
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: false)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading..."
        loadingNotification.dimBackground = true
        
        // {"space_id":"1","user_id":"18","date":"01-05-2017","from_time":"11:00 AM","to_time":"03:00 PM","repeat":"0","amount":"700","payment_type":"1"} // 1 cash 2 visa
        
        var strPriceDiscounted = String()
        if strPromoCodeID == "0"
        {
            strPriceDiscounted = self.strTotalPrice
        }
        else
        {
            strPriceDiscounted = self.strPromoPrice
        }
        
        let parameters: Parameters = ["space_id": self.spaceID,
                                      "user_id":self.app.strUserId,
                                      "date":self.strDate,
                                      "from_time":self.strFromTime,
                                      "to_time":self.strToTime,
                                      "repeat":self.iDayType,
                                      "amount":strPriceDiscounted,//self.strTotalPrice,
                                      "payment_type":self.strPaymentType,
                                      "base_amount":self.strPrice,
                                      "end_date":self.strEndDate,
                                      "hours":self.strTimeDeff,
                                      "promocode_id":strPromoCodeID,
                                      "actual_amount":strTotalPrice,
                                      "discount_price":strPromoDiscount]
        print(parameters)
        
        Alamofire.request("\(self.app.strBaseAPI)insert_booking.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
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
                            let strReferenceNo : String = self.json["reference_no"].stringValue
                            let strBookingID : String = self.json["booking_id"].stringValue
                            let VC = self.storyboard?.instantiateViewController(withIdentifier: "SuccessView") as! SuccessView
                            VC.strCapacity = self.strCapacity
                            VC.strBookingID = strBookingID
                            VC.strReferenceNo = strReferenceNo
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
                            self.navigationController?.pushViewController(VC, animated: true)
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
                                      "end_date":self.strEndDate,
                                      "total_price":self.strTotalPrice,
                                      "hours":self.strTimeDeff]
        
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
                            Toast(text: "Booking has been successfully changed.").show()
                            
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

    @IBAction func btnPopupCancel(_ sender: UIButton)
    {
        self.viewPopUp.isHidden = true
    }
    
    //MARK:- Btn VISA
    @IBAction func btnVisaAction(_ sender: UIButton)
    {
        if self.app.isConnectedToInternet()
        {
            self.getPaymentOptionAPI()
        }
        else
        {
            Toast(text: "Internet Connetion in not availble.Try Again").show()
        }
    }
    
    func getVisaAPI()
    {
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: false)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading..."
        loadingNotification.dimBackground = true
        
        //        {"InputEmail":"awais@upscale.com.sa","InputPassword":"123456","products":"20","quantities":"02","customers":"1","courier":"0","discounts_type":"","discounts":"0","delivery_options":"no","payment_options":"2"}
        var discounts_type = String()
        var discount = String()
        if strPercentage.isEmpty
        {
            discounts_type = ""
            discount = ""
        }
        else
        {
            if strPercentage == "percent"
            {
                discounts_type = "p"
            }
            else
            {
                discounts_type = "f"
            }
            discount = self.strPromoDiscount
        }
        
        let parameters: Parameters = ["InputEmail": "awais@upscale.com.sa",
                                      "InputPassword":"123456",
                                      "products":self.strEsaarProductID,
                                      "quantities":self.strTimeDeff,
                                      "customers":self.app.strEssalID,
                                      "courier":"0",
                                      "discounts_type":discounts_type,
                                      "discounts":discount,
                                      "payment_options":strPaymentOptions,
                                      "delivery_options":"no"]
        
        print(JSON(parameters))
        
        Alamofire.request("https://esal-sa.com/api/invoices/create", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
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
                        
                        let strStatus : String = self.json["success"].stringValue
                        self.strMessage = self.json["message"].stringValue
                        
                        if strStatus == "true"
                        {
                            let Data = self.json["data"]
                            
                            self.strURL = Data[0]["payment_url"].stringValue
                            self.viewPopUp.isHidden = false
                            
                            self.webView.delegate = self
                            if let url = URL(string: self.strURL)
                            {
                                let request = URLRequest(url: url)
                                self.webView.loadRequest(request)
                            }
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
    
    func getPaymentOptionAPI()
    {
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: false)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading..."
        loadingNotification.dimBackground = true
        
        //        {"InputEmail":"awais@upscale.com.sa","InputPassword":"123456"}
        let parameters: Parameters = ["InputEmail": "awais@upscale.com.sa",
                                      "InputPassword":"123456"]
        
        print(JSON(parameters))
        
        Alamofire.request("https://esal-sa.com/api/invoices/get_payment_options", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
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
                        
                        let strStatus : String = self.json["success"].stringValue
                        self.strMessage = self.json["message"].stringValue
                        
                        if strStatus == "true"
                        {
                            let data = self.json["data"]
                            
                            for index in 0...data.count-1
                            {
                                let strCode : String = data[index]["pymntopt_code"].stringValue
                                if strCode == "CC"
                                {
                                    self.strPaymentOptions = data[index]["id"].stringValue
                                }
                            }
                            self.getVisaAPI()
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
    
    //MARK:- Webview Delelegate
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        let strURL : String = (webView.request?.mainDocumentURL?.absoluteString)!
        
        if strURL == "https://esal-sa.com/home/thankyou/success"//"http://awn.sa/esaal/home/thankyou/success"
        {
            self.viewPopUp.isHidden = true
            self.strPaymentOptions = self.strPaymentType
            if self.app.isConnectedToInternet()
            {
                self.insertBookingAPI()
            }
            else
            {
                Toast(text: "Internet Connetion in not availble.Try Again").show()
            }
        }
        
    }
}
