//
//  TermsView.swift
//  Upscale
//
//  Created by INFORAAM on 12/05/17.
//  Copyright © 2017 krutik. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD
import Toaster

class TermsView: UIViewController,UIWebViewDelegate
{

    @IBOutlet weak var txtTerms: UITextView!
    @IBOutlet weak var webView: UIWebView!
    
    var loadingNotification : MBProgressHUD!
    var json : JSON!
    var strMessage : String!
    
    var app = AppDelegate()

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        app = UIApplication.shared.delegate as! AppDelegate
        self.navigationController?.isNavigationBarHidden = true

//        if self.app.isConnectedToInternet()
//        {
//            loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: false)
//            loadingNotification.mode = MBProgressHUDMode.indeterminate
//            loadingNotification.label.text = "Loading..."
//            loadingNotification.dimBackground = true
//        }
//        else
//        {
//            Toast(text: "Internet Connetion in not availble.Try Again").show()
//        }
//        
//
//        webView.delegate = self
//        let url = URL (string: self.app.strBaseTerms)
//        let requestObj = URLRequest(url: url!)
//        webView.loadRequest(requestObj)
        
        let strTerms : String = "Terms".localized
        let strTerms2 : String = "Terms2".localized
        let strTerms3 : String = "Terms3".localized
        
        txtTerms.text = strTerms + "\n\n" + strTerms2 + "\n\n" + strTerms3

    }
    
//    func webViewDidStartLoad(_ webView: UIWebView)
//    {
//        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: false)
//        loadingNotification.mode = MBProgressHUDMode.indeterminate
//        loadingNotification.label.text = "Loading..."
//        loadingNotification.dimBackground = true
//    }
    
//    func webViewDidFinishLoad(_ webView: UIWebView)
//    {
//        self.loadingNotification.hide(animated: true)
//    }
    
    

    @IBAction func btnBack(_ sender: Any)
    {
        if let navController = self.navigationController
        {
            navController.popViewController(animated: true)
        }
    }
    
    
}
