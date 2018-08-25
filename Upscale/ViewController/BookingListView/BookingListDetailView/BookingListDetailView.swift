//
//  BookingListDetailView.swift
//  Upscale
//
//  Created by Developer on 19/04/17.
//  Copyright © 2017 krutik. All rights reserved.
//

import UIKit
import DatePickerDialog
import Toaster
import Alamofire
import SwiftyJSON
import MBProgressHUD
import ImageSlideshow
import IQDropDownTextField
import DLRadioButton
import CoreLocation

class BookingListDetailView: BaseViewController,UIScrollViewDelegate,UITextFieldDelegate,IQDropDownTextFieldDelegate,IQDropDownTextFieldDataSource,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate
{
    //MARK:-
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblPackageName: UILabel!
    
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblLocation: UILabel!
    @IBOutlet var viewRating: FloatRatingView!
    
    @IBOutlet var lblDateTime: UILabel!
    @IBOutlet var lblReview: UILabel!
    
    @IBOutlet var lblPrice: UILabel!
    
    @IBOutlet var lblPerson: UILabel!
    
    @IBOutlet var imgHeart: UIImageView!
    @IBOutlet var imgPager: ImageSlideshow!
    
    @IBOutlet var txtDate: UITextField!
    @IBOutlet var txtFrom: UITextField!
    @IBOutlet var txtTo: UITextField!
    
    @IBOutlet var viewDate: UIView!
    @IBOutlet var viewFrom: UIView!
    @IBOutlet var viewTo: UIView!

    
    @IBOutlet var viewSpecial: UIView!
    @IBOutlet var btnSpecial: UIButton!
    @IBOutlet var lblDetails: UILabel!
    
    
//    @IBOutlet var viewRepeat: UIView!
//    @IBOutlet var btnRepeat: UIButton!
//
//    @IBOutlet var txtWeek: IQDropDownTextField!
//
//    @IBOutlet var txtDay: IQDropDownTextField!
    
    @IBOutlet var viewPromo: UIView!
    @IBOutlet var btnPromo: UIButton!
    @IBOutlet var txtPromo: UITextField!
    @IBOutlet var btnPromoApply: UIButton!
    
    @IBOutlet var viewPayment: UIView!
    @IBOutlet var btnPaymnet: UIButton!
    
    
    @IBOutlet var viewPayNow: UIView!
    @IBOutlet var viewNow: UIView!
    @IBOutlet var lblTotalPrice: UILabel!
    @IBOutlet var btnCOD: DLRadioButton!
    @IBOutlet var btnVISA: DLRadioButton!
    @IBOutlet var btnBANK: DLRadioButton!
    
    @IBOutlet var lblSPECIAL: UILabel!
    @IBOutlet var lblPROMO: UILabel!
    @IBOutlet var lblPAYMENT: UILabel!
    
    @IBOutlet var viewDateList: UIView!
    @IBOutlet var tblView: UITableView!
    
    @IBOutlet var lblVisa: UILabel!
    @IBOutlet var lblBank: UILabel!
    @IBOutlet var lblPromoDiscount: UILabel!
    
    @IBOutlet var viewTop: UIView!
    
    @IBOutlet var lblSpaceButton: UILabel!
    
    @IBOutlet var lblPromoButton: UILabel!
    @IBOutlet var lblPaymentButton: UILabel!
    
    var arrSDWebImageSource : [SDWebImageSource] = []
    
    
    var loadingNotification : MBProgressHUD!
    var json : JSON!
    var strMessage : String!
    
    var strDate = String()
    var strFrom = String()
    var strTo = String()
    var strFullDate = String()
    
    var datePicker = UIDatePicker()
    var currentDate = Date()
    
    var spaceID = Int()
    var capacityID = Int()
    var spaceUserID = Int()
    
    var strName = String()
    
    var strProjector = String()
    var strScanner = String()
    var strParking = String()
    var strAC = String()
    var strLocker = String()
    var strPhone = String()
    var strMail =  String()
    var strWifi = String()
    var strWork = String()
    var strMale = String()
    var strFemale = String()
    var strCoffee = String()
    
    var strLocation = String()
    var strDescription = String()
    var strPrice = String()
    var strCapacity = String()
    
    var strEndDate = String()
    
    var Rating = Int()
    var RatingCount = Int()
    
    //PopUp
    var giveRating = Float()
    
    var CellHeight = CGFloat()
    
    let defaults = UserDefaults.standard
    var strLanguage = "English"
    var wishStatus = Int()
    
    var check = Bool()

    var strEsaarProductID = String()
    
    
    var special = Int()
    var promo = Int()
    var payment = Int()

    var SpecialHeight = CGFloat()
    var RepeatedHeight = CGFloat()
    var PromoHeight = CGFloat()
    var PaymentHeight = CGFloat()

    var strPaymentType = "1"

    var arrDate : [Dictionary<String,String>] = []

    var strPromoCode = String()
    var strPromoCodeID = "0"//String()
    var strPromoPrice = "0"//String()
    var strPromoDiscount = "0"//String()
    var strPercentage = String()
    var TotalPrice = Double()
    var TotalDiscount = Double()
    var DiscountPrice = Double()

    var strBankName = String()
    var strIbanNumber = String()
    var strAccountNumber = String()
    var strFullImage = String()

    var strLat = String()
    var strLong = String()

    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    var lat = Double()
    var long = Double()
    
    var isSubscriber = String()
    var strPackageName = String()
    var strPackageID = String()
    var strPackageEndDate = String()

    let dateFormatter = DateFormatter()

    var SearchID = 0

    var LeftHours = Double()

    var Amount = Double()
    //MARK:-
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true

        self.lblPackageName.isHidden = true
        self.viewPayNow.isHidden = true

        
        if DeviceType.IS_IPHONE_X
        {
            self.viewNavigation.frame = CGRect(x:self.viewNavigation.frame.origin.x, y: self.viewNavigation.frame.origin.y, width:self.viewNavigation.frame.size.width, height:88)
            self.scrollView.frame = CGRect(x:self.scrollView.frame.origin.x, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height, width:self.scrollView.frame.size.width, height:self.view.frame.size.height -  self.viewNavigation.frame.size.height - self.viewPayNow.frame.size.height)
        }
        
        lblSPECIAL.layer.borderWidth = 1
        lblSPECIAL.layer.borderColor = UIColor.lightGray.cgColor
        lblPROMO.layer.borderWidth = 1
        lblPROMO.layer.borderColor = UIColor.lightGray.cgColor
        lblPAYMENT.layer.borderWidth = 1
        lblPAYMENT.layer.borderColor = UIColor.lightGray.cgColor

        self.lblVisa.isHidden = true
        self.lblBank.isHidden = true
        self.lblPromoDiscount.isHidden = true
        self.viewDateList.isHidden = true
        self.scrollView.isHidden = true
        
        self.viewRating.emptyImage = UIImage(named: "StarLight.png")
        self.viewRating.fullImage = UIImage(named: "star.png")
        
        self.viewRating.contentMode = UIViewContentMode.scaleAspectFit
        self.viewRating.maxRating = 5
        self.viewRating.minRating = 0
        self.viewRating.editable = false
        self.viewRating.halfRatings = false
        self.viewRating.backgroundColor = UIColor.clear
        self.viewRating.rating = 1.5
        
        if strDate.isEmpty
        {
            dateFormatter.dateFormat = "MMM dd, yyyy"
            dateFormatter.locale = NSLocale.init(localeIdentifier: "en") as Locale

            let DT = dateFormatter.string(from:currentDate)
            self.txtDate.text = DT
            self.strDate = DT
            
            dateFormatter.dateFormat = "a"
            var ZONE = dateFormatter.string(from:currentDate)
            
            dateFormatter.dateFormat = "hh"
            let TM = dateFormatter.string(from:currentDate)
            self.txtFrom.text = "\(TM):00 \(ZONE)"
            self.strFrom = "\(TM):00 \(ZONE)"

            let earlyDate = Calendar.current.date(
                byAdding: .hour,
                value: 1,
                to: currentDate)
            
            dateFormatter.dateFormat = "hh"
            let EndM = dateFormatter.string(from:earlyDate!)
            dateFormatter.dateFormat = "a"
            ZONE = dateFormatter.string(from:earlyDate!)
            
            self.txtTo.text = "\(EndM):00 \(ZONE)"
            self.strTo = "\(EndM):00 \(ZONE)"
        }
        else
        {
            self.txtDate.text = self.strDate
            self.txtFrom.text = self.strFrom
            self.txtTo.text = self.strTo
        }

        if self.app.isConnectedToInternet()
        {
            self.getSpaceDetailsAPI()
        }
        else
        {
            Toast(text: "Internet Connetion in not availble.Try Again").show()
        }

        if self.defaults.string(forKey: "selectedLanguage") != nil
        {
            self.strLanguage = (self.defaults.value(forKey: "selectedLanguage") as! String)
        }
        
        self.setAllDetails()
        
        self.textFieldLeftViewPadding(txt: txtDate, vv: viewDate)
        self.textFieldLeftViewPadding(txt: txtFrom, vv: viewFrom)
        self.textFieldLeftViewPadding(txt: txtTo, vv: viewTo)
        
        txtPromo.delegate = self
        txtPromo.layer.borderWidth = 1
        txtPromo.layer.borderColor = UIColor.lightGray.cgColor

        txtPromo.attributedPlaceholder = NSAttributedString(string: txtPromo.placeholder!,
                                                               attributes: [NSAttributedStringKey.foregroundColor: UIColor.darkGray])

        btnCOD.isSelected = true
        btnCOD.contentHorizontalAlignment = .left
        btnVISA.contentHorizontalAlignment = .left
        btnBANK.contentHorizontalAlignment = .left

        self.SelectedButton(btn: btnCOD)
        self.UnSelectButton(btn: btnVISA)
        self.UnSelectButton(btn: btnBANK)

        self.tblView.delegate = self
        self.tblView.dataSource = self
        
        self.lblDateTime.textAlignment = .left

        if strLanguage == "ar"
        {
            self.lblSpaceButton.textAlignment = .right
            self.lblPromoButton.textAlignment = .right
            self.lblPaymentButton.textAlignment = .right
            
            self.txtPromo.textAlignment = .right
            self.txtPromo.setRightPaddingPoints(10)
            
            self.btnCOD.frame = CGRect(x:self.btnCOD.frame.origin.x, y: self.btnCOD.frame.origin.y, width:self.btnCOD.frame.size.width - 20, height:self.btnCOD.frame.size.height)
            self.btnVISA.frame = CGRect(x:self.btnCOD.frame.origin.x + self.btnCOD.frame.size.width, y: self.btnVISA.frame.origin.y, width:self.btnVISA.frame.size.width, height:self.btnVISA.frame.size.height)
            self.btnBANK.frame = CGRect(x:self.btnVISA.frame.origin.x + self.btnVISA.frame.size.width, y: self.btnBANK.frame.origin.y, width:self.btnBANK.frame.size.width + 20, height:self.btnBANK.frame.size.height)
        }
        else
        {
            self.lblSpaceButton.textAlignment = .left
            self.lblPromoButton.textAlignment = .left
            self.lblPaymentButton.textAlignment = .left
            
            self.txtPromo.textAlignment = .left
            self.txtPromo.setLeftPaddingPoints(10)
        }
        if DeviceType.IS_IPHONE_5
        {
            btnCOD.titleLabel?.font = btnCOD.titleLabel?.font.withSize(12)
            btnVISA.titleLabel?.font = btnVISA.titleLabel?.font.withSize(12)
            btnBANK.titleLabel?.font = btnBANK.titleLabel?.font.withSize(12)
            lblTotalPrice.font = lblTotalPrice.font.withSize(20)
        }
        
        self.getLatLong()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.showSpinningWheel(_:)), name: NSNotification.Name(rawValue: "AddNewOfferView"), object: nil)
    }
    
    func showSpinningWheel(_ notification: NSNotification)
    {
        print("Call When Set")
        self.getLatLong()
    }
    
    //MARK:- Get Location
    func getLatLong()
    {
        if (CLLocationManager.locationServicesEnabled())
        {
            if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways)
            {
                currentLocation = locationManager.location
                
                if currentLocation == nil
                {
                    //                    self.alertForLocation()
                }
                else
                {
                    print(currentLocation)
                    lat = currentLocation.coordinate.latitude
                    long = currentLocation.coordinate.longitude
                    
                    self.app.lat = lat
                    self.app.long = long
                    
                    print("Lat : \(lat)\nLong : \(long)")
                    
                    self.defaults.setValue(lat, forKey: "lat") //String
                    self.defaults.setValue(long, forKey: "long") //String
                    self.defaults.synchronize()
                    
                    if defaults.string(forKey: "lat") != nil
                    {
                        lat = (defaults.value(forKey: "lat") as! Double)
                        long = (defaults.value(forKey: "long") as! Double)
                        
                        print("Lat : \(lat)\nLong : \(long)")
                    }
                }
            }
            else
            {
                //                self.alertForLocation()
            }
        }
        else
        {
            //            self.alertForLocation()
        }
    }
    
    //MARK:- ScrollView Height
    func DefaulHeightforView()
    {
        scrollView.contentSize = CGSize(width: CGFloat(scrollView.frame.size.width), height: CGFloat(viewPayment.frame.origin.y + viewPayment.frame.size.height + 15))

//        for viewAll: UIView in scrollView.subviews
//        {
//            if viewAll.tag == 101
//            {
//                scrollView.contentSize = CGSize(width: CGFloat(scrollView.frame.size.width), height: CGFloat(viewAll.frame.origin.y + viewAll.frame.size.height))
//            }
//        }
    }
    
    func textFieldLeftViewPadding(txt : UITextField, vv : UIView)
    {
        txt.leftView = vv
        txt.leftViewMode = .always
        
        txt.delegate = self
        txt.layer.borderWidth = 1
        txt.layer.borderColor = UIColor.lightGray.cgColor

        txt.attributedPlaceholder = NSAttributedString(string: txt.placeholder!,
                                                       attributes: [NSAttributedStringKey.foregroundColor: UIColor.darkGray])
        if DeviceType.IS_IPHONE_5
        {
            txt.font = txt.font?.withSize(10)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func btnMenu(_ sender: Any)
    {
        if let navController = self.navigationController
        {
            navController.popViewController(animated: true)
        }
    }
    
    @IBAction func btnDate(_ sender: Any)
    {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = NSLocale(localeIdentifier: "en") as Locale

        let maxDate = dateFormatter.date(from: strPackageEndDate)
        
        let currentDate: Date = Date()
        datePicker.minimumDate = currentDate

        if isSubscriber == "1"
        {
            DatePickerDialog().show("Date Picker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: datePicker.minimumDate!, minimumDate: datePicker.minimumDate, maximumDate: maxDate, datePickerMode: .date) { (date) in
                
                if let dt = date
                {
                    self.dateFormatter.dateFormat = "MMMM dd, yyyy"
                    self.dateFormatter.locale = NSLocale(localeIdentifier: "en") as Locale
                    
                    self.strDate = self.dateFormatter.string(from:dt as Date)
                    self.txtDate.text = self.strDate
                }
            }
        }
        else
        {
            //Only Future Date Allowed
            DatePickerDialog().show("Date Picker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", minimumDate: datePicker.minimumDate ,datePickerMode: .date) { (date) in
                if let dt = date
                {
                    self.dateFormatter.dateFormat = "MMMM dd, yyyy"
                    self.dateFormatter.locale = NSLocale(localeIdentifier: "en") as Locale
                    
                    self.strDate = self.dateFormatter.string(from:dt as Date)
                    self.txtDate.text = self.strDate
                }
            }
        }
    }
    
    @IBAction func btnFrom(_ sender: Any)
    {
        DatePickerDialog().show("Time Picker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .time) { (date) in
            if let dt = date
            {
                self.dateFormatter.dateFormat = "hh:mm"
                self.dateFormatter.locale = NSLocale(localeIdentifier: "en") as Locale
                
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
                    self.strFrom = self.dateFormatter.string(from:dt as Date)
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
    
    @IBAction func btnTo(_ sender: Any)
    {
        DatePickerDialog().show("Time Picker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .time) { (date) in
            if let dt = date
            {
                self.dateFormatter.dateFormat = "hh:mm"
                self.dateFormatter.locale = NSLocale(localeIdentifier: "en") as Locale
                
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
                    self.strTo = self.dateFormatter.string(from:dt as Date)
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
    
    //MARK:- get Space Details API
    func getSpaceDetailsAPI()
    {
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: false)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading..."
        loadingNotification.dimBackground = true
        
        let parameters: Parameters = ["user_id":self.app.strUserId,
                                      "your_space_id": self.spaceID,
                                      "capacity_id":self.capacityID]
        
        print(JSON(parameters))
        
        Alamofire.request("\(self.app.strBaseAPI)your_space_detail.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
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
                            self.scrollView.isHidden = false
                            self.viewPayNow.isHidden = false

                            self.strEsaarProductID = self.json["esaal_product_id"].stringValue
                            self.isSubscriber = self.json["is_subscriber"].stringValue
                            self.strPackageEndDate = self.json["package_end_date"].stringValue
                            self.strPackageName = self.json["package_name"].stringValue
                            self.strPackageID = self.json["package_id"].stringValue

                            self.spaceUserID = self.json["space_user_id"].intValue
                            self.strName = self.json["name"].stringValue
                            self.strProjector =  self.json["projector"].stringValue
                            self.strScanner =  self.json["scanner"].stringValue
                            self.strParking =  self.json["parking"].stringValue
                            self.strAC =  self.json["ac"].stringValue
                            self.strLocker =  self.json["locker"].stringValue
                            self.strPhone =  self.json["ph"].stringValue
                            self.strMail =  self.json["mail"].stringValue
                            self.strWifi =  self.json["wifi"].stringValue
                            self.strWork =  self.json["work"].stringValue
                            self.strMale =  self.json["male"].stringValue
                            self.strFemale =  self.json["female"].stringValue
                            self.strCoffee =  self.json["coffee"].stringValue
                            self.strLat =  self.json["lat"].stringValue
                            self.strLong =  self.json["long"].stringValue

                            if self.strLanguage == "en"
                            {
                                self.strBankName =  self.json["bank_name"].stringValue
                                self.strIbanNumber =  self.json["iban"].stringValue
                                self.strAccountNumber =  self.json["account_no"].stringValue
                            }
                            else
                            {
                                self.strBankName =  self.json["bank_name_ar"].stringValue
                                self.strIbanNumber =  self.json["iban_ar"].stringValue
                                self.strAccountNumber =  self.json["account_no_ar"].stringValue
                            }
                            
                            self.Rating = self.json["rating"].intValue
                            self.RatingCount = self.json["rating_count"].intValue
                            
                            self.strLocation =  self.json["location"].stringValue
                            self.strDescription =  self.json["description"].stringValue
                            self.strPrice =  self.json["price"].stringValue
                            self.strCapacity =  self.json["capacity"].stringValue
                            let Images = self.json["images"]
                            
                            if Images.count != 0
                            {
                                self.arrSDWebImageSource.removeAll()
                                for index in 0...Images.count-1
                                {
                                    let strImage : String = Images[index]["image"].stringValue
                                    
                                    let escapedString : String = strImage.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
                                    let strFullImage : String = "\(self.app.strImagePath)space/\(escapedString)"
                                    
                                    self.arrSDWebImageSource.append(SDWebImageSource(urlString: strFullImage)!)
                                }
                            }
                            else
                            {
                                print(self.strFullImage)
                                self.arrSDWebImageSource.append(SDWebImageSource(urlString: self.strFullImage)!)
                            }
                            
                            self.imgPager.tag = self.imgPager.currentPage
                            self.imgPager.contentScaleMode = UIViewContentMode.scaleAspectFill
                            
                            self.imgPager.pageControl.pageIndicatorTintColor = UIColor.white
                            self.imgPager.pageControl.currentPageIndicatorTintColor = UIColor.init(rgb: 0xF2932C)
                            
                            self.imgPager.activityIndicator = DefaultActivityIndicator()
                            self.imgPager.currentPageChanged = { page in
                                self.imgPager.tag = page
                            }
                            self.imgPager.setImageInputs(self.arrSDWebImageSource)
                            self.imgPager.backgroundColor = UIColor.white

                            self.lblName.text = self.strName
                            self.lblLocation.text = self.strLocation

                            self.viewRating.rating = Float(self.Rating)
                            self.lblReview.text = "(\(self.RatingCount) Reviews)"
                            
                            self.wishStatus = self.json["wish_status"].intValue
                            
                            if self.wishStatus == 1
                            {
                                self.imgHeart.image = UIImage(named: "WhiteHeart.png")
                            }
                            
                            self.lblName.text = self.strName
                            self.lblLocation.text = self.strLocation
                            self.lblPrice.text = "\(self.strPrice) SAR/Hr"
                            self.lblTotalPrice.text = "\(self.strPrice) SAR PAY NOW"
                            self.lblPerson.text = "\(self.capacityID)"

//                            if DeviceType.IS_SIMULATOR
//                            {
//                                self.isSubscriber = "1"
//                            }
                            if self.isSubscriber == "1"
                            {
                                self.lblTotalPrice.text = "BOOK NOW"
                                self.lblPackageName.isHidden = false
                                self.lblPackageName.text = "You Are Subscriber of Package : \(self.strPackageName)"
                                
                                self.scrollView.frame = CGRect(x:self.scrollView.frame.origin.x, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height, width:self.scrollView.frame.size.width, height:self.view.frame.size.height -  self.viewNavigation.frame.size.height - self.viewPayNow.frame.size.height - self.lblPackageName.frame.size.height)
                            }
                            
                            self.lblDetails.text = self.strDescription
                            let rectFirst = self.lblDetails.text?.boundingRect(with: CGSize(width: CGFloat(self.lblDetails.frame.size.width), height: CGFloat(50000)), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: self.lblDetails.font], context: nil)
                            self.lblDetails.frame = CGRect(x:self.lblDetails.frame.origin.x, y: self.lblDetails.frame.origin.y, width:self.lblDetails.frame.size.width, height:(rectFirst?.height)!)
                            
                            if self.strBankName.isEmpty
                            {
                                self.btnBANK.isEnabled = false
                                self.btnBANK.isUserInteractionEnabled = false
                            }
                            
                            var strBankText = String()
                            strBankText = "Bank Name".localized + " : \(self.strBankName)\n" + "Iban No".localized + " : \(self.strIbanNumber)\n" + "Account No".localized +  ": \(self.strAccountNumber)\n"
                            
                            self.lblBank.text = strBankText//"Bank Name : \(self.strBankName)\nIban No : \(self.strIbanNumber)\nAccount No : \(self.strAccountNumber)"
                            let rectBank = self.lblBank.text?.boundingRect(with: CGSize(width: CGFloat(self.lblBank.frame.size.width), height: CGFloat(50000)), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: self.lblBank.font], context: nil)
                            self.lblBank.frame = CGRect(x:self.lblBank.frame.origin.x, y: self.lblBank.frame.origin.y, width:self.lblBank.frame.size.width, height:(rectBank?.height)!)
                            
                            self.special = 1
                            self.setAllDetails()
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
    
    //MARK:- InsertReview API
    func insertReviewAPI()
    {
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: false)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading..."
        loadingNotification.dimBackground = true
        
        let strReviewText : String = ""//self.txtReview.text!
        
       // {"space_id":1,"user_id":1,"rating":5,"review":"asda as das das das dada asd sad"}
        let parameters: Parameters = ["space_id": self.spaceID,
                                      "user_id":self.app.strUserId,
                                      "rating":Int(self.giveRating),
                                      "review":strReviewText]
        print(JSON(parameters))

        Alamofire.request("\(self.app.strBaseAPI)insert_review.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
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
                            Toast(text: "Review Added Successfully!").show()
                            if self.app.isConnectedToInternet()
                            {
                                self.getSpaceDetailsAPI()
                            }
                            else
                            {
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
    
    func checkAvailbleBookingAPI()
    {
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: false)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading..."
        loadingNotification.dimBackground = true
        
        var strUserID = String()
        if self.app.strUserId.isEmpty
        {
            strUserID = "0"
            self.isSubscriber = "0"
        }
        else
        {
            strUserID = self.app.strUserId
        }
        
        let parameters: Parameters = ["space_id": self.spaceID,
                                      "date":self.strDate,
                                      "from_time":self.strFrom,
                                      "to_time":self.strTo,
                                      "u_id":strUserID,
                                      "is_subscribe":self.isSubscriber]
        print(JSON(parameters))
        
        Alamofire.request("\(self.app.strBaseAPI)check_available_date.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
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
                            self.LeftHours = self.json["hours"].doubleValue
                            
                            self.dateFormatter.dateFormat = "hh:mm a"
                            self.dateFormatter.locale = NSLocale.init(localeIdentifier: "en") as Locale

                            let startDate = self.dateFormatter.date(from: self.strFrom)
                            let endDate = self.dateFormatter.date(from: self.strTo)
                            
                            let Diff : String = self.daysBetweenDates(startDate: startDate!, endDate: endDate!)
                            print("Dif : \(Diff)")

                            let actual_amount : Double = Double(Diff)! * Double(self.strPrice)!
                            
                            var Dic : Dictionary<String,String> = [:]
                            Dic.updateValue(self.strDate, forKey: "date")
                            Dic.updateValue(self.strFrom, forKey: "from_time")
                            Dic.updateValue(self.strTo, forKey: "to_time")
                            Dic.updateValue(self.strFullDate, forKey: "full_date")
                            Dic.updateValue(self.strPrice, forKey: "base_amount")
                            Dic.updateValue(Diff, forKey: "hours")
                            Dic.updateValue("\(actual_amount)", forKey: "actual_amount")
                            print(Dic)
                            self.arrDate.append(Dic)
                            
                            self.viewDateList.isHidden = false
                            self.tblView.reloadData()
                            
                            self.lblPromoDiscount.isHidden = true
                            self.btnPromoApply.setTitle("APPLY", for: .normal)
                            
                            self.check = false
                            self.strPromoCodeID = "0"
                            self.strPromoPrice = "0"
                            self.strPromoDiscount = "0"
                            self.txtPromo.text = ""

                            self.GetAllTotalPrice()
                            
                            UIView.animate(withDuration: 0.4, animations: {
                                self.tblView.frame = CGRect(x:self.tblView.frame.origin.x, y: self.tblView.frame.origin.y, width:self.tblView.frame.size.width, height: CGFloat(self.arrDate.count * 35))
                                self.viewDateList.frame = CGRect(x:self.viewDateList.frame.origin.x, y: self.viewTop.frame.origin.y + self.viewTop.frame.size.height, width:self.viewDateList.frame.size.width, height: self.tblView.frame.origin.y + self.tblView.frame.size.height + 5)
                                
                                self.viewSpecial.frame = CGRect(x:self.viewSpecial.frame.origin.x, y: self.viewDateList.frame.origin.y + self.viewDateList.frame.size.height, width:self.viewSpecial.frame.size.width, height:self.SpecialHeight)
                                
                                self.setAllDetails()
                            })
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
    
    func GetAllTotalPrice()
    {
        self.TotalPrice = 0
        self.TotalDiscount = 0
        if self.arrDate.count == 0
        {
            self.lblTotalPrice.text = "\(self.strPrice) SAR PAY NOW"
        }
        else
        {
            for index in 0...self.arrDate.count-1
            {
                let dic = self.arrDate[index]
                let strPrice : String = dic["base_amount"]!
                let hours : String = dic["hours"]!
                
                let Final  : Double = Double(strPrice)! * Double(hours)!
                
                self.TotalPrice = self.TotalPrice + Final
            }
            
            if strPromoCodeID != "0"
            {
                self.TotalPrice = self.TotalPrice - Double(self.strPromoDiscount)!
                self.TotalDiscount = self.TotalDiscount + Double(self.strPromoDiscount)!
            }
            
            if isSubscriber == "1"
            {
                self.lblTotalPrice.text = "BOOK NOW"
                TotalPrice = 0
            }
            else
            {
                self.lblTotalPrice.text = "\(self.TotalPrice) SAR PAY NOW"
            }
        }
    }
    
    @IBAction func btnFavoriteHeart(_ sender: Any)
    {
        if self.app.strUserId.isEmpty
        {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.navigationController?.pushViewController(VC, animated: true)
        }
        else
        {
            if self.app.isConnectedToInternet()
            {
                self.InsertFavoriteAPI(spaceID: spaceID)
            }
            else
            {
                Toast(text: "Internet Connetion in not availble.Try Again").show()
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
                            self.wishStatus = self.json["wish_status"].intValue
                            
                            if self.wishStatus == 1
                            {
                                self.imgHeart.image = UIImage(named: "WhiteHeart.png")
                            }
                            else
                            {
                                self.imgHeart.image = UIImage(named: "heart.png")
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
    
    @IBAction func btnAllAction(_ sender: UIButton)
    {
        if sender.tag == 1
        {
            if special == 0
            {
                special = 1
            }
            else
            {
                special = 0
            }
        }
        else if sender.tag == 3
        {
            if promo == 0
            {
                promo = 1
            }
            else
            {
                promo = 0
            }
        }
        else if sender.tag == 4
        {
            if payment == 0
            {
                payment = 1
            }
            else
            {
                payment = 0
            }
        }
        self.setAllDetails()
    }
    
    func setAllDetails()
    {
        if special == 0
        {
            SpecialHeight = 55
            lblSPECIAL.isHidden = true
            lblDetails.isHidden = true
        }
        else
        {
            lblSPECIAL.isHidden = false
            lblDetails.isHidden = false
            self.lblSPECIAL.frame = CGRect(x:self.lblSPECIAL.frame.origin.x, y: self.lblSPECIAL.frame.origin.y, width:self.lblSPECIAL.frame.size.width, height:lblDetails.frame.origin.y + lblDetails.frame.size.height)

            SpecialHeight = lblDetails.frame.origin.y + lblDetails.frame.size.height + 10
        }
        
        if promo == 0
        {
            PromoHeight = 55
            lblPROMO.isHidden = true
        }
        else
        {
            lblPROMO.isHidden = false
            if self.lblPromoDiscount.isHidden == true
            {
                self.lblPROMO.frame = CGRect(x:self.lblPROMO.frame.origin.x, y: self.lblPROMO.frame.origin.y, width:self.lblPROMO.frame.size.width, height:txtPromo.frame.origin.y + txtPromo.frame.size.height + 5)

                PromoHeight = txtPromo.frame.origin.y + txtPromo.frame.size.height + 10
            }
            else
            {
                self.lblPROMO.frame = CGRect(x:self.lblPROMO.frame.origin.x, y: self.lblPROMO.frame.origin.y, width:self.lblPROMO.frame.size.width, height:lblPromoDiscount.frame.origin.y + lblPromoDiscount.frame.size.height + 5)

                PromoHeight = self.lblPromoDiscount.frame.origin.y + self.lblPromoDiscount.frame.size.height + 10
            }
        }
        
        if payment == 0
        {
            lblPAYMENT.isHidden = true
            PaymentHeight = 45
            
            self.btnCOD.isHidden = true
            self.btnVISA.isHidden = true
            self.btnBANK.isHidden = true

        }
        else
        {
            
            self.btnCOD.isHidden = false
            self.btnVISA.isHidden = false
            self.btnBANK.isHidden = false

            lblPAYMENT.isHidden = false
            if strPaymentType == "1"
            {
                self.lblVisa.isHidden = true
                self.lblBank.isHidden = true

                PaymentHeight = btnCOD.frame.origin.y + btnCOD.frame.size.height + 10
                self.lblPAYMENT.frame = CGRect(x:self.lblSPECIAL.frame.origin.x, y: self.lblSPECIAL.frame.origin.y, width:self.lblSPECIAL.frame.size.width, height:btnCOD.frame.origin.y + btnCOD.frame.size.height + 5)
            }
            else if strPaymentType == "2"
            {
                self.lblVisa.isHidden = false
                self.lblBank.isHidden = true

                PaymentHeight = lblVisa.frame.origin.y + lblVisa.frame.size.height + 10
                self.lblPAYMENT.frame = CGRect(x:self.lblSPECIAL.frame.origin.x, y: self.lblSPECIAL.frame.origin.y, width:self.lblSPECIAL.frame.size.width, height:lblVisa.frame.origin.y + lblVisa.frame.size.height + 5)
            }
            else if strPaymentType == "3"
            {
                self.lblVisa.isHidden = true
                self.lblBank.isHidden = false

                PaymentHeight = lblBank.frame.origin.y + lblBank.frame.size.height + 10
                self.lblPAYMENT.frame = CGRect(x:self.lblSPECIAL.frame.origin.x, y: self.lblSPECIAL.frame.origin.y, width:self.lblSPECIAL.frame.size.width, height:lblBank.frame.origin.y + lblBank.frame.size.height + 5)
            }
        }
        
        UIView.animate(withDuration: 0.5)
        {
            self.viewSpecial.frame = CGRect(x:self.viewSpecial.frame.origin.x, y: self.viewSpecial.frame.origin.y, width:self.viewSpecial.frame.size.width, height:self.SpecialHeight)
            
            self.viewPromo.frame = CGRect(x:self.viewPromo.frame.origin.x, y: self.viewSpecial.frame.origin.y + self.viewSpecial.frame.size.height, width:self.viewPromo.frame.size.width, height:self.PromoHeight)
            
            self.viewPayment.frame = CGRect(x:self.viewPayment.frame.origin.x, y: self.viewPromo.frame.origin.y + self.viewPromo.frame.size.height, width:self.viewPayment.frame.size.width, height:self.PaymentHeight)
            
//            self.viewPayNow.frame = CGRect(x:self.viewPayNow.frame.origin.x, y: self.viewPayment.frame.origin.y + self.viewPayment.frame.size.height + 10, width:self.viewPayment.frame.size.width, height:self.viewPayNow.frame.size.height)
            
            self.DefaulHeightforView()
        }
        
        self.buttonColorSet(btn: btnSpecial, type: special)
        self.buttonColorSet(btn: btnPromo, type: promo)
        self.buttonColorSet(btn: btnPaymnet, type: payment)
    }
    
    func buttonColorSet(btn : UIButton,type : Int)
    {
        if type == 0
        {
            btn.setTitleColor(UIColor.darkGray, for: .normal)
            btn.backgroundColor = UIColor.init(rgb: 0xDFDFDF)
            if btn == btnSpecial
            {
                lblSpaceButton.textColor = UIColor.darkGray
            }
            else if btn == btnPromo
            {
                lblPromoButton.textColor = UIColor.darkGray
            }
            else if btn == btnPaymnet
            {
                lblPaymentButton.textColor = UIColor.darkGray
            }
        }
        else
        {
            btn.setTitleColor(UIColor.white, for: .normal)
            btn.backgroundColor = UIColor.darkGray//init(rgb: 0xA6A7AB)
            if btn == btnSpecial
            {
                lblSpaceButton.textColor = UIColor.white
            }
            else if btn == btnPromo
            {
                lblPromoButton.textColor = UIColor.white
            }
            else if btn == btnPaymnet
            {
                lblPaymentButton.textColor = UIColor.white
            }
        }
        btn.layer.cornerRadius = 2
    }
    
    @IBAction func btnPayAction(_ sender: UIButton)
    {
        if self.arrDate.count == 0
        {
            Toast(text: "Please Select Date For Booking").show()
        }
        else
        {
            if strPaymentType == "2"
            {
                Toast(text: "Visa Payment Service is Temporary Not Available").show()
            }
            else
            {
                let alertController = UIAlertController(title: "Are you sure to make this Booking", message: nil, preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "NO", style: .default) { (action:UIAlertAction!) in
                    print("you have pressed the Cancel button")
                }
                alertController.addAction(cancelAction)
                
                let OKAction = UIAlertAction(title: "YES", style: .default) { (action:UIAlertAction!) in
                    print("you have pressed OK button")
                    
                    if self.app.strUserId.isEmpty
                    {
                        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                        self.navigationController?.pushViewController(VC, animated: true)
                    }
                    else
                    {
                        if self.app.isConnectedToInternet()
                        {
                            self.InsertBookingAPI()
                        }
                        else
                        {
                            Toast(text: "Internet Connetion in not availble.Try Again").show()
                        }
                    }
                }
                alertController.view.tintColor = UIColor.init(rgb: 0xF2932C)
                alertController.addAction(OKAction)
                
                self.present(alertController, animated: true, completion:nil)
            }
        }
    }
    
    @IBAction func btnPromoApply(_ sender: UIButton)
    {
        txtPromo.resignFirstResponder()
        
        if isSubscriber == "1"
        {
            Toast(text: "You are Already Subscriber").show()
        }
        else
        {
            if check == false
            {
                self.strPromoCode = txtPromo.text!
                if self.strPromoCode.isEmpty
                {
                    Toast(text: "Please Enter Promocode").show()
                }
                else
                {
                    if self.arrDate.count == 0
                    {
                        Toast(text: "Please Select Date For Booking").show()
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
            }
            else
            {
                self.lblPromoDiscount.isHidden = true
                self.btnPromoApply.setTitle("APPLY", for: .normal)
                
                check = false
                self.strPromoCodeID = "0"
                self.strPromoPrice = "0"
                self.strPromoDiscount = "0"
                self.txtPromo.text = ""
                
                self.GetAllTotalPrice()
                self.setAllDetails()
            }
        }
    }
    
    @IBAction func btnCODVISA(_ sender: DLRadioButton)
    {
        if btnCOD.isTouchInside == true
        {
            strPaymentType = "1"
            btnCOD.isSelected = true
            btnVISA.isSelected = false
            btnBANK.isSelected = false
            
            self.SelectedButton(btn: btnCOD)
            self.UnSelectButton(btn: btnVISA)
            self.UnSelectButton(btn: btnBANK)
        }
        else if btnVISA.isTouchInside == true
        {
            strPaymentType = "2"
            btnCOD.isSelected = false
            btnVISA.isSelected = true
            btnBANK.isSelected = false
            
            self.UnSelectButton(btn: btnCOD)
            self.SelectedButton(btn: btnVISA)
            self.UnSelectButton(btn: btnBANK)
        }
        else if btnBANK.isTouchInside == true
        {
            strPaymentType = "3"
            btnCOD.isSelected = false
            btnVISA.isSelected = false
            btnBANK.isSelected = true
            
            self.UnSelectButton(btn: btnCOD)
            self.UnSelectButton(btn: btnVISA)
            self.SelectedButton(btn: btnBANK)
        }
        self.setAllDetails()
    }
    
    func SelectedButton(btn : DLRadioButton)
    {
        btn.iconColor = UIColor.init(rgb: 0xF2932C)
        btn.indicatorColor = UIColor.init(rgb: 0xF2932C)
    }
    
    func UnSelectButton(btn : DLRadioButton)
    {
        btn.iconColor = UIColor.darkGray
        btn.indicatorColor = UIColor.darkGray
    }
    
    @IBAction func btnAddDate(_ sender: UIButton)
    {
        strFullDate = "\(strDate) \(strFrom) \(strTo)"
        
        if arrDate.contains(where: { $0["full_date"] == strFullDate })
        {
            Toast(text: "Cannot duplicate Date and time").show()
        }
        else
        {
            if isSubscriber == "1"
            {
                self.dateFormatter.dateFormat = "hh:mm a"
                dateFormatter.locale = NSLocale(localeIdentifier: "en") as Locale

                let startDate = dateFormatter.date(from: self.strFrom)
                let endDate = dateFormatter.date(from: self.strTo)
                
                let strDiff : String = self.daysBetweenDates(startDate: startDate!, endDate: endDate!)
                print("Diff \(strDiff)")
                
                var FinalHours = Double()
                if self.arrDate.count != 0
                {
                    for index in 0...self.arrDate.count-1
                    {
                        var dic = self.arrDate[index]
                        let hours : String = dic["hours"]!
                        
                        FinalHours = FinalHours + Double(hours)!
                    }
                }
                FinalHours = FinalHours + LeftHours + Double(strDiff)!

                let Diff = 4 - FinalHours
                
                if (Double(strDiff)! > 4.0) && (SearchID != 2)
                {
                    Toast(text: "Your Can not book space for More than 4 Hour").show()
                }
                else if Diff < 0 && SearchID != 2
                {
                    Toast(text: "Your Can not book space for More than 4 Hour").show()
                }
//                else if LeftHours <= 0
//                {
//                    Toast(text: "Your Can not book space for More than 4 Hour").show()
//                }
                else
                {
                    if self.app.isConnectedToInternet()
                    {
                        self.checkAvailbleBookingAPI()
                    }
                    else
                    {
                        Toast(text: "Internet Connetion in not availble.Try Again").show()
                    }
                }
            }
            else
            {
                if self.app.isConnectedToInternet()
                {
                    self.checkAvailbleBookingAPI()
                }
                else
                {
                    Toast(text: "Internet Connetion in not availble.Try Again").show()
                }
            }
        }
    }

//    func daysBetweenDates(startDate: Date, endDate: Date) -> Int
//    {
//        let calendar = Calendar.current
//        let components = calendar.dateComponents([Calendar.Component.hour], from: startDate, to: endDate)
//        return components.hour!
//    }
    func daysBetweenDates(startDate: Date, endDate: Date) -> String
    {
        let calendar = Calendar.current
        let components = calendar.dateComponents([Calendar.Component.hour,Calendar.Component.minute], from: startDate, to: endDate)
        if components.minute! > 0
        {
            return "\(components.hour!).5"
        }
        else
        {
            return "\(components.hour!).0"
        }
//        print(components.hour,components.minute)
//        return components.hour!
    }
    
    //MARK:- Tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.arrDate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell : DateCell!
        
        cell = tblView.dequeueReusableCell(withIdentifier: "DateCell") as! DateCell!
        if cell == nil
        {
            cell = Bundle.main.loadNibNamed("DateCell", owner: self, options: nil)?[0] as! DateCell!
        }
        
        let dic = self.arrDate[indexPath.row]
        let strFullName : String = dic["full_date"]!
        cell.lblName.text = strFullName
        
        cell.btnMinus.addTarget(self, action: #selector(btnMinusAction(sender:)), for: .touchUpInside)
        cell.btnMinus.tag = indexPath.row
        
        cell.backgroundColor = UIColor.clear
        
        cell.selectionStyle = .none
        tblView.rowHeight = cell.frame.size.height

        return cell
    }
    
    @objc func btnMinusAction(sender: UIButton!)
    {
        self.arrDate.remove(at: sender.tag)
        self.tblView.reloadData()

        self.lblPromoDiscount.isHidden = true
        self.btnPromoApply.setTitle("APPLY", for: .normal)
        
        self.check = false
        self.strPromoCodeID = "0"
        self.strPromoPrice = "0"
        self.strPromoDiscount = "0"
        self.txtPromo.text = ""
        
        self.GetAllTotalPrice()
        self.setAllDetails()
        
        UIView.animate(withDuration: 0.4, animations: {
            if self.arrDate.count == 0
            {
                self.viewDateList.isHidden = true
                
                self.viewSpecial.frame = CGRect(x:self.viewSpecial.frame.origin.x, y: self.viewTop.frame.origin.y + self.viewTop.frame.size.height, width:self.viewSpecial.frame.size.width, height:self.SpecialHeight)
            }
            else
            {
                self.viewDateList.isHidden = false

                self.tblView.frame = CGRect(x:self.tblView.frame.origin.x, y: self.tblView.frame.origin.y, width:self.tblView.frame.size.width, height: CGFloat(self.arrDate.count * 35))
                self.viewDateList.frame = CGRect(x:self.viewDateList.frame.origin.x, y: self.viewTop.frame.origin.y + self.viewTop.frame.size.height, width:self.viewDateList.frame.size.width, height: self.tblView.frame.origin.y + self.tblView.frame.size.height + 5)
                
                self.viewSpecial.frame = CGRect(x:self.viewSpecial.frame.origin.x, y: self.viewDateList.frame.origin.y + self.viewDateList.frame.size.height, width:self.viewSpecial.frame.size.width, height:self.SpecialHeight)
            }
            
            self.setAllDetails()
        })
        
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
        print(JSON(parameters))

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
                            self.Amount = self.json["amount"].doubleValue
//                            self.DiscountPrice = Amount

                            var Price = Double()
                            var Discount = Double()
                            
                            self.strPercentage = self.json["type"].stringValue
                            if self.strPercentage == "percent"
                            {
                                Discount = self.TotalPrice * self.Amount/100
                            }
                            else
                            {
                                Discount = self.Amount
                            }
                            self.DiscountPrice = Discount
                            Price = self.TotalPrice - Discount
                            
                            self.strPromoDiscount = ("\(Discount)")
                            self.strPromoPrice = ("\(Price)")
                            
                            self.lblPromoDiscount.text = "You get \(self.strPromoDiscount) SAR Dicount"
                            self.lblPromoDiscount.isHidden = false
                            
                            self.btnPromoApply.setTitle("REMOVE", for: .normal)
                            
                            self.check = true
                            
                            self.GetAllTotalPrice()
                            self.setAllDetails()
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
    
    //MARK:- InsertReview API
    func InsertBookingAPI()
    {
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: false)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading..."
        loadingNotification.dimBackground = true
        
        var arrBooking : [Dictionary<String,String>] = []
        
        for index in 0...self.arrDate.count-1
        {
            var DicData : Dictionary<String,String> = [:]
            
            var dic = self.arrDate[index]
            let date : String = dic["date"]!
            let from_time : String = dic["from_time"]!
            let to_time : String = dic["to_time"]!
            let base_amount : String = dic["base_amount"]!
            let hours : String = dic["hours"]!
            var actual_amount : String = dic["actual_amount"]!
            
            var final_discount = Double()
            if self.strPercentage == "percent"
            {
                final_discount = Double(actual_amount)! * self.Amount / 100
            }
            else
            {
                if self.Amount > Double(actual_amount)!
                {
                    final_discount = Double(actual_amount)!
                }
                else
                {
                    final_discount = self.Amount
                }
            }
            
            var amount : Double = Double(actual_amount)! - final_discount
            
            if isSubscriber == "1"
            {
                actual_amount = "0"
                amount = 0
                final_discount = 0
                TotalPrice = 0
                TotalDiscount = 0
            }
            
            DicData.updateValue(date, forKey: "date")
            DicData.updateValue(from_time, forKey: "from_time")
            DicData.updateValue(to_time, forKey: "to_time")
            DicData.updateValue(base_amount, forKey: "base_amount")
            DicData.updateValue(hours, forKey: "hours")
            DicData.updateValue(actual_amount, forKey: "actual_amount")
            DicData.updateValue("\(amount)", forKey: "amount")
            DicData.updateValue("\(final_discount)", forKey: "discount_price")

            arrBooking.append(DicData)
        }
        print(JSON(arrBooking))
        
        var parameters = Parameters()
        if isSubscriber == "1"
        {
            parameters = ["space_id": self.spaceID,
                          "user_id":self.app.strUserId,
                          "total_cost":self.TotalPrice,
                          "payment_type":self.strPaymentType,
                          "promocode_id":self.strPromoCodeID,
                          "transcation_id":"0",
                          "payment_time":"",
                          "discount_amount":self.TotalDiscount,
                          "booking":arrBooking,
                          "package_id":self.strPackageID,
                          "is_subscriber":self.isSubscriber,
                          "booking_from":"2"]
        }
        else
        {
            parameters = ["space_id": self.spaceID,
                          "user_id":self.app.strUserId,
                          "total_cost":self.TotalPrice,
                          "payment_type":self.strPaymentType,
                          "promocode_id":self.strPromoCodeID,
                          "transcation_id":"0",
                          "payment_time":"",
                          "discount_amount":self.TotalDiscount,
                          "booking":arrBooking]
        }
        
        print(JSON(parameters))
        
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
                            let VC = self.storyboard?.instantiateViewController(withIdentifier: "SuccessView") as! SuccessView
                            VC.strName = self.strName
                            VC.strCapacity = self.strCapacity
                            VC.strLocation = self.strLocation
                            VC.strPrice = self.strPrice
                            VC.arrSDWebImageSource = self.arrSDWebImageSource
                            VC.strBookingID = self.json["final_booking_id"].stringValue
                            VC.strReferenceNo = self.json["reference_no"].stringValue
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
    
    @IBAction func btnMapLication(_ sender: UIButton)
    {
        if self.app.lat == 0 || self.app.long == 0
        {
            self.alertForLocation()
        }
        else
        {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "MapView") as! MapView
            VC.strLongitude = self.strLong
            VC.strLatitude = self.strLat
            self.navigationController?.pushViewController(VC, animated: true)
        }
        

//        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!))
//        {//comgooglemaps://?saddr=23.0321,72.5252&daddr=22.9783,72.6002&zoom=14&views=traffic
//            UIApplication.shared.openURL(URL(string:
//                "comgooglemaps://?saddr=\(self.app.lat),\(self.app.long)&daddr=\(self.strLat),\(self.strLong)&zoom=14&directionsmode=driving")!)
////            UIApplication.shared.openURL(URL(string:
////                "comgooglemaps://?center=\(strLat),\(strLong)&zoom=14&views=traffic")!)
//        }
//        else
//        {
//            Toast(text: "Please install Google Map").show()
//        }
    }
    
    func alertForLocation()
    {
        let alertController = UIAlertController(title: "Location Services Disabled!", message: "Please enable Location Based Services for distance from work spaces", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Settings", style: .default) { (action:UIAlertAction!) in

            if let url = URL(string: UIApplicationOpenSettingsURLString)
                //URL(string: "App-Prefs:root=LOCATION_SERVICES")
            {
                if #available(iOS 10.0, *)
                {
                    UIApplication.shared.open(url, completionHandler: .none)
                }
                else
                {
                    UIApplication.shared.openURL(url)
                }
            }
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Cancel", style: .default) { (action:UIAlertAction!) in
            
        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
    
}
