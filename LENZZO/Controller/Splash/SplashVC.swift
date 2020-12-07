//
//  SplashVC.swift
//  LENZZO
//
//  Created by Apple on 2/11/20.
//  Copyright © 2020 LENZZO. All rights reserved.
//

import UIKit
import QuartzCore
import SwiftyGif

class SplashVC: UIViewController {
    @IBOutlet weak var imageLogo: UIImageView!
    //verified_visa_512x256
    @IBOutlet weak var imageViewBottomLogo: UIImageView!
    //@IBOutlet weak var labelLogo: UILabel!
    
    var i = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        imageLogo.backgroundColor = UIColor.white
        imageLogo.alpha = 1.0
        // labelLogo.text = ""
        
        self.view.addSubview(imageLogo)
        imageViewBottomLogo.isHidden = true
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        self.labelLogo.alpha = 0
        //
        //        self.labelLogo.text = NSLocalizedString("MSG343", comment: "")
        self.imageLogo.image = UIImage(named:"lenzzo_1024x1024.png")
        
        self.imageLogo.transform = CGAffineTransform(scaleX: 0.0,y: 0.0);
        
        UIView.animate(withDuration: 2.0, delay: 0.0, options: [.curveEaseInOut], animations: {
            
            self.imageLogo.transform = CGAffineTransform(scaleX: 1.0,y: 1.0);
            
        }){ (finished) in
            if finished {
                self.checkCountry()
            }
            
        }
        
    }
    override func viewWillLayoutSubviews() {
        
        
        
        //        self.imageViewBottomLogo.image = UIImage(named:"verified_visa_512x256")
        //        self.imageViewBottomLogo.transform = CGAffineTransform(scaleX: 0.0,y: 0.0);
        //        UIView.animate(withDuration: 0.5, delay: 2.5, options: [.curveEaseInOut], animations: {
        //            self.imageViewBottomLogo.transform = CGAffineTransform(scaleX: 1.0,y: 1.0);
        //        })
        
    }
    
    
    
    
    func checkCountry()
    {
        if let isCountrySelected = KeyConstant.user_Default.value(forKey: KeyConstant.kSelectedCountry) as? String
        {
            if(isCountrySelected.count > 0)
            {
                KeyConstant.sharedAppDelegate.setRoot()
                
                return
            }
        }
        
        KeyConstant.sharedAppDelegate.showCountryScreen(vc: self)
        
    }
    
    override func viewDidLayoutSubviews() {
        
        
        
        // sleep(1)
        //   KeyConstant.sharedAppDelegate.setRoot()
        
        /*   UIView.animate(withDuration: 2.0, delay: 0.2, options: [.curveEaseInOut], animations: {
         self.imageLogo.frame = CGRect(x: 0, y: (UIScreen.main.bounds.height / 2) - (self.imageLogo.frame.height / 2), width: UIScreen.main.bounds.width, height: self.imageLogo.frame.height)
         }) { (finished) in
         if finished {
         // Repeat animation from bottom to top
         //self.Up()
         
         //                let objHome = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
         //                self.present(objHome, animated: false, completion: nil)
         //
         KeyConstant.sharedAppDelegate.setRoot()
         
         }
         }*/
    }
    
}
