//
//  ReviewVC.swift
//  LENZZO
//
//  Created by Apple on 11/20/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import UIKit
import Kingfisher
import AlamofireImage
import SwiftyJSON

protocol DelegateOrderUpdate {
    func orderUpdate()
}

class ReviewVC: UIViewController,UITextViewDelegate, UITextFieldDelegate {
    
    var delegateOrder: DelegateOrderUpdate!

    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var buttonTitle: UIButton!
    @IBOutlet weak var buttonClose: UIButton!
    var dicData = [String:JSON]()
    var rate = 0
    @IBOutlet weak var textViewMEssage: UITextView!
    @IBOutlet weak var textFieldName: UITextField!
    var stringTitle = String()

    @IBOutlet weak var imageReview1: UIImageView!
    @IBOutlet weak var imageReview2: UIImageView!
    @IBOutlet weak var imageReview3: UIImageView!
    @IBOutlet weak var imageReview4: UIImageView!
    @IBOutlet weak var imageReview5: UIImageView!
    var placeholderLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dicData)
    
        
        self.buttonTitle.setTitle(NSLocalizedString("MSG270", comment: ""), for: .normal)
        self.buttonSubmit.setTitle(NSLocalizedString("MSG272", comment: ""), for: .normal)
        self.buttonClose.setTitle(NSLocalizedString("MSG273", comment: ""), for: .normal)

        textFieldName.addPadding(.left(10))
        
    
        
        if let stringFName =  KeyConstant.user_Default.value(forKey: KeyConstant.kuserName) as? String
            
        {
            self.textFieldName.text = stringFName
        }
        
        
        
        self.textFieldName.addPadding(.left(10))

        
        //self.textViewMEssage.text = NSLocalizedString("MSG271", comment: "")
        self.textViewMEssage.textColor = .white
        self.textViewMEssage.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10);
        
        if(HelperArabic().isArabicLanguage())
        {
            textFieldName.textAlignment = .right
            textViewMEssage.textAlignment = .right
            
        }
        else
        {
            textFieldName.textAlignment = .left
            textViewMEssage.textAlignment = .left
            
        }
        
        self.imageReview1.image = UIImage(named: "star_blank_50x50")?.withRenderingMode(.alwaysTemplate)
        self.imageReview1.tintColor = .white
        
        self.imageReview2.image = UIImage(named: "star_blank_50x50")?.withRenderingMode(.alwaysTemplate)
               self.imageReview2.tintColor = .white
        
        self.imageReview3.image = UIImage(named: "star_blank_50x50")?.withRenderingMode(.alwaysTemplate)
               self.imageReview3.tintColor = .white
        
        self.imageReview4.image = UIImage(named: "star_blank_50x50")?.withRenderingMode(.alwaysTemplate)
               self.imageReview4.tintColor = .white
        
        self.imageReview5.image = UIImage(named: "star_blank_50x50")?.withRenderingMode(.alwaysTemplate)
               self.imageReview5.tintColor = .white
        
        self.setupPlaceHolder()
        self.buttonSubmit.titleLabel?.font = UIFont(name: FontLocalization.medium.strValue, size: 16.0)
        self.buttonClose.titleLabel?.font = UIFont(name: FontLocalization.medium.strValue, size: 16.0)
        self.buttonTitle.titleLabel?.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        self.textFieldName.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        self.textViewMEssage.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)

        
        }
        
        func setupPlaceHolder(){
            placeholderLabel = UILabel()
            placeholderLabel.text = NSLocalizedString("MSG271", comment: "")
            placeholderLabel.textColor = UIColor.lightGray.withAlphaComponent(0.25)
           // placeholderLabel.font = UIFont(name: "Poppins-Light", size: reviewTxtView.font!.pointSize)
            placeholderLabel.sizeToFit()
            textViewMEssage.addSubview(placeholderLabel)
            placeholderLabel.frame.origin = CGPoint(x: 5, y: (textViewMEssage.font?.pointSize)! / 2)
            placeholderLabel.textColor = UIColor.lightGray
            placeholderLabel.isHidden = !textViewMEssage.text.isEmpty
        }
    
    @IBAction func buttonSubmit(_ sender: Any) {
        
        guard let name = textFieldName.text, (!(name.isEmpty))
            else {
                KeyConstant.sharedAppDelegate.showAlertView(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG134", comment: ""))
                return
        }
       
        
        
        guard let mesg = textViewMEssage.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            else {
                KeyConstant.sharedAppDelegate.showAlertView(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG136", comment: ""))
                return
        }
        
       
            
            if(rate > 0)
                   {
                    if(mesg.count > 0){
                       self.addReview()
                    }
                    else{
                    KeyConstant.sharedAppDelegate.showAlertView(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG136", comment: ""))
                    }
                   
                   }
                   else
                   {
                       KeyConstant.sharedAppDelegate.showAlertView(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG277", comment: ""))

                   }
      
       
        
    }
    @IBAction func buttonClose(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
        
    }
    
 
    /*
     
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */

    
    //MARK:- TEXTVIEW DELEGATE METHODS
    
//    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
//
//
//        if(textView == textViewMEssage)
//        {
//            textView.textColor = .white
//
//            if(textView.text == NSLocalizedString("MSG271", comment: "")) {
//                textView.text = ""
//            }
//        }
//
//
//        return true
//    }
//
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if(textView == textViewMEssage)
//        {
//            if(textView.text == "") {
//
//
//                textView.text = NSLocalizedString("MSG271", comment: "")
//                textView.textColor = .white
//
//            }
//        }
//
//    }
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if text == "\n" {
//            textView.resignFirstResponder()
//            return false
//        }
//        return true
//    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    
    func addReview()
    {
        let productId = String(dicData["product_id"]?.string ?? "")
        let producName = String(dicData["product_name"]?.string ?? "")
        let orderId = String(dicData["product_order_id"]?.string ?? "")
        let order_detail_id = String(dicData["id"]?.string ?? "")


        
        let params = ["user_id":KeyConstant.user_Default.value(forKey: KeyConstant.kuserId) as? String ?? "" ,"user_name":textFieldName.text ?? "","comment":textViewMEssage.text ?? "","product_id":productId,"product_name":producName,"rating":String(rate),"order_id":orderId,"order_detail_id":order_detail_id]
        
        print(params)
        
        MBProgress().showIndicator(view: self.view)
        
        
        WebServiceHelper.sharedInstanceAPI.hitPostAPI(urlString: KeyConstant.APIReviewSent, params:params , completionHandler: { (result: [String:Any], err:Error?) in
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
                
     
                let alertView = UIAlertController(title: NSLocalizedString("MSG31", comment: "").uppercased(), message: "", preferredStyle: .alert)
                let msgFont = [NSAttributedString.Key.font: UIFont(name: FontLocalization.medium.strValue, size: 15.0)!]
                let msgAttrString = NSMutableAttributedString(string: message ?? "", attributes: msgFont)
                alertView.setValue(msgAttrString, forKey: "attributedMessage")
                
                let alertAction = UIAlertAction(title: NSLocalizedString("MSG18", comment: ""), style: .default) { (alert) in
                    self.dismiss(animated: true, completion: {
                    self.delegateOrder.orderUpdate()
                    })
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
    
    @IBAction func buttonReview1(_ sender: Any) {
        self.setRating(rating: 1)
    }
    @IBAction func buttonReview2(_ sender: Any) {
        self.setRating(rating: 2)
    }
    @IBAction func buttonReview3(_ sender: Any) {
        self.setRating(rating: 3)
    }
    @IBAction func buttonReview4(_ sender: Any) {
        self.setRating(rating: 4)
    }
    @IBAction func buttonReview5(_ sender: Any) {
        self.setRating(rating: 5)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func setRating(rating:Int)
    {
        
        var applyRate = rating
        if(rate == applyRate)
        {
            applyRate = 0
        }
        let imageSelected = UIImage(named:"star")?.maskWithColor(color: AppColors.SelcetedColor)
        
        let imageUnSelected = UIImage(named:"star_blank_50x50")?.maskWithColor(color: .white)
            
            self.imageReview1.image = imageUnSelected
            self.imageReview2.image = imageUnSelected
            self.imageReview3.image = imageUnSelected
            self.imageReview4.image = imageUnSelected
            self.imageReview5.image = imageUnSelected
            
            
            switch applyRate
            {
            case 0 :
                break
            case 1 :
                self.imageReview1.image = imageSelected
                break
            case 2 :
                self.imageReview1.image = imageSelected
                self.imageReview2.image = imageSelected
                break
            case 3 :
                self.imageReview1.image = imageSelected
                self.imageReview2.image = imageSelected
                self.imageReview3.image = imageSelected
                break
            case 4 :
                self.imageReview1.image = imageSelected
                self.imageReview2.image = imageSelected
                self.imageReview3.image = imageSelected
                self.imageReview4.image = imageSelected
                break
            case 5 :
                self.imageReview1.image = imageSelected
                self.imageReview2.image = imageSelected
                self.imageReview3.image = imageSelected
                self.imageReview4.image = imageSelected
                self.imageReview5.image = imageSelected
                
                break
            default:
                break
        }
        
        self.rate = applyRate

    }
}
