//
//  BrandModelView.swift
//  LENZZO
//
//  Created by Apple on 8/21/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON


class BrandModelview
{
    
    func getAllBrandInfo(vc:UIViewController, brandId:String, completionHandler:@escaping (_ success:Bool, _ errorC : Error?) -> Void)
    {
        
        MBProgress().showIndicator(view: vc.view)
        
        
        
        WebServiceHelper.sharedInstanceAPI.hitPostAPI(urlString: KeyConstant.APIBrandList, params: [:], completionHandler: { (result: [String:Any], err:Error?) in
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
                    BrandModel.sharedInstance.addAllData(dicData: responseDic)
                }
                completionHandler(true,err)
                
            }
            else
            {
                
                completionHandler(false,err)
                
            }
            
        })
        
        
    }
    func getOfferBrandInfo(vc:UIViewController, offerType:String, completionHandler:@escaping (_ success:Bool, _ errorC : Error?) -> Void)
    {
        
        MBProgress().showIndicator(view: vc.view)
        
        
        let param = ["only_deal_otd":"1","user_id":KeyConstant.sharedAppDelegate.getUserId()]
        WebServiceHelper.sharedInstanceAPI.hitPostAPI(urlString: KeyConstant.APIViewOffers, params: param, completionHandler: { (result: [String:Any], err:Error?) in
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
                    OfferModel.sharedInstance.addAllData(dicData: responseDic)
                }
                completionHandler(true,err)
                
            }
            else
            {
                
                completionHandler(false,err)
                
            }
            
        })
        
        
    }
    
    func getAllBrandByCategory(vc:UIViewController, catId:String, completionHandler:@escaping (_ success:Bool, _ errorC : Error?) -> Void)
    {
        
        MBProgress().showIndicator(view: vc.view)
        
        
        
        WebServiceHelper.sharedInstanceAPI.hitPostAPI(urlString: KeyConstant.APIViewBrandOfCat, params: ["category_id":catId], completionHandler: { (result: [String:Any], err:Error?) in
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
                    BrandModel.sharedInstance.addAllData(dicData: responseDic)
                }
                completionHandler(true,err)
                
            }
            else
            {
                
                completionHandler(false,err)
                
            }
            
        })
        
        
    }
}
