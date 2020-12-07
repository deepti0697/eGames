//
//  SignupViewModel.swift
//  LENZZO
//
//  Created by Apple on 8/30/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON


class SignupViewModel
{
    
    func signup(vc:UIViewController, params:[String:String] , isPresentFromMenu:Bool)
    {
        
        
        MBProgress().showIndicator(view: vc.view)
        
        WebServiceHelper.sharedInstanceAPI.hitPostAPI(urlString: KeyConstant.APISignup, params: params, completionHandler: { (result: [String:Any], err:Error?) in
            print(result)
            MBProgress().hideIndicator(view: vc.view)
            
            if(!(err == nil))
            {
                KeyConstant.sharedAppDelegate.showAlertView(vc: vc,titleString:NSLocalizedString("MSG31", comment: ""), messageString:err?.localizedDescription ?? NSLocalizedString("MSG21", comment: ""))
                
                return
            }
            let json = JSON(result)
            
            let statusCode = json["status"].string
            
            if(statusCode == "success")
            {
                
                if let dicData = json["result"].dictionary
                {                    
                    
                    if let userId = dicData["id"]?.string
                    {
                        
                        KeyConstant.user_Default.set(userId, forKey: KeyConstant.kuserId)
                        KeyConstant.user_Default.set(dicData["name"]?.string, forKey: KeyConstant.kuserName)
                        KeyConstant.user_Default.set(dicData["email"]?.string, forKey: KeyConstant.kuserEmail)
                        KeyConstant.user_Default.set(dicData["country_code"]?.string, forKey: KeyConstant.kuserCountryCode)
                        
                        KeyConstant.user_Default.removeObject(forKey: KeyConstant.kCheckoutGuestId)
                        
                        KeyConstant.user_Default.removeObject(forKey: KeyConstant.kUserSessionTempId)
                        var message = json["message"].string ?? NSLocalizedString("MSG279", comment: "")
                        
                        if(HelperArabic().isArabicLanguage())
                        {
                            if let msg = json["message_ar"].string
                            {
                                if( msg.count > 0)
                                {
                                    message = msg
                                }
                            }
                        }
                        
                        let alertView = UIAlertController(title: NSLocalizedString("MSG31", comment: "").uppercased(), message: message, preferredStyle: .alert)
                        
                        let alertAction = UIAlertAction(title: NSLocalizedString("MSG18", comment: ""), style: .default) { (alert) in
                            
                            KeyConstant.sharedAppDelegate.setRoot()
                        }
                        
                        alertAction.setValue(AppColors.SelcetedColor, forKey: "titleTextColor")
                        
                        alertView.addAction(alertAction)
                        
                        let msgFont = [NSAttributedString.Key.font: UIFont(name: FontLocalization.medium.strValue, size: 15.0)!]
                        let msgAttrString = NSMutableAttributedString(string: message, attributes: msgFont)
                        alertView.setValue(msgAttrString, forKey: "attributedMessage")
                        
                        vc.present(alertView, animated: true, completion: nil)
                        
                        
                    }
                    
                    
                }
                
                
                
                /*
                 
                 var mesg = NSLocalizedString("MSG192", comment: "")
                 
                 if let guest = json["result"]["signup_type"].string
                 {
                 if(guest.lowercased() == "guest")
                 {
                 mesg = NSLocalizedString("MSG409", comment: "")
                 }
                 }
                 
                 
                 let alertView = UIAlertController(title: NSLocalizedString("MSG31", comment: "").uppercased(), message: mesg, preferredStyle: .alert)
                 
                 let alertAction = UIAlertAction(title: NSLocalizedString("MSG18", comment: ""), style: .default) { (alert) in
                 
                 //SignupViewModel().logoutOnly(vc: vc)
                 
                 //                    if(isPresentGuestSignup == true)
                 //                    {
                 //
                 //
                 //                        vc.dismiss(animated: true, completion: {
                 //
                 //                            let loginVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                 //                            loginVC.isPresentFromMenu = false
                 //                            loginVC.isPresentFromCheckOut = true
                 //                            loginVC.delegateReloadData  = delegateReloadData
                 //                            vc.present(loginVC, animated: false, completion: nil)
                 //                            return
                 //
                 //                        })
                 //
                 //
                 //
                 //
                 //                    }
                 //                    else
                 //                    {
                 //
                 vc.dismiss(animated: true, completion: nil)
                 // }
                 
                 }
                 alertAction.setValue(UIColor(red: 175.0/255.0, green: 148.0/255.0, blue: 50.0/255.0, alpha: 1.0), forKey: "titleTextColor")
                 let msgFont = [NSAttributedString.Key.font: UIFont(name: "Futura-Medium", size: 15.0)!]
                 let msgAttrString = NSMutableAttributedString(string: mesg, attributes: msgFont)
                 alertView.setValue(msgAttrString, forKey: "attributedMessage")
                 alertView.addAction(alertAction)
                 vc.present(alertView, animated: true, completion: nil)
                 */
                
                
            }
            else
            {
                
                
                
                var message = json["message"].string
                
                if(HelperArabic().isArabicLanguage())
                {
                    if let msg = json["message_ar"].string
                    {
                        if( msg.count > 0)
                        {
                            message = msg
                        }
                    }
                }
                
                KeyConstant.sharedAppDelegate.showAlertView(vc: vc,titleString:NSLocalizedString("MSG31", comment: ""), messageString:message ?? NSLocalizedString("MSG21", comment: ""))
                
                
            }
            
        })
        
        
    }
    
    func forgotPassword(vc:UIViewController, params:[String:String])
    {
        
        
        MBProgress().showIndicator(view: vc.view)
        
        
        WebServiceHelper.sharedInstanceAPI.hitPostAPI(urlString: KeyConstant.APIForgotPassword, params: params, completionHandler: { (result: [String:Any], err:Error?) in
            print(result)
            MBProgress().hideIndicator(view: vc.view)
            
            if(!(err == nil))
            {
                KeyConstant.sharedAppDelegate.showAlertView(vc: vc,titleString:NSLocalizedString("MSG31", comment: ""), messageString:err?.localizedDescription ?? NSLocalizedString("MSG21", comment: ""))
                
                return
            }
            let json = JSON(result)
            
            let statusCode = json["status"].string
            
            if(statusCode == "success")
            {
                
                
                var message = json["message"].string
                
                if(HelperArabic().isArabicLanguage())
                {
                    if let msg = json["message_ar"].string
                    {
                        if( msg.count > 0)
                        {
                            message = msg
                        }
                    }
                }
                
                let alertView = UIAlertController(title: NSLocalizedString("MSG31", comment: "").uppercased(), message: message, preferredStyle: .alert)
                
                let alertAction = UIAlertAction(title: NSLocalizedString("MSG18", comment: ""), style: .default) { (alert) in
                    
                    vc.dismiss(animated: false, completion: nil)
                }
                alertAction.setValue(AppColors.SelcetedColor, forKey: "titleTextColor")
                
                alertView.addAction(alertAction)
                let msgFont = [NSAttributedString.Key.font: UIFont(name: FontLocalization.medium.strValue, size: 15.0)!]
                let msgAttrString = NSMutableAttributedString(string: message ?? "", attributes: msgFont)
                alertView.setValue(msgAttrString, forKey: "attributedMessage")
                vc.present(alertView, animated: true, completion: nil)
                
                
            }
            else
            {
                
                
                
                var message = json["message"].string
                
                if(HelperArabic().isArabicLanguage())
                {
                    if let msg = json["message_ar"].string
                    {
                        if( msg.count > 0)
                        {
                            message = msg
                        }
                    }
                }
                
                KeyConstant.sharedAppDelegate.showAlertView(vc: vc,titleString:NSLocalizedString("MSG31", comment: ""), messageString:message ?? NSLocalizedString("MSG21", comment: ""))
                
                
            }
            
        })
        
        
    }
    func logoutOnly(vc:UIViewController)
    {
        
        
        MBProgress().showIndicator(view: vc.view)
        let user_id = KeyConstant.sharedAppDelegate.getUserId()
        
        
        WebServiceHelper.sharedInstanceAPI.hitPostAPI(urlString: KeyConstant.APILogout, params: ["device_id":KeyConstant.user_Default.value(forKey: KeyConstant.kDeviceToken) as? String ?? "","email":KeyConstant.user_Default.value(forKey: KeyConstant.kuserEmail) as? String ?? "","user_id":user_id], completionHandler: { (result: [String:Any], err:Error?) in
            print(result)
            MBProgress().hideIndicator(view: vc.view)
            
            if(!(err == nil))
            {
                KeyConstant.sharedAppDelegate.showAlertView(vc: vc,titleString:NSLocalizedString("MSG31", comment: ""), messageString:err?.localizedDescription ?? NSLocalizedString("MSG21", comment: ""))
                
                return
            }
            
            self.removeKe()
            
            
        })
        
        
    }
    func logout(vc:UIViewController)
    {
        
        
        MBProgress().showIndicator(view: vc.view)
        let user_id = KeyConstant.sharedAppDelegate.getUserId()
        
        
        WebServiceHelper.sharedInstanceAPI.hitPostAPI(urlString: KeyConstant.APILogout, params: ["device_id":KeyConstant.user_Default.value(forKey: KeyConstant.kDeviceToken) as? String ?? "","email":KeyConstant.user_Default.value(forKey: KeyConstant.kuserEmail) as? String ?? "","user_id":user_id], completionHandler: { (result: [String:Any], err:Error?) in
            print(result)
            MBProgress().hideIndicator(view: vc.view)
            
            if(!(err == nil))
            {
                KeyConstant.sharedAppDelegate.showAlertView(vc: vc,titleString:NSLocalizedString("MSG31", comment: ""), messageString:err?.localizedDescription ?? NSLocalizedString("MSG21", comment: ""))
                
                return
            }
            let json = JSON(result)
            
            let statusCode = json["status"].string
            
            if(statusCode == "success")
            {
                
                
                var message = json["message"].string
                
                if(HelperArabic().isArabicLanguage())
                {
                    if let msg = json["message_ar"].string
                    {
                        if( msg.count > 0)
                        {
                            message = msg
                        }
                    }
                }
                
                let alertView = UIAlertController(title: NSLocalizedString("MSG31", comment: "").uppercased(), message: message, preferredStyle: .alert)
                
                let alertAction = UIAlertAction(title: NSLocalizedString("MSG18", comment: ""), style: .default) { (alert) in
                    
                    self.removeKeysT()
                    
                    
                }
                alertAction.setValue(AppColors.SelcetedColor, forKey: "titleTextColor")
                let msgFont = [NSAttributedString.Key.font: UIFont(name: FontLocalization.medium.strValue, size: 15.0)!]
                let msgAttrString = NSMutableAttributedString(string: message ?? "", attributes: msgFont)
                alertView.setValue(msgAttrString, forKey: "attributedMessage")
                alertView.addAction(alertAction)
                vc.present(alertView, animated: true, completion: nil)
                
                
            }
            else
            {
                
                
                
                var message = json["message"].string
                
                if(HelperArabic().isArabicLanguage())
                {
                    if let msg = json["message_ar"].string
                    {
                        if( msg.count > 0)
                        {
                            message = msg
                        }
                    }
                }
                
                
                KeyConstant.sharedAppDelegate.showAlertView(vc: vc,titleString:NSLocalizedString("MSG31", comment: ""), messageString:message ?? NSLocalizedString("MSG21", comment: ""))
                
                self.removeKeysT()
            }
            
        })
        
        
    }
    
    func removeKe()
    {
        KeyConstant.user_Default.removeObject(forKey: KeyConstant.kuserId)
        KeyConstant.user_Default.removeObject(forKey: KeyConstant.kuserName)
        KeyConstant.user_Default.removeObject(forKey: KeyConstant.kuserEmail)
        KeyConstant.user_Default.removeObject(forKey: KeyConstant.kUserSessionTempId)
        KeyConstant.user_Default.removeObject(forKey: KeyConstant.kGuestSaveDeviceID)
        KeyConstant.user_Default.removeObject(forKey: KeyConstant.kCheckoutGuestId)
        let myId =  KeyConstant.sharedAppDelegate.getUserId()
    }
    func removeKeysT()
    {
        self.removeKe()
        KeyConstant.sharedAppDelegate.setRoot()
    }
}
