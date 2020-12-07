//
//  StringExtension.swift
//  OilBizz
//
//  Created by Apple on 10/23/18.
//  Copyright © 2018 SEOEssence. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func isValidEmail() -> Bool {
        if(HelperArabic().isArabicLanguage())
        {
            
            return true
        }
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
   
    func isValidPassword() -> Bool {
        
                if(self.count < 6)
                {
                    return false
                }
        return true
        
        //        let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
        //          let passwordRegex = ".{6}$"
        //        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    var isEmptyField: Bool {
        return trimmingCharacters(in: .whitespaces) == ""
    }
    
    
    func verifyUrl (urlString: String?) -> Bool {
        
                let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
                if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.endIndex.encodedOffset)) {
                    // it is a link, if the match covers the whole string
                    return match.range.length == self.endIndex.encodedOffset
                } else {
                    return false
        }
    }
    
    
             
}

extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension String {
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}
