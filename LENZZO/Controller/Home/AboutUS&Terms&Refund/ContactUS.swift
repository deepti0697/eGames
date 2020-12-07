//
//  Contact US.swift
//  LENZZO
//
//  Created by Apple on 10/1/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import UIKit
import WebKit
import Kingfisher
import AlamofireImage
import SwiftyJSON
import IQKeyboardManagerSwift
import MessageUI

class ContactUS: UIViewController,MFMailComposeViewControllerDelegate {
    var arrayData = [JSON]()
    
    var arraySocial = [JSON]()
    @IBOutlet weak var labelPhone: UILabel!
    @IBOutlet weak var labelEmail2: UILabel!
    @IBOutlet weak var labelWhatsapp: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var textViewMessage: IQTextView!
    @IBOutlet weak var buttonDone: UIButton!
    @IBOutlet weak var textFieldMobile: RoundTextField!
    @IBOutlet weak var textFieldCode: RoundTextField!
    @IBOutlet weak var textFieldName: RoundTextField!
    @IBOutlet weak var textFieldEmail: RoundTextField!
   
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var lowerView: UIView!

    @IBOutlet weak var collectionView: UICollectionView!
    
    var pickerView: UIPickerView!
    var arrayCountryCode = [String]()
    var arrayCountryName = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
     
        pickerView = UIPickerView()
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        self.toolbar()
        
        self.textFieldCode.inputView = pickerView
        self.textFieldMobile.keyboardType = .asciiCapableNumberPad

        self.textFieldCode.text = "+965"
        self.textFieldCode.isUserInteractionEnabled = true
        self.getCountryLanguage()
        self.getContactsData()
        self.getSocialIcons()
        self.textViewMessage.text = NSLocalizedString("MSG423", comment: "")
        self.textViewMessage.textColor = .lightGray
        self.textViewMessage.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10);
        self.textViewMessage.delegate = self
        if(HelperArabic().isArabicLanguage())
        {
            textViewMessage.textAlignment = .right
            
        }
        else
        {
            textViewMessage.textAlignment = .left
            
        }
        
     
    }
    func initialSetUp(){
        
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            let horizontalSpacing = flowLayout.scrollDirection == .vertical ? flowLayout.minimumInteritemSpacing : flowLayout.minimumLineSpacing
            
//            let tablewidth = ((CGFloat(UIScreen.main.bounds.width) - CGFloat(25)))/2
            flowLayout.itemSize = CGSize(width: 50, height: 50)
        }
    }
    
//    @IBAction func buttonEmail(_ sender: Any) {
//
//        self.sendMail(email: labelEmail1.text ?? "")
//    }
//
    
    @IBAction func buttonMail2(_ sender: Any) {
        
        self.sendMail(email: labelEmail2.text ?? "")

    }
    
    func sendMail(email:String)
    {
        print(email)
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }
        
        if(!(email.isEmpty))
        {
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            
            // Configure the fields of the interface.
            composeVC.setToRecipients([email])
            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        // Check the result or perform other tasks.
        
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }

    @IBAction func buttonWhatsapp(_ sender: Any) {
        if( self.labelWhatsapp.text!.count > 0)
        {
            let phoneNumber = self.labelWhatsapp.text?.replacingOccurrences(of: " ", with: "")
            
            let urlWhats = "whatsapp://send?phone=" + String(phoneNumber ?? "")
            if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
                if let whatsappURL = URL(string: urlString) {
                    if UIApplication.shared.canOpenURL(whatsappURL) {
                        UIApplication.shared.openURL(whatsappURL)
                    } else {
                        print("Install Whatsapp")
                    }
                }
            }
            else
            {
                let whatsappURL = URL(string: "https://api.whatsapp.com/send?phone=" + String(phoneNumber ?? ""))
                if UIApplication.shared.canOpenURL(whatsappURL!) {
                    UIApplication.shared.open(whatsappURL!, options: [:], completionHandler: nil)
                }
            }
        }
        
    }
    @IBAction func buttonCall(_ sender: Any) {
        if( (self.labelPhone.text?.count)! > 0)
        {
            self.callNumber(phoneNumber: self.labelPhone.text!)
        }
    }
    
     func callNumber(phoneNumber:String) {
        let phoneNum = phoneNumber.replacingOccurrences(of: " ", with: "")

        
        if let phoneCallURL = URL(string: "telprompt://\(phoneNum)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    application.openURL(phoneCallURL as URL)
                    
                }
            }
        }
    }
    override func viewWillLayoutSubviews() {
        self.textFieldEmail.bottomBorderColor = UIColor.white
        self.textFieldCode.bottomBorderColor = UIColor.white
        self.textFieldName.bottomBorderColor = UIColor.white
        self.textFieldMobile.bottomBorderColor = UIColor.white
        
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height: self.upperView.frame.origin.y + self.upperView.frame.height + 50)
//            self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height: 700)
        self.initialSetUp()
        
        lowerView.backgroundColor = .white
        lowerView.dropShadow(color: .gray, opacity: 0.5, offSet: CGSize(width: 0, height: 0), radius: 2, scale: true)

        upperView.backgroundColor = .white
        upperView.dropShadow(color: .gray, opacity: 0.5, offSet: CGSize(width: 0, height: 0), radius: 2, scale: true)
        
        

        
    }
   
    @IBAction func butttonBack(_ sender: Any) {
        KeyConstant.sharedAppDelegate.setRoot()
    }
    
    func getContactsData()
    {
        labelWhatsapp.text = ""
        labelEmail2.text = ""
        labelPhone.text = ""
        
        MBProgress().showIndicator(view: self.view)
        
        
        WebServiceHelper.sharedInstanceAPI.hitPostAPI(urlString: KeyConstant.APIContactDetails, params: [:], completionHandler: { (result: [String:Any], err:Error?) in
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
                if let dicData = json["response"]["cms_detail_Array"]["admin_settings"].dictionary
                {
                    if(dicData.count > 0)
                    {
                        self.labelWhatsapp.text = dicData["whatsup_number"]?.string ?? ""
                        self.labelEmail2.text = dicData["order_email"]?.string ?? ""
                        self.labelPhone.text = dicData["support_number"]?.string ?? ""

                        
                    }
                }
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
    
    @IBAction func buttonReset(_ sender: Any) {
        
        textFieldName.text = ""
        textFieldEmail.text = ""
        textFieldCode.text = ""
        textFieldMobile.text = ""
        textViewMessage.text = ""

        
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
        guard let emailValid = textFieldEmail.text, (emailValid.isValidEmail()) else
        {
            KeyConstant.sharedAppDelegate.showAlertViewWithTextField(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG6", comment: ""),textField: textFieldEmail)
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
       if(textViewMessage.text.count == 0 )
       {
         KeyConstant.sharedAppDelegate.showAlertViewWithTextField(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG136", comment: ""),textField: textFieldMobile)
        return
        }
        
        let strPhone = String(textFieldCode.text ?? "") + String(textFieldMobile.text ?? "")
        self.submitQuery(param: ["name":textFieldName.text ?? "","email":textFieldEmail.text ?? "","phone":strPhone,"message":textViewMessage.text ?? ""])
        
     
    }
    
    func submitQuery(param:[String:String])
    {
    
    MBProgress().showIndicator(view: self.view)
    self.arraySocial.removeAll()
    
    WebServiceHelper.sharedInstanceAPI.hitPostAPI(urlString: KeyConstant.APIContactQuery, params:param, completionHandler: { (result: [String:Any], err:Error?) in
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
    print(json)
    if(statusCode == "success")
    {
        KeyConstant.sharedAppDelegate.showAlertView(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG243", comment: ""))
        self.textFieldName.text = ""
        self.textFieldEmail.text = ""
        self.textFieldCode.text = "+965"
        self.textFieldMobile.text = ""
        self.textViewMessage.text = ""
        self.view.endEditing(true)
        
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
    
    func getSocialIcons()
    {
       
        MBProgress().showIndicator(view: self.view)
        self.arraySocial.removeAll()
        
        WebServiceHelper.sharedInstanceAPI.hitPostAPI(urlString: KeyConstant.APISocialDetails, params: [:], completionHandler: { (result: [String:Any], err:Error?) in
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
                if let arrayData = json["response"]["social_Array"]["social_list"].array
                {
                    if(arrayData.count > 0)
                    {
                        
                        self.arraySocial = arrayData
                        self.collectionView.reloadData()
                        
                    }
                }
            }})
        
        
        
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
extension ContactUS:UIPickerViewDataSource, UIPickerViewDelegate
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
extension ContactUS : UITextFieldDelegate,UITextViewDelegate
{
   
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        
        if(textView == textViewMessage)
        {
            textView.textColor = .black
            
            if(textView.text == NSLocalizedString("MSG423", comment: "")) {
                textView.text = ""
            }
        }
        
        
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if(textView == textViewMessage)
        {
            if(textView.text == "") {
                
                
                textView.text = NSLocalizedString("MSG423", comment: "")
                textView.textColor = .lightGray
                
            }
        }
        
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
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
    extension ContactUS: UICollectionViewDelegate,UICollectionViewDataSource
    {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            
            return  arraySocial.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let cell:ContactViewCell!
            
            cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "ContactViewCell", for: indexPath) as? ContactViewCell
            
            cell.imageViewCategory.contentMode = .scaleAspectFit
            
            if let strUrl = arraySocial[indexPath.item]["image"].string
            {
                if(strUrl.count > 0)
                {
                    let urlString = strUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    
                    
                    cell.imageViewCategory.kf.setImage(with: URL(string: KeyConstant.kImageSocialURL + urlString!)!, placeholder: UIImage.init(named: "noImage"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: { (downloadImage, error, cacheType, url) in
                        if(downloadImage != nil)
                        {
                            cell.imageViewCategory.image = downloadImage!
                        }
                    })
                }
                else
                {
                    cell.imageViewCategory.image = UIImage(named: "noImage")
                    
                }
            }
            else
            {
                cell.imageViewCategory.image = UIImage(named: "noImage")
                
            }
            
            return cell
            
        }
        
        
        
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
        {
            
            let objVC = self.storyboard?.instantiateViewController(withIdentifier: "AboutUS") as! AboutUS
            objVC.typeCMSAPI = "social"
            
            objVC.webURL = arraySocial[indexPath.item]["url"].string ?? ""
            objVC.titleString = arraySocial[indexPath.item]["name"].string?.uppercased() ?? ""
            self.slideMenuController()?.present(objVC, animated: false, completion: nil)
            
            
        }
        
        
}
class ContactViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageViewCategory: UIImageView!
   
}
