//
//  WebView.swift
//  Upscale
//
//  Created by Code Clinic on 12/01/18.
//  Copyright © 2018 krutik. All rights reserved.
//

import UIKit

class WebView: UIViewController,UIWebViewDelegate
{
    //MARK:- Outlet
    
    @IBOutlet var webView: UIWebView!
    
    var strURL = String()
    
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
    
    var strBookingType = String()
    var strBookingID = String()
    
    
    var app = AppDelegate()
    
    var repeatCount = Int()
    var strDayType = String()
    var iDayType = Int()
    var strEndDate = String()
    
    var strPromoCodeID = String()
    var strPromoPrice = String()
    var strPromoDiscount = String()
    var strEsaarProductID = String()
    
    //MARK:-
    override func viewDidLoad()
    {
        super.viewDidLoad()
        app = UIApplication.shared.delegate as! AppDelegate
        self.navigationController?.isNavigationBarHidden = true

        strURL = "https://is.gd/Mug4CW"
        
        webView.delegate = self
        if let url = URL(string: strURL)
        {
            let request = URLRequest(url: url)
            webView.loadRequest(request)
        }
        
    }

    
    @IBAction func btnBack(_ sender: Any)
    {
        if let navController = self.navigationController
        {
            navController.popViewController(animated: true)
        }
    }
    
    //MARK:- Webview Delelegate
    //http://awn.sa/esaal/home/thankyou/success
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        let strURL : String = (webView.request?.mainDocumentURL?.absoluteString)!

        if strURL == "http://awn.sa/esaal/home/thankyou/success"
        {
            
        }
        
    }
    
    
}
