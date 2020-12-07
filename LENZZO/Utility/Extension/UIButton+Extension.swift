//
//  UIView+Extension.swift
//  Lenzzo
//
//  Created by Apple on 5/7/19.
//  Copyright © 2019 Lenzzo., Ltd. All rights reserved.
//

import Foundation
import UIKit


extension UIButton
{
    struct viewHolder {
        
        static var lineView = UIView()
        static var buttonSelected = UIButton()

    }
    
 
    
    func addBottomBorderWithColor(color:UIColor, height:CGFloat) {
        
        viewHolder.buttonSelected.removeBorder()
     
        
    viewHolder.lineView = UIView(frame: CGRect(x: 0, y: self.frame.size.height - 3, width: UIScreen.main.bounds.width / 2, height: height))
    viewHolder.lineView.backgroundColor = color
    self.addSubview(viewHolder.lineView)
    viewHolder.buttonSelected = self
        
    }
    func addBottomBorderWithColorThird(color:UIColor) {
        
        viewHolder.buttonSelected.removeBorder()
        
        
        viewHolder.lineView = UIView(frame: CGRect(x: 0, y: self.frame.size.height - 3, width: UIScreen.main.bounds.width / 3, height: 3))
        viewHolder.lineView.backgroundColor = color
        self.addSubview(viewHolder.lineView)
        viewHolder.buttonSelected = self
        
    }
     func removeBorder()
     {
      
            viewHolder.lineView.removeFromSuperview()
        

    }
    
    
    
    func addViewBottomBorderWithColor(color:UIColor, height:CGFloat) {
        
        let lineView = UIView(frame: CGRect(x: 0, y: self.frame.size.height, width: self.frame.size.width, height: height))
        lineView.backgroundColor = color
        self.addSubview(lineView)
        
        
    }
    
}
