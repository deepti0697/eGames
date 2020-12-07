//
//  HomeModelView.swift
//  LENZZO
//
//  Created by Apple on 8/20/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON


class HomeModelView
{
    
    
    func getAllHomeInfo(vc:UIViewController, completionHandler:@escaping (_ success:Bool, _ errorC : Error?) -> Void)
    {
        
        MBProgress().showIndicator(view: vc.view)
        
        
        
        WebServiceHelper.sharedInstanceAPI.hitPostAPI(urlString: KeyConstant.APIHomeInfo, params: [:], completionHandler: { (result: [String:Any], err:Error?) in
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
                    HomeInfoModel.sharedInstance.addAllData(dicData: responseDic)
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
