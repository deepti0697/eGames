//
//  UILabel+Extension.swift
//  Lenzzo
//
//  Created by Apple on 8/6/19.
//  Copyright © 2019 Lenzzo., Ltd. All rights reserved.
//

import Foundation
import UIKit
@IBDesignable class PaddingLabel: UILabel {
    
    @IBInspectable var topInset: CGFloat = 0.0
    @IBInspectable var bottomInset: CGFloat = 0.0
    @IBInspectable var leftInset: CGFloat = 10.0
    @IBInspectable var rightInset: CGFloat = 5.0
    
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
}


extension UILabel {
    
    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {
        
        guard let labelText = self.text else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        
        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        
        // Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        self.attributedText = attributedString
    }
}
extension String {
    func withBoldText(arraytext: [String], font: UIFont? = nil, boldFont: UIFont? = nil) -> NSAttributedString {
        let _font = font ?? UIFont.systemFont(ofSize: 14, weight: .regular)
        let _boldFont = boldFont ?? UIFont.boldSystemFont(ofSize: _font.pointSize)

        let fullString = NSMutableAttributedString(string: self, attributes: [NSAttributedString.Key.font: _font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font:_boldFont]
        for ind in 0..<arraytext.count
        {
        let range = (self as NSString).range(of: arraytext[ind])
        fullString.addAttributes(boldFontAttribute, range: range)
        }
        return fullString
    }
    
    
    func withBoldTextParagraphLineSpace(arraytext: [String], font: UIFont? = nil, boldFont: UIFont? = nil) -> NSAttributedString {
        let _font = font ?? UIFont.systemFont(ofSize: 14, weight: .regular)
        let _boldFont = boldFont ?? UIFont.boldSystemFont(ofSize: _font.pointSize)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 4
        
        let fullString = NSMutableAttributedString(string: self, attributes: [NSAttributedString.Key.font: _font,NSAttributedString.Key.paragraphStyle : style])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font:_boldFont]
        for ind in 0..<arraytext.count
        {
            let range = (self as NSString).range(of: arraytext[ind])
            fullString.addAttributes(boldFontAttribute, range: range)
        }
        
        
        return fullString
    }
    
}

//label.attributeString = "my full string".withBoldText(text: "full")

extension UILabel {
    
    func setHTML1(html: String) {
        do {
            
            let attributedString: NSMutableAttributedString = try NSMutableAttributedString(data: html.data(using: String.Encoding.unicode,allowLossyConversion: true)!, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            
            
            let paragraphStyle = NSMutableParagraphStyle()
            if(HelperArabic().isArabicLanguage())
            {
                paragraphStyle.baseWritingDirection = .rightToLeft
                paragraphStyle.alignment = .right

            }
            else
            {
                paragraphStyle.baseWritingDirection = .leftToRight
                paragraphStyle.alignment = .left

            }
            paragraphStyle.lineBreakMode = .byWordWrapping
            
            attributedString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: (attributedString.string as NSString).range(of: attributedString.string))
            
            
            self.attributedText = attributedString
            
        } catch {
            self.text = html
        }
    }
    
    func setHTML(html: String) {
        do {
         
            let attributedString: NSMutableAttributedString = try NSMutableAttributedString(data: html.data(using: String.Encoding.unicode,allowLossyConversion: true)!, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .justified
            if(HelperArabic().isArabicLanguage())
            {
                paragraphStyle.baseWritingDirection = .rightToLeft
            }
            else
            {
                paragraphStyle.baseWritingDirection = .leftToRight
            }
            paragraphStyle.lineBreakMode = .byWordWrapping

          attributedString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: (attributedString.string as NSString).range(of: attributedString.string))
            
            
            self.attributedText = attributedString
            
        } catch {
            self.text = html
        }
    }
}
extension UITextView {
    func setHTML(html: String) {
        do {
            
           // let modifiedFont = String(format:"<span style=\"font-family: '\(FontLocalization.medium.strValue)'; font-size: \(self.font!.pointSize)\">%@</span>", html)
            
            let attributedString: NSMutableAttributedString = try NSMutableAttributedString(data: html.data(using: String.Encoding.unicode,allowLossyConversion: true)!, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .left
            if(HelperArabic().isArabicLanguage())
            {
                paragraphStyle.baseWritingDirection = .rightToLeft
                self.textAlignment = .right
            }
            else
            {
                paragraphStyle.baseWritingDirection = .leftToRight
                self.textAlignment = .left
            }
            paragraphStyle.lineBreakMode = .byWordWrapping
            
            attributedString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: (attributedString.string as NSString).range(of: attributedString.string))
            self.attributedText = attributedString
            self.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
           
        } catch {
            self.text = html
          
        }
    }
}
