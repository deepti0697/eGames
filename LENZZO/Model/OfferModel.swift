//
//  OfferModel.swift
//  LENZZO
//
//  Created by Apple on 2/11/20.
//  Copyright © 2020 LENZZO. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON


class OfferModel
{
    static var sharedInstance = OfferModel()
    private init() { }
    
    var arrayOfferList = [OfferInfo]()
    
    struct OfferInfo
    {
        var familyid:String!
        var brandid:String!
        
        var name:String!
         var brand_image:String!
        //var arrChild:[JSON]!
        var product_image:String!
        var product_images:String!
        var offer_id:String!
        var offer_name:String!
        // var brand_slider_images:String!
        var image:String!
        var deal_otd_discount:String!
        var deal_otd:String!
        var price:String!
        var brand_name:String!
        var discount_percentage:String!
        var id:String!
   
        var description:String!
        var cate_id:String!
        var sale_price:String!
        var title:String!
        var quantity:String!
        var variations:String!
        var status:String!
        var tags:String!
        var stock_flag:String!
        var start_range:String!
        var wishlist:String!
        
        init(dictData:[String:JSON])
        {
            self.product_image = dictData["product_image"]?.string ?? ""
            self.product_images = dictData["product_images"]?.string ?? ""
            self.deal_otd_discount = dictData["deal_otd_discount"]?.string ?? ""
            self.deal_otd = dictData["deal_otd"]?.string ?? ""
            self.price = dictData["price"]?.string ?? ""
            self.brand_name = dictData["brand_name"]?.string ?? ""
            self.discount_percentage = dictData["discount_percentage"]?.string ?? ""
            self.familyid = dictData["id"]?.string ?? ""
            self.id = dictData["id"]?.string ?? ""
            self.brandid = dictData["brand_id"]?.string ?? ""
            
            self.name = dictData["name"]?.string ?? ""
            self.brand_image = dictData["brand_image"]?.string ?? ""
            //self.arrChild = dictData["child"]?.array ?? [JSON]()
            //self.brand_slider_images = dictData["brand_slider_images"]?.string ?? ""
            self.image = dictData["offer"]?["image"].string ?? ""
            self.wishlist = dictData["wishlist"]?.string ?? ""
            if let offerName = dictData["offer"]?["offer_subtitle"].string
            {
                self.offer_name = offerName
            }
            if let offerID = dictData["offer"]?["id"].string
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
        self.arrayOfferList.removeAll()
        
        if let arraBrand = dicData["product_list_Array"]?["product_list"].array
        {
            for i in 0..<arraBrand.count
            {
                self.arrayOfferList.append(OfferInfo(dictData: arraBrand[i].dictionary ?? [:]))
                
            }
        }
    }
    
    
}

