//
//  PackageView.swift
//  Upscale
//
//  Created by Krutik V. Poojara on 15/02/18.
//  Copyright © 2018 krutik. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD
import Toaster
import DLRadioButton


class PackageView: BaseViewController,UITableViewDelegate,UITableViewDataSource
{
    //MARK:- Outlet
    
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var tblView: UITableView!
    
    @IBOutlet var viewPopup: UIView!
    @IBOutlet var viewPackage: UIView!
    
    @IBOutlet var lblDetails: UILabel!
    @IBOutlet var scrollView: UIScrollView!

    @IBOutlet var lblSPACES: UILabel!
    
    @IBOutlet var lblSpaces: UILabel!
    
    
    @IBOutlet var viewPayment: UIView!
    
    
    @IBOutlet var btnCOD: DLRadioButton!
    @IBOutlet var btnVISA: DLRadioButton!
    @IBOutlet var btnBANK: DLRadioButton!

    @IBOutlet var lblVisa: UILabel!
    @IBOutlet var lblBank: UILabel!

    
    @IBOutlet var btnCancel: UIButton!
    @IBOutlet var btnPickPackage: UIButton!
    
    var loadingNotification : MBProgressHUD!
    var json : JSON!
    var strMessage : String!

    var arrPackage : [Any] = []

    var strPaymentType = "1"
    let defaults = UserDefaults.standard
    var strLanguage = "English"

    var strBankName = String()
    var strIbanNumber = String()
    var strAccountNumber = String()
    var strPackageID = String()

    //MARK:-
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true

        if DeviceType.IS_IPHONE_X
        {
            self.viewNavigation.frame = CGRect(x:self.viewNavigation.frame.origin.x, y: self.viewNavigation.frame.origin.y, width:self.viewNavigation.frame.size.width, height:88)
            self.tblView.frame = CGRect(x:self.tblView.frame.origin.x, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height + 10, width:self.tblView.frame.size.width, height:self.view.frame.size.height -  self.viewNavigation.frame.size.height - 20)
        }
        
        if self.defaults.string(forKey: "selectedLanguage") != nil
        {
            self.strLanguage = (self.defaults.value(forKey: "selectedLanguage") as! String)
        }
        
        if strLanguage == "ar"
        {
            self.btnCOD.frame = CGRect(x:self.btnCOD.frame.origin.x, y: self.btnCOD.frame.origin.y, width:self.btnCOD.frame.size.width - 20, height:self.btnCOD.frame.size.height)
            self.btnVISA.frame = CGRect(x:self.btnCOD.frame.origin.x + self.btnCOD.frame.size.width, y: self.btnVISA.frame.origin.y, width:self.btnVISA.frame.size.width, height:self.btnVISA.frame.size.height)
            self.btnBANK.frame = CGRect(x:self.btnVISA.frame.origin.x + self.btnVISA.frame.size.width, y: self.btnBANK.frame.origin.y, width:self.btnBANK.frame.size.width + 20, height:self.btnBANK.frame.size.height)
        }
        
        self.tblView.delegate = self
        self.tblView.dataSource = self
        
        self.viewPopup.isHidden = true
        
        self.btnCancel.layer.borderColor = UIColor.init(rgb: 0xF6A92B).cgColor
        self.btnCancel.layer.borderWidth = 1
        
        if self.app.isConnectedToInternet()
        {
            self.getPackageAPI()
        }
        else
        {
            Toast(text: "Internet Connetion in not availble.Try Again").show()
        }
    }

    func setScrollviewForLastView()
    {
        for viewAll: UIView in scrollView.subviews
        {
            if viewAll.tag == 101
            {
                scrollView.contentSize = CGSize(width: CGFloat(scrollView.frame.size.width), height: CGFloat(viewAll.frame.origin.y + viewAll.frame.size.height + 10))
            }
        }
    }
    
    //MARK:- Back
    @IBAction func btnBack(_ sender: Any)
    {
        self.onSlideMenuButtonPressed(sender as! UIButton)
    }
    
    @IBAction func btnCancel(_ sender: UIButton)
    {
        self.viewPopup.isHidden = true
    }
    
    @IBAction func btnPickPackage(_ sender: UIButton)
    {
        if strPaymentType == "2"
        {
            Toast(text: "Visa Payment Service is Temporary Not Available").show()
        }
        else
        {
            let alertController = UIAlertController(title: "Are you sure you want to Subscribe to this package?", message: nil, preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "NO", style: .default) { (action:UIAlertAction!) in
                print("you have pressed the Cancel button")
            }
            alertController.addAction(cancelAction)
            
            let OKAction = UIAlertAction(title: "YES", style: .default) { (action:UIAlertAction!) in
                print("you have pressed OK button")
                
                if self.app.strUserId.isEmpty
                {
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                    self.navigationController?.pushViewController(VC, animated: true)
                }
                else
                {
                    if self.app.isConnectedToInternet()
                    {
                        self.InsertPackageAPI()
                    }
                    else
                    {
                        Toast(text: "Internet Connetion in not availble.Try Again").show()
                    }
                }
            }
            alertController.view.tintColor = UIColor.init(rgb: 0xF2932C)
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion:nil)
        }
    }
    
    @IBAction func btnCODVISA(_ sender: DLRadioButton)
    {
        if btnCOD.isTouchInside == true
        {
            strPaymentType = "1"
            btnCOD.isSelected = true
            btnVISA.isSelected = false
            btnBANK.isSelected = false
            
            self.SelectedButton(btn: btnCOD)
            self.UnSelectButton(btn: btnVISA)
            self.UnSelectButton(btn: btnBANK)
        }
        else if btnVISA.isTouchInside == true
        {
            strPaymentType = "2"
            btnCOD.isSelected = false
            btnVISA.isSelected = true
            btnBANK.isSelected = false
            
            self.UnSelectButton(btn: btnCOD)
            self.SelectedButton(btn: btnVISA)
            self.UnSelectButton(btn: btnBANK)
        }
        else if btnBANK.isTouchInside == true
        {
            strPaymentType = "3"
            btnCOD.isSelected = false
            btnVISA.isSelected = false
            btnBANK.isSelected = true
            
            self.UnSelectButton(btn: btnCOD)
            self.UnSelectButton(btn: btnVISA)
            self.SelectedButton(btn: btnBANK)
        }
        self.setPaymentDetails()
    }
    
    func setPaymentDetails()
    {
        UIView.animate(withDuration: 0.5) {
            
            if self.strPaymentType == "1"
            {
                self.lblVisa.isHidden = true
                self.lblBank.isHidden = true
                
                self.viewPayment.frame = CGRect(x:self.viewPayment.frame.origin.x, y: self.viewPayment.frame.origin.y, width:self.viewPayment.frame.size.width, height:self.btnCOD.frame.origin.y + self.btnCOD.frame.size.height + 5)
            }
            else if self.strPaymentType == "2"
            {
                self.lblVisa.isHidden = false
                self.lblBank.isHidden = true
                
                self.viewPayment.frame = CGRect(x:self.viewPayment.frame.origin.x, y: self.viewPayment.frame.origin.y, width:self.viewPayment.frame.size.width, height:self.lblVisa.frame.origin.y + self.lblVisa.frame.size.height + 5)
            }
            else if self.strPaymentType == "3"
            {
                self.lblVisa.isHidden = true
                self.lblBank.isHidden = false
                
                self.viewPayment.frame = CGRect(x:self.viewPayment.frame.origin.x, y: self.viewPayment.frame.origin.y, width:self.viewPayment.frame.size.width, height:self.lblBank.frame.origin.y + self.lblBank.frame.size.height + 5)
            }
            
            self.setScrollviewForLastView()
        }
    }
    
    func SelectedButton(btn : DLRadioButton)
    {
        btn.iconColor = UIColor.init(rgb: 0xF2932C)
        btn.indicatorColor = UIColor.init(rgb: 0xF2932C)
    }
    
    func UnSelectButton(btn : DLRadioButton)
    {
        btn.iconColor = UIColor.darkGray
        btn.indicatorColor = UIColor.darkGray
    }
    
    //MARK:- Tablview
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return self.arrPackage.count
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell : PackageCell!
        cell = tblView.dequeueReusableCell(withIdentifier: "PackageCell") as! PackageCell!
        if cell == nil
        {
            cell = Bundle.main.loadNibNamed("PackageCell", owner: self, options: nil)?[0] as! PackageCell!
        }
        
        let arrValue = JSON(self.arrPackage)
        
        let strName : String = arrValue[indexPath.section]["package_name"].stringValue
        let strType : String = arrValue[indexPath.section]["package_type"].stringValue
        let strPrice : String = arrValue[indexPath.section]["package_price"].stringValue
        let strSubscribe : String = arrValue[indexPath.section]["is_subscribe"].stringValue
        let strCompanyName : String = arrValue[indexPath.section]["company_name"].stringValue

        cell.lblPackage.text = strName
        cell.lblType.text = strType
        cell.lblPrice.text = "\(strPrice) SAR"
        cell.lblCompany.text = strCompanyName

        if strSubscribe == "1"
        {
            cell.lblSubscribe.text = "Subscribed"
        }
        else
        {
            cell.lblSubscribe.text = ""
        }
        
        tblView.rowHeight = cell.frame.size.height
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        viewPopup.frame.origin.x = 0
        ProjectUtility.animatePopupView(viewPopup: viewPopup, viewDetails: viewPackage)

        let arrValue = JSON(self.arrPackage)
        
        strPackageID = arrValue[indexPath.section]["package_id"].stringValue
        let strDetails : String = arrValue[indexPath.section]["package_desc"].stringValue
        var strSpaceName : String = arrValue[indexPath.section]["space_name"].stringValue
        strSpaceName = strSpaceName.replacingOccurrences(of: ",", with: "\n")

        self.lblDetails.text = strDetails
        self.lblSpaces.text = strSpaceName
        let rectDetails = self.lblDetails.text?.boundingRect(with: CGSize(width: CGFloat(self.lblDetails.frame.size.width), height: CGFloat(50000)), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: self.lblDetails.font], context: nil)
        self.lblDetails.frame = CGRect(x:self.lblDetails.frame.origin.x, y: self.lblDetails.frame.origin.y, width:self.lblDetails.frame.size.width, height:(rectDetails?.height)!)

        self.lblSPACES.frame = CGRect(x:self.lblSPACES.frame.origin.x, y: self.lblDetails.frame.origin.y + self.lblDetails.frame.size.height + 10, width:self.lblSPACES.frame.size.width, height: self.lblSPACES.frame.height)

        let rectSpace = self.lblSpaces.text?.boundingRect(with: CGSize(width: CGFloat(self.lblSpaces.frame.size.width), height: CGFloat(50000)), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: self.lblSpaces.font], context: nil)
        self.lblSpaces.frame = CGRect(x:self.lblSpaces.frame.origin.x, y: self.lblSPACES.frame.origin.y + self.lblSPACES.frame.size.height + 10, width:self.lblSpaces.frame.size.width, height:(rectSpace?.height)!)

        self.viewPayment.frame = CGRect(x:self.viewPayment.frame.origin.x, y: self.lblSpaces.frame.origin.y + self.lblSpaces.frame.size.height, width:self.viewPayment.frame.size.width, height: self.viewPayment.frame.height)
        
        strPaymentType = "1"
        btnCOD.isSelected = true
        btnVISA.isSelected = false
        btnBANK.isSelected = false
        
        self.SelectedButton(btn: btnCOD)
        self.UnSelectButton(btn: btnVISA)
        self.UnSelectButton(btn: btnBANK)
        
        if self.strLanguage == "en"
        {
            self.strBankName = arrValue[indexPath.section]["bank_name"].stringValue
            self.strIbanNumber = arrValue[indexPath.section]["iban"].stringValue
            self.strAccountNumber = arrValue[indexPath.section]["account_no"].stringValue
        }
        else
        {
            self.strBankName = arrValue[indexPath.section]["bank_name_ar"].stringValue
            self.strIbanNumber = arrValue[indexPath.section]["iban_ar"].stringValue
            self.strAccountNumber = arrValue[indexPath.section]["account_no_ar"].stringValue
        }
        
        if self.strBankName.isEmpty
        {
            self.btnBANK.isEnabled = false
            self.btnBANK.isUserInteractionEnabled = false
        }
        else
        {
            self.btnBANK.isEnabled = true
            self.btnBANK.isUserInteractionEnabled = true
        }
        
        var strBankText = String()
        strBankText = "Bank Name".localized + " : \(self.strBankName)\n" + "Iban No".localized + " : \(self.strIbanNumber)\n" + "Account No".localized +  ": \(self.strAccountNumber)\n"
        
        self.lblBank.text = strBankText//"Bank Name : \(self.strBankName)\nIban No : \(self.strIbanNumber)\nAccount No : \(self.strAccountNumber)"
        let rectBank = self.lblBank.text?.boundingRect(with: CGSize(width: CGFloat(self.lblBank.frame.size.width), height: CGFloat(50000)), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: self.lblBank.font], context: nil)
        self.lblBank.frame = CGRect(x:self.lblBank.frame.origin.x, y: self.lblBank.frame.origin.y, width:self.lblBank.frame.size.width, height:(rectBank?.height)!)
        
        self.setPaymentDetails()
    }
    
    func MoreAction(sender: UIButton!)
    {
        ProjectUtility.animatePopupView(viewPopup: viewPopup, viewDetails: viewPackage)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        let viewHeader = UIView()
        viewHeader.backgroundColor = UIColor.clear
        
        return viewHeader
    }
    
    //MARK:- Get Package API
    func getPackageAPI()
    {
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: false)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading..."
        loadingNotification.dimBackground = true
        
        let parameters : Parameters = ["user_id":self.app.strUserId]
        print(JSON(parameters))
        
        Alamofire.request("\(self.app.strBaseAPI)package_list.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            debugPrint(response)
            
            self.loadingNotification.hide(animated: true)
            
            if response.response?.statusCode == 200
            {
                if response.result.isSuccess == true
                {
                    if let value = response.result.value
                    {
                        self.json = JSON(value)
                        print(self.json)
                        
                        let strStatus : String = self.json["status"].stringValue
                        self.strMessage = self.json["message"].stringValue
                        
                        self.arrPackage.removeAll()
                        
                        if strStatus == "1"
                        {
                            self.arrPackage = self.json["package_list"].arrayValue
                            
                            self.tblView.reloadData()
                        }
                        else
                        {
                            Toast(text: self.strMessage).show()
                        }
                    }
                    else
                    {
                        Toast(text: "Request time out.").show()
                    }
                }
                else
                {
                    print(response.result.error.debugDescription)
                    Toast(text: "Request time out.").show()
                }
            }
        }
    }
    
    //MARK:- Insert Package API
    func InsertPackageAPI()
    {
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: false)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading..."
        loadingNotification.dimBackground = true
        
        let parameters: Parameters = ["package_id": self.strPackageID,
                                      "user_id":self.app.strUserId,
                                      "payment_type":self.strPaymentType]
        
        print(JSON(parameters))
        
        Alamofire.request("\(self.app.strBaseAPI)package_booking.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            debugPrint(response)
            
            self.loadingNotification.hide(animated: true)
            
            if response.response?.statusCode == 200
            {
                if response.result.isSuccess == true
                {
                    if let value = response.result.value
                    {
                        self.json = JSON(value)
                        print(self.json)
                        
                        let strStatus : String = self.json["status"].stringValue
                        self.strMessage = self.json["message"].stringValue
                        
                        self.arrPackage.removeAll()
                        
                        if strStatus == "1"
                        {
                            self.getPackageAPI()

                            Toast(text: "Package Successfully Subscribed").show()
                            self.viewPopup.isHidden = true
                        }
                        else
                        {
                            Toast(text: "You are Already Subscriber of this package").show()
                        }
                    }
                    else
                    {
                        Toast(text: "Request time out.").show()
                    }
                }
                else
                {
                    print(response.result.error.debugDescription)
                    Toast(text: "Request time out.").show()
                }
            }
        }
    }
    
}
