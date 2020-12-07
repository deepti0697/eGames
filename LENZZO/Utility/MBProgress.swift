//
//  File.swift
//  LENZZO
//
//  Created by Apple on 8/19/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD
import SwiftyGif

class MBProgress{


func showIndicator(view:UIView)
{
    var hud = MBProgressHUD()
    hud = MBProgressHUD.showAdded(to: view, animated:
        true)
    // Set the custom view mode to show any view.
    hud.mode = MBProgressHUDMode.customView
    // Set an image view with a checkmark.
    let gifmanager = SwiftyGifManager(memoryLimit:20)
    //let gif = UIImage(gifName: "loading-new.gif")
    
    let gif = UIImage(gifName: "newloading.gif")
    
    

    let imageview = UIImageView(gifImage: gif, manager: gifmanager)
    imageview.tintColor = AppColors.SelcetedColor
    //hud.labelText = NSLocalizedString("Loading", comment: "")
    //hud.labelColor = UIColor.red
    //
    //
    imageview.frame = CGRect(x: 0 , y: 0, width: hud.bezelView.frame.width , height: hud.bezelView.frame.height)
    
 
    imageview.contentMode = .scaleAspectFit
    
    hud.customView = imageview
    hud.backgroundView.color = UIColor.clear//UIColor.init(white: 1.0, alpha: 0.5)
//    hud.bezelView.backgroundColor = UIColor.init(red: 237.0/255.0, green: 231.0/255.0, blue: 231.0/255.0, alpha: 1.0)
    hud.bezelView.color = .clear
    hud.bezelView.style = .solidColor
    
    hud.show(true)
    
}

    
    func hideIndicator(view:UIView)
    {
        
        DispatchQueue.main.async {
        MBProgressHUD.hide(for: view, animated: true)

        }
        
    }

}
