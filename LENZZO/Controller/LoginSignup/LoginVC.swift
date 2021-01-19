//
//  LoginVC.swift
//  LENZZO
//
//  Created by Apple on 8/20/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import UIKit
import Kingfisher
import AlamofireImage
import SwiftyJSON

protocol ReloadDataDelegate
{
    func reloadDataSelected()
}



class LoginVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var heightConstrintsUserName: NSLayoutConstraint!
    @IBOutlet weak var heightConstrintsPassword: NSLayoutConstraint!
    
    var isPresentGuestSignup = Bool()
    
   
    
    @IBOutlet weak var buttonForgot: UIButton!
    @IBOutlet weak var buttonDonotAccount: UIButton!
    @IBOutlet weak var buttonLogin: UIButton!
    
    @IBOutlet weak var btnSignup: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var textFieldEmail: RoundTextField!
    @IBOutlet weak var textFieldPassword: RoundTextField!
    @IBOutlet weak var labelCountCart: UILabel!
    
    var delegateReloadData: ReloadDataDelegate!
    var isPresentFromMenu = Bool()
    var isPresentFromCheckOut = Bool()
    var isPresentFromGuestSignup = Bool()
    
    @IBOutlet weak var viewGuestoptions: UIView!
    var isExstingUSer = Bool()
    
    @IBOutlet weak var imageExistingUser: UIImageView!
    @IBOutlet weak var imageGuestUser: UIImageView!
    @IBOutlet weak var labelExistingUser: UILabel!
    @IBOutlet weak var labelGuestUser: UILabel!
    
    @IBOutlet weak var backImgView: UIImageView!
    @IBOutlet weak var cartBtn: UIButton!
    @IBOutlet weak var searchBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let guest = KeyConstant.user_Default.value(forKey: KeyConstant.kCheckoutGuestId) as? String
        {
            self.textFieldEmail.text = KeyConstant.user_Default.value(forKey: KeyConstant.kuserEmail) as? String ?? ""
        }
        self.buttonLogin.setTitle(NSLocalizedString("MSG416", comment: ""), for: .normal)
        
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(rightSwip))
        
        if(HelperArabic().isArabicLanguage())
        {
            
            swipeRight.direction = UISwipeGestureRecognizer.Direction.left
            
        }
        else
        {
            swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        }
        
//        let attributeStringdonot = NSMutableAttributedString(string: NSLocalizedString("MSG347", comment: ""),attributes: [NSAttributedString.Key.font : UIFont.init(name: FontLocalization.Bold.strValue, size: 11.0),NSAttributedString.Key.foregroundColor : UIColor.white])
//        buttonDonotAccount.setAttributedTitle(attributeStringdonot, for: .normal)
        buttonDonotAccount.setTitle(NSLocalizedString("MSG347", comment: ""), for: .normal)
        btnSignup.setTitle(NSLocalizedString("MSG443", comment: ""), for: .normal)
//        let attributeStringForgot = NSMutableAttributedString(string: NSLocalizedString("MSG45", comment: ""),attributes: [NSAttributedString.Key.font : UIFont.init(name: FontLocalization.Bold.strValue, size: 11.0),NSAttributedString.Key.foregroundColor : UIColor.white])
//        //        let attributeWhat = NSMutableAttributedString(string: NSLocalizedString("MSG360", comment: ""),attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 11.0),NSAttributedString.Key.foregroundColor : UIColor.black])
//        let combination = NSMutableAttributedString()
//        combination.append(attributeStringForgot)
//        // combination.append(attributeWhat)
//        buttonForgot.setAttributedTitle(combination, for: .normal)
        
        buttonForgot.setTitle(NSLocalizedString("MSG45", comment: ""), for: .normal)
        
        //        buttonForgot.setAttributedTitle(attributeStringForgot, for: .normal)
        
        self.view.addGestureRecognizer(swipeRight)
        
        
        isExstingUSer = true
        
        if(isPresentFromCheckOut == true)
        {
            self.viewGuestoptions.isHidden = false
            self.labelExistingUser.text = NSLocalizedString("MSG406", comment: "")
            self.labelGuestUser.text = NSLocalizedString("MSG407", comment: "")
            self.imageExistingUser.image = UIImage(named:"slect_100x100")?.withRenderingMode(.alwaysTemplate)
            self.imageExistingUser.tintColor = .white
            self.imageGuestUser.image = UIImage(named:"de_select_100x100")?.withRenderingMode(.alwaysTemplate)
            self.imageGuestUser.tintColor = .white
            
        }
        else
        {
            
            self.viewGuestoptions.isHidden = true
            self.labelExistingUser.text = ""
            self.labelGuestUser.text = ""
            
            
        }
        
            self.changeTintAndThemeColor()
            
        self.textFieldEmail.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        self.textFieldPassword.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        self.buttonDonotAccount.titleLabel?.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        self.buttonDonotAccount.titleLabel?.textAlignment = .center
        self.buttonLogin.titleLabel?.font = UIFont(name: FontLocalization.Bold.strValue, size: 15.0)
       // self.btnSignup.titleLabel?.font = UIFont(name: FontLocalization.Bold.strValue, size: 12.0)
        self.buttonForgot.titleLabel?.font = UIFont(name: FontLocalization.medium.strValue, size: 11.0)
         self.labelGuestUser.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        self.labelExistingUser.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        //self.buttonSignup.titleLabel?.adjustsFontSizeToFitWidth = true
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
            
            self.buttonDonotAccount.setTitleColor(.white, for: .normal)
            self.buttonDonotAccount.tintColor = .white
            
            self.buttonForgot.setTitleColor(.white, for: .normal)
            self.buttonForgot.tintColor = .white
        }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.showCartCount()
    }
    
    override func viewWillLayoutSubviews() {
       // scrollView.dropShadow()
        
        self.textFieldEmail.bottomBorderColor = UIColor.white
        self.textFieldPassword.bottomBorderColor = UIColor.white
        
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height: self.btnSignup.frame.origin.y + 100)
        
        if(isExstingUSer == false && isPresentFromCheckOut == true)
        {
            
            self.heightConstrintsPassword.constant = 0
            self.textFieldPassword.isHidden = true
            
            
        }
        else
        {
            
            self.heightConstrintsPassword.constant = self.heightConstrintsUserName.constant
            self.textFieldPassword.isHidden = false
            
            
        }
        
        
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
    
    
    
    @IBAction func buttonLoginSubmit(_ sender: Any) {
        
        guard let email = textFieldEmail.text, (!(email.isEmpty)) else
            
        {
            KeyConstant.sharedAppDelegate.showAlertViewWithTextField(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG2", comment: ""),textField:textFieldEmail)
            return
        }
        
        if(isPresentFromCheckOut == true && isExstingUSer == false)
        {
            
            self.checkoutWithGuest()
        }
        else
        {
            guard let password = textFieldPassword.text, (!(password.isEmpty))
            else {
                KeyConstant.sharedAppDelegate.showAlertViewWithTextField(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG4", comment: ""),textField:textFieldPassword)
                
                return
            }
            
            
            self.view.endEditing(false)
            let obhLoginViewModel = LoginViewModel(userEmailLogin: LoginModel(email: email, password: password))
            obhLoginViewModel.login(vc: self, isPresentFromMenu: isPresentFromMenu)
            return
        }
        
    }
    @IBAction func buttonLoginUser(_ sender: Any) {
        
        if(isExstingUSer == true)
        {
            isExstingUSer = false
            self.imageExistingUser.image = UIImage(named:"de_select_100x100")?.withRenderingMode(.alwaysTemplate)
            self.imageExistingUser.tintColor = .white
            self.imageGuestUser.image = UIImage(named:"slect_100x100")?.withRenderingMode(.alwaysTemplate)
            self.imageGuestUser.tintColor = .white
            self.heightConstrintsPassword.constant = 0
            self.textFieldPassword.isHidden = true
            
            self.buttonLogin.setTitle(NSLocalizedString("MSG415", comment: ""), for: .normal)
            
        }
        else
        {
            
            isExstingUSer = true
            self.imageExistingUser.image = UIImage(named:"slect_100x100")?.withRenderingMode(.alwaysTemplate)
            self.imageExistingUser.tintColor = .white
            self.imageGuestUser.image = UIImage(named:"de_select_100x100")?.withRenderingMode(.alwaysTemplate)
            self.imageGuestUser.tintColor = .white
            self.heightConstrintsPassword.constant = self.heightConstrintsUserName.constant
            self.textFieldPassword.isHidden = false
            self.buttonLogin.setTitle(NSLocalizedString("MSG416", comment: ""), for: .normal)
            
            
        }
        
    }
    @IBAction func buttonGuestUser(_ sender: Any) {
        if(isExstingUSer == true)
        {
            isExstingUSer = false
            self.imageExistingUser.image = UIImage(named:"de_select_100x100")?.withRenderingMode(.alwaysTemplate)
            self.imageExistingUser.tintColor = .white
            self.imageGuestUser.image = UIImage(named:"slect_100x100")?.withRenderingMode(.alwaysTemplate)
            self.imageGuestUser.tintColor = .white
            self.heightConstrintsPassword.constant = 0
            self.textFieldPassword.isHidden = true
            self.buttonLogin.setTitle(NSLocalizedString("MSG415", comment: ""), for: .normal)
            
        }
        else
        {
            isExstingUSer = true
            self.imageExistingUser.image = UIImage(named:"slect_100x100")?.withRenderingMode(.alwaysTemplate)
            self.imageExistingUser.tintColor = .white
            self.imageGuestUser.image = UIImage(named:"de_select_100x100")?.withRenderingMode(.alwaysTemplate)
            self.imageGuestUser.tintColor = .white
            self.heightConstrintsPassword.constant = self.heightConstrintsUserName.constant
            self.textFieldPassword.isHidden = false
            self.buttonLogin.setTitle(NSLocalizedString("MSG416", comment: ""), for: .normal)
            
            
        }
    }
    
    func checkoutWithGuest()
    {
        
        
        MBProgress().showIndicator(view: self.view)
        
        
        WebServiceHelper.sharedInstanceAPI.hitPostAPI(urlString: KeyConstant.APIGuestChecout, params: ["email":textFieldEmail.text ?? "","guestid":KeyConstant.user_Default.value(forKey: KeyConstant.kUserSessionTempId) as? String ?? "","device_id":KeyConstant.user_Default.value(forKey: KeyConstant.kDeviceToken) as? String ?? ""], completionHandler: { (result: [String:Any], err:Error?) in
            print(result)
            MBProgress().hideIndicator(view: self.view)
            
            if(!(err == nil))
            {
                KeyConstant.sharedAppDelegate.showAlertView(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString:err?.localizedDescription ?? NSLocalizedString("MSG21", comment: ""))
                
                return
            }
            let json = JSON(result)
            
            let statusCode = json["status"].string
            
            if(statusCode == "success")
            {
                if let dicData = json["result"].dictionary
                {
                    
                    
                    
                    if let userId = dicData["id"]?.string
                    {
                        KeyConstant.user_Default.set(userId, forKey: KeyConstant.kCheckoutGuestId)
                        KeyConstant.user_Default.set("yes", forKey: KeyConstant.kFromGuestCheckoutLogin)
                        
                        
                        KeyConstant.user_Default.set("Guest User", forKey: KeyConstant.kuserName)
                        
                        KeyConstant.user_Default.set(self.textFieldEmail.text!, forKey: KeyConstant.kuserEmail)
                        
                        if(self.isPresentFromCheckOut == true)
                        {
                            
                            
                            self.dismiss(animated: true, completion: {
                                if(self.delegateReloadData != nil)
                                {
                                    self.delegateReloadData.reloadDataSelected()
                                }
                            })
                            return
                        }
                        else
                        {
                            KeyConstant.sharedAppDelegate.setRoot()
                            
                        }
                        
                    }
                    
                    
                }
                
                
                
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
    @IBAction func buttonFilter(_ sender: Any) {
        KeyConstant.sharedAppDelegate.showFilterScreen(vc: self)
        
    }
    @IBAction func buttonSearch(_ sender: Any) {
        KeyConstant.sharedAppDelegate.showSearchScreen(vc: self)
        
    }
    @IBAction func butttonBack(_ sender: Any) {
        
//        if let strIsFromMyAccountTab =  KeyConstant.user_Default.value(forKey:KeyConstant.kSelectedTabBarIndex) as? String
//        {
            if(self.tabBarController?.selectedIndex == 4)
            {
                KeyConstant.sharedAppDelegate.setRoot()
                return
            }
        //}
        
        
        self.dismiss(animated: false, completion:
                     {
            if(self.delegateReloadData != nil)
            {
                self.delegateReloadData.reloadDataSelected()
            }
        })
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
    
    @IBAction func buttonSignup(_ sender: Any) {
        let singupVC = self.storyboard?.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
        singupVC.isPresentFromMenu = isPresentFromMenu
        singupVC.isPresentFromCheckOut = isPresentFromCheckOut
        singupVC.isPresentGuestSignup = isPresentGuestSignup
        singupVC.delegateReloadData  = delegateReloadData
        self.present(singupVC, animated: false, completion: nil)
        
    }
    
    @IBAction func buttonForgotPassword(_ sender: Any) {
        let forgotVC = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        //forgotVC.modalPresentationStyle = .overCurrentContext
        self.present(forgotVC, animated: false, completion: nil)
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    }
