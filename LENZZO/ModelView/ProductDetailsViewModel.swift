//
//  ProductViewModel.swift
//  LENZZO
//
//  Created by Apple on 8/22/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class ProductDetailsViewModel
{
    
    
    func getProductDetailsJSON(vc:UIViewController, productId:String,  completionHandler:@escaping (_ result:[String:JSON], _ relatedArray:[JSON], _ ratingArray:[String:JSON], _ success:Bool, _ errorC : Error?) -> Void)
    {
        
        MBProgress().showIndicator(view: vc.view)
        let current_currency = KeyConstant.user_Default.value(forKey: KeyConstant.kSelectedCurrency) as! String
        
        WebServiceHelper.sharedInstanceAPI.hitPostAPI(urlString: KeyConstant.APIProductDetails, params: ["product_id":productId,"current_currency":current_currency.uppercased()], completionHandler: { (result: [String:Any], err:Error?) in
            print(result)
            MBProgress().hideIndicator(view: vc.view)
            if(!(err == nil))
            {
                completionHandler([String:JSON](),[JSON](),[String:JSON](),false,err)
                return
            }
            let json = JSON(result)
            
            let statusCode = json["status"].string
            print(json)
            if(statusCode == "success")
            {
                
                
                completionHandler(json["response"]["product_detail_Array"]["product_detail"].dictionary ?? [String:JSON](),json["response"]["related_product_list_Array"]["product_list"].array ?? [JSON](),json["response"]["product_rating_list_Array"].dictionary ?? [String:JSON](),true,err)
                
                
            }
            else
            {
                
                completionHandler([String:JSON](),[JSON](),[String:JSON](),false,err)
                
            }
            
        })
        
        
    }
}
