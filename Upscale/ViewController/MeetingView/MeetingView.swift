//
//  MeetingView.swift
//  Upscale
//
//  Created by Developer on 14/04/17.
//  Copyright © 2017 krutik. All rights reserved.
//

import UIKit
import DatePickerDialog
import Toaster
import CoreLocation


class MeetingView: BaseViewController,UITextFieldDelegate,CLLocationManagerDelegate
{
    //MARK:- 
    @IBOutlet var viewUser: UIView!
    @IBOutlet var lblUser: UILabel!
    
    @IBOutlet var txtDate: UITextField!
    @IBOutlet var viewDate: UIView!
    
    @IBOutlet var txtFrome: UITextField!
    @IBOutlet var viewFrome: UIView!
    
    @IBOutlet var txtTo: UITextField!
    @IBOutlet var viewTo: UIView!
    
    @IBOutlet var btnNext: UIButton!
    @IBOutlet var btnBack: UIButton!
    
    
    @IBOutlet var imgBookingType: UIImageView!
    @IBOutlet var lblBookingType: UILabel!
    @IBOutlet var viewRepeat: UIView!
    
    @IBOutlet var txtEndDate: UITextField!
    @IBOutlet var viewSelectDate: UIView!
    
    @IBOutlet var btnSelectRepeat: UIButton!
    
    
    @IBOutlet var btnType: NiceButton!
    @IBOutlet var btnSubType: NiceButton!
    
    @IBOutlet var lblType: UILabel!
    
    @IBOutlet var lblSubType: UILabel!
    
    @IBOutlet var viewSelect: UIView!
    
    @IBOutlet var viewTop: UIView!
    
    
    @IBOutlet var lblLangDate: UILabel!
    @IBOutlet var lblLangfrom: UILabel!
    @IBOutlet var lblLangTo: UILabel!
    
    
    
    let SelectTypeDropdown = DropDown()
    let SelectSubTypeDropdown = DropDown()
    
    lazy var dropDowns: [DropDown] =
        {
            return [
                self.SelectTypeDropdown,
                self.SelectSubTypeDropdown
            ]
    }()
    
    var strType = "Day"
    var strSubType = "Select"
    var strLanguage = "English"
    var iType = Int()

    var strDate = String()
    var strFrom = String()
    var strTo = String()
    
    var datePicker = UIDatePicker()
    var currentDate = Date()

    var strLocation = String()
    var selectedSpace = Int()
    var IntUser = Int()
    var img = UIImage()
    let defaults = UserDefaults.standard

    var selectedMeeting = Int()
    var selectedDesk = Int()
    var selectedDescuss = Int()
    var selectedPrivate = Int()
    var selectedConfrance = Int()
    
    var repeatCount = 0
    var strDayType = "Day"
    var strEndDate = String()

    var check = Bool()

    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var lat = Double()
    var long = Double()

    //MARK:-
    //MARK:-
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        viewUser.layer.cornerRadius = viewUser.frame.size.height / 2
        viewUser.clipsToBounds = true
    
        
        self.btnCornerRadiation(btn: btnBack)
        self.btnCornerRadiation(btn: btnNext)

        datePicker.minimumDate = currentDate
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        dateFormatter.locale = NSLocale(localeIdentifier: "en") as Locale
        
        self.strDate = dateFormatter.string(from:currentDate as Date)
        txtDate.placeholder = self.strDate
        txtDate.text = self.strDate
        
        let df = DateFormatter()
        df.dateFormat = "hh:mm a"
        df.locale = NSLocale(localeIdentifier: "en") as Locale

        self.strFrom = df.string(from:currentDate as Date)
        txtFrome.placeholder = self.strFrom
        txtTo.placeholder = self.strFrom
        
        
        var strName = String()
        var image = UIImage()

        if selectedSpace == 1
        {
            strName = "MEETING ROOM".localized
            image = UIImage(named:"meetingBlack.png")!
        }
        else if selectedSpace == 2
        {
            strName = "DESK".localized
            image = UIImage(named:"Darkdesk-1.png")!
        }
        else if selectedSpace == 3
        {
            strName = "DISCUSSION ROOM".localized
            image = UIImage(named:"Darkdiscussroom.png")!
        }
        else if selectedSpace == 4
        {
            strName = "PRIVATE ROOM".localized
            image = UIImage(named:"Darkprivate_room.png")!
        }
        else if selectedSpace == 5
        {
            strName = "CONFERENCE ROOM".localized
            image = UIImage(named:"Darkconforance.png")!
        }
        else if selectedSpace == 6
        {
            strName = "OTHERS".localized
            image = UIImage(named:"otherDark.png")!
        }
        else
        {
            self.lblBookingType.isHidden = true
            self.imgBookingType.isHidden = true
            self.viewUser.isHidden = true
        }

        self.lblBookingType.text = strName
        self.imgBookingType.image = image
        self.setLabelOffTo()

        self.lblUser.text = String(IntUser)
        
        print("space \(selectedSpace)")
        print("location : \(strLocation)")
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        self.getLatLong()

//        viewSelect.isHidden = true
        setupSelectTypeDropdown()
        self.btnSetDesign(btn: btnType)
        
        if self.defaults.string(forKey: "selectedLanguage") != nil
        {
            self.strLanguage = (self.defaults.value(forKey: "selectedLanguage") as! String)
        }
        
        if strLanguage == "ar"
        {
            txtDate.textAlignment = .right
            txtTo.textAlignment = .right
            txtFrome.textAlignment = .right
            txtEndDate.textAlignment = .right
            
            lblLangDate.textAlignment = .right
            lblLangfrom.textAlignment = .right
            lblLangTo.textAlignment = .right
            
            self.textFieldPaddingLeftView(txt: txtDate, vv: viewDate)
            self.textFieldPaddingLeftView(txt: txtFrome, vv: viewFrome)
            self.textFieldPaddingLeftView(txt: txtTo, vv: viewTo)
            self.textFieldPaddingLeftView(txt: txtEndDate, vv: viewSelectDate)

        }
        else
        {
            lblLangDate.textAlignment = .left
            lblLangfrom.textAlignment = .left
            lblLangTo.textAlignment = .left
            
            
            self.textFieldPaddingView(txt: txtDate, vv: viewDate)
            self.textFieldPaddingView(txt: txtFrome, vv: viewFrome)
            self.textFieldPaddingView(txt: txtTo, vv: viewTo)
            self.textFieldPaddingView(txt: txtEndDate, vv: viewSelectDate)

        }
        viewRepeat.isHidden = true
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
    
    
    func setLabelOffTo()
    {
        let strName : String = lblBookingType.text!
        
        //        lblBookingType.frame = CGRect(x: 0, y: 0, width: strName, height: 0)
        
        let stringsize1: CGSize = strName.size(withAttributes: [NSAttributedStringKey.font : lblBookingType.font]) //UIFont.systemFont(ofSize: CGFloat(14))
        lblBookingType.frame = CGRect(x: lblBookingType.frame.origin.x, y: lblBookingType.frame.origin.y, width: CGFloat(stringsize1.width + 10), height: lblBookingType.frame.size.height)
        lblBookingType.center.x = viewTop.center.x
        
        viewUser.frame = CGRect(x: lblBookingType.frame.origin.x + lblBookingType.frame.size.width + CGFloat(5), y: viewUser.frame.origin.y, width: viewUser.frame.size.width, height: viewUser.frame.size.height)
        imgBookingType.frame = CGRect(x: lblBookingType.frame.origin.x - imgBookingType.frame.size.width - CGFloat(5), y: imgBookingType.frame.origin.y, width: imgBookingType.frame.size.width, height: imgBookingType.frame.size.height)
    }
    
    func btnSetDesign(btn : UIButton)
    {
        btn.layer.cornerRadius = 3
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    
    @IBAction func btnTypeAction(_ sender: Any)
    {
        SelectTypeDropdown.show()
    }
    
    @IBAction func btnSubTypeAction(_ sender: Any)
    {
        self.SelectSubTypeDropdown.show()
    }
    
    func setupSelectTypeDropdown()
    {
        SelectTypeDropdown.anchorView = btnType
        
        SelectTypeDropdown.bottomOffset = CGPoint(x: 0, y: btnType.bounds.height)
        
        // You can also use localizationKeysDataSource instead. Check the docs.
        SelectTypeDropdown.dataSource = ["Day",
                                         "Week",
                                         "Month"]
        
        SelectTypeDropdown.frame.origin.x = btnType.frame.origin.x
        SelectTypeDropdown.width = btnType.frame.size.width
        
        // Action triggered on selection
        SelectTypeDropdown.selectionAction =
            { [unowned self] (index, item) in
                //                self.btnType.setTitle(item, for: .normal)
                
                self.strDayType = item
                self.lblType.text = self.strDayType
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

    
    
    //MARK:- Get Location
    func getLatLong()
    {
        if (CLLocationManager.locationServicesEnabled())
        {
            if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways)
            {
                currentLocation = locationManager.location
                
                print(currentLocation)
                lat = currentLocation.coordinate.latitude
                long = currentLocation.coordinate.longitude
                
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
            else
            {
                self.alertForEnableLocation()
            }
        }
        else
        {
            self.alertForEnableLocation()
        }
    }
    
    func alertForEnableLocation()
    {
        let alertController = UIAlertController(title: "Please Enable Your GPS", message: "Location services are not Enable!", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func textFieldPaddingView(txt : UITextField, vv : UIView)
    {
        txt.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
        txt.rightView = vv
        txt.rightViewMode = .always
        txt.delegate = self
        
        txt.layer.borderWidth = 1
        txt.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func textFieldPaddingLeftView(txt : UITextField, vv : UIView)
    {
        txt.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
        txt.leftView = vv
        txt.leftViewMode = .always
        txt.delegate = self
        
        txt.layer.borderWidth = 1
        txt.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func btnCornerRadiation(btn: UIButton)
    {
        btn.layer.cornerRadius = btn.layer.frame.size.height / 2
        btn.clipsToBounds = true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField .resignFirstResponder()
        return true
    }

    @IBAction func btnBack(_ sender: Any)
    {
        if let navController = self.navigationController
        {
            navController.popViewController(animated: true)
        }
    }
    
    @IBAction func btnMenu(_ sender: Any)
    {
        if let navController = self.navigationController
        {
            navController.popViewController(animated: true)
        }
    }
    
    //MARK:-
//    @IBAction func btnBack(_ sender: Any)
//    {
//        if let navController = self.navigationController
//        {
//            navController.popViewController(animated: true)
//        }
//    }
    
    //MARK:- Buuton Action
    
    @IBAction func btnDate(_ sender: Any)
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
    
    @IBAction func btnFrome(_ sender: Any)
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
                
                self.txtFrome.text = self.strFrom
            }
            
        }
    }
    
    @IBAction func btnTo(_ sender: Any)
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
                
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "hh:mm"
//                dateFormatter.locale = NSLocale(localeIdentifier: "en") as Locale
//
//                let df1 = DateFormatter()
//                df1.dateFormat = "hh"
//                let strHour : String = df1.string(from:dt as Date)
//
//                let df2 = DateFormatter()
//                df2.dateFormat = "mm"
//                let strMinut : String = df2.string(from: dt as Date)
//
//                let df3 = DateFormatter()
//                df3.dateFormat = "a"
//                let strAMPM : String = df3.string(from: dt as Date)
                
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
    
    
    @IBAction func bthnNext(_ sender: Any)
    {
        if (self.txtDate.text?.isEmpty)!
        {
            Toast(text: "Please Select Date").show()
        }
        else if (self.txtFrome.text?.isEmpty)!
        {
            Toast(text: "Please Select Time").show()
        }
        else if (self.txtTo.text?.isEmpty)!
        {
            Toast(text: "Please Select Time").show()
        }
        else
        {
            if check == true
            {
                if (self.txtEndDate.text?.isEmpty)!
                {
                    Toast(text: "Please Select End Time").show()
                }
                else
                {
                    self.nextPage()
                }
            }
            else
            {
                self.nextPage()
            }
        }
    }
    
    func nextPage()
    {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "BookingListView") as! BookingListView
        VC.strLocation = self.strLocation
        VC.selectedSpace = selectedSpace
        VC.strDateTime = self.strDate
        VC.strFromTime = self.strFrom
        VC.strToTime = self.strTo
        VC.selectedSpace = selectedSpace
        //            VC.selectedDesk = selectedDesk
        //            VC.selectedDescuss = selectedDescuss
        //            VC.selectedPrivate = selectedPrivate
        //            VC.selectedConfrance = selectedConfrance
        self.navigationController?.pushViewController(VC, animated: true)
        
        self.defaults.setValue(self.strDate, forKey: "date") //String
        self.defaults.setValue(self.strFrom, forKey: "fromtime") //String
        self.defaults.setValue(self.strTo, forKey: "totime") //String
        self.defaults.setValue(self.strEndDate, forKey: "enddate") //String
        self.defaults.setValue(self.repeatCount, forKey: "repeat") //String
        
        self.defaults.synchronize()
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
            strDayType = "Day"
            lblType.text = strDayType
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
