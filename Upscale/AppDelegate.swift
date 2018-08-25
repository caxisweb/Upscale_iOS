//
//  AppDelegate.swift
//  Upscale
//
//  Created by Developer on 11/04/17.
//  Copyright © 2017 krutik. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SystemConfiguration
import Alamofire
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import TwitterKit
import Fabric
import UserNotifications
import GoogleMaps
import ImageSlideshow
import GoogleMobileAds


enum UIUserInterfaceIdiom : Int
{
    case Unspecified
    case Phone
    case Pad
}

struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPHONE_X         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 812.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    static let IS_IPAD_PRO          = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
    static let IS_SIMULATOR         = TARGET_IPHONE_SIMULATOR == 1
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,GIDSignInDelegate,UNUserNotificationCenterDelegate
{

    var window: UIWindow?
    
    var strBaseAPI = String()
    var strImagePath = String()
    
    var strUserId = String()
    var strName = String()
    var strEmail = String()
    var strNumber = String()
    var strUserImage = String()
    var strEssalID = String()

    var repeatCount = Int()
    var strEndDate = String()

    var strDeviceToken = String()

    var strLanguage = String()

    var lat = Double()
    var long = Double()

    var arrAdvertise : [Any] = []
    var arrSDWebImageSource : [SDWebImageSource] = []
    var arrURL : [String] = []

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        UIApplication.shared.statusBarStyle = .lightContent
        
        // Sample AdMob app ID: ca-app-pub-3940256099942544~1458002511
//        GADMobileAds.configure(withApplicationID: "ca-app-pub-3940256099942544~1458002511")
        GADMobileAds.configure(withApplicationID: "ca-app-pub-1573732121110201~4564244393")

        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(String(describing: configureError))")
        
        GIDSignIn.sharedInstance().delegate = self
        GMSServices.provideAPIKey("AIzaSyD-CTnHqDSgh-ICq35-45Pd0ck-37Q6q_g")
//        GMSServices.provideAPIKey("AIzaSyDVEarKl8vJ6KN7iGk66I4geQx5HTZdRFw")

        
//        Fabric.with([Twitter.self])
//        Fabric.with(TWTRTwitter)

        TWTRTwitter.sharedInstance().start(withConsumerKey: "mr4zFMgZQtUh4iVGvuiEUvd0d", consumerSecret: "QskHYWA1kupQN28SKe1GIbBqFFE4SuiJGvEEnfMCBPrJyhDbZl")
//        Fabric.with([TWTRTwitter.sharedInstance()])
//        Fabric.with([Crashlytics.self])
//        Fabric.with([Twitter.self])

        NotificationCenter.default.addObserver(self, selector: #selector(languageWillChange), name: NSNotification.Name(rawValue: "LANGUAGE_WILL_CHANGE"), object: nil)
        
//        let targetLang : String = (UserDefaults.standard.object(forKey: "selectedLanguage") as! String)
//        Bundle.setLanguage((targetLang != nil) ? targetLang : "en")

        if UserDefaults.standard.object(forKey: "selectedLanguage") == nil
        {
           Bundle.setLanguage("en")
            self.strLanguage = "en"
        }
        else
        {
            let targetLang : String = (UserDefaults.standard.object(forKey: "selectedLanguage") as! String)
            Bundle.setLanguage((targetLang != nil) ? targetLang : "en")
            self.strLanguage = targetLang
        }
        
        let de = UserDefaults.standard
        if de.string(forKey: "user_id") != nil
        {
            self.strUserId = (de.value(forKey: "user_id") as! String)
            self.strName = (de.value(forKey: "user_name") as! String)
            self.strEmail = (de.value(forKey: "user_email") as! String)
            self.strNumber = (de.value(forKey: "user_mobile") as! String)
            self.strUserImage = (de.value(forKey: "user_image") as! String)
            
            if de.string(forKey: "esaal_customer_id") != nil
            {
                self.strEssalID = (de.value(forKey: "esaal_customer_id") as! String)
            }
        }
        
        let rootController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BookingView") as! BookingView
        let navigation = UINavigationController(rootViewController: rootController)
        self.window!.rootViewController! = navigation

        if DeviceType.IS_SIMULATOR
        {
            let rootController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ViewController") as! ViewController
            let navigation = UINavigationController(rootViewController: rootController)
            self.window!.rootViewController! = navigation
        }

//        strBaseAPI = "http://test.hive.sa/admin/API/"
//        strImagePath = "http://test.hive.sa/admin/upload/"
        
        strBaseAPI = "http://hive.sa/admin/new_api/"//"http://hive.sa/admin/API/"
        strImagePath = "http://hive.sa/admin/upload/"

        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true

//        registerForPushNotifications(application: application)

        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

        return true
    }
    
    @objc func languageWillChange(notification:NSNotification)
    {
        let targetLang = notification.object as! String
        UserDefaults.standard.set(targetLang, forKey: "selectedLanguage")
        Bundle.setLanguage(targetLang)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LANGUAGE_DID_CHANGE"), object: targetLang)
    }

    /*
    //MARK:- Registrer for Push Notification
    func registerForPushNotifications(application: UIApplication)
    {
        if #available(iOS 10.0, *)
        {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.badge, .alert , .sound]) { (greanted, error) in
                if greanted
                {
                    UIApplication.shared.registerForRemoteNotifications();
                }
            }
        }
        else
        {
            let type: UIUserNotificationType = [UIUserNotificationType.badge, UIUserNotificationType.alert, UIUserNotificationType.sound];
            let setting = UIUserNotificationSettings(types: type, categories: nil);
            UIApplication.shared.registerUserNotificationSettings(setting);
            UIApplication.shared.registerForRemoteNotifications();
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        strDeviceToken = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print(strDeviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error)
    {
        print(error.localizedDescription)
    }
    */

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication)
    {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AddNewOfferView"), object: nil, userInfo: nil)

        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication)
    {
        FBSDKAppEvents.activateApp()

        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
//    
//    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
//    }
//    
//    private func application(_ app: UIApplication, open url: URL, options: [AnyHashable: Any]) -> Bool {
//        return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
//    }
    
//    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
//        
//        
//        if(url.scheme == "fbYOURAPPKEY") { //Facebook
//            return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
//        }
//        else { //Gmail
//            return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
//        }
//        
//    }
    
    @objc func tapFunction(sender:UITapGestureRecognizer)
    {
        let imgPager : ImageSlideshow = (sender.view as! ImageSlideshow)
        let strURL = self.arrURL[imgPager.tag]
        
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
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool
    {
        if (url.scheme?.hasPrefix("fb"))!
        {
            return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!, annotation: nil)
        }
        else if (url.scheme?.hasPrefix("com.googleusercontent.apps"))! //
        {
            return GIDSignIn.sharedInstance().handle(url as URL!, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: nil)
        }
        else
        {
            return TWTRTwitter.sharedInstance().application(app, open: url, options: options)
        }
        return true
    }
    
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!)
    {
        if (error == nil) {
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor
    {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    //MARK:- Internet Connection Check
    func isConnectedToInternet() ->Bool
    {
        return NetworkReachabilityManager()!.isReachable
    }


}

extension String
{
    var localized: String
    {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

extension String
{
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: characters.count)) != nil
    }
}


extension NSMutableAttributedString
{
    func setColorForText(_ textToFind: String, with color: UIColor)
    {
        let range = self.mutableString.range(of: textToFind, options: .caseInsensitive)
        if range.location != NSNotFound
        {
//            addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range)
            addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range)
        }
    }
}

extension NSMutableAttributedString {
    enum AtributeSearchType {
        case First, All, Last
    }
    
    func attributeRangeFor(searchString: String, attributeValue: AnyObject, atributeSearchType: AtributeSearchType) {
        let inputLength = self.string.characters.count
        let searchLength = searchString.characters.count
        var range = NSRange(location: 0, length: self.length)
        var rangeCollection = [NSRange]()
        
        while (range.location != NSNotFound) {
            range = (self.string as NSString).range(of: searchString, options: [], range: range)
            if (range.location != NSNotFound) {
                switch atributeSearchType {
                case .First:
                    self.addAttribute(NSAttributedStringKey.foregroundColor, value: attributeValue, range: NSRange(location: range.location, length: searchLength))
                    return
                case .All:
                    self.addAttribute(NSAttributedStringKey.foregroundColor, value: attributeValue, range: NSRange(location: range.location, length: searchLength))
                    break
                case .Last:
                    rangeCollection.append(range)
                    break
                }
                
                range = NSRange(location: range.location + range.length, length: inputLength - (range.location + range.length))
            }
        }
        
        switch atributeSearchType {
        case .Last:
            let indexOfLast = rangeCollection.count - 1
            self.addAttribute(NSAttributedStringKey.foregroundColor, value: attributeValue, range: rangeCollection[indexOfLast])
            break
        default:
            break
        }
    }
}

extension UITextField
{
    func setLeftPaddingPoints(_ amount:CGFloat)
    {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat)
    {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
