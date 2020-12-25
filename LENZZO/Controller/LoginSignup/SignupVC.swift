//
//  SingupVC.swift
//  LENZZO
//
//  Created by Apple on 8/20/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import UIKit
import Kingfisher
import AlamofireImage
import SwiftyJSON



class SignupVC: UIViewController {
    var arrayData = [JSON]()
    var isPresentFromCheckOut = Bool()
    
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var registerTitleLbl: PaddingLabel!
    @IBOutlet weak var buttonAlreadyLogin: UIButton!
    @IBOutlet weak var textFieldCPassword: RoundTextField!
    @IBOutlet weak var textFieldMobile: RoundTextField!
    @IBOutlet weak var textFieldCode: RoundTextField!
    @IBOutlet weak var textFieldName: RoundTextField!
    @IBOutlet weak var textFieldEmail: RoundTextField!
    @IBOutlet weak var textFieldPassword: RoundTextField!
    

    @IBOutlet weak var labelCountCart: UILabel!
    
    var isPresentFromMenu = Bool()
    var isPresentGuestSignup = Bool()
    
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    
    
    
    
    
    var pickerView: UIPickerView!
    
    var delegateReloadData: ReloadDataDelegate!
    
    
    @IBOutlet weak var backImgView: UIImageView!
    @IBOutlet weak var cartBtn: UIButton!
    @IBOutlet weak var searchBtn: UIButton!
    
    
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
        if let guest = KeyConstant.user_Default.value(forKey: KeyConstant.kCheckoutGuestId) as? String
        {
            self.textFieldEmail.text = KeyConstant.user_Default.value(forKey: KeyConstant.kuserEmail) as? String ?? ""
        }
        
        
        
//        let attributeString = NSMutableAttributedString(string: NSLocalizedString("MSG346", comment: ""),attributes: [NSAttributedString.Key.font : UIFont.init(name: FontLocalization.Bold.strValue, size: 11.0),NSAttributedString.Key.foregroundColor : UIColor.white])
//        // buttonAlreadyLogin.setAttributedTitle(attributeString, for: .normal)
//
//        //        let attributeWhat = NSMutableAttributedString(string: NSLocalizedString("MSG360", comment: ""),attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 11.0),NSAttributedString.Key.foregroundColor:UIColor.black])
//        //
//        //
//        let combination = NSMutableAttributedString()
//        combination.append(attributeString)
//        //  combination.append(attributeWhat)
//        buttonAlreadyLogin.setAttributedTitle(combination, for: .normal)
        
        buttonAlreadyLogin.setTitle(NSLocalizedString("MSG346", comment: ""), for: .normal)
        buttonAlreadyLogin.titleLabel?.font = UIFont(name: FontLocalization.Bold.strValue, size: 11.0)
        
        self.view.addGestureRecognizer(swipeRight)
        
        
        
        
        
        pickerView = UIPickerView()
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        self.textFieldCode.inputView = pickerView
        self.toolbar()
        
        self.textFieldMobile.keyboardType = .asciiCapableNumberPad
        
       if let mobileCode = KeyConstant.user_Default.value(forKey: KeyConstant.kuserCountryCode) as? String{
        if mobileCode.contains("+"){
            self.textFieldCode.text = mobileCode
        }else{
            self.textFieldCode.text = "+" + mobileCode
        }
       }else{
            self.textFieldCode.text = "+965"
        }
        
       // self.textFieldCode.text = KeyConstant.user_Default.value(forKey: KeyConstant.kuserCountryCode) as? String ?? "+965"
        
        self.getCountryLanguage()
        
            self.changeTintAndThemeColor()
            
        textFieldCPassword.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        textFieldMobile.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        textFieldCode.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        textFieldName.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        textFieldEmail.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        textFieldPassword.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        
        self.buttonAlreadyLogin.titleLabel?.font = UIFont(name: FontLocalization.medium.strValue, size: 9.0)
        self.buttonLogin.titleLabel?.font = UIFont(name: FontLocalization.Bold.strValue, size: 15.0)
        self.submitBtn.titleLabel?.font = UIFont(name: FontLocalization.Bold.strValue, size: 15.0)
        self.resetBtn.titleLabel?.font = UIFont(name: FontLocalization.Bold.strValue, size: 15.0)
        
        self.registerTitleLbl.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        
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
            
            
            
            self.buttonAlreadyLogin.setTitleColor(.white, for: .normal)
            self.buttonAlreadyLogin.tintColor = .white
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
    func getCountryLanguage()
    {
        
        MBProgress().showIndicator(view: self.view)
        
        self.arrayData.removeAll()
        
        
        WebServiceHelper.sharedInstanceAPI.hitPostAPI(urlString: KeyConstant.APIGetCountryList, params: ["only_selected_countries":"1"], completionHandler: { (result: [String:Any], err:Error?) in
            print(result)
            DispatchQueue.main.async {
                MBProgress().hideIndicator(view: self.view)
            }
            if(!(err == nil))
            {
                KeyConstant.sharedAppDelegate.showAlertView(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: err?.localizedDescription ?? NSLocalizedString("MSG21", comment: ""))
                return
            }
            
            let json = JSON(result)
            
            let statusCode = json["status"].string
            print(json)
            if(statusCode == "success")
            {
                self.arrayData = json["result"].array ?? [JSON]()
                
                self.pickerView.reloadAllComponents()
                
                
                
                
                
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
                KeyConstant.sharedAppDelegate.showAlertView(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: message ?? NSLocalizedString("MSG21", comment: ""))
            }
            
        })
        
        
        
    }
    
    override func viewWillLayoutSubviews() {
       // scrollView.dropShadow()
        self.textFieldEmail.bottomBorderColor = UIColor.white
        self.textFieldPassword.bottomBorderColor = UIColor.white
        self.textFieldCPassword.bottomBorderColor = UIColor.white
        self.textFieldCode.bottomBorderColor = UIColor.white
        self.textFieldName.bottomBorderColor = UIColor.white
        self.textFieldMobile.bottomBorderColor = UIColor.white
        
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height: self.buttonLogin.frame.origin.y + 100)
        
        
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
    
    
    @IBAction func buttonReset(_ sender: Any) {
        
        let strClear =  ""
        textFieldName.text = strClear
        textFieldEmail.text = strClear
        textFieldCode.text = strClear
        textFieldMobile.text = strClear
        textFieldPassword.text = strClear
        textFieldCPassword.text = strClear
        
        
    }
    @IBAction func buttonSubmit(_ sender: Any) {
        
        
        guard let name = textFieldName.text, (!(name.isEmpty)) else
            
        {
            KeyConstant.sharedAppDelegate.showAlertViewWithTextField(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG134", comment: ""),textField: textFieldName)
            return
        }
        guard let email = textFieldEmail.text, (!(email.isEmpty)) else
            
        {
            KeyConstant.sharedAppDelegate.showAlertViewWithTextField(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG2", comment: ""),textField: textFieldEmail)
            return
        }
        if(!(HelperArabic().isArabicLanguage()))
        {
            guard let emailValid = textFieldEmail.text, (emailValid.isValidEmail()) else
            {
                KeyConstant.sharedAppDelegate.showAlertViewWithTextField(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG6", comment: ""),textField: textFieldEmail)
                return
            }
        }
        
        guard let mobile = textFieldMobile.text, (!(mobile.isEmpty) && mobile.count > 7)
            else {
                
                if(textFieldCode.text == "+965" || textFieldCode.text == "965")
                {
                    KeyConstant.sharedAppDelegate.showAlertViewWithTextField(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG213", comment: ""),textField:textFieldMobile )
                }
                else
                {
                    KeyConstant.sharedAppDelegate.showAlertViewWithTextField(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG3", comment: ""),textField:textFieldMobile )
                }
                return
        }
        guard let password = textFieldPassword.text, (!(password.isEmpty))
            else {
                KeyConstant.sharedAppDelegate.showAlertViewWithTextField(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG4", comment: ""),textField:textFieldPassword )
                return
        }
        guard let passwordLength = textFieldPassword.text, (passwordLength.count > 5)
            else {
                KeyConstant.sharedAppDelegate.showAlertViewWithTextField(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG317", comment: ""),textField:textFieldPassword )
                return
        }
        
        
        guard let repassword = textFieldCPassword.text, (!(repassword.isEmpty))
            else {
                KeyConstant.sharedAppDelegate.showAlertViewWithTextField(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG5", comment: ""),textField: textFieldCPassword)
                return
        }
        
        
        guard let passwordCheck = textFieldCPassword.text, (passwordCheck == textFieldPassword.text)
            else {
                KeyConstant.sharedAppDelegate.showAlertViewWithTextField(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG8", comment: ""),textField:textFieldCPassword )
                return
        }
        
       
        var strValue = ""
        
        
        if(HelperArabic().isArabicLanguage())
        {
            strValue = KeyConstant.kArabicCode
        }
        else{
            
            strValue = KeyConstant.kEnglishCode
        }
        SignupViewModel().signup(vc: self, params: ["name":textFieldName.text ?? "","email":textFieldEmail.text ?? "","password":textFieldPassword.text ?? "","country_code":textFieldCode.text ?? "","phone":textFieldMobile.text ?? "","guestid":KeyConstant.user_Default.value(forKey: KeyConstant.kUserSessionTempId) as? String ?? "","device_id":KeyConstant.user_Default.value(forKey: KeyConstant.kDeviceToken) as? String ?? "2222222222222","current_language": strValue], isPresentFromMenu: isPresentFromMenu)
        
    }

    @IBAction func buttonLogin(_ sender: Any) {
        if(isPresentGuestSignup == true)
        {
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            loginVC.isPresentFromMenu = isPresentFromMenu
            loginVC.isPresentFromCheckOut = true
            loginVC.isPresentFromCheckOut = true
            loginVC.isPresentGuestSignup  = isPresentGuestSignup
            self.present(loginVC, animated: false, completion: nil)
            return
        }
        
        if(isPresentFromMenu == true)
        {
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            loginVC.isPresentFromMenu = isPresentFromMenu
            loginVC.isPresentFromCheckOut = isPresentFromCheckOut
            self.present(loginVC, animated: false, completion: nil)
        }
        else
        {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension SignupVC:UIPickerViewDataSource, UIPickerViewDelegate
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.arrayData.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        
        
        return String(self.arrayData[row]["asciiname"].string ?? "") + String(format: " (%@) ",arrayData[row]["code"].string ?? "")
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if(self.arrayData.count > 0)
        {
            let row = self.pickerView.selectedRow(inComponent: 0)
            self.pickerView.selectRow(row, inComponent: 0, animated: false)
            if let mobileCode = self.arrayData[row]["code"].string{
                
                if mobileCode.contains("+"){
                    self.textFieldCode.text = mobileCode
                }else{
                  self.textFieldCode.text = "+" + mobileCode
                }
               
            }else{
              self.textFieldCode.text = ""
            }
            self.textFieldMobile.text = ""
            
        }
        
    }
    
    
    
    func toolbar()
    {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: NSLocalizedString("MSG344", comment: ""), style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: NSLocalizedString("MSG53", comment: ""), style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelPicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textFieldCode.inputAccessoryView = toolBar
    }
    
    
    
    @objc func donePicker (sender:UIBarButtonItem)
    {
        if(self.arrayData.count > 0)
        {
            let row = self.pickerView.selectedRow(inComponent: 0)
            self.pickerView.selectRow(row, inComponent: 0, animated: false)
            if let code = self.arrayData[row]["code"].string{
               self.textFieldCode.text = "+" + code
            }
            
            self.textFieldMobile.text = ""
            self.view.endEditing(true)
        }
    }
    
    @objc func cancelPicker (sender:UIBarButtonItem)
    {
        
        self.view.endEditing(true)
    }
}
extension SignupVC : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if(textField == textFieldMobile)
        {
            var maxLength = 10
            if(textFieldCode.text == "+965" || textFieldCode.text == "965")
            {
                maxLength = 8
            }
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        return true
    }
}
