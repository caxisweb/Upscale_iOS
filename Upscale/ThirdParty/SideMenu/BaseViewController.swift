//
//  BaseViewController.swift
//  Itext2pay
//
//  Created by Gaurav Parmar on 04/12/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit

extension NSObject{
    static var className: String{
        get{
            return String(describing: self)
        }
    }
}

class BaseViewController: UIViewController,SlideMenuDelegate
{

    var strShareText = "Please download now hive and enjoy booking cooworking space" + "\n" + "http://hive.sa/app.php"

    var app = AppDelegate()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        app = UIApplication.shared.delegate as! AppDelegate
        
        
    }
    
    func slideMenuItemSelectedAtIndex(_ index: Int32)
    {
        let topViewController : UIViewController = self.navigationController!.topViewController!
        print("View Controller is : \(topViewController) \n", terminator: "")
        
        if self.app.strUserId.isEmpty
        {
            switch(index)
            {
            case 0:
                //            self.openViewControllerBasedOnIdentifier("HomeView")
                break
                
            case 1:
                self.openViewControllerBasedOnIdentifier("BookingView")
                break
                
            case 2:
                self.openViewControllerBasedOnIdentifier("ListYourPlaceView")
                break
                
            case 3:
                self.openViewControllerBasedOnIdentifier("PackageView")
                break
                
            case 4:
                self.openViewControllerBasedOnIdentifier("AboutUsView")
                break
                
            case 5:
                self.openViewControllerBasedOnIdentifier("FeedbackView")
                break
                
            case 6:
                self.openViewControllerBasedOnIdentifier("ViewController")
                break
                
            case 7:
                self.openViewControllerBasedOnIdentifier("SignupView")
                break
                
            default:
                print("default\n", terminator: "")
            }
        }
        else
        {
            switch(index)
            {
            case 0:
                //            self.openViewControllerBasedOnIdentifier("HomeView")
                break
                
            case 1:
                self.openViewControllerBasedOnIdentifier("BookingView")
                break
                
            case 2:
                self.openViewControllerBasedOnIdentifier("MyProfileView")
                break
                
            case 3:
                self.openViewControllerBasedOnIdentifier("WishListView")
                break
                
            case 4:
                self.openViewControllerBasedOnIdentifier("MyHistoryView")
                break
                
            case 5:
                self.openViewControllerBasedOnIdentifier("ListYourPlaceView")
                break
                
            case 6:
                self.openViewControllerBasedOnIdentifier("PackageView")
                break
                
            case 7:
                self.openViewControllerBasedOnIdentifier("AboutUsView")
                break
                
            case 8:
                self.openViewControllerBasedOnIdentifier("FeedbackView")
                break
                
            default:
                print("default\n", terminator: "")
            }
        }
    }
    
    func openViewControllerBasedOnIdentifier(_ strIdentifier:String)
    {
        let destViewController : UIViewController = self.storyboard!.instantiateViewController(withIdentifier: strIdentifier)
        let topViewController : UIViewController = self.navigationController!.topViewController!
        let strFinal : String = String(describing: topViewController)
        
        if strFinal.range(of: strIdentifier) != nil
        {
            print("Same VC")
        }
        else
        {
            self.navigationController!.pushViewController(destViewController, animated: true)
        }
    }
    
    func addSlideMenuButton()
    {
        let btnShowMenu = UIButton(type: UIButtonType.system)
        btnShowMenu.setImage(self.defaultMenuImage(), for: UIControlState())
        btnShowMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnShowMenu.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        let customBarItem = UIBarButtonItem(customView: btnShowMenu)
        self.navigationItem.leftBarButtonItem = customBarItem;
    }
    
    func defaultMenuImage() -> UIImage
    {
        var defaultMenuImage = UIImage()
        
        defaultMenuImage = UIImage(named: "menu.png")!
        
        return defaultMenuImage;
    }
    
    func DefaultsShare()
    {
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [self.strShareText], applicationActivities: nil)
        
        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            UIActivityType.postToWeibo,
            UIActivityType.print,
            UIActivityType.assignToContact,
            UIActivityType.saveToCameraRoll,
            UIActivityType.addToReadingList,
            UIActivityType.postToFlickr,
            UIActivityType.postToVimeo,
            UIActivityType.postToTencentWeibo
        ]
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func onSlideMenuButtonPressed(_ sender : UIButton)
    {
        if (sender.tag == 10)
        {
            // To Hide Menu If it already there
            self.slideMenuItemSelectedAtIndex(-1);
            
            sender.tag = 0;
            
            let viewMenuBack : UIView = view.subviews.last!
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                var frameMenu : CGRect = viewMenuBack.frame
                frameMenu.origin.x = -1 * UIScreen.main.bounds.size.width
                viewMenuBack.frame = frameMenu
                viewMenuBack.layoutIfNeeded()
                viewMenuBack.backgroundColor = UIColor.clear
            }, completion:
                { (finished) -> Void in
                viewMenuBack.removeFromSuperview()
            })
            
            return
        }
        
        sender.isEnabled = false
        sender.tag = 10
        
        let menuVC : MenuViewController = self.storyboard!.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menuVC.btnMenu = sender
        menuVC.delegate = self
        self.view.addSubview(menuVC.view)
        self.addChildViewController(menuVC)
        menuVC.view.layoutIfNeeded()
        
        
        menuVC.view.frame=CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        
        UIView.animate(withDuration: 0.3, animations:
            { () -> Void in
            menuVC.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
            sender.isEnabled = true
        }, completion:nil)
    }

}
