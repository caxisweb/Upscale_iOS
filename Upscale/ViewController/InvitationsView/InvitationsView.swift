//
//  InvitationsView.swift
//  Upscale
//
//  Created by Developer on 27/04/17.
//  Copyright © 2017 krutik. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD
import Toaster
import ImageSlideshow

class InvitationsView: BaseViewController,UITextFieldDelegate
{
    //MARK:- Outlet
    @IBOutlet var viewNavigation: UIView!

    @IBOutlet var viewTop: UIView!
    @IBOutlet var imgPager: ImageSlideshow!

    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblPerson: UILabel!
    @IBOutlet var lblLocation: UILabel!

    
    @IBOutlet var btnSend: UIButton!
        
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var viewDetails: UIView!
    @IBOutlet var txtEmail: UITextField!
    
    @IBOutlet var txtNumber: UITextField!
    
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var lblMob: UILabel!
    
    @IBOutlet var txtEmailTwo: UITextField!
    @IBOutlet var txtNumberTwo: UITextField!
    
    @IBOutlet var txtEmailThree: UITextField!
    @IBOutlet var txtNumberThree: UITextField!
    
    
    @IBOutlet var viewSend: UIView!    
    @IBOutlet var viewSecond: UIView!
    
    @IBOutlet var txtEmailFour: UITextField!
    @IBOutlet var txtNumberFour: UITextField!
    
    @IBOutlet var txtEmailFive: UITextField!
    @IBOutlet var txtNumberFive: UITextField!
    
    @IBOutlet var txtEmailSix: UITextField!
    @IBOutlet var txtNumberSix: UITextField!
    
    
    @IBOutlet var viewThree: UIView!
    
    @IBOutlet var txtEmailSeven: UITextField!
    @IBOutlet var txtNumberSeven: UITextField!
    
    @IBOutlet var txtEmailEight: UITextField!
    @IBOutlet var txtNumberEight: UITextField!
    
    @IBOutlet var txtEmailNine: UITextField!
    @IBOutlet var txtNumberNine: UITextField!
    
    @IBOutlet var viewAddMore: UIView!
    @IBOutlet var btnDelete: UIButton!
    @IBOutlet var btnAddMore: UIButton!
    @IBOutlet var btnAddPlus: UIButton!
    
    
    @IBOutlet var lblOne: UILabel!
    @IBOutlet var lblTwo: UILabel!
    @IBOutlet var lblThree: UILabel!
    @IBOutlet var lblFour: UILabel!
    @IBOutlet var lblFive: UILabel!
    @IBOutlet var lblSix: UILabel!
    @IBOutlet var lblSeven: UILabel!
    @IBOutlet var lblEight: UILabel!
    @IBOutlet var lblNine: UILabel!

    var loadingNotification : MBProgressHUD!
    var json : JSON!
    var strMessage : String!
    
//    var app = AppDelegate()
    
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
    var repeatCount = Int()
    var strBookingID = String()
    
    var Y = Int()
    var arrEmail : [UITextField] = []
    var arrNumber : [UITextField] = []
    
    var strEmail = String()
    var strNumber = String()
    
    var iAddMore = 1
    var arrSDWebImageSource : [SDWebImageSource] = []

    var strLanguage = "English"
    let defaults = UserDefaults.standard

    //MARK:-
    //MARK:-
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        if DeviceType.IS_IPHONE_X
        {
            self.viewNavigation.frame = CGRect(x:self.viewNavigation.frame.origin.x, y: self.viewNavigation.frame.origin.y, width:self.viewNavigation.frame.size.width, height:88)
            self.scrollView.frame = CGRect(x:self.scrollView.frame.origin.x, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height, width:self.scrollView.frame.size.width, height:self.view.frame.size.height -  self.viewNavigation.frame.size.height - 75)
        }
        
        if self.defaults.string(forKey: "selectedLanguage") != nil
        {
            self.strLanguage = (self.defaults.value(forKey: "selectedLanguage") as! String)
        }
        
        self.labelCornerRadiation(lbl: lblOne)
        self.labelCornerRadiation(lbl: lblTwo)
        self.labelCornerRadiation(lbl: lblThree)
        self.labelCornerRadiation(lbl: lblFour)
        self.labelCornerRadiation(lbl: lblFive)
        self.labelCornerRadiation(lbl: lblSix)
        self.labelCornerRadiation(lbl: lblSeven)
        self.labelCornerRadiation(lbl: lblEight)
        self.labelCornerRadiation(lbl: lblNine)

        self.textFieldCornerRadiation(txt: txtEmail)
        self.textFieldCornerRadiation(txt: txtEmailTwo)
        self.textFieldCornerRadiation(txt: txtEmailThree)
        self.textFieldCornerRadiation(txt: txtEmailFour)
        self.textFieldCornerRadiation(txt: txtEmailFive)
        self.textFieldCornerRadiation(txt: txtEmailSix)
        self.textFieldCornerRadiation(txt: txtEmailSeven)
        self.textFieldCornerRadiation(txt: txtEmailEight)
        self.textFieldCornerRadiation(txt: txtEmailNine)
        
        self.textFieldCornerRadiation(txt: txtNumber)
        self.textFieldCornerRadiation(txt: txtNumberTwo)
        self.textFieldCornerRadiation(txt: txtNumberThree)
        self.textFieldCornerRadiation(txt: txtNumberFour)
        self.textFieldCornerRadiation(txt: txtNumberFive)
        self.textFieldCornerRadiation(txt: txtNumberSix)
        self.textFieldCornerRadiation(txt: txtNumberSeven)
        self.textFieldCornerRadiation(txt: txtNumberEight)
        self.textFieldCornerRadiation(txt: txtNumberNine)
        
        self.viewSecond.isHidden = true
        self.viewThree.isHidden = true
        self.btnDelete.isHidden = true

        self.setDefault(vv: viewDetails)
        
        self.setScrollViewHeight()
        
        btnSend.layer.cornerRadius = 4
        
//        self.arrSDWebImageSource.append(SDWebImageSource(urlString: "http://swiftdeveloperblog.com/wp-content/uploads/2015/07/1.jpeg")!)
//        self.arrSDWebImageSource.append(SDWebImageSource(urlString: "http://www.quentinroussat.fr/assets/img/iOS%20icon's%20Style/ios8.png")!)
//        self.arrSDWebImageSource.append(SDWebImageSource(urlString: "http://www.simplifiedtechy.net/wp-content/uploads/2017/07/simplified-techy-default.png")!)
        //
        self.imgPager.tag = self.imgPager.currentPage
        self.imgPager.contentScaleMode = UIViewContentMode.scaleAspectFill

        self.imgPager.pageControl.pageIndicatorTintColor = UIColor.white
        self.imgPager.pageControl.currentPageIndicatorTintColor = UIColor.init(rgb: 0xE9983E)
        
        self.imgPager.activityIndicator = DefaultActivityIndicator()
        self.imgPager.currentPageChanged = { page in
            self.imgPager.tag = page
        }
        
        self.imgPager.setImageInputs(self.arrSDWebImageSource)
        
        self.lblName.text = strName
        self.lblLocation.text = strLocation
        self.lblPerson.text = strCapacity
        self.lblPrice.text = "\(strPrice) SAR/Hr"

        //scrollView
//        self.textFieldCornerRadiation(txt: txtEmail)
//        self.textFieldCornerRadiation(txt: txtNumber)
//        self.labelCornerRadiation(lbl: lblCount)
        /*
        viewDetails.isHidden = true
        if strCapacity.isEmpty
        {
            strCapacity = "0"
        }
        let capacity : Int = Int(strCapacity)!
        
        if capacity != 0
        {
            for i in 1...capacity
            {
                let vv = UIView()
                
                let txtE = UITextField()
                let txtN = UITextField()
                let lblC = UILabel()
                let lblE = UILabel()
                let lblN = UILabel()
                
                vv.frame = CGRect(x: self.viewDetails.frame.origin.x, y: CGFloat(self.Y), width: self.viewDetails.frame.size.width, height: self.viewDetails.frame.size.height)
                
                lblC.frame = CGRect(x: self.lblCount.frame.origin.x, y: self.lblCount.frame.origin.y, width: self.lblCount.frame.size.width, height: self.lblCount.frame.size.height)
                lblE.frame = CGRect(x: self.lblEmail.frame.origin.x, y: self.lblEmail.frame.origin.y, width: self.lblEmail.frame.size.width, height: self.lblEmail.frame.size.height)
                lblN.frame = CGRect(x: self.lblMob.frame.origin.x, y: self.lblMob.frame.origin.y, width: self.lblMob.frame.size.width, height: self.lblCount.frame.size.height)
                
                lblE.font = lblEmail.font
                lblN.font = lblMob.font
                lblE.textColor = lblEmail.textColor
                lblN.textColor = lblMob.textColor
                
                txtE.keyboardType = .emailAddress
                txtN.keyboardType = .numberPad
                
                lblE.text = "E-mail".localized
                lblN.text = "Mob.".localized
         
                txtE.frame = CGRect(x: self.txtEmail.frame.origin.x, y: self.txtEmail.frame.origin.y, width: self.txtEmail.frame.size.width, height: self.txtEmail.frame.size.height)
                txtN.frame = CGRect(x: self.txtNumber.frame.origin.x, y: self.txtNumber.frame.origin.y, width: self.txtNumber.frame.size.width, height: self.txtNumber.frame.size.height)
                
                lblC.text = "\(i)"
                
                txtE.tag = i
                txtN.tag = i
                lblE.tag = i
                lblN.tag = i
                lblC.tag = i
                
                self.textFieldCornerRadiation(txt: txtE)
                self.textFieldCornerRadiation(txt: txtN)
                self.labelCornerRadiation(lbl: lblC)
                
                self.arrEmail.append(txtE)
                self.arrNumber.append(txtN)
         
                vv.addSubview(lblC)
                vv.addSubview(lblE)
                vv.addSubview(lblN)
                vv.addSubview(txtE)
                vv.addSubview(txtN)
                
                Y = Int(vv.frame.origin.y + vv.frame.size.height)
                
                self.scrollView.addSubview(vv)
            }
            
            self.viewSend.frame = CGRect(x: self.viewSend.frame.origin.x, y: CGFloat(self.Y), width: self.viewSend.frame.size.width, height: self.viewSend.frame.size.height)
            self.setScrollViewHeight()
        }
 */
        
    }
    
    func setScrollViewHeight()
    {
        for viewAll: UIView in scrollView.subviews
        {
            if viewAll.tag == 100
            {
                scrollView.contentSize = CGSize(width: CGFloat(scrollView.frame.size.width), height: CGFloat(viewAll.frame.origin.y + viewAll.frame.size.height + 10))
            }
        }
    }
    
    func textFieldCornerRadiation(txt : UITextField)
    {
        txt.layer.borderWidth = 1
        txt.layer.borderColor = UIColor.lightGray.cgColor
        txt.layer.cornerRadius = 1
        txt.delegate = self
        txt.font = txtEmail.font
        
        if DeviceType.IS_IPHONE_5
        {
            txt.font = txt.font?.withSize(14)
        }
        if txt.keyboardType == .emailAddress
        {
            txt.placeholder = "Email".localized
        }
        if self.strLanguage == "ar"
        {
            txt.setRightPaddingPoints(5)
            txt.textAlignment = .right
        }
        else
        {
            txt.setLeftPaddingPoints(5)
            txt.textAlignment = .left
        }
    }
    
    func labelCornerRadiation(lbl : UILabel)
    {
        if DeviceType.IS_IPHONE_5
        {
            lbl.frame = CGRect(x: lbl.frame.origin.x - 5, y: lbl.frame.origin.y, width: lbl.frame.size.width, height: lbl.frame.size.height)
        }
        lbl.layer.cornerRadius = lbl.layer.frame.size.height / 2
        lbl.clipsToBounds = true
        lbl.backgroundColor = UIColor.lightGray
        lbl.textAlignment = .center
    }
    
    //MARK:- Textfield Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField .resignFirstResponder()
        return true
    }
    
    @IBAction func btnMenu(_ sender: Any)
    {
        let desiredViewController = self.navigationController!.viewControllers.filter { $0 is BookingView }.first!
        self.navigationController!.popToViewController(desiredViewController, animated: true)
    }
    
    func HideKeyboard()
    {
        txtEmail.resignFirstResponder()
        txtEmailTwo.resignFirstResponder()
        txtEmailThree.resignFirstResponder()
        txtEmailFour.resignFirstResponder()
        txtEmailFive.resignFirstResponder()
        txtEmailSix.resignFirstResponder()
        txtEmailSeven.resignFirstResponder()
        txtEmailEight.resignFirstResponder()
        txtEmailNine.resignFirstResponder()
        
        txtNumber.resignFirstResponder()
        txtNumberTwo.resignFirstResponder()
        txtNumberThree.resignFirstResponder()
        txtNumberFour.resignFirstResponder()
        txtNumberFive.resignFirstResponder()
        txtNumberSix.resignFirstResponder()
        txtNumberSeven.resignFirstResponder()
        txtNumberEight.resignFirstResponder()
        txtNumberNine.resignFirstResponder()
    }
    
    //MARK:- Button Send
    @IBAction func btnSend(_ sender: Any)
    {
        self.HideKeyboard()
        
        if (txtEmail.text?.isEmpty)!
        {
            Toast(text: "Please Enter Email").show()
        }
        else if isValidEmail(testStr: txtEmail.text!) == false
        {
            Toast(text: "Please Enter Valid Email.").show()
        }
        else if (txtNumber.text?.isEmpty)!
        {
            Toast(text: "Please Enter Number").show()
        }
        else if (txtNumber.text?.characters.count)! != 10  && !(txtNumber.text?.hasPrefix("05"))!
        {
            Toast(text: "Please Enter Correct Number").show()
        }
        else if (!(txtEmailTwo.text?.isEmpty)!) && isValidEmail(testStr: txtEmailTwo.text!) == false //Email
        {
            Toast(text: "Please Enter Valid Email.").show()
        }
        else if (!(txtEmailThree.text?.isEmpty)!) && isValidEmail(testStr: txtEmailThree.text!) == false
        {
            Toast(text: "Please Enter Valid Email.").show()
        }
        else if (!(txtEmailFour.text?.isEmpty)!) && isValidEmail(testStr: txtEmailFour.text!) == false
        {
            Toast(text: "Please Enter Valid Email.").show()
        }
        else if (!(txtEmailFive.text?.isEmpty)!) && isValidEmail(testStr: txtEmailFive.text!) == false
        {
            Toast(text: "Please Enter Valid Email.").show()
        }
        else if (!(txtEmailSix.text?.isEmpty)!) && isValidEmail(testStr: txtEmailSix.text!) == false
        {
            Toast(text: "Please Enter Valid Email.").show()
        }
        else if (!(txtEmailSeven.text?.isEmpty)!) && isValidEmail(testStr: txtEmailSeven.text!) == false
        {
            Toast(text: "Please Enter Valid Email.").show()
        }
        else if (!(txtEmailEight.text?.isEmpty)!) && isValidEmail(testStr: txtEmailEight.text!) == false
        {
            Toast(text: "Please Enter Valid Email.").show()
        }
        else if (!(txtEmailNine.text?.isEmpty)!) && isValidEmail(testStr: txtEmailNine.text!) == false
        {
            Toast(text: "Please Enter Valid Email.").show()
        }
        else if !(txtNumberTwo.text?.isEmpty)! && (txtNumberTwo.text?.characters.count)! != 10 && !(txtNumberTwo.text?.hasPrefix("05"))!
        {
            Toast(text: "Please Enter Correct Second Number").show()
        }
        else if !(txtNumberThree.text?.isEmpty)! && (txtNumberThree.text?.characters.count)! != 10 && !(txtNumberThree.text?.hasPrefix("05"))!
        {
            Toast(text: "Please Enter Correct Third Number").show()
        }
        else if !(txtNumberFour.text?.isEmpty)! && (txtNumberFour.text?.characters.count)! != 10 && !(txtNumberFour.text?.hasPrefix("05"))!
        {
            Toast(text: "Please Enter Correct Forth Number").show()
        }
        else if !(txtNumberFive.text?.isEmpty)! && (txtNumberFive.text?.characters.count)! != 10 && !(txtNumberFive.text?.hasPrefix("05"))!
        {
            Toast(text: "Please Enter Correct Fifth Number").show()
        }
        else if !(txtNumberSix.text?.isEmpty)! && (txtNumberSix.text?.characters.count)! != 10 && !(txtNumberSix.text?.hasPrefix("05"))!
        {
            Toast(text: "Please Enter Correct Sixth Number").show()
        }
        else if !(txtNumberSeven.text?.isEmpty)! && (txtNumberSeven.text?.characters.count)! != 10 && !(txtNumberSeven.text?.hasPrefix("05"))!
        {
            Toast(text: "Please Enter Correct Seventh Number").show()
        }
        else if !(txtNumberEight.text?.isEmpty)! && (txtNumberEight.text?.characters.count)! != 10 && (txtNumberEight.text?.hasPrefix("05"))!
        {
            Toast(text: "Please Enter Correct Eighth Number").show()
        }
        else if !(txtNumberNine.text?.isEmpty)! && (txtNumberNine.text?.characters.count)! != 10 && !(txtNumberNine.text?.hasPrefix("05"))!
        {
            Toast(text: "Please Enter Correct Nineth Number").show()
        }
        else
        {
            strEmail = ""
            strNumber = ""
            
            strEmail = ("\(txtEmail.text!),\(txtEmailTwo.text!),\(txtEmailThree.text!),\(txtEmailFour.text!),\(txtEmailFive.text!),\(txtEmailSix.text!),\(txtEmailSeven.text!),\(txtEmailEight.text!),\(txtEmailNine.text!)")
            strNumber = ("\(txtNumber.text!),\(txtNumberTwo.text!),\(txtNumberThree.text!),\(txtNumberFour.text!),\(txtNumberFive.text!),\(txtNumberSix.text!),\(txtNumberSeven.text!),\(txtNumberEight.text!),\(txtNumberNine.text!)")
            
            print("Emails : \(strEmail)")
            print("Number : \(strNumber)")
            
            if self.app.isConnectedToInternet()
            {
                self.inviteUserAPI()
            }
            else
            {
                Toast(text: "Internet Connetion in not availble.Try Again").show()
            }
        }
    }
    
    //MARK:- Email Validation 
    func isValidEmail(testStr:String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)

        return result
    }
    
    //MARK:- InviteUser API
    func inviteUserAPI()
    {
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: false)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading..."
        loadingNotification.dimBackground = true
        
        let parameters: Parameters = ["final_booking_id": self.strBookingID,
                                      "user_id":self.app.strUserId,
                                      "office_name":self.strName,
                                      "email_id":strEmail,
                                      "mobile_num":strNumber]
        
        //{"final_booking_id":"65","user_id":"684","office_name":"Test P","email_id":"maulik.dce@gmail.com,jhalapratipalsinh@gmail.com,jaydeep.wwe@gmail.com","mobile_num":"8780932559,8905986678,8488838244"}
        print(JSON(parameters))
        
        Alamofire.request("\(self.app.strBaseAPI)invite_user.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
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
                            Toast(text: "Invitation has been successfully sent").show()

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
    
    //MARK:- viewAddMore
    @IBAction func btnAddMore(_ sender: Any)
    {
        if iAddMore == 1
        {
            iAddMore = iAddMore + 1
            
            viewSecond.isHidden = false
            btnDelete.isHidden = false
            self.btnAddMore.isHidden = false
            self.btnAddPlus.isHidden = false
            
            UIView.animate(withDuration: 0.4, animations: {
                self.viewSecond.frame = CGRect(x: self.viewSecond.frame.origin.x, y: self.viewDetails.frame.origin.y + self.viewDetails.frame.size.height, width: self.viewSecond.frame.size.width, height: self.viewSecond.frame.size.height)
                
                self.setDefault(vv: self.viewSecond)
            })
        }
        else if iAddMore == 2
        {
            iAddMore = iAddMore + 1
            
            viewThree.isHidden = false
            btnDelete.isHidden = false
            self.btnAddMore.isHidden = true
            self.btnAddPlus.isHidden = true
            
            UIView.animate(withDuration: 0.4, animations: {
                self.viewThree.frame = CGRect(x: self.viewThree.frame.origin.x, y: self.viewSecond.frame.origin.y + self.viewSecond.frame.size.height, width: self.viewThree.frame.size.width, height: self.viewThree.frame.size.height)
                
                self.setDefault(vv: self.viewThree)
            })
            
        }
    }
   
    @IBAction func btnDelete(_ sender: Any)
    {
        if iAddMore == 3
        {
            iAddMore = iAddMore - 1
            viewThree.isHidden = true
            self.btnAddMore.isHidden = false
            self.btnAddPlus.isHidden = false
            btnDelete.isHidden = false

            UIView.animate(withDuration: 0.4, animations: {
                self.setDefault(vv: self.viewSecond)
            })
        }
        else if iAddMore == 2
        {
            iAddMore = iAddMore - 1
            
            viewSecond.isHidden = true
            btnDelete.isHidden = true
            
            UIView.animate(withDuration: 0.4, animations: {
                self.setDefault(vv: self.viewDetails)
            })
        }
    }
    
    func setDefault(vv : UIView)
    {
        viewAddMore.frame = CGRect(x: viewAddMore.frame.origin.x, y: vv.frame.origin.y + vv.frame.size.height, width: viewAddMore.frame.size.width, height: viewAddMore.frame.size.height)
        
        self.setScrollViewHeight()
    }

}
