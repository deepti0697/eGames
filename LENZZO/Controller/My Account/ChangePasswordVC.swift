//
//  ChangePasswordVC.swift
//  LENZZO
//
//  Created by Apple on 11/21/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import UIKit
import Kingfisher
import AlamofireImage
import SwiftyJSON

class ChangePasswordVC: UIViewController {
    
    @IBOutlet weak var labelCountCart: UILabel!
    @IBOutlet weak var buttonUpdate: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var textFieldOldPassword: RoundTextField!
    @IBOutlet weak var textFieldNewPassword: RoundTextField!
    @IBOutlet weak var textFieldCNewPassword: RoundTextField!
    
    @IBOutlet weak var changePasswordTitleLbl: PaddingLabel!
    @IBOutlet weak var cartBtn: UIButton!
    
    @IBOutlet weak var backImgView: UIImageView!
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
        
            self.changeTintAndThemeColor()
        
        textFieldOldPassword.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        textFieldNewPassword.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        textFieldCNewPassword.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        buttonUpdate.titleLabel?.font = UIFont(name: FontLocalization.Bold.strValue, size: 15.0)
        
            
        }
        
        
        func changeTintAndThemeColor(){
            
            
            let cartImg = UIImage(named: "cart")?.withRenderingMode(.alwaysTemplate)
            self.cartBtn.setImage(cartImg, for: .normal)
            self.cartBtn.tintColor = .white
            
            self.backImgView.image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate)
            self.backImgView.tintColor = .white
            self.scrollView.backgroundColor = .clear
            
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
    
    
    override func viewWillLayoutSubviews() {
       // scrollView.dropShadow()
        self.textFieldOldPassword.bottomBorderColor = UIColor.white
        self.textFieldNewPassword.bottomBorderColor = UIColor.white
        self.textFieldCNewPassword.bottomBorderColor = UIColor.white
        
        
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height: self.buttonUpdate.frame.origin.y + 100)
        
        
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
    
    
    @IBAction func buttonSubmit(_ sender: Any) {
        
        
        
        guard let password = textFieldOldPassword.text, (!(password.isEmpty))
            else {
                KeyConstant.sharedAppDelegate.showAlertViewWithTextField(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG10", comment: ""),textField:textFieldOldPassword )
                return
        }
        guard let passwordLength = textFieldOldPassword.text, (passwordLength.count > 5)
            else {
                KeyConstant.sharedAppDelegate.showAlertViewWithTextField(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG317", comment: ""),textField:textFieldOldPassword )
                return
        }
        
        guard let textFieldNewPass = textFieldNewPassword.text, (!(textFieldNewPass.isEmpty))
            else {
                KeyConstant.sharedAppDelegate.showAlertViewWithTextField(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG318", comment: ""),textField:textFieldNewPassword )
                return
        }
        
        guard let textFieldNewPasswo = textFieldNewPassword.text, (textFieldNewPasswo.count > 5)
            else {
                KeyConstant.sharedAppDelegate.showAlertViewWithTextField(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG317", comment: ""),textField:textFieldNewPassword )
                return
        }
        
        
        guard let repassword = textFieldCNewPassword.text, (!(repassword.isEmpty))
            else {
                KeyConstant.sharedAppDelegate.showAlertViewWithTextField(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG319", comment: ""),textField: textFieldCNewPassword)
                return
        }
        
        
        guard let passwordCheck = textFieldCNewPassword.text, (passwordCheck == textFieldNewPassword.text)
            else {
                KeyConstant.sharedAppDelegate.showAlertViewWithTextField(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG320", comment: ""),textField:textFieldCNewPassword )
                return
        }
        
        
        
        
        MBProgress().showIndicator(view: self.view)
        
        
        WebServiceHelper.sharedInstanceAPI.hitPostAPI(urlString: KeyConstant.APIChangePassword, params: ["old_password":textFieldOldPassword.text ?? "","password":textFieldNewPassword.text ?? "","user_id":KeyConstant.user_Default.value(forKey: KeyConstant.kuserId) as? String ?? ""], completionHandler: { (result: [String:Any], err:Error?) in
            print(result)
            DispatchQueue.main.async {
                MBProgress().hideIndicator(view: self.view)
            }
            if(!(err == nil))
            {
                KeyConstant.sharedAppDelegate.showAlertView(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString:err?.localizedDescription ?? NSLocalizedString("MSG21", comment: ""))
                
                return
            }
            let json = JSON(result)
            let statusCode = json["status"].string
            
            if(statusCode == "success")
            {
                
                let strClear =  ""
                self.textFieldCNewPassword.text = strClear
                self.textFieldOldPassword.text = strClear
                self.textFieldNewPassword.text = strClear
                
                let alertView = UIAlertController(title: NSLocalizedString("MSG31", comment: "").uppercased(), message: "", preferredStyle: .alert)
                let msgFont = [NSAttributedString.Key.font: UIFont(name: FontLocalization.medium.strValue, size: 15.0)!]
                let msgAttrString = NSMutableAttributedString(string: NSLocalizedString("MSG321", comment: ""), attributes: msgFont)
                alertView.setValue(msgAttrString, forKey: "attributedMessage")
                
                let alertAction = UIAlertAction(title: NSLocalizedString("MSG18", comment: ""), style: .default) { (alert) in
                    self.dismiss(animated: true, completion: nil)
                }
                alertAction.setValue(AppColors.SelcetedColor, forKey: "titleTextColor")
                alertView.addAction(alertAction)
                self.present(alertView, animated: true, completion: nil)
            }
            else
            {
                
                
                
                var message = json["message"].string
                
                if(HelperArabic().isArabicLanguage())
                {
                    if let msg = json["message_ar"].string
                    {
                        if( msg.count > 0)
                        {
                            message = msg
                        }
                    }
                }
                
                KeyConstant.sharedAppDelegate.showAlertView(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString:message ?? NSLocalizedString("MSG21", comment: ""))
                
                
            }
            
        })
        
    }
    
    
    
}

extension ChangePasswordVC : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
