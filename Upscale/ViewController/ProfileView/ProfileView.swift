//
//  ProfileView.swift
//  Upscale
//
//  Created by Developer on 26/04/17.
//  Copyright © 2017 krutik. All rights reserved.
//

import UIKit
import MapKit
import DatePickerDialog
import Toaster
import Alamofire
import SwiftyJSON
import MBProgressHUD
import MessageUI


class ProfileView: BaseViewController,FloatRatingViewDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,MKMapViewDelegate,UITextFieldDelegate,UITextViewDelegate,MFMailComposeViewControllerDelegate,UINavigationControllerDelegate
{
    
    @IBOutlet var lblOverView: UILabel!
    @IBOutlet var lblSpace: UILabel!
    @IBOutlet var lblReviews: UILabel!
    
    @IBOutlet var viewOverView: UIView!
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var imgscrollView: UIScrollView!
    @IBOutlet var pageController: UIPageControl!
    @IBOutlet var btnBackward: UIButton!
    @IBOutlet var btnForward: UIButton!
    
    @IBOutlet var viewAddress: UIView!
    @IBOutlet var viewImageLogo: UIView!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblSummery: UILabel!
    @IBOutlet var lblName: UILabel!
    
    @IBOutlet weak var viewContactUs: UIView!
    @IBOutlet var lblLangEmail: UILabel!
    @IBOutlet var lblLangNumber: UILabel!
    @IBOutlet var lblLangOpenHour: UILabel!
    @IBOutlet var lblLangAmenities: UILabel!
    @IBOutlet var lblLangLeaveAReview: UILabel!
    
    
    
    
    @IBOutlet var lblDesk: UILabel!
    @IBOutlet var lblMeeting: UILabel!
    @IBOutlet var lblDiscusion: UILabel!
    @IBOutlet var lblPrivate: UILabel!
    @IBOutlet var lblConference: UILabel!
    
    @IBOutlet weak var btnMoreReview: UIButton!
    @IBOutlet weak var lblMoreReview: UILabel!
    @IBOutlet var viewHours: UIView!
    
    @IBOutlet var lblFromMON: UILabel!
    @IBOutlet var lblFromTUE: UILabel!
    @IBOutlet var lblFromWED: UILabel!
    @IBOutlet var lblFromTHU: UILabel!
    @IBOutlet var lblFromFRI: UILabel!
    @IBOutlet var lblFromSAT: UILabel!
    @IBOutlet var lblFromSUN: UILabel!
    
    @IBOutlet var lblToMON: UILabel!
    @IBOutlet var lblToTUE: UILabel!
    @IBOutlet var lblToWED: UILabel!
    @IBOutlet var lblToTHU: UILabel!
    @IBOutlet var lblToFRI: UILabel!
    @IBOutlet var lblToSAT: UILabel!
    @IBOutlet var lblToSUN: UILabel!
    
    @IBOutlet var viewAmenities: UIView!
    @IBOutlet var clAmenitiesView: UICollectionView!
    @IBOutlet var viewMap: UIView!
    @IBOutlet var mapDetailsView: MKMapView!
    
    @IBOutlet weak var imgLogo: UIImageView!
    
    var arrAmenitiesImages = ["projector.png","air-conditioner.png","mail.png","scanner.png","lockers.png","wifi (1).png","parking.png","phone-call (2).png","work.png","male.png","female.png","cup.png"]
    var arrAmenities : [String] = []
    
    var strLanguage = "English"
    let defaults = UserDefaults.standard

    //View Space
    
    @IBOutlet var viewSpaceView: UIView!
    @IBOutlet var lblListLine: UILabel!
    @IBOutlet var lblMapLine: UILabel!
    
    @IBOutlet var viewList: UIView!
    @IBOutlet var tblView: UITableView!
    
    @IBOutlet var viewSpaceMap: UIView!
    @IBOutlet var mapViewSpace: MKMapView!
    
    //View Space
    
    @IBOutlet var viewReviews: UIView!
    @IBOutlet var viewFloatRating: FloatRatingView!
    @IBOutlet var txtReview: UITextView!
    @IBOutlet var btnReviewSubmit: UIButton!
    @IBOutlet var lblReviewCount: UILabel!
    @IBOutlet var tblViewReview: UITableView!
    
    
    @IBOutlet weak var viewPopUpContactUs: UIView!
    @IBOutlet weak var viewContactUsDetails: UIView!
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtNumber: UITextField!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var viewNumber: UIView!
    
    
    var loadingNotification : MBProgressHUD!
    var json : JSON!
    var strMessage : String!
    
//    var app = AppDelegate()
    var cell = AnemitiesCell()
    
    var arrList : [Any] = []
    var arrReview : [Any] = []
    var arrImages : [Any] = []
    var totalPages = Int()
    
    
    
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
    
    var Rating = Int()
    var RatingCount = Int()
    
    var giveRating = Float()
    
    var iOverView : Int = 0
    var iSpace : Int = 0
    var iReview : Int = 0
    
    //Map Array
    var arrCoordinates : [[Double]] = []
    var arrNames : [String] = []
    var arrAddresses : [String] = []
    var phones : [String] = []
    
    var arrReviewMap : [String] = []
    var arrRate : [String] = []
    var arrHour : [String] = []
    var arrUser : [String] = []
    var arrWifi : [String] = []
    var arrCall : [String] = []
    var arrMail : [String] = []
    var arrWork : [String] = []
    var arrKm : [String] = []
    var arrImagesMap : [String] = []
    
    var arrID : [String] = []
    
    var arrLat : [Double] = []
    var arrLong : [Double] = []
    
    var lat = Double()
    var long = Double()
    
    var strEmail = String()
    var strNumber = String()
    
    //MARK:-
    //MARK:-
    override func viewDidLoad()
    {
        super.viewDidLoad()
//        app = UIApplication.shared.delegate as! AppDelegate
        self.navigationController?.isNavigationBarHidden = true
        
        if defaults.string(forKey: "lat") != nil
        {
            lat = (defaults.value(forKey: "lat") as! Double)
            long = (defaults.value(forKey: "long") as! Double)
            
            print("Lat : \(lat)\nLong : \(long)")
        }
        
        txtReview.delegate = self
        
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
                        strCoffee]
        
//        let strMore = "( More )".localized
//        btnMoreReview.setTitle(strMore, for: .normal)

        
        lblSpace.isHidden = true
        lblReviews.isHidden = true
        
        
        lblOverView.isHidden = false
        lblSpace.isHidden = true
        lblReviews.isHidden = true
        
        viewOverView.isHidden = false
        viewSpaceView.isHidden = true
        viewReviews.isHidden = true
        
        lblListLine.isHidden = false
        viewList.isHidden = false
        
        lblMapLine.isHidden = true
        viewSpaceMap.isHidden = true
        
        self.viewFloatRating.delegate = self
        self.viewFloatRating.emptyImage = UIImage(named: "starg2.png")
        self.viewFloatRating.fullImage = UIImage(named: "star.png")
        
        self.viewFloatRating.contentMode = UIViewContentMode.scaleAspectFit
        self.viewFloatRating.maxRating = 5
        self.viewFloatRating.minRating = 1
        self.viewFloatRating.editable = true
        self.viewFloatRating.halfRatings = false
        self.viewFloatRating.backgroundColor = UIColor.clear
        self.viewFloatRating.rating = 0
        
        viewImageLogo.layer.cornerRadius = viewImageLogo.frame.size.height  / 2
        
        for viewAll: UIView in scrollView.subviews
        {
            if viewAll.tag == 100
            {
                scrollView.contentSize = CGSize(width: CGFloat(scrollView.frame.size.width), height: CGFloat(viewAll.frame.origin.y + viewAll.frame.size.height))
            }
        }
        
        tblView.delegate = self
        tblView.dataSource = self
        tblView.separatorStyle = .none
        
        tblViewReview.dataSource = self
        tblViewReview.delegate = self
        tblViewReview.separatorStyle = .none
        tblViewReview.isUserInteractionEnabled = false
        
        clAmenitiesView.register(UINib(nibName: "AnemitiesCell", bundle: nil), forCellWithReuseIdentifier: "AnemitiesCell")
        clAmenitiesView.delegate = self
        clAmenitiesView.dataSource = self
        
        btnReviewSubmit.layer.cornerRadius = btnReviewSubmit.frame.size.height / 2
        
        if self.app.isConnectedToInternet()
        {
            self.getSpaceDetailsAPI()
        }
        else
        {
            Toast(text: "Internet Connetion in not availble.Try Again").show()
        }
        
        viewPopUpContactUs.isHidden = true
        viewContactUsDetails.layer.cornerRadius = 5
        viewContactUs.layer.cornerRadius = 3
        
        self.textFieldPaddingView(txt: txtEmail, vv: viewEmail)
        self.textFieldPaddingView(txt: txtNumber, vv: viewNumber)
        self.scrollView.isHidden = true

        if DeviceType.IS_IPHONE_5
        {
            
            viewImageLogo.frame = CGRect(x: viewImageLogo.frame.origin.x, y: viewImageLogo.frame.origin.y, width: 60, height: 60)
            
            self.fontForiPhone5(lbl: lblFromMON)
            self.fontForiPhone5(lbl: lblFromTUE)
            self.fontForiPhone5(lbl: lblFromWED)
            self.fontForiPhone5(lbl: lblFromTHU)
            self.fontForiPhone5(lbl: lblFromFRI)
            self.fontForiPhone5(lbl: lblFromSAT)
            self.fontForiPhone5(lbl: lblFromSUN)
            
            self.fontForiPhone5(lbl: lblToMON)
            self.fontForiPhone5(lbl: lblToTUE)
            self.fontForiPhone5(lbl: lblToWED)
            self.fontForiPhone5(lbl: lblToTHU)
            self.fontForiPhone5(lbl: lblToFRI)
            self.fontForiPhone5(lbl: lblToSAT)
            self.fontForiPhone5(lbl: lblToSUN)
        }
        
        if self.defaults.string(forKey: "selectedLanguage") != nil
        {
            self.strLanguage = (self.defaults.value(forKey: "selectedLanguage") as! String)
        }
        
        if strLanguage == "ar"
        {
            txtEmail.textAlignment = .right
            txtNumber.textAlignment = .right
            txtReview.textAlignment = .right
            
            lblLangLeaveAReview.textAlignment = .right
            lblLangAmenities.textAlignment = .right
            lblLangOpenHour.textAlignment = .right
            lblLangEmail.textAlignment = .right
            lblLangNumber.textAlignment = .right
        }
        else
        {
            lblLangLeaveAReview.textAlignment = .left
            lblLangAmenities.textAlignment = .left
            lblLangOpenHour.textAlignment = .left
            lblLangEmail.textAlignment = .left
            lblLangNumber.textAlignment = .left
        }
    }
    
    func fontForiPhone5(lbl : UILabel)
    {
        lbl.font = lbl.font.withSize(7)
    }
    
    func textFieldPaddingView(txt : UITextField, vv : UIView)
    {
        txt.rightView = vv
        txt.rightViewMode = .always
        txt.delegate = self
        txt.isUserInteractionEnabled = false
        txt.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
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
    
    @IBAction func btnMoreReview(_ sender: Any)
    {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ReviewView") as! ReviewView
        VC.spaceID = spaceID
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    
    
    //MARK:- Button Actions
    @IBAction func btnOverView(_ sender: Any)
    {
        lblOverView.isHidden = false
        lblSpace.isHidden = true
        lblReviews.isHidden = true
        
        viewOverView.isHidden = false
        viewSpaceView.isHidden = true
        viewReviews.isHidden = true
        
        if iOverView == 0
        {
            if self.app.isConnectedToInternet()
            {
                self.getSpaceDetailsAPI()
            }
            else
            {
                Toast(text: "Internet Connetion in not availble.Try Again").show()
            }
        }
    }
    
    @IBAction func btnSpace(_ sender: Any)
    {
        lblOverView.isHidden = true
        lblSpace.isHidden = false
        lblReviews.isHidden = true
        
        viewOverView.isHidden = false
        viewSpaceView.isHidden = false
        viewReviews.isHidden = true
        
        if iSpace == 0
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
        else
        {
            self.tblView.reloadData()
        }
    }
    
    @IBAction func btnReviews(_ sender: Any)
    {
        lblOverView.isHidden = true
        lblSpace.isHidden = true
        lblReviews.isHidden = false
        
        viewOverView.isHidden = true
        viewSpaceView.isHidden = true
        viewReviews.isHidden = false
    }
    
    
    @IBAction func btnListCliked(_ sender: Any)
    {
        lblListLine.isHidden = false
        viewList.isHidden = false
        
        lblMapLine.isHidden = true
        viewSpaceMap.isHidden = true
    }
    
    @IBAction func btnMApCliked(_ sender: Any)
    {
        lblListLine.isHidden = true
        viewList.isHidden = true
        
        lblMapLine.isHidden = false
        viewSpaceMap.isHidden = false
    }
    
    //MARK:- Folating Rate
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating:Float)
    {
        print("Rateing : \(rating) ")
        self.giveRating = rating
        self.viewFloatRating.rating = self.giveRating
        print("Rateing : \(self.giveRating) ")
        //        self.lblRate.text = NSString(format: "%.2f", self.floatRatingView.rating) as String
    }

    //MARK:- Textview
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    
    //MARK:- TableView Methods
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if tableView == tblView
        {
            return self.arrList.count
        }
        else
        {
            return self.arrReview.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var CELL = UITableViewCell()
        
        if tableView == tblView
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
            cell.lblKM.text = strKM

            
            let strLocation : String = arrValue[indexPath.section]["location"].stringValue
            let strPrice : String = arrValue[indexPath.section]["price"].stringValue
            let strImage : String = ("\(arrValue[indexPath.section]["img"].stringValue)")
            
            let escapedString : String = strImage.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            print(escapedString)
            
            let strFullImage : String = "\(self.app.strImagePath)space/\(escapedString)"
            cell.imgProfile.sd_setImage(with: URL(string: strFullImage), placeholderImage: nil)
            
            cell.lblName.text = strName
            cell.lblAddress.text = strLocation
            cell.lblHour.text = strPrice
            
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
            
//            cell.imgProfile.sd_setImage(with: URL(string: strImage), placeholderImage: nil)
            
            cell.viewRating.emptyImage = UIImage(named: "starg2.png")
            cell.viewRating.fullImage = UIImage(named: "star.png")
            
            cell.viewRating.contentMode = UIViewContentMode.scaleAspectFit
            cell.viewRating.maxRating = 5
            cell.viewRating.minRating = 1
            cell.viewRating.editable = false
            cell.viewRating.halfRatings = false
            cell.viewRating.backgroundColor = UIColor.clear
            cell.viewRating.rating = 5
            
            cell.viewLeft.layer.cornerRadius = 3
            cell.viewLeft.clipsToBounds = true
            
            CELL = cell
        }
        else
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
            cell.viewReting.rating = 5
            
            var arrValue = JSON(self.arrReview)
            
            let strName : String = arrValue[indexPath.section]["user_name"].stringValue
            let strReview : String = arrValue[indexPath.section]["review"].stringValue
            let rate : Float = arrValue[indexPath.section]["rate"].floatValue
            let strDate : String = arrValue[indexPath.section]["datetime"].stringValue
            
            cell.viewReting.rating = rate
            
            cell.lblaName.text = strName
            cell.lblComments.text = strReview
            
            cell.lblDate.text = strDate
            cell.lblComments.clipsToBounds = true
            cell.lblComments.numberOfLines = 0
            
            let rect = cell.lblComments.text?.boundingRect(with: CGSize(width: CGFloat(cell.lblComments.frame.size.width), height: CGFloat(500)), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: cell.lblComments.font], context: nil)
            
            cell.lblComments.frame = CGRect(x: CGFloat(cell.lblComments.frame.origin.x), y: CGFloat(cell.lblComments.frame.origin.y), width: CGFloat(cell.lblComments.frame.size.width), height: CGFloat((rect?.size.height)!))
            
            cell.selectionStyle = .none
            
            cell.frame.size.height = cell.lblComments.frame.origin.x + cell.lblComments.frame.size.height + CGFloat(5) ///cell.frame.size.height
            CELL = cell
        }
        
        CELL.selectionStyle = .none
        if tableView == tblView
        {
            tblView.rowHeight = CELL.frame.size.height
        }
        else
        {
            tblViewReview.rowHeight = CELL.frame.size.height
        }
        
        return CELL
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //        var arrValue = JSON(self.arrList)
        //
        //        let VC = self.storyboard?.instantiateViewController(withIdentifier: "BookingListDetailView") as! BookingListDetailView
        //        VC.capacityID = arrValue[indexPath.row]["capacity"].intValue
        //        VC.spaceID = arrValue[indexPath.row]["space_id"].intValue
        //        self.navigationController?.pushViewController(VC, animated: true)
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
    
    //MARK:- Collection Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return arrAmenities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnemitiesCell", for: indexPath) as! AnemitiesCell
        
        let strAmenities : String = arrAmenities[indexPath.row]
        
        if strAmenities == "Projector(s)"
        {
            if self.strProjector != "1"
            {
                cell.alpha = 0.4
            }
        }
        else if strAmenities == "Air Conditioner"
        {
            if self.strAC != "1"
            {
                cell.alpha = 0.4
            }
        }
        else if strAmenities == "Mail service"
        {
            if self.strMail != "1"
            {
                cell.alpha = 0.4
            }
        }
        else if strAmenities == "Scanner / Printer"
        {
            if self.strScanner != "1"
            {
                cell.alpha = 0.4
            }
        }
        else if strAmenities == "Lockers"
        {
            if self.strLocker != "1"
            {
                cell.alpha = 0.4
            }
        }
        else if strAmenities == "WiFi / Internet"
        {
            if self.strWifi != "1"
            {
                cell.alpha = 0.4
            }
        }
        else if strAmenities == "Parking Space"
        {
            if self.strParking != "1"
            {
                cell.alpha = 0.4
            }
        }
        else if strAmenities == "Phone"
        {
            if self.strPhone != "1"
            {
                cell.alpha = 0.4
            }
        }
        else if strAmenities == "Phone"
        {
            if self.strPhone != "1"
            {
                cell.alpha = 0.4
            }
        }
        else if strAmenities == "Work 24 / h"
        {
            if self.strWork != "1"
            {
                cell.alpha = 0.4
            }
        }
        else if strAmenities == "Male"
        {
            if self.strMale != "1"
            {
                cell.alpha = 0.4
            }
        }
        else if strAmenities == "Female"
        {
            if self.strFemale != "1"
            {
                cell.alpha = 0.4
            }
        }
        else if strAmenities == "Coffee/Tea"
        {
            if self.strCoffee != "1"
            {
                cell.alpha = 0.4
            }
        }
        
        cell.lblName.text = strAmenities
        let img  = UIImage(named:self.arrAmenitiesImages[indexPath.row])
        cell.imgType.image = img
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if DeviceType.IS_IPHONE_5
        {
            return CGSize(width: 100, height: 40)
        }
        if DeviceType.IS_IPHONE_6
        {
            return CGSize(width: 115, height: 40)
        }
        else
        {
            return CGSize(width: 115, height: 40)
        }
    }
    
    @objc(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:) func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
    
    @objc(collectionView:layout:minimumLineSpacingForSectionAtIndex:) func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
    
    // Layout: Set Edges
    @objc(collectionView:layout:insetForSectionAtIndex:) func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // return UIEdgeInsetsMake(0,8,0,8);  // top, left, bottom, right
        return UIEdgeInsetsMake(0, 0, 0, 0)
        // top, left, bottom, right
    }
    
    //MARK:- get Space Details API
    func getSpaceDetailsAPI()
    {
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: false)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading..."
        loadingNotification.dimBackground = true
        
//        self.spaceID = 1
//        self.capacityID = 2

        let parameters: Parameters = ["user_id":self.app.strUserId,
                                      "your_space_id": self.spaceID,
                                      "capacity_id":self.capacityID]
        
        Alamofire.request("\(self.app.strBaseAPI)your_space_detail.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            debugPrint(response)
            
            if response.response?.statusCode == 200
            {
                self.loadingNotification.hide(animated: true)
                
                if response.result.isSuccess == true
                {
                    if let value = response.result.value
                    {
                        self.iOverView = 1
                        self.json = JSON(value)
                        print(self.json)
                        
                        let strStatus : String = self.json["status"].stringValue
                        self.strMessage = self.json["message"].stringValue
                        
                        if strStatus == "1"
                        {
                            self.scrollView.isHidden = false
                            self.arrReview.removeAll()
                            
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
                            
                            
                            self.Rating = self.json["rating"].intValue
                            self.RatingCount = self.json["rating_count"].intValue
                            
                            self.strLocation =  self.json["location"].stringValue
                            self.strDescription =  self.json["description"].stringValue
                            self.strPrice =  self.json["price"].stringValue
                            self.strCapacity =  self.json["capacity"].stringValue
                            
                            self.arrImages = self.json["images"].arrayValue
                            
                            self.arrReview = self.json["review"].arrayValue
                            
                            let strLogo : String = self.json["logo"].stringValue
                            self.strEmail = self.json["email"].stringValue
                            self.strNumber = self.json["phone"].stringValue
                            
                            self.txtEmail.text = self.strEmail
                            self.txtNumber.text = self.strNumber
                            
                            if self.arrReview.count == 0
                            {
                                self.btnMoreReview.isHidden = true
                                self.lblMoreReview.isHidden = true
                            }
                            
                            let escapedString : String = strLogo.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
                            print(escapedString)
                            
                            let strFullImage : String = "\(self.app.strImagePath)logo/\(escapedString)"
                            
                            self.imgLogo.sd_setImage(with: URL(string: strFullImage), placeholderImage: nil)
                            
                            self.lblReviewCount.text = "\(self.arrReview.count) Reviews"
                            
                            self.tblViewReview.reloadData()
                            
                            self.DefaulHeightforView()
                            
                            
                            self.lblName.text = self.strName
                            self.lblAddress.text = self.strLocation
                            
//                            self.mapDetailsView.delegate = self
                            self.mapDetailsView.mapType = MKMapType.standard
                            
                            // 2)
                            let LAT : Double = self.json["lat"].doubleValue
                            let LONG : Double = self.json["long"].doubleValue
                            
                            let location = CLLocationCoordinate2D(latitude: LAT,longitude: LONG)
                            
                            // 3)
                            let span = MKCoordinateSpanMake(0.05, 0.05)
                            let region = MKCoordinateRegion(center: location, span: span)
                            self.mapDetailsView.setRegion(region, animated: true)
                            
                            // 4)
                            let annotation = MKPointAnnotation()
                            annotation.coordinate = location
                            annotation.title = self.strName
                            annotation.subtitle = self.strLocation
                            self.mapDetailsView.addAnnotation(annotation)
                            //
                            
                            let rect2 = self.lblAddress.text?.boundingRect(with: CGSize(width: CGFloat(self.lblAddress.frame.size.width), height: CGFloat(500)), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: self.lblAddress.font], context: nil)

                            self.lblAddress.frame = CGRect(x: CGFloat(self.lblAddress.frame.origin.x), y: CGFloat(self.lblAddress.frame.origin.y), width: CGFloat(self.lblAddress.frame.size.width), height: CGFloat((rect2?.size.height)!))
                            
                            self.lblSummery.text = self.strDescription
                            
                            let rect = self.lblSummery.text?.boundingRect(with: CGSize(width: CGFloat(self.lblSummery.frame.size.width), height: CGFloat(500)), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: self.lblSummery.font], context: nil)
                            
                            self.lblSummery.frame = CGRect(x: CGFloat(self.lblSummery.frame.origin.x), y: CGFloat(self.lblAddress.frame.origin.y + self.lblAddress.frame.size.height + 5), width: CGFloat(self.lblSummery.frame.size.width), height: CGFloat((rect?.size.height)!))
                            
                            self.viewAddress.frame = CGRect(x: self.viewAddress.frame.origin.x, y: self.viewAddress.frame.origin.y, width: self.viewAddress.frame.size.width, height: self.lblSummery.frame.origin.y + self.lblSummery.frame.size.height + 10)
                            
                            self.viewHours.frame = CGRect(x: self.viewHours.frame.origin.x, y: self.viewAddress.frame.origin.y + self.viewAddress.frame.size.height, width: self.viewHours.frame.size.width, height: self.viewHours.frame.size.height)
                            
                            self.viewAmenities.frame = CGRect(x: self.viewHours.frame.origin.x, y: self.viewHours.frame.origin.y + self.viewHours.frame.size.height, width: self.viewAmenities.frame.size.width, height: self.viewAmenities.frame.size.height)
                            
                            self.viewMap.frame = CGRect(x: self.viewMap.frame.origin.x, y: self.viewAmenities.frame.origin.y + self.viewAmenities.frame.size.height, width: self.viewMap.frame.size.width, height: self.viewMap.frame.size.height)
                            
                            self.DefaulHeightforView()
                            
                            self.clAmenitiesView.delegate = self
                            self.clAmenitiesView.dataSource = self
                            
                            self.clAmenitiesView.reloadData()
                            
                            let arrData = self.json["days"].arrayValue
                            for i in 0 ..< arrData.count
                            {
                                let strDay : String = arrData[i]["day"].stringValue
                                let strOpenTime : String = arrData[i]["open_time"].stringValue
                                let strCloseTime : String = arrData[i]["close_time"].stringValue
                                
                                if strDay == "monday"
                                {
                                    self.lblFromMON.text = strOpenTime
                                    self.lblToMON.text = strCloseTime
                                }
                                else if strDay == "tuesday"
                                {
                                    self.lblFromTUE.text = strOpenTime
                                    self.lblToTUE.text = strCloseTime
                                }
                                else if strDay == "wednesday"
                                {
                                    self.lblFromWED.text = strOpenTime
                                    self.lblToWED.text = strCloseTime
                                }
                                else if strDay == "thursday"
                                {
                                    self.lblFromTHU.text = strOpenTime
                                    self.lblToTHU.text = strCloseTime
                                }
                                else if strDay == "friday"
                                {
                                    self.lblFromFRI.text = strOpenTime
                                    self.lblToFRI.text = strCloseTime
                                }
                                else if strDay == "saturday"
                                {
                                    self.lblFromSAT.text = strOpenTime
                                    self.lblToSAT.text = strCloseTime
                                }
                                else if strDay == "sunday"
                                {
                                    self.lblFromSUN.text = strOpenTime
                                    self.lblToSUN.text = strCloseTime
                                }
                            }
                            
                            self.configureScrollView()
                            self.configurePageControl()
                            
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
    
    func DefaulHeightforView()
    {
        for viewAll: UIView in scrollView.subviews
        {
            if viewAll.tag == 100
            {
                scrollView.contentSize = CGSize(width: CGFloat(scrollView.frame.size.width), height: CGFloat(viewAll.frame.origin.y + viewAll.frame.size.height))
            }
        }
    }
    func configureScrollView()
    {
        imgscrollView.isPagingEnabled = true
        
        imgscrollView.showsHorizontalScrollIndicator = false
        imgscrollView.showsVerticalScrollIndicator = false
        imgscrollView.scrollsToTop = false
        
        totalPages = self.arrImages.count
        
        imgscrollView.contentSize = CGSize(width: imgscrollView.frame.size.width * CGFloat(totalPages), height: imgscrollView.frame.size.height)
        
        // Load the TestView view from the TestView.xib file and configure it properly.
        
        for i in 0 ..< totalPages
        {
            let testView = Bundle.main.loadNibNamed("TestView", owner: self, options: nil)?[0] as! UIView
            
            testView.frame = CGRect(x: CGFloat(i) * imgscrollView.frame.size.width, y: imgscrollView.frame.origin.y, width: imgscrollView.frame.size.width, height: imgscrollView.frame.size.height)
            
            let img = testView.viewWithTag(2) as! UIImageView
            //            img.image = UIImage(named:arrImage[i])
            
            let arrValue = JSON(self.arrImages)
            let strImg = arrValue[i]["image"].stringValue
            
            let escapedString : String = strImg.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            print(escapedString)
            
            let strFullImage : String = "\(self.app.strImagePath)space/\(escapedString)"
            
            img.sd_setImage(with: URL(string: strFullImage), placeholderImage: nil)
            
            imgscrollView.addSubview(testView)
        }
        
        if self.arrImages.count == 0
        {
            let testView = Bundle.main.loadNibNamed("TestView", owner: self, options: nil)?[0] as! UIView
            
            testView.frame = CGRect(x: CGFloat(0) * imgscrollView.frame.size.width, y: imgscrollView.frame.origin.y, width: imgscrollView.frame.size.width, height: imgscrollView.frame.size.height)
            
            let img = testView.viewWithTag(2) as! UIImageView
            img.image = UIImage(named:"logo1.png")
            imgscrollView.addSubview(testView)
        }
    }
    
    func configurePageControl()
    {
        pageController.numberOfPages = totalPages
        
        pageController.currentPage = 0
    }
    
    
    @IBAction func btnAddReview(_ sender: Any)
    {
        print(self.giveRating)
        
        if self.giveRating == 0
        {
            Toast(text: "Please Give Your Rating").show()
        }
        else if self.txtReview.text.isEmpty
        {
            Toast(text: "Please Write a Review").show()
        }
        else
        {
            if self.app.isConnectedToInternet()
            {
                self.insertReviewAPI()
            }
            else
            {
                Toast(text: "Internet Connetion in not availble.Try Again").show()
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
        
        let strReviewText : String = self.txtReview.text!
        
        
        // {"space_id":1,"user_id":1,"rating":5,"review":"asda as das das das dada asd sad"}
        let parameters: Parameters = ["space_id": self.spaceID,
                                      "user_id":self.app.strUserId,
                                      "rating":Int(self.giveRating),
                                      "review":strReviewText]
        print(parameters)
        
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
                            
                            self.viewFloatRating.rating = 0
                            self.giveRating = 0
                            self.txtReview.text = nil
                            
                            if self.app.isConnectedToInternet()
                            {
                                self.getAllReviewAPI()
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
    
    
    
    func getAllReviewAPI()
    {
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: false)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading..."
        loadingNotification.dimBackground = true
        
        
        // {"space_id": "1", "limit": "2"}
        let parameters: Parameters = ["space_id": self.spaceID,
                                      "limit":2]
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
                            
                            self.tblViewReview.reloadData()
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
    func getBookingListAPI()
    {
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: false)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading..."
        loadingNotification.dimBackground = true
        
        spaceUserID = 1
        //{"date":"2017-04-17","fromtime":"08:00","totime":"10:00","space_type":1,"location":"abc street"}
        let parameters: Parameters = ["space_user_id":self.spaceUserID,
                                      "lat":lat,
                                      "long":long]
        
        print(parameters)
        
        Alamofire.request("\(self.app.strBaseAPI)space_list.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            debugPrint(response)
            
            if response.response?.statusCode == 200
            {
                self.loadingNotification.hide(animated: true)
                
                if response.result.isSuccess == true
                {
                    if let value = response.result.value
                    {
                        self.iSpace = 1
                        self.json = JSON(value)
                        print(self.json)
                        
                        let strStatus : String = self.json["status"].stringValue
                        self.strMessage = self.json["message"].stringValue
                        
                        if strStatus == "1"
                        {
                            self.arrList.removeAll()
                            
                            self.arrID.removeAll()
                            self.arrCoordinates.removeAll()
                            self.arrNames.removeAll()
                            self.arrAddresses.removeAll()
                            self.arrReviewMap.removeAll() //
                            self.arrRate.removeAll()
                            self.arrHour.removeAll()
                            self.arrUser.removeAll()
                            self.arrWifi.removeAll()
                            self.arrCall.removeAll()
                            self.arrMail.removeAll()
                            self.arrWork.removeAll()
                            self.arrKm.removeAll()
                            self.arrImagesMap.removeAll() //
                            
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

                                self.arrLat.append(Double(strLat)!)
                                self.arrLong.append(Double(strLong)!)
                                
                                self.arrNames.append(strName)
                                self.arrAddresses.append(strAddresses)
                                
                                self.arrReviewMap.append(strReview) //
                                self.arrRate.append(strRating)
                                self.arrHour.append(strHour)
                                self.arrUser.append(strUser)
                                
                                self.arrWifi.append(strWifi)
                                self.arrCall.append(strCall)
                                self.arrMail.append(strMail)
                                self.arrWork.append(strWork)
                                
                                self.arrImagesMap.append(strImages) //
                                self.arrKm.append(strKM)
                            }
                            
                            self.mapViewSpace.delegate = self
                            
                            for i in 0...self.arrID.count-1
                            {
                                
                                let LAT = self.arrLat[i]
                                let LONG = self.arrLong[i]
                                
                                let point = StarbucksAnnotation(coordinate: CLLocationCoordinate2D(latitude: LAT , longitude: LONG))
                                point.image = UIImage(named: "starbucks-\(i+1).jpg")
                                point.name = self.arrNames[i]
                                point.address = self.arrAddresses[i]
                                
                                point.review = self.arrReviewMap[i]
                                point.rate = self.arrRate[i]
                                point.hour = self.arrHour[i]
                                point.user = self.arrUser[i]
                                point.wifi = self.arrWifi[i]
                                point.call = self.arrCall[i]
                                point.mail = self.arrMail[i]
                                point.work = self.arrWork[i]
                                point.km = self.arrKm[i]
                                
                                point.id = self.arrID[i]
                                point.img = self.arrImagesMap[i]
                                
                                
                                self.mapViewSpace.addAnnotation(point)
                            }
                            // 3
                            
                            let LAT = self.arrLat[0]
                            let LONG = self.arrLong[0]
                            
//                            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: LAT, longitude: LONG), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
                            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: LAT, longitude: LONG), span: MKCoordinateSpan(latitudeDelta: 0.2,longitudeDelta: 0.2))
                            //latitudeDelta: 0.2,longitudeDelta: 0.2
                            self.mapViewSpace.setRegion(region, animated: true)
                            
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
        var MK = MKAnnotationView()
        if mapView == mapViewSpace
        {
            if annotation is MKUserLocation
            {
                return nil
            }
            var annotationView = self.mapViewSpace.dequeueReusableAnnotationView(withIdentifier: "Pin")
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
            MK = annotationView!
            
//            return annotationView
        }
        else
        {
            let annotationView = AnnotationView(annotation: annotation, reuseIdentifier: "Attraction")
            annotationView.canShowCallout = true
             MK = annotationView
//            MK = annotation as! MKAnnotationView
        }
        return MK
    }

    //MARK:- Map Delegate
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        if mapView == mapViewSpace
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
            button.addTarget(self, action: #selector(callPhoneNumber(sender:)), for: .touchUpInside)
            button.tag = Int(starbucksAnnotation.id)!
            calloutView.addSubview(button)
            
            // 3
            calloutView.center = CGPoint(x: view.bounds.size.width / 2, y: -calloutView.bounds.size.height*0.52)
            view.addSubview(calloutView)
            mapView.setCenter((view.annotation?.coordinate)!, animated: true)
        }
        
    }
    
    @objc func callPhoneNumber(sender: UIButton)
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
    
    @IBAction func btnContactUsAction(_ sender: Any)
    {
       viewPopUpContactUs.isHidden = false
    }
    
    @IBAction func btnContactUsCancel(_ sender: Any)
    {
        viewPopUpContactUs.isHidden = true
    }
    
    //MARK:- Call And Mail

    @IBAction func btnCallAndMail(_ sender: Any)
    {
        if (sender as AnyObject).tag == 2
        {
            if let url = URL(string: "tel://\(strNumber)"), UIApplication.shared.canOpenURL(url)
            {
                if #available(iOS 10, *)
                {
                    UIApplication.shared.open(url)
                }
                else
                {
                    UIApplication.shared.openURL(url)
                }
            }
        }
        else if (sender as AnyObject).tag == 1
        {
            let mailComposeViewController = configuredMailComposeViewController()
            mailComposeViewController.delegate = self //as? UINavigationControllerDelegate
            
            if MFMailComposeViewController.canSendMail()
            {
                self.present(mailComposeViewController, animated: true, completion: nil)
            }
        }
    }
    
    //MARK:- MFMailCompose
    func configuredMailComposeViewController() -> MFMailComposeViewController
    {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        //        mailComposerVC.delegate = self
        mailComposerVC.setToRecipients([self.strEmail])
        mailComposerVC.setSubject("")
        mailComposerVC.setMessageBody("", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert()
    {
        let alertController = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?)
    {
        switch result
        {
        case .cancelled:
            print("Mail cancelled")
        case .saved:
            print("Mail saved")
        case .sent:
            print("Mail sent")
            Toast(text: "Mail sent").show()

        case .failed:
            print("Mail sent failure: \(String(describing: error?.localizedDescription))")
            //        default:
            //            break
        }
        
        // Close the Mail Interface
        dismiss(animated: true) {
            
        }
    }
    
    
}



