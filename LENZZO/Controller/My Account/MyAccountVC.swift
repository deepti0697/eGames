//
//  MyAccountVC.swift
//  LENZZO
//
//  Created by Apple on 11/18/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import UIKit
import Kingfisher
import AlamofireImage
import SwiftyJSON

class MyAccountVC: UIViewController, UITextFieldDelegate {
    var arrayData = [JSON]()
    var arrayOptions = [NSLocalizedString("MSG261", comment: ""),NSLocalizedString("MSG368", comment: ""),NSLocalizedString("MSG238", comment: ""),NSLocalizedString("MSG262", comment: ""),NSLocalizedString("MSG263", comment: ""),NSLocalizedString("MSG114", comment: "")]
    
    @IBOutlet weak var headerTopView: UIView!
    @IBOutlet weak var viewCall: UIView!
    
    @IBOutlet weak var callHeightConst: NSLayoutConstraint!
    @IBOutlet weak var labelName: PaddingLabel!
    @IBOutlet weak var imageViewProfile: UIImageView!
    
    @IBOutlet weak var englishBtn: UIButton!
    @IBOutlet weak var arabicBtn: UIButton!
    @IBOutlet weak var labelLoyaltyPoints: PaddingLabel!
    @IBOutlet weak var labelPhone: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelCountCart: UILabel!
    
    @IBOutlet weak var arabicLbl: UILabel!
    
    @IBOutlet weak var englishLbl: UILabel!
    @IBOutlet weak var backImgView: UIImageView!
    @IBOutlet weak var cartBtn: UIButton!
    @IBOutlet weak var searchBtn: UIButton!
    
    @IBOutlet weak var imageViewEnglish: UIImageView!
    @IBOutlet weak var imageViewKuwaiti: UIImageView!

    @IBOutlet weak var myAccountHeaderLbl: PaddingLabel!
    @IBOutlet weak var chooseYourLngLbl: UILabel!
    var profilePhotoURL = ""
    var isPresentFromMenu = Bool()
    var arrayLanguage = ["English","العربية"]

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
        
        self.labelName.text = ""
        self.labelEmail.text = ""
        self.imageViewProfile.image = UIImage(named:"noImage")
        self.imageViewProfile.contentMode = .scaleAspectFill
        self.imageViewProfile.clipsToBounds = true
        
        
              self.changeTintAndThemeColor()
        chooseYourLngLbl.text = NSLocalizedString("MSG445", comment: "")
        if(HelperArabic().isArabicLanguage())
               {
                imageViewEnglish.isHidden = true
                imageViewKuwaiti.isHidden = false
                chooseYourLngLbl.textAlignment = .right
               }
               else{
                   
                   imageViewEnglish.isHidden = false
                   imageViewKuwaiti.isHidden = true
            chooseYourLngLbl.textAlignment = .left
               }
        self.chooseYourLngLbl.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        self.labelName.font = UIFont(name: FontLocalization.medium.strValue, size: 20.0)
        self.labelEmail.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        self.labelPhone.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        self.labelLoyaltyPoints.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        self.myAccountHeaderLbl.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        self.englishBtn.titleLabel?.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        self.englishBtn.titleLabel?.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        
        
        
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
            
            self.imageViewEnglish.image = UIImage(named: "right_tik_50x50")?.withRenderingMode(.alwaysTemplate)
                self.imageViewEnglish.tintColor = .white
                
            
                self.imageViewKuwaiti.image = UIImage(named: "right_tik_50x50")?.withRenderingMode(.alwaysTemplate)
                self.imageViewKuwaiti.tintColor = .white
            
           
        }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        if(HelperArabic().isArabicLanguage())
               {
                   
                self.backImgView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                   
               }
               else
               {
                   self.backImgView.transform = CGAffineTransform(rotationAngle: 245)
               }
        self.arabicLbl.text = "عربى"//NSLocalizedString("MSG438", comment: "")
        self.showCartCount()
        self.getMyPoints()
        
        self.getProfileData()
    }
    func getProfileData()
    {
        profilePhotoURL = ""
        MBProgress().showIndicator(view: self.view)
        
        WebServiceHelper.sharedInstanceAPI.hitPostAPI(urlString: KeyConstant.APIProfileDetails, params: ["user_id":KeyConstant.user_Default.value(forKey: KeyConstant.kuserId) as? String ?? ""], completionHandler: { (result: [String:Any], err:Error?) in
            print(result)
            DispatchQueue.main.async {
                
                MBProgress().hideIndicator(view: self.view)
            }
            if(!(err == nil))
            {
                self.getProfileData()
                return
            }
            let json = JSON(result)
            
            let statusCode = json["status"].string
            print(json)
            if(statusCode == "success")
            {
                self.viewCall.isHidden = false
                
                self.labelName.text = String(json["response"]["name"].string?.capitalizedFirst ?? "")
                
                KeyConstant.user_Default.set(self.labelName.text ?? "", forKey: KeyConstant.kuserName)
                
                self.labelEmail.text = String(json["response"]["email"].string ?? "")
                
                self.labelPhone.text = String(String(json["response"]["country_code"].string ?? "") + " " + String(json["response"]["phone"].string ?? ""))
                
                
                //
                //                if let gender = json["response"]["gender"].string
                //                {
                //                    if(gender.lowercased() == "male" || gender.lowercased() == "الذكر")
                //                    {
                //                        self.labelEmail.text =  self.labelEmail.text! + "\n" + "\(NSLocalizedString("MSG363", comment: "")): \(NSLocalizedString("MSG361", comment: ""))"
                //
                //                    }
                //                    else if(gender.lowercased() == "female" || gender.lowercased() == "إناثا")
                //                    {
                //                        self.labelEmail.text =  self.labelEmail.text! + "\n" + "\(NSLocalizedString("MSG363", comment: "")): \(NSLocalizedString("MSG362", comment: ""))"
                //                    }
                //                    else
                //                    {
                //                        self.labelEmail.text =  self.labelEmail.text! + "\n" + "\(NSLocalizedString("MSG363", comment: "")): \(gender)"
                //
                //                    }
                //
                //                }
                //
                //                if let dob = json["response"]["dob"].string
                //                {
                //                    self.labelEmail.text =  self.labelEmail.text! + "\n" + "\(NSLocalizedString("MSG364", comment: "")): \(dob)"
                //                }
                //
            }
            
            
            if let strUrl = json["response"]["profilephoto"].string
            {
                if(strUrl.count > 0)
                {
                    let urlString = strUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    self.profilePhotoURL = strUrl
                    
                    
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
            if let strUserID = KeyConstant.user_Default.value(forKey: KeyConstant.kCheckoutGuestId) as? String
            {
                self.labelName.text = KeyConstant.user_Default.value(forKey: KeyConstant.kuserName) as? String ?? ""
                self.labelEmail.text = KeyConstant.user_Default.value(forKey: KeyConstant.kuserEmail) as? String ?? ""
                self.imageViewProfile.image = UIImage(named: "user(1)")
                
                self.viewCall.isHidden = true
                self.callHeightConst.constant = 0
            }
        })
        
        
        
    }
    override func viewWillLayoutSubviews() {
        
        
        
    }
    func showCartCount()
    {
        labelCountCart.text = ""
        
        
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
                
                var priceTemp = ""
                if(currentCurrency.uppercased() == "KWD")
                {
                    priceTemp = String(format:"%.3f",Double(totalPrice)?.roundTo(places: 3) ?? 0.0)
                }
                else
                {
                    priceTemp = String(format:"%.2f",Double(totalPrice)?.roundTo(places: 2) ?? 0.0)
                    
                }
                
                
                self.labelLoyaltyPoints.text = String(format:"\(NSLocalizedString("MSG394", comment: ""))",totalPoints,priceTemp,currentCurrency)
                
            }
            
        })
        
        
        
        
    }
 
    
    //MARK:- IBACTIONS
    
    
    @IBAction func buttonGenderEnglish(_ sender: Any) {
       // isFemaleMale = arrayGender[0]
        imageViewEnglish.isHidden = false
        imageViewKuwaiti.isHidden = true
        self.arabicLbl.text = "عربى"//NSLocalizedString("MSG438", comment: "")
        //KeyConstant.user_Default.setValue(self.arrayLanguage[0], forKey: KeyConstant.kSelectedLanguage)
        
        self.changeLanguage(strValue: KeyConstant.kEnglishCode)

        
    }
    @IBAction func buttonGenderKuwaiti(_ sender: Any) {
       // isFemaleMale = arrayGender[1]
        imageViewEnglish.isHidden = true
        imageViewKuwaiti.isHidden = false
        self.arabicLbl.text = "عربى"//NSLocalizedString("MSG438", comment: "")
       // KeyConstant.user_Default.setValue(self.arrayLanguage[1], forKey: KeyConstant.kSelectedLanguage)
        
        self.changeLanguage(strValue: KeyConstant.kArabicCode)
    }
    
    
    
    func changeLanguage(strValue:String){
        Bundle.setLanguage(strValue)
        UserDefaults.standard.set([strValue], forKey: KeyConstant.kSelectedDeviceCurrency)
        UserDefaults.standard.synchronize()
        
        if(strValue == KeyConstant.kArabicCode)
        {
            
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            
        }
        else{
            
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            
        }
        
       // KeyConstant.sharedAppDelegate.setRoot()
        let appdele = KeyConstant.sharedAppDelegate
        let objHome = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeTabBarController") as! HomeTabBarController
        appdele.navCon = UINavigationController(rootViewController: objHome)
        appdele.navCon?.isNavigationBarHidden = true
        appdele.window = UIWindow(frame: UIScreen.main.bounds)
        appdele.window?.rootViewController = appdele.navCon
        appdele.window?.makeKeyAndVisible()
    }
    
    
    @IBAction func buttonFilter(_ sender: Any) {
        KeyConstant.sharedAppDelegate.showFilterScreen(vc: self)
        
    }
    @IBAction func buttonSearch(_ sender: Any) {
        KeyConstant.sharedAppDelegate.showSearchScreen(vc: self)
        
    }
    @IBAction func butttonBack(_ sender: Any) {
        
        KeyConstant.sharedAppDelegate.setRoot()
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
    
    
    @IBAction func buttonViewProfile(_ sender: Any) {
        
        if let strUserID = KeyConstant.user_Default.value(forKey: KeyConstant.kuserId) as? String
        {
            if(self.profilePhotoURL.count > 0)
            {
                
                let brandVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductImagePreview") as! ProductImagePreview
                self.definesPresentationContext = true
                brandVC.modalPresentationStyle = .overCurrentContext
                brandVC.currentIndex = 0
                brandVC.arrImageUrl = [String(KeyConstant.kImageProfilePicURL + profilePhotoURL)]
                self.present(brandVC, animated: false, completion: nil)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
extension MyAccountVC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountTableViewCell") as! AccountTableViewCell
        cell.labelCategoryName.text  = arrayOptions[indexPath.row]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if(indexPath.row == 4)
        {
            SignupViewModel().logout(vc: self)
            return
        }
        else{
            
            if let strUserID = KeyConstant.user_Default.value(forKey: KeyConstant.kCheckoutGuestId) as? String
            {
                self.setAlertGuest()
                return
            }
        }
        
        switch indexPath.row {
        case 0:
            let objFav = self.storyboard?.instantiateViewController(withIdentifier: "OrderHistoryVC") as! OrderHistoryVC
            self.present(objFav, animated: false, completion: nil)
            break
        case 1:
            let objFav = self.storyboard?.instantiateViewController(withIdentifier: "LoyltyPointVC") as! LoyltyPointVC
            if(self.profilePhotoURL.count > 0)
            {
                objFav.strImagePicURL = self.profilePhotoURL
            }
            self.present(objFav, animated: false, completion: nil)
            break
            
            case 2:
                       let objFav = self.storyboard?.instantiateViewController(withIdentifier: "ProductListVC") as! ProductListVC
                       objFav.isWishList = true
                       self.present(objFav, animated: false, completion: nil)
                       break
        case 3:
            DispatchQueue.main.async {
                
                let objFav = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
                self.present(objFav, animated: false, completion: nil)
            }
            break
        case 4:
            let objFav = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
            self.present(objFav, animated: false, completion: nil)
            break
        case 5:
            SignupViewModel().logout(vc: self)
            
            break
        default:
            break
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
        
        // return UITableView.automaticDimension
    }
    
    func setAlertGuest()
    {
        let alertView = UIAlertController(title: NSLocalizedString("MSG31", comment: "").uppercased(), message: "", preferredStyle: .alert)
        let msgFont = [NSAttributedString.Key.font: UIFont(name: FontLocalization.medium.strValue, size: 15.0)!]
        let msgAttrString = NSMutableAttributedString(string: NSLocalizedString("MSG408", comment: ""), attributes: msgFont)
        alertView.setValue(msgAttrString, forKey: "attributedMessage")
        
        let alertAction = UIAlertAction(title: NSLocalizedString("MSG18", comment: ""), style: .default) { (alert) in
            
            let singupVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            singupVC.isPresentFromMenu = false
            singupVC.isPresentFromCheckOut = false
            self.present(singupVC, animated: false, completion: nil)
        }
        
        alertAction.setValue(AppColors.SelcetedColor, forKey: "titleTextColor")
        alertView.addAction(alertAction)
        self.present(alertView, animated: true, completion: nil)
        
    }
    
    
}
