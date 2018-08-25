//
//  ForgotView.swift
//  Upscale
//
//  Created by Developer on 15/04/17.
//  Copyright © 2017 krutik. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD
import Toaster

class ForgotView: UIViewController,UITextFieldDelegate
{
    //MARk:-
    
    @IBOutlet var viewForgot: UIView!
    @IBOutlet var viewTitle: UIView!
    
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var btnSend: UIButton!
    
    @IBOutlet var viewChangePassword: UIView!
    @IBOutlet var viewPasswordTitle: UIView!
    
    @IBOutlet var txtOTP: UITextField!
    @IBOutlet var txtNew: UITextField!
    @IBOutlet var txtConfirm: UITextField!
    @IBOutlet var btnReset: UIButton!

    @IBOutlet var lblForgotPassword: UILabel!
    
    @IBOutlet var lblChangePassword: UILabel!
    
    
    
    
    var loadingNotification : MBProgressHUD!
    var json : JSON!
    var strMessage : String!
    
    var app = AppDelegate()
    
    var strUserID = String()
    
    let defaults = UserDefaults.standard
    
    var strLanguage = "English"

    
    //MARk:-
    override func viewDidLoad()
    {
        super.viewDidLoad()
        app = UIApplication.shared.delegate as! AppDelegate
        
        self.viewForgot.layer.cornerRadius = 15
        
        if self.defaults.string(forKey: "selectedLanguage") != nil
        {
            self.strLanguage = (self.defaults.value(forKey: "selectedLanguage") as! String)
        }
        if strLanguage == "ar"
        {
            txtEmail.textAlignment = .right
            
            txtOTP.textAlignment = .right
            txtNew.textAlignment = .right
            txtConfirm.textAlignment = .right
        }
    
        self.textfiledDesign(txt: txtEmail)

        btnSend.layer.cornerRadius = 5
        
        //View Chnage Password
        self.viewChangePassword.layer.cornerRadius = 15

        self.viewChangePassword.isHidden = true
        
        self.textfiledDesign(txt: txtOTP)
        self.textfiledDesign(txt: txtNew)
        self.textfiledDesign(txt: txtConfirm)

        btnReset.layer.cornerRadius = 5
        
        viewTitle.clipsToBounds = true
        viewPasswordTitle.clipsToBounds = true
        
        self.viewTitle.layer.cornerRadius = 15
        self.viewPasswordTitle.layer.cornerRadius = 15

        lblForgotPassword.text = "Forgot Password ?".localized
        txtEmail.placeholder = "Enter Your E-mail".localized
        let strSend = "Send".localized
        btnSend.setTitle(strSend, for: .normal)
        
        lblChangePassword.text = "Change Password".localized
        txtOTP.placeholder = "OTP".localized
        txtNew.placeholder = "New Password".localized
        txtConfirm.placeholder = "Re-type New Password".localized
        let strReSet = "RESET".localized
        btnReset.setTitle(strReSet, for: .normal)

    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField .resignFirstResponder()
        return true
    }
    
    func viewCornerRadiation(vv : UIView)
    {
        let path = UIBezierPath(roundedRect:vv.bounds,
                                byRoundingCorners:[.topRight, .topLeft],
                                cornerRadii: CGSize(width: 15, height:  15))
        
        let maskLayer = CAShapeLayer()
        
        maskLayer.path = path.cgPath
        vv.layer.mask = maskLayer
    }
    
    func textfiledDesign(txt : UITextField)
    {
        if strLanguage != "ar"
        {
            txt.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        }
        txt.layer.borderWidth = 1
        txt.layer.borderColor = UIColor.lightGray.cgColor
        txt.clipsToBounds = true
        txt.delegate = self
        
        txt.attributedPlaceholder = NSAttributedString(string: txt.placeholder!,
                                                       attributes: [NSAttributedStringKey.foregroundColor: UIColor.darkGray])
    }

    @IBAction func btnCancel(_ sender: Any)
    {
        self.view.removeFromSuperview()
    }
    
    @IBAction func btnSend(_ sender: Any)
    {
        txtEmail.resignFirstResponder()
        
        if (txtEmail.text?.isEmpty)!
        {
            Toast(text: "Please Enter Email").show()
        }
        else
        {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            
            if emailTest.evaluate(with: txtEmail.text)
            {
                if self.app.isConnectedToInternet()
                {
                    if self.app.isConnectedToInternet()
                    {
                        self.forgotPasswrodAPI()
                    }
                    else
                    {
                        Toast(text: "Internet Connetion in not availble.Try Again").show()
                    }
                }
                else
                {
                    Toast(text: "Internet Connetion in not availble.Try Again").show()
                }
            }
            else
            {
                Toast(text: "Please Enter Valid Email.").show()
            }
        }
    }
    
    
    
    //MARK:- View Change Password
    
    @IBAction func btnReset(_ sender: Any)
    {
        txtOTP.resignFirstResponder()
        txtNew.resignFirstResponder()
        txtConfirm.resignFirstResponder()

        if (txtOTP.text?.isEmpty)!
        {
            Toast(text: "Please Enter OTP").show()
        }
        else if (txtNew.text?.isEmpty)!
        {
            Toast(text: "Please Enter New Password").show()
        }
        else if (txtConfirm.text?.isEmpty)!
        {
            Toast(text: "Please Enter Re-Type New Password").show()
        }
        else
        {
            if txtNew.text == txtConfirm.text
            {
                if self.app.isConnectedToInternet()
                {
                    self.changePasswordAPI()
                }
                else
                {
                    Toast(text: "Internet Connetion in not availble.Try Again").show()
                }
            }
            else
            {
                Toast(text: "Password doesn't Match").show()
            }
        }
    }
    
    
    //MARK:- Forgot Password
    func forgotPasswrodAPI()
    {
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: false)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading..."
        loadingNotification.dimBackground = true
        
        let strEmail : String = txtEmail.text!
        
        
        let parameters: Parameters = ["email": strEmail]
        
        Alamofire.request("\(self.app.strBaseAPI)forgot_password.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
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
                            
                            self.strUserID = self.json["user_id"].stringValue
                            self.viewForgot.isHidden = true
                            self.viewChangePassword.isHidden = false
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
   
    //MARK:- Change Password
    func changePasswordAPI()
    {
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: false)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading..."
        loadingNotification.dimBackground = true
        
        let strOTP : String = txtOTP.text!
        let strPassword : String = txtNew.text!
        
        
        let parameters: Parameters = ["user_id": self.strUserID,
                                      "otp":strOTP,
                                      "password":strPassword]
        
        Alamofire.request("\(self.app.strBaseAPI)reset_password.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
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
                            self.view.removeFromSuperview()
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

}
