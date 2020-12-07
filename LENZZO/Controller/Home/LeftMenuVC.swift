//
//  LeftMenuVC.swift
//  Lenzzo
//
//  Created by Apple on 5/9/19.
//  Copyright © 2019 Lenzzo., Ltd. All rights reserved.
//

import UIKit
import SwiftyJSON
import AlamofireImage

class LeftMenuVC: UIViewController,UIActionSheetDelegate {
    var arrUserData = [String]()
    var viewController = UIViewController()
    var leftImageIconArray = ["menu_tick","menu_tick_right"]
    
    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var arrayTitle = [NSLocalizedString("MSG333", comment: ""),NSLocalizedString("MSG334", comment: ""),NSLocalizedString("MSG335", comment: ""),NSLocalizedString("MSG336", comment: ""),NSLocalizedString("MSG337", comment: ""),NSLocalizedString("MSG338", comment: ""),NSLocalizedString("MSG339", comment: ""),NSLocalizedString("MSG340", comment: "")]
    
    var arrayAfterLogin = [NSLocalizedString("MSG333", comment: ""),NSLocalizedString("MSG334", comment: ""),NSLocalizedString("MSG335", comment: ""),NSLocalizedString("MSG336", comment: ""),NSLocalizedString("MSG337", comment: ""),NSLocalizedString("MSG338", comment: ""),NSLocalizedString("MSG339", comment: ""),NSLocalizedString("MSG340", comment: ""),NSLocalizedString("MSG341", comment: "")]
    
    
    //Latest,Exclusive
    
    override func viewDidLoad() {
        
        tableView.tableFooterView = UIView()
        super.viewDidLoad()
        self.getProfileData()
        
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        // self.checkExclusiveAndLatestProduct()
        
        // Do any additional setup after loading the view.
    }
    func getProfileData()
    {
        
        
        WebServiceHelper.sharedInstanceAPI.hitPostAPI(urlString: KeyConstant.APIProfileDetails, params: ["user_id":KeyConstant.user_Default.value(forKey: KeyConstant.kuserId) as? String ?? ""], completionHandler: { (result: [String:Any], err:Error?) in
            print(result)
            
            if(!(err == nil))
            {
                return
            }
            let json = JSON(result)
            
            let statusCode = json["status"].string
            print(json)
            if(statusCode == "success")
            {
                
                KeyConstant.user_Default.set(String(json["response"]["name"].string?.capitalizedFirst ?? ""), forKey: KeyConstant.kuserName)
                
                
            }
            
        })
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tableView.reloadData()
        
    }
    
    func checkExclusiveAndLatestProduct()
    {
        
        ProductListViewModel().getBrandCatProductList(vc: self, itemId: "", APIName: KeyConstant.APIBrandProductList, sortIndex: [String:String](), customParam: ["tags":"exclusive"], filterParam: [ : ], completionHandler: { (result:[JSON], success: Bool, errorC:Error?) in
            
            if(result.count > 0 &&  (!self.arrayTitle.contains(NSLocalizedString("MSG217", comment: ""))))
            {
                self.arrayTitle.insert(NSLocalizedString("MSG217", comment: ""), at: self.arrayTitle.count)
                self.arrayAfterLogin.insert(NSLocalizedString("MSG217", comment: ""), at: self.arrayAfterLogin.count)
            }
            self.tableView.reloadData()
        } )
        
        
        ProductListViewModel().getBrandCatProductList(vc: self, itemId: "", APIName: KeyConstant.APIBrandProductList, sortIndex: [String:String](), customParam: ["tags":"new"], filterParam: [ : ], completionHandler: { (result:[JSON], success: Bool, errorC:Error?) in
            
            if(result.count > 0 && (!self.arrayTitle.contains(NSLocalizedString("MSG218", comment: ""))))
            {
                self.arrayTitle.insert(NSLocalizedString("MSG218", comment: ""), at: self.arrayTitle.count)
                self.arrayAfterLogin.insert(NSLocalizedString("MSG218", comment: ""), at: self.arrayAfterLogin.count)
                
            }
            self.tableView.reloadData()
            
        } )
        
    }
    
    @IBAction func buttonLoginSignup(_ sender: Any) {
        
        
        let isLogin = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        isLogin.isPresentFromMenu = true
        self.slideMenuController()?.present(isLogin, animated: false, completion: nil)
        
    }
    
    @IBAction func buttonCancelAction(_ sender: Any) {
        if(HelperArabic().isArabicLanguage())
        {
            
            self.slideMenuController()?.closeRight()
        }
        else
        {
            self.slideMenuController()?.closeLeft()
            
        }
    }
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension LeftMenuVC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let userid = KeyConstant.user_Default.value(forKey: KeyConstant.kuserId) as? String
        {
            
            self.labelTitle.text = "\(NSLocalizedString("MSG342", comment: "")) " + String(KeyConstant.user_Default.value(forKey: KeyConstant.kuserName) as? String ?? "")
            self.buttonLogin.isHidden = true
            self.labelTitle.isHidden = false
            return arrayAfterLogin.count
            
        }
        else
        {
            if let userid = KeyConstant.user_Default.value(forKey: KeyConstant.kCheckoutGuestId) as? String
            {
                
                self.labelTitle.text = "\(NSLocalizedString("MSG342", comment: "")) " + String(KeyConstant.user_Default.value(forKey: KeyConstant.kuserName) as? String ?? "")
                self.buttonLogin.isHidden = true
                self.labelTitle.isHidden = false
                return arrayAfterLogin.count
                
            }
        }
        self.buttonLogin.isHidden = false
        self.labelTitle.isHidden = true
        
        return arrayTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTVC") as! MenuTVC
        
        if let userid = KeyConstant.user_Default.value(forKey: KeyConstant.kuserId) as? String
        {
            cell.labelTitle.text = arrayAfterLogin[indexPath.row]
            if(HelperArabic().isArabicLanguage())
            {
                if(arrayAfterLogin[indexPath.row] == NSLocalizedString("MSG335", comment: ""))
                {
                    cell.labelTitle.text = "English"
                }
            }
            else
            {
                if(arrayAfterLogin[indexPath.row] == NSLocalizedString("MSG335", comment: ""))
                {
                    cell.labelTitle.text = "العربية"
                }
            }
        }
        else if let userid = KeyConstant.user_Default.value(forKey: KeyConstant.kCheckoutGuestId) as? String
        {
            cell.labelTitle.text = arrayAfterLogin[indexPath.row]
            if(HelperArabic().isArabicLanguage())
            {
                if(arrayAfterLogin[indexPath.row] == NSLocalizedString("MSG335", comment: ""))
                {
                    cell.labelTitle.text = "English"
                }
            }
            else
            {
                if(arrayAfterLogin[indexPath.row] == NSLocalizedString("MSG335", comment: ""))
                {
                    cell.labelTitle.text = "العربية"
                }
            }
        }
        else
        {
            cell.labelTitle.text = arrayTitle[indexPath.row]
            if(HelperArabic().isArabicLanguage())
            {
                
                if(arrayTitle[indexPath.row] == NSLocalizedString("MSG335", comment: ""))
                {
                    cell.labelTitle.text = "English"
                }
                
            }
            else
            {
                if(arrayTitle[indexPath.row] == NSLocalizedString("MSG335", comment: ""))
                {
                    cell.labelTitle.text = "العربية"
                }
                
                
                
            }
        }
        if(HelperArabic().isArabicLanguage())
        {
            
            cell.imageIcon.image = UIImage(named:leftImageIconArray[1])
            cell.labelTitle.textAlignment = .right
        }
        else
        {
            cell.imageIcon.image = UIImage(named:leftImageIconArray[0])
            cell.labelTitle.textAlignment = .left
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        switch(indexPath.row)
        {
        case 0:
            KeyConstant.sharedAppDelegate.setRoot()
            break
        case 1:
            KeyConstant.sharedAppDelegate.showCountryScreen(vc: self)
            break
        case 2:
            if(HelperArabic().isArabicLanguage())
            {
                self.changeEnglish()
                
            }
            else
            {
                self.changeArabic()
                
            }
            // KeyConstant.sharedAppDelegate.showCountryScreen(vc: self)
            break
        case 3:
            let brandVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoriesListVC") as! CategoriesListVC
            self.slideMenuController()?.present(brandVC, animated: false, completion: nil)
            break
        case 4:
            let objVC = self.storyboard?.instantiateViewController(withIdentifier: "AboutUS") as! AboutUS
            objVC.typeCMSAPI = "terms-and-conditions"
            objVC.titleString = arrayTitle[indexPath.row]
            objVC.htmlString = NSLocalizedString("MSG232", comment: "")
            self.slideMenuController()?.present(objVC, animated: false, completion: nil)
            break
        case 5:
            let objVC = self.storyboard?.instantiateViewController(withIdentifier: "AboutUS") as! AboutUS
            objVC.typeCMSAPI = "about-us"
            objVC.titleString = arrayTitle[indexPath.row]
            objVC.htmlString = NSLocalizedString("MSG232", comment: "")
            self.slideMenuController()?.present(objVC, animated: false, completion: nil)
            break
        case 6:
            let objVC = self.storyboard?.instantiateViewController(withIdentifier: "FAQListVC") as! FAQListVC
            objVC.titleString = arrayTitle[indexPath.row]
            self.slideMenuController()?.present(objVC, animated: false, completion: nil)
            break
        case 7:
            self.rateApp()
            break
        case 8:
            
            SignupViewModel().logout(vc: self)
            
            
            break
            
            
        default: break
            
            
            
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func rateApp()
    {
        //itms-apps://itunes.apple.com/app/
        //https://apps.apple.com/us/app/lenzzo/id1462253938
        guard let url = URL(string: "itms-apps://itunes.apple.com/app/" + "id1462253938") else {
            return
        }
        if #available(iOS 10, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    
    func changeEnglish()
    {
        let alertView = UIAlertController(title: NSLocalizedString("ALERT", comment: "").uppercased(), message: "", preferredStyle: .alert)
        
        let msgFont = [NSAttributedString.Key.font: UIFont(name: FontLocalization.medium.strValue, size: 15.0)!]
        
        let msgAttrString = NSMutableAttributedString(string: "Do you really want to change language?", attributes: msgFont)
        
        alertView.setValue(msgAttrString, forKey: "attributedMessage")
        
        let alertAction = UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .default) { (alert) in
            
            
            
        }
        let alertYes = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default) { (alert) in
            //yes
            self.updateCountryList(strValue: "en")
            
            
        }
        
        
        
        
        alertView.addAction(alertYes)
        
        alertView.addAction(alertAction)
        alertAction.setValue(AppColors.SelcetedColor, forKey: "titleTextColor")
        alertYes.setValue(AppColors.SelcetedColor, forKey: "titleTextColor")
        
        alertView.view.tintColor = UIColor.black
        alertView.view.layer.cornerRadius = 40
        alertView.view.backgroundColor = UIColor.white
        DispatchQueue.main.async(execute: {
            
            self.present(alertView, animated: true, completion: nil)
        })
        
    }
    func changeArabic()
    {
        
        let alertView = UIAlertController(title: NSLocalizedString("تنبيه", comment: "").uppercased(), message: "", preferredStyle: .alert)
        
        let msgFont = [NSAttributedString.Key.font: UIFont(name: FontLocalization.medium.strValue, size: 15.0)!]
        
        let msg = "هل تريد حقًا تغيير اللغة؟"
        
        let msgAttrString = NSMutableAttributedString(string: msg, attributes: msgFont)
        
        alertView.setValue(msgAttrString, forKey: "attributedMessage")
        
        let alertAction = UIAlertAction(title: NSLocalizedString("لا", comment: ""), style: .default) { (alert) in
            
            
            
        }
        let alertYes = UIAlertAction(title: NSLocalizedString("نعم", comment: ""), style: .default) { (alert) in
            //yes
            self.updateCountryList(strValue: "ar")
            
        }
        alertView.addAction(alertYes)
        
        alertView.addAction(alertAction)
        alertAction.setValue(AppColors.SelcetedColor, forKey: "titleTextColor")
        alertYes.setValue(AppColors.SelcetedColor, forKey: "titleTextColor")
        
        alertView.view.tintColor = UIColor.black
        alertView.view.layer.cornerRadius = 40
        alertView.view.backgroundColor = UIColor.white
        DispatchQueue.main.async(execute: {
            
            self.present(alertView, animated: true, completion: nil)
        })
        
    }
    
    func updateCountryList(strValue:String)
    {
        
        MBProgress().showIndicator(view: self.view)
        
        
        WebServiceHelper.sharedInstanceAPI.hitPostAPI(urlString: KeyConstant.APIChange_language, params: ["current_language":strValue,"user_id":KeyConstant.sharedAppDelegate.getUserId()], completionHandler: { (result: [String:Any], err:Error?) in
            print(result)
            
            
            DispatchQueue.main.async {
                MBProgress().hideIndicator(view: self.view)
            }
            if(err != nil)
            {
                self.updateCountryList(strValue: strValue)
                return
            }
            let json = JSON(result)
            
            let statusCode = json["status"].string
            print(json)
            if(statusCode == "success")
            {
                
                
                
                
                Bundle.setLanguage(strValue)
                UserDefaults.standard.set([strValue], forKey: KeyConstant.kSelectedDeviceCurrency)
                UserDefaults.standard.synchronize()
                
                if(strValue == KeyConstant.kArabicCode)
                {
                    
                    UIView.appearance().semanticContentAttribute = .forceRightToLeft
                    KeyConstant.user_Default.setValue("العربية", forKey: KeyConstant.kSelectedLanguage)
                    
                    
                }
                else{
                    UIView.appearance().semanticContentAttribute = .forceLeftToRight
                    KeyConstant.user_Default.setValue("English", forKey: KeyConstant.kSelectedLanguage)
                    
                    
                }
                
                
                KeyConstant.sharedAppDelegate.setRoot()
            }
            
            
        })
        
        
        
    }
}

extension String {
    var capitalizedFirst: String {
        
        return self.capitalized
        //        let characters = self.characters
        //        if let first = characters.first {
        //            return String(first).uppercased() +
        //                String(characters.dropFirst())
        //        }
        //        return self
    }
}
