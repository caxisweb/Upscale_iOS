//
//  FeedbackView.swift
//  Upscale
//
//  Created by INFORAAM on 06/07/17.
//  Copyright © 2017 krutik. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD
import Toaster
import ImageSlideshow
import GoogleMobileAds


class FeedbackView: BaseViewController,UITextViewDelegate,UIGestureRecognizerDelegate
{
    
    @IBOutlet var viewNavigation: UIView!

    @IBOutlet var txtFeedback: UITextView!
    
    @IBOutlet var btnSubmit: UIButton!
    @IBOutlet var lblText: UILabel!
    
    @IBOutlet var imgBanner: ImageSlideshow!

    @IBOutlet var viewGoogleAdd: GADBannerView!

    var loadingNotification : MBProgressHUD!
    var json : JSON!
    var strMessage : String!
    
//    var app = AppDelegate()

    let defaults = UserDefaults.standard
    
    var strLanguage = "English"

    var strFeedback = String()
    var lblPlaceholder : UILabel!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        if DeviceType.IS_IPHONE_X
        {
            self.viewNavigation.frame = CGRect(x:self.viewNavigation.frame.origin.x, y: self.viewNavigation.frame.origin.y, width:self.viewNavigation.frame.size.width, height:88)
            self.lblText.frame = CGRect(x:self.lblText.frame.origin.x, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height + 15, width:self.lblText.frame.size.width, height:self.lblText.frame.size.height)
            self.txtFeedback.frame = CGRect(x:self.txtFeedback.frame.origin.x, y: self.lblText.frame.origin.y + self.lblText.frame.size.height + 10, width:self.txtFeedback.frame.size.width, height:self.txtFeedback.frame.size.height)
            self.btnSubmit.frame = CGRect(x:self.btnSubmit.frame.origin.x, y: self.txtFeedback.frame.origin.y + self.txtFeedback.frame.size.height + 25, width:self.btnSubmit.frame.size.width, height:self.btnSubmit.frame.size.height)
        }
        
        self.txtFeedback.delegate = self
        
        self.lblPlaceholder = UILabel()
        self.lblPlaceholder.text = "Feedback Placeholder".localized
        self.lblPlaceholder.font = txtFeedback.font
        self.lblPlaceholder.numberOfLines = 0
        self.lblPlaceholder.textAlignment = .left
        self.view.addSubview(lblPlaceholder)
        
        self.lblPlaceholder.frame.size.width = self.txtFeedback.frame.size.width - 10
        let rectTitle = self.lblPlaceholder.text?.boundingRect(with: CGSize(width: CGFloat(self.lblPlaceholder.frame.size.width), height: CGFloat(500)), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: self.lblPlaceholder.font], context: nil)
        
        self.lblPlaceholder.frame = CGRect(x: self.txtFeedback.frame.origin.x + 5, y: self.txtFeedback.frame.origin.y + 7, width: self.txtFeedback.frame.size.width - 10, height: (rectTitle?.height)!)
        
        self.lblPlaceholder.textColor = UIColor.lightGray
        self.lblPlaceholder.isHidden = !self.txtFeedback.text.isEmpty

        self.btnSubmit.layer.cornerRadius = 3
        self.btnSubmit.clipsToBounds = true
        
        self.txtFeedback.layer.borderWidth = 1
        self.txtFeedback.layer.borderColor = UIColor.lightGray.cgColor
        
        if self.defaults.string(forKey: "selectedLanguage") != nil
        {
            self.strLanguage = (self.defaults.value(forKey: "selectedLanguage") as! String)
        }
        
        if strLanguage == "ar"
        {
            txtFeedback.textAlignment = .right
            lblText.textAlignment = .right
            lblPlaceholder.textAlignment = .right
        }
        else
        {
            txtFeedback.textAlignment = .left
            lblText.textAlignment = .left
            lblPlaceholder.textAlignment = .left
        }
        if DeviceType.IS_IPHONE_5
        {
            lblText.font = lblText.font.withSize(12)
        }
        
//        viewGoogleAdd.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        viewGoogleAdd.adUnitID = "ca-app-pub-1573732121110201/3032752443"
        viewGoogleAdd.rootViewController = self
        viewGoogleAdd.load(GADRequest())
        
        if self.app.arrSDWebImageSource.count == 0
        {
            
        }
        else
        {
            self.viewGoogleAdd.isHidden = true

            self.imgBanner.contentScaleMode = UIViewContentMode.scaleToFill//scaleAspectFill
            self.imgBanner.pageControl.isHidden = true
            self.imgBanner.slideshowInterval = 5.0
            //                                self.imgBanner.pageControl.currentPage
            self.imgBanner.pageControl.pageIndicatorTintColor = UIColor.clear
            self.imgBanner.pageControl.currentPageIndicatorTintColor = UIColor.clear
            
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
    
    //MARK:-
    @IBAction func btnBack(_ sender: Any)
    {
        self.txtFeedback.resignFirstResponder()
        self.onSlideMenuButtonPressed(sender as! UIButton)
    }

    //MARK:- TextView methods
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if(text == "\n")
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView)
    {
        lblPlaceholder.isHidden = !textView.text.isEmpty
    }
    
    //MARK:- Submit button
    @IBAction func btnSubmit(_ sender: Any)
    {
        self.txtFeedback.resignFirstResponder()
        self.strFeedback = txtFeedback.text!
        if self.strFeedback.isEmpty
        {
            Toast(text: "Enter Your Feedback").show()
        }
        else
        {
            if self.app.isConnectedToInternet()
            {
                self.InsertFeedbackAPI()
            }
            else
            {
                Toast(text: "Internet Connetion in not availble.Try Again").show()
            }
        }
    }
    
    //MARK:- Insert Feedback API
    func InsertFeedbackAPI()
    {
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: false)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading..."
        loadingNotification.dimBackground = true
        
        let parameters: Parameters = ["user_id": self.app.strUserId,
                                      "feedback":self.strFeedback]
        
        Alamofire.request("\(self.app.strBaseAPI)insert_feedback.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
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
                            
                            let VC = self.storyboard?.instantiateViewController(withIdentifier: "BookingView") as! BookingView
                            self.navigationController?.pushViewController(VC, animated: true)
//                            self.txtFeedback.text = ""
//                            self.lblPlaceholder.isHidden = !self.txtFeedback.text.isEmpty
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
