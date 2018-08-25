//
//  SuccessView.swift
//  Upscale
//
//  Created by Developer on 27/04/17.
//  Copyright © 2017 krutik. All rights reserved.
//

import UIKit
import SafariServices
import Social
import ImageSlideshow
import GoogleMobileAds

class SuccessView: BaseViewController,SFSafariViewControllerDelegate,UIGestureRecognizerDelegate
{

    //MARK:-
    @IBOutlet var viewNavigation: UIView!

    @IBOutlet var lblRefNumber: UILabel!
    
    @IBOutlet var btnInvitations: UIButton!
    
    @IBOutlet var lblSharingWith: UILabel!
    
    @IBOutlet var imgBanner: ImageSlideshow!

    @IBOutlet var viewGoogleAdd: GADBannerView!

    var strReferenceNo = String()
    var strShare = String()
    
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

    var strShareURL = "https://itunes.apple.com/us/app/hive-%D9%87%D8%A7%D9%8A%DA%A4/id1206432265?ls=1&mt=8"

    var arrSDWebImageSource : [SDWebImageSource] = []

    //MARK:- 
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        if DeviceType.IS_IPHONE_X
        {
            self.viewNavigation.frame = CGRect(x:self.viewNavigation.frame.origin.x, y: self.viewNavigation.frame.origin.y, width:self.viewNavigation.frame.size.width, height:88)
        }
        
        lblRefNumber.text = strReferenceNo
        
        lblRefNumber.layer.cornerRadius = 4
        lblRefNumber.clipsToBounds = true
        
        btnInvitations.layer.cornerRadius = 4
        
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
    
    @IBAction func btnMenu(_ sender: Any)
    {
        let desiredViewController = self.navigationController!.viewControllers.filter { $0 is BookingView }.first!
        self.navigationController!.popToViewController(desiredViewController, animated: true)
    }
    
    @IBAction func btnInvitations(_ sender: Any)
    {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "InvitationsView") as! InvitationsView
        VC.strName = self.strName
        VC.strCapacity = self.strCapacity
        VC.strLocation = self.strLocation
        VC.strPrice = self.strPrice
        VC.arrSDWebImageSource = self.arrSDWebImageSource
        VC.strBookingID = self.strBookingID

        self.navigationController?.pushViewController(VC, animated: true)

//        let VC = self.storyboard?.instantiateViewController(withIdentifier: "InvitationsView") as! InvitationsView
//        VC.strCapacity = self.strCapacity
//        VC.strBookingID = strBookingID
//        VC.spaceID = self.spaceID
//        VC.strDate = self.strDate
//        VC.strFromTime = self.strFromTime
//        VC.strToTime = self.strToTime
//        VC.repeatCount = self.repeatCount
//        VC.strTotalPrice = self.strTotalPrice
//        VC.strPaymentType = self.strPaymentType
//        VC.strPrice = self.strPrice
//        VC.strTimeDeff = self.strTimeDeff
//        VC.strName = self.strName
//        VC.strLocation = self.strLocation
//        self.navigationController?.pushViewController(VC, animated: true)
//        let desiredViewController = self.navigationController!.viewControllers.filter { $0 is BookingView }.first!
//        self.navigationController!.popToViewController(desiredViewController, animated: true)
    }
    
    @IBAction func btnAllAction(_ sender: UIButton)
    {
        if sender.tag == 1
        {
            self.FBShare()
        }
        else if sender.tag == 2
        {
            self.LinkedINShare()
        }
        else if sender.tag == 3
        {
            self.TwitterShare()
        }
        else if sender.tag == 4
        {
            self.GooglePlusShare()
        }
    }
    
    //MARK:- FB Share
    func FBShare()
    {
        let isInstalled : Bool = UIApplication.shared.canOpenURL(URL(string: "fb://")!)
        if isInstalled
        {
            let VC : SLComposeViewController = SLComposeViewController(forServiceType:SLServiceTypeFacebook)
            VC.add(URL(string: strShareURL))
            self.present(VC, animated: true, completion: nil)
        }
        else
        {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK:- Twitter Share
    func TwitterShare()
    {
        let isInstalled : Bool = UIApplication.shared.canOpenURL(URL(string: "twitter://")!)
        if isInstalled
        {
            let VC : SLComposeViewController = SLComposeViewController(forServiceType:SLServiceTypeTwitter)
            VC.add(URL(string: strShareURL))
            self.present(VC, animated: true, completion: nil)
        }
        else
        {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to share.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK:- Google Share
    func GooglePlusShare()
    {
        let urlComponents: NSURLComponents = NSURLComponents(string: "https://plus.google.com/share")!
        
        urlComponents.queryItems = [NSURLQueryItem(name: "url", value:strShareURL) as URLQueryItem]
        
        if let url = urlComponents.url
        {
            if #available(iOS 9.0, *)
            {
                let controller: SFSafariViewController = SFSafariViewController(url: url)
                controller.delegate = self
                self.present(controller, animated: true, completion: nil)
            }
            else
            {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    //MARK:- LinkedIn Share
    func LinkedINShare()
    {
        let url = URL(string: "https://www.linkedin.com/sharing/share-offsite?mini=true&url=\(strShareURL)&title=Hive&source=LinkedIn")!
        if #available(iOS 10.0, *)
        {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        else
        {
            UIApplication.shared.openURL(url)
        }
    }
    
//    func FBShare()
//    {
//        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook)
//        {
//            let facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
//            facebookSheet.setInitialText(strShare)
//            self.present(facebookSheet, animated: true, completion: nil)
//        }
//        else
//        {
//            let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }
//    }
//
//    func TwitterShare()
//    {
//        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter)
//        {
//            let twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
//            twitterSheet.setInitialText(strShare)
//            self.present(twitterSheet, animated: true, completion: nil)
//        }
//        else
//        {
//            let alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to share.", preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }
//    }
//
//    func GooglePlusShare()
//    {
//        let urlComponents: NSURLComponents = NSURLComponents(string: "https://plus.google.com/share")!
//
//        urlComponents.queryItems = [NSURLQueryItem(name: "text", value:strShare) as URLQueryItem]
//
//        if let url = urlComponents.url
//        {
//            if #available(iOS 9.0, *)
//            {
//                let controller: SFSafariViewController = SFSafariViewController(url: url)
//                controller.delegate = self
//                self.present(controller, animated: true, completion: nil)
//            }
//            else
//            {
//                UIApplication.shared.openURL(url)
//            }
//        }
//    }
//
//    func DefaultsShareApp()
//    {
//        let activityViewController : UIActivityViewController = UIActivityViewController(
//            activityItems: [self.strShare], applicationActivities: nil)
//
//        // Anything you want to exclude
//        activityViewController.excludedActivityTypes = [
//            UIActivityType.postToWeibo,
//            UIActivityType.print,
//            UIActivityType.assignToContact,
//            UIActivityType.saveToCameraRoll,
//            UIActivityType.addToReadingList,
//            UIActivityType.postToFlickr,
//            UIActivityType.postToVimeo,
//            UIActivityType.postToTencentWeibo
//        ]
//
//        self.present(activityViewController, animated: true, completion: nil)
//    }

}
