//
//  EditProfileVC.swift
//  LENZZO
//
//  Created by Apple on 11/19/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import UIKit
import Kingfisher
import AlamofireImage
import SwiftyJSON

class EditProfileVC: UIViewController {
    var arrayData = [JSON]()
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var imageFeMale: UIImageView!
    
    @IBOutlet weak var editProfileTitleLbl: PaddingLabel!
    @IBOutlet weak var labelMale: UILabel!
    @IBOutlet weak var labelFemale: UILabel!
    @IBOutlet weak var imageMale: UIImageView!
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    var arrayGender = ["Male","Female"]
    var isFemaleMale = String()
    @IBOutlet weak var textFieldDOB: RoundTextField!
    @IBOutlet weak var textFieldMobile: RoundTextField!
    @IBOutlet weak var textFieldCode: RoundTextField!
    @IBOutlet weak var textFieldName: RoundTextField!
    
    @IBOutlet weak var cartBtn: UIButton!
    @IBOutlet weak var backImgView: UIImageView!
    
    @IBOutlet weak var labelCountCart: UILabel!
    let picker = UIImagePickerController()
    
    
    var pickerView: UIPickerView!
    
    let datePickerView = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.labelMale.text = NSLocalizedString("MSG361", comment: "")
        self.labelFemale.text = NSLocalizedString("MSG362", comment: "")
        self.imageViewProfile.contentMode = .scaleAspectFill
        self.imageViewProfile.clipsToBounds = true
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(rightSwip))
        
        if(HelperArabic().isArabicLanguage())
        {
            
            swipeRight.direction = UISwipeGestureRecognizer.Direction.left
            
        }
        else
        {
            swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        }
        
        arrayGender = [NSLocalizedString("MSG361", comment: ""),NSLocalizedString("MSG362", comment: "")]
        
        
        self.view.addGestureRecognizer(swipeRight)
        picker.delegate = self
        
        datePickerView.datePickerMode = .date
        textFieldDOB.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        if HelperArabic().isArabicLanguage(){
                   datePickerView.locale = Locale(identifier: "ar")
               }else{
                   datePickerView.locale = Locale(identifier: "en")
               }
        
        pickerView = UIPickerView()
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        self.textFieldCode.inputView = pickerView
        self.toolbar()
        
        
        self.textFieldMobile.keyboardType = .asciiCapableNumberPad
        
        // self.textFieldCode.text = "+965"
        self.textFieldCode.text = KeyConstant.user_Default.value(forKey: KeyConstant.kuserCountryCode) as? String ?? "+965"
        
        imageMale.isHidden = true
        imageFeMale.isHidden = true
        isFemaleMale = ""
        self.getCountryLanguage()
        self.getProfileData()
               self.changeTintAndThemeColor()
        self.textFieldName.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        self.textFieldDOB.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        self.textFieldMobile.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        self.textFieldCode.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        self.editProfileTitleLbl.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        self.buttonSubmit.titleLabel?.font = UIFont(name: FontLocalization.Bold.strValue, size: 15.0)
        }
        
        
        func changeTintAndThemeColor(){
            
         
            
            let cartImg = UIImage(named: "cart")?.withRenderingMode(.alwaysTemplate)
            self.cartBtn.setImage(cartImg, for: .normal)
            self.cartBtn.tintColor = .white
            
            self.backImgView.image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate)
            self.backImgView.tintColor = .white
            
            self.imageMale.image = UIImage(named: "right_tik_50x50")?.withRenderingMode(.alwaysTemplate)
            self.imageMale.tintColor = .white
            
        
            self.imageFeMale.image = UIImage(named: "right_tik_50x50")?.withRenderingMode(.alwaysTemplate)
            self.imageFeMale.tintColor = .white
            
//            self.buttonAlreadyLogin.setTitleColor(.white, for: .normal)
//            self.buttonAlreadyLogin.tintColor = .white
            self.scrollView.backgroundColor = .clear
            
        }
    
    func getProfileData()
    {
        
        MBProgress().showIndicator(view: self.view)
        
        WebServiceHelper.sharedInstanceAPI.hitPostAPI(urlString: KeyConstant.APIProfileDetails, params: ["user_id":KeyConstant.user_Default.value(forKey: KeyConstant.kuserId) as? String ?? ""], completionHandler: { (result: [String:Any], err:Error?) in
            print(result)
            DispatchQueue.main.async {
                
                MBProgress().hideIndicator(view: self.view)
            }
            if(!(err == nil))
            {
                return
            }
            let json = JSON(result)
            
            let statusCode = json["status"].string
            print(json)
            if(statusCode == "success")
            {
                self.textFieldName.text = String(json["response"]["name"].string ?? "")
                
                KeyConstant.user_Default.set(self.textFieldName.text ?? "", forKey: KeyConstant.kuserName)
                
                self.textFieldMobile.text = String(json["response"]["phone"].string ?? "")
                
                self.textFieldCode.text = String(json["response"]["country_code"].string ?? "")
                
                self.textFieldDOB.text = String(json["response"]["dob"].string ?? "")
                
                if let gender = json["response"]["gender"].string
                {
                    if(gender.lowercased() == NSLocalizedString("MSG361", comment: "").lowercased() || gender.lowercased() == "male" || gender.lowercased() == "الذكر")
                    {
                        self.isFemaleMale = self.arrayGender[0]
                        self.imageMale.isHidden = false
                        self.imageFeMale.isHidden = true
                    }
                    else
                    {
                        self.isFemaleMale = self.arrayGender[1]
                        self.imageMale.isHidden = true
                        self.imageFeMale.isHidden = false
                    }
                }
            }
            
            
            if let strUrl = json["response"]["profilephoto"].string
            {
                if(strUrl.count > 0)
                {
                    let urlString = strUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    
                    
                    self.imageViewProfile.kf.setImage(with: URL(string: KeyConstant.kImageProfilePicURL + urlString!)!, placeholder: UIImage.init(named: "noImage"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: { (downloadImage, error, cacheType, url) in
                        if(downloadImage != nil)
                        {
                            self.imageViewProfile.image = downloadImage!
                        }
                    })
                }
                else
                {
                    self.imageViewProfile.image = UIImage(named: "user(1)")
                    
                }
            }
            
        })
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.showCartCount()
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
       
        textFieldDOB.text = dateFormatter.string(from: sender.date)
    }
    @IBAction func buttonProfilePicChange(_ sender: Any) {
        self.openAlert()
    }
    
    @IBAction func buttonFemale(_ sender: Any) {
        isFemaleMale = arrayGender[0]
        imageMale.isHidden = false
        imageFeMale.isHidden = true
    }
    @IBAction func buttonMale(_ sender: Any) {
        
        isFemaleMale = arrayGender[1]
        imageMale.isHidden = true
        imageFeMale.isHidden = false
        
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
        
        
        WebServiceHelper.sharedInstanceAPI.hitPostAPI(urlString: KeyConstant.APIGetCountryList, params: [:], completionHandler: { (result: [String:Any], err:Error?) in
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
        //scrollView.dropShadow()
        
        self.textFieldCode.bottomBorderColor = UIColor.white
        self.textFieldName.bottomBorderColor = UIColor.white
        self.textFieldMobile.bottomBorderColor = UIColor.white
        
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height: self.buttonSubmit.frame.origin.y + 100)
        
        
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
        
        guard let name = textFieldName.text, (!(name.isEmpty)) else
            
        {
            KeyConstant.sharedAppDelegate.showAlertViewWithTextField(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG134", comment: ""),textField: textFieldName)
            return
        }
        
        guard let mobile = textFieldMobile.text, (!(mobile.isEmpty) && mobile.count > 7)
            else {
                
                if(textFieldCode.text == "+965")
                {
                    KeyConstant.sharedAppDelegate.showAlertViewWithTextField(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG213", comment: ""),textField:textFieldMobile )
                }
                else
                {
                    KeyConstant.sharedAppDelegate.showAlertViewWithTextField(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG3", comment: ""),textField:textFieldMobile )
                }
                return
        }
        guard let dob = textFieldDOB.text, (!(dob.isEmpty)) else
            
        {
            KeyConstant.sharedAppDelegate.showAlertViewWithTextField(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG365", comment: ""),textField: textFieldDOB)
            return
        }
//        if(isFemaleMale.count < 1)
//        {
//            KeyConstant.sharedAppDelegate.showAlertView(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG148", comment: ""))
//            return
//        }
        
        
        MBProgress().showIndicator(view: self.view)
        
        
        WebServiceHelper.sharedInstanceAPI.hitPostAPI(urlString: KeyConstant.APIProfileEdit, params: ["country_code":textFieldCode.text ?? "","phone":textFieldMobile.text ?? "","name":textFieldName.text ?? "","user_id":KeyConstant.user_Default.value(forKey: KeyConstant.kuserId) as? String ?? "","dob":textFieldDOB.text ?? ""], completionHandler: { (result: [String:Any], err:Error?) in
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
                
                KeyConstant.user_Default.set(self.textFieldName.text ?? "", forKey: KeyConstant.kuserName)
                
                let alertView = UIAlertController(title: NSLocalizedString("MSG31", comment: "").uppercased(), message: "", preferredStyle: .alert)
                let msgFont = [NSAttributedString.Key.font: UIFont(name: FontLocalization.medium.strValue, size: 15.0)!]
                let msgAttrString = NSMutableAttributedString(string: NSLocalizedString("MSG266", comment: ""), attributes: msgFont)
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension EditProfileVC:UIPickerViewDataSource, UIPickerViewDelegate
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.arrayData.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        var countryName = ""
        
        if HelperArabic().isArabicLanguage(){
            //asciiname_ar
            countryName = self.arrayData[row]["asciiname_ar"].string ?? ""
        }else{
           countryName = self.arrayData[row]["asciiname"].string ?? ""
        }
        
        return String(countryName) + String(format: " (%@) ",arrayData[row]["code"].string ?? "")
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if(self.arrayData.count > 0)
        {
            let row = self.pickerView.selectedRow(inComponent: 0)
            self.pickerView.selectRow(row, inComponent: 0, animated: false)
            self.textFieldCode.text = self.arrayData[row]["code"].string ?? ""
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
            self.textFieldCode.text = self.arrayData[row]["code"].string ?? ""
            self.textFieldMobile.text = ""
            self.view.endEditing(true)
        }
    }
    
    @objc func cancelPicker (sender:UIBarButtonItem)
    {
        
        self.view.endEditing(true)
    }
}
extension EditProfileVC : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if(textField == textFieldMobile)
        {
            var maxLength = 12
            if(textFieldCode.text == "+965")
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

extension EditProfileVC:UIImagePickerControllerDelegate,
UINavigationControllerDelegate{
    
    
    func createWithImage1(param:[String:String], vc:UIViewController, imageData: Data)
    {
        MBProgress().showIndicator(view: self.view)
        
        WebServiceHelper.sharedInstanceAPI.hitPostAPIWithImage(urlString: KeyConstant.APIProfileEdit, params: ["user_id":KeyConstant.user_Default.value(forKey: KeyConstant.kuserId) as? String ?? ""], imageData: imageData, imageKey: "profilephoto", completionHandler: { (result: [String:Any], err:Error?) in
            print(result)
            DispatchQueue.main.async {
                MBProgress().hideIndicator(view: self.view)
            }
            if(!(err == nil))
            {
                AppDelegate().showAlertView(vc:vc, titleString:(NSLocalizedString("MSG20", comment: "")), messageString: (err?.localizedDescription)!)
                return
            }
            let json = JSON(result)
            
            let statusCode = json["status"].string
            
            
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
            
            if(statusCode == "success")
            {
                print(json)
                
                let alertView = UIAlertController(title: NSLocalizedString("MSG31", comment: "").uppercased(), message: "", preferredStyle: .alert)
                let msgFont = [NSAttributedString.Key.font: UIFont(name: FontLocalization.medium.strValue, size: 15.0)!]
                let msgAttrString = NSMutableAttributedString(string: NSLocalizedString("MSG266", comment: ""), attributes: msgFont)
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
                
                AppDelegate().showAlertView(vc:vc, titleString:(NSLocalizedString("MSG23", comment: "")), messageString: message ?? NSLocalizedString("MSG23", comment: ""))
                return
            }
            
        })
        
        
        
    }
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        if(selectedImage != nil)
        {
            imageViewProfile.image = selectedImage
            
        }
        // Dismiss the picker.
        dismiss(animated: true, completion: {
            
            DispatchQueue.main.async {
                var dicParam: [String:String]
                dicParam = ["userid": KeyConstant.user_Default.value(forKey: KeyConstant.kuserId) as! String]
                let data =  selectedImage.jpegData(compressionQuality: 0.8)
                self.createWithImage1(param: dicParam, vc: self, imageData:data!)
            }
            
        })
        
    }
    
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
    }
    
    
    func openAlert()
    {
        
        let alertController = UIAlertController(title: NSLocalizedString("MSG269", comment: ""), message: "", preferredStyle: UIAlertController.Style.actionSheet)
        
        let cAction = UIAlertAction(title: NSLocalizedString("MSG267", comment: ""), style: UIAlertAction.Style.default, handler: {alert -> Void in
            self.btnCamera()
        })
        let gAction = UIAlertAction(title: NSLocalizedString("MSG268", comment: ""), style: UIAlertAction.Style.default, handler: {alert -> Void in
            self.btnGallary()
        })
        let cancelAction = UIAlertAction(title: NSLocalizedString("MSG53", comment: ""), style: UIAlertAction.Style.cancel, handler: nil)
        
        alertController.addAction(cAction)
        alertController.addAction(gAction)
        
        alertController.addAction(cancelAction)
        if UIDevice.current.userInterfaceIdiom == .pad {
            guard let viewBase = self.view else {
                return
                
            }
            alertController.popoverPresentationController?.permittedArrowDirections = .up
            alertController.popoverPresentationController?.sourceView = self.view
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    func btnCamera() {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = true
            picker.sourceType = UIImagePickerController.SourceType.camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            present(picker,animated: true,completion: nil)
        } else {
            noCamera()
        }
    }
    func noCamera(){
        let alertVC = UIAlertController(
            title: (NSLocalizedString("MSG43", comment: "")),
            message: (NSLocalizedString("MSG44", comment: "")),
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: (NSLocalizedString("MSG18", comment: "")),
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }
    func btnGallary() {
        
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        picker.modalPresentationStyle = .popover
        present(picker, animated: true, completion: nil)
        picker.popoverPresentationController?.sourceView = self.imageViewProfile
    }
    
}
