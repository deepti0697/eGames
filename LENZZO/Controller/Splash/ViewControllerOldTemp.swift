//
//  ViewController.swift
//  LENZZO
//
//  Created by Apple on 8/13/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import UIKit
import QuartzCore
import SwiftyGif

class ViewControllerOldTemp: UIViewController {
    @IBOutlet weak var imageBrand1: UIImageView!
    @IBOutlet weak var imageBrand2: UIImageView!
    @IBOutlet weak var imageBrand3: UIImageView!
    @IBOutlet weak var imageBrand4: UIImageView!
    @IBOutlet weak var imageBrand5: UIImageView!
    @IBOutlet weak var imageBrand6: UIImageView!

    //@IBOutlet weak var labelLogo: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.methodLoadBrand1()
        
 
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func methodLoadBrand1()
    {
        imageBrand1.image = UIImage(named:"brandimage0")
        self.imageBrand1.transform = CGAffineTransform(scaleX: 0.0,y: 0.0);
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.imageBrand1.transform = CGAffineTransform(scaleX: 1.0,y: 1.0);
        })
        { (finished) in
            if finished {
                self.methodLoadBrand2()
            }
        }
    }
    func methodLoadBrand2()
    {
        imageBrand2.image = UIImage(named:"brandimage1")
        self.imageBrand2.transform = CGAffineTransform(scaleX: 0.0,y: 0.0);
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.imageBrand2.transform = CGAffineTransform(scaleX: 1.0,y: 1.0);
        })
        { (finished) in
            if finished {
                self.methodLoadBrand3()
            }
        }
    }
    func methodLoadBrand3()
    {
        imageBrand3.image = UIImage(named:"brandimage2")
        self.imageBrand3.transform = CGAffineTransform(scaleX: 0.0,y: 0.0);
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.imageBrand3.transform = CGAffineTransform(scaleX: 1.0,y: 1.0);
        })
        { (finished) in
            if finished {
                self.methodLoadBrand4()
            }
        }
    }
    func methodLoadBrand4()
    {
        imageBrand4.image = UIImage(named:"brandimage3")
        self.imageBrand4.transform = CGAffineTransform(scaleX: 0.0,y: 0.0);
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.imageBrand4.transform = CGAffineTransform(scaleX: 1.0,y: 1.0);
        })
        { (finished) in
            if finished {
                self.methodLoadBrand5()
            }
        }
    }
    func methodLoadBrand5()
    {
        imageBrand5.image = UIImage(named:"brandimage4")
        self.imageBrand5.transform = CGAffineTransform(scaleX: 0.0,y: 0.0);
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.imageBrand5.transform = CGAffineTransform(scaleX: 1.0,y: 1.0);
        })
        { (finished) in
            if finished {
                self.methodLoadBrand6()
            }
        }
    }
    
    func methodLoadBrand6()
    {
        imageBrand6.image = UIImage(named:"brandimage5")
        self.imageBrand6.transform = CGAffineTransform(scaleX: 0.0,y: 0.0);
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.imageBrand6.transform = CGAffineTransform(scaleX: 1.0,y: 1.0);
        })
        { (finished) in
            if finished {
                let splashVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SplashVC") as! SplashVC
                self.present(splashVC, animated: false, completion: nil)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        

    }
    override func viewWillLayoutSubviews() {
        
    }

        

    
   
    
    override func viewDidLayoutSubviews() {
        
    }
  
}

extension UIView {
    
        func fadeIn(duration: TimeInterval = 2.0, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
            UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
                self.alpha = 0.9
            }, completion: completion)
        }
        
        func fadeOut(duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
            UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
                self.alpha = 0.0
            }, completion: completion)
        }
    

    
    
}
