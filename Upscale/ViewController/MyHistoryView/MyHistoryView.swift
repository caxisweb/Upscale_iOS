//
//  MyHistoryView.swift
//  Upscale
//
//  Created by Developer on 29/04/17.
//  Copyright © 2017 krutik. All rights reserved.
//

import UIKit
import Toaster
import Alamofire
import SwiftyJSON
import MBProgressHUD
import DatePickerDialog

class MyHistoryView: BaseViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate
{
    @IBOutlet var viewNavigation: UIView!

    @IBOutlet var viewTop: UIView!
    @IBOutlet var lblActive: UILabel!
    @IBOutlet var lblInactive: UILabel!
    
    @IBOutlet var tblView: UITableView!
    
    @IBOutlet var viewPopupDelete: UIView!
    @IBOutlet var viewDeleteDetails: UIView!
    
    @IBOutlet var viewPopupEdit: UIView!
    @IBOutlet var viewEditDetails: UIView!
    @IBOutlet var txtDate: UITextField!
    @IBOutlet var txtFrom: UITextField!
    @IBOutlet var txtTo: UITextField!
    
    @IBOutlet var viewDate: UIView!
    @IBOutlet var viewFrom: UIView!
    @IBOutlet var viewTo: UIView!
    @IBOutlet var btnBooking: NiceButton!
    @IBOutlet var lblBookingType: UILabel!
    
    @IBOutlet var btnBack: UIButton!
    
    @IBOutlet var viewRepeat: UIView!
    
    @IBOutlet var txtEndDate: UITextField!
    @IBOutlet var viewSelectDate: UIView!
    
    @IBOutlet var btnSelectRepeat: UIButton!

    @IBOutlet var lblLangDate: UILabel!
    @IBOutlet var lblLangFrom: UILabel!
    @IBOutlet var lblLangTo: UILabel!
    
    @IBOutlet var btnActive: UIButton!
    @IBOutlet var btnInActive: UIButton!
    
    var loadingNotification : MBProgressHUD!
    var json : JSON!
    var strMessage : String!
    
//    var app = AppDelegate()
    
    var arrActive : [Any] = []
    var arrInactive : [Any] = []

    var iselect : Int = -1
    var check = Bool()
    var temp = Bool()

    var strType = "active"
    
    var iActive = 0
    var iInactive = 0
    
    var strBookingID = String()
    
    var spaceID = Int()

    var strLocation = String()
    var strCapacity = String()
    var strPrice = String()

    
    var strName = String()
    var strLanguage = "English"
    let defaults = UserDefaults.standard

    //Edit

    var strDate = String()
    var strFrom = String()
    var strTo = String()
    
    var datePicker = UIDatePicker()
    var currentDate = Date()
    
    var repeatCount = Int()
    var strDayType = "Day"
    var strEndDate = String()

    let SelectDayTypeDropdown = DropDown()
    
    lazy var dropDowns: [DropDown] =
        {
            return [
                self.SelectDayTypeDropdown
            ]
    }()

    var strBack = String()
    var strShare = String()
    
    var row = Int()

    //MARK:-
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        if DeviceType.IS_IPHONE_X
        {
            self.viewNavigation.frame = CGRect(x:self.viewNavigation.frame.origin.x, y: self.viewNavigation.frame.origin.y, width:self.viewNavigation.frame.size.width, height:88)
            self.viewTop.frame = CGRect(x:self.viewTop.frame.origin.x, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height, width:self.viewTop.frame.size.width, height:self.viewTop.frame.size.height)
            self.tblView.frame = CGRect(x:self.tblView.frame.origin.x, y: self.viewTop.frame.origin.y + self.viewTop.frame.size.height, width:self.tblView.frame.size.width, height:self.view.frame.size.height -  self.viewTop.frame.origin.y - self.viewTop.frame.size.height)
        }
        
        lblInactive.backgroundColor = UIColor.init(rgb: 0xD6D7D9)
        
        tblView.dataSource = self
        tblView.delegate = self
        tblView.separatorStyle = .none

        if self.app.isConnectedToInternet()
        {
            self.getMyHistoryAPI(strType: self.strType)
        }
        else
        {
            Toast(text: "Internet Connetion in not availble.Try Again").show()
        }
        
        viewPopupDelete.isHidden = true
        viewDeleteDetails.layer.cornerRadius = 5
        
        btnBooking.layer.cornerRadius = 3
        btnBooking.layer.borderWidth = 1
        btnBooking.layer.borderColor = UIColor.lightGray.cgColor
        
        setupSelectDayTypeDropdown()

        viewPopupEdit.isHidden = true
        viewEditDetails.layer.cornerRadius = 5

        self.textFieldRightViewPadding(txt: txtDate, vv: viewDate)
        self.textFieldRightViewPadding(txt: txtFrom, vv: viewFrom)
        self.textFieldRightViewPadding(txt: txtTo, vv: viewTo)
        self.textFieldRightViewPadding(txt: txtEndDate, vv: viewSelectDate)
        
        if self.defaults.string(forKey: "selectedLanguage") != nil
        {
            self.strLanguage = (self.defaults.value(forKey: "selectedLanguage") as! String)
        }
        
        if strLanguage == "ar"
        {
            txtDate.textAlignment = .right
            txtFrom.textAlignment = .right
            txtTo.textAlignment = .right
            txtEndDate.textAlignment = .right
            
            lblLangDate.textAlignment = .right
            lblLangFrom.textAlignment = .right
            lblLangTo.textAlignment = .right
        }
        else
        {
            lblLangDate.textAlignment = .left
            lblLangFrom.textAlignment = .left
            lblLangTo.textAlignment = .left
        }
        viewRepeat.isHidden = true
    }

    @IBAction func btnBack(_ sender: Any)
    {
        self.onSlideMenuButtonPressed(sender as! UIButton)
    }
    
    @IBAction func btnActive(_ sender: Any)
    {
        lblActive.backgroundColor = UIColor.white
        lblInactive.backgroundColor = UIColor.init(rgb: 0xD6D7D9)

        btnActive.isUserInteractionEnabled = false
        btnInActive.isUserInteractionEnabled = true

        self.strType = "active"
        iselect = -1

        if self.app.isConnectedToInternet()
        {
            self.getMyHistoryAPI(strType: self.strType)
        }
        else
        {
            Toast(text: "Internet Connetion in not availble.Try Again").show()
        }
    }

    @IBAction func btnInactive(_ sender: Any)
    {
        lblInactive.backgroundColor = UIColor.white
        lblActive.backgroundColor = UIColor.init(rgb: 0xD6D7D9)
        
        btnActive.isUserInteractionEnabled = true
        btnInActive.isUserInteractionEnabled = false

        self.strType = "inactive"
        iselect = -1

        if self.app.isConnectedToInternet()
        {
            self.getMyHistoryAPI(strType: self.strType)
        }
        else
        {
            Toast(text: "Internet Connetion in not availble.Try Again").show()
        }
    }
    
    //MARK:- TablView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if strType == "active"
        {
            return self.arrActive.count
        }
        else
        {
            return self.arrInactive.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell : WishListCell!
        cell = tblView.dequeueReusableCell(withIdentifier: "WishListCell") as! WishListCell!
        if cell == nil
        {
            cell = Bundle.main.loadNibNamed("WishListCell", owner: self, options: nil)?[0] as! WishListCell!
        }
        
        self.row = indexPath.row
        var arrValue : JSON!
        if self.strType == "active"
        {
            arrValue = JSON(self.arrActive)
            cell.btnBook.setTitle("CANCEL".localized, for: .normal)
        }
        else
        {
            arrValue = JSON(self.arrInactive)
            cell.btnBook.setTitle("Book Now".localized, for: .normal)
        }

        let strName : String = arrValue[indexPath.row]["name"].stringValue
        let strLocation : String = arrValue[indexPath.row]["location"].stringValue
        let strPrice : String = arrValue[indexPath.row]["amount"].stringValue
        
        let strKM : String = arrValue[indexPath.row]["distance"].stringValue
        let strUser : String = arrValue[indexPath.row]["capacity"].stringValue
        var strRating : String = arrValue[indexPath.row]["rating"].stringValue
        if strRating.isEmpty
        {
            strRating = "0"
        }
        
        cell.lblName.text = strName
        cell.lblAddress.text = strLocation
        cell.lblPrice.text = "\(strPrice) SAR"
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
        
        if iselect == self.row
        {
            cell.viewHistory.isHidden = false
        }
        else
        {
            cell.viewHistory.isHidden = true
        }
        
        cell.viewHeart.isHidden = true

        cell.btnDelete.addTarget(self, action: #selector(btnDeleteAction), for: .touchUpInside)
        cell.btnDelete.tag = self.row
        cell.btnShare.addTarget(self, action: #selector(btnShareAction), for: .touchUpInside)
        cell.btnShare.tag = self.row
        
        cell.btnBook.addTarget(self, action: #selector(btnBookAction), for: .touchUpInside)
        cell.btnBook.tag = indexPath.row
        
        cell.viewShare.layer.cornerRadius = cell.viewShare.frame.size.height / 2
        cell.viewDelete.layer.cornerRadius = cell.viewDelete.frame.size.height / 2
        
        cell.selectionStyle = .none
        tblView.rowHeight = cell.frame.size.height
        
        return cell
    }
    
    func btnBookAction(sender:UIButton)
    {
        var arrValue : JSON!
        if self.strType == "active"
        {
            arrValue = JSON(self.arrActive)
            ProjectUtility.animatePopupView(viewPopup: viewPopupDelete, viewDetails: viewDeleteDetails)
        }
        else
        {
            arrValue = JSON(self.arrInactive)
        
            let strImage : String = arrValue[sender.tag]["img"].stringValue
            let escapedString : String = strImage.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            
            let strFullImage : String = "\(self.app.strImagePath)space/\(escapedString)"

            let VC = self.storyboard?.instantiateViewController(withIdentifier: "BookingListDetailView") as! BookingListDetailView
            VC.capacityID = arrValue[sender.tag]["capacity"].intValue
            VC.spaceID = arrValue[sender.tag]["your_space_id"].intValue
            VC.strFullImage = strFullImage
            self.navigationController?.pushViewController(VC, animated: true)
        }
        
        self.strBookingID = arrValue[sender.tag]["booking_id"].stringValue
        
        self.iselect = -1
        self.tblView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if self.strType == "active"
        {
            if iselect == indexPath.row
            {
                iselect = -1
            }
            else
            {
                iselect = indexPath.row
            }
            self.tblView.reloadData()
        }
    }
   

    //MARK:- Button Actions 
    func btnDeleteAction(sender:UIButton)
    {
        ProjectUtility.animatePopupView(viewPopup: viewPopupDelete, viewDetails: viewDeleteDetails)
        
        var arrValue : JSON!
        if self.strType == "active"
        {
            arrValue = JSON(self.arrActive)
        }
        else
        {
            arrValue = JSON(self.arrInactive)
        }

        self.strBookingID = arrValue[sender.tag]["booking_id"].stringValue
        
        self.iselect = -1
        self.tblView.reloadData()
    }
    
    func btnEditAction(sender:UIButton)
    {        
//        var arrValue : JSON!
//        if self.strType == "active"
//        {
//            arrValue = JSON(self.arrActive)
//        }
//        else
//        {
//            arrValue = JSON(self.arrInactive)
//        }
//
//        self.strBookingID = arrValue[sender.tag]["booking_id"].stringValue
//
//        self.spaceID = arrValue[sender.tag]["your_space_id"].intValue
//        self.strLocation = arrValue[sender.tag]["location"].stringValue
//        self.strCapacity = arrValue[sender.tag]["capacity"].stringValue
//        self.strPrice = arrValue[sender.tag]["amount"].stringValue
//
//        self.strDate = arrValue[sender.tag]["booking_date"].stringValue
//        self.strFrom = arrValue[sender.tag]["from_time"].stringValue
//        self.strTo = arrValue[sender.tag]["to_time"].stringValue
//
//        self.repeatCount = arrValue[sender.tag]["repeat_b"].intValue
//
//        if self.repeatCount == 0
//        {
//            self.strDayType = "Never"
//        }
//        else if self.repeatCount == 1
//        {
//            self.strDayType = "Day"
//        }
//        else if self.repeatCount == 2
//        {
//            self.strDayType = "Week"
//        }
//        else if self.repeatCount == 3
//        {
//            self.strDayType = "Month"
//        }
//
//        self.lblBookingType.text = self.strDayType
//
//        self.txtDate.text = self.strDate
//        self.txtFrom.text = self.strFrom
//        self.txtTo.text = self.strTo
        
//        self.viewPopupEdit.isHidden = false
        ProjectUtility.animatePopupView(viewPopup: viewPopupEdit, viewDetails: viewEditDetails)
//        self.viewRepeat.isHidden = true
//        self.check = false
//
//
//        self.iselect = -1
//        self.tblView.reloadData()
    }
    
    func textFieldRightViewPadding(txt : UITextField, vv : UIView)
    {
        txt.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        
        txt.rightView = vv
        txt.rightViewMode = .always
        
        txt.delegate = self
        txt.layer.cornerRadius = 3
        txt.layer.borderWidth = 1
        txt.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func btnShareAction(sender:UIButton)
    {
        print("Share : \(sender.tag)")
        var arrValue : JSON!
        if self.strType == "active"
        {
            arrValue = JSON(self.arrActive)
        }
        else
        {
            arrValue = JSON(self.arrInactive)
        }
        self.strName = arrValue[sender.tag]["name"].stringValue
        
        self.strShare = "Please explore \(strName) and join the coworkers community now by booking a space" + "\n" + "http://hive.sa/app.php"
        self.DefaultsShareApp()
        
//        self.iselect = -1
//        self.tblView.reloadData()
    }
    
    func DefaultsShareApp()
    {
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [self.strShare], applicationActivities: nil)
        
        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            UIActivityType.postToWeibo,
            UIActivityType.print,
            UIActivityType.assignToContact,
            UIActivityType.saveToCameraRoll,
            UIActivityType.addToReadingList,
            UIActivityType.postToFlickr,
            UIActivityType.postToVimeo,
            UIActivityType.postToTencentWeibo
        ]
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    //MARK:- Get All List
    func getMyHistoryAPI(strType : String)
    {
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: false)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading..."
        loadingNotification.dimBackground = true
        
        //{"user_id":"18","type":"active"}
        let parameters: Parameters = ["user_id":self.app.strUserId,
                                      "type":strType]
        print(parameters)
        
        Alamofire.request("\(self.app.strBaseAPI)my_booking_list.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
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
                        
                        if strType == "active"
                        {
                            self.iActive = 1
                            self.arrActive.removeAll()
                            self.iInactive = 0
                        }
                        else
                        {
                            self.iInactive = 1
                            self.arrInactive.removeAll()
                        }
                        
                        if strStatus == "1"
                        {
                            if strType == "active"
                            {
                                self.arrActive = self.json["bookings"].arrayValue
                            }
                            else
                            {
                                self.arrInactive = self.json["bookings"].arrayValue
                            }
                        }
                        else
                        {
                            Toast(text: self.strMessage).show()
                        }
                        
                        self.tblView.reloadData()
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
    
    //MARK:- viewPopupDelete Delete
    
    @IBAction func btnCancelDeleteAction(_ sender: Any)
    {
        viewPopupDelete.isHidden = true
    }
    
    @IBAction func btnDeleteBooking(_ sender: Any)
    {
        if self.app.isConnectedToInternet()
        {
            self.deleteBookinAPI()
        }
        else
        {
            Toast(text: "Internet Connetion in not availble.Try Again").show()
        }
    }

    func deleteBookinAPI()
    {
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: false)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading..."
        loadingNotification.dimBackground = true
        
        //{"user_id":"18","type":"active"}
        let parameters: Parameters = ["booking_id":self.strBookingID]
        print(parameters)
        
        Alamofire.request("\(self.app.strBaseAPI)remove_booking.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
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
                            self.viewPopupDelete.isHidden = true
                            self.iselect = -1
                            
                            if self.app.isConnectedToInternet()
                            {
                                self.getMyHistoryAPI(strType: self.strType)
                            }
                            else
                            {
                                Toast(text: "Internet Connetion in not availble.Try Again").show()
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
    
    //MARK:- viewPopupEdit Details
    @IBAction func btnCancelEditAction(_ sender: Any)
    {
        viewPopupEdit.isHidden = true
    }
    
    @IBAction func btnBookingAction(_ sender: Any)
    {
        SelectDayTypeDropdown.show()
    }
    
    func setupSelectDayTypeDropdown()
    {
        SelectDayTypeDropdown.anchorView = btnBooking
        
        SelectDayTypeDropdown.bottomOffset = CGPoint(x: 0, y: btnBooking.bounds.height)
        
        // You can also use localizationKeysDataSource instead. Check the docs.
        SelectDayTypeDropdown.dataSource = ["Day",//3
                                            "Week",//2
                                            "Month"]
        
        SelectDayTypeDropdown.frame.origin.x = btnBooking.frame.origin.x
        SelectDayTypeDropdown.width = btnBooking.frame.size.width
        
        // Action triggered on selection
        SelectDayTypeDropdown.selectionAction =
            { [unowned self] (index, item) in
                //                self.btnDenoType.setTitle(item, for: .normal)
                
                //                self.strDenomination = item
                self.strDayType = item
                self.lblBookingType.text = self.strDayType
                if index == 0
                {
                    self.repeatCount = 1
                }
                else if index == 1
                {
                    self.repeatCount = 2
                }
                else if index == 2
                {
                    self.repeatCount = 3
                }
                
        }
    }
    

    @IBAction func btnUpdateEditAction(_ sender: Any)
    {
//        if self.strDayType == "Day"
//        {
//            self.repeatCount = 1
//        }
//        else if self.strDayType == "Week"
//        {
//            self.repeatCount = 2
//        }
//        else if self.strDayType == "Month"
//        {
//            self.repeatCount = 3
//        }
//        else if self.strDayType == "Never"
//        {
//            self.repeatCount = 0
//        }
        
        if self.strDate.isEmpty
        {
            Toast(text: "Please Select Date").show()
        }
        else if self.strFrom.isEmpty
        {
            Toast(text: "Please Select Time").show()
        }
        else if self.strTo.isEmpty
        {
            Toast(text: "Please Select Time").show()
        }
        else
        {
            if check == true
            {
                if (txtEndDate.text?.isEmpty)!
                {
                    Toast(text: "Please Eneter End Date").show()
                }
                else
                {
                    self.update()
                }
            }
            else
            {
                update()
            }
        }
    }
    
    func update()
    {
        if self.app.isConnectedToInternet()
        {
            self.insertBookingAPI()
//            self.updateBookingAPI()
        }
        else
        {
            Toast(text: "Internet Connetion in not availble.Try Again").show()
        }
    }
    
    //MARK:- Date Time Action
    @IBAction func btnDateAction(_ sender: Any)
    {
        //Only Future Date Allowed
        DatePickerDialog().show("Date Picker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", minimumDate: datePicker.minimumDate ,datePickerMode: .date) { (date) in
            if let dt = date
            {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMMM dd, yyyy"
                dateFormatter.locale = NSLocale(localeIdentifier: "en") as Locale

                self.strDate = dateFormatter.string(from:dt as Date)
                self.txtDate.text = self.strDate
            }
        }
        
    }
    
    @IBAction func btnFromAction(_ sender: Any)
    {
        DatePickerDialog().show("Time Picker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .time) { (date) in
            if let dt = date
            {
                //                let dateFormatter = DateFormatter()
                //                dateFormatter.dateFormat = "hh:mm a"
                //
                //                self.strFrom = dateFormatter.string(from:dt as Date)
                //
                //                self.txtFrome.text = self.strFrom
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm"
                dateFormatter.locale = NSLocale(localeIdentifier: "en") as Locale
                
                let df1 = DateFormatter()
                df1.dateFormat = "hh"
                df1.locale = NSLocale(localeIdentifier: "en") as Locale
                let strHour : String = df1.string(from:dt as Date)
                
                let df2 = DateFormatter()
                df2.dateFormat = "mm"
                df2.locale = NSLocale(localeIdentifier: "en") as Locale
                let strMinut : String = df2.string(from: dt as Date)
                
                let df3 = DateFormatter()
                df3.dateFormat = "a"
                df3.locale = NSLocale(localeIdentifier: "en") as Locale
                let strAMPM : String = df3.string(from: dt as Date)
                
                let H : Int = Int(strHour)!
                var M : Int = Int(strMinut)!
                
                if M == 00 || M == 30
                {
                    self.strFrom = dateFormatter.string(from:dt as Date)
                    print(self.strFrom)
                    self.strFrom = self.strFrom + " \(strAMPM)"
                }
                else
                {
                    if M < 30
                    {
                        M = 00
                    }
                    else if M > 30 && M < 60
                    {
                        M = 30
                    }
                    
                    if M == 0
                    {
                        if H < 10
                        {
                            self.strFrom = ("0\(H):00")
                        }
                        else
                        {
                            self.strFrom = ("\(H):00")
                        }
                    }
                    else
                    {
                        if H < 10
                        {
                            self.strFrom = ("0\(H):\(M)")
                        }
                        else
                        {
                            self.strFrom = ("\(H):\(M)")
                        }
                    }
                    self.strFrom = self.strFrom + " \(strAMPM)"
                }
                
                self.txtFrom.text = self.strFrom
            }
            
        }
    }
    
    @IBAction func btnToAction(_ sender: Any)
    {
        DatePickerDialog().show("Time Picker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .time) { (date) in
            if let dt = date
            {
                //                let dateFormatter = DateFormatter()
                //                dateFormatter.dateFormat = "hh:mm a"
                //
                //                self.strTo = dateFormatter.string(from:dt as Date)
                //
                //                self.txtTo.text = self.strTo
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm"
                dateFormatter.locale = NSLocale(localeIdentifier: "en") as Locale
                
                let df1 = DateFormatter()
                df1.dateFormat = "hh"
                df1.locale = NSLocale(localeIdentifier: "en") as Locale
                let strHour : String = df1.string(from:dt as Date)
                
                let df2 = DateFormatter()
                df2.dateFormat = "mm"
                df2.locale = NSLocale(localeIdentifier: "en") as Locale
                let strMinut : String = df2.string(from: dt as Date)
                
                let df3 = DateFormatter()
                df3.dateFormat = "a"
                df3.locale = NSLocale(localeIdentifier: "en") as Locale
                let strAMPM : String = df3.string(from: dt as Date)
                
                let H : Int = Int(strHour)!
                var M : Int = Int(strMinut)!
                
                if M == 00 || M == 30
                {
                    self.strTo = dateFormatter.string(from:dt as Date)
                    print(self.strTo)
                    self.strTo = self.strTo + " \(strAMPM)"
                }
                else
                {
                    if M < 30
                    {
                        M = 00
                    }
                    else if M > 30 && M < 60
                    {
                        M = 30
                    }
                    
                    if M == 0
                    {
                        if H < 10
                        {
                            self.strTo = ("0\(H):00")
                        }
                        else
                        {
                            self.strTo = ("\(H):00")
                        }
                    }
                    else
                    {
                        if H < 10
                        {
                            self.strTo = ("0\(H):\(M)")
                        }
                        else
                        {
                            self.strTo = ("\(H):\(M)")
                        }
                    }
                    self.strTo = self.strTo + " \(strAMPM)"
                }
                
                self.txtTo.text = self.strTo
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
                                      "from_time":self.strFrom,
                                      "to_time":self.strTo,
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
                            Toast(text: "Booking has been successfully changed.").show()
                            self.viewPopupEdit.isHidden = true
                            self.iselect = -1
                            
                            if self.app.isConnectedToInternet()
                            {
                                self.getMyHistoryAPI(strType: self.strType)
                            }
                            else
                            {
                                Toast(text: "Internet Connetion in not availble.Try Again").show()
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
    
    //MARK:- Check Booking
    func insertBookingAPI()
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
        
        var strDATE = String()
        strDATE = dateFormatter.string(from: date!)
        print(strDATE)
        
        //  {"space_id":"1","date":"28-04-2017","from_time":"11:00 AM","to_time":"01:00 PM"}
        let parameters: Parameters = ["space_id": self.spaceID,
                                      "date":strDATE,
                                      "from_time":self.strFrom,
                                      "to_time":self.strTo,
                                      "cost":self.strPrice]
        
        print(parameters)
        
        Alamofire.request("\(self.app.strBaseAPI)check_booking_available.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
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
                            // {"space_id":"1","user_id":"18","date":"01-05-2017","from_time":"11:00 AM","to_time":"03:00 PM","repeat":"0","amount":"700","payment_type":"1"}
                            
                            let VC = self.storyboard?.instantiateViewController(withIdentifier: "SummaryView") as! SummaryView
                            VC.strBookingID = self.strBookingID
                            VC.strEndDate = self.strEndDate
                            VC.iDayType = self.repeatCount
                            VC.spaceID = self.spaceID //
                            VC.strName = self.strName
                            VC.strLocation = self.strLocation
                            VC.strCapacity = self.strCapacity
                            VC.strPrice = self.strPrice
                            VC.strDayType = self.strDayType //
                            VC.strDate = self.strDate //
                            VC.strFromTime = self.strFrom //
                            VC.strToTime = self.strTo //
                            VC.strBookingType = "Edit"
                            VC.strTotalPrice = self.json["price"].stringValue //
                            VC.strTimeDeff = self.json["time_diff"].stringValue
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
    
    
    //MARK:- viewRepeat
    @IBAction func btnSelectRepeat(_ sender: Any)
    {
        if check
        {
            let image = UIImage(named: "unchecklog.png")
            btnSelectRepeat.setImage(image, for: UIControlState.normal)
            check = false
            
            viewRepeat.isHidden = true
            
            repeatCount = 0
        }
        else
        {
            let image = UIImage(named: "checked.png")
            btnSelectRepeat.setImage(image, for: UIControlState.normal)
            check = true
            
            viewRepeat.isHidden = false
            repeatCount = 1
            
            self.setupSelectDayTypeDropdown()
        }
        
        
    }
    
    @IBAction func btnEndDate(_ sender: Any)
    {
        //Only Future Date Allowed
        DatePickerDialog().show("Date Picker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", minimumDate: datePicker.minimumDate ,datePickerMode: .date) { (date) in
            if let dt = date
            {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMMM dd, yyyy"
                
                self.strEndDate = dateFormatter.string(from:dt as Date)
                self.txtEndDate.text = self.strEndDate
            }
        }
        
    }
    
}
