//
//  Helper.swift
//  LENZZO
//
//  Created by Apple on 11/27/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import Foundation

class HelperArabic
{
    func isArabicLanguage() -> Bool {
        if((UserDefaults.standard.array(forKey: "AppleLanguages")?.first as?
            String) == "ar")
        {
            return true
        }
        return false
        
    }
    
}
