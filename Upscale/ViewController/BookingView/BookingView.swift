//
//  BookingView.swift
//  Upscale
//
//  Created by Developer on 12/04/17.
//  Copyright © 2017 krutik. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD
import Toaster
import CoreLocation
import IQDropDownTextField
import DatePickerDialog
import MapKit
import ImageSlideshow
import GoogleMobileAds

class BookingView: BaseViewController,CLLocationManagerDelegate,IQDropDownTextFieldDelegate,IQDropDownTextFieldDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,RangeSeekSliderDelegate,MKMapViewDelegate,UIGestureRecognizerDelegate,GADBannerViewDelegate
{
    //MARK:- IBOutlet
    
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var viewTop: UIView!
    @IBOutlet var viewBottom: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var clView: UICollectionView!
    @IBOutlet var clSearchView: UICollectionView!

    @IBOutlet var txtCity: IQDropDownTextField!
    
//    @IBOutlet var viewCity: UIView!
    @IBOutlet var tblView: UITableView!
    
    @IBOutlet var txtDate: UITextField!
    @IBOutlet var viewDate: UIView!
    
    @IBOutlet var txtFrom: UITextField!
    @IBOutlet var viewfrom: UIView!
    
    @IBOutlet var txtTo: UITextField!
    @IBOutlet var viewTo: UIView!

    
    @IBOutlet var viewSlider: RangeSeekSlider!

    
    @IBOutlet var viewPopUp: UIView!
    @IBOutlet var viewSearch: UIView!

    @IBOutlet var txtSearchCity: IQDropDownTextField!
    @IBOutlet var txtSearchType: IQDropDownTextField!

    @IBOutlet var txtSearchDate: UITextField!
    @IBOutlet var viewSearchDate: UIView!
    
    @IBOutlet var txtSearchFrom: UITextField!
    @IBOutlet var viewSearchfrom: UIView!
    
    @IBOutlet var txtSearchTo: UITextField!
    @IBOutlet var viewSearchTo: UIView!

    @IBOutlet var btnSearch: UIButton!
    @IBOutlet var lblRange: UILabel!
    @IBOutlet var viewMap: MKMapView!
    
    @IBOutlet var lblSelectCity: UILabel!
    
    @IBOutlet var btnSearchNormal: UIButton!
    
    
    @IBOutlet var lblADVANCESEARCH: UILabel!
    @IBOutlet var lblPRICE: UILabel!
    @IBOutlet var lblFACILITY: UILabel!
    
    @IBOutlet var viewAdd: UIView!
    @IBOutlet var imgBanner: ImageSlideshow!
    @IBOutlet var viewGoogleAdd: GADBannerView!
    
    var arrCity : [String] = []
    var arrCityID : [String] = []
    var arrSearch : [String] = []
    var arrSearchID : [String] = []
    
    var strCityName = String()
    var strCityID = String()

    var strSearchName = String()
    var strSearchCityID = String()

    var loadingNotification : MBProgressHUD!
    var json : JSON!
    var strMessage : String!
    
//    var app = AppDelegate()
    
    var strLocation = String()
    var IntUser = Int()
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    var lat = Double()
    var long = Double()
    let defaults = UserDefaults.standard

    var strLanguage = "English"
    var iCurrent = 0
    
    var defaultSelected = 0
    
    var arrTypeSelected = [#imageLiteral(resourceName: "Meeting Room_512.png"),#imageLiteral(resourceName: "Desk_512.png"),#imageLiteral(resourceName: "Private Room_512.png"),#imageLiteral(resourceName: "Conference Room_512.png"),#imageLiteral(resourceName: "Others_512.png")]
    var arrType = [#imageLiteral(resourceName: "Meeting Room_ Black 512.png"),#imageLiteral(resourceName: "Desk_BLACk 512.png"),#imageLiteral(resourceName: "Private Room_Black512.png"),#imageLiteral(resourceName: "Conference Room_Black 512.png"),#imageLiteral(resourceName: "Others_Black 512.png")]
    var arrAmenities : [String] = []
    var arrSelected : [String] = []

    var arrFacility = [Dictionary<String,String>]()
    
    var arrSpace : [String] = []
    
    var cell = TypeCell()
    var cellSearch = ListYourPlaceCell()
    var selectedSpace = Int()
    var selectedSpaceName = String()

    fileprivate lazy var allTextFields: [IQDropDownTextField] = {
        let allTextFields: [IQDropDownTextField] = [
        ]
        return allTextFields
    }()
    
    var strDateTimeFormate = String()
    var strDateTime = String()
    var strFromTime = String()
    var strToTime = String()

    var strSearchDateTime = String()
    var strSearchFromTime = String()
    var strSearchToTime = String()

    var datePicker = UIDatePicker()
    var currentDate = Date()

    var MinValue = Int()
    var MaxValue = Int()

    var arrList : [Any] = []
    //MAP
    var LM: CLLocationManager?
    var strFormattedAddress: String = ""
    var latitude: Float = 0.0
    var longitude: Float = 0.0
    
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
    var arrPrice : [String] = []

    var arrLat : [Double] = []
    var arrLong : [Double] = []
    
    var Check = Bool()
    
    var ID = 1
    var SearchID = 1
    var arrSpaceID = [1,2,4,5,6]
    
    var iProjector : Int = 0
    var iAirConditioner : Int = 0
    var iMailServer : Int = 0
    var iScanner : Int = 0
    var iLockers : Int = 0
    var iWiFi : Int = 0
    var iParking : Int = 0
    var iPhone : Int = 0
    var iWork : Int = 0
    var iMale : Int = 0
    var iFemale : Int = 0
    var iCoffee : Int = 0
    
    var strImage = String()
    var escapedString = String()
    var strFullImage = String()
    var strURL = String()

    
    //MARK:-
    //MARK:-
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true

        if DeviceType.IS_IPHONE_X
        {
            self.viewNavigation.frame = CGRect(x:self.viewNavigation.frame.origin.x, y: self.viewNavigation.frame.origin.y, width:self.viewNavigation.frame.size.width, height:88)
            self.viewTop.frame = CGRect(x:self.viewTop.frame.origin.x, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height, width:self.viewTop.frame.size.width, height:self.viewTop.frame.size.height)
            self.viewBottom.frame = CGRect(x:self.viewBottom.frame.origin.x, y: self.viewTop.frame.origin.y + self.viewTop.frame.size.height, width:self.viewBottom.frame.size.width, height:self.view.frame.size.height -  self.viewTop.frame.origin.y - self.viewTop.frame.size.height)
        }
        
        arrSpace.removeAll()
        arrSpace.append("Meeting Room".localized)
        arrSpace.append("Desk".localized)
        arrSpace.append("Private Room".localized)
        arrSpace.append("Conference Room".localized)
        arrSpace.append("Others".localized)
        self.selectedSpaceName = arrSpace[selectedSpace]
        
        self.viewPopUp.isHidden = true
        self.viewMap.isHidden = true
        
        self.MinValue = 0
        self.MaxValue = 1000

        // custom number formatter range slider
        viewSlider.delegate = self
        viewSlider.minValue = 0.0
        viewSlider.maxValue = 1000
        viewSlider.selectedMinValue = CGFloat(self.MinValue)
        viewSlider.selectedMaxValue = CGFloat(self.MaxValue)
        viewSlider.selectedHandleDiameterMultiplier = 1.0
        viewSlider.colorBetweenHandles = UIColor.lightGray//.red
        viewSlider.lineHeight = 1//10.0
        viewSlider.tintColor = UIColor.lightGray
        viewSlider.handleColor = UIColor.darkGray
        viewSlider.minLabelColor = UIColor.darkGray //02A862
        viewSlider.maxLabelColor = UIColor.darkGray
//        viewSlider.tintColor = UIColor.init(rgb: 0x02A862)
        
        let SAR = "SAR per hour".localized
        self.lblRange.text = "\(MinValue) - \(MaxValue) \(SAR)"
        self.lblRange.isHidden = true
        
        txtCity.showDismissToolbar = true
        datePicker.minimumDate = currentDate
        
        let strProject = "Projector(s)".localized
        let strAir = "Air Conditioner".localized
        let strMail = "Mail service".localized
        let strScanner = "Scanner / Printer".localized
        let strLockers = "Lockers".localized
        let strWifi = "WiFi / Internet".localized
        let strParking = "Parking Space".localized
        let strPhone = "Phone".localized
        let strWork = "Work 24 / h".localized
        let strMale = "Male".localized
        let strFemale = "Female".localized
        let strCoffee = "Coffee/Tea".localized
        
        arrAmenities = [strProject,
                        strAir,
                        strMail,
                        strScanner,
                        strLockers,
                        strWifi,
                        strParking,
                        strPhone,
                        strWork,
                        strMale,
                        strFemale,
                        strCoffee,]
        
        let flexibleButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClicked(_:)))

        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClicked(_:)))
        let toolbar = UIToolbar()
        toolbar.items = [cancelButton,flexibleButton, doneButton]
        
        toolbar.sizeToFit()
        
        self.allTextFields.append(txtCity)
        
        self.allTextFields.forEach { (textField) in
            textField.inputAccessoryView = toolbar
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        dateFormatter.locale = NSLocale.init(localeIdentifier: "en") as Locale

        let DT = dateFormatter.string(from:currentDate)
        self.txtDate.placeholder = DT
        self.strDateTimeFormate = DT
        self.strSearchDateTime = DT
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.strDateTime = dateFormatter.string(from:currentDate)

        dateFormatter.dateFormat = "a"
        var ZONE = dateFormatter.string(from:currentDate)
        
        dateFormatter.dateFormat = "hh"
        let TM = dateFormatter.string(from:currentDate)
        self.txtFrom.placeholder = "\(TM):00 \(ZONE)"
        self.strFromTime = "\(TM):00 \(ZONE)"
        self.strSearchFromTime = "\(TM):00 \(ZONE)"

        let earlyDate = Calendar.current.date(
            byAdding: .hour,
            value: 1,
            to: currentDate)
        
        dateFormatter.dateFormat = "hh"
        let EndM = dateFormatter.string(from:earlyDate!)
        dateFormatter.dateFormat = "a"
        ZONE = dateFormatter.string(from:earlyDate!)

        print(EndM)
        self.txtTo.placeholder = "\(EndM):00 \(ZONE)"
        self.strToTime = "\(EndM):00 \(ZONE)"
        self.strSearchToTime = "\(EndM):00 \(ZONE)"

        self.txtSearchDate.text = self.strSearchDateTime
        self.txtSearchFrom.text = self.strSearchFromTime
        self.txtSearchTo.text = self.strSearchToTime

        self.textFieldLeftViewPadding(txt: txtDate, vv: viewDate, type: 0)
        self.textFieldLeftViewPadding(txt: txtFrom, vv: viewfrom, type: 0)
        self.textFieldLeftViewPadding(txt: txtTo, vv: viewTo, type: 0)

        self.textFieldLeftViewPadding(txt: txtSearchDate, vv: viewSearchDate, type: 1)
        self.textFieldLeftViewPadding(txt: txtSearchFrom, vv: viewSearchfrom, type: 1)
        self.textFieldLeftViewPadding(txt: txtSearchTo, vv: viewSearchTo, type: 1)
        
        self.txtCity.delegate = self
        self.txtCity.dataSource = self
        self.txtCity.layer.cornerRadius = 3
        self.txtCity.layer.borderWidth = 1
        self.txtCity.layer.borderColor = UIColor.lightGray.cgColor
        self.txtCity.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)

        self.txtSearchCity.delegate = self
        self.txtSearchCity.dataSource = self
        self.txtSearchCity.layer.cornerRadius = 3
        self.txtSearchCity.layer.borderWidth = 1
        self.txtSearchCity.layer.borderColor = UIColor.lightGray.cgColor
        self.txtSearchCity.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)

        self.txtSearchType.delegate = self
        self.txtSearchType.dataSource = self
        self.txtSearchType.layer.cornerRadius = 3
        self.txtSearchType.layer.borderWidth = 1
        self.txtSearchType.layer.borderColor = UIColor.lightGray.cgColor
        self.txtSearchType.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        self.txtSearchType.isOptionalDropDown = false
        self.txtSearchType.itemList = self.arrSpace

        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.tblView.tableHeaderView = self.viewAdd
        
        if self.app.isConnectedToInternet()
        {
            self.getCityAPI()
        }
        else
        {
            Toast(text: "Internet Connetion in not availble.Try Again").show()
        }
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        self.getLatLong()
        
        if self.defaults.string(forKey: "selectedLanguage") != nil
        {
            self.strLanguage = (self.defaults.value(forKey: "selectedLanguage") as! String)
        }
        
        self.txtCity.textAlignment = .left
        self.txtSearchCity.textAlignment = .left
        self.txtSearchType.textAlignment = .left
        self.lblADVANCESEARCH.textAlignment = .left
        self.lblPRICE.textAlignment = .left
        self.lblFACILITY.textAlignment = .left

        if self.strLanguage == "ar"
        {
            self.lblSelectCity.textAlignment = .right
        }
        else
        {
            self.lblSelectCity.textAlignment = .left
        }

        clView.register(UINib(nibName: "TypeCell", bundle: nil), forCellWithReuseIdentifier: "TypeCell")
        clView.dataSource = self
        clView.delegate = self
        clView.reloadData()
        
        clSearchView.register(UINib(nibName: "ListYourPlaceCell", bundle: nil), forCellWithReuseIdentifier: "ListYourPlaceCell")
        clSearchView.dataSource = self
        clSearchView.delegate = self
        
        if DeviceType.IS_IPHONE_5
        {
            btnSearchNormal.titleLabel?.font = btnSearchNormal.titleLabel?.font.withSize(13)
        }
        
//        viewGoogleAdd.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        viewGoogleAdd.adUnitID = "ca-app-pub-1573732121110201/3032752443"
        viewGoogleAdd.rootViewController = self
        viewGoogleAdd.load(GADRequest())

    }
    
    func textFieldLeftViewPadding(txt : UITextField, vv : UIView, type : Int)
    {
        txt.leftView = vv
        txt.leftViewMode = .always
        txt.delegate = self
        
        if DeviceType.IS_IPHONE_5
        {
            txt.font = txt.font?.withSize(9)
        }
        
        var color = UIColor()
        if type == 0
        {
            txt.layer.cornerRadius = 1
            color = UIColor.white
        }
        else
        {
            txt.layer.cornerRadius = 3
            txt.layer.borderWidth = 1
            txt.layer.borderColor = UIColor.lightGray.cgColor
            color = UIColor.darkGray
        }
        txt.attributedPlaceholder = NSAttributedString(string: txt.placeholder!,
                                                       attributes: [NSAttributedStringKey.foregroundColor: color])
    }
    
    @IBAction func doneClicked(_ sender: Any)
    {
        if self.lat == 0
        {
            self.getLatLong()
        }
        self.txtCity.resignFirstResponder()
        let strCITY : String = txtCity.selectedItem!
        print(strCITY)
        print(txtCity.selectedRow)
        
        if self.app.isConnectedToInternet()
        {
            self.getBookingListAPI()
        }
        else
        {
            Toast(text: "Internet Connetion in not availble.Try Again").show()
        }
    }
    
    @IBAction func cancelClicked(_ sender: Any)
    {
        self.txtCity.resignFirstResponder()
    }
    
    func textField(_ textField: IQDropDownTextField, didSelectItem item: String?)
    {
        if textField == txtCity
        {
            txtCity.setSelectedItem(item, animated: true)
//            self.lblTitle.text = item
            
            if txtCity.selectedRow == -1
            {
                self.strCityName = ""
                self.strCityID = ""
            }
            else
            {
                self.strCityName = item!
                self.strCityID = self.arrCityID[txtCity.selectedRow]
            }
            print("City : \(strCityName)\nID : \(strCityID)")
        }
        else if textField == txtSearchCity
        {
            txtSearchCity.setSelectedItem(item, animated: true)
            
            if txtSearchCity.selectedRow == -1
            {
                self.strSearchName = ""
                self.strSearchCityID = ""
            }
            else
            {
                self.strSearchName = item!
                self.strSearchCityID = self.arrCityID[txtSearchCity.selectedRow]
            }
            print("SearchCity : \(strSearchName)\nSearchID : \(strSearchCityID)")
        }
        else if textField == txtSearchType
        {
            txtSearchType.setSelectedItem(item, animated: true)
            self.SearchID  = self.arrSpaceID[txtSearchType.selectedRow]
            print("SearchID : \(SearchID)")
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
    
    func alertForEnableLocation()
    {
        let alertController = UIAlertController(title: "Please Enable Your GPS", message: "Location services are not Enable!", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }

    func getCornerViewSet(vv : UIView)
    {
        vv.layer.cornerRadius = vv.frame.size.height / 2
        vv.clipsToBounds = true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField .resignFirstResponder()
        return true
    }
    
    @IBAction func btnMenu(_ sender: Any)
    {
        self.onSlideMenuButtonPressed(sender as! UIButton)
    }
   
    
    func gotoNextScreen()
    {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "MeetingView") as! MeetingView
        VC.strLocation = self.strCityID
//        VC.selectedSpace = selectedSpace
//        VC.IntUser = IntUser
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    //MARK:- CollectionView
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView == clSearchView
        {
            return self.arrAmenities.count
        }
        else
        {
            return self.arrSpace.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if collectionView == clSearchView
        {
            cellSearch = collectionView.dequeueReusableCell(withReuseIdentifier: "ListYourPlaceCell", for: indexPath) as! ListYourPlaceCell
            
            if self.arrSelected.contains(self.arrAmenities[indexPath.row])
            {
                cellSearch.btnCheck.setImage(UIImage(named: "checked.png"), for: .normal)
            }
            else
            {
                cellSearch.btnCheck.setImage(UIImage(named: "unchecklog.png"), for: .normal)
            }
            
            cellSearch.lblName.text = ("\(self.arrAmenities[indexPath.row])")
            
            cellSearch.btnCheck.addTarget(self, action: #selector(btnCheckAction), for: .touchUpInside)
            cellSearch.btnCheck.tag = indexPath.row
            
            return cellSearch
        }
        else
        {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TypeCell", for: indexPath) as! TypeCell

            if selectedSpace == indexPath.row
            {
                cell.imgProfile.image = arrTypeSelected[indexPath.row]
                cell.viewLine.isHidden = false
                
                cell.viewDetails.layer.borderWidth = 1
                cell.viewDetails.layer.borderColor = UIColor.init(rgb: 0xF2932C).cgColor
                cell.viewDetails.layer.cornerRadius = 5
                cell.viewDetails.clipsToBounds = true
            }
            else
            {
                cell.imgProfile.image = arrType[indexPath.row]
                
                cell.viewDetails.layer.borderWidth = 0
                cell.viewDetails.layer.borderColor = UIColor.clear.cgColor
                cell.viewDetails.layer.cornerRadius = 0
                cell.viewDetails.clipsToBounds = true
            }
            cell.viewLine.isHidden = true

            cell.lblName.text = self.arrSpace[indexPath.row]
            
            
            return cell
        }
    }
    
    func btnCheckAction(sender: UIButton!)
    {
        let strName : String = self.arrAmenities[sender.tag]
        
        if self.arrSelected.contains(strName)
        {
            if let index = self.arrSelected.index(of: strName)
            {
                self.arrSelected.remove(at: index)
                
                if strName == "Projector(s)"
                {
                    iProjector = 0
                }
                else if strName == "Air Conditioner"
                {
                    iAirConditioner = 0
                }
                else if strName == "Mail service"
                {
                    iMailServer = 0
                }
                else if strName == "Scanner / Printer"
                {
                    iScanner = 0
                }
                else if strName == "Lockers"
                {
                    iLockers = 0
                }
                else if strName == "WiFi / Internet"
                {
                    iWiFi = 0
                }
                else if strName == "Parking Space"
                {
                    iParking = 0
                }
                else if strName == "Phone"
                {
                    iPhone = 0
                }
                else if strName == "Work 24 / h"
                {
                    iWork = 0
                }
                else if strName == "Male"
                {
                    iMale = 0
                }
                else if strName == "Female"
                {
                    iFemale = 0
                }
                else if strName == "Coffee/Tea"
                {
                    iCoffee = 0
                }
            }
        }
        else
        {
            self.arrSelected.append(strName)
            
            if strName == "Projector(s)"
            {
                iProjector = 1
            }
            else if strName == "Air Conditioner"
            {
                iAirConditioner = 1
            }
            else if strName == "Mail service"
            {
                iMailServer = 1
            }
            else if strName == "Scanner / Printer"
            {
                iScanner = 1
            }
            else if strName == "Lockers"
            {
                iLockers = 1
            }
            else if strName == "WiFi / Internet"
            {
                iWiFi = 1
            }
            else if strName == "Parking Space"
            {
                iParking = 1
            }
            else if strName == "Phone"
            {
                iPhone = 1
            }
            else if strName == "Work 24 / h"
            {
                iWork = 1
            }
            else if strName == "Male"
            {
                iMale = 1
            }
            else if strName == "Female"
            {
                iFemale = 1
            }
            else if strName == "Coffee/Tea"
            {
                iCoffee = 1
            }
        }
        print(JSON(self.arrSelected))
        self.clSearchView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if collectionView == clView
        {
            self.selectedSpace = indexPath.row
            self.ID = self.arrSpaceID[selectedSpace]
            self.selectedSpaceName = arrSpace[selectedSpace]
            clView.reloadData()
            if self.lat == 0
            {
                self.getLatLong()
            }
            if self.app.isConnectedToInternet()
            {
                self.getBookingListAPI()
            }
            else
            {
                Toast(text: "Internet Connetion in not availble.Try Again").show()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if collectionView == clSearchView
        {
            return CGSize(width: self.clSearchView.frame.size.width / 3, height: 40)

//            return CGSize(width: clSearchView.frame.size.width / 4, height: self.clSearchView.frame.size.height / 3)
        }
        else
        {
            return CGSize(width: 80, height: self.clView.frame.size.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        var edges = UIEdgeInsets()
        edges = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return edges
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    //MARK:- Table View
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return self.arrList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell : BookingListCell!
        cell = tblView.dequeueReusableCell(withIdentifier: "BookingListCell") as! BookingListCell!
        if cell == nil
        {
            cell = Bundle.main.loadNibNamed("BookingListCell", owner: self, options: nil)?[0] as! BookingListCell!
        }
        
        let arrValue = JSON(self.arrList)
        
        let strName : String = arrValue[indexPath.section]["name"].stringValue
        let strAddress : String = arrValue[indexPath.section]["location"].stringValue
        let strImage : String = arrValue[indexPath.section]["img"].stringValue
        let strWishList : String = arrValue[indexPath.section]["wish_status"].stringValue
        let strPrice : String = arrValue[indexPath.section]["price"].stringValue
        let strKM : String = arrValue[indexPath.section]["distance"].stringValue
        let strUser : String = arrValue[indexPath.section]["capacity"].stringValue
        let strRatingCount : String = arrValue[indexPath.section]["rating_count"].stringValue
        let strRating : String = arrValue[indexPath.section]["rating"].stringValue

        let strCall : String = arrValue[indexPath.section]["ph"].stringValue
        let strMail : String = arrValue[indexPath.section]["mail"].stringValue
        let strWifi : String = arrValue[indexPath.section]["wifi"].stringValue
        let strWork : String = arrValue[indexPath.section]["work"].stringValue

        cell.lblName.text = strName
        cell.lblAddress.text = strAddress
        cell.lblHour.text = strPrice
        cell.lblUser.text = strUser
        cell.lblSpaceType.text = "[\(selectedSpaceName)]"

        let escapedString : String = strImage.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        let strFullImage : String = "\(self.app.strImagePath)space/\(escapedString)"
        cell.imgProfile.sd_setImage(with: URL(string: strFullImage), placeholderImage: nil)

//        if strRating == "0"
//        {
//            cell.lblReviews.isHidden = true
//        }
//        else
//        {
//            cell.lblReviews.isHidden = false
//        }
        cell.lblReviews.text = "(\(strRating) reviews)"

        cell.lblKM.text = strKM
        
        if strWishList == "1"
        {
            cell.imgHeart.image = UIImage(named: "WhiteHeart.png")
//            cell.viewHeart.backgroundColor = UIColor.init(rgb: 0xD3D3D3)
        }
        
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
        
        cell.viewRating.emptyImage = UIImage(named: "StarLight.png")
        cell.viewRating.fullImage = UIImage(named: "star.png")
        
        cell.viewRating.contentMode = UIViewContentMode.scaleAspectFit
        cell.viewRating.maxRating = 5
        cell.viewRating.minRating = 0
        cell.viewRating.editable = false
        cell.viewRating.halfRatings = false
        cell.viewRating.backgroundColor = UIColor.clear
        cell.viewRating.rating = Float(strRatingCount)!
        
        cell.viewShare.layer.borderWidth = 1
        cell.viewShare.layer.borderColor = UIColor.white.cgColor
        cell.viewHeart.layer.borderWidth = 1
        cell.viewHeart.layer.borderColor = UIColor.white.cgColor

        cell.viewHeart.layer.cornerRadius = 4
        cell.viewShare.layer.cornerRadius = 4
        cell.viewHeart.clipsToBounds = true
        cell.viewShare.clipsToBounds = true
        
        
        cell.btnBook.setTitle("Book Now".localized, for: .normal)
//        cell.btnBook.addTarget(self, action: #selector(btnBookAction), for: .touchUpInside)
//        cell.btnBook.tag = indexPath.section
        cell.btnBook.layer.cornerRadius = 2
        cell.btnBook.isUserInteractionEnabled = false
        
        cell.btnHeart.addTarget(self, action: #selector(btnLikeAction), for: .touchUpInside)
        cell.btnHeart.tag = indexPath.section

        cell.selectionStyle = .none
        tblView.rowHeight = cell.frame.size.height
        
        return cell
    }
    
    func btnLikeAction(sender: UIButton!)
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
        var arrValue = JSON(self.arrList)

        let strImage : String = arrValue[indexPath.section]["img"].stringValue
        let escapedString : String = strImage.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!

        let strFullImage : String = "\(self.app.strImagePath)space/\(escapedString)"

        let VC = self.storyboard?.instantiateViewController(withIdentifier: "BookingListDetailView") as! BookingListDetailView
        VC.capacityID = arrValue[indexPath.section]["capacity"].intValue
        VC.spaceID = arrValue[indexPath.section]["space_id"].intValue
        VC.strDate = self.strDateTimeFormate
        VC.strFrom = self.strFromTime
        VC.strTo = self.strToTime
        VC.strFullImage = strFullImage
        VC.SearchID = self.SearchID
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @objc func btnBookAction(sender:UIButton)
    {
        print(sender.tag)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 5
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        let viewFooter = UIView()
        viewFooter.backgroundColor = UIColor.clear
        
        return viewFooter
    }
    
    //MARK:- btn Search
    @IBAction func btnDate(_ sender: Any)
    {
        //Only Future Date Allowed
        DatePickerDialog().show("Date Picker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", minimumDate: datePicker.minimumDate ,datePickerMode: .date) { (date) in
            if let dt = date
            {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMMM dd, yyyy"
                dateFormatter.locale = NSLocale(localeIdentifier: "en") as Locale
                
                var DATETIME = String()
                DATETIME = dateFormatter.string(from:dt as Date)
                self.strDateTimeFormate = DATETIME

                dateFormatter.dateFormat = "yyyy-MM-dd"
                dateFormatter.locale = NSLocale(localeIdentifier: "en") as Locale
                
                if (sender as AnyObject).tag == 1
                {
                    self.strSearchDateTime = dateFormatter.string(from:dt as Date)
                    self.txtSearchDate.text = DATETIME
                }
                else
                {
                    self.strDateTime = dateFormatter.string(from:dt as Date)
                    self.txtDate.text = DATETIME
                }
            }
        }
    }
    
    @IBAction func btnFrom(_ sender: Any)
    {
        DatePickerDialog().show("Time Picker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .time) { (date) in
            if let dt = date
            {
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
                var strAMPM : String = df3.string(from: dt as Date)
                
                var H : Int = Int(strHour)!
                var M : Int = Int(strMinut)!
                
                var FROMTIME = String()

                if M == 00 || M == 30
                {
                    FROMTIME = dateFormatter.string(from:dt as Date)
                    FROMTIME = FROMTIME + " \(strAMPM)"
                }
                else
                {
                    if M < 15 && M > 0
                    {
                        M = 00
                    }
                    else if M > 15 && M < 30
                    {
                        M = 30
                    }
                    else if M > 30 && M < 45
                    {
                        M = 30
                    }
                    else if M > 45// && M < 60
                    {
                        M = 00
                        H = H + 1
                        if H > 12
                        {
                            H = 1
                            if strAMPM == "AM"
                            {
                                strAMPM = "PM"
                            }
                            else
                            {
                                strAMPM = "AM"
                            }
                        }
                    }
                    
                    if M == 0
                    {
                        if H < 10
                        {
                            FROMTIME = ("0\(H):00")
                        }
                        else
                        {
                            FROMTIME = ("\(H):00")
                        }
                    }
                    else
                    {
                        if H < 10
                        {
                            FROMTIME = ("0\(H):\(M)")
                        }
                        else
                        {
                            FROMTIME = ("\(H):\(M)")
                        }
                    }
                    FROMTIME = FROMTIME + " \(strAMPM)"
                }
                
                if (sender as AnyObject).tag == 1
                {
                    self.strSearchFromTime = FROMTIME
                    self.txtSearchFrom.text = self.strSearchFromTime
                }
                else
                {
                    self.strFromTime = FROMTIME
                    self.txtFrom.text = self.strFromTime
                }
            }
            
        }
    }
    
    @IBAction func btnTo(_ sender: Any)
    {
        DatePickerDialog().show("Time Picker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .time) { (date) in
            if let dt = date
            {
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
                var strAMPM : String = df3.string(from: dt as Date)
                
                var H : Int = Int(strHour)!
                var M : Int = Int(strMinut)!
                
                var TOTIME = String()
                if M == 00 || M == 30
                {
                    TOTIME = dateFormatter.string(from:dt as Date)
                    TOTIME = TOTIME + " \(strAMPM)"
                }
                else
                {
                    if M < 15 && M > 0
                    {
                        M = 00
                    }
                    else if M > 15 && M < 30
                    {
                        M = 30
                    }
                    else if M > 30 && M < 45
                    {
                        M = 30
                    }
                    else if M > 45// && M < 60
                    {
                        M = 00
                        H = H + 1
                        if H > 12
                        {
                            H = 1
                            if strAMPM == "AM"
                            {
                                strAMPM = "PM"
                            }
                            else
                            {
                                strAMPM = "AM"
                            }
                        }
                    }
                    
                    if M == 0
                    {
                        if H < 10
                        {
                            TOTIME = ("0\(H):00")
                        }
                        else
                        {
                            TOTIME = ("\(H):00")
                        }
                    }
                    else
                    {
                        if H < 10
                        {
                            TOTIME = ("0\(H):\(M)")
                        }
                        else
                        {
                            TOTIME = ("\(H):\(M)")
                        }
                    }
                    TOTIME = TOTIME + " \(strAMPM)"
                }
                
                self.strToTime = TOTIME
                self.strSearchToTime = TOTIME
                if (sender as AnyObject).tag == 1
                {
                    self.txtSearchTo.text = self.strSearchToTime
                }
                else
                {
                    self.txtTo.text = self.strToTime
                }
            }
        }
    }
    
    @IBAction func btnSearch(_ sender: UIButton)
    {
        if self.app.isConnectedToInternet()
        {
            self.getBookingListAPI()
        }
        else
        {
            Toast(text: "Internet Connetion in not availble.Try Again").show()
        }
    }
    
    @IBAction func btnCancelAction(_ sender: UIButton)
    {
        ProjectUtility.closePopupView(viewPopup: viewPopUp, viewDetails: viewSearch)
    }
    
    //MARK:- Get City
    func getCityAPI()
    {
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: false)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading..."
        loadingNotification.dimBackground = true
        
        Alamofire.request("\(self.app.strBaseAPI)fetch_city.php", method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { response in
            debugPrint(response)
            
            self.loadingNotification.hide(animated: true)

            if response.response?.statusCode == 200
            {
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
                            
                            if arrData.count != 0
                            {
                                for i in 0 ..< arrData.count
                                {
                                    let strName : String = arrData[i]["city_name"].stringValue
                                    let strID : String = arrData[i]["city_id"].stringValue
                                    
                                    if i == 0
                                    {
                                        self.strCityName = arrData[0]["city_name"].stringValue
                                        self.strCityID = arrData[0]["city_id"].stringValue
//                                        self.lblTitle.text = self.strCityName
                                    }
                                    self.arrCity.append(strName)
                                    self.arrCityID.append(strID)
                                }
                                self.txtCity.isOptionalDropDown = false
                                self.txtCity.itemList = self.arrCity
                                
                                self.txtSearchCity.isOptionalDropDown = false
                                self.txtSearchCity.itemList = self.arrCity
                            }
                            else
                            {
                                Toast(text: self.strMessage).show()
                            }
                            self.getBookingListAPI()
                        }
                    }
                    else
                    {
                        Toast(text: "Request time out.").show()
                    }
                }
                else
                {
                    print(response.result.error.debugDescription)
                    Toast(text: "Request time out.").show()
                }
            }
        }
    }
    
    //MARK:- Range Slider
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat)
    {
        self.MinValue = Int(minValue)
        self.MaxValue = Int(maxValue)
        
        let SAR = "SAR per hour".localized
        self.lblRange.text = "\(MinValue) - \(MaxValue) \(SAR)"
    }
    
    
    @IBAction func btnBootomAction(_ sender: UIButton)
    {
        if sender.tag == 1
        {
            if Check
            {
                self.tblView.isHidden = false
                self.viewMap.isHidden = true
                self.tblView.transform = CGAffineTransform.identity.scaledBy(x: 0.001, y: 0.001);
                
                UIView.animate(withDuration: 0.5)
                {
                    self.tblView.transform = CGAffineTransform.identity;
                    self.viewMap.transform = CGAffineTransform.identity.scaledBy(x: 0.00, y: 0.00);
                }
                Check = false
            }
            else
            {
                self.tblView.isHidden = true
                self.viewMap.isHidden = false
                self.viewMap.transform = CGAffineTransform.identity.scaledBy(x: 0.001, y: 0.001);

                UIView.animate(withDuration: 0.5)
                {
                    self.viewMap.transform = CGAffineTransform.identity;
                    self.tblView.transform = CGAffineTransform.identity.scaledBy(x: 0.00, y: 0.00);
                }
                Check = true
            }
            
        }
        else
        {
            self.viewPopUp.frame.origin.y = 0
            ProjectUtility.animatePopupView(viewPopup: viewPopUp, viewDetails: viewSearch)
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
        let parameters: Parameters = ["user_id": self.app.strUserId,
                                      "totime": strToTime,
                                      "fromtime": strFromTime,
                                      "location": strCityID,
                                      "space_type": ID,
                                      "date": strDateTime,
                                      "lat":lat,
                                      "long":long]
        print(parameters)
        
        Alamofire.request("\(self.app.strBaseAPI)booking_datetime.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            debugPrint(response)
            
            self.loadingNotification.hide(animated: true)

            if response.response?.statusCode == 200
            {
                if response.result.isSuccess == true
                {
                    if let value = response.result.value
                    {
                        self.json = JSON(value)
                        print(self.json)
                        
                        let strStatus : String = self.json["status"].stringValue
                        self.strMessage = self.json["message"].stringValue
                        
                        self.arrList.removeAll()
                        
                        self.arrID.removeAll()
                        self.arrPrice.removeAll()
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

                        let allAnnotations = self.viewMap.annotations
                        self.viewMap.removeAnnotations(allAnnotations)
                        
                        if strStatus == "1"
                        {
                            self.arrList = self.json["space_list"].arrayValue
                            
                            let Data = self.json["advertise"]
                            if Data.count != 0
                            {
                                self.viewGoogleAdd.isHidden = true
                                
                                self.imgBanner.contentScaleMode = UIViewContentMode.scaleToFill//scaleAspectFill
                                self.imgBanner.pageControl.isHidden = true
                                self.imgBanner.slideshowInterval = 5.0
                                //                                self.imgBanner.pageControl.currentPage
                                self.imgBanner.pageControl.pageIndicatorTintColor = UIColor.clear
                                self.imgBanner.pageControl.currentPageIndicatorTintColor = UIColor.clear
                                
                                self.app.arrSDWebImageSource.removeAll()
                                self.app.arrURL.removeAll()
                                
                                for i in 0...Data.count-1
                                {
                                    self.strImage = Data[i]["adv_img"].stringValue
                                    self.escapedString = self.strImage.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
                                    self.strFullImage = "\(self.app.strImagePath)advertise/\(self.escapedString)"
                                    self.app.arrSDWebImageSource.append(SDWebImageSource(urlString: self.strFullImage)!)
                                    
                                    let strURL = Data[i]["adv_url"].stringValue
                                    self.app.arrURL.append(strURL)
                                    
                                    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapFunction))
                                    
                                    tapGestureRecognizer.numberOfTapsRequired = 1
                                    tapGestureRecognizer.delegate = self
                                    
                                    self.imgBanner.addGestureRecognizer(tapGestureRecognizer)
                                    self.imgBanner.isUserInteractionEnabled = true
                                    
                                    self.imgBanner.tag = self.imgBanner.currentPage
                                    
                                    self.imgBanner.activityIndicator = DefaultActivityIndicator()
                                    self.imgBanner.currentPageChanged = { page in
                                        self.imgBanner.tag = page
                                    }
                                    
                                    self.imgBanner.setImageInputs(self.app.arrSDWebImageSource)
                                }
                            }
                            
                            self.tblView.reloadData()
                            self.tblView.setContentOffset(CGPoint.zero, animated: true)

                            var arrValue = JSON(self.arrList)
                            print(arrValue)
                            
                            for i in 0..<arrValue.count
                            {
                                let strSpaceId : String = arrValue[i]["space_id"].stringValue
                                
                                let strPrice : String = arrValue[i]["price"].stringValue
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
                                    
                                    self.arrPrice.append(strPrice)

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
                            
                            self.viewMap.delegate = self
                            for i in 0...self.arrID.count-1
                            {
                                let LAT = self.arrLat[i]
                                let LONG = self.arrLong[i]
                                
                                let point = StarbucksAnnotation(coordinate: CLLocationCoordinate2D(latitude: LAT , longitude: LONG))
                                point.image = UIImage(named: "starbucks-\(i+1).jpg")
                                point.name = self.arrNames[i]
                                point.address = self.arrAddresses[i]
                                point.price = self.arrPrice[i]

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
                                
                                self.viewMap.addAnnotation(point)
                            }
                            // 3
                            let LAT = self.arrLat[0]
                            let LONG = self.arrLong[0]
                            
                            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: LAT, longitude: LONG), span: MKCoordinateSpan(latitudeDelta: 0.6,longitudeDelta: 0.6))
                            self.viewMap.setRegion(region, animated: true)
                        }
                        else
                        {
                            self.tblView.reloadData()
                            Toast(text: self.strMessage).show()
                        }
                    }
                }
                else
                {
                    Toast(text: "Request time out.").show()
                }
            }
            else
            {
                print(response.result.error.debugDescription)
                Toast(text: "Request time out.").show()
            }
        }
    }
    
    @objc func tapFunction(sender:UITapGestureRecognizer)
    {
        let imgPager : ImageSlideshow = (sender.view as! ImageSlideshow)
        let strURL = self.app.arrURL[imgPager.tag]
        
        if !strURL.isEmpty
        {
            let url = URL(string: strURL)!
            if #available(iOS 10.0, *)
            {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            else
            {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        if annotation is MKUserLocation
        {
            return nil
        }
        var annotationView = self.viewMap.dequeueReusableAnnotationView(withIdentifier: "Pin")
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
        let size = CGSize(width: 45, height: 45)
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
        let size = CGSize(width: 45, height: 45)
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
        
        calloutView.lblBookNow.text = "Book Now".localized
        
        let img : String = starbucksAnnotation.img
        
        let escapedString : String = img.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        print(escapedString)
        
        let strImage : String = ("\(self.app.strImagePath)space/\(escapedString)")
        calloutView.imgProfile.sd_setImage(with: URL(string: strImage), placeholderImage: nil)
        
        calloutView.lblIMG.text = strImage
        
        let strReview : String = starbucksAnnotation.review
        calloutView.lblReviews.text = ("\(strReview) Reviews")
        
        calloutView.lblPrice.text = starbucksAnnotation.price
        
        calloutView.viewRating.emptyImage = UIImage(named: "StarLight.png")
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
        
//        calloutView.layer.borderWidth = 1
//        calloutView.layer.borderColor = UIColor.lightGray.cgColor
        
        // 3
        calloutView.center = CGPoint(x: view.bounds.size.width / 2, y: -calloutView.bounds.size.height*0.52)
        view.addSubview(calloutView)
        mapView.setCenter((view.annotation?.coordinate)!, animated: true)
    }
    
    func callPhoneNumber(sender: UIButton)
    {
//        var arrValue = JSON(self.arrList)
//
//        let strImage : String = arrValue[sender.tag]["img"].stringValue
//        let escapedString : String = strImage.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
//
//        let strFullImage : String = "\(self.app.strImagePath)space/\(escapedString)"
//
//        let VC = self.storyboard?.instantiateViewController(withIdentifier: "BookingListDetailView") as! BookingListDetailView
//        VC.capacityID = arrValue[sender.tag]["capacity"].intValue
//        VC.spaceID = arrValue[sender.tag]["space_id"].intValue
//        VC.strDate = self.strDateTimeFormate
//        VC.strFrom = self.strFromTime
//        VC.strTo = self.strToTime
//        VC.strFullImage = strFullImage
//        self.navigationController?.pushViewController(VC, animated: true)
        
        let v = sender.superview as! CustomCalloutView
//        print("Space ID : \(sender.tag)")
//
        let strUser : String = v.lblUser.text!
//        print("User : \(strUser)")
//
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "BookingListDetailView") as! BookingListDetailView
        VC.capacityID = Int(strUser)!//arrValue[sender.tag]["capacity"].intValue
        VC.spaceID = sender.tag//arrValue[sender.tag]["space_id"].intValue
        VC.strDate = self.strDateTimeFormate
        VC.strFrom = self.strFromTime
        VC.strTo = self.strToTime
        VC.strFullImage = v.lblIMG.text!//strFullImage
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView)
    {
        let pinImage = UIImage(named: "AnnotationBlack.png")
        let size = CGSize(width: 45, height: 45)
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
        
        let parameters: Parameters = ["user_id": self.app.strUserId,
                                      "space_id": spaceID]
        
        print(JSON(parameters))
        Alamofire.request("\(self.app.strBaseAPI)insert_favorite.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            debugPrint(response)
            
            self.loadingNotification.hide(animated: true)

            if response.response?.statusCode == 200
            {
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
                }
            }
            else
            {
                print(response.result.error.debugDescription)
                Toast(text: "Request time out.").show()
            }
        }
    }
    
    
    
    @IBAction func btnPrevious(_ sender: UIButton)
    {
        if self.selectedSpace != 0
        {
            self.selectedSpace = self.selectedSpace - 1
            self.ID  = self.arrSpaceID[selectedSpace]
            self.selectedSpaceName = self.arrSpace[selectedSpace]
            clView.reloadData()
            let indexPath = IndexPath(row: self.selectedSpace, section: 0)
            
            clView.scrollToItem(at: indexPath, at: .right, animated: true)
            if self.lat == 0
            {
                self.getLatLong()
            }
            if self.app.isConnectedToInternet()
            {
                self.getBookingListAPI()
            }
            else
            {
                Toast(text: "Internet Connetion in not availble.Try Again").show()
            }
        }
        
    }
    
    @IBAction func btnNext(_ sender: UIButton)
    {
        if self.selectedSpace != 4
        {
            self.selectedSpace = self.selectedSpace + 1
            self.ID  = self.arrSpaceID[selectedSpace]
            self.selectedSpaceName = self.arrSpace[selectedSpace]
            clView.reloadData()
//            clView.collectionViewLayout.invalidateLayout()
            let indexPath = IndexPath(row: self.selectedSpace, section: 0)
            
            clView.scrollToItem(at: indexPath, at: .left, animated: true)
            if self.lat == 0
            {
                self.getLatLong()
            }
            if self.app.isConnectedToInternet()
            {
                self.getBookingListAPI()
            }
            else
            {
                Toast(text: "Internet Connetion in not availble.Try Again").show()
            }
        }
    }
    
    //MARK:- filterAPI
    func filterAPI()
    {
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: false)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading..."
        loadingNotification.dimBackground = true
        
        let parameters: Parameters = ["user_id":self.app.strUserId,
                                      "space_type":self.SearchID,
                                      "location": self.strSearchCityID,
                                      "min_price": self.MinValue,
                                      "max_price": self.MaxValue,
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
                                      "date":self.strSearchDateTime,
                                      "fromtime":self.strSearchFromTime,
                                      "totime":self.strSearchToTime,
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
                        
                        if strStatus == "1"
                        {
                            self.arrList = self.json["space_list"].arrayValue
                            
                            self.tblView.reloadData()
                            self.tblView.setContentOffset(CGPoint.zero, animated: true)
                            
                            var arrValue = JSON(self.arrList)
                            print(arrValue)
                            
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
                            
                            self.viewMap.delegate = self
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
                                
                                self.viewMap.addAnnotation(point)
                            }
                            // 3
                            let LAT = self.arrLat[0]
                            let LONG = self.arrLong[0]
                            
                            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: LAT, longitude: LONG), span: MKCoordinateSpan(latitudeDelta: 0.2,longitudeDelta: 0.2))
                            self.viewMap.setRegion(region, animated: true)
                        }
                        else
                        {
                            self.tblView.reloadData()
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
    
    @IBAction func btnAdvanceSearch(_ sender: UIButton)
    {
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


