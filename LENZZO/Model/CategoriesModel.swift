//
//  CategoriesModel.swift
//  LENZZO
//
//  Created by Apple on 8/21/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON


class CategoriesModel
{
    static var sharedInstance = CategoriesModel()
    private init() { }
    
    var arrayCatList = [CategoryInfo]()
    
    struct CategoryInfo
    {
        var id:String!
        var name:String!
        var cat_image:String!
        
        
        init(dictData:[String:JSON])
        {
            self.id = dictData["id"]?.string ?? ""
            self.name = dictData["name"]?.string ?? ""
            if(HelperArabic().isArabicLanguage())
            {
                if let title_ar =  dictData["name_ar"]?.string
                {
                    self.name = title_ar
                }
            }
            self.cat_image = dictData["category_image"]?.string ?? ""
            
        }
    }
    
    func addAllData(dicData:[String:JSON])
    {
        self.arrayCatList.removeAll()
        
        if let arrayCatList = dicData["category_Array"]?["category_list"].array
        {
            for i in 0..<arrayCatList.count
            {
                self.arrayCatList.append(CategoryInfo(dictData: arrayCatList[i].dictionary ?? [:]))
                
            }
        }
    }
}
