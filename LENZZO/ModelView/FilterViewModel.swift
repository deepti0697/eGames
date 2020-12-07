//
//  FilterViewModel.swift
//  LENZZO
//
//  Created by Apple on 9/19/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON


class FilterViewModel
{
    
    func getAlFilterData(vc:UIViewController, completionHandler:@escaping (_ success:Bool, _ errorC : Error?) -> Void)
    {
        
        MBProgress().showIndicator(view: vc.view)
        
        FilterDataModel.sharedInstance.arrayList.removeAll()
        
        WebServiceHelper.sharedInstanceAPI.hitPostAPI(urlString: KeyConstant.APIGetFilterData, params: [:], completionHandler: { (result: [String:Any], err:Error?) in
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
                if let responseArray = json["response"].array
                {
                    FilterDataModel.sharedInstance.addAllData(arrayData: responseArray)
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
