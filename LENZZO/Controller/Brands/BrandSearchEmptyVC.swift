//
//  BrandSearchEmptyVC.swift
//  LENZZO
//
//  Created by sanjay mac on 15/06/20.
//  Copyright © 2020 LENZZO. All rights reserved.
//

import UIKit

class BrandSearchEmptyVC: UIViewController {

    
    @IBOutlet weak var backImgView: UIImageView!
    @IBOutlet weak var buttonMenu: UIButton!

    @IBOutlet weak var searchTitleLbl: PaddingLabel!
    @IBOutlet weak var cartBtn: UIButton!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var labelCountCart: UILabel!
    
    @IBOutlet weak var noProductsFound: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.changeTintAndThemeColor()
        noProductsFound.font = UIFont(name: FontLocalization.Bold.strValue, size: 15.0)
        searchTitleLbl.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        searchTitleLbl.text = NSLocalizedString("MSG431", comment: "")
      }
      
      
      func changeTintAndThemeColor(){
          let img = UIImage(named: "search (1)")?.withRenderingMode(.alwaysTemplate)
          self.searchBtn.setImage(img, for: .normal)
          self.searchBtn.tintColor = .white
          
          let cartImg = UIImage(named: "cart")?.withRenderingMode(.alwaysTemplate)
          self.cartBtn.setImage(cartImg, for: .normal)
          self.cartBtn.tintColor = .white
          
          self.backImgView.image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate)
          self.backImgView.tintColor = .white
      }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.presentingViewController == nil{
            KeyConstant.sharedAppDelegate.showSearchScreen(vc: self)
        }
        if(HelperArabic().isArabicLanguage())
        {
         self.backImgView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }
        else
        {
        self.backImgView.transform = CGAffineTransform(rotationAngle: 245)
        }
    }
    
    @IBAction func cartBtnClicked(_ sender: UIButton) {
        
        let myCartVC = self.storyboard?.instantiateViewController(withIdentifier: "MyCartVC") as! MyCartVC
        self.present(myCartVC, animated: false, completion: nil)
    }
    
    @IBAction func searchBtnClicked(_ sender: UIButton) {
        
        KeyConstant.sharedAppDelegate.showSearchScreen(vc: self)
        
    }
    
    
    @IBAction func backBtnClicked(_ sender: UIButton) {
        
        self.tabBarController?.selectedIndex = 0
        
        
    }
    
    
}
