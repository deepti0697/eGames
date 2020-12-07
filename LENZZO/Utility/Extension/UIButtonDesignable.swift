//
//  UIButtonDesignable.swift
//  Lenzzo
//
//  Created by Apple on 5/7/19.
//  Copyright © 2019 Lenzzo., Ltd. All rights reserved.
//

import Foundation
import UIKit


var _fontSize:CGFloat = 15
var _fontName:String = "futura-medium"
@IBDesignable
class DesignableView: UIView {
}

@IBDesignable
class DesignableButton: UIButton {
}

@IBDesignable
class DesignableLabel: UILabel {
    
}


//extension UILabel{
//
//    @IBInspectable
//    var fontSizeValue:CGFloat
//    {
//        set
//        {
//            _fontSize = newValue
//            self.font = UIFont(name: _fontName, size: _fontSize)
//        }
//        get
//        {
//            return _fontSize
//        }
//    }
//
//
//    @IBInspectable
//    var fontName:String
//    {
//        set
//        {
//            _fontName = newValue
//            self.font = UIFont(name: _fontName, size: _fontSize)
//        }
//        get
//        {
//            return _fontName
//        }
//    }
//}
extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}



//@IBDesignable
//extension UIView {
//    @IBInspectable
//    public var startColor: UIColor = .white {
//        didSet {
//            gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
//            setNeedsDisplay()
//        }
//    }
//    @IBInspectable
//    public var endColor: UIColor = .white {
//        didSet {
//            gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
//            setNeedsDisplay()
//        }
//    }
//
//    private lazy var gradientLayer: CAGradientLayer = {
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = self.bounds
//        gradientLayer.colors = [self.startColor.cgColor, self.endColor.cgColor]
//        return gradientLayer
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        layer.insertSublayer(gradientLayer, at: 0)
//    }
//
//    public required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        layer.insertSublayer(gradientLayer, at: 0)
//    }
//
//    open override func layoutSubviews() {
//        super.layoutSubviews()
//        gradientLayer.frame = bounds
//    }
//}
