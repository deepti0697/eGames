//
//  LoginSingupViewModel.swift
//  LENZZO
//
//  Created by Apple on 8/30/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON


class LoginViewModel
{
    let email: String!
    let password: String!
    
    
    init(userEmailLogin:LoginModel)
    {
        self.email = userEmailLogin.email
        self.password = userEmailLogin.password
        
    }
    
    
    func login(vc:LoginVC, isPresentFromMenu:Bool)
    {
        var strValue = ""
        
        
        if(HelperArabic().isArabicLanguage())
        {
            strValue = KeyConstant.kArabicCode
        }
        else{
            
            strValue = KeyConstant.kEnglishCode
        }
        
        MBProgress().showIndicator(view: vc.view)
        
        // "guestID":KeyConstant.user_Default.value(forKey: KeyConstant.kUserSessionTempId) as? String ?? ""
        WebServiceHelper.sharedInstanceAPI.hitPostAPI(urlString: KeyConstant.APILogin, params: ["device_id":KeyConstant.user_Default.value(forKey: KeyConstant.kDeviceToken) as? String ?? "2222222222222","email":email,"password":password,"guestid":KeyConstant.user_Default.value(forKey: KeyConstant.kUserSessionTempId) as? String ?? "","current_language": strValue], completionHandler: { (result: [String:Any], err:Error?) in
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
                if let dicData = json["response"].dictionary
                {
                    
                    
                    
                    if let userId = dicData["id"]?.string
                    {
                        
                        KeyConstant.user_Default.set(userId, forKey: KeyConstant.kuserId)
                        KeyConstant.user_Default.set(dicData["name"]?.string, forKey: KeyConstant.kuserName)
                        KeyConstant.user_Default.set(dicData["email"]?.string, forKey: KeyConstant.kuserEmail)
                        KeyConstant.user_Default.set(dicData["country_code"]?.string, forKey: KeyConstant.kuserCountryCode)
                        
                        KeyConstant.user_Default.removeObject(forKey: KeyConstant.kCheckoutGuestId)
                        
                        KeyConstant.user_Default.removeObject(forKey: KeyConstant.kUserSessionTempId)
                        
                        print(KeyConstant.user_Default.value(forKey: KeyConstant.kuserId))
                        
                        let alertView = UIAlertController(title: NSLocalizedString("MSG31", comment: "").uppercased(), message: NSLocalizedString("MSG193", comment: ""), preferredStyle: .alert)
                        
                        let alertAction = UIAlertAction(title: NSLocalizedString("MSG18", comment: ""), style: .default) { (alert) in
                            
                            if let strIsFromMyAccountTab =  KeyConstant.user_Default.value(forKey:KeyConstant.kSelectedTabBarIndex) as? String
                            {
                                if(vc.isPresentFromCheckOut == true)
                                {
                                    
                                    
                                    vc.dismiss(animated: true, completion: {
                                        if(vc.delegateReloadData != nil)
                                        {
                                            vc.delegateReloadData.reloadDataSelected()
                                        }
                                    })
                                    return
                                }
                                else
                                {
                                    if(strIsFromMyAccountTab == "3")
                                    {
                                        KeyConstant.sharedAppDelegate.setRoot()
                                        return
                                    }
                                }
                            }
                            
                            if(isPresentFromMenu == true)
                            {
                                KeyConstant.sharedAppDelegate.setRoot()
                                return
                            }
                            else
                            {
                                
                                
                                vc.dismiss(animated: true, completion: {
                                    if(vc.delegateReloadData != nil)
                                    {
                                        vc.delegateReloadData.reloadDataSelected()
                                    }
                                })
                                return
                            }
                            
                        }
                        alertAction.setValue(AppColors.SelcetedColor, forKey: "titleTextColor")
                        
                        alertView.addAction(alertAction)
                        
                        let msgFont = [NSAttributedString.Key.font: UIFont(name: FontLocalization.medium.strValue, size: 15.0)!]
                        let msgAttrString = NSMutableAttributedString(string: NSLocalizedString("MSG193", comment: ""), attributes: msgFont)
                        alertView.setValue(msgAttrString, forKey: "attributedMessage")
                        
                        vc.present(alertView, animated: true, completion: nil)
                        
                        
                        
                    }
                    
                    
                }
                
                
                
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
    
    
    
    
}
