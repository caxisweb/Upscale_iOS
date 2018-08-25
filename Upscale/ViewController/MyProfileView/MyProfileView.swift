//
//  MyProfileView.swift
//  Upscale
//
//  Created by INFORAAM on 24/05/17.
//  Copyright © 2017 krutik. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD
import Toaster

class MyProfileView: BaseViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    //MARK:- Outlet
    @IBOutlet var viewNavigation: UIView!

    @IBOutlet var viewDetails: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet var txtName: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtMobile: UITextField!

    
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var lblMobile: UILabel!
    
    @IBOutlet var btnUpdate: UIButton!
    
    var loadingNotification : MBProgressHUD!
    var json : JSON!
    var strMessage : String!
    
    var picker = UIImagePickerController()

    var strName = String()
    var strEmail = String()
    var strMobile = String()

    let defaults = UserDefaults.standard
    var strLanguage = "English"
    
    //MARK:-
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true

        if DeviceType.IS_IPHONE_X
        {
            self.viewNavigation.frame = CGRect(x:self.viewNavigation.frame.origin.x, y: self.viewNavigation.frame.origin.y, width:self.viewNavigation.frame.size.width, height:88)
            self.viewDetails.frame = CGRect(x:self.viewDetails.frame.origin.x, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height, width:self.viewDetails.frame.size.width, height:self.view.frame.size.height -  self.viewNavigation.frame.size.height)
        }
        
        if self.app.strUserImage.hasPrefix("https:") || self.app.strUserImage.hasPrefix("http:")
        {
            self.imgProfile.sd_setImage(with: URL(string: self.app.strUserImage), placeholderImage: nil)
        }
        else
        {
            if !self.app.strUserImage.isEmpty
            {
                self.imgProfile.sd_setImage(with: URL(string: "\(self.app.strImagePath)profile/\(self.app.strUserImage)"), placeholderImage: nil)
            }
        }

        self.txtName.text = self.app.strName
        self.txtEmail.text = self.app.strEmail
        self.txtMobile.text = self.app.strNumber

        imgProfile.layer.borderWidth = 1
        imgProfile.layer.borderColor = UIColor.init(rgb: 0xF2932C).cgColor

        imgProfile.layer.cornerRadius = imgProfile.frame.size.height / 2
        imgProfile.clipsToBounds = true
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        imgProfile.addGestureRecognizer(tap)
        imgProfile.isUserInteractionEnabled = true
        
        self.picker.delegate = self
        
        if self.defaults.string(forKey: "selectedLanguage") != nil
        {
            self.strLanguage = (self.defaults.value(forKey: "selectedLanguage") as! String)
        }
        
        self.TextFieldDesign(txt: txtName)
        self.TextFieldDesign(txt: txtEmail)
        self.TextFieldDesign(txt: txtMobile)

    }
    
    func TextFieldDesign(txt : UITextField)
    {
        txt.delegate = self
        txt.layer.borderWidth = 1
        txt.layer.borderColor = UIColor.darkGray.cgColor
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
        textField.resignFirstResponder()
        return true
    }
    
    func handleTap(_ sender: UITapGestureRecognizer)
    {
        let alertController = UIAlertController(title: "Add Photo!", message: nil, preferredStyle: .actionSheet)
        let ok = UIAlertAction(title: "Take Photo", style: .default, handler: { (action) -> Void in
            self.openCamera()
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            print("Cancel Button Pressed")
        })
        let  delete = UIAlertAction(title: "Choose from Gallery", style: .default) { (action) -> Void in
            self.openGallary()
        }
        
        alertController.addAction(ok)
        alertController.addAction(cancel)
        alertController.addAction(delete)
        
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK:- Image Picker
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
            present(picker, animated: true, completion: nil)
        }
        else
        {
            self.openGallary()
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
        
        picker .dismiss(animated: true, completion: nil)
        self.imgProfile.image = imageSelected
        self.UploadImageAPI(img: imageSelected!)
    }

    @IBAction func btnMenu(_ sender: Any)
    {
        self.onSlideMenuButtonPressed(sender as! UIButton)
    }
    
    @IBAction func btnUpdateProfile(_ sender: Any)
    {
        txtName.resignFirstResponder()
        txtName.resignFirstResponder()
        txtName.resignFirstResponder()
        
        strName = txtName.text!
        strEmail = txtEmail.text!
        strMobile = txtMobile.text!
        
        if strName.isEmpty
        {
            Toast(text: "Please Enter Name").show()
        }
        else if strEmail.isEmpty
        {
            Toast(text: "Please Enter Email").show()
        }
        else if strEmail.isValidEmail() == false
        {
            Toast(text: "Please Enter Valid Email").show()
        }
        else if strMobile.isEmpty
        {
            Toast(text: "Please Enter Mobile").show()
        }
        else
        {
            if self.app.isConnectedToInternet()
            {
                self.UpdateProfileAPI()
            }
            else
            {
                Toast(text: "Internet Connetion in not availble.Try Again").show()
            }
        }
    }
    
    func UploadImageAPI(img : UIImage)
    {
        self.loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: false)
        self.loadingNotification.mode = MBProgressHUDMode.indeterminate
        self.loadingNotification.label.text = "Loading..."
        self.loadingNotification.dimBackground = true
        
        //        let parameters : Parameters = ["mer_id":self.app.strMerId]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if let imageData = UIImageJPEGRepresentation(img, 0.5)
            {
                let format = DateFormatter()
                format.dateFormat="yyyy-MM-dd-HH-mm-ss"
                let currentFileName: String = "IMG-\(format.string(from: Date())).jpeg"
                
                multipartFormData.append(imageData, withName: "file", fileName: currentFileName, mimeType: "image/jpeg")
                multipartFormData.append(self.app.strUserId.data(using: .utf8)!, withName: "user_id")
            }
            
        }, to: "\(self.app.strBaseAPI)update_profile_image.php", encodingCompletion: { response in
            switch response {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    
                    debugPrint("SUCCESS RESPONSE:- \(response)")
                    self.loadingNotification.hide(animated: true)
                    
                    if let value = response.result.value
                    {
                        self.json = JSON(value)
                        print(self.json)
                        
                        let strStatus : String = self.json["status"].stringValue
                        self.strMessage = self.json["message"].stringValue
                        
                        if strStatus == "1"
                        {
                            self.app.strUserImage = self.json["image"].stringValue
                            
                            self.defaults.setValue(self.app.strNumber, forKey: "user_image") //String
                            self.defaults.synchronize()
                            
                            Toast(text: "Profile Update Successfully!").show()
                        }
                        else
                        {
                            Toast(text: self.strMessage).show()
                        }
                    }
                    else
                    {
                        Toast(text: "Request time out.").show()
                        self.loadingNotification.hide(animated: true)
                    }
                }
            case .failure(let encodingError):
                print("ERROR RESPONSE: \(encodingError)")
                Toast(text: "Please check your internet connection.").show()
                self.loadingNotification.hide(animated: true)
            }
        })
        
    }

    //MARK:- Get All Details
    func UpdateProfileAPI()
    {
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: false)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading..."
        loadingNotification.dimBackground = true

        let parameters: Parameters = ["user_id": self.app.strUserId,
                                      "name": strName,
                                      "phone": strMobile,
                                      "email": strEmail,
                                      "new_pass": "",
                                      "re_pass": "",
                                      "user_type": "",
                                      "city": ""]
        
        print(JSON(parameters))

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
                            self.app.strName = self.strName
                            self.app.strEmail = self.strEmail
                            self.app.strNumber = self.strMobile

                            self.defaults.setValue(self.app.strName, forKey: "user_name") //String
                            self.defaults.setValue(self.app.strEmail, forKey: "user_email") //String
                            self.defaults.setValue(self.app.strNumber, forKey: "user_mobile") //String
                            self.defaults.synchronize()
                            
                            Toast(text: "Profile Update Successfully!").show()
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
