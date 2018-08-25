//
//  ViewController.swift
//  Upscale
//
//  Created by Developer on 11/04/17.
//  Copyright © 2017 krutik. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD
import Toaster
import FBSDKLoginKit
import GoogleSignIn
import CoreLocation
import TwitterKit
import LinkedinSwift
import ImageSlideshow
import GoogleMobileAds

class ViewController: UIViewController,UITextFieldDelegate,GIDSignInDelegate, GIDSignInUIDelegate,CLLocationManagerDelegate,UIGestureRecognizerDelegate
{
    //MARK:-
    @IBOutlet var viewNavigation: UIView!

    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtPassword: UITextField!

//    @IBOutlet var viewEmail: UIView!
//    @IBOutlet var viewPassword: UIView!
    
    @IBOutlet var btnKeepLogin: UIButton!
    
    
    @IBOutlet var btnSignIn: UIButton!
    @IBOutlet var btnSignUp: UIButton!
    @IBOutlet var btnListPlace: UIButton!
    
    
    @IBOutlet var btnLanguage: UIButton!
//    @IBOutlet var btnArabic: UIButton!
    
    @IBOutlet var imgBanner: ImageSlideshow!

    @IBOutlet var viewGoogleAdd: GADBannerView!

    var loadingNotification : MBProgressHUD!
    var json : JSON!
    var strMessage : String!
    
    var app = AppDelegate()
    var popViewController = ForgotView()
    
    var check = Bool()

    let defaults = UserDefaults.standard

    //FB
    var strFBName = String()
    var strFBEmail = String()
    var strFBImage = String()
    var strFBID = String()
    
    //Google
    var strGoogleID = String()
    var strGoogleName = String()
    var strGooglEmail = String ()
    var strGoogleImage = String()
    
    //Twitter
    var strTwitterName = String()
    var strTwitterID = String()
    var strTwitterImageUrl = String()
    var strTwitterEmail = String()
    
    //LinkedIN
    var strLinkedinName = String()
    var strLinkedinID = String()
    var strLinkedinImageUrl = String()
    var strLinkedinEmail = String()
    
    let linkedinHelper = LinkedinSwiftHelper(configuration: LinkedinSwiftConfiguration(clientId: "77tn2ar7gq6lgv", clientSecret: "iqkDGYpWdhf7WKzA", state: "DLKDJF46ikMMZADfdfds", permissions: ["r_basicprofile", "r_emailaddress"], redirectUrl: "https://github.com/tonyli508/LinkedinSwift"))

    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    var strLanguage = "English"
    var strGotoViewcontroller = String()

    //MARK:-
    override func viewDidLoad()
    {
        super.viewDidLoad()
        app = UIApplication.shared.delegate as! AppDelegate
        self.navigationController?.isNavigationBarHidden = true
        
        if DeviceType.IS_IPHONE_X
        {
            self.viewNavigation.frame = CGRect(x:self.viewNavigation.frame.origin.x, y: self.viewNavigation.frame.origin.y, width:self.viewNavigation.frame.size.width, height:88)
            self.scrollView.frame = CGRect(x:self.scrollView.frame.origin.x, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height, width:self.scrollView.frame.size.width, height:self.view.frame.size.height - 55 -  self.viewNavigation.frame.size.height)
        }
//        if defaults.string(forKey: "Email") != nil
//        {
//            self.txtEmail.text = (defaults.value(forKey: "Email") as! String)
//            self.txtPassword.text = (defaults.value(forKey: "Password") as! String)
//            if check == (defaults.value(forKey: "check") != nil)
//            {
//                check = true
//                let image = UIImage(named: "checked.png")
//                btnKeepLogin.setImage(image, for: UIControlState.normal)
//            }
//            
//        }
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self

        if self.defaults.string(forKey: "selectedLanguage") != nil
        {
            self.strLanguage = (self.defaults.value(forKey: "selectedLanguage") as! String)
        }
        
        if strLanguage == "ar"
        {
            txtEmail.textAlignment = .right
            txtPassword.textAlignment = .right
            
//            self.btnLanguage.tag = 2
//            self.btnLanguage.setTitle("English", for: .normal)
        }
        else
        {
//            self.btnLanguage.tag = 1
//            self.btnLanguage.setTitle("Arabic", for: .normal)
        }
        self.textFieldPaddingView(txt: txtEmail)
        self.textFieldPaddingView(txt: txtPassword)
        
        self.btnCornerRadiation(btn: btnSignIn)
        self.btnCornerRadiation(btn: btnListPlace)

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
        
        self.setScrollviewForLastView()
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
    
    //MARK:- Back
    @IBAction func btnBack(_ sender: Any)
    {
        self.PopToViewController()
    }
    
    func PopToViewController()
    {
        if let navController = self.navigationController
        {
            navController.popViewController(animated: true)
        }
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
    
    func textFieldPaddingView(txt : UITextField)
    {
        txt.delegate = self
        txt.layer.borderWidth = 1
        txt.layer.borderColor = UIColor.lightGray.cgColor
        txt.attributedPlaceholder = NSAttributedString(string: txt.placeholder!,
                                                               attributes: [NSAttributedStringKey.foregroundColor: UIColor.darkGray])
        if self.strLanguage == "ar"
        {
            txt.setRightPaddingPoints(10)
        }
        else
        {
            txt.setLeftPaddingPoints(10)
        }
    }
    
    func btnCornerRadiation(btn: UIButton)
    {
        btn.layer.cornerRadius = 2
        btn.clipsToBounds = true
    }

    //MARK:- UITextField Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField .resignFirstResponder()
        return true
    }
   
    //MARK:- Forget
    @IBAction func btnForget(_ sender: Any)
    {
        let bundle = Bundle(for: ForgotView.self)
        self.popViewController = ForgotView(nibName: "ForgotView", bundle: bundle)
        self.popViewController.view.frame = self.view.frame
        self.view.addSubview(self.popViewController.view)
        self.addChildViewController(popViewController)
    }
    
    //MARK:- FB Log In Methods
    @IBAction func btnFBLogIn(_ sender: Any)
    {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.getFBUserData()
                        fbLoginManager.logOut()
                    }
                }
            }
        }
    }
    
    //MARK: - FB Button
    func getFBUserData()
    {
        if((FBSDKAccessToken.current()) != nil)
        {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil)
                {
                    if let value = result
                    {
                        let json = JSON(value)
                        print(json)
                        self.strFBID = json["id"].stringValue
                        self.strFBName = json["name"].stringValue
                        self.strFBEmail = json["email"].stringValue
                        
                        let dicImage = json["picture"].dictionaryValue
                        let dicData = dicImage["data"]?.dictionaryValue
                        self.strFBImage = (dicData?["url"]?.stringValue)!
                        
                        print("\(self.strFBName) \n\(self.strFBID) \n\(self.strFBEmail) \n\(self.strFBImage)")
                        
                        if self.app.isConnectedToInternet()
                        {
                            self.FBLoginAPI()
                        }
                        else
                        {
                            Toast(text: "Internet Connetion in not availble.Try Again").show()
                        }
                    }
                }
            })
        }
        
    }
    
    func FBLoginAPI()
    {
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: false)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading..."
        loadingNotification.dimBackground = true
        
        let parameters: Parameters = ["type_id": self.strFBID,
                                      "name": self.strFBName,
                                      "email":self.strFBEmail,
                                      "image":self.strFBImage,
                                      "type":"facebook",
                                      "ipn_id":"1"]
        
        Alamofire.request("\(self.app.strBaseAPI)social_login.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
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
                            self.app.strUserId = self.json["user_id"].stringValue
                            self.app.strName = self.json["user_name"].stringValue
                            self.app.strEmail = self.json["user_email"].stringValue
                            self.app.strNumber = self.json["user_mobile"].stringValue
                            self.app.strUserImage = self.json["user_image"].stringValue
                            self.app.strEssalID = self.json["esaal_customer_id"].stringValue

                            self.defaults.setValue(self.app.strUserId, forKey: "user_id") //String
                            self.defaults.setValue(self.app.strName, forKey: "user_name") //String
                            self.defaults.setValue(self.app.strEmail, forKey: "user_email") //String
                            self.defaults.setValue(self.app.strNumber, forKey: "user_mobile") //String
                            self.defaults.setValue(self.app.strUserImage, forKey: "user_image") //String
                            self.defaults.setValue(self.app.strEssalID, forKey: "esaal_customer_id") //String

                            self.defaults.synchronize()
                            
                            self.PopToViewController()
//                            let VC = self.storyboard?.instantiateViewController(withIdentifier: "BookingView") as! BookingView
//                            self.navigationController?.pushViewController(VC, animated: true)
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
        
    //MARK:- Google Log In Methods
    @IBAction func btnGoogleLogin(_ sender: Any)
    {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        GIDSignIn.sharedInstance().clientID = "47558154421-jelrv231d5f6lk3vqbb7hrut9ml34gbq.apps.googleusercontent.com"
        
        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/plus.login")
        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/plus.me")
        
        self.googlePLogin()
    }
    
    func googlePLogin()
    {
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self

        GIDSignIn.sharedInstance().signIn()
    }
    
    func sign(inWillDispatch signIn: GIDSignIn, error: Error?) {
        print("\(String(describing: error))")
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!)
    {
        present(viewController, animated: true) {
            
        }
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!)
    {
        dismiss(animated: true) {
            
        }
    }
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!)
    {
        if (error == nil)
        {
            strGoogleID = user.userID                  // For client-side use only!
            strGoogleName = user.profile.name
            strGooglEmail = user.profile.email
            let img = user.profile.imageURL(withDimension: 100)
            
            strGoogleImage = (img?.absoluteString)!
            
            print("Id : \(strGoogleID)")
            print("Name : \(strGoogleName)")
            print("Email : \(strGooglEmail)")
            print("Image : \(strGoogleImage)")
            
            GIDSignIn.sharedInstance().signOut()
            
            self.GoogleLoginAPI()
        }
        else
        {
            print("\(error.localizedDescription)")
        }
    }

    func GoogleLoginAPI()
    {
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: false)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading..."
        loadingNotification.dimBackground = true
        
        //        {"type":"facebook","type_id":"1","image":"abc.jpg","name":"jaydeep","email":"jaydeep.wwe@gmail.com","gcm_id":"a"}
        
        
        let parameters: Parameters = ["type_id": self.strGoogleID,
                                      "name": self.strGoogleName,
                                      "email":self.strGooglEmail,
                                      "image":self.strGoogleImage,
                                      "type":"google",
                                      "ipn_id":"1"]
        
        Alamofire.request("\(self.app.strBaseAPI)social_login.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
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
                            
                            self.app.strUserId = self.json["user_id"].stringValue
                            self.app.strName = self.json["user_name"].stringValue
                            self.app.strEmail = self.json["user_email"].stringValue
                            self.app.strNumber = self.json["user_mobile"].stringValue
                            self.app.strUserImage = self.json["user_image"].stringValue
                            self.app.strEssalID = self.json["esaal_customer_id"].stringValue

                            //
                            self.defaults.setValue(self.app.strUserId, forKey: "user_id") //String
                            self.defaults.setValue(self.app.strName, forKey: "user_name") //String
                            self.defaults.setValue(self.app.strEmail, forKey: "user_email") //String
                            self.defaults.setValue(self.app.strNumber, forKey: "user_mobile") //String
                            self.defaults.setValue(self.app.strUserImage, forKey: "user_image") //String
                            
                            self.defaults.synchronize()
                            
                            self.PopToViewController()
//                            let VC = self.storyboard?.instantiateViewController(withIdentifier: "BookingView") as! BookingView
//                            self.navigationController?.pushViewController(VC, animated: true)
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
    
    
    //MARK:- Twitter Login Methods
    @IBAction func btnTwitter(_ sender: Any)
    {
        self.getTwitterUserData()
    }
    
    func getTwitterUserData()
    {
        TWTRTwitter.sharedInstance().logIn(with: self) { (session, error) in
            if session != nil
            {
                let client = TWTRAPIClient.withCurrentUser()
                let request = client.urlRequest(withMethod: "GET", urlString: "https://api.twitter.com/1.1/account/verify_credentials.json?include_email=true", parameters: ["include_email": "true", "skip_status": "true"], error: nil)
                                
                client.sendTwitterRequest(request) { response, data, connectionError in
                    if (connectionError == nil)
                    {
                        let json : AnyObject
                        
                        do{
                            json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject] as AnyObject
                            self.json = JSON(json)
                            print("Json response: ", self.json)
                            
                            self.strTwitterName = self.json["name"].stringValue
                            self.strTwitterID = self.json["id"].stringValue
                            self.strTwitterEmail = self.json["email"].stringValue
                            self.strTwitterImageUrl = self.json["profile_image_url"].stringValue
                            
                            print("Name : ",self.strTwitterName)
                            print("Id : ",self.strTwitterID)
                            print("Email : ",self.strTwitterEmail)
                            print("Image : ",self.strTwitterImageUrl)
                            
                            self.SocialLoginAPI(strTypeId: self.strTwitterID, strName: self.strTwitterName, strEmail: self.strTwitterEmail, strImage: self.strTwitterImageUrl, strType: "twitter", strIphoneId: "1")
                            
                        } catch {
                            
                        }
                    }
                    else
                    {
                        print("Error: \(String(describing: connectionError))")
                    }
                }
                
            }
            else if let error = error
            {
                print("ERROR :- \(error.localizedDescription)")
            }
        }
        
//        TWTRTwitter.sharedInstance().logIn(withMethods: [.webBased]) { (session, error) in
//            if (session != nil)
//            {
//                print("signed in as \(session!.userName)");
//                
//                let client = TWTRAPIClient.withCurrentUser()
//                let request = client.urlRequest(withMethod: "GET",
//                                                url: "https://api.twitter.com/1.1/account/verify_credentials.json?include_email=true",
//                                                parameters: ["include_email": "true", "skip_status": "true"],
//                                                error: nil)
//                
//                client.sendTwitterRequest(request) { response, data, connectionError in
//                    if (connectionError == nil)
//                    {
//                        let json : AnyObject
//                        
//                        do{
//                            json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject] as AnyObject
//                            self.json = JSON(json)
//                            print("Json response: ", self.json)
//                            
//                            self.strTwitterName = self.json["name"].stringValue
//                            self.strTwitterID = self.json["id"].stringValue
//                            self.strTwitterEmail = self.json["email"].stringValue
//                            self.strTwitterImageUrl = self.json["profile_image_url"].stringValue
//                            
//                            print("Name : ",self.strTwitterName)
//                            print("Id : ",self.strTwitterID)
//                            print("Email : ",self.strTwitterEmail)
//                            print("Image : ",self.strTwitterImageUrl)
//                            
//                            self.SocialLoginAPI(strTypeId: self.strTwitterID, strName: self.strTwitterName, strEmail: self.strTwitterEmail, strImage: self.strTwitterImageUrl, strType: "twitter", strIphoneId: "1")
//                            
//                        } catch {
//                            
//                        }
//                    }
//                    else
//                    {
//                        print("Error: \(String(describing: connectionError))")
//                    }
//                }
//                
//            }
//            else
//            {
//                print("error: \(error!.localizedDescription)");
//            }
//        }
    }
    
    @IBAction func btnLinkedin(_ sender: Any)
    {
        linkedinHelper.authorizeSuccess({ [unowned self] (lsToken) -> Void in
            
            self.linkedinHelper.requestURL("https://api.linkedin.com/v1/people/~:(id,first-name,last-name,email-address,picture-url,picture-urls::(original),positions,date-of-birth,phone-numbers,location)?format=json", requestType: LinkedinSwiftRequestGet, success: { (response) -> Void in
                print("res :\(response)")
                
                let data =  response.jsonObject
                print("Data : \(data)")
                self.json = JSON(data)
                print(self.json)
                
                self.strLinkedinName = self.json["firstName"].stringValue
                self.strLinkedinID = self.json["id"].stringValue
                self.strLinkedinEmail = self.json["emailAddress"].stringValue
                self.strLinkedinImageUrl = self.json["pictureUrl"].stringValue
                
                if self.app.isConnectedToInternet()
                {
                    self.SocialLoginAPI(strTypeId: self.strLinkedinID, strName: self.strLinkedinName, strEmail: self.strLinkedinEmail, strImage: self.strLinkedinImageUrl, strType: "linkedin", strIphoneId: "1")
                }
                else
                {
                    Toast(text: "Internet Connetion in not availble.Try Again").show()
                }
                
            }) { [unowned self] (error) -> Void in
                
            }
            }, error: { [unowned self] (error) -> Void in
                
            }, cancel: { [unowned self] () -> Void in
                
        })
        
    }
    
    //MARK:- Login Methods
    @IBAction func btnSignIn(_ sender: Any)
    {
        txtEmail.resignFirstResponder()
        txtPassword.resignFirstResponder()
        
        if txtEmail.text == ""
        {
            Toast(text: "Please Enter Email Id").show()
        }
        else
        {
            if txtPassword.text == ""
            {
                Toast(text: "Please Enter Password").show()
            }
            else
            {
                let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
                let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
                
                if emailTest.evaluate(with: txtEmail.text)
                {
                    if self.app.isConnectedToInternet()
                    {
                        self.getLogInAPI()
                    }
                    else
                    {
                        Toast(text: "Internet Connetion in not availble.Try Again").show()
                    }
                }
                else
                {
                    Toast(text: "Please enter valid Email.").show()
                }
            }
        }
    }
    
    @IBAction func btnSignUp(_ sender: Any)
    {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "SignupView") as! SignupView
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func btnListUrPlace(_ sender: Any)
    {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ListYourPlaceView") as! ListYourPlaceView
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func btnKeepLoggedIn(_ sender: Any)
    {
        if check
        {
            let image = UIImage(named: "unchecklog.png")
            btnKeepLogin.setImage(image, for: UIControlState.normal)
            
            check = false
        }
        else
        {
            let image = UIImage(named: "checked.png")
            btnKeepLogin.setImage(image, for: UIControlState.normal)
            
            check = true
            
//            defaults.set(txtEmail.text, forKey: "Email")
//            defaults.set(txtPassword.text , forKey: "Password")
//            defaults.set(check, forKey: "check")
        }
    }
    
    //MARK:- Button switch
    @IBAction func btnChangedLanguageAction(_ sender: UIButton)
    {
        var localString = String()
        
        if sender.tag == 1
        {
            localString = "ar"
            strLanguage = "ar"
            
            self.btnLanguage.setTitle("English", for: .normal)
            sender.tag = 2
        }
        else if sender.tag == 2
        {
            localString = "en"
            strLanguage = "en"

            self.btnLanguage.setTitle("Arabic", for: .normal)
            sender.tag = 1
        }
        self.defaults.setValue(self.strLanguage, forKey: "selectedLanguage")
        self.defaults.synchronize()
        
        if !localString.isEmpty
        {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LANGUAGE_WILL_CHANGE"), object: localString)
            
            let rootController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ViewController") as! ViewController
            let navigation = UINavigationController(rootViewController: rootController)
            
            UIApplication.shared.keyWindow?.rootViewController = navigation
        }
    }
    
    //MARK:- Login API
    func getLogInAPI()
    {
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: false)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading..."
        loadingNotification.dimBackground = true
        
        let strEmail : String = txtEmail.text!
        let strPassword : String = txtPassword.text!
        
        
        let parameters: Parameters = ["email": strEmail,
                                      "password":strPassword,
                                      "ipn_id":"1"]
        
        Alamofire.request("\(self.app.strBaseAPI)login.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
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
                            self.app.strUserId = self.json["user_id"].stringValue
                            self.app.strName = self.json["user_name"].stringValue
                            self.app.strEmail = self.json["user_email"].stringValue
                            self.app.strNumber = self.json["user_mobile"].stringValue
                            self.app.strEssalID = self.json["esaal_customer_id"].stringValue

                            let strImage : String = self.json["user_image"].stringValue
                            self.app.strUserImage = strImage.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
                            
                            print(self.app.strUserImage)
                            
                            self.defaults.setValue(self.app.strUserId, forKey: "user_id") //String
                            self.defaults.setValue(self.app.strName, forKey: "user_name") //String
                            self.defaults.setValue(self.app.strEmail, forKey: "user_email") //String
                            self.defaults.setValue(self.app.strNumber, forKey: "user_mobile") //String
                            self.defaults.setValue(self.app.strUserImage, forKey: "user_image") //String
                            self.defaults.setValue(self.app.strEssalID, forKey: "esaal_customer_id") //String

                            self.defaults.synchronize()
                            
                            self.PopToViewController()
//                            let VC = self.storyboard?.instantiateViewController(withIdentifier: "BookingView") as! BookingView
//                            self.navigationController?.pushViewController(VC, animated: true)
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
    
//    //MARK:- Button switch
//    @IBAction func btnChangedLanguageAction(_ sender: Any)
//    {
//        
//        var localString = String()
//
//        
//        if btnEnglish.isTouchInside == true
//        {
//            localString = "en"
//            
//            strLanguage = "en"
//            self.defaults.setValue(self.strLanguage, forKey: "selectedLanguage")
//        }
//        else if btnArabic.isTouchInside == true
//        {
//            localString = "ar"
//            
//            strLanguage = "ar"
//            self.defaults.setValue(self.strLanguage, forKey: "selectedLanguage")
//        }
//        
//        self.defaults.synchronize()
//        
//        if !localString.isEmpty
//        {
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LANGUAGE_WILL_CHANGE"), object: localString)
//            
//            let rootController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ViewController") as! ViewController
//            let navigation = UINavigationController(rootViewController: rootController)
//            
//            UIApplication.shared.keyWindow?.rootViewController = navigation
//        }
//        
//        self.setColorforLanguageView()
//    }
    
//    func setColorforLanguageView()
//    {
//
//        if strLanguage == "ar"
//        {
//            btnEnglish.isEnabled = true
//            btnArabic.isEnabled = false
//
//            btnArabic.backgroundColor = self.app.UIColorFromRGB(rgbValue: 0x123356)
//            btnArabic.setTitleColor(UIColor.white, for: .normal)
//
//            btnEnglish.backgroundColor = UIColor.clear
//            btnEnglish.setTitleColor(UIColor.black, for: .normal)
//        }
//        else
//        {
//            btnEnglish.isEnabled = false
//            btnArabic.isEnabled = true
//
//            btnEnglish.backgroundColor = self.app.UIColorFromRGB(rgbValue: 0x123356)
//            btnEnglish.setTitleColor(UIColor.white, for: .normal)
//
//            btnArabic.backgroundColor = UIColor.clear
//            btnArabic.setTitleColor(UIColor.black, for: .normal)
//        }
//    }
    
    
    func SocialLoginAPI(strTypeId : String, strName : String, strEmail : String, strImage : String, strType : String, strIphoneId : String)
    {
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: false)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading..."
        loadingNotification.dimBackground = true
        
        //        {"type":"facebook","type_id":"1","image":"abc.jpg","name":"jaydeep","email":"jaydeep.wwe@gmail.com","gcm_id":"a"}
        
        
        let parameters: Parameters = ["type_id": strTypeId,//self.strFBID,
                                      "name": strName,//self.strFBName,
                                      "email": strEmail,//self.strFBEmail,
                                      "image": strImage,//self.strFBImage,
                                      "type": strType,//"facebook",
                                      "ipn_id":strIphoneId]//"1"]
        
        print(parameters)
        
        Alamofire.request("\(self.app.strBaseAPI)social_login.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
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
                            self.app.strUserId = self.json["user_id"].stringValue
                            self.app.strName = self.json["user_name"].stringValue
                            self.app.strEmail = self.json["user_email"].stringValue
                            self.app.strNumber = self.json["user_mobile"].stringValue
                            self.app.strUserImage = self.json["user_image"].stringValue
                            self.app.strEssalID = self.json["esaal_customer_id"].stringValue

                            //
                            self.defaults.setValue(self.app.strUserId, forKey: "user_id") //String
                            self.defaults.setValue(self.app.strName, forKey: "user_name") //String
                            self.defaults.setValue(self.app.strEmail, forKey: "user_email") //String
                            self.defaults.setValue(self.app.strNumber, forKey: "user_mobile") //String
                            self.defaults.setValue(self.app.strUserImage, forKey: "user_image") //String
                            self.defaults.setValue(self.app.strEssalID, forKey: "esaal_customer_id") //String

                            self.defaults.synchronize()
                            
                            self.PopToViewController()

//                            let VC = self.storyboard?.instantiateViewController(withIdentifier: "BookingView") as! BookingView
//                            self.navigationController?.pushViewController(VC, animated: true)
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

