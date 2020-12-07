//
//  HomeInfoModel.swift
//  LENZZO
//
//  Created by Apple on 8/20/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class HomeInfoModel
{
    static var sharedInstance = HomeInfoModel()
    private init() { }
    
    var arrayBanner = [BannerInfo]()
    var arraySlider = [SliderInfo]()
    var arrayProduct = [ProductInfo]()
    var arrayTopSelling = [TopSellingInfo]()
    var arrayTopBrand = [TopBrandInfo]()
    var arrayNewRelease = [NewReleaseInfo]()
    var appHeaderLogo = String()
    
    struct BannerInfo
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
        var is_redirect_deal_otd:String!
        
        init(dictData:[String:JSON])
        {
            self.id = dictData["id"]?.string ?? ""
            self.name = dictData["name"]?.string ?? ""
            self.path = dictData["path"]?.string ?? ""
            self.is_redirect_deal_otd = dictData["is_redirect_deal_otd"]?.string ?? ""
            if(HelperArabic().isArabicLanguage())
            {
                if let title_ar =  dictData["name_ar"]?.string
                {
                    self.name = title_ar
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
                        if let product_title =  dictData["product_title_ar"]?.string
                        {
                            self.product_name = product_title
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
        var brand_list:[JSON]!
        var categoryName:String!
        var categoryID:String!
        
        init(dictData:[String:JSON])
        {
            self.brand_list = dictData["brand_list"]?.array ?? [JSON]()
            self.categoryName = dictData["categoryName"]?.string ?? ""
            if(HelperArabic().isArabicLanguage())
            {
                if let title_ar =  dictData["categoryName_ar"]?.string
                {
                    if(title_ar.count > 0)
                    {
                        self.categoryName = title_ar
                    }
                }
            }
            self.categoryID = dictData["category_id"]?.string ?? ""
            
        }
    }
    
    
    struct TopSellingInfo
    {
        
        var brand_id:String!
        var brand_name:String!
        var cate_id:String!
        var cate_name:String!
        var current_currency:String!
        var description:String!
        var description_ar:String!
        var family_id:String!
        var family_name:String!
        var featured:String!
        var id:String!
        var is_hide:String!
        var model_no:String!
        var negotiable:String!
        var price:String!
        var product_image:String!
        var product_images:String!
        var quantity:String!
        var rating:String!
        var releted_product:String!
        var replacement:String!
        var reviewed:String!
        var sale_price:String!
        var sell_quantity:String!
        var status:String!
        var stock_flag:String!
        var tags:String! // best-selling
        var title:String!
        var title_ar:String!
        var user_id:String!
        var variation_color:String!
        var variations:String!
        var with_power_price:String!
        
        
        var categoryName:String!
        var categoryID:String!
        
        init(dictData:[String:JSON])
        {
          
          self.brand_id = dictData["brand_id"]?.string ?? ""
          self.brand_name = dictData["brand_name"]?.string ?? ""
          self.cate_id = dictData["cate_id"]?.string ?? ""
          self.cate_name = dictData["cate_name"]?.string ?? ""
          self.current_currency = dictData["current_currency"]?.string ?? ""
          self.description = dictData["description"]?.string ?? ""
          self.description_ar = dictData["description_ar"]?.string ?? ""
          self.family_id = dictData["family_id"]?.string ?? ""
          self.family_name = dictData["family_name"]?.string ?? ""
          self.featured = dictData["featured"]?.string ?? ""
          self.id = dictData["id"]?.string ?? ""
          self.is_hide = dictData["is_hide"]?.string ?? ""
          self.model_no = dictData["model_no"]?.string ?? ""
          self.negotiable = dictData["negotiable"]?.string ?? ""
          self.price = dictData["price"]?.string ?? ""
          self.product_image = dictData["product_image"]?.string ?? ""
          self.product_images = dictData["product_images"]?.string ?? ""
          self.quantity = dictData["quantity"]?.string ?? ""
          self.rating = dictData["rating"]?.string ?? ""
          self.releted_product = dictData["releted_product"]?.string ?? ""
          self.replacement = dictData["replacement"]?.string ?? ""
          self.reviewed = dictData["reviewed"]?.string ?? ""
          self.sale_price = dictData["sale_price"]?.string ?? ""
          self.sell_quantity = dictData["sell_quantity"]?.string ?? ""
          self.status = dictData["status"]?.string ?? ""
          self.stock_flag = dictData["stock_flag"]?.string ?? ""
          self.tags = dictData["tags"]?.string ?? ""
          self.title = dictData["title"]?.string ?? ""
          self.title_ar = dictData["title_ar"]?.string ?? ""
          self.user_id = dictData["user_id"]?.string ?? ""
          self.variation_color = dictData["variation_color"]?.string ?? ""
          self.variations = dictData["variations"]?.string ?? ""
          self.with_power_price = dictData["with_power_price"]?.string ?? ""
            
            
            
        }
    }
    
    struct TopBrandInfo
    {
        
        
        var brand_image:String!
        var brand_slider_images:String!
        var brand_slider_images_order:String!
        var category_id:String!
        var created_at:String!
        var diff_range:String!
        var diff_range_above:String!
        var end_range:String!
        var icon:String!
        var id:String!
        var name:String!
        var name_ar:String!
        var offer:String!
        var offer_collection:String!
        var offer_id:String!
        var offer_subtitle:String!
        var range_above:String!
        var slug:String!
        var start_range:String!
        var status:String!
        var ui_order:String!
        var updated_at:String!
        
        
        var brand_id:String!
        var brand_name:String!
        var cate_id:String!
        var cate_name:String!
        var current_currency:String!
        var description:String!
        var description_ar:String!
        var family_id:String!
        var family_name:String!
        var featured:String!
        var topbrand_childArr:[JSON]!
        
        
        init(dictData:[String:JSON])
        {
           
        self.brand_image = dictData["brand_image"]?.string ?? ""
        self.brand_slider_images = dictData["brand_slider_images"]?.string ?? ""
        self.brand_slider_images_order = dictData["brand_slider_images_order"]?.string ?? ""
        self.category_id = dictData["category_id"]?.string ?? ""
        self.created_at = dictData["created_at"]?.string ?? ""
        self.diff_range = dictData["diff_range"]?.string ?? ""
        self.diff_range_above = dictData["diff_range_above"]?.string ?? ""
        self.end_range = dictData["end_range"]?.string ?? ""
        self.icon = dictData["icon"]?.string ?? ""
        self.id = dictData["id"]?.string ?? ""
        self.name = dictData["name"]?.string ?? ""
        self.name_ar = dictData["name_ar"]?.string ?? ""
        self.offer = dictData["offer"]?.string ?? ""
        self.offer_collection = dictData["offer_collection"]?.string ?? ""
        self.offer_id = dictData["offer_id"]?.string ?? ""
        self.offer_subtitle = dictData["offer_subtitle"]?.string ?? ""
        self.range_above = dictData["range_above"]?.string ?? ""
        self.slug = dictData["slug"]?.string ?? ""
        self.start_range = dictData["start_range"]?.string ?? ""
        self.status = dictData["status"]?.string ?? ""
        self.ui_order = dictData["ui_order"]?.string ?? ""
        self.updated_at = dictData["updated_at"]?.string ?? ""
        self.brand_id = dictData["brand_id"]?.string ?? ""
        self.brand_name = dictData["brand_name"]?.string ?? ""
        self.cate_id = dictData["cate_id"]?.string ?? ""
        self.cate_name = dictData["cate_name"]?.string ?? ""
        self.current_currency = dictData["current_currency"]?.string ?? ""
        self.description = dictData["description"]?.string ?? ""
        self.description_ar = dictData["description_ar"]?.string ?? ""
        self.family_id = dictData["family_id"]?.string ?? ""
        self.family_name = dictData["family_name"]?.string ?? ""
        self.featured = dictData["featured"]?.string ?? ""
        self.topbrand_childArr = dictData["child"]?.array ?? [JSON]()
        
        }
    }
    
    
    struct NewReleaseInfo{
        
        
        var brand_image:String!
        var product_image:String!
        var brand_slider_images:String!
        var brand_slider_images_order:String!
        var category_id:String!
        var created_at:String!
        var diff_range:String!
        var diff_range_above:String!
        var end_range:String!
        var icon:String!
        var id:String!
        var name:String!
        var name_ar:String!
        var offer:String!
        var offer_collection:String!
        var offer_id:String!
        var offer_subtitle:String!
        var range_above:String!
        var slug:String!
        var start_range:String!
        var status:String!
        var ui_order:String!
        var updated_at:String!
        
        
        var brand_id:String!
        var brand_name:String!
        var cate_id:String!
        var cate_name:String!
        var current_currency:String!
        var description:String!
        var description_ar:String!
        var family_id:String!
        var family_name:String!
        var featured:String!
        var topbrand_childArr:[JSON]!
        
        
        init(dictData:[String:JSON])
        {
           
        self.brand_image = dictData["brand_image"]?.string ?? ""
        self.product_image = dictData["product_image"]?.string ?? ""
        self.brand_slider_images = dictData["brand_slider_images"]?.string ?? ""
        self.brand_slider_images_order = dictData["brand_slider_images_order"]?.string ?? ""
        self.category_id = dictData["category_id"]?.string ?? ""
        self.created_at = dictData["created_at"]?.string ?? ""
        self.diff_range = dictData["diff_range"]?.string ?? ""
        self.diff_range_above = dictData["diff_range_above"]?.string ?? ""
        self.end_range = dictData["end_range"]?.string ?? ""
        self.icon = dictData["icon"]?.string ?? ""
        self.id = dictData["id"]?.string ?? ""
        self.name = dictData["name"]?.string ?? ""
        self.name_ar = dictData["name_ar"]?.string ?? ""
        self.offer = dictData["offer"]?.string ?? ""
        self.offer_collection = dictData["offer_collection"]?.string ?? ""
        self.offer_id = dictData["offer_id"]?.string ?? ""
        self.offer_subtitle = dictData["offer_subtitle"]?.string ?? ""
        self.range_above = dictData["range_above"]?.string ?? ""
        self.slug = dictData["slug"]?.string ?? ""
        self.start_range = dictData["start_range"]?.string ?? ""
        self.status = dictData["status"]?.string ?? ""
        self.ui_order = dictData["ui_order"]?.string ?? ""
        self.updated_at = dictData["updated_at"]?.string ?? ""
        self.brand_id = dictData["brand_id"]?.string ?? ""
        self.brand_name = dictData["brand_name"]?.string ?? ""
        self.cate_id = dictData["cate_id"]?.string ?? ""
        self.cate_name = dictData["cate_name"]?.string ?? ""
        self.current_currency = dictData["current_currency"]?.string ?? ""
        self.description = dictData["description"]?.string ?? ""
        self.description_ar = dictData["description_ar"]?.string ?? ""
        self.family_id = dictData["family_id"]?.string ?? ""
        self.family_name = dictData["family_name"]?.string ?? ""
        self.featured = dictData["featured"]?.string ?? ""
        self.topbrand_childArr = dictData["child"]?.array ?? [JSON]()
        
        }
    }
    
    func addAllData(dicData:[String:JSON])
    {
        self.arrayBanner.removeAll()
        self.arraySlider.removeAll()
        self.arrayProduct.removeAll()
        self.appHeaderLogo = ""
        
        if let appLogo = dicData["logo"]?.string
        {
            
            if(appLogo.count > 0)
            {
                self.appHeaderLogo = KeyConstant.kImageBaseBannerSliderURL + appLogo
            }
        }
        
        
        
        if let arraBanner = dicData["banner_Array"]?["banner_list"].array
        {
            for i in 0..<arraBanner.count
            {
                self.arrayBanner.append(BannerInfo(dictData: arraBanner[i].dictionary ?? [:]))
                
            }
        }
        
        
        if let arraySlider = dicData["slider_Array"]?["slider_list"].array
        {
            self.arraySlider.removeAll()
            for i in 0..<arraySlider.count
            {
                self.arraySlider.append(SliderInfo(dictData: arraySlider[i].dictionary ?? [:]))
                
            }
        }
        
        
        if let arrayProduct = dicData["category_brand_Array"]?["category_brand_list"].array
        {
            self.arrayProduct.removeAll()
            for i in 0..<arrayProduct.count
            {
                self.arrayProduct.append(ProductInfo(dictData: arrayProduct[i].dictionary ?? [:]))
                
            }
        }
        
        //////////////
        if let arrayTopSelling = dicData["top_selling_products"]?.array
        {
            self.arrayTopSelling.removeAll()
            for i in 0..<arrayTopSelling.count
            {
                self.arrayTopSelling.append(TopSellingInfo(dictData: arrayTopSelling[i].dictionary ?? [:]))
                
            }
        }
        
//        if let arrayTopBrand = dicData["top_brands"]?.array
//        {
//            self.arrayTopBrand.removeAll()
//            for i in 0..<arrayTopBrand.count
//            {
//                self.arrayTopBrand.append(TopBrandInfo(dictData: arrayTopBrand[i].dictionary ?? [:]))
//
//            }
//        }
        
        if let arrayNewRelease = dicData["new_release_products"]?.array
        {
            self.arrayNewRelease.removeAll()
            for i in 0..<arrayNewRelease.count
            {
                self.arrayNewRelease.append(NewReleaseInfo(dictData: arrayNewRelease[i].dictionary ?? [:]))
                
            }
        }
        
        //top_selling_products
    }
    
}
