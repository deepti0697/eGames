//
//  ProductListViewModel.swift
//  LENZZO
//
//  Created by Apple on 8/21/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire


class ProductListViewModel
{
    func getBrandCatProductList(vc:UIViewController, itemId:String,APIName:String,sortIndex:[String:String],customParam:[String:String],filterParam:[String:String],  completionHandler:@escaping (_ result:[JSON], _ success:Bool, _ errorC : Error?) -> Void)
    {
        
        MBProgress().showIndicator(view: vc.view)
        var prama:[String:String]
        
        if(APIName == KeyConstant.APIProductSearchByName)
        {
            prama = ["brand_id":itemId]
        }
        else if(APIName == KeyConstant.APIViewWishlist)
        {
            
            prama = ["user_id":KeyConstant.sharedAppDelegate.getUserId()]
        }
        else
        {
            prama = [:]
            
        }
        
        /* sortIndex 0 = "MSG226"   1= "MSG227"    2= "MSG228"
         
         high to low : key: price, value: DESC
         low  to high : key: price, value: ASC
         Latest : key: created_at, value: DESC */
        if(sortIndex.count > 0)
        {
            let replacingCurrent = prama.merging(sortIndex) {
                (_, new) in new
                
            }
            prama = replacingCurrent
        }
        
        
        
        //for  tags data and search data
        if(customParam.count > 0)
        {
            let replacingCurrent = prama.merging(customParam) {
                (_, new) in new
                
            }
            prama = replacingCurrent
        }
        
        if(filterParam.count > 0)
        {
            let replacingCurrentFilter = prama.merging(filterParam) {
                (_, new) in new
                
            }
            prama = replacingCurrentFilter
        }
        
        let current_currency = KeyConstant.user_Default.value(forKey: KeyConstant.kSelectedCurrency) as! String
        prama["current_currency"] = current_currency.uppercased()
        print("updated dic data: \(prama)")
        
        WebServiceHelper.sharedInstanceAPI.hitPostAPI(urlString: KeyConstant.APIProductSearchByName, params: prama, completionHandler: { (result: [String:Any], err:Error?) in
            print(result)
            MBProgress().hideIndicator(view: vc.view)
            if(!(err == nil))
            {
                completionHandler([JSON](),false,err)
                
                
                return
            }
            let json = JSON(result)
            
            let statusCode = json["status"].string
           // print(json)
            if(statusCode == "success")
            {
                
              //  print(result)
                if let responseDic = json["response"].dictionary
                {
                    
                    ProductListModel.sharedInstance.addAllData(dicData: responseDic)
                    
                }
                
         //mm       print(json["response"]["product_list_Array"]["product_list"].array)
                completionHandler(json["response"]["product_list_Array"]["product_list"].array ?? [JSON](),true,err)
                
            }
            else
            {
                
                completionHandler([JSON](),false,err)
                
            }
            
        })
        
        
    }
    
    //    func filterGetBrandCatProductList(vc:UIViewController, itemId:String,APIName:String,sortIndex:Int,customParam:[String:String],filterData:[String:AnyObject],filterRating:String,  completionHandler:@escaping (_ result:[JSON], _ success:Bool, _ errorC : Error?) -> Void)
    //    {
    //
    //        MBProgress().showIndicator(view: vc.view)
    //        //var prama:[String:String]
    //        var parameters = [String: AnyObject]()
    //
    //
    //
    //        if(APIName == KeyConstant.APIBrandProductList)
    //        {
    //            parameters = ["brand_id":itemId] as [String : AnyObject]
    //        }
    //        else if(APIName == KeyConstant.APIViewWishlist)
    //        {
    //
    //            parameters = ["user_id":KeyConstant.sharedAppDelegate.getUserId()] as [String : AnyObject]
    //        }
    //        else
    //        {
    //            parameters = [:]
    //
    //        }
    //
    //        /* sortIndex 0 = "MSG226"   1= "MSG227"    2= "MSG228"
    //
    //         high to low : key: price, value: DESC
    //         low  to high : key: price, value: ASC
    //         Latest : key: created_at, value: DESC */
    //        switch(sortIndex)
    //        {
    //        case 0:
    //            parameters["key"] = "created_at" as AnyObject
    //            parameters["value"] = "DESC" as AnyObject
    //            break
    //        case 1:
    //
    //            parameters["key"] = "price" as AnyObject
    //            parameters["value"] = "ASC" as AnyObject
    //            break
    //        case 2:
    //            parameters["key"] = "price" as AnyObject
    //            parameters["value"] = "DESC" as AnyObject
    //            break
    //        default:
    //            break
    //        }
    //
    //
    //        //for  tags data and search data
    //        if(customParam.count > 0)
    //        {
    //            let replacingCurrent = parameters.merging(customParam as [String : AnyObject]) {
    //                (_, new) in new
    //
    //            }
    //            parameters = replacingCurrent
    //        }
    //
    //        if(filterData.count > 0)
    //        {
    //
    //            parameters["brand_id"] = filterData["brand_id"] as AnyObject
    //            parameters["tags"] = filterData["tags"] as AnyObject
    //            parameters["color"] = filterData["color"] as AnyObject
    //            parameters["rating"] = filterRating as AnyObject
    //
    //        }
    //
    //        print(parameters)
    //
    //
    //
    //        WebServiceHelper.sharedInstanceAPI.hitPostAPIINJSON(urlString: KeyConstant.APIBrandProductList, params: parameters, completionHandler: { (result: [String:Any], err:Error?) in
    //            print(result)
    //            MBProgress().hideIndicator(view: vc.view)
    //            if(!(err == nil))
    //            {
    //                completionHandler([JSON](),false,err)
    //
    //
    //                return
    //            }
    //            let json = JSON(result)
    //
    //            let statusCode = json["status"].string
    //            print(json)
    //            if(statusCode == "success")
    //            {
    //
    //                print(result)
    //                if let responseDic = json["response"].dictionary
    //                {
    //
    //                    ProductListModel.sharedInstance.addAllData(dicData: responseDic)
    //
    //                }
    //                completionHandler(json["response"]["product_list_Array"]["product_list"].array ?? [JSON](),true,err)
    //
    //            }
    //            else
    //            {
    //
    //                completionHandler([JSON](),false,err)
    //
    //            }
    //
    //        })
    //    }
    
}
