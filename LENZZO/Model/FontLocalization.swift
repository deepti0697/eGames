//
//  FontLocalization.swift
//  LENZZO
//
//  Created by sanjay mac on 10/07/20.
//  Copyright © 2020 LENZZO. All rights reserved.
//

import Foundation

enum FontLocalization:String {
    
    
    case Black
    case Bold
    case Light
    case medium
    case SemiBold
    
    var strValue:String{
        switch self {
        case .Black:
            return HelperArabic().isArabicLanguage() ? "Cairo-Black" : "Futura-Bold-font"
        case .Bold:
            return HelperArabic().isArabicLanguage() ? "Cairo-Bold" : "Futura-Heavy-font"
        case .Light:
            return HelperArabic().isArabicLanguage() ? "Cairo-Light" : "Futura-Light-font"
            
        case .medium:
            return HelperArabic().isArabicLanguage() ? "Cairo-SemiBold" : "futura-medium"
            
        case .SemiBold:
            return HelperArabic().isArabicLanguage() ? "Cairo-SemiBold" : "futura-medium-bt"
            
        }
    }

}
