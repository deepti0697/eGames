//
//  WishListViewModel.swift
//  LENZZO
//
//  Created by Apple on 8/23/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON


class WishListViewModel
{
    
    func getAllWishlistProduct(vc:UIViewController, completionHandler:@escaping (_ success:Bool, _ errorC : Error?) -> Void)
    {
        
        MBProgress().showIndicator(view: vc.view)
        
        let current_currency = KeyConstant.user_Default.value(forKey: KeyConstant.kSelectedCurrency) as! String
        
        
        WebServiceHelper.sharedInstanceAPI.hitPostAPI(urlString: KeyConstant.APIViewWishlist, params: ["user_id":KeyConstant.sharedAppDelegate.getUserId(),"current_currency":current_currency.uppercased()], completionHandler: { (result: [String:Any], err:Error?) in
            print(result)
            MBProgress().hideIndicator(view: vc.view)
            if(!(err == nil))
            {
                completionHandler(false,err)
                
                
                return
            }
            let json = JSON(result)
            
            let statusCode = json["status"].string
            print(json)
            if(statusCode == "success")
            {
                
                print(result)
                if let responseDic = json["response"].dictionary
                {
                    WishListModel.sharedInstance.addAllData(dicData: responseDic)
                }
                completionHandler(true,err)
                
            }
            else
            {
                
                completionHandler(false,err)
                
            }
            
        })
        
        
        
    }
    
    
    
    func addToWishlist(vc:UIViewController, param:[String:String], completionHandler:@escaping (_ success:Bool, _ errorC : Error?) -> Void)
    {
        
        MBProgress().showIndicator(view: vc.view)
        
        
        
        WebServiceHelper.sharedInstanceAPI.hitPostAPI(urlString: KeyConstant.APIAddWishlist, params: param, completionHandler: { (result: [String:Any], err:Error?) in
            print(result)
            MBProgress().hideIndicator(view: vc.view)
            if(!(err == nil))
            {
                completionHandler(false,err)
                
                
                return
            }
            let json = JSON(result)
            
            let statusCode = json["status"].string
            print(json)
            if(statusCode == "success")
            {
                
                print(result)
                
                completionHandler(true,err)
                
            }
            else
            {
                
                completionHandler(false,err)
                
            }
            
        })
        
        
        
    }
}

