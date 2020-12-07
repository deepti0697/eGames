//
//  FilterDataModel.swift
//  LENZZO
//
//  Created by Apple on 9/19/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

struct FilterDataModel
{
    
    static var sharedInstance = FilterDataModel()
    private init() { }
    
    var arrayList = [FilterInfo]()
    
    
    struct FilterInfo
    {
        var arrayData:[JSON]
        var title:String!
        var slug:String!
        
        
        init(arrayData:[JSON], title:String, slug:String)
        {
            
            self.title = title
            self.arrayData = arrayData
            self.slug = slug
            
        }
    }
    
    mutating func addAllData(arrayData:[JSON])
    {
        arrayList.removeAll()
        if(arrayData.count > 0)
        {
            for i in 0..<arrayData.count
            {
                var title = arrayData[i]["title"].string ?? ""
                if(HelperArabic().isArabicLanguage())
                {
                    if let title_ar = arrayData[i]["title_ar"].string
                    {
                        if(title_ar.count > 0)
                        {
                            title = title_ar
                        }
                    }
                }
                
                
                self.arrayList.append(FilterInfo(arrayData: arrayData[i]["list"].array ?? [JSON](), title: title, slug: arrayData[i]["slug"].string ?? ""))
                
            }
        }
    }
    
}

