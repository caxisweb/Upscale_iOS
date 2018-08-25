
//  EditProfileView.swift
//  Upscale
//
//  Created by INFORAAM on 08/05/17.
//  Copyright © 2017 krutik. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD
import Toaster
import IQDropDownTextField

class EditProfileView: BaseViewController,UITextFieldDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,IQDropDownTextFieldDataSource,IQDropDownTextFieldDelegate
{
    
    @IBOutlet var scrollView: UIScrollView!

    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblExpertise: UILabel!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var lblMobile: UILabel!
    @IBOutlet var lblCt: UILabel!
    @IBOutlet var lblNewPassword: UILabel!
    @IBOutlet var lblRepPassword: UILabel!
    
    
    
    
    
    @IBOutlet var txtName: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtMobile: UITextField!
    @IBOutlet var txtNewPassword: UITextField!
    @IBOutlet var txtRepPassword: UITextField!
    
    @IBOutlet var btnUpdate: UIButton!
    
    @IBOutlet var txtArea: IQDropDownTextField!
    @IBOutlet var txtCity: IQDropDownTextField!

    
    var loadingNotification : MBProgressHUD!
    var json : JSON!
    var strMessage : String!
    
//    var app = AppDelegate()
    
    var strArea = String()
    var strCity = String()
    
    var picker = UIImagePickerController()
    let defaults = UserDefaults.standard
    var strLanguage = "English"

    var arrArea = ["IT",
                   "HR",
                   "Finance",
                   "Marketing",
                   "Legal",
                   "Sales",
                   "Business",
                   "HR",
                   "Startup",
                   "Digital Media",
                   "Branding & UX",
                   "Other"]
    
    //MARK:-
    //MARK:-
    override func viewDidLoad()
    {
        super.viewDidLoad()
//        app = UIApplication.shared.delegate as! AppDelegate
        self.navigationController?.isNavigationBarHidden = true

        if self.defaults.string(forKey: "selectedLanguage") != nil
        {
            self.strLanguage = (self.defaults.value(forKey: "selectedLanguage") as! String)
        }
        
//        if strLanguage == "ar"
//        {
//            txtName.textAlignment = .right
//            txtEmail.textAlignment = .right
//            txtMobile.textAlignment = .right
//            txtNewPassword.textAlignment = .right
//            txtRepPassword.textAlignment = .right
//            
//            lblName.textAlignment = .right
//            lblExpertise.textAlignment = .right
//            lblEmail.textAlignment = .right
//            lblMobile.textAlignment = .right
//            lblCt.textAlignment = .right
//            lblNewPassword.textAlignment = .right
//            lblRepPassword.textAlignment = .right
//        }
//        else
//        {
//            lblName.textAlignment = .left
//            lblExpertise.textAlignment = .left
//            lblEmail.textAlignment = .left
//            lblMobile.textAlignment = .left
//            lblCt.textAlignment = .left
//            lblNewPassword.textAlignment = .left
//            lblRepPassword.textAlignment = .left
//        }
        
        self.textfieldValidation(txt: txtName)
        self.textfieldValidation(txt: txtEmail)
        self.textfieldValidation(txt: txtMobile)
        self.textfieldValidation(txt: txtNewPassword)
        self.textfieldValidation(txt: txtRepPassword)
        
        btnUpdate.layer.cornerRadius = btnUpdate.frame.size.height / 2
        
        if self.app.isConnectedToInternet()
        {
//            self.getAllDetailsAPI()
        }
        else
        {
            Toast(text: "Internet Connetion in not availble.Try Again").show()
        }
        
        self.txtArea.delegate = self
        self.txtArea.dataSource = self
        self.txtArea.layer.cornerRadius = 1
        self.txtArea.layer.borderWidth = 1
        self.txtArea.layer.borderColor = UIColor.lightGray.cgColor
        self.txtArea.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        self.txtArea.isOptionalDropDown = false
        self.txtArea.itemList = arrArea
        
        self.txtCity.delegate = self
        self.txtCity.dataSource = self
        self.txtCity.layer.cornerRadius = 1
        self.txtCity.layer.borderWidth = 1
        self.txtCity.layer.borderColor = UIColor.lightGray.cgColor
        self.txtCity.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        self.txtCity.isOptionalDropDown = false
        self.txtCity.itemList = ["Riyadh",
                                 "Jeddah",
                                 "Dammam",
                                 "Makkah",
                                 "Medina",
                                 "Qassim"]

//        self.txtCity.setSelectedRow(2, animated: true)
        self.txtCity.setSelectedItem("Qassim", animated: true)
        self.setScrollviewForLastView()
    }
    
    func setScrollviewForLastView()
    {
        for viewAll: UIView in scrollView.subviews
        {
            if viewAll.tag == 100
            {
                scrollView.contentSize = CGSize(width: CGFloat(scrollView.frame.size.width), height: CGFloat(viewAll.frame.origin.y + viewAll.frame.size.height + 10))
            }
        }
    }
    
    func textfieldValidation(txt : UITextField)
    {
        txt.delegate = self
        txt.layer.borderWidth = 1
        txt.layer.borderColor = UIColor.lightGray.cgColor
        if strLanguage != "ar"
        {
            txt.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
        }
        
        txt.layer.cornerRadius = 3
    }
    
    @IBAction func btnBack(_ sender: Any)
    {
        if let navController = self.navigationController
        {
            navController.popViewController(animated: true)
        }
//        self.onSlideMenuButtonPressed(sender as! UIButton)
    }
    
    
    //MARK:- Get All Details
    func getAllDetailsAPI()
    {
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: false)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading..."
        loadingNotification.dimBackground = true
                
        let parameters: Parameters = ["user_id": self.app.strUserId]
        
        Alamofire.request("\(self.app.strBaseAPI)my_profile.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
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
                            self.txtName.text = self.json["name"].stringValue
                            self.txtEmail.text = self.json["email"].stringValue
                            self.txtMobile.text = self.json["phone"].stringValue
                            
                            let strType : String = self.json["user_type"].stringValue
                            let strCITY : String = self.json["user_city"].stringValue
                            
                            let strImage : String = self.json["image"].stringValue
                            
                            if strType.isEmpty || strType == "select"
                            {
                                self.strArea = "select"
                            }
                            else
                            {
                                self.strArea = strType
                            }
//                            self.lblArea.text = self.strArea
                            
                            if strCITY.isEmpty || strCITY == "select"
                            {
                                self.strCity = "select"
                            }
                            else
                            {
                                self.strCity = strCITY
                            }
//                            self.lblCity.text = self.strCity
                            
//                            if strImage.hasPrefix("https:") || strImage.hasPrefix("http:")
//                            {
//                                self.imgProfile.sd_setImage(with: URL(string: strImage), placeholderImage: nil)
//                            }
//                            else
//                            {
//                                if !strImage.isEmpty
//                                {
//                                    let escapedString : String = strImage.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
//                                    print(escapedString)
//
//                                    let strFullImage : String = "\(self.app.strImagePath)profile/\(escapedString)"
//
//                                    self.imgProfile.sd_setImage(with: URL(string: strFullImage), placeholderImage: nil)
//                                }
//                            }
//                            self.imgProfile.layer.borderWidth = 1
//                            self.imgProfile.layer.borderColor = self.app.UIColorFromRGB(rgbValue: 0xE9983E).cgColor

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
    
    @IBAction func btnCancel(_ sender: Any)
    {
        self.popToViewController()
    }
    
    @IBAction func btnSave(_ sender: Any)
    {
        txtName.resignFirstResponder()
        txtEmail.resignFirstResponder()
        txtMobile.resignFirstResponder()
        txtNewPassword.resignFirstResponder()
        txtRepPassword.resignFirstResponder()
        
        if (txtName.text?.isEmpty)!
        {
            Toast(text: "Please Enter Name").show()
        }
        else if strArea == "select"
        {
            Toast(text: "Please Select Area of Expertise").show()
        }
        else if (txtEmail.text?.isEmpty)!
        {
            Toast(text: "Please Enter Email").show()
        }
        else if (txtMobile.text?.isEmpty)!
        {
            Toast(text: "Please Enter Mobile Number").show()
        }
        else if strCity == "select"
        {
            Toast(text: "Please Select City").show()
        }
        else if !(txtNewPassword.text?.isEmpty)!
        {
            if (txtRepPassword.text?.isEmpty)!
            {
                Toast(text: "Please Re-Enter Password").show()
            }
            else
            {
                if txtNewPassword.text == txtRepPassword.text
                {
                    print("Success")
                    self.updateDetails()
                }
                else
                {
                    Toast(text: "Password not match.").show()
                }
            }
        }
        else if !(txtRepPassword.text?.isEmpty)!
        {
            if (txtNewPassword.text?.isEmpty)!
            {
                Toast(text: "Please Enter New Password").show()
            }
            else
            {
                if txtNewPassword.text == txtRepPassword.text
                {
                    print("Success")
                    self.updateDetails()
                }
                else
                {
                    Toast(text: "Password not match.").show()
                }
            }
        }
        else
        {
            self.updateDetails()
        }
    }
    
    func updateDetails()
    {
        if self.app.isConnectedToInternet()
        {
            self.UpdateProfileDetailsAPI()
        }
        else
        {
            Toast(text: "Internet Connetion in not availble.Try Again").show()
        }
    }
    
    //MARK:- Update Profile Details API
    func UpdateProfileDetailsAPI()
    {
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: false)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading..."
        loadingNotification.dimBackground = true
        
        //{"user_id":"1","name": "Jaydeep Bhatt","phone":"0987654321","email":"jaydeep.wwe@gmail.com"}
        
        let strName : String = txtName.text!
        let strEmail : String = txtEmail.text!
        let strNumber : String = txtMobile.text!
        let strPassword : String = txtNewPassword.text!
        let strRePassword : String = txtRepPassword.text!
        
        let parameters: Parameters = ["user_id": self.app.strUserId,
                                      "name":strName,
                                      "email":strEmail,
                                      "phone":strNumber,
                                      "new_pass":strPassword,
                                      "re_pass":strRePassword,
                                      "user_type":strArea,
                                      "city":strCity]
        print(parameters)
        
        Alamofire.request("\(self.app.strBaseAPI)update_profile.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
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
                            self.app.strName = strName
                            self.app.strEmail = strEmail
                            self.app.strNumber = strNumber
                            
                            self.defaults.setValue(self.app.strName, forKey: "user_name") //String
                            self.defaults.setValue(self.app.strEmail, forKey: "user_email") //String
                            self.defaults.setValue(self.app.strNumber, forKey: "user_mobile") //String

                            self.defaults.synchronize()

                            Toast(text: "Successfully Updated!").show()
                            self.popToViewController()
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
    
    //MARK:- Update Profile Pic API

    func UploadImageAPI(img : UIImage)
    {
        self.loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: false)
        self.loadingNotification.mode = MBProgressHUDMode.indeterminate
        self.loadingNotification.label.text = "Loading..."
        self.loadingNotification.dimBackground = true
        
        let parameters = ["user_id": self.app.strUserId]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if let imageData = UIImageJPEGRepresentation(img, 0.1)
            {
                multipartFormData.append(imageData, withName: "file", fileName: "file.png", mimeType: "image/png")
            }
            for (key, value) in parameters
            {
                multipartFormData.append((value.data(using: .utf8))!, withName: key)
            }
        }, to: "\(self.app.strBaseAPI)update_profile_image.php", encodingCompletion: { response in
            switch response {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    
                    //  debugPrint("SUCCESS RESPONSE:- \(response)")
                    
                    if let value = response.result.value
                    {
                        self.loadingNotification.hide(animated: true)
                        self.json = JSON(value)
                        print(self.json)
                        
                        let strStatus : String = self.json["status"].stringValue
                        let strMsg : String = self.json["message"].stringValue
                        
                        if strStatus == "1"
                        {
                            let strImage : String = self.json["image"].stringValue
                            self.app.strUserImage = strImage.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
                            
                            UserDefaults.standard.set(self.app.strUserImage, forKey: "user_image")
                            
                            UserDefaults.standard.synchronize()
                            
                            let VC = self.storyboard?.instantiateViewController(withIdentifier: "BookingView") as! BookingView
                            self.navigationController?.pushViewController(VC, animated: true)
                            
                            Toast(text: "Successfully Updated!").show()
                        }
                        else
                        {
                            Toast(text: strMsg).show()
                        }
                    }
                }
            case .failure(let encodingError):
                print("ERROR RESPONSE: \(encodingError)")
                self.loadingNotification.hide(animated: true)
                Toast(text: "Please Check your Internet Connection.").show()
            }
        })
    }

    func popToViewController()
    {
        if let navController = self.navigationController
        {
            navController.popViewController(animated: true)
        }
    }
    
    //MARK:- Textfield Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField .resignFirstResponder()
        
        return true
    }
}
