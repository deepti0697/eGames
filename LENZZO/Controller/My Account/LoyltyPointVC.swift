//
//  LoyltyPointVC.swift
//  LENZZO
//
//  Created by Apple on 12/3/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import UIKit
import Kingfisher
import AlamofireImage
import SwiftyJSON

class LoyltyPointVC: UIViewController {
    
    @IBOutlet weak var labelCountCart: UILabel!
    @IBOutlet weak var labelAvailableTitles: PaddingLabel!
    @IBOutlet weak var imageViewPic: UIImageView!
    
 
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var cartBtn: UIButton!
    @IBOutlet weak var backImgView: UIImageView!
    @IBOutlet weak var labelAlert: PaddingLabel!
    @IBOutlet weak var labelBalancePoints: PaddingLabel!
    @IBOutlet weak var labelTopTitles: PaddingLabel!
    
    var strImagePicURL = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(rightSwip))
        
        if(HelperArabic().isArabicLanguage())
        {
            swipeRight.direction = UISwipeGestureRecognizer.Direction.left
        }
        else
        {
            swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        }
        
        
        self.view.addGestureRecognizer(swipeRight)
        
        self.labelTopTitles.text = NSLocalizedString("MSG371", comment: "").uppercased()
        self.labelAvailableTitles.text = NSLocalizedString("MSG369", comment: "")
        
        self.labelBalancePoints.text = "0"
        
        getMyPoints()
        imageViewPic.contentMode = .scaleToFill
        if(strImagePicURL.count > 0)
        {
            let urlString = strImagePicURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            self.imageViewPic.kf.setImage(with: URL(string: KeyConstant.kImageProfilePicURL + urlString!)!, placeholder: UIImage.init(named: "user(1)"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: { (downloadImage, error, cacheType, url) in
                if(downloadImage != nil)
                {
                    self.imageViewPic.image = downloadImage!
                }
            })
        }
            self.changeTintAndThemeColor()
        
        
        labelAlert.font = UIFont(name: FontLocalization.medium.strValue, size: 17.0)
        labelBalancePoints.font = UIFont(name: FontLocalization.Bold.strValue, size: 30.0)
        labelTopTitles.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        labelAvailableTitles.font = UIFont(name: FontLocalization.medium.strValue, size: 18.0)
        
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
        super.viewWillAppear(false)
        self.showCartCount()
    }
    func showCartCount()
    {
        labelCountCart.text = ""
        if(HelperArabic().isArabicLanguage())
        {
         self.backImgView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }
        else
        {
        self.backImgView.transform = CGAffineTransform(rotationAngle: 245)
        }
        CartViewModel().viewCartList(vc: self, param: ["user_id":KeyConstant.sharedAppDelegate.getUserId()], completionHandler: { (result:[JSON], totalCount:String ,error:Error?) in
            
            self.labelCountCart.text = ""
            
            
            
            if(result.count > 0)
            {
                self.labelCountCart.text = totalCount
                
                print(result.count)
            }})
        
    }
    
    
    func getMyPoints()
    {
        CartViewModel().getMyLoyaltyPoints(vc: self, param: [:], completionHandler: { (result:[String:JSON], error:Error?) in
            
            if(!(error == nil))
            {
                self.getMyPoints()
                return
            }
            if(result.count > 0)
            {
                
                let totalPoints = result["point"]?.string ?? "0"
                let totalPrice =  result["price"]?.string ?? "0.0"
                let currentCurrency = result["current_currency"]?.string ?? ""
                let minimumPoints = result["min_point"]?.string ?? "0"
                
                
                var priceTemp = ""
                if(currentCurrency.uppercased() == "KWD")
                {
                    priceTemp = String(format:"%.3f",Double(totalPrice)?.roundTo(places: 3) ?? 0.0)
                }
                else
                {
                    priceTemp = String(format:"%.2f",Double(totalPrice)?.roundTo(places: 2) ?? 0.0)
                    
                }
                
                
                self.labelBalancePoints.text = totalPoints
                let balance = String("\n( \(priceTemp) \(currentCurrency) )")
                self.labelAvailableTitles.text = self.labelAvailableTitles.text! + balance
                self.labelAlert.text = String(format: "\(NSLocalizedString("MSG370", comment: ""))",minimumPoints)
                
            }
            
        })
        
        
        
        
    }
    
    override func viewWillLayoutSubviews() {
        
    }
    
    @IBAction func buttonFilter(_ sender: Any) {
        KeyConstant.sharedAppDelegate.showFilterScreen(vc: self)
        
    }
    @IBAction func buttonSearch(_ sender: Any) {
        KeyConstant.sharedAppDelegate.showSearchScreen(vc: self)
        
    }
    @IBAction func butttonBack(_ sender: Any) {
        
        self.dismiss(animated: false, completion: nil)
        
    }
    @objc func rightSwip(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            self.butttonBack(UIButton())
            
        }
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    @IBAction func buttonCart(_ sender: Any) {
        let myCartVC = self.storyboard?.instantiateViewController(withIdentifier: "MyCartVC") as! MyCartVC
        self.present(myCartVC, animated: false, completion: nil)
    }
    
    
    
    
    
}
