//
//  WhatsappVC.swift
//  LENZZO
//
//  Created by sanjay mac on 25/07/20.
//  Copyright © 2020 LENZZO. All rights reserved.
//

import UIKit

class WhatsappVC: UIViewController {

   private var strWhatsappNumber = "+96594906684"//"+96599454974"//"+96567696747"

    override func viewDidLoad() {
        super.viewDidLoad()

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: Notification.Name("applicationWillEnterForeground"), object: nil)
        }

    @objc func appMovedToForeground() {
            print("App moved to ForeGround!")
            
        if self.tabBarController?.selectedIndex != nil{
            self.tabBarController?.selectedIndex = 0
            return
        }
        else{
          self.getContactsData()
        }
        
        }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getContactsData()
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    //MARK:- getContactsData
       
       func getContactsData()
       {
           
           
          self.strWhatsappNumber = "+96594906684"//"+96599454974"//"+96567696747"
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
                           
                        KeyConstant.sharedAppDelegate.showAlertView(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG437", comment: ""))
                           
                           
                           
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
