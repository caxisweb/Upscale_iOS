//
//  MenuViewController.swift
//  Itext2pay
//
//  Created by Gaurav Parmar on 04/12/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit
import SDWebImage
import Social
import SafariServices

protocol SlideMenuDelegate
{
    func slideMenuItemSelectedAtIndex(_ index : Int32)
}


class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,SFSafariViewControllerDelegate {

    /**
     *  Array to display menu options
     */
    @IBOutlet var tblMenuOptions : UITableView!
    
    /**
     *  Transparent button to hide menu
     */
    @IBOutlet var btnCloseMenuOverlay : UIButton!
    
    /**
     *  Array containing menu options
     */
    var arrayMenuOptions = [Dictionary<String,String>]()
    
    /**
     *  Menu button which was tapped to display the menu
     */
    var btnMenu : UIButton!
    
    /**
     *  Delegate of the MenuVC
     */
    var delegate : SlideMenuDelegate?
    var cell = SideMenuCell()

    var app = AppDelegate()
    var strTitle = String()
    
    let defaults = UserDefaults.standard
    var strLanguage = "English"
    var localString = String()

    var strShareURL = "https://itunes.apple.com/us/app/hive-%D9%87%D8%A7%D9%8A%DA%A4/id1206432265?ls=1&mt=8"
    
    //MARK:-
    override func viewDidLoad()
    {
        super.viewDidLoad()
        app = UIApplication.shared.delegate as! AppDelegate
        
        tblMenuOptions.tableFooterView = UIView()
        tblMenuOptions.delegate = self
        tblMenuOptions.dataSource = self
        tblMenuOptions.separatorStyle = .none
        
        let vv = UIView()
        var vv_Height = CGFloat()
        vv.backgroundColor = UIColor.init(rgb: 0xF2932C)
        if DeviceType.IS_IPHONE_X
        {
            vv_Height = 44
        }
        else
        {
            vv_Height = 20
        }
        vv.frame = CGRect(x:0, y: 0, width:self.view.frame.size.width, height:vv_Height)
        self.view.addSubview(vv)
        
        if self.defaults.string(forKey: "selectedLanguage") != nil
        {
            self.strLanguage = (self.defaults.value(forKey: "selectedLanguage") as! String)
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        updateArrayMenuOptions()
    }
    
    func updateArrayMenuOptions()
    {
        self.arrayMenuOptions.removeAll()
        
        if self.app.strUserId.isEmpty
        {
            let strHome = "Home".localized
            let strListYourSpace = "List Your Space".localized
            let strPackages = "Packages".localized
//            let strWishList = "Wish List".localized
            let strAbout = "About Us".localized
            let strFeedback = "Feedback".localized
            let strLogIn = "Login".localized
            let strSignUp = "Sign Up".localized
            let strLanguage = "Language"
            
            arrayMenuOptions.append(["title":"User Name", "icon":"Ellipse 516.png"])
            arrayMenuOptions.append(["title":strHome, "icon":"NavHome.png"])
            arrayMenuOptions.append(["title":strListYourSpace, "icon":"NavAddspace.png"])
            arrayMenuOptions.append(["title":strPackages, "icon":"NavPackage.png"])
//            arrayMenuOptions.append(["title":strWishList, "icon":"Navwish.png"])
            arrayMenuOptions.append(["title":strAbout, "icon":"NavAbout.png"])
            arrayMenuOptions.append(["title":strFeedback, "icon":"NavFeedbck.png"])
            arrayMenuOptions.append(["title":strLogIn, "icon":"NavLogin.png"])
            arrayMenuOptions.append(["title":strSignUp, "icon":"NavSignup.png"])
            arrayMenuOptions.append(["title":strLanguage, "icon":""])
        }
        else
        {
            let strHome = "Home".localized
            let strProfile = "My Profile".localized
            let strWishList = "Wish List".localized
            let strHistory = "My History".localized
            let strListYourSpace = "List Your Space".localized
            let strPackages = "Packages".localized
            let strAbout = "About Us".localized
            let strFeedback = "Feedback".localized
            let strLanguage = "Language"

            arrayMenuOptions.append(["title":"User Name", "icon":"Ellipse 516.png"])
            arrayMenuOptions.append(["title":strHome, "icon":"NavHome.png"])
            arrayMenuOptions.append(["title":strProfile, "icon":"NavProfile.png"])
            arrayMenuOptions.append(["title":strWishList, "icon":"Navwish.png"])
            arrayMenuOptions.append(["title":strHistory, "icon":"NawHistory.png"])
            arrayMenuOptions.append(["title":strListYourSpace, "icon":"NavAddspace.png"])
            arrayMenuOptions.append(["title":strPackages, "icon":"NavPackage.png"])
            arrayMenuOptions.append(["title":strAbout, "icon":"NavAbout.png"])
            arrayMenuOptions.append(["title":strFeedback, "icon":"NavFeedbck.png"])
//            arrayMenuOptions.append(["title":strSignUp, "icon":"NavSignup.png"])
            arrayMenuOptions.append(["title":strLanguage, "icon":""])
        }
        tblMenuOptions.reloadData()
    }
    
    @IBAction func onCloseMenuClick(_ button:UIButton!)
    {
        btnMenu.tag = 0
        
        if (self.delegate != nil)
        {
            var index = Int32(button.tag)
            if(button == self.btnCloseMenuOverlay)
            {
                index = -1
            }
            delegate?.slideMenuItemSelectedAtIndex(index)
        }
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
        }, completion: { (finished) -> Void in
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell : SideMenuCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell") as! SideMenuCell!
        
        if cell == nil
        {
            if indexPath.row == 0
            {
                cell = Bundle.main.loadNibNamed("SideMenuCell", owner: self, options: nil)?[0] as! SideMenuCell
                
                cell.btnLogout.addTarget(self, action: #selector(LogoutChanged), for: .touchUpInside)
                
                cell.btnLogout.setTitle("Logout".localized, for: .normal)
                cell.btnLanguage.isHidden = true
                if self.app.strUserId.isEmpty
                {
                    cell.imgProfile.isHidden = true
                    cell.btnLogout.isHidden = true
                    cell.imgLogout.isHidden = true
                    cell.lblName.isHidden = true
                }
                else
                {
                    cell.imgLogo.isHidden = true
                    cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.size.height / 2
                    cell.imgProfile.clipsToBounds = true

                    if strLanguage == "ar"
                    {
                        cell.imgLogout.frame.origin.x = 220
                    }
                    if self.app.strUserImage.hasPrefix("https:") || self.app.strUserImage.hasPrefix("http:")
                    {
                        cell.imgProfile.sd_setImage(with: URL(string: self.app.strUserImage), placeholderImage: nil)
                        print(self.app.strUserImage)
                    }
                    else
                    {
                        if !self.app.strUserImage.isEmpty
                        {
                            cell.imgProfile.sd_setImage(with: URL(string: "\(self.app.strImagePath)profile/\(self.app.strUserImage)"), placeholderImage: nil)
                            print("\(self.app.strImagePath)profile/\(self.app.strUserImage)")
                        }
                    }
                }
            }
            else if indexPath.row ==  self.arrayMenuOptions.count-1
            {
                cell = Bundle.main.loadNibNamed("SideMenuCell", owner: self, options: nil)?[2] as! SideMenuCell
                
                cell.btnEnglish.addTarget(self, action: #selector(EnglishChanged), for: .touchUpInside)
                cell.btnArabic.addTarget(self, action: #selector(ArabicChanged), for: .touchUpInside)
                
                if strLanguage == "ar"
                {
                    cell.btnEnglish.isUserInteractionEnabled = true
                    cell.btnArabic.isUserInteractionEnabled = false
                    
                    cell.btnEnglish.backgroundColor = UIColor.init(rgb: 0xD6D7D9)
                    cell.btnArabic.backgroundColor = UIColor.init(rgb: 0xF2932C)
                    
                    cell.btnEnglish.setTitleColor(UIColor.black, for: .normal)
                    cell.btnArabic.setTitleColor(UIColor.white, for: .normal)
                }
                else
                {
                    cell.btnEnglish.isUserInteractionEnabled = false
                    cell.btnArabic.isUserInteractionEnabled = true
                    
                    cell.btnEnglish.backgroundColor = UIColor.init(rgb: 0xF2932C)
                    cell.btnArabic.backgroundColor = UIColor.init(rgb: 0xD6D7D9)
                    
                    cell.btnEnglish.setTitleColor(UIColor.white, for: .normal)
                    cell.btnArabic.setTitleColor(UIColor.black, for: .normal)
                }

            }
            else
            {
                cell = Bundle.main.loadNibNamed("SideMenuCell", owner: self, options: nil)?[1] as! SideMenuCell
                cell.lblName.text = arrayMenuOptions[indexPath.row]["title"]!
                let image : UIImage = UIImage(named: arrayMenuOptions[indexPath.row]["icon"]!)!
                cell.imgSidebaar.image = image
                
                if strLanguage == "ar"
                {
                    cell.lblName.textAlignment = .right
                }
                else
                {
                    cell.lblName.textAlignment = .left
                }
                
                if !self.app.strUserId.isEmpty && indexPath.row == 3
                {
                    cell.lblCount.text = "11"
                    cell.lblCount.layer.cornerRadius = cell.lblCount.frame.size.height / 2
                    cell.lblCount.clipsToBounds = true
                    cell.lblCount.isHidden = true
                }
                else
                {
                    cell.lblCount.isHidden = true
                }
                cell.layer.backgroundColor = UIColor.clear.cgColor
                
                cell.viewDetails.layer.borderWidth = 1
                cell.viewDetails.layer.borderColor = UIColor.lightGray.cgColor
                cell.viewDetails.layer.cornerRadius = 10
                cell.viewDetails.clipsToBounds = true
            }
            
            
        }
        
        cell.selectionStyle = .none

        tblMenuOptions.rowHeight = cell.frame.size.height
        return cell
    }
    
    func LogoutChanged(sender: UIButton!)
    {
        print("Logout")
        let strTitle = "Are you sure ?".localized
        let strMessage = "You want to log out ?".localized
        
        let strCancel = "Cancel".localized
        let strLogout = "Logout".localized
        
        
        let alertController = UIAlertController(title: strTitle, message: strMessage, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: strCancel, style: .cancel) { (action:UIAlertAction!) in
            print("you have pressed the Cancel button")
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: strLogout, style: .destructive) { (action:UIAlertAction!) in
            print("you have pressed OK button")
            
            self.app.strUserId = ""
            let defaults = UserDefaults.standard
            defaults.removeObject(forKey: "user_id")
            defaults.synchronize()
            
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "BookingView") as! BookingView
            self.navigationController?.pushViewController(VC, animated: true)
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    func btnLanguageChanged(sender: UIButton!)
    {
        if strLanguage == "en"
        {
            strLanguage = "ar"
        }
        else
        {
            strLanguage = "en"
        }
        self.defaults.setValue(self.strLanguage, forKey: "selectedLanguage")
        
        if !strLanguage.isEmpty
        {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LANGUAGE_WILL_CHANGE"), object: strLanguage)
            
            let rootController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BookingView") as! BookingView
            let navigation = UINavigationController(rootViewController: rootController)
            
            UIApplication.shared.keyWindow?.rootViewController = navigation
        }
    }
    func EnglishChanged(sender: UIButton!)
    {
        localString = "en"

        strLanguage = "en"
        self.defaults.setValue(self.strLanguage, forKey: "selectedLanguage")
        self.setDetails()
    }
    
    func ArabicChanged(sender: UIButton!)
    {
        localString = "ar"
        
        strLanguage = "ar"
        self.defaults.setValue(self.strLanguage, forKey: "selectedLanguage")
        
        self.setDetails()
    }
    
    func setDetails()
    {
        self.defaults.synchronize()
        
        if !localString.isEmpty
        {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LANGUAGE_WILL_CHANGE"), object: localString)
            
            let rootController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BookingView") as! BookingView
            let navigation = UINavigationController(rootViewController: rootController)
            
            UIApplication.shared.keyWindow?.rootViewController = navigation
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.row != 0
        {
            if indexPath.row != arrayMenuOptions.count-1
            {
                let btn = UIButton(type: UIButtonType.custom)
                btn.tag = indexPath.row
                self.onCloseMenuClick(btn)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrayMenuOptions.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
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
//            VC.setInitialText(strShare)
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
//            VC.setInitialText(strShare)
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
}
