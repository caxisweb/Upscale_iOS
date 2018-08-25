//
//  BookingListView.swift
//  Upscale
//
//  Created by Developer on 14/04/17.
//  Copyright © 2017 krutik. All rights reserved.
//

import UIKit
import DatePickerDialog
import Toaster
import Alamofire
import SwiftyJSON
import MBProgressHUD
import MapKit
//import NHRangeSlider


class BookingListView: BaseViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,MKMapViewDelegate
{
    //MARK:- Outlet
    //MARK:-
    @IBOutlet var lblList: UILabel!
    @IBOutlet var lblMap: UILabel!
    
    @IBOutlet var viewList: UIView!
    @IBOutlet var tblView: UITableView!
    
    
    
    @IBOutlet var viewMap: UIView!
    @IBOutlet var mapView: MKMapView!
    
    
    //PopUp View
    @IBOutlet var viewPopUp: UIView!
    @IBOutlet var viewDetails: UIView!
    
    
    @IBOutlet var txtLocation: UITextField!
    @IBOutlet var viewLocationLeft: UIView!
    @IBOutlet var viewLocationRight: UIView!
    
    @IBOutlet var txtSpaceType: UITextField!
    @IBOutlet var viewSpaceTypeLeft: UIView!
    @IBOutlet var viewSpaceTypeRight: UIView!
    
    @IBOutlet var txtOperator: UITextField!
    @IBOutlet var viewOperatorLeft: UIView!
    @IBOutlet var viewOperatorRight: UIView!
    
    @IBOutlet var viewSlider: UIView!
    
    @IBOutlet var txtDate: UITextField!
    @IBOutlet var viewDate: UIView!

    @IBOutlet var txtFrom: UITextField!
    @IBOutlet var viewfrom: UIView!
    
    @IBOutlet var txtTo: UITextField!
    @IBOutlet var viewTo: UIView!
    
    
    @IBOutlet var btnProjectors: UIButton!
    @IBOutlet var btnScanner: UIButton!
    @IBOutlet var btnParking: UIButton!
    @IBOutlet var btnAirConditiner: UIButton!
    @IBOutlet var btnLockers: UIButton!
    @IBOutlet var btnPhone: UIButton!
    @IBOutlet var btnMail: UIButton!
    @IBOutlet var btnWifi: UIButton!
    @IBOutlet var btnWork: UIButton!
    @IBOutlet var btnMale: UIButton!
    @IBOutlet var btnFemale: UIButton!
    @IBOutlet var btnCoffee: UIButton!

    @IBOutlet var btnShowSpace: UIButton!
    
    @IBOutlet var btnSpaceType: NiceButton!
    
    @IBOutlet var btnFilter: UIButton!
    
    @IBOutlet var tblCityView: UITableView!
    
    @IBOutlet var lblLOCATION: UILabel!
    @IBOutlet var lblPRICERANGE: UILabel!
    @IBOutlet var lblDATE: UILabel!
    @IBOutlet var lblFROM: UILabel!
    @IBOutlet var lblTO: UILabel!
    @IBOutlet var lblAMENITIES: UILabel!
    
    
    
    
    
    
    var loadingNotification : MBProgressHUD!
    var json : JSON!
    var strMessage : String!
    
//    var app = AppDelegate()

    //MAP
    var locationManager: CLLocationManager?
    var strFormattedAddress: String = ""
    var latitude: Float = 0.0
    var longitude: Float = 0.0
    
    var iProjector : Int = 0
    var iScanner : Int = 0
    var iParking : Int = 0
    var iAirConditioner : Int = 0
    var iLockers : Int = 0
    var iPhone : Int = 0
    var iMailServer : Int = 0
    var iWiFi : Int = 0
    var iWork : Int = 0
    var iMale : Int = 0
    var iFemale : Int = 0
    var iCoffee : Int = 0

    var checkProjects = Bool()
    var checkScanner = Bool()
    var checkParking = Bool()
    var checkAirConditioner = Bool()
    var checkLockers = Bool()
    var checkPhone = Bool()
    var checkMailServer = Bool()
    var checkWiFi = Bool()
    var checkWork = Bool()
    var checkMale = Bool()
    var checkFemale = Bool()
    var checkCoffee = Bool()

    var strDate = String()
    var strFrom = String()
    var strTo = String()
    
    var datePicker = UIDatePicker()
    var currentDate = Date()

    
    var selectedSpace = Int()
    var strLocation = String()
    var strDateTime = String()
    var strFromTime = String()
    var strToTime = String()
    
    var selectedMeeting = Int()
    var selectedDesk = Int()
    var selectedDescuss = Int()
    var selectedPrivate = Int()
    var selectedConfrance = Int()

    
    var arrList : [Any] = []
    
    //Map Array
    var arrCoordinates : [[Double]] = []
    var arrNames : [String] = []
    var arrAddresses : [String] = []
    
    var arrReview : [String] = []
    var arrRate : [String] = []
    var arrHour : [String] = []
    var arrUser : [String] = []
    var arrWifi : [String] = []
    var arrCall : [String] = []
    var arrMail : [String] = []
    var arrWork : [String] = []
    var arrKm : [String] = []
    var arrImages : [String] = []
    
    var arrID : [String] = []
    
    var arrLat : [Double] = []
    var arrLong : [Double] = []
    
    var lat = Double()
    var long = Double()
    let defaults = UserDefaults.standard

//    var sliderWithLabelFollowView = NHRangeSliderView()
    var iLowerValue = Int()
    var iUpperValue = Int()
    
    var x = CGFloat()
    var y = CGFloat()
    
    let SelectSpaceTypeDropdown = DropDown()
    
    lazy var dropDowns: [DropDown] =
        {
            return [
                self.SelectSpaceTypeDropdown
            ]
    }()
    
    var spaceType = Int()
    var strFilterDateTime = String()
    var strFilterFromTime = String()
    var strFilterToTime = String()

    //City
    var arrCity : [String] = []
    var arrCityID : [String] = []
    var arrSearch : [String] = []
    var arrSearchID : [String] = []
    
    var strCityName = String()
    var strCityID = String()
    
    var isSearching: Bool = false
    
    var strLanguage = "English"

    //MARK:-
    override func viewDidLoad()
    {
        super.viewDidLoad()
//        app = UIApplication.shared.delegate as! AppDelegate
        self.navigationController?.isNavigationBarHidden = true
        
        tblView.dataSource = self
        tblView.delegate = self
        tblView.separatorStyle = .none
        
        self.hideViewAndLine(lbl: lblMap, vv: viewMap)
//        self.hideViewAndLine(lbl: lblList, vv: viewList)
        
        //view Popup
        viewPopUp.isHidden = true
        viewSlider.isHidden = true
        viewDetails.layer.cornerRadius = 5
        self.textFieldPaddingView(txt: txtLocation, vl: viewLocationLeft, vr: viewLocationRight)
        self.textFieldPaddingView(txt: txtSpaceType, vl: viewSpaceTypeLeft, vr: viewSpaceTypeRight)
        
        self.textFieldRightViewPadding(txt: txtDate, vv: viewDate)
        self.textFieldRightViewPadding(txt: txtFrom, vv: viewfrom)
        self.textFieldRightViewPadding(txt: txtTo, vv: viewTo)
        
        datePicker.minimumDate = currentDate
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd"
        
        self.strDate = dateFormatter.string(from:currentDate as Date)
        txtDate.placeholder = self.strDate
        
        let df = DateFormatter()
        df.dateFormat = "hh:mm a"
        
        self.strFrom = df.string(from:currentDate as Date)
        txtFrom.placeholder = self.strFrom
        txtTo.placeholder = self.strFrom

        self.btnShowSpace.layer.cornerRadius = btnShowSpace.frame.size.height / 2
        
        if defaults.string(forKey: "lat") != nil
        {
            lat = (defaults.value(forKey: "lat") as! Double)
            long = (defaults.value(forKey: "long") as! Double)
            
            print("Lat : \(lat)\nLong : \(long)")
        }
        
        // Slider
        if DeviceType.IS_IPHONE_5
        {
            x = 25
            y = 35
        }
        else if DeviceType.IS_IPHONE_6
        {
            x = 25
            y = 40
        }
        else if DeviceType.IS_IPHONE_6P
        {
            x = 25
            y = 50
        }
//
//        sliderWithLabelFollowView = NHRangeSliderView(frame: CGRect(x: self.viewSlider.frame.origin.x + x, y: self.viewSlider.frame.origin.y + y,width: self.viewSlider.frame.size.width,height: self.viewSlider.frame.size.height) )
//
//        sliderWithLabelFollowView.trackHighlightTintColor = UIColor.lightGray
//        sliderWithLabelFollowView.lowerValue = 0.0
//        sliderWithLabelFollowView.upperValue = 1000.0
//        sliderWithLabelFollowView.gapBetweenThumbs = 1
//
//        sliderWithLabelFollowView.minimumValue = 0.0
//        sliderWithLabelFollowView.maximumValue = 1000.0
//
//        sliderWithLabelFollowView.thumbLabelStyle = .FOLLOW
//        //        sliderWithLabelFollowView.titleLabel?.text = "Slider with labels follow thumbs"
//
//        sliderWithLabelFollowView.thumbTintColor = UIColor(rgb: 0xE9983E)
//        sliderWithLabelFollowView.thumbBorderColor = UIColor(rgb: 0xFFF8D3)
//        sliderWithLabelFollowView.trackHighlightTintColor = UIColor(rgb: 0xE0E0E0)
//        sliderWithLabelFollowView.lowerLabel?.textColor = UIColor.lightGray
//        sliderWithLabelFollowView.upperLabel?.textColor = UIColor.lightGray
//
//        sliderWithLabelFollowView.sizeToFit()
////        self.view.addSubview(sliderWithLabelFollowView)
//        self.viewPopUp.addSubview(sliderWithLabelFollowView)
//
//        iLowerValue = Int((sliderWithLabelFollowView.lowerLabel?.text)!)!
//        iUpperValue = Int((sliderWithLabelFollowView.upperLabel?.text)!)!
        
        var strTYPE = String()
        if selectedSpace == 1
        {
            strTYPE = "MEETING ROOM"
        }
        else if selectedSpace == 2
        {
            strTYPE = "DESK"
        }
        else if selectedSpace == 3
        {
            strTYPE = "DESCUSSION ROOM"
        }
        else if selectedSpace == 4
        {
            strTYPE = "PRIVATE ROOM"
        }
        else if selectedSpace == 5
        {
            strTYPE = "CONFERENCE ROOM"
        }
        else
        {
            strTYPE = "OTHERS"
        }
        
        self.spaceType = selectedSpace
        self.txtSpaceType.text = strTYPE
        
        strFilterDateTime = strDateTime
        strFilterToTime = strToTime
        strFilterFromTime =  strFromTime
        self.txtDate.text = strFilterDateTime
        self.txtFrom.text = strFilterFromTime
        self.txtTo.text = strFilterToTime
        
        setupSelectSpaceTypeDropdown()
        
        if strLanguage == "ar"
        {
            lblLOCATION.textAlignment = .right
            lblPRICERANGE.textAlignment = .right
            lblDATE.textAlignment = .right
            lblFROM.textAlignment = .right
            lblTO.textAlignment = .right
            lblAMENITIES.textAlignment = .right
        }
        else
        {
            lblLOCATION.textAlignment = .left
            lblPRICERANGE.textAlignment = .left
            lblDATE.textAlignment = .left
            lblFROM.textAlignment = .left
            lblTO.textAlignment = .left
            lblAMENITIES.textAlignment = .left
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        app = UIApplication.shared.delegate as! AppDelegate

        if self.app.isConnectedToInternet()
        {
            self.getBookingListAPI()
        }
        else
        {
            Toast(text: "Internet Connetion in not availble.Try Again").show()
        }
        tblView.isHidden = true
        
        tblCityView.isHidden = true
        tblCityView.delegate = self
        tblCityView.dataSource = self

        
        
    }
    
    @IBAction func btnBack(_ sender: Any)
    {
        if let navController = self.navigationController
        {
            navController.popViewController(animated: true)
        }
    }
    
    func getMapLatLong()
    {
//        var countries: [String] = ["Germany","Germany","Poland","Denmark"]
//        var practiceRoute: [CLLocationCoordinate2D] = [CLLocationCoordinate2DMake(50, 10),CLLocationCoordinate2DMake(52, 9),CLLocationCoordinate2DMake(53, 20),CLLocationCoordinate2DMake(56, 14)]
//        
//        for i in 0 ..< practiceRoute.count {
//            
//            let annotation = MKPointAnnotation()
//            annotation.title = countries[i]
//            annotation.coordinate = practiceRoute[i]
//            self.mapView.addAnnotation(annotation)
//        }
        
        // 1)
        mapView.mapType = MKMapType.standard
        
//        var arrMap : [Dictionary<String,String>] = [["lat":"23.0225","long":"72.5714"],["lat":"23.3225","long":"72.1714"]]
        
        // 2)
        let location = CLLocationCoordinate2D(latitude: 23.0225,longitude: 72.5714)
        
        // 3)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        // 4)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "iOS Dev Center "
        annotation.subtitle = "Ahmedabad"
        mapView.addAnnotation(annotation)
    }
    
    
    
    @IBAction func btnMenu(_ sender: Any)
    {
        if let navController = self.navigationController
        {
            navController.popViewController(animated: true)
        }
    }
    
    
    //MARK:-
    func hideViewAndLine(lbl : UILabel, vv : UIView)
    {
        lbl.isHidden = true
        vv.isHidden = true
    }
    func showViewAndLine(lbl : UILabel, vv : UIView)
    {
        lbl.isHidden = false
        vv.isHidden = false
    }
    
    func textFieldPaddingView(txt : UITextField, vl : UIView, vr : UIView)
    {
        txt.rightView = vr
        txt.rightViewMode = .always
        
        txt.leftView = vl
        txt.leftViewMode = .always
        
        txt.delegate = self
        txt.layer.cornerRadius = 3
        txt.layer.borderWidth = 1
        txt.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func textFieldRightViewPadding(txt : UITextField, vv : UIView)
    {
        txt.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)

        txt.rightView = vv
        txt.rightViewMode = .always

        txt.delegate = self
        txt.layer.cornerRadius = 3
        txt.layer.borderWidth = 1
        txt.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    //MARK:- Menu
    
    @IBAction func btnList(_ sender: Any)
    {
        self.showViewAndLine(lbl: lblList, vv: viewList)
        self.hideViewAndLine(lbl: lblMap, vv: viewMap)
    }

    @IBAction func btnMap(_ sender: Any)
    {
        self.showViewAndLine(lbl: lblMap, vv: viewMap)
        self.hideViewAndLine(lbl: lblList, vv: viewList)
    }
    
    //MARK:- TablViwe
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if tableView == tblCityView
        {
            return 1
        }
        else
        {
            
        }
        return self.arrList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == tblCityView
        {
            if isSearching
            {
                return self.arrSearch.count
            }
            else
            {
                return self.arrCity.count
            }
        }
        else
        {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var CELL = UITableViewCell()
        if tableView == tblCityView
        {
            var cell : TextFiledCell!
            cell = tblView.dequeueReusableCell(withIdentifier: "TextFiledCell") as! TextFiledCell!
            if cell == nil
            {
                cell = Bundle.main.loadNibNamed("TextFiledCell", owner: self, options: nil)?[0] as! TextFiledCell!
            }
            if isSearching
            {
                cell.lblName.text = self.arrSearch[indexPath.row]
            }
            else
            {
                cell.lblName.text = self.arrCity[indexPath.row]
            }
            
            cell.selectionStyle = .none
            tblCityView.rowHeight = cell.frame.size.height
            
            CELL = cell
        }
        else
        {
            var cell : BookingListCell!
            cell = tblView.dequeueReusableCell(withIdentifier: "BookingListCell") as! BookingListCell!
            if cell == nil
            {
                cell = Bundle.main.loadNibNamed("BookingListCell", owner: self, options: nil)?[0] as! BookingListCell!
            }
            
            var arrValue = JSON(self.arrList)
            
            let strName : String = arrValue[indexPath.section]["name"].stringValue
            let strCall : String = arrValue[indexPath.section]["ph"].stringValue
            let strMail : String = arrValue[indexPath.section]["mail"].stringValue
            let strWifi : String = arrValue[indexPath.section]["wifi"].stringValue
            let strWork : String = arrValue[indexPath.section]["work"].stringValue
            
            let strKM : String = arrValue[indexPath.section]["distance"].stringValue
            let strLike : String = arrValue[indexPath.section]["wish_status"].stringValue
            
            if strLike == "1"
            {
                cell.imgHeart.image = UIImage(named: "likeheart.png")
            }
            
            let strLocation : String = arrValue[indexPath.section]["location"].stringValue
            let strPrice : String = arrValue[indexPath.section]["price"].stringValue
            let strImage : String = ("\(arrValue[indexPath.section]["img"].stringValue)")
            
            let escapedString : String = strImage.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            
            let strFullImage : String = "\(self.app.strImagePath)space/\(escapedString)"
            cell.imgProfile.sd_setImage(with: URL(string: strFullImage), placeholderImage: nil)
            
            let rateCount : Int = arrValue[indexPath.section]["rating_count"].intValue
            let rating : Int = arrValue[indexPath.section]["rating"].intValue
            let strCapacity : String = arrValue[indexPath.section]["capacity"].stringValue
            
            cell.lblUser.text = strCapacity
            
            cell.lblName.text = strName
            cell.lblAddress.text = strLocation
            cell.lblHour.text = strPrice
            
            cell.lblReviews.text = "(\(rateCount) reviews)"
            cell.lblKM.text = strKM
            
            if strCall == "0"
            {
                cell.imgCall.isHidden = true
            }
            if strMail == "0"
            {
                cell.imgMail.isHidden = true
            }
            if strWifi == "0"
            {
                cell.imgWifi.isHidden = true
            }
            if strWork == "0"
            {
                cell.imgWork.isHidden = true
            }
            
            
            cell.viewRating.emptyImage = UIImage(named: "starg2.png")
            cell.viewRating.fullImage = UIImage(named: "star.png")
            
            cell.viewRating.contentMode = UIViewContentMode.scaleAspectFit
            cell.viewRating.maxRating = 5
            cell.viewRating.minRating = 1
            cell.viewRating.editable = false
            cell.viewRating.halfRatings = false
            cell.viewRating.backgroundColor = UIColor.clear
            cell.viewRating.rating = Float(rating)
            
            cell.viewLeft.layer.cornerRadius = 3
            cell.viewLeft.clipsToBounds = true
            
            cell.lblUser.layer.cornerRadius = cell.lblUser.frame.size.height / 2
            cell.lblUser.clipsToBounds = true
            
            cell.btnHeart.addTarget(self, action: #selector(likeHeartAction), for: .touchUpInside)
            cell.btnHeart.tag = indexPath.section
            
            cell.selectionStyle = .none
            tblView.rowHeight = cell.frame.size.height
            CELL = cell
        }
        
        
        
        return CELL
    }
    
    func likeHeartAction(sender: UIButton!)
    {
        var arrValue = JSON(self.arrList)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView == tblCityView
        {
            if isSearching
            {
                self.strLocation = self.arrSearch[indexPath.row]
            }
            else
            {
                self.strLocation = self.arrCity[indexPath.row]
            }
            
            self.txtLocation.text = self.strLocation
            self.tblCityView.isHidden = true
            self.txtLocation.resignFirstResponder()
            
            if let i = self.arrCity.index(of: self.strLocation)
            {
                self.strCityID = self.arrCityID[i]
            }
        }
        else
        {
            var arrValue = JSON(self.arrList)
            
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "BookingListDetailView") as! BookingListDetailView
            VC.capacityID = arrValue[indexPath.section]["capacity"].intValue
            VC.spaceID = arrValue[indexPath.section]["space_id"].intValue
            self.navigationController?.pushViewController(VC, animated: true)
        }
        
        
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
    
    //MARK:- MAP VIEW Delegate
    
    
    //MARK:- PopUp
    
    @IBAction func btnFilter(_ sender: Any)
    {
        self.viewPopUp.isHidden = false
        
        
    }
    
    @IBAction func btnCancelPopup(_ sender: Any)
    {
        self.viewPopUp.isHidden = true
    }
    
    @IBAction func btnSpaceType(_ sender: Any)
    {
        SelectSpaceTypeDropdown.show()
    }
    
    func setupSelectSpaceTypeDropdown()
    {
        SelectSpaceTypeDropdown.anchorView = btnSpaceType
        
        SelectSpaceTypeDropdown.bottomOffset = CGPoint(x: 0, y: btnSpaceType.bounds.height)
        
        // You can also use localizationKeysDataSource instead. Check the docs.
        let strMEETING : String = "MEETING ROOM"//.localized
        let strDESK : String = "DESK"//.localized
        let strDESCUSSION : String = "DESCUSSION ROOM"//.localized
        let strPRIVATE : String = "PRIVATE ROOM"//.localized
        let strCONFERENCE : String = "CONFERENCE ROOM"//.localized
        let strOTHERS : String = "OTHERS"//.localized

        SelectSpaceTypeDropdown.dataSource = [strMEETING,
                                              strDESK,
                                              strDESCUSSION,
                                              strPRIVATE,
                                              strCONFERENCE,
                                              strOTHERS]
        
        SelectSpaceTypeDropdown.frame.origin.x = btnSpaceType.frame.origin.x
        SelectSpaceTypeDropdown.width = btnSpaceType.frame.size.width
        
        // Action triggered on selection
        SelectSpaceTypeDropdown.selectionAction =
            { [unowned self] (index, item) in

                self.txtSpaceType.text = item
                self.spaceType = index + 1
                print(self.spaceType)
        }
    }
    
    
    @IBAction func btnDate(_ sender: Any)
    {
        //Only Future Date Allowed
        DatePickerDialog().show("Date Picker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", minimumDate: datePicker.minimumDate ,datePickerMode: .date) { (date) in
            if let dt = date
            {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMMM dd, yyyy"
                dateFormatter.locale = NSLocale(localeIdentifier: "en") as Locale

                self.strFilterDateTime = dateFormatter.string(from:dt as Date)
                self.txtDate.text = self.strFilterDateTime
            }
        }
        
    }
    
    @IBAction func btnFrom(_ sender: Any)
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
                    self.strFilterFromTime = dateFormatter.string(from:dt as Date)
                    print(self.strFilterFromTime)
                    self.strFilterFromTime = self.strFilterFromTime + " \(strAMPM)"
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
                            self.strFilterFromTime = ("0\(H):00")
                        }
                        else
                        {
                            self.strFilterFromTime = ("\(H):00")
                        }
                    }
                    else
                    {
                        if H < 10
                        {
                            self.strFilterFromTime = ("0\(H):\(M)")
                        }
                        else
                        {
                            self.strFilterFromTime = ("\(H):\(M)")
                        }
                    }
                    self.strFilterFromTime = self.strFilterFromTime + " \(strAMPM)"
                }
                
                self.txtFrom.text = self.strFilterFromTime
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
                
                let H : Int = Int(strHour)!
                var M : Int = Int(strMinut)!
                
                if M == 00 || M == 30
                {
                    self.strFilterToTime = dateFormatter.string(from:dt as Date)
                    print(self.strFilterToTime)
                    self.strFilterToTime = self.strFilterToTime + " \(strAMPM)"
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
                            self.strFilterToTime = ("0\(H):00")
                        }
                        else
                        {
                            self.strFilterToTime = ("\(H):00")
                        }
                    }
                    else
                    {
                        if H < 10
                        {
                            self.strFilterToTime = ("0\(H):\(M)")
                        }
                        else
                        {
                            self.strFilterToTime = ("\(H):\(M)")
                        }
                    }
                    self.strFilterToTime = self.strFilterToTime + " \(strAMPM)"
                }
                
                self.txtTo.text = self.strFilterToTime
            }
            
        }
    }
    
    //MARK:- Btn AMenities
    @IBAction func btnAmenities(_ sender: Any)
    {
        if btnProjectors.isTouchInside == true
        {
            if checkProjects
            {
                let image = UIImage(named: "unchecklog.png")
                btnProjectors.setImage(image, for: UIControlState.normal)
                
                checkProjects = false
                iProjector = 0
            }
            else
            {
                let image = UIImage(named: "checked.png")
                btnProjectors.setImage(image, for: UIControlState.normal)
                
                checkProjects = true
                iProjector = 1
            }
        }
        else if btnScanner.isTouchInside == true
        {
            if checkScanner
            {
                let image = UIImage(named: "unchecklog.png")
                btnScanner.setImage(image, for: UIControlState.normal)
                
                checkScanner = false
                iScanner = 0
            }
            else
            {
                let image = UIImage(named: "checked.png")
                btnScanner.setImage(image, for: UIControlState.normal)
                
                checkScanner = true
                iScanner = 1
            }
        }
        else if btnParking.isTouchInside == true
        {
            if checkParking
            {
                let image = UIImage(named: "unchecklog.png")
                btnParking.setImage(image, for: UIControlState.normal)
                
                checkParking = false
                iParking = 0
            }
            else
            {
                let image = UIImage(named: "checked.png")
                btnParking.setImage(image, for: UIControlState.normal)
                
                checkParking = true
                iParking = 1
            }
        }
        else if btnAirConditiner.isTouchInside == true
        {
            if checkAirConditioner
            {
                let image = UIImage(named: "unchecklog.png")
                btnAirConditiner.setImage(image, for: UIControlState.normal)
                
                checkAirConditioner = false
                iAirConditioner = 0
            }
            else
            {
                let image = UIImage(named: "checked.png")
                btnAirConditiner.setImage(image, for: UIControlState.normal)
                
                checkAirConditioner = true
                iAirConditioner = 1
            }
        }
        else if btnLockers.isTouchInside == true
        {
            if checkLockers
            {
                let image = UIImage(named: "unchecklog.png")
                btnLockers.setImage(image, for: UIControlState.normal)
                
                checkLockers = false
                iLockers = 0
            }
            else
            {
                let image = UIImage(named: "checked.png")
                btnLockers.setImage(image, for: UIControlState.normal)
                
                checkLockers = true
                iLockers = 1
            }
        }
        else if btnPhone.isTouchInside == true
        {
            if checkPhone
            {
                let image = UIImage(named: "unchecklog.png")
                btnPhone.setImage(image, for: UIControlState.normal)
                
                checkPhone = false
                iPhone = 0
            }
            else
            {
                let image = UIImage(named: "checked.png")
                btnPhone.setImage(image, for: UIControlState.normal)
                
                checkPhone = true
                iPhone = 1
            }
        }
        else if btnMail.isTouchInside == true
        {
            if checkMailServer
            {
                let image = UIImage(named: "unchecklog.png")
                btnMail.setImage(image, for: UIControlState.normal)
                
                checkMailServer = false
                iMailServer = 0
            }
            else
            {
                let image = UIImage(named: "checked.png")
                btnMail.setImage(image, for: UIControlState.normal)
                
                checkMailServer = true
                iMailServer = 1
            }
        }
        else if btnWifi.isTouchInside == true
        {
            if checkWiFi
            {
                let image = UIImage(named: "unchecklog.png")
                btnWifi.setImage(image, for: UIControlState.normal)
                
                checkWiFi = false
                iWiFi = 0
            }
            else
            {
                let image = UIImage(named: "checked.png")
                btnWifi.setImage(image, for: UIControlState.normal)
                
                checkWiFi = true
                iWiFi = 1
            }
        }
        else if btnWork.isTouchInside == true
        {
            if checkWork
            {
                let image = UIImage(named: "unchecklog.png")
                btnWork.setImage(image, for: UIControlState.normal)
                
                checkWork = false
                iWork = 0
            }
            else
            {
                let image = UIImage(named: "checked.png")
                btnWork.setImage(image, for: UIControlState.normal)
                
                checkWork = true
                iWork = 1
            }
        }
        else if btnMale.isTouchInside == true
        {
            if checkMale
            {
                let image = UIImage(named: "unchecklog.png")
                btnMale.setImage(image, for: UIControlState.normal)
                
                checkMale = false
                iMale = 0
            }
            else
            {
                let image = UIImage(named: "checked.png")
                btnMale.setImage(image, for: UIControlState.normal)
                
                checkMale = true
                iMale = 1
            }
        }
        else if btnFemale.isTouchInside == true
        {
            if checkFemale
            {
                let image = UIImage(named: "unchecklog.png")
                btnFemale.setImage(image, for: UIControlState.normal)
                
                checkFemale = false
                iFemale = 0
            }
            else
            {
                let image = UIImage(named: "checked.png")
                btnFemale.setImage(image, for: UIControlState.normal)
                
                checkFemale = true
                iFemale = 1
            }
        }
        else if btnCoffee.isTouchInside == true
        {
            if checkCoffee
            {
                let image = UIImage(named: "unchecklog.png")
                btnCoffee.setImage(image, for: UIControlState.normal)
                
                checkCoffee = false
                iCoffee = 0
            }
            else
            {
                let image = UIImage(named: "checked.png")
                btnCoffee.setImage(image, for: UIControlState.normal)
                
                checkCoffee = true
                iCoffee = 1
            }
        }
    }
    
    
    //MARK:- Btn Show Space
    @IBAction func btnShowSpace(_ sender: Any)
    {
//        iLowerValue = Int((sliderWithLabelFollowView.lowerLabel?.text)!)!
//        iUpperValue = Int((sliderWithLabelFollowView.upperLabel?.text)!)!
        
        if (txtLocation.text?.isEmpty)!
        {
            Toast(text: "Please Select Location").show()
        }
        else if (txtSpaceType.text?.isEmpty)!
        {
            Toast(text: "Please Select Space Type").show()
        }
        if (txtDate.text?.isEmpty)!
        {
            Toast(text: "Please Select Date").show()
        }
        else if (txtFrom.text?.isEmpty)!
        {
            Toast(text: "Please Select Time").show()
        }
        else if (txtTo.text?.isEmpty)!
        {
            Toast(text: "Please Select Time").show()
        }
        else
        {
            print("Location : \(txtLocation.text!)")
            print("Space Type : \(txtSpaceType.text!)")

            print("Lower : \(iLowerValue)")
            print("Uper : \(iUpperValue)")
            
            print("Date : \(strDate)")
            print("Frome : \(strFrom)")
            print("To : \(strTo)")

            print("Project : \(iProjector)")
            print("Air : \(iAirConditioner)")
            print("Mail : \(iMailServer)")
            print("Scanner : \(iScanner)")
            print("Lockers : \(iLockers)")
            print("Wifi : \(iWiFi)")
            print("Parking : \(iParking)")
            print("Phone : \(iPhone)")
            print("Work : \(iWork)")
            print("Male : \(iMale)")
            print("Female : \(iFemale)")
            print("Coffee : \(iCoffee)")

            if self.app.isConnectedToInternet()
            {
                self.filterAPI()
            }
            else
            {
                Toast(text: "Internet Connetion in not availble.Try Again").show()
            }
        }
    }
    
    //MARK:- BookingList
    func getBookingListAPI()
    {
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: false)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading..."
        loadingNotification.dimBackground = true
        
        //{"date":"2017-04-17","fromtime":"08:00","totime":"10:00","space_type":1,"location":"abc street"}
        let parameters: Parameters = ["user_id":self.app.strUserId,
                                      "date":self.strDateTime,
                                      "fromtime":self.strFromTime,
                                      "totime":self.strToTime,
                                      "space_type":self.selectedSpace,
                                      "location": self.strLocation,
//                                      "meeting_room":selectedMeeting,
//                                      "desk":selectedDesk,
//                                      "discussion_room":selectedDescuss,
//                                      "private_room":selectedPrivate,
//                                      "conference_room":selectedConfrance,
                                      "lat":lat,
                                      "long":long]
        print(parameters)
        
        Alamofire.request("\(self.app.strBaseAPI)booking_datetime.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
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
                        
                        //MARK:- Get City
                        self.getCityAPI()

                        if strStatus == "1"
                        {
                            self.tblView.isHidden = false
                            self.arrList.removeAll()
                            
                            self.arrID.removeAll()
                            self.arrCoordinates.removeAll()
                            self.arrNames.removeAll()
                            self.arrAddresses.removeAll()
                            self.arrReview.removeAll()
                            self.arrRate.removeAll()
                            self.arrHour.removeAll()
                            self.arrUser.removeAll()
                            self.arrWifi.removeAll()
                            self.arrCall.removeAll()
                            self.arrMail.removeAll()
                            self.arrWork.removeAll()
                            self.arrKm.removeAll()
                            self.arrImages.removeAll()
                            
                            self.arrLat.removeAll()
                            self.arrLong.removeAll()
                            
                            self.arrList = self.json["space_list"].arrayValue
                            
                            self.tblView.reloadData()
                            
                            var arrValue = JSON(self.arrList)
                            
                            for i in 0..<arrValue.count
                            {
                                let strSpaceId : String = arrValue[i]["space_id"].stringValue
                                
                                let strLat : String = arrValue[i]["lat"].stringValue
                                let strLong : String = arrValue[i]["long"].stringValue

                                let strName : String = arrValue[i]["name"].stringValue
                                let strAddresses : String = arrValue[i]["location"].stringValue

                                let strReview : String = arrValue[i]["rating_count"].stringValue
                                let strRating : String = arrValue[i]["rating"].stringValue
                                let strHour : String = arrValue[i]["price"].stringValue
                                
                                let strUser : String = arrValue[i]["capacity"].stringValue

                                let strWifi : String = arrValue[i]["wifi"].stringValue
                                let strCall : String = arrValue[i]["ph"].stringValue
                                let strMail : String = arrValue[i]["mail"].stringValue
                                let strWork : String = arrValue[i]["work"].stringValue

                                let strImages : String = arrValue[i]["img"].stringValue
                                let strKM : String = arrValue[i]["distance"].stringValue
                                
                                if strLat != "0" && strLong != "0"
                                {
                                    self.arrID.append(strSpaceId)
                                    self.arrLat.append(Double(strLat)!)
                                    self.arrLong.append(Double(strLong)!)
                                    
                                    
                                    self.arrNames.append(strName)
                                    self.arrAddresses.append(strAddresses)
                                    
                                    self.arrReview.append(strReview)
                                    self.arrRate.append(strRating)
                                    self.arrHour.append(strHour)
                                    self.arrUser.append(strUser)
                                    
                                    self.arrWifi.append(strWifi)
                                    self.arrCall.append(strCall)
                                    self.arrMail.append(strMail)
                                    self.arrWork.append(strWork)
                                    
                                    self.arrImages.append(strImages)
                                    self.arrKm.append(strKM)
                                }
                                
                            }
                            
                            self.mapView.delegate = self

                            for i in 0...self.arrID.count-1
                            {
                                let LAT = self.arrLat[i]
                                let LONG = self.arrLong[i]
                                
                                let point = StarbucksAnnotation(coordinate: CLLocationCoordinate2D(latitude: LAT , longitude: LONG))
                                point.image = UIImage(named: "starbucks-\(i+1).jpg")
                                point.name = self.arrNames[i]
                                point.address = self.arrAddresses[i]
                                
                                point.review = self.arrReview[i]
                                point.rate = self.arrRate[i]
                                point.hour = self.arrHour[i]
                                point.user = self.arrUser[i]
                                point.wifi = self.arrWifi[i]
                                point.call = self.arrCall[i]
                                point.mail = self.arrMail[i]
                                point.work = self.arrWork[i]
                                point.km = self.arrKm[i]
                                
                                point.id = self.arrID[i]
                                point.img = self.arrImages[i]
                                
                                self.mapView.addAnnotation(point)
                            }
                            // 3

                            let LAT = self.arrLat[0]
                            let LONG = self.arrLong[0]
                            
                            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: LAT, longitude: LONG), span: MKCoordinateSpan(latitudeDelta: 0.2,longitudeDelta: 0.2))
                            self.mapView.setRegion(region, animated: true)
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        if annotation is MKUserLocation
        {
            return nil
        }
        var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: "Pin")
        if annotationView == nil
        {
            annotationView = AnnotationView(annotation: annotation, reuseIdentifier: "Pin")
            annotationView?.canShowCallout = false
        }
        else
        {
            annotationView?.annotation = annotation
        }
        
        // Resize image
        let pinImage = UIImage(named: "AnnotationBlack.png")
        let size = CGSize(width: 30, height: 45)
        UIGraphicsBeginImageContext(size)
        pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        annotationView?.image = resizedImage
        
        
        return annotationView
    }
    
    //MARK:- Map Delegate
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        // 1
        if view.annotation is MKUserLocation
        {
            // Don't proceed with custom callout
            return
        }
        // 2
        
        let pinImage = UIImage(named: "AnnotationOrange.png")
        let size = CGSize(width: 45, height: 40)
        UIGraphicsBeginImageContext(size)
        pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        view.image = resizedImage
        
        
        let starbucksAnnotation = view.annotation as! StarbucksAnnotation
        let views = Bundle.main.loadNibNamed("CustomCalloutView", owner: nil, options: nil)
        let calloutView = views?[0] as! CustomCalloutView
        calloutView.lblName.text = starbucksAnnotation.name
        calloutView.lblAddress.text = starbucksAnnotation.address
        
        let img : String = starbucksAnnotation.img
        
        let escapedString : String = img.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        print(escapedString)
        
        let strImage : String = ("\(self.app.strImagePath)space/\(escapedString)")
        calloutView.imgProfile.sd_setImage(with: URL(string: strImage), placeholderImage: nil)

        let strReview : String = starbucksAnnotation.review
        calloutView.lblReviews.text = ("(\(strReview) reviews)")
        
        
        calloutView.viewRating.emptyImage = UIImage(named: "starg2.png")
        calloutView.viewRating.fullImage = UIImage(named: "star.png")
        
        calloutView.viewRating.contentMode = UIViewContentMode.scaleAspectFit
        calloutView.viewRating.maxRating = 5
        calloutView.viewRating.minRating = 1
        calloutView.viewRating.editable = false
        calloutView.viewRating.halfRatings = false
        calloutView.viewRating.backgroundColor = UIColor.clear
        
        calloutView.viewRating.rating = Float(starbucksAnnotation.rate)!
        calloutView.lblUser.text = starbucksAnnotation.user
        
        calloutView.lblUser.layer.cornerRadius = calloutView.lblUser.layer.frame.size.height / 2
        calloutView.lblUser.clipsToBounds = true

        if starbucksAnnotation.wifi == "0"
        {
            calloutView.imgWifi.isHidden = true
        }
        if starbucksAnnotation.call == "0"
        {
            calloutView.imgCall.isHidden = true
        }
        if starbucksAnnotation.mail == "0"
        {
            calloutView.imgMail.isHidden = true
        }
        if starbucksAnnotation.work == "0"
        {
            calloutView.imgWork.isHidden = true
        }
        
        let strKM : String = starbucksAnnotation.km
        calloutView.lblKM.text = ("\(strKM)")

        
        let button = UIButton(frame: calloutView.frame)
        button.addTarget(self, action: #selector(BookingListView.callPhoneNumber(sender:)), for: .touchUpInside)
        button.tag = Int(starbucksAnnotation.id)!
        calloutView.addSubview(button)

        // 3
        calloutView.center = CGPoint(x: view.bounds.size.width / 2, y: -calloutView.bounds.size.height*0.52)
        view.addSubview(calloutView)
        mapView.setCenter((view.annotation?.coordinate)!, animated: true)
        
    }
    
    func callPhoneNumber(sender: UIButton)
    {
        let v = sender.superview as! CustomCalloutView
        print("Space Id : \(sender.tag)")
        
        let strUser : String = v.lblUser.text!
        print(strUser)
        
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "BookingListDetailView") as! BookingListDetailView
        VC.spaceID = sender.tag
        VC.capacityID = Int(strUser)!
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView)
    {
        let pinImage = UIImage(named: "AnnotationBlack.png")
        let size = CGSize(width: 30, height: 45)
        UIGraphicsBeginImageContext(size)
        pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        view.image = resizedImage
        
        if view.isKind(of: AnnotationView.self)
        {
            for subview in view.subviews
            {
                subview.removeFromSuperview()
            }
        }
    }
    
    func InsertFavoriteAPI(spaceID : Int)
    {
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: false)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading..."
        loadingNotification.dimBackground = true
        
        //        {"type":"facebook","type_id":"1","image":"abc.jpg","name":"jaydeep","email":"jaydeep.wwe@gmail.com","gcm_id":"a"}
        
        
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
                           self.getBookingListAPI()
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
    
    //MARK:- BookingList
    func filterAPI()
    {
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: false)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading..."
        loadingNotification.dimBackground = true
        
        //{"space_type": "2", "location":"1", "min_price":40, "max_price":100, "is_projector":"1", "is_parking":"0", "is_scaner":"0", "is_ac":"0", "is_lockers":"0", "is_phone":"0", "is_mail_service":"0", "is_internet":"0", "is_work_24":"0", "fromtime":"05:30 PM", "totime":"06:30 PM", "date":"June 12, 2017"}
        
        
        let parameters: Parameters = ["user_id":self.app.strUserId,
                                      "space_type":self.spaceType,
                                      "location": self.strCityID,
                                      "min_price": self.iLowerValue,
                                      "max_price": self.iUpperValue,
                                      "is_projector": self.iProjector,
                                      "is_parking": self.iParking,
                                      "is_scaner": self.iScanner,
                                      "is_ac": self.iAirConditioner,
                                      "is_lockers": self.iLockers,
                                      "is_phone": self.iPhone,
                                      "is_mail_service": self.iMailServer,
                                      "is_internet": self.iWiFi,
                                      "is_work_24": self.iWork,
                                      "is_male": self.iMale,
                                      "is_female": self.iFemale,
                                      "is_coffee": self.iCoffee,
                                      "date":self.strFilterDateTime,
                                      "fromtime":self.strFilterFromTime,
                                      "totime":self.strFilterToTime,
                                      "lat":lat,
                                      "long":long]
        print(parameters)
        
        Alamofire.request("\(self.app.strBaseAPI)booking_datetime.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
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
                        
                        self.viewPopUp.isHidden = true
                        
                        if strStatus == "1"
                        {
                            self.tblView.isHidden = false
                            self.arrList.removeAll()
                            
                            self.arrID.removeAll()
                            self.arrCoordinates.removeAll()
                            self.arrNames.removeAll()
                            self.arrAddresses.removeAll()
                            self.arrReview.removeAll()
                            self.arrRate.removeAll()
                            self.arrHour.removeAll()
                            self.arrUser.removeAll()
                            self.arrWifi.removeAll()
                            self.arrCall.removeAll()
                            self.arrMail.removeAll()
                            self.arrWork.removeAll()
                            self.arrKm.removeAll()
                            self.arrImages.removeAll()
                            
                            self.arrLat.removeAll()
                            self.arrLong.removeAll()
                            
                            self.arrList = self.json["space_list"].arrayValue
                            
                            self.tblView.reloadData()
                            
                            var arrValue = JSON(self.arrList)
                            
                            for i in 0..<arrValue.count
                            {
                                let strSpaceId : String = arrValue[i]["space_id"].stringValue
                                
                                let strLat : String = arrValue[i]["lat"].stringValue
                                let strLong : String = arrValue[i]["long"].stringValue
                                
                                let strName : String = arrValue[i]["name"].stringValue
                                let strAddresses : String = arrValue[i]["location"].stringValue
                                
                                let strReview : String = arrValue[i]["rating_count"].stringValue
                                let strRating : String = arrValue[i]["rating"].stringValue
                                let strHour : String = arrValue[i]["price"].stringValue
                                
                                let strUser : String = arrValue[i]["capacity"].stringValue
                                
                                let strWifi : String = arrValue[i]["wifi"].stringValue
                                let strCall : String = arrValue[i]["ph"].stringValue
                                let strMail : String = arrValue[i]["mail"].stringValue
                                let strWork : String = arrValue[i]["work"].stringValue
                                
                                let strImages : String = arrValue[i]["img"].stringValue
                                let strKM : String = arrValue[i]["distance"].stringValue
                                
                                
                                self.arrID.append(strSpaceId)
                                //                                self.arrCoordinates.append([Double(strLat)!,Double(strLong)!])
                                self.arrLat.append(Double(strLat)!)
                                self.arrLong.append(Double(strLong)!)
                                
                                
                                self.arrNames.append(strName)
                                self.arrAddresses.append(strAddresses)
                                
                                self.arrReview.append(strReview)
                                self.arrRate.append(strRating)
                                self.arrHour.append(strHour)
                                self.arrUser.append(strUser)
                                
                                self.arrWifi.append(strWifi)
                                self.arrCall.append(strCall)
                                self.arrMail.append(strMail)
                                self.arrWork.append(strWork)
                                
                                self.arrImages.append(strImages)
                                self.arrKm.append(strKM)
                            }
                            
                            self.mapView.delegate = self
                            
                            for i in 0...self.arrID.count-1
                            {
                                let LAT = self.arrLat[i]
                                let LONG = self.arrLong[i]
                                
                                let point = StarbucksAnnotation(coordinate: CLLocationCoordinate2D(latitude: LAT , longitude: LONG))
                                point.image = UIImage(named: "starbucks-\(i+1).jpg")
                                point.name = self.arrNames[i]
                                point.address = self.arrAddresses[i]
                                //                                point.phone = self.phones[i]
                                
                                point.review = self.arrReview[i]
                                point.rate = self.arrRate[i]
                                point.hour = self.arrHour[i]
                                point.user = self.arrUser[i]
                                point.wifi = self.arrWifi[i]
                                point.call = self.arrCall[i]
                                point.mail = self.arrMail[i]
                                point.work = self.arrWork[i]
                                point.km = self.arrKm[i]
                                
                                point.id = self.arrID[i]
                                point.img = self.arrImages[i]
                                
                                self.mapView.addAnnotation(point)
                            }
                            // 3
                            
                            let LAT = self.arrLat[0]
                            let LONG = self.arrLong[0]
                            
                            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: LAT, longitude: LONG), span: MKCoordinateSpan(latitudeDelta: 0.2,longitudeDelta: 0.2))
                            self.mapView.setRegion(region, animated: true)
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
    
    //MARK:- Get All City API
    func getCityAPI()
    {
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: false)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading..."
        loadingNotification.dimBackground = true
        
        
        Alamofire.request("\(self.app.strBaseAPI)fetch_city.php", method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { response in
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
                            self.arrCity.removeAll()
                            let arrData = self.json["city"].arrayValue
                            
                            for i in 0 ..< arrData.count
                            {
                                self.strCityName = arrData[i]["city_name"].stringValue
                                self.strCityID = arrData[i]["city_id"].stringValue
                                
                                self.arrCity.append(self.strCityName)
                                self.arrCityID.append(self.strCityID)
                                
                                if self.strLocation == self.strCityID
                                {
                                    self.txtLocation.text = self.strCityName
                                }
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
    
    //MARK:- Textfiled Methods
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let strText : String = txtLocation.text!
        
        var strFinalString = String()
        if string.isEmpty
        {
            strFinalString = strText.substring(to: strText.index(before: strText.endIndex))
        }
        else
        {
            strFinalString = ("\(strText)\(string)")
        }
        self.getSearch(strSearch: strFinalString)
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        self.tblCityView.isHidden = false
        self.tblCityView.reloadData()
        
        if DeviceType.IS_IPHONE_5
        {
            tblCityView.frame.origin.y = tblCityView.frame.origin.y + 2
        }
        tblCityView.frame = CGRect(x: tblCityView.frame.origin.x, y: tblCityView.frame.origin.y, width: tblCityView.frame.size.width, height: CGFloat(40 * self.arrCity.count))
    }
    
    func getSearch(strSearch : String)
    {
        isSearching = true
        
        //        let predicate = NSPredicate(format: "SELF contains %@", strSearch)
        let predicate = NSPredicate(format: "SELF contains[cd] %@", strSearch)
        arrSearch = arrCity.filter { predicate.evaluate(with: $0) }
        
        if (strSearch.isEmpty)
        {
            self.arrSearch = self.arrCity
        }
        tblCityView.frame = CGRect(x: tblCityView.frame.origin.x, y: tblCityView.frame.origin.y, width: tblCityView.frame.size.width, height: CGFloat(40 * self.arrSearch.count))
        tblCityView.reloadData()
        tblCityView.isHidden = false
    }
    
    @available(iOS 10.0, *)
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason)
    {
        self.tblCityView.isHidden = true
        isSearching = false
    }
    
    
}
