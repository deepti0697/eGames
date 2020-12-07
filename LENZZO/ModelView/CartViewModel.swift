//
//  CartViewModel.swift
//  LENZZO
//
//  Created by Apple on 9/3/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import UIKit
import SwiftyJSON

class CartViewModel
{
    func addToCart(vc:UIViewController, param:[String:String], completionHandler:@escaping (_ success:Bool, _ errorC : Error?) -> Void)
    {
        
        MBProgress().showIndicator(view: vc.view)
        
        
        
        WebServiceHelper.sharedInstanceAPI.hitPostAPI(urlString: KeyConstant.APIAddCart, params: param, completionHandler: { (result: [String:Any], err:Error?) in
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
    
    func viewCartListWithoutLoader(vc:UIViewController, param:[String:String], completionHandler:@escaping (_ result:[JSON], _ totalCount:String ,_ errorC : Error?) -> Void)
    {
        
        
        let currency = KeyConstant.user_Default.value(forKey: KeyConstant.kSelectedCurrency) as! String
        var pramas:[String:String] = ["current_currency":currency.uppercased()]
        
        if(param.count > 0)
        {
            let replacingCurrent = pramas.merging(param) {
                (_, new) in new
                
            }
            pramas = replacingCurrent
        }
        
        
        WebServiceHelper.sharedInstanceAPI.hitPostAPI(urlString: KeyConstant.APIMyCartList, params: pramas, completionHandler: { (result: [String:Any], err:Error?) in
            print(result)
            if(!(err == nil))
            {
                completionHandler([JSON](),"0",err)
                
                
                return
            }
            let json = JSON(result)
            
            let statusCode = json["status"].string
            print(json)
            if(statusCode == "success")
            {
                
                
                completionHandler(json["response"]["usercart_Array"]["usercart"].array ?? [JSON]() ,String(json["response"]["usercart_Array"]["totalcount"].int ?? 0),err)
                
            }
            else
            {
                
                completionHandler([JSON](),"0",err)
                
            }
            
        })
        
        
        
    }
    
    
    func viewCartList(vc:UIViewController, param:[String:String], completionHandler:@escaping (_ result:[JSON], _ totalCount:String ,_ errorC : Error?) -> Void)
    {
        
        
        
        guard let currency = KeyConstant.user_Default.value(forKey: KeyConstant.kSelectedCurrency) as? String else{
            return
        }
        var pramas:[String:String] = ["current_currency":currency.uppercased()]
        
        if(param.count > 0)
        {
            let replacingCurrent = pramas.merging(param) {
                (_, new) in new
                
            }
            pramas = replacingCurrent
        }
        
        MBProgress().showIndicator(view: vc.view)
        WebServiceHelper.sharedInstanceAPI.hitPostAPI(urlString: KeyConstant.APIMyCartList, params: pramas, completionHandler: { (result: [String:Any], err:Error?) in
            print(result)
            MBProgress().hideIndicator(view: vc.view)
            if(!(err == nil))
            {
                completionHandler([JSON](),"0",err)
                
                
                return
            }
            let json = JSON(result)
            
            let statusCode = json["status"].string
            print(json)
            if(statusCode == "success")
            {
                
                
                completionHandler(json["response"]["usercart_Array"]["usercart"].array ?? [JSON](),String(json["response"]["usercart_Array"]["totalcount"].int ?? 0) ,err)
                
            }
            else
            {
                
                completionHandler([JSON](),"0",err)
                
            }
            
        })
        
        
        
    }
    
    
    
    func deleteToCart(vc:UIViewController, param:[String:String], completionHandler:@escaping (_ success:Bool, _ errorC : Error?) -> Void)
    {
        
        MBProgress().showIndicator(view: vc.view)
        
        
        WebServiceHelper.sharedInstanceAPI.hitPostAPI(urlString: KeyConstant.APIMyCartDelete, params: param, completionHandler: { (result: [String:Any], err:Error?) in
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
    
    
    func updateToCart(vc:UIViewController, param:[String:String], completionHandler:@escaping (_ success:Bool, _ errorC : Error?) -> Void)
    {
        
        MBProgress().showIndicator(view: vc.view)
        
        
        
        WebServiceHelper.sharedInstanceAPI.hitPostAPI(urlString: KeyConstant.APIMyCartUpdate, params: param, completionHandler: { (result: [String:Any], err:Error?) in
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
    
    func moveToWishlistFromCart(vc:UIViewController, param:[String:String], completionHandler:@escaping (_ success:Bool, _ errorC : Error?) -> Void)
    {
        
        MBProgress().showIndicator(view: vc.view)
        
        
        
        WebServiceHelper.sharedInstanceAPI.hitPostAPI(urlString: KeyConstant.APIMyCartMoveWishlist, params: param, completionHandler: { (result: [String:Any], err:Error?) in
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
    
    
    
    
    func deleteToAddress(vc:UIViewController, param:[String:String], completionHandler:@escaping (_ success:Bool, _ errorC : Error?) -> Void)
    {
        
        MBProgress().showIndicator(view: vc.view)
        
        
        
        WebServiceHelper.sharedInstanceAPI.hitPostAPI(urlString: KeyConstant.APIdeleteAddress, params: param, completionHandler: { (result: [String:Any], err:Error?) in
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
    
    
    
    
    
    func myOrderList(vc:UIViewController, param:[String:String], completionHandler:@escaping (_ result:[JSON], _ errorC : Error?) -> Void)
    {
        
        MBProgress().showIndicator(view: vc.view)
        
        
        
        WebServiceHelper.sharedInstanceAPI.hitPostAPI(urlString: KeyConstant.APIMyOrdersList, params: param, completionHandler: { (result: [String:Any], err:Error?) in
            print(result)
            MBProgress().hideIndicator(view: vc.view)
            if(!(err == nil))
            {
                completionHandler([JSON](),err)
                
                
                return
            }
            let json = JSON(result)
            
            let statusCode = json["status"].string
            print(json)
            if(statusCode == "success")
            {
                
                print(result)
                
                completionHandler(json["response"]["orderlist_Array"]["orderlist"].array ?? [JSON]() ,err)
                
            }
            else
            {
                
                completionHandler([JSON](),err)
                
            }
            
        })
        
        
        
    }
    
    
    
    func getMyLoyaltyPoints(vc:UIViewController, param:[String:String], completionHandler:@escaping (_ result:[String:JSON], _ errorC : Error?) -> Void)
    {
        
        MBProgress().showIndicator(view: vc.view)
        
        
        WebServiceHelper.sharedInstanceAPI.hitPostAPI(urlString: KeyConstant.APIGetMyPoints, params: ["user_id":KeyConstant.user_Default.value(forKey: KeyConstant.kuserId) as? String ?? "","current_currency":KeyConstant.user_Default.value(forKey: KeyConstant.kSelectedCurrency) as? String ?? ""], completionHandler: { (result: [String:Any], err:Error?) in
            print(result)
            MBProgress().hideIndicator(view: vc.view)
            if(!(err == nil))
            {
                completionHandler([String:JSON](),err)
                
                
                return
            }
            let json = JSON(result)
            
            let statusCode = json["status"].string
            print(json)
            if(statusCode == "success")
            {
                
                print(result)
                
                completionHandler(json.dictionary ?? [String:JSON]() ,err)
                
            }
            else
            {
                
                completionHandler([String:JSON](),err)
                
            }
            
        })
        
        
        
    }
    
    
    func getMyEarnLoyaltyPoints(vc:UIViewController, param:[String:String], completionHandler:@escaping (_ result:[String:JSON], _ errorC : Error?) -> Void)
    {
        
        MBProgress().showIndicator(view: vc.view)
        
        
        WebServiceHelper.sharedInstanceAPI.hitPostAPI(urlString: KeyConstant.APIEarnRedeemPoints, params: param, completionHandler: { (result: [String:Any], err:Error?) in
            print(result)
            MBProgress().hideIndicator(view: vc.view)
            if(!(err == nil))
            {
                completionHandler([String:JSON](),err)
                
                
                return
            }
            let json = JSON(result)
            
            let statusCode = json["status"].string
            print(json)
            if(statusCode == "success")
            {
                
                print(result)
                
                completionHandler(json.dictionary ?? [String:JSON]() ,err)
                
            }
            else
            {
                
                completionHandler([String:JSON](),err)
                
            }
            
        })
        
        
        
    }
    
    
    func getCollectionBanner(vc:UIViewController, param:[String:String], completionHandler:@escaping (_ result:[String:JSON], _ errorC : Error?) -> Void)
    {
        
        MBProgress().showIndicator(view: vc.view)
        
        
        
        WebServiceHelper.sharedInstanceAPI.hitPostAPI(urlString: KeyConstant.APISliderBannerCollection, params: param, completionHandler: { (result: [String:Any], err:Error?) in
            print(result)
            MBProgress().hideIndicator(view: vc.view)
            if(!(err == nil))
            {
                completionHandler([String:JSON](),err)
                
                
                return
            }
            let json = JSON(result)
            
            let statusCode = json["status"].string
            print(json)
            if(statusCode == "success")
            {
                
                print(result)
                
                completionHandler(json["response"].dictionary ?? [String:JSON]() ,err)
                
            }
            else
            {
                
                completionHandler([String:JSON](),err)
                
            }
            
        })
        
        
        
    }
    
    
    
    func getChildList(vc:UIViewController, param:[String:String], completionHandler:@escaping (_ result:[JSON], _ errorC : Error?) -> Void)
    {
        
        MBProgress().showIndicator(view: vc.view)
        
        
        
        WebServiceHelper.sharedInstanceAPI.hitPostAPI(urlString: KeyConstant.APIGetChildFromBrand, params: param, completionHandler: { (result: [String:Any], err:Error?) in
            print(result)
            MBProgress().hideIndicator(view: vc.view)
            if(!(err == nil))
            {
                completionHandler([JSON](),err)
                
                
                return
            }
            let json = JSON(result)
            
            let statusCode = json["status"].string
            print(json)
            if(statusCode == "success")
            {
                
                print(result)
                
                completionHandler(json["response"]["child"].array ?? [JSON]() ,err)
                
            }
            else
            {
                
                completionHandler([JSON](),err)
                
            }
            
        })
        
        
        
    }
}
