//
//  BrandModel.swift
//  LENZZO
//
//  Created by Apple on 8/21/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON


class BrandModel
{
    static var sharedInstance = BrandModel()
    private init() { }
    
    var arrayBrandList = [BrandInfo]()
    
    struct BrandInfo
    {
        var id:String!
        var name:String!
        var brand_image:String!
        var arrChild:[JSON]!
        var offer_id:String!
        var offer_name:String!
        var brand_slider_images:String!
        var image:String!
        
        
        init(dictData:[String:JSON])
        {
            self.id = dictData["id"]?.string ?? ""
            self.name = dictData["name"]?.string ?? ""
            self.brand_image = dictData["brand_image"]?.string ?? ""
            self.arrChild = dictData["child"]?.array ?? [JSON]()
            self.brand_slider_images = dictData["brand_slider_images"]?.string ?? ""
            self.image = dictData["offer"]?["image"].string ?? ""
            
            if let offerName = dictData["offer_subtitle"]?.string
            {
                self.offer_name = offerName
            }
            if let offerID = dictData["offer_id"]?.string
            {
                self.offer_id = offerID
            }
            
            if(HelperArabic().isArabicLanguage())
            {
                if let title_ar =  dictData["name_ar"]?.string
                {
                    if(title_ar.count > 0)
                    {
                        self.name = title_ar
                    }
                }
                if let offerName_ar = dictData["offer"]?["offer_subtitle_ar"].string
                {
                    if(offerName_ar.count > 0)
                    {
                        self.offer_name = offerName_ar
                    }
                }
            }
            
        }
    }
    
    func addAllData(dicData:[String:JSON])
    {
        self.arrayBrandList.removeAll()
        
        if let arraBrand = dicData["brand_Array"]?["brand_list"].array
        {
            for i in 0..<arraBrand.count
            {
                self.arrayBrandList.append(BrandInfo(dictData: arraBrand[i].dictionary ?? [:]))
                
            }
        }
    }
    
    func addFilterData(arrayData:[JSON])
    {
        self.arrayBrandList.removeAll()
        
        if (arrayData.count > 0)
        {
            for i in 0..<arrayData.count
            {
                self.arrayBrandList.append(BrandInfo(dictData: arrayData[i].dictionary ?? [:]))
                
            }
        }
    }
}
class BannerSliderCollection
{
    static var sharedInstance = BannerSliderCollection()
    private init() { }
    
    var arrayBrandList = [String:JSON]()
    
    
    func brandSlider(arrayData:[String:JSON])
    {
        self.arrayBrandList.removeAll()
        
        if (arrayData.count > 0)
        {
            self.arrayBrandList = arrayData
            
        }
    }
    
    
    
}
