//
//  ProductListModel.swift
//  LENZZO
//
//  Created by Apple on 8/21/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON


class ProductListModel
{
    static var sharedInstance = ProductListModel()
    private init() { }
    
    var arrayProductList = [ProductInfo]()
    var sliderArr = [SliderInfo]()
    
    
    struct SliderInfo
    {
        var id:String!
        var name:String!
        var path:String!
        var slug:String!
        var status:String!
        var type:String!
        var product_id:String!
        var product_name:String!
        
        var brand_id:String!
        var brand_name:String!
        
        var offer_id:String!
        var offer_name:String!
        
        var category_id:String!
        var category_name:String!
        
        init(dictData:[String:JSON])
        {
            self.id = dictData["id"]?.string ?? ""
            self.name = dictData["name"]?.string ?? ""
            self.path = dictData["path"]?.string ?? ""
            
            if(HelperArabic().isArabicLanguage())
            {
                if let name =  dictData["name_ar"]?.string
                {
                    self.name = name
                }
                
                if let path =  dictData["path_ar"]?.string
                {
                    self.path = path
                }
            }
            
            
            
            self.slug = dictData["slug"]?.string ?? ""
            self.status = dictData["status"]?.string ?? ""
            self.type = dictData["type"]?.string ?? ""
            if let productId = dictData["product_id"]?.string
            {
                if(productId == "0")
                {
                    self.product_id = ""
                    self.product_name = ""
                    
                }
                else
                {
                    self.product_id = productId
                    self.product_name = dictData["product_title"]?.string ?? ""
                    if(HelperArabic().isArabicLanguage())
                    {
                        if let product_name =  dictData["product_title_ar"]?.string
                        {
                            self.product_name = product_name
                        }
                    }
                }
            }
            else
            {
                self.product_id = ""
                self.product_name = ""
                
            }
            
            if let brand_id = dictData["brand_id"]?.string
            {
                if( brand_id == "0")
                {
                    self.brand_id = ""
                    self.brand_name = ""
                }
                else
                {
                    self.brand_id = brand_id
                    self.brand_name = dictData["brand_name"]?.string ?? ""
                    if(HelperArabic().isArabicLanguage())
                    {
                        if let brand_name =  dictData["brand_name_ar"]?.string
                        {
                            self.brand_name = brand_name
                        }
                    }
                    
                }
            }
            else
            {
                self.brand_id = ""
                self.brand_name = ""
            }
            
            if let offer_id = dictData["offer_id"]?.string
            {
                if(offer_id == "0")
                {
                    self.offer_id = ""
                    self.offer_name = ""
                }
                else{
                    self.offer_id = offer_id
                    self.offer_name = dictData["offer_name"]?.string ?? ""
                    if(HelperArabic().isArabicLanguage())
                    {
                        if let offer_name =  dictData["offer"]?["offer_name_ar"].string
                        {
                            self.offer_name = offer_name
                        }
                    }
                }
            }
            else
            {
                self.offer_id = ""
                self.offer_name = ""
            }
            
            if let category_id = dictData["category_id"]?.string
            {
                
                if(category_id == "0")
                {
                    self.category_id = ""
                    self.category_name = ""
                }
                else
                {
                    self.category_id = category_id
                    self.category_name = dictData["category_name"]?.string ?? ""
                    if(HelperArabic().isArabicLanguage())
                    {
                        if let category_name =  dictData["category_name_ar"]?.string
                        {
                            self.category_name = category_name
                        }
                    }
                }
            }
            else
            {
                self.category_id = ""
                self.category_name = ""
            }
        }
    }
    
    
    struct ProductInfo
    {
        var id:String!
        var name:String!
        var product_image:String!
        var description:String!
        var price:String!
        var cate_id:String!
        
        var sale_price:String!
        
        var title:String!
        var quantity:String!
        var variations:String!
        
        var status:String!
        var tags:String!
        var stock_flag:String!
        var offer_id:String!
        var offer_name:String!
        
        var start_range:String!
        var wishlist:String!
        
        
        init(dictData:[String:JSON])
        {
            self.title = dictData["title"]?.string ?? ""
            self.wishlist = dictData["wishlist"]?.string ?? ""
            self.description = dictData["description"]?.string ?? ""
            if let offerName = dictData["offer_name"]?.string
            {
                self.offer_name = offerName
            }
            
            if(HelperArabic().isArabicLanguage())
            {
                if let title_ar =  dictData["title_ar"]?.string
                {
                    if(title_ar.count > 0)
                    {
                        self.title = title_ar
                    }
                    
                }
                if let description_ar =  dictData["description_ar"]?.string
                {
                    if(description_ar.count > 0)
                    {
                        self.description = description_ar
                    }
                }
                if let offerName_ar = dictData["offer"]?["name_ar"].string
                {
                    if(offerName_ar.count > 0)
                    {
                        self.offer_name = offerName_ar
                    }
                }
                
                
            }
            
            self.id = dictData["id"]?.string ?? ""
            self.name = dictData["cate_name"]?.string ?? ""
            self.product_image = dictData["product_image"]?.string ?? ""
            if let cate_id = dictData["cate_id"]?.int
            {
                self.cate_id = String(format:"%d",cate_id)
            }
            else
            {
                self.cate_id = dictData["cate_id"]?.string ?? ""
            }
            if let priceDouble = dictData["price"]?.double
            {
                self.price = String(format:"%.2f", priceDouble)
            }
            else if let priceInt = dictData["price"]?.int
            {
                self.price = String(format:"%d",priceInt)
            }
            else
            {
                self.price = dictData["price"]?.string ?? "0.0"
            }
            
            
            if let sale_price = dictData["sale_price"]?.double
            {
                self.sale_price = String(format:"%.2f", sale_price)
            }
            else if let sale_price = dictData["sale_price"]?.int
            {
                self.sale_price = String(format:"%d",sale_price)
            }
            else
            {
                self.sale_price = dictData["sale_price"]?.string ?? "0.0"
            }
            
            
            
            
            
            
            
            if let offerID = dictData["offer_id"]?.string
            {
                self.offer_id = offerID
            }
            self.status = dictData["status"]?.string ?? ""
            
            self.quantity = dictData["quantity"]?.string ?? ""
            self.variations = dictData["variation_color"]?.string ?? ""
            self.tags = dictData["tags"]?.string ?? ""
            self.stock_flag = dictData["stock_flag"]?.string ?? ""
            if let start_range = dictData["power"]?["start_range"].string
            {
                self.start_range = start_range
            }
            else{
                self.start_range = ""
            }
        }
    }
    func addAllData(dicData:[String:JSON])
    {
        self.arrayProductList.removeAll()
        
        if let arrayProductList = dicData["product_list_Array"]?["product_list"].array
        {
            for i in 0..<arrayProductList.count
            {
                self.arrayProductList.append(ProductInfo(dictData: arrayProductList[i].dictionary ?? [:]))
                
            }
        }
        
        if let arraySlider = dicData["banner_Array"]?["slider_list"].dictionary
        {
            
            self.sliderArr.removeAll()
            self.sliderArr.append(SliderInfo(dictData: arraySlider))
//            for i in 0..<arraySlider.count
//            {
//                self.sliderArr.append(SliderInfo(dictData: arraySlider[i].dictionary ?? [:]))
//
//            }
        }
        
        
    }
    
    func addSearchedData(arrData:[JSON])
    {
        self.arrayProductList.removeAll()
        
        if(arrData.count > 0)
        {
            for i in 0..<arrData.count
            {
                self.arrayProductList.append(ProductInfo(dictData: arrData[i].dictionary ?? [:]))
                
            }
        }
    }
    
}
