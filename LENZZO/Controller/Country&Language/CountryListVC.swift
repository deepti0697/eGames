//
//  CountryListVC.swift
//  LENZZO
//
//  Created by Apple on 9/26/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import UIKit
import Kingfisher
import AlamofireImage
import SwiftyJSON
class CountryListVC: UIViewController {
    
    @IBOutlet weak var buttonApply: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var buttonArabic: UIButton!
    @IBOutlet weak var buttonEnglish: UIButton!
    
    @IBOutlet weak var labelLanguage: UILabel!
    @IBOutlet weak var labelCountry: UILabel!
    
    var arrayData = [JSON]()
    var strValue = String()
    
    var arrayTempSelection = [Bool]()
    
    var arrayLanguage = ["English","العربية"]
    var selectedLangauge: String?
    
    var yellowColor = AppColors.SelcetedColor
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
        if(HelperArabic().isArabicLanguage())
        {
            self.setArabic()
            
        }
        else
        {
            self.setEnglish()
            
        }
        
        if let isLanguageSelected = KeyConstant.user_Default.value(forKey: KeyConstant.kSelectedLanguage) as? String
        {
            if(isLanguageSelected.count > 0)
            {
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
                
                for ind in 0..<arrayLanguage.count
                {
                    if(arrayLanguage[ind] == isLanguageSelected)
                    {
                        if(ind == 1)
                        {
                            self.setArabic()
                        }
                        else
                        {
                            self.setEnglish()
                            
                        }
                        
                    }
                }
            }
        }
        
        
        self.tableView.reloadData()
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.getCountryList()
        
    }
    func getCountryList()
    {
        
        MBProgress().showIndicator(view: self.view)
        
        self.arrayData.removeAll()
        
        self.arrayTempSelection.removeAll()
        
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
                
                for ind in 0..<self.arrayData.count
                {
                    self.arrayTempSelection.insert(false, at: self.arrayTempSelection.count)
                }
                
                if let isCountrySelected = KeyConstant.user_Default.value(forKey: KeyConstant.kSelectedCountry) as? String
                {
                    if(isCountrySelected.count > 0)
                    {
                        for ind in 0..<self.arrayData.count
                        {
                            if(self.arrayData[ind]["asciiname"].string?.lowercased() == isCountrySelected.lowercased())
                            {
                                self.arrayTempSelection[ind] = true
                            }
                            else
                            {
                                self.arrayTempSelection[ind] = false
                                
                            }
                        }
                    }
                }
                self.tableView.reloadData()
                
                
                
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
    @IBAction func buttonBack(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func rightSwip(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            self.buttonBack(UIButton())
            
        }
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @IBAction func buttonEnglishLangauge(_ sender: Any) {
        self.setEnglish()
    }
    
    @IBAction func buttonArabicLangauge(_ sender: Any) {
        
        self.setArabic()
        
    }
    
    func setEnglish()
    {
        strValue = KeyConstant.kEnglishCode
        selectedLangauge = arrayLanguage[0]
        self.buttonEnglish.backgroundColor = yellowColor
        self.buttonArabic.backgroundColor = .white
        self.buttonEnglish.setTitleColor(.white, for: .normal)
        self.buttonArabic.setTitleColor(yellowColor, for: .normal)
        self.labelLanguage.text = NSLocalizedString("MSG382", comment: "")
        self.labelCountry.text = NSLocalizedString("MSG383", comment: "")
        self.buttonApply.setTitle(NSLocalizedString("MSG358", comment: ""), for: .normal)
        self.getCountryList()
    }
    
    func setArabic()
    {
        strValue = KeyConstant.kArabicCode
        selectedLangauge = arrayLanguage[1]
        self.buttonArabic.backgroundColor = yellowColor
        self.buttonEnglish.backgroundColor = .white
        self.buttonArabic.setTitleColor(.white, for: .normal)
        self.buttonEnglish.setTitleColor(yellowColor, for: .normal)
        
        self.labelLanguage.text = NSLocalizedString("MSG384", comment: "")
        self.labelCountry.text = NSLocalizedString("MSG385", comment: "")
        self.buttonApply.setTitle(NSLocalizedString("MSG359", comment: ""), for: .normal)
        
        self.getCountryList()
        
        
    }
    @IBAction func buttonActionApply(_ sender: Any) {
        
        
        
        if(selectedLangauge?.count == 0)
        {
            
            KeyConstant.sharedAppDelegate.showAlertView(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG229", comment: ""))
            return
        }
        
        if(!(arrayTempSelection.contains(true)))
        {
            KeyConstant.sharedAppDelegate.showAlertView(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG230", comment: ""))
            return
        }
        self.updateCountryList()
        
        
    }
    func updateCountryList()
    {
        
        MBProgress().showIndicator(view: self.view)
        
        
        WebServiceHelper.sharedInstanceAPI.hitPostAPI(urlString: KeyConstant.APIChange_language, params: ["current_language":strValue,"user_id":KeyConstant.sharedAppDelegate.getUserId()], completionHandler: { (result: [String:Any], err:Error?) in
            print(result)
            DispatchQueue.main.async {
                MBProgress().hideIndicator(view: self.view)
            }
            if(err != nil)
            {
                self.updateCountryList()
                return
            }
            let json = JSON(result)
            
            let statusCode = json["status"].string
            print(json)
            if(statusCode == "success")
            {
                KeyConstant.user_Default.setValue(self.selectedLangauge, forKey: KeyConstant.kSelectedLanguage)
                
                for ind in 0..<self.arrayData.count
                {
                    if(self.arrayTempSelection[ind] == true)
                    {
                        KeyConstant.user_Default.setValue(self.arrayData[ind]["asciiname"].string, forKey: KeyConstant.kSelectedCountry)
                        
                        KeyConstant.user_Default.setValue(self.arrayData[ind]["currency_code"].string!.uppercased(), forKey: KeyConstant.kSelectedCurrency)
                        
                        KeyConstant.user_Default.setValue(self.arrayData[ind]["code"].string!.uppercased(), forKey: KeyConstant.kuserCountryCode)
                        
                        Bundle.setLanguage(self.strValue)
                        UserDefaults.standard.set([self.strValue], forKey: KeyConstant.kSelectedDeviceCurrency)
                        UserDefaults.standard.synchronize()
                        
                        if(self.strValue == KeyConstant.kArabicCode)
                        {
                            
                            UIView.appearance().semanticContentAttribute = .forceRightToLeft
                            
                        }
                        else{
                            
                            UIView.appearance().semanticContentAttribute = .forceLeftToRight
                            
                        }
                        
                        
                    }
                }
                
                KeyConstant.sharedAppDelegate.setRoot()
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
extension CountryListVC:UITableViewDelegate, UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrayData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryTVCell") as! CountryTVCell
        
        cell.labelCountryName.text = String(arrayData[indexPath.row]["asciiname"].string ?? "")
        
        if(strValue == KeyConstant.kArabicCode)
        {
            if let title_ar =  arrayData[indexPath.row]["asciiname_ar"].string
            {
                cell.labelCountryName.text = title_ar
                
            }
        }
        
        if(self.arrayTempSelection[indexPath.row] == true)
        {
            cell.buttonCountrySelection.isHidden = false
        }
        else
        {
            cell.buttonCountrySelection.isHidden = true
            
        }
        cell.imageViewCountry.contentMode = .scaleAspectFill
        if let strUrl = self.arrayData[indexPath.row]["flag"].string
        {
            if(strUrl.count > 0)
            {
                let urlString = strUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                
                
                cell.imageViewCountry.kf.setImage(with: URL(string: KeyConstant.kImageBaseFlagURL + urlString!)!, placeholder: UIImage.init(named: "noImage"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: { (downloadImage, error, cacheType, url) in
                    if(downloadImage != nil)
                    {
                        cell.imageViewCountry.image = downloadImage!
                    }
                })
            }
            else
            {
                cell.imageViewCountry.image = UIImage(named: "noImage")
                
            }
        }
        else
        {
            cell.imageViewCountry.image = UIImage(named: "noImage")
            
        }
        
        
        return cell
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        for ind in 0..<arrayData.count
        {
            if(arrayTempSelection[ind] == true)
            {
                arrayTempSelection[ind] = false
            }
        }
        
        arrayTempSelection[indexPath.row] = true
        self.tableView.reloadData()
        
        
    }
    
}


class CountryTVCell:UITableViewCell
{
    @IBOutlet weak var imageViewCountry: UIImageView!
    
    @IBOutlet weak var buttonCountrySelection: UIButton!
    @IBOutlet weak var labelCountryName: PaddingLabel!
}


extension UITextField {
    open override func awakeFromNib() {
        super.awakeFromNib()
        if(HelperArabic().isArabicLanguage())
        {
            
            if(self.textAlignment == .left)
            {
                self.textAlignment = .right
            }
            else if (self.textAlignment == .right)
            {
                self.textAlignment = .left
            }
        }
    }
}
extension UILabel {
    open override func awakeFromNib() {
        super.awakeFromNib()
        if(HelperArabic().isArabicLanguage())
        {
            
            if(self.textAlignment == .left)
            {
                self.textAlignment = .right
            }
            else if (self.textAlignment == .right)
            {
                self.textAlignment = .left
            }
        }
    }
}
//extension UITextView {
//    open override func awakeFromNib() {
//        super.awakeFromNib()
//         if(HelperArabic().isArabicLanguage())
//        {
//           
//            if(self.textAlignment == .left)
//            {
//            self.textAlignment = .right
//            }
//            else if (self.textAlignment == .right)
//            {
//                self.textAlignment = .left
//            }
//        }
//    }
//}
extension UIImageView {
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        if #available(iOS 13.0, *) {
            
            if(self.image?.pngData() == UIImage(named:"cart")?.pngData())
            {
                
                self.image = UIImage(named:"cart1")
                
            }
        }
        
        if(HelperArabic().isArabicLanguage())
        {
            
            
            if(self.image?.pngData() == UIImage(named:"arrow")?.pngData())
            {
                
                self.image = UIImage(named:"arrow_right")
                
            }
            
            
            
        }
    }
}
extension UISwipeGestureRecognizer {
    open override func awakeFromNib() {
        super.awakeFromNib()
        if(HelperArabic().isArabicLanguage())
        {
            
            if( self.direction == .right)
            {
                self.direction = UISwipeGestureRecognizer.Direction.left
            }
            else if( self.direction == .left)
            {
                self.direction = UISwipeGestureRecognizer.Direction.right
            }
            
        }
    }
}




//extension UIButton {
//    open override func awakeFromNib() {
//        super.awakeFromNib()
//        if(HelperArabic().isArabicLanguage())
//        {
//            
//            if(self.currentImage == UIImage(named:"arrow"))
//            {
//                self.setImage(UIImage(named:"arrow_right"), for: .normal)
//            }
//        }
//    }
//}
//extension UIButton {
//    open override func awakeFromNib() {
//        super.awakeFromNib()
//        if(HelperArabic().isArabicLanguage())
//        {
//            
//            if(self.titleLabel?.textAlignment == .left)
//            {
//                self.titleLabel?.textAlignment = .right
//            }
//            else if(self.titleLabel?.textAlignment == .right)
//            {
//                self.titleLabel?.textAlignment = .left
//
//            }
//        }
//    }
//}
