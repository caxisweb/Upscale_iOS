//
//  ListYourPlaceView.swift
//  Upscale
//
//  Created by Developer on 11/04/17.
//  Copyright © 2017 krutik. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
import MBProgressHUD
import Toaster
import MapKit
import IQDropDownTextField


class ListYourPlaceView: UIViewController,UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate,MKMapViewDelegate,UIGestureRecognizerDelegate,IQDropDownTextFieldDelegate,IQDropDownTextFieldDataSource
{
    //MARK:-
    @IBOutlet var viewNavigation: UIView!

    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var viewTop: UIView!
    
    @IBOutlet var txtCity: IQDropDownTextField!

    @IBOutlet var txtRoom: IQDropDownTextField!
    @IBOutlet var txtCost: UITextField!
    
    @IBOutlet var txtCapacity: UITextField!
    @IBOutlet var txtCounts: UITextField!

//    @IBOutlet var txtCapacityTwo: IQDropDownTextField!
//    @IBOutlet var txtCountsTwo: IQDropDownTextField!
//
//    @IBOutlet var txtCapacityThree: IQDropDownTextField!
//    @IBOutlet var txtCountsThree: IQDropDownTextField!
//
//    @IBOutlet var btnAddMore: UIButton!
//    @IBOutlet var btnDelete: UIButton!
    
    @IBOutlet var clImageView: UICollectionView!
    
    
    @IBOutlet var txtName: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtMobile: UITextField!
    
    @IBOutlet var viewAmenities: UIView!
    @IBOutlet var clView: UICollectionView!
    
    
    @IBOutlet var viewImage: UIView!
    @IBOutlet var imgOne: UIImageView!
    @IBOutlet var imgTwo: UIImageView!
    @IBOutlet var imgThree: UIImageView!
    
    @IBOutlet var btnOne: UIButton!
    @IBOutlet var btnTwo: UIButton!
    @IBOutlet var btnThree: UIButton!

    @IBOutlet var viewLocation: UIView!
    @IBOutlet var btnLocation: UIButton!
    @IBOutlet var btnSubmit: UIButton!
    
    
    @IBOutlet var viewPopUp: UIView!
    @IBOutlet var viewMapDetails: UIView!
    @IBOutlet var mapView: MKMapView!
    
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblAmenities: UILabel!
    @IBOutlet var lblPhotos: UILabel!
    @IBOutlet var lblADRESS: UILabel!
    
    var loadingNotification : MBProgressHUD!
    var json : JSON!
    var strMessage : String!
    
    var app = AppDelegate()

    var arrCity : [String] = []
    var arrCityID : [String] = []
    
    var strCityName = String()
    var strCityID = String()

    var strPerson = "1"
    var strAvailable = "1"
    
    var strPersonTwo : String = "0"
    var strAvailableTwo : String = "0"
    
    var strPersonThree : String = "0"
    var strAvailableThree : String = "0"
    
    let chooseSelectPersonDropDown = DropDown()
    let chooseSelectAvailableDropDown = DropDown()
    
    let chooseSelectPersonTwoDropDown = DropDown()
    let chooseSelectAvailableTwoDropDown = DropDown()
    
    let chooseSelectPersonThreeDropDown = DropDown()
    let chooseSelectAvailableThreeDropDown = DropDown()

    
    lazy var dropDowns: [DropDown] = {
        return [
            self.chooseSelectPersonDropDown,
            self.chooseSelectAvailableDropDown,
            self.chooseSelectPersonTwoDropDown,
            self.chooseSelectAvailableTwoDropDown,
            self.chooseSelectPersonThreeDropDown,
            self.chooseSelectAvailableThreeDropDown
        ]
    }()
    
    var cell = ListYourPlaceCell()
    var cellImage = PostBookCell()

    var arrAmenities : [String] = []
    var arrSelected : [String] = []
    
    
    var picker = UIImagePickerController()
    var iOne : Int = 0
    var iTwo : Int = 0
    var iThree : Int = 0
    
    var RoomID : Int = 0
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!

    var lat = Double()
    var long = Double()
    
    var selectedLat = Double()
    var selectedLong = Double()
    
    var imageCount : Int = 0
    var arrImages : [UIImage] = []
    var totalImage : Int = 0
    
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

    var strAddress = String()
    var strSelectdAddress = String()
    var strSpaceId = String()
    var strCity = String()
    
    var addMore : Int = 1
    
    var arrPerson : [String] = []
    var arrAVAILABLE : [String] = []
    
    let defaults = UserDefaults.standard
    var strLanguage = "English"
    
    var arrRoom : [String] = []// ["MEETING ROOM","DESK","PRIVATE ROOM","CONFERENCE ROOM","OTHERS"]
    var arrSpaceID = [1,2,4,5,6]

    var strRoom = String()
    var strCost = String()
    var strCapacity = String()
    var strCounts = String()

    var Total = 1
    
    //MARK:-
    //MARK:-
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        app = UIApplication.shared.delegate as! AppDelegate
        
        if DeviceType.IS_IPHONE_X
        {
            self.viewNavigation.frame = CGRect(x:self.viewNavigation.frame.origin.x, y: self.viewNavigation.frame.origin.y, width:self.viewNavigation.frame.size.width, height:88)
            self.scrollView.frame = CGRect(x:self.scrollView.frame.origin.x, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height, width:self.scrollView.frame.size.width, height:self.view.frame.size.height -  self.viewNavigation.frame.size.height)
        }
        
        if self.defaults.string(forKey: "selectedLanguage") != nil
        {
            self.strLanguage = (self.defaults.value(forKey: "selectedLanguage") as! String)
        }
        
        if self.app.isConnectedToInternet()
        {
            self.getCityAPI()
        }
        else
        {
            Toast(text: "Internet Connetion in not availble.Try Again").show()
        }
        
        //["MEETING ROOM","DESK","PRIVATE ROOM","CONFERENCE ROOM","OTHERS"]
        arrRoom.removeAll()
        arrRoom.append("Meeting Room".localized)
        arrRoom.append("Desk".localized)
        arrRoom.append("Private Room".localized)
        arrRoom.append("Conference Room".localized)
        arrRoom.append("Others".localized)
        
        self.setDetails()
        
        txtRoom.layer.borderWidth = 1
        txtRoom.layer.borderColor = UIColor.lightGray.cgColor
        
        txtRoom.itemList = arrRoom
        txtRoom.delegate = self
        txtRoom.dataSource = self
        
        txtCost.layer.borderWidth = 1
        txtCost.layer.borderColor = UIColor.lightGray.cgColor
        
        txtCost.delegate = self
        
        self.txtCity.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        self.txtRoom.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)

        self.txtCity.delegate = self
        self.txtCity.dataSource = self
        self.txtCity.layer.borderWidth = 1
        self.txtCity.layer.borderColor = UIColor.lightGray.cgColor
        self.txtCity.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        
        self.setScrollviewForLastView()
    }
    
    func textField(_ textField: IQDropDownTextField, didSelectItem item: String?)
    {
        if textField == txtRoom
        {
            txtRoom.setSelectedItem(item, animated: true)
            
            txtRoom.setSelectedItem(item, animated: true)
            
            if txtRoom.selectedRow == -1
            {
                self.strRoom = ""
            }
            else
            {
                self.RoomID = self.arrSpaceID[txtRoom.selectedRow]
            }
        }
        else if textField == txtCity
        {
            txtCity.setSelectedItem(item, animated: true)
            
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
        }
    }
    
    func setDetails()
    {
        self.imageCount = 0
        self.totalImage = 0
        
        self.arrImages.removeAll()
        
        self.strCityID = ""
        self.strCityName = ""
        
        self.RoomID = 0
        
        self.imgOne.image = nil
        self.imgTwo.image = nil
        self.imgThree.image = nil
        
        self.txtCity.setSelectedItem("", animated: true)
        self.txtRoom.setSelectedItem("", animated: true)
        
        self.txtCity.textAlignment = .left
        self.txtRoom.textAlignment = .left
        self.lblAmenities.textAlignment = .left
        self.lblADRESS.textAlignment = .left
        self.lblPhotos.textAlignment = .left

        
        self.txtCost.text = ""
        self.txtName.text = ""
        self.txtCapacity.text = ""
        self.txtCounts.text = ""
        self.txtEmail.text = ""
        self.txtMobile.text = ""
        
        iProjector = 0
        iAirConditioner = 0
        iMailServer = 0
        iScanner = 0
        iLockers = 0
        iWiFi = 0
        iParking = 0
        iPhone = 0
        iWork = 0
        iMale = 0
        iFemale = 0
        iCoffee = 0

        arrSelected.removeAll()
        
        self.textFieldPaddingView(txt: txtName)
        self.textFieldPaddingView(txt: txtEmail)
        self.textFieldPaddingView(txt: txtMobile)
        self.textFieldPaddingView(txt: txtCost)
        self.textFieldPaddingView(txt: txtCapacity)
        self.textFieldPaddingView(txt: txtCounts)

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
        
        clView.register(UINib(nibName: "ListYourPlaceCell", bundle: nil), forCellWithReuseIdentifier: "ListYourPlaceCell")
        clView.dataSource = self
        clView.delegate = self
        clView.reloadData()
        
        clImageView.register(UINib(nibName: "PostBookCell", bundle: nil), forCellWithReuseIdentifier: "PostBookCell")
        clImageView.dataSource = self
        clImageView.delegate = self

        picker.delegate = self
        btnLocation.layer.cornerRadius = 3
        btnSubmit.layer.cornerRadius = 3
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        txtName.text = ""
        txtEmail.text = ""
        txtMobile.text = ""
        
        strAddress = ""
        
        var image = UIImage()
        image = UIImage(named:"picture (3) copy.png")!
        
        btnOne.setImage(image, for: .normal)
        btnTwo.setImage(image, for: .normal)
        btnThree.setImage(image, for: .normal)
        
        btnTwo.isEnabled = false
        btnThree.isEnabled = false
        
        self.viewPopUp.isHidden = true
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self

        self.getLatLong()
        self.setScrollviewForLastView()
    }
    
    func setviewPersonBorder(btn : UIButton)
    {
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func setScrollviewForLastView()
    {
        let rectTitle = self.lblAddress.text?.boundingRect(with: CGSize(width: CGFloat(self.lblAddress.frame.size.width), height: CGFloat(500)), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: self.lblAddress.font], context: nil)
        
        self.lblAddress.frame = CGRect(x: CGFloat(self.lblAddress.frame.origin.x), y: CGFloat(self.lblAddress.frame.origin.y), width: CGFloat(self.lblAddress.frame.size.width), height: CGFloat((rectTitle?.size.height)!))
        
        self.viewLocation.frame = CGRect(x:self.viewLocation.frame.origin.x, y: self.viewLocation.frame.origin.y, width:self.viewLocation.frame.size.width, height:self.lblAddress.frame.origin.y + self.lblAddress.frame.size.height + 25)
        
        self.viewImage.frame = CGRect(x:self.viewImage.frame.origin.x, y: self.viewLocation.frame.origin.y + self.viewLocation.frame.size.height, width:self.viewImage.frame.size.width, height:self.viewImage.frame.size.height)
        
        for viewAll: UIView in scrollView.subviews
        {
            if viewAll.tag == 100
            {
                scrollView.contentSize = CGSize(width: CGFloat(scrollView.frame.size.width), height: CGFloat(viewAll.frame.origin.y + viewAll.frame.size.height))
            }
        }
    }
    
    //MARK:- Textfield methods
    func textFieldPaddingView(txt : UITextField)
    {
        txt.delegate = self
        txt.layer.borderWidth = 1
        txt.layer.borderColor = UIColor.lightGray.cgColor
        
        if self.strLanguage == "ar"
        {
            txt.setRightPaddingPoints(10)
            txt.textAlignment = .right
        }
        else
        {
            txt.setLeftPaddingPoints(10)
            txt.textAlignment = .left
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField .resignFirstResponder()
        return true
    }
    
    func setViewCornerRadiation(vv :UIView)
    {
        vv.layer.cornerRadius = 5
        vv.clipsToBounds = true
    }
    
    //MARK:- Back
    @IBAction func btnBack(_ sender: Any)
    {
        if let navController = self.navigationController
        {
            navController.popViewController(animated: true)
        }
    }
    
    //MARK:- CollectionView
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView == clImageView
        {
            return self.arrImages.count
        }
        else
        {
            return self.arrAmenities.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if collectionView == clImageView
        {
            cellImage = collectionView.dequeueReusableCell(withReuseIdentifier: "PostBookCell", for: indexPath) as! PostBookCell
            
            cellImage.imgProfile.image = self.arrImages[indexPath.row]
            
            cellImage.btnDelete.addTarget(self, action: #selector(btnDeleteAction), for: .touchUpInside)
            cellImage.btnDelete.tag = indexPath.row
            
            return cellImage
        }
        else
        {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListYourPlaceCell", for: indexPath) as! ListYourPlaceCell
            
            if self.arrSelected.contains(self.arrAmenities[indexPath.row])
            {
                cell.btnCheck.setImage(UIImage(named: "checked.png"), for: .normal)
            }
            else
            {
                cell.btnCheck.setImage(UIImage(named: "unchecklog.png"), for: .normal)
            }
            
            if strLanguage == "ar"
            {
                cell.lblName.textAlignment = .right
            }
            else
            {
                cell.lblName.textAlignment = .left
            }
            
            cell.lblName.text = ("\(self.arrAmenities[indexPath.row])")
            
            cell.btnCheck.addTarget(self, action: #selector(btnCheckAction), for: .touchUpInside)
            cell.btnCheck.tag = indexPath.row
            
            return cell
        }
    
    }
    
    @objc func btnDeleteAction(sender:UIButton)
    {
        self.arrImages.remove(at: sender.tag)
        self.clImageView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if collectionView == clImageView
        {
            return CGSize(width: self.clImageView.frame.size.width / 3, height: self.clImageView.frame.size.height)
        }
        else
        {
            return CGSize(width: self.clView.frame.size.width / 3, height: 40)
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
        self.clView.reloadData()
    }

    //MARK:- Lat Long
    @IBAction func btnLocation(_ sender: Any)
    {
        viewPopUp.frame.origin.y = 0
        ProjectUtility.animatePopupView(viewPopup: viewPopUp, viewDetails: viewMapDetails)
    }
    
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
                    self.alertForLocation()
                }
                else
                {
                    print(currentLocation)
                    lat = currentLocation.coordinate.latitude
                    long = currentLocation.coordinate.longitude
                    
                    self.getLocation()
                }
            }
            else
            {
                self.alertForLocation()
            }
        }
        else
        {
            self.alertForLocation()
        }

    }
    
    func alertForLocation()
    {
        let alertController = UIAlertController(title: "Location Services Disabled!", message: "Please enable Location Based Services for better results! We promise to keep your location private", preferredStyle: .alert)
        
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
    
    func getLocation()
    {   //23.012631, 72.522634
        let longitude :CLLocationDegrees = long
        let latitude :CLLocationDegrees = lat
        
        let location = CLLocation(latitude: latitude, longitude: longitude) //changed!!!
        print(location)
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            print(location)
            
            if error != nil
            {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            if (placemarks?.count)! > 0
            {
                var placemark : CLPlacemark!
                placemark = placemarks?[0]
                
                print(placemark.addressDictionary as Any)

                let strCity : String = (placemark.addressDictionary?["City"] as! String)
                print(strCity)
                
                placemark = placemarks?[0]
                
                // Address dictionary
                print(placemark.addressDictionary as Any)
                
                var strCountry = String()
                // Location name
                if let locationName = placemark.addressDictionary!["Name"] as? NSString {
                    print(locationName)
                    self.strAddress += locationName as String
                }
                // Street address
                if let street = placemark.addressDictionary!["Thoroughfare"] as? NSString {
                    print(street)
                }
                // City
                if let city = placemark.addressDictionary!["City"] as? NSString {
                    print(city)
                    self.strCity = String(city)
                }
                // Zip code
                if let zip = placemark.addressDictionary!["ZIP"] as? NSString {
                    print(zip)
                }
                // Country
                if let country = placemark.addressDictionary!["Country"] as? NSString {
                    print(country)
                    strCountry = String(country)
                }
                
                if let formetAdd = placemark.addressDictionary!["FormattedAddressLines"] as? NSArray {
                    print(formetAdd)
                    self.strAddress = formetAdd.componentsJoined(by: ", ")

                }
                self.lblAddress.text = self.strAddress
                self.mapView.delegate = self
                self.mapView.mapType = MKMapType.standard
                
                // 2)
                //                let LAT : Double = 24.774265
                //                let LONG : Double = 46.738586
                
                let location = CLLocationCoordinate2D(latitude: self.lat,longitude: self.long)
                
                // 3)
                let span = MKCoordinateSpanMake(0.05, 0.05)
                let region = MKCoordinateRegion(center: location, span: span)
                self.mapView.setRegion(region, animated: true)
                
                // 4)
                let annotation = MKPointAnnotation()
                annotation.coordinate = location
                annotation.title = self.strAddress
                annotation.subtitle = strCountry
                self.mapView.addAnnotation(annotation)
                //
                
                let lpgr = UILongPressGestureRecognizer(target: self, action:#selector(self.handleLongPress))
                
                lpgr.minimumPressDuration = 0.5
                lpgr.delaysTouchesBegan = true
                lpgr.delegate = self
                self.mapView.addGestureRecognizer(lpgr)
                
                self.setScrollviewForLastView()
            }
            else
            {
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    func alertForEnableLocation()
    {
        let alertController = UIAlertController(title: "Please Enable Your GPS", message: "Location services are not Enable!", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    //MARK:-Image View
    @IBAction func btnImageSelect(_ sender: Any)
    {
        if btnOne.isTouchInside == true
        {
            iOne = 1
        }
        else if btnTwo.isTouchInside == true
        {
            iTwo = 1
        }
        else if btnThree.isTouchInside == true
        {
            iThree = 1
        }
        self.alertControllerForImage()
    }
    
    
    //MARK:- AlertController
    func alertControllerForImage()
    {
        let alertController = UIAlertController(title: "Add Photo!", message: "", preferredStyle: .actionSheet)
        let ok = UIAlertAction(title: "Take Photo", style: .default, handler: { (action) -> Void in
            self.openCamera()
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            print("Cancel Button Pressed")
        })
        let  delete = UIAlertAction(title: "Choose frome Library", style: .default) { (action) -> Void in
            self.openGallary()
        }
        
        alertController.addAction(ok)
        alertController.addAction(cancel)
        alertController.addAction(delete)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        if (UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
            present(picker, animated: true, completion: nil)
        }
        else
        {
            self.openGallary()
//            let alert = UIAlertController(title: "Camera Not Found", message: "This device has no Camera", preferredStyle: .alert)
//            let ok = UIAlertAction(title: "OK", style:.default, handler: nil)
//            alert.addAction(ok)
//            present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary()
    {
        picker.allowsEditing = false
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let imageSelected = info[UIImagePickerControllerOriginalImage] as? UIImage
//        self.arrImages.append(imageSelected!)
//
//        clImageView.reloadData()
        
        if iOne == 1
        {
            iOne = 0
            btnOne.setImage(nil, for: .normal)
            
            self.imgOne.image = imageSelected
            
            if self.arrImages.count == 0
            {
                self.arrImages.insert(imageSelected!, at: 0)
            }
            else
            {
                self.arrImages[0] = imageSelected!
            }
            btnTwo.isEnabled = true
        }
        else if iTwo == 1
        {
            iTwo = 0
            btnTwo.setImage(nil, for: .normal)
            
            self.imgTwo.image = imageSelected
            
            if self.arrImages.count == 1
            {
                self.arrImages.insert(imageSelected!, at: 1)
            }
            else
            {
                self.arrImages[1] = imageSelected!
            }
            btnThree.isEnabled = true
        }
        else if iThree == 1
        {
            iThree = 0
            btnThree.setImage(nil, for: .normal)
            
            self.imgThree.image = imageSelected
            
            if self.arrImages.count == 2
            {
                self.arrImages.insert(imageSelected!, at: 2)
            }
            else
            {
                self.arrImages[2] = imageSelected!
            }
        }
        picker .dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Submit Button
    @IBAction func btnSubmit(_ sender: Any)
    {
        txtCost.resignFirstResponder()
        txtName.resignFirstResponder()
        txtCapacity.resignFirstResponder()
        txtCounts.resignFirstResponder()
        txtEmail.resignFirstResponder()
        txtMobile.resignFirstResponder()

        strCost = txtCost.text!
        strCapacity = txtCapacity.text!
        strCounts = txtCounts.text!

        if strCityID.isEmpty
        {
            Toast(text: "Please Select City").show()
        }
        else if RoomID == 0
        {
            Toast(text: "Please Select Space Type").show()
        }
        else if strCost.isEmpty
        {
            Toast(text: "Please Enter Cost").show()
        }
        else if (txtName.text?.isEmpty)!
        {
            Toast(text: "Please Enter Space Name").show()
        }
        else if strCapacity.isEmpty
        {
            Toast(text: "Please Enter Number of Person").show()
        }
        else if strCounts.isEmpty
        {
            Toast(text: "Please Enter Number of Room").show()
        }
        else if (txtEmail.text?.isEmpty)!
        {
            Toast(text: "Please Enter Email").show()
        }
        else if txtEmail.text?.isValidEmail() == false
        {
            Toast(text: "Please Enter Valid Email.").show()
        }
        else if (txtMobile.text?.isEmpty)!
        {
            Toast(text: "Please Enter Mobile Number").show()
        }
        else if (txtMobile.text?.characters.count)! != 10 && !(txtMobile.text?.hasPrefix("05"))!
        {
            Toast(text: "Please Enter Correct Number").show()
        }
        else if self.strAddress.isEmpty
        {
            Toast(text: "Please Select Location").show()
        }
        else if self.arrImages.count == 0
        {
            Toast(text: "Please Select Image").show()
        }
        else
        {
            if self.app.isConnectedToInternet()
            {
                self.uploadData()
            }
            else
            {
                Toast(text: "Internet Connetion in not availble.Try Again").show()
            }
        }
    }
    
    func uploadData()
    {
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: false)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading..."
        loadingNotification.dimBackground = true
        
//        let strPrice : String = txtPrice.text!
        let strEmail : String = txtEmail.text!
        let strNumber : String = txtMobile.text!
        let strName : String = txtName.text!
        
        let parameters: Parameters = ["email":strEmail,
                                      "price":strCost,
                                      "name":strName,
                                      "mobile":strNumber,
                                      "type":RoomID,
                                      "capacity1":strCapacity,
                                      "avail1":strCounts,
                                      "capacity2":strPersonTwo,
                                      "avail2":strAvailableTwo,
                                      "capacity3":strPersonThree,
                                      "avail3":strAvailableThree,
                                      "projector":iProjector,
                                      "scanner":iScanner,
                                      "parking":iParking,
                                      "ac":iAirConditioner,
                                      "locker":iLockers,
                                      "phone":iPhone,
                                      "mail_ser":iMailServer,
                                      "wifi":iWiFi,
                                      "work":iWork,
                                      "male":iMale,
                                      "female":iFemale,
                                      "coffee":iCoffee,
                                      "location":strAddress,
                                      "lat":lat,
                                      "long":long,
                                      "cityname":"",
                                      "city_id":strCityID]
        print(JSON(parameters))
        Alamofire.request("\(self.app.strBaseAPI)your_space.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
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
                            self.strSpaceId = self.json["space_id"].stringValue
                            self.totalImage = self.arrImages.count
                            self.uploadFile()
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
    
    func uploadFile()
    {
        if self.imageCount < self.totalImage
        {
            let img : UIImage = self.arrImages[self.imageCount]
            self.UploadImageFileAPI(img: img)
        }
        else
        {
            Toast(text: "Space Added Successfully!").show()
            self.setDetails()
        }
    }
    
    func UploadImageFileAPI(img :UIImage)
    {
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: false)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading..."
        loadingNotification.dimBackground = true
        
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if let imageData = UIImageJPEGRepresentation(img, 0.1)
            {
                let format = DateFormatter()
                format.dateFormat="yyyy-MM-dd-HH-mm-ss"
                let currentFileName: String = "IMG-\(format.string(from: Date())).jpeg"
                
                multipartFormData.append(imageData, withName: "file", fileName: currentFileName, mimeType: "image/jpeg") //jpeg png
                multipartFormData.append(self.strSpaceId.data(using: .utf8)!, withName: "space_id")
            }
            
        }, to: "\(self.app.strBaseAPI)upload_space_pic.php", encodingCompletion: { response in
            switch response {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    
                    debugPrint("SUCCESS RESPONSE:- \(response)")
                    if let value = response.result.value
                    {
                        self.loadingNotification.hide(animated: true)
                        
                        self.json = JSON(value)
                        print(self.json)
                        
                        let strStatus : String = self.json["status"].stringValue
                        self.strMessage = self.json["message"].stringValue
                        
                        if strStatus == "1"
                        {
                            self.imageCount = self.imageCount + 1
                            self.uploadFile()
                        }
                        else
                        {
                            Toast(text: self.strMessage).show()
                        }
                    }
                }
            case .failure(let encodingError):
                print("ERROR RESPONSE: \(encodingError)")
                Toast(text: "Please check your internet connection.").show()
                self.loadingNotification.hide(animated: true)
            }
        })
        
    }
    
    @IBAction func btnCancelAction(_ sender: Any)
    {
        self.viewPopUp.isHidden = true
//        self.strAddress = ""
//        self.lat = 0
//        self.long = 0
    }
    
    @IBAction func btnSelectedMap(_ sender: Any)
    {
        self.viewPopUp.isHidden = true
        self.lat = self.selectedLat
        self.long = self.selectedLong
        self.strAddress = self.strSelectdAddress
        
        self.lblAddress.text = self.strAddress
        self.setScrollviewForLastView()
    }
    
    func handleLongPress(gestureReconizer: UILongPressGestureRecognizer)
    {
        if gestureReconizer.state != UIGestureRecognizerState.ended
        {
            let touchLocation = gestureReconizer.location(in: mapView)
            let locationCoordinate = mapView.convert(touchLocation,toCoordinateFrom: mapView)
            print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
            
            self.selectedLat = locationCoordinate.latitude
            self.selectedLong = locationCoordinate.longitude
            
            let allAnnotations = self.mapView.annotations
            self.mapView.removeAnnotations(allAnnotations)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = locationCoordinate
            
            CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude), completionHandler: {(placemarks, error) -> Void in
                if error != nil {
                    print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                    return
                }
                
                if (placemarks?.count)! > 0
                {
                    var placemark : CLPlacemark!
                    placemark = placemarks?[0]
                    var strAddress = String()
                    var strCountry = String()
                    if let formetAdd = placemark.addressDictionary!["FormattedAddressLines"] as? NSArray
                    {
                        strAddress = formetAdd.componentsJoined(by: ", ")
                        self.strSelectdAddress = strAddress
                    }
                    if let country = placemark.addressDictionary!["Country"] as? NSString
                    {
                        strCountry =  String(country)
                    }
                    
                    annotation.title = strAddress
                    annotation.subtitle = strCountry
                    self.mapView.addAnnotation(annotation)
                    
                    let location = CLLocationCoordinate2D(latitude: locationCoordinate.latitude,longitude: locationCoordinate.longitude)
                    
                    // 3)
                    let span = MKCoordinateSpanMake(0.05, 0.05)
                    let region = MKCoordinateRegion(center: location, span: span)
                    self.mapView.setRegion(region, animated: true)
                }
                else
                {
                    annotation.title = "Unknown Place"
                    self.mapView.addAnnotation(annotation)
                    print("Problem with the data received from geocoder")
                }
                
            })
            
            return
        }
    }
    
    //MARK:- Btn Add More

//    @IBAction func btnAddMore(_ sender: UIButton)
//    {
//        Total = Total + 1
//        if Total == 2
//        {
//            self.txtCapacityTwo.isHidden = false
//            self.txtCountsTwo.isHidden = false
//
//            self.btnAddMore.frame = CGRect(x:self.btnAddMore.frame.origin.x, y: self.txtCapacityTwo.frame.origin.y + self.txtCapacityTwo.frame.size.height + 10, width:self.btnAddMore.frame.size.width, height:self.btnAddMore.frame.size.height)
//        }
//        else if Total == 3
//        {
//            self.txtCapacityThree.isHidden = false
//            self.txtCountsThree.isHidden = false
//
//            self.btnAddMore.frame = CGRect(x:self.btnAddMore.frame.origin.x, y: self.txtCapacityThree.frame.origin.y + self.txtCapacityThree.frame.size.height + 10, width:self.btnAddMore.frame.size.width, height:self.btnAddMore.frame.size.height)
//        }
//        self.AddHideShow()
//    }
    
//    @IBAction func btnDelete(_ sender: UIButton)
//    {
//        Total = Total - 1
//
//        if Total == 1
//        {
//            self.txtCapacityTwo.isHidden = true
//            self.txtCountsTwo.isHidden = true
//            self.txtCapacityThree.isHidden = true
//            self.txtCountsThree.isHidden = true
//
//            self.btnDelete.isHidden = true
//            self.btnAddMore.frame = CGRect(x:self.btnAddMore.frame.origin.x, y: self.txtCapacity.frame.origin.y + self.txtCapacity.frame.size.height + 10, width:self.btnAddMore.frame.size.width, height:self.btnAddMore.frame.size.height)
//        }
//        else if Total == 2
//        {
//            self.txtCapacityThree.isHidden = true
//            self.txtCountsThree.isHidden = true
//
//            self.btnAddMore.frame = CGRect(x:self.btnAddMore.frame.origin.x, y: self.txtCapacityTwo.frame.origin.y + self.txtCapacityTwo.frame.size.height + 10, width:self.btnAddMore.frame.size.width, height:self.btnAddMore.frame.size.height)
//
//            self.btnDelete.isHidden = false
//        }
//        self.AddHideShow()
//    }
    
    func AddHideShow()
    {
//        if Total == 1
//        {
//            btnDelete.isHidden = true
//        }
//        else
//        {
//            btnDelete.isHidden = false
//        }
//
//        if Total == 3
//        {
//            btnAddMore.isHidden = true
//        }
//        else
//        {
//            btnAddMore.isHidden = false
//        }
//        self.btnDelete.frame = CGRect(x:self.btnDelete.frame.origin.x, y: self.btnAddMore.frame.origin.y, width:self.btnDelete.frame.size.width, height:self.btnDelete.frame.size.height)
//
//        self.txtEmail.frame = CGRect(x:self.txtEmail.frame.origin.x, y: self.btnAddMore.frame.origin.y + self.btnAddMore.frame.size.height + 10, width:self.txtEmail.frame.size.width, height:self.txtEmail.frame.size.height)

        self.txtMobile.frame = CGRect(x:self.txtMobile.frame.origin.x, y: self.txtEmail.frame.origin.y + self.txtEmail.frame.size.height + 10, width:self.txtMobile.frame.size.width, height:self.txtMobile.frame.size.height)

        self.viewTop.frame = CGRect(x:self.viewTop.frame.origin.x, y: self.viewTop.frame.origin.y, width:self.viewTop.frame.size.width, height:self.txtMobile.frame.origin.y + self.txtMobile.frame.size.height + 20)
        
        self.viewAmenities.frame = CGRect(x:self.viewAmenities.frame.origin.x, y: self.viewTop.frame.origin.y + self.viewTop.frame.size.height, width:self.viewAmenities.frame.size.width, height:self.viewAmenities.frame.size.height)

        self.viewLocation.frame = CGRect(x:self.viewLocation.frame.origin.x, y: self.viewAmenities.frame.origin.y + self.viewAmenities.frame.size.height, width:self.viewLocation.frame.size.width, height:self.viewLocation.frame.size.height)

        self.setScrollviewForLastView()
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
                                    
                                    self.arrCity.append(strName)
                                    self.arrCityID.append(strID)
                                }
                                self.txtCity.itemList = self.arrCity
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
    }
    
}
