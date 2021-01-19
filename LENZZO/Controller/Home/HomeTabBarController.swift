//
//  HomeTabBarController.swift
//  Lenzzo
//
//  Created by Apple on 5/9/19.
//  Copyright © 2019 Lenzzo., Ltd. All rights reserved.
//

import UIKit
import Kingfisher
import AlamofireImage
import MBProgressHUD
import SwiftyGif
import SwiftyJSON
class HomeTabBarController: UITabBarController {
    var controllers = [UIViewController]()
    var numberOfTabs: CGFloat = 4
    var tabBarHeight: CGFloat = 60
    let accountImage = "account"
    @objc let menuButton = UIButton(frame: CGRect.zero)
    var strWhatsappNumber = "+96567696747"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: FontLocalization.medium.strValue, size: 10)!], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: FontLocalization.medium.strValue, size: 10)!], for: .selected)
        
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 0)
        
        //self.setSelctedIndexTabBar()
        self.setTabBarC()
        
        self.setViewControllerForNormalUser()
        setupMiddleButton()
        moreNavigationController.navigationBar.isHidden = true
        if let moreTableView = moreNavigationController.topViewController?.view as? UITableView {
            moreTableView.tintColor = .white
            for cell in moreTableView.visibleCells{
                cell.textLabel?.textColor = .white
                //cell.contentView.backgroundColor = .clear
                cell.backgroundColor = .clear
            }
            moreTableView.backgroundColor = AppColors.themeColor
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = AppColors.themeColor
    }
    
    func setupMiddleButton() {
        menuButton.isHidden = true
        menuButton.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        if(HelperArabic().isArabicLanguage())
        {
            menuButton.setBackgroundImage(UIImage(named:"Whatsapp-512")!.alpha(0.6), for: .normal)
            
        }
        else
        {
            //ic_whatsapp  "Whatsapp-512
            menuButton.setBackgroundImage(UIImage(named:"Whatsapp-512")!.alpha(0.6), for: .normal)
            
        }
        menuButton.backgroundColor = .clear
        
        menuButton.addTarget(self, action:#selector(menuButtonAction), for: .touchUpInside)
        
        self.view.addSubview(menuButton)
        self.view.layoutIfNeeded()
        
    }
    func setSelctedIndexTabBar()
    {
        KeyConstant.user_Default.set(String(format:"%d",self.selectedIndex), forKey: KeyConstant.kSelectedTabBarIndex)
        
    }
    
    @objc func menuButtonAction(sender:UIButton){
        if(strWhatsappNumber.count > 0)
        {
            self.openWhatsapp()
        }
        else
        {
            self.getContactsData()
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tabBarHeight = self.tabBar.frame.height
        menuButton.frame.origin.y = self.tabBar.frame.origin.y - menuButton.frame.height/1.2
        
        
        if(HelperArabic().isArabicLanguage())
        {
            menuButton.frame.origin.x = 8
            
        }
        else
        {
            menuButton.frame.origin.x = self.view.bounds.width -  (menuButton.frame.width)
            
        }
        
        // updateSelectionIndicatorImage()
    }
    func setViewControllerForNormalUser()
    {
//        let whatsAppTab = UIViewController()
//        whatsAppTab.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        
        
        self.setViewC(vC: HomeVC(), imageName: "home", title:  NSLocalizedString("MSG251", comment: ""), colorVC: AppColors.themeColor, withIdentifie: "HomeVC")
        
        self.setViewC(vC: BrandSearchEmptyVC(), imageName: "s", title:  NSLocalizedString("MSG431", comment: ""), colorVC: AppColors.themeColor, withIdentifie: "BrandSearchEmptyVC")
        
        
        self.setViewC(vC: OffersHomeVC(), imageName: "icon", title:  NSLocalizedString("MSG253", comment: ""), colorVC: AppColors.themeColor, withIdentifie: "OffersHomeVC")
        
        self.setViewC(vC: MyCartVC(), imageName: "cart", title:  NSLocalizedString("Cart", comment: ""), colorVC: AppColors.themeColor, withIdentifie: "MyCartVC")
        
        if let strUserID = KeyConstant.user_Default.value(forKey: KeyConstant.kuserId) as? String
        {
            self.setViewC(vC: MyAccountVC(), imageName: "a", title:  NSLocalizedString("MSG254", comment: ""), colorVC: AppColors.themeColor, withIdentifie: "MyAccountVC")
            
        }
        else
        {
            if let strUserID = KeyConstant.user_Default.value(forKey: KeyConstant.kCheckoutGuestId) as? String
            {
                self.setViewC(vC: MyAccountVC(), imageName: "a", title:  NSLocalizedString("MSG254", comment: ""), colorVC: AppColors.themeColor, withIdentifie: "MyAccountVC")
                
            }
            else
            {
                self.setViewC(vC: LoginVC(), imageName: "a", title:  NSLocalizedString("MSG254", comment: ""), colorVC: AppColors.themeColor, withIdentifie: "LoginVC")
            }
        }
        
      //  self.setViewC(vC: ContactUS(), imageName: "contactus", title:  NSLocalizedString("MSG255", comment: ""), colorVC: UIColor.white, withIdentifie: "ContactUS")
        
       //self.setViewC(vC: whatsAppTab, imageName: "contactus", title:  NSLocalizedString("MSG255", comment: ""), colorVC: UIColor.white, withIdentifie: "ContactUS")
        // self.setViewC(vC: FAQListVC(), imageName: "whatsapptab", title:  NSLocalizedString("MSG425", comment: ""), colorVC: UIColor.white, withIdentifie: "FAQListVC")
      //  self.setWhatsVC(vC: whatsAppTab, imageName: "whatsapp_50x50", title:   NSLocalizedString("MSG255", comment: ""))
        self.setViewC(vC: WhatsappVC(), imageName: "whatsapp_50x50", title:  NSLocalizedString("MSG255", comment: ""), colorVC: AppColors.themeColor, withIdentifie: "WhatsappVC")
        
        
        self.viewControllers = controllers
        
        
        
        
        
    }
    
    
    
    func setTabBarC()
    {
        self.delegate = self
        self.tabBar.isTranslucent = false;
        self.tabBar.tintColor = AppColors.SelcetedColor//UIColor(red: 175.0/255.0, green: 148.0/255.0, blue: 50.0/255.0, alpha: 1.0)
        self.tabBar.unselectedItemTintColor = UIColor.white
        self.tabBar.barTintColor = AppColors.tabBarColor
        
        
    }
    
    func setViewC(vC: UIViewController, imageName: String, title: String, colorVC:UIColor, withIdentifie: String)
    {
        let objJob = self.storyboard?.instantiateViewController(withIdentifier: withIdentifie)
        objJob?.tabBarItem.image = UIImage(named: imageName)
        objJob?.title = title
       
        let navBar = UINavigationController(rootViewController: objJob!)
        navBar.isNavigationBarHidden = true
        controllers.append(objJob!)
        
    }
    
    
    func setWhatsVC(vC: UIViewController, imageName: String, title: String){
        vC.view.backgroundColor = .clear
        vC.tabBarItem.image = UIImage(named: imageName)
        vC.title = title
//        let navBar = UINavigationController(rootViewController: objJob!)
//        navBar.isNavigationBarHidden = true
        controllers.append(vC)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension HomeTabBarController: UITabBarControllerDelegate
{
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        //        print(viewController)
        //        print(viewController.tabBarController?.selectedIndex)
        //
        //        if(viewController == FAQListVC())
        //        {
        //            let mobileWhatsapp = "+918826465473"
        //            if(mobileWhatsapp.count > 0)
        //            {
        //                let phoneNumber = mobileWhatsapp.replacingOccurrences(of: " ", with: "")
        //
        //                let urlWhats = "whatsapp://send?phone=" + String(phoneNumber ?? "")
        //                if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
        //                    if let whatsappURL = URL(string: urlString) {
        //                        if UIApplication.shared.canOpenURL(whatsappURL) {
        //                            UIApplication.shared.openURL(whatsappURL)
        //                        } else {
        //                            print("Install Whatsapp")
        //                        }
        //                    }
        //                }
        //                else
        //                {
        //                    let whatsappURL = URL(string: "https://api.whatsapp.com/send?phone=" + String(phoneNumber ?? ""))
        //                    if UIApplication.shared.canOpenURL(whatsappURL!) {
        //                        UIApplication.shared.open(whatsappURL!, options: [:], completionHandler: nil)
        //                    }
        //                }
        //            }
        //            return false
        //        }
        
       // print("shouldSelect")
        return true
    }
    
    
    // UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // print(self.selectedIndex)
        //  self.setSelctedIndexTabBar()
        KeyConstant.user_Default.set(String(format:"%d",(viewController.tabBarController?.selectedIndex) ?? 0), forKey: KeyConstant.kSelectedTabBarIndex)
        self.view.backgroundColor = AppColors.themeColor
        
        if(self.selectedIndex == 0)
        {
            
            KeyConstant.sharedAppDelegate.setRoot()
            
        }
        
        if (self.selectedIndex == 4){
            if(strWhatsappNumber.count > 0)
            {
                self.openWhatsapp()
            }
            else
            {
                self.getContactsData()
            }
        }
        
        
        
    }
    
    func updateSelectionIndicatorImage() {
        let width = tabBar.bounds.width
        var selectionImage = UIImage(named: "tabSelected")
        let tabSize = CGSize(width: width/numberOfTabs, height: tabBarHeight)
        
        UIGraphicsBeginImageContext(tabSize)
        selectionImage!.draw(in: CGRect(x: 0, y: 0, width: tabSize.width, height: tabSize.height))
        selectionImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        self.tabBar.selectionIndicatorImage = selectionImage
    }
    
    
 //MARK:- getContactsData
    
    func getContactsData()
    {
        
        
       self.strWhatsappNumber = "+96567696747"
        self.openWhatsapp()
//        MBProgress().showIndicator(view: self.view)
//
//
//        WebServiceHelper.sharedInstanceAPI.hitPostAPI(urlString: KeyConstant.APIContactDetails, params: [:], completionHandler: { (result: [String:Any], err:Error?) in
//            print(result)
//            DispatchQueue.main.async {
//                MBProgress().hideIndicator(view: self.view)
//            }
//            if(!(err == nil))
//            {
//
//                return
//            }
//            let json = JSON(result)
//
//            let statusCode = json["status"].string
//            print(json)
//            if(statusCode == "success")
//            {
//                if let dicData = json["response"]["cms_detail_Array"]["admin_settings"].dictionary
//                {
//                    if(dicData.count > 0)
//                    {
//                        self.strWhatsappNumber = dicData["whatsup_number"]?.string ?? ""
//                        self.openWhatsapp()
//
//
//                    }
//                }
//            }})
        
        
        
    }
    
    func openWhatsapp()
    {
        if( self.strWhatsappNumber.count > 0)
        {
            var fullMob = self.strWhatsappNumber
            fullMob = fullMob.replacingOccurrences(of: " ", with: "")
            fullMob = fullMob.replacingOccurrences(of: "+", with: "")
            fullMob = fullMob.replacingOccurrences(of: "-", with: "")
            let urlWhats = "whatsapp://send?phone=\(fullMob)"
            if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
                if let whatsappURL = URL(string: urlString) {
                    if UIApplication.shared.canOpenURL(whatsappURL){
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(whatsappURL)
                        }
                    }
                    else {
                        print("Please Install Whatsapp")
                        
                        KeyConstant.sharedAppDelegate.showAlertView(vc: (self.viewControllers?[4])!,titleString:NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG437", comment: ""))
                        
                        
                        
                    }
                }
            }
                
            else
            {
                let whatsappURL = URL(string: "https://api.whatsapp.com/send?phone=" + String(fullMob))
                if UIApplication.shared.canOpenURL(whatsappURL!) {
                    UIApplication.shared.open(whatsappURL!, options: [:], completionHandler: nil)
                }
            }
        }
       
    }
}

extension UIView {
    var safeAreaHeight: CGFloat {
        if #available(iOS 11, *) {
            return safeAreaLayoutGuide.layoutFrame.size.height
        }
        return bounds.height
    }
}
