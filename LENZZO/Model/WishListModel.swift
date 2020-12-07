//
//  WishListModel.swift
//  LENZZO
//
//  Created by Apple on 8/23/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON


class WishListModel
{
    static var sharedInstance = WishListModel()
    private init() { }
    
    var arrayWishList = [FavInfo]()
    
    struct FavInfo
    {
        
        var dicAllWishlist:[String:JSON]
        var wishlistProductId :String
        
        
        init(dicData:[String:JSON])
        {
            self.dicAllWishlist = dicData
            wishlistProductId = dicData["product_id"]?.string ?? ""
            
        }
    }
    
    func addAllData(dicData:[String:JSON])
    {
        self.arrayWishList.removeAll()
        
        if let arrayWishList = dicData["wishlist_Array"]?["wishlist"].array
        {
            for i in 0..<arrayWishList.count
            {
                self.arrayWishList.append(FavInfo(dicData: arrayWishList[i].dictionary ?? [String:JSON]()))
                
            }
        }
    }
}
