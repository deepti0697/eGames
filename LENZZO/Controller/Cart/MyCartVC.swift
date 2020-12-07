//
//  MyCartVC.swift
//  LENZZO
//
//  Created by Apple on 9/3/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import UIKit
import Kingfisher
import AlamofireImage
import SwiftyJSON
protocol ReloadProductListDelegate
{
    func reloadDataSelected()
}

class MyCartVC: UIViewController,ReloadDataDelegate,UIGestureRecognizerDelegate {
    @IBOutlet weak var arrowImgView: UIImageView!
    var delegateReloadData: ReloadProductListDelegate!
    @IBOutlet weak var buttonRedeemPoints: UIButton!
    
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var heightConstraintEarnPointMessages: NSLayoutConstraint!
    @IBOutlet weak var heightConstraintEarnPoints: NSLayoutConstraint!
    @IBOutlet weak var labelEarnPoints: PaddingLabel!
    @IBOutlet weak var labelAmountEarnPoints: PaddingLabel!
    @IBOutlet weak var labelLoyalityPoints: PaddingLabel!
    @IBOutlet weak var heightConstraintsLoyltyPoints: NSLayoutConstraint!
    @IBOutlet weak var LoyaltyPointView: UIView!
    @IBOutlet weak var labelCartTotal: PaddingLabel!
    @IBOutlet weak var labelPromoCode: PaddingLabel!
    @IBOutlet weak var buttonPromoCodeApply: UIButton!
    @IBOutlet weak var textFieldPromocode: RoundTextField!
    @IBOutlet weak var labelHeaderPromoCode: PaddingLabel!
    @IBOutlet weak var labelOfferAlertTitle: PaddingLabel!
    
    @IBOutlet weak var labelOfferAlertDescr: PaddingLabel!
    @IBOutlet weak var labelOfferAlertProductName: PaddingLabel!
    
    @IBOutlet weak var discountHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var footerViewTable: UIView!
    @IBOutlet weak var labelSubToTalAmount: PaddingLabel!
    @IBOutlet weak var buttonAddFromWishLIst: UIButton!
    @IBOutlet weak var labelStep: PaddingLabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelEmptyMessage: UILabel!
    @IBOutlet weak var myCartTitleLbl: PaddingLabel!
    
    
    @IBOutlet weak var checkOutBtn: UIButton!
    @IBOutlet weak var cartTitleLbl: PaddingLabel!
    
    
    var sellDPrice = 0.0
    var totalPrice = 0.0
    var afterDiscountPrice = 0.0
    var arrayData = [JSON]()
    var strSalePrice = String()
    var currency = ""
    var promoCodeApllied = ""
    var promoCodeAmount = 0.0
    var promoCodeID = ""
    var totalLoyltyPoints = 0
    var earnLoyltyPoints = 0
    var afterRedeemPrice = 0.0
    var stringIsOfferApply = ""
    var redeemPoints = ""
    var user_id = ""
    var guestCheckoutID = String()
    var isFromGuestLogin = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let guest = KeyConstant.user_Default.value(forKey: KeyConstant.kCheckoutGuestId) as? String
        {
            user_id = guest
            guestCheckoutID = user_id
        }
        else
        {
            user_id = KeyConstant.sharedAppDelegate.getUserId()
        }
        self.labelEmptyMessage.isHidden = true
        
        currency = KeyConstant.user_Default.value(forKey: KeyConstant.kSelectedCurrency) as! String
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        // self.tableView.contentInset = UIEdgeInsets(top: -35, left: 0, bottom: 0, right: 0)
        
        self.labelEmptyMessage.isHidden = true
        
        
        self.labelHeaderPromoCode.text = NSLocalizedString("MSG324", comment: "")
        
        self.labelEarnPoints.text = String(format:"\(NSLocalizedString("MSG376", comment: ""))","0")
        self.heightConstraintEarnPointMessages.constant = 0
        
        
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
        
        
        getCartList()
        
        
        self.changeTintAndThemeColor()
        self.textFieldPromocode.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        self.buttonPromoCodeApply.titleLabel?.font = UIFont(name: FontLocalization.medium.strValue, size: 17.0)
        self.cartTitleLbl.font = UIFont(name: FontLocalization.Bold.strValue, size: 15.0)
        self.labelStep.font = UIFont(name: FontLocalization.Bold.strValue, size: 15.0)
        self.myCartTitleLbl.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        self.labelSubToTalAmount.font = UIFont(name: FontLocalization.medium.strValue, size: 16.0)
        self.labelEarnPoints.font = UIFont(name: FontLocalization.medium.strValue, size: 16.0)
        self.labelAmountEarnPoints.font = UIFont(name: FontLocalization.medium.strValue, size: 16.0)
        self.labelLoyalityPoints.font = UIFont(name: FontLocalization.medium.strValue, size: 16.0)
        self.labelHeaderPromoCode.font = UIFont(name: FontLocalization.medium.strValue, size: 16.0)
        self.checkOutBtn.titleLabel?.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        self.labelCartTotal.font = UIFont(name: FontLocalization.medium.strValue, size: 16.0)
        }
        
        
        func changeTintAndThemeColor(){
            
            self.arrowImgView.image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate)
            self.arrowImgView.tintColor = .white
            
            self.homeBtn.setImage(UIImage(named: "homeB")?.withRenderingMode(.alwaysTemplate), for: .normal)
            self.homeBtn.tintColor = .white
          
            
        }
    
    
    func loyalityDefaultView(status:String)
    {
        if(status == KeyConstant.pointsViewShow)
        {
            self.labelLoyalityPoints.text = String(format:"\(NSLocalizedString("MSG372", comment: ""))",String(format:"%d",totalLoyltyPoints))
            
            self.heightConstraintsLoyltyPoints.constant = 63
            
            
        }
        else
        {
            self.heightConstraintsLoyltyPoints.constant = 0
            
        }
        
        
    }
    
    func applyRedeem()
    {
        var checkPrice = 0.0
        if(self.promoCodeID.count > 0)
        {
            checkPrice = afterDiscountPrice
        }
        else
        {
            checkPrice = self.totalPrice
            
        }
        
        
        if(checkPrice > 0)
        {
            
            var checkPriceTemp = ""
            MBProgress().showIndicator(view: self.view)
            if(self.currency.uppercased() == "KWD")
            {
                checkPriceTemp = String(format:"%.3f",checkPrice)
            }
            else
            {
                checkPriceTemp = String(format:"%.2f",checkPrice)
                
            }
            
            WebServiceHelper.sharedInstanceAPI.hitPostAPI(urlString: KeyConstant.APIRedeemPoints, params: ["price":checkPriceTemp,"user_id":user_id,"current_currency":self.currency], completionHandler: { (result: [String:Any], err:Error?) in
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
                    var strPrice = json["price"].string ?? "0.0"
                    strPrice = strPrice.replacingOccurrences(of: ",", with: "")
                    
                    var tempRedeem = 0.0
                    
                    if(self.currency.uppercased() == "KWD")
                    {
                        tempRedeem = Double(strPrice)?.roundTo(places: 3) ?? 0.0
                        
                    }
                    else
                    {
                        tempRedeem = Double(strPrice)?.roundTo(places: 2) ?? 0.0
                        
                    }
                    
                    self.redeemPoints = String(json["point"].int ?? 0)
                    
                    
                    if(self.promoCodeID.count > 0)
                    {
                        if(self.currency.uppercased() == "KWD")
                        {
                            self.afterRedeemPrice = Double(self.afterDiscountPrice - tempRedeem).roundTo(places: 3)
                        }
                        else
                        {
                            self.afterRedeemPrice = Double(self.afterDiscountPrice - tempRedeem).roundTo(places: 2)
                            
                        }
                        
                    }
                    else
                    {
                        if(self.currency.uppercased() == "KWD")
                        {
                            self.afterRedeemPrice = Double(self.totalPrice - tempRedeem).roundTo(places: 3)
                        }
                        else
                        {
                            self.afterRedeemPrice = Double(self.totalPrice - tempRedeem).roundTo(places: 2)
                            
                        }
                    }
                    
                    if( self.afterRedeemPrice < 0)
                    {
                        self.afterRedeemPrice = 0.0
                    }
                    if(self.currency.uppercased() == "KWD")
                    {
                        self.labelAmountEarnPoints.text = NSLocalizedString("MSG375", comment: "") + String(format:"%.3f",tempRedeem) + " " + self.currency
                        self.heightConstraintEarnPoints.constant = 41
                        self.buttonRedeemPoints.setTitle(NSLocalizedString("MSG326", comment: ""), for: .normal)
                        self.labelSubToTalAmount.text = NSLocalizedString("MSG329", comment: "") + " : \(String(format:"%.3f", self.afterRedeemPrice)) \(self.currency)"
                    }
                    else
                    {
                        self.labelAmountEarnPoints.text = NSLocalizedString("MSG375", comment: "") + String(format:"%.2f",tempRedeem) + " " + self.currency
                        self.heightConstraintEarnPoints.constant = 41
                        self.buttonRedeemPoints.setTitle(NSLocalizedString("MSG326", comment: ""), for: .normal)
                        self.labelSubToTalAmount.text = NSLocalizedString("MSG329", comment: "") + " : \(String(format:"%.2f", self.afterRedeemPrice)) \(self.currency)"
                    }
                    
                    
                    let remainingPoint = self.totalLoyltyPoints - Int(json["point"].int ?? 0)
                    self.labelLoyalityPoints.text = String(format:"\(NSLocalizedString("MSG372", comment: ""))",String(format:"%d",remainingPoint)) + "\n" + "\(NSLocalizedString("MSG392", comment: "")): \(String(json["point"].int ?? 0))"
                    
                    self.getMyEarnedPoints(price: self.afterRedeemPrice)
                    
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
                    
                    self.removeRedeemPoint()
                }
                
            })
        }
        else
        {
            KeyConstant.sharedAppDelegate.showAlertView(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG386", comment: ""))
            
        }
    }
    
    func removeRedeemPoint()
    {
        
        self.redeemPoints = ""
        self.heightConstraintEarnPoints.constant = 0
        self.buttonRedeemPoints.setTitle(NSLocalizedString("MSG374", comment: ""), for: .normal)
        var tempTotal = 0.0
        if(self.promoCodeID.count > 0)
        {
            if(self.currency.uppercased() == "KWD")
            {
                tempTotal = Double(self.afterDiscountPrice - self.afterRedeemPrice).roundTo(places: 3)
            }
            else
            {
                tempTotal = Double(self.afterDiscountPrice - self.afterRedeemPrice).roundTo(places: 2)
                
            }
        }
        else
        {
            if(self.currency.uppercased() == "KWD")
            {
                tempTotal = Double(self.totalPrice - self.afterRedeemPrice).roundTo(places: 3)
            }
            else
            {
                tempTotal = Double(self.totalPrice - self.afterRedeemPrice).roundTo(places: 2)
                
            }
            
        }
        if(self.currency.uppercased() == "KWD")
        {
            self.labelSubToTalAmount.text = NSLocalizedString("MSG329", comment: "") + " : \(String(format:"%.3f", tempTotal.roundTo(places: 3))) \(self.currency)"
            self.getMyEarnedPoints(price: tempTotal.roundTo(places: 3))
        }
        else
        {
            self.labelSubToTalAmount.text = NSLocalizedString("MSG329", comment: "") + " : \(String(format:"%.2f", tempTotal.roundTo(places: 2))) \(self.currency)"
            self.getMyEarnedPoints(price: tempTotal.roundTo(places: 2))
        }
        self.afterRedeemPrice = 0.0
        self.getMyAvailablePoints()
        
    }
    @IBAction func buttonRedeem(_ sender: Any){
        
        if(redeemPoints.count > 0)
        {
            self.removeRedeemPoint()
            
            
            return
        }
        else
        {
            self.applyRedeem()
        }
    }
    @objc func rightSwip(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            self.buttonBackAction(UIButton())
            
        }
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    override func viewWillAppear(_ animated: Bool) {
        
        if(HelperArabic().isArabicLanguage())
               {
                self.arrowImgView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
               }
               else
               {
               self.arrowImgView.transform = CGAffineTransform(rotationAngle: 245)
               }
        
    }
    
    
    override func viewWillLayoutSubviews() {
        self.textFieldPromocode.bottomBorderColor = UIColor.white
        
    }
    
    func getCartList()
    {
        self.buttonRedeemPoints.setTitle(NSLocalizedString("MSG374", comment: ""), for: .normal)
        self.heightConstraintEarnPoints.constant = 0
        earnLoyltyPoints = 0
        afterRedeemPrice = 0.0
        totalLoyltyPoints = 0
        redeemPoints = ""
        
        self.footerViewTable.isHidden = true
        self.arrayData.removeAll()
        self.stringIsOfferApply = ""
        self.totalPrice = 0.0
        self.textFieldPromocode.text = ""
        self.textFieldPromocode.isUserInteractionEnabled = true
        self.promoCodeAmount = 0.0
        self.promoCodeID = ""
        promoCodeApllied = ""
        self.buttonPromoCodeApply.setTitle(NSLocalizedString("MSG325", comment: ""), for: .normal)
        discountHeightConstraint.constant = 0
        
        if(self.currency.uppercased() == "KWD")
        {
            
            self.labelSubToTalAmount.text = NSLocalizedString("MSG329", comment: "") + " : \(String(format:"%.3f",self.totalPrice))  \(self.currency)"
            self.labelCartTotal.text = NSLocalizedString("MSG330", comment: "") + " : \(String(format:"%.3f",self.totalPrice)) \(self.currency)"
            self.labelPromoCode.text = NSLocalizedString("MSG331", comment: "") + " : \(String(format:"%.3f",self.promoCodeAmount)) \(self.currency)"
            
        }
        else
        {
            self.labelSubToTalAmount.text = NSLocalizedString("MSG329", comment: "") + " : \(String(format:"%.2f",self.totalPrice))  \(self.currency)"
            self.labelCartTotal.text = NSLocalizedString("MSG330", comment: "") + " : \(String(format:"%.2f",self.totalPrice)) \(self.currency)"
            self.labelPromoCode.text = NSLocalizedString("MSG331", comment: "") + " : \(String(format:"%.2f",self.promoCodeAmount)) \(self.currency)"
        }
        
        self.tableView.reloadData()
        self.tableView.sectionHeaderHeight = 0
        self.tableView.estimatedSectionHeaderHeight = 0
        self.getMyAvailablePoints()
        CartViewModel().viewCartList(vc: self, param: ["user_id":KeyConstant.sharedAppDelegate.getUserId()], completionHandler: { (result:[JSON], totalCount:String ,error:Error?) in
            
            
            if(error != nil)
            {
                
                KeyConstant.sharedAppDelegate.showAlertView(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString:error?.localizedDescription ?? NSLocalizedString("MSG21", comment: ""))
                //self.getCartList()
                return
            }
            
            self.arrayData = result
            if(self.arrayData.count == 0)
            {
                self.labelEmptyMessage.isHidden = false
            }
            else
            {
                self.labelEmptyMessage.isHidden = true
                
            }
            if(self.arrayData.count > 0)
            {
                self.footerViewTable.isHidden = false
                
                for ind in 0..<self.arrayData.count
                {
                    
                    
                    self.totalPrice = self.totalPrice +  self.getTotalPriceEachCartDouble(dictData: self.arrayData[ind].dictionary!)
                    print("dsfdsf\(self.totalPrice)")
                    //}
                    //                        var offer_flag = ""
                    //                        if let offerFlagTemp = self.arrayData[ind]["offer_flag"].string
                    //                        {
                    //                            offer_flag = offerFlagTemp
                    //                        }
                    //                        if let offerFlagTemp = self.arrayData[ind]["offer_flag"].int
                    //                        {
                    //                            offer_flag = String(format:"%d",offerFlagTemp)
                    //                        }
                    //
                    //                        if offer_flag == "1"
                    //                        {
                    //
                    //                        if(self.stringIsOfferApply.count == 0)
                    //                        {
                    //                            self.stringIsOfferApply = NSLocalizedString("MSG249", comment: "") + String(self.arrayData[ind]["product_name"].string ?? "")
                    //                        }
                    //                        else
                    //                        {
                    //                            self.stringIsOfferApply = self.stringIsOfferApply + "\n" + String(NSLocalizedString("MSG249", comment: "") + String(self.arrayData[ind]["product_name"].string ?? ""))
                    //
                    //                        }
                    //                        }
                    
                    
                }
                
                
                
                
            }
            
            
            
            if(self.currency.uppercased() == "KWD")
            {
                self.labelCartTotal.text = NSLocalizedString("MSG330", comment: "") + " : \(String(format:"%.3f",self.totalPrice)) \(self.currency)"
                
                self.labelSubToTalAmount.text = NSLocalizedString("MSG329", comment: "") + " : \(String(format:"%.3f",self.totalPrice)) \(self.currency)"
            }
            else
            {
                self.labelCartTotal.text = NSLocalizedString("MSG330", comment: "") + " : \(String(format:"%.2f",self.totalPrice)) \(self.currency)"
                
                self.labelSubToTalAmount.text = NSLocalizedString("MSG329", comment: "") + " : \(String(format:"%.2f",self.totalPrice)) \(self.currency)"
            }
            self.tableView.sectionHeaderHeight = UITableView.automaticDimension
            
            self.tableView.estimatedSectionHeaderHeight = UITableView.automaticDimension
            
            self.tableView.reloadData()
            
            self.getMyEarnedPoints(price: self.totalPrice)
        } )
        
        
        
    }
    
    func recheckCartItmes()
    {
        MBProgress().showIndicator(view: self.view)
        
        CartViewModel().viewCartList(vc: self, param: ["user_id":KeyConstant.sharedAppDelegate.getUserId()], completionHandler: { (result:[JSON], totalCount:String ,error:Error?) in
            
            
            DispatchQueue.main.async {
                
                MBProgress().hideIndicator(view: self.view)
            }
            if(error != nil)
            {
                self.recheckCartItmes()
                return
            }
            if(result.count > 0)
            {
                var quantity = 0
                var product_quantity = 0
                var strStockFlag = "0"
                
                for indexTemp in 0..<result.count
                {
                    if let arrayTemp = result[indexTemp]["child"].array
                    {
                        for ind in 0..<arrayTemp.count
                        {
                            quantity = Int(arrayTemp[ind]["quantity"].string ?? "0") ?? 0
                            product_quantity = Int(arrayTemp[ind]["product_quantity"].string ?? "0") ?? 0
                            strStockFlag = arrayTemp[ind]["stock_flag"].string ?? "0"
                            
                            if(!(quantity > 0 && (quantity < product_quantity + 1)))
                            {
                                
                                self.setAlerOutOfStock()
                                return
                                
                            }
                            else
                            {
                                if((Int(strStockFlag) ?? 0) < 1 || strStockFlag.count < 1)
                                {
                                    self.setAlerOutOfStock()
                                    return
                                }
                            }
                        }
                    }
                }
                
                let objVC = self.storyboard?.instantiateViewController(withIdentifier: "CheckOutVC") as! CheckOutVC
                objVC.arraySelectedAllCartItems = self.arrayData
                objVC.isFromGuestLogin = self.isFromGuestLogin
                if(self.redeemPoints.count > 0)
                {
                    objVC.redeemPointsApplied = ["loyality_point":self.redeemPoints]
                }
                
                
                
                if(self.redeemPoints.count > 0)
                {
                    objVC.subTotalPrice = self.afterRedeemPrice
                    if(self.promoCodeID.count > 0)
                    {
                        objVC.promoDetails = ["coupon_price":String(self.promoCodeAmount),"coupon_id":self.promoCodeID,"coupon_code":self.promoCodeApllied]
                        
                    }
                }
                else if(self.promoCodeID.count > 0)
                {
                    objVC.promoDetails = ["coupon_price":String(self.promoCodeAmount),"coupon_id":self.promoCodeID,"coupon_code":self.promoCodeApllied]
                    objVC.subTotalPrice = self.afterDiscountPrice
                }
                else
                {
                    objVC.subTotalPrice = self.totalPrice
                }
                self.present(objVC, animated: false, completion: nil)
                
                
            }
            
        } )
    }
    
    @IBAction func buttonApplyPromoAction(_ sender: Any) {
        
        if(!((self.textFieldPromocode.text?.isEmpty)!))
        {
            self.applyPromoCode()
        }
        else
        {
            KeyConstant.sharedAppDelegate.showAlertViewWithTextField(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG327", comment: ""),textField:textFieldPromocode )
        }
        
    }
    
    func getMyAvailablePoints()
    {
        self.loyalityDefaultView(status: KeyConstant.pointsViewHide)
        
        CartViewModel().getMyLoyaltyPoints(vc: self, param: [:], completionHandler: { (result:[String:JSON], error:Error?) in
            
            if(error != nil)
            {
                self.getMyAvailablePoints()
                return
            }
            if(result.count > 0)
            {
                
                self.totalLoyltyPoints = Int(result["point"]?.string ?? "0") ?? 0
                if(self.totalLoyltyPoints > 0)
                {
                    self.loyalityDefaultView(status: KeyConstant.pointsViewShow)
                }
            }
            
        })
        
    }
    func getMyEarnedPoints(price:Double)
    {
        self.labelEarnPoints.text = String(format:"\(NSLocalizedString("MSG376", comment: ""))","0")
        self.heightConstraintEarnPointMessages.constant = 0
        
        CartViewModel().getMyEarnLoyaltyPoints(vc: self, param: ["price":String(price),"current_currency":currency], completionHandler: { (result:[String:JSON], error:Error?) in
            
            if(error != nil)
            {
                self.getMyEarnedPoints(price:price)
                return
            }
            if(result.count > 0)
            {
                let points = result["point"]?.int ?? 0
                if(points > 0)
                {
                    self.labelEarnPoints.text = String(format:"\(NSLocalizedString("MSG376", comment: ""))",String(points) ?? "0")
                    self.heightConstraintEarnPointMessages.constant = 40
                    let strUserID = KeyConstant.user_Default.value(forKey: KeyConstant.kuserId) as? String ?? ""
                    
                    if(self.guestCheckoutID.count > 0 || strUserID.count == 0)
                    {
                        self.labelEarnPoints.text = self.labelEarnPoints.text! + "\n\n"
                        //424
                        self.heightConstraintEarnPointMessages.constant = 100
                        
                        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: self.labelEarnPoints.text!)
                        
                        //  attributedString.setColorForText(textForAttribute: "(\(NSLocalizedString("MSG414", comment: "")) ", withColor: .red)
                        
                        self.labelEarnPoints.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
                        
                        let attributeString1 = NSMutableAttributedString(string: NSLocalizedString("MSG414", comment: "") + "\n",attributes: [NSAttributedString.Key.font : UIFont.init(name: FontLocalization.medium.strValue, size: 15.0),NSAttributedString.Key.foregroundColor : UIColor.white])
                        
                        let attributeString2 = NSMutableAttributedString(string: NSLocalizedString("MSG424", comment: ""),attributes: [NSAttributedString.Key.font : UIFont.init(name: FontLocalization.medium.strValue, size: 15.0),NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue,NSAttributedString.Key.foregroundColor : UIColor.white])
                        
                        self.labelEarnPoints.isUserInteractionEnabled = true
                        self.labelEarnPoints.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.tapLabel(gesture:))))
                        
                        let combination = NSMutableAttributedString()
                        combination.append(attributedString)
                        combination.append(attributeString1)
                        combination.append(attributeString2)
                        
                        self.labelEarnPoints.attributedText = combination
                        
                    }
                    
                    
                    
                }
            }
            
        })
        
    }
    @objc func tapLabel(gesture: UITapGestureRecognizer) {
        
        let termsRange = (self.labelEarnPoints.text as! NSString).range(of: NSLocalizedString("MSG424", comment: ""))
        // comment for now
        //let privacyRange = (text as NSString).range(of: "Privacy Policy")
        
        if gesture.didTapAttributedTextInLabel(label: self.labelEarnPoints, inRange: termsRange) {
            
            
            
            let singupVC = self.storyboard?.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
            singupVC.isPresentFromMenu = false
            singupVC.isPresentFromCheckOut = true
            singupVC.delegateReloadData  = self
            self.present(singupVC, animated: false, completion: nil)
            
            
        }
    }
    func applyPromoCode()
    {
        
        if(promoCodeApllied.count > 0)
        {
            self.buttonPromoCodeApply.setTitle(NSLocalizedString("MSG325", comment: ""), for: .normal)
            self.textFieldPromocode.text = ""
            self.textFieldPromocode.isUserInteractionEnabled = true
            self.promoCodeAmount = 0.0
            self.promoCodeID = ""
            
            promoCodeApllied = ""
            
            
            self.afterDiscountPrice = 0.0
            
            self.labelPromoCode.text = NSLocalizedString("MSG331", comment: "") + " : 0.0 \(self.currency)"
            if(self.currency.uppercased() == "KWD")
            {
                self.labelCartTotal.text = NSLocalizedString("MSG330", comment: "") + " : \(String(format:"%.3f",self.totalPrice)) \(self.currency)"
            }
            else
            {
                self.labelCartTotal.text = NSLocalizedString("MSG330", comment: "") + " : \(String(format:"%.2f",self.totalPrice)) \(self.currency)"
                
            }
            if(self.redeemPoints.count > 0)
            {
                if(self.currency.uppercased() == "KWD")
                {
                    let afterRemovePromo = Double(self.totalPrice - self.afterRedeemPrice).roundTo(places: 3)
                    self.labelSubToTalAmount.text = NSLocalizedString("MSG329", comment: "") + " : \(String(format:"%.3f",afterRemovePromo)) \(self.currency)"
                    self.getMyEarnedPoints(price: afterRemovePromo)
                    
                }
                else
                {
                    let afterRemovePromo = Double(self.totalPrice - self.afterRedeemPrice).roundTo(places: 2)
                    self.labelSubToTalAmount.text = NSLocalizedString("MSG329", comment: "") + " : \(String(format:"%.2f",afterRemovePromo)) \(self.currency)"
                    self.getMyEarnedPoints(price: afterRemovePromo)
                }
                
            }
            else
            {
                if(self.currency.uppercased() == "KWD")
                {
                    
                    self.labelSubToTalAmount.text = NSLocalizedString("MSG329", comment: "") + " : \(String(format:"%.3f",self.totalPrice)) \(self.currency)"
                }
                else
                {
                    self.labelSubToTalAmount.text = NSLocalizedString("MSG329", comment: "") + " : \(String(format:"%.2f",self.totalPrice)) \(self.currency)"
                    
                    
                }
                self.getMyEarnedPoints(price: self.totalPrice)
                
            }
            self.discountHeightConstraint.constant = 0
            if(self.redeemPoints.count > 0)
            {
                self.applyRedeem()
            }
            return
        }
        
        var checkPriceTemp = 0.0
        if(self.currency.uppercased() == "KWD")
        {
            if(self.redeemPoints.count > 0)
            {
                checkPriceTemp = afterRedeemPrice.roundTo(places: 3)
            }
            else
            {
                checkPriceTemp = self.totalPrice.roundTo(places: 3)
                
            }
        }
        else
        {
            
            if(self.currency.uppercased() == "KWD")
            {
                if(self.redeemPoints.count > 0)
                {
                    checkPriceTemp = afterRedeemPrice.roundTo(places: 3)
                }
                else
                {
                    checkPriceTemp = self.totalPrice.roundTo(places: 3)
                }
            }
            else
            {
                if(self.redeemPoints.count > 0)
                {
                    checkPriceTemp = afterRedeemPrice.roundTo(places: 2)
                }
                else
                {
                    checkPriceTemp = self.totalPrice.roundTo(places: 2)
                    
                }
            }
        }
        
        if(checkPriceTemp > 0.0)
        {
            var checkPriceTempGet = ""
            
            MBProgress().showIndicator(view: self.view)
            if(self.currency.uppercased() == "KWD")
            {
                checkPriceTempGet = String(format:"%.3f",checkPriceTemp)
                
            }
            else
            {
                checkPriceTempGet = String(format:"%.2f",checkPriceTemp)
                
            }
            WebServiceHelper.sharedInstanceAPI.hitPostAPI(urlString: KeyConstant.APIcouponApply, params: ["coupon_code":textFieldPromocode.text ?? "","price":checkPriceTempGet,"user_id":user_id,"current_currency":self.currency], completionHandler: { (result: [String:Any], err:Error?) in
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
                    self.discountHeightConstraint.constant = 41
                    
                    self.promoCodeApllied = self.textFieldPromocode.text ?? ""
                    self.buttonPromoCodeApply.setTitle(NSLocalizedString("MSG326", comment: ""), for: .normal)
                    var strPrice = json["result"]["coupon_price"].string ?? "0.0"
                    strPrice = strPrice.replacingOccurrences(of: ",", with: "")
                    
                    if(self.currency.uppercased() == "KWD")
                    {
                        
                        self.promoCodeAmount = Double(strPrice)?.roundTo(places: 3) ?? 0.0
                    }
                    else
                    {
                        self.promoCodeAmount = Double(strPrice)?.roundTo(places: 2) ?? 0.0
                        
                    }
                    self.promoCodeID = json["result"]["id"].string ?? ""
                    
                    
                    if(self.currency.uppercased() == "KWD")
                    {
                        self.labelCartTotal.text = NSLocalizedString("MSG330", comment: "") + " : \(String(format:"%.3f",self.totalPrice)) \(self.currency)"
                        self.labelPromoCode.text = NSLocalizedString("MSG331", comment: "") + " : \(String(format:"%.3f",self.promoCodeAmount) + " \(self.currency)")"
                        
                        
                        if(self.redeemPoints.count > 0)
                        {
                            self.afterDiscountPrice = Double(self.afterRedeemPrice - self.promoCodeAmount).roundTo(places: 3)
                            
                        }
                        else
                        {
                            self.afterDiscountPrice = Double(self.totalPrice - self.promoCodeAmount).roundTo(places: 3)
                        }
                    }
                    else
                    {
                        self.labelCartTotal.text = NSLocalizedString("MSG330", comment: "") + " : \(String(format:"%.2f",self.totalPrice)) \(self.currency)"
                        self.labelPromoCode.text = NSLocalizedString("MSG331", comment: "") + " : \(String(format:"%.2f",self.promoCodeAmount) + " \(self.currency)")"
                        
                        if(self.currency.uppercased() == "KWD")
                        {
                            if(self.redeemPoints.count > 0)
                            {
                                self.afterDiscountPrice = Double(self.afterRedeemPrice - self.promoCodeAmount).roundTo(places: 3)
                                
                            }
                            else
                            {
                                self.afterDiscountPrice = Double(self.totalPrice - self.promoCodeAmount).roundTo(places: 3)
                            }
                        }
                        else
                        {
                            if(self.redeemPoints.count > 0)
                            {
                                self.afterDiscountPrice = Double(self.afterRedeemPrice - self.promoCodeAmount).roundTo(places: 2)
                                
                            }
                            else
                            {
                                self.afterDiscountPrice = Double(self.totalPrice - self.promoCodeAmount).roundTo(places: 2)
                            }
                        }
                    }
                    if(self.afterDiscountPrice < 0)
                    {
                        self.afterDiscountPrice = 0.0
                    }
                    if(self.currency.uppercased() == "KWD")
                    {
                        self.labelSubToTalAmount.text = NSLocalizedString("MSG329", comment: "") + " : \(String(format:"%.3f",self.afterDiscountPrice)) \(self.currency)"
                    }
                    else
                    {
                        self.labelSubToTalAmount.text = NSLocalizedString("MSG329", comment: "") + " : \(String(format:"%.2f",self.afterDiscountPrice)) \(self.currency)"
                    }
                    self.getMyEarnedPoints(price: self.afterDiscountPrice)
                    
                    self.textFieldPromocode.isUserInteractionEnabled = false
                    self.textFieldPromocode.resignFirstResponder()
                    
                    let alertView = UIAlertController(title: NSLocalizedString("MSG31", comment: "").uppercased(), message: "", preferredStyle: .alert)
                    let msgFont = [NSAttributedString.Key.font: UIFont(name: FontLocalization.medium.strValue, size: 15.0)!]
                    let msgAttrString = NSMutableAttributedString(string: NSLocalizedString("MSG328", comment: ""), attributes: msgFont)
                    alertView.setValue(msgAttrString, forKey: "attributedMessage")
                    
                    let alertAction = UIAlertAction(title: NSLocalizedString("MSG18", comment: ""), style: .default) { (alert) in
                        
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
        else
        {
            KeyConstant.sharedAppDelegate.showAlertView(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString:NSLocalizedString("MSG386", comment: ""))
            
        }
        
    }
    
    @IBAction func buttonBackAction(_ sender: Any) {
        
        if(self.navigationController != nil)
        {
            self.navigationController?.popViewController(animated: true)
        }
        else
        {
            
            self.dismiss(animated: false, completion: {
                if(self.delegateReloadData != nil)
                {
                    self.delegateReloadData.reloadDataSelected()
                }
            })
        }
    }
    @IBAction func buttonGoToMyFav(_ sender: Any) {
        
        let objFav = self.storyboard?.instantiateViewController(withIdentifier: "ProductListVC") as! ProductListVC
        objFav.isFromCartList = true
        self.present(objFav, animated: false, completion: nil)
        
        
    }
    @IBAction func buttonCheckOut(_ sender: Any) {
        
        if let strUserID = KeyConstant.user_Default.value(forKey: KeyConstant.kuserId) as? String
        {
            //check out of stock product
            self.recheckCartItmes()
        }
        else
        {
            
            if (guestCheckoutID.count > 0)
            {
                //check out of stock product
                self.recheckCartItmes()
            }
            else
                
            {
                let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                loginVC.delegateReloadData = self
                loginVC.isPresentFromMenu = false
                loginVC.isPresentFromCheckOut = true
                self.present(loginVC, animated: false, completion: nil)
            }
            
        }
        
    }
    func setAlerOutOfStock()
    {
        let alertView = UIAlertController(title: NSLocalizedString("MSG31", comment: "").uppercased(), message: "", preferredStyle: .alert)
        let msgFont = [NSAttributedString.Key.font: UIFont(name: FontLocalization.medium.strValue, size: 15.0)!]
        let msgAttrString = NSMutableAttributedString(string: NSLocalizedString("MSG322", comment: ""), attributes: msgFont)
        alertView.setValue(msgAttrString, forKey: "attributedMessage")
        
        let alertAction = UIAlertAction(title: NSLocalizedString("MSG18", comment: ""), style: .default) { (alert) in
            
            self.getCartList()
        }
        alertAction.setValue(AppColors.SelcetedColor, forKey: "titleTextColor")
        alertView.addAction(alertAction)
        self.present(alertView, animated: true, completion: nil)
        
    }
    
    func reloadDataSelected()
    {
        if let guest = KeyConstant.user_Default.value(forKey: KeyConstant.kCheckoutGuestId) as? String
        {
            user_id = guest
            guestCheckoutID = user_id
        }
        else
        {
            user_id = KeyConstant.sharedAppDelegate.getUserId()
        }
        
        getCartList()
        
        
    }
    @IBAction func buttonCartList(_ sender: Any) {
        
        KeyConstant.sharedAppDelegate.setRoot()
        
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
extension MyCartVC:UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let child = self.arrayData[section]["child"].array
        {
            return child.count
        }
        return 0
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.arrayData.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell") as! CartTableViewCell
        
        
        

         cell.rightQTYTitle.font = UIFont(name: FontLocalization.medium.strValue, size: 13.0)
         cell.leftQTYTitle.font = UIFont(name: FontLocalization.medium.strValue, size: 13.0)
         cell.labelRightPrice.font = UIFont(name: FontLocalization.medium.strValue, size: 13.0)
         cell.labelQty.font = UIFont(name: FontLocalization.medium.strValue, size: 13.0)
//         cell.labelOrderQty.font = UIFont(name: FontLocalization.medium.strValue, size: 13.0)
//         cell.labelDate.font = UIFont(name: FontLocalization.medium.strValue, size: 13.0)
        cell.labelOutStock.font = UIFont(name: FontLocalization.medium.strValue, size: 11.0)
        cell.labelItemName.font = UIFont(name: FontLocalization.medium.strValue, size: 13.0)
        cell.removeLbl.font = UIFont(name: FontLocalization.medium.strValue, size: 14.0)
        
        
        cell.labelHeaderItemNumber.font = UIFont(name: FontLocalization.medium.strValue, size: 12.0)
        cell.labelHeaderItemPrice.font = UIFont(name: FontLocalization.medium.strValue, size: 12.0)
         cell.deleteImgView.image = UIImage(named: "delete")?.withRenderingMode(.alwaysTemplate)
         cell.deleteImgView.tintColor = .white
         
        cell.buttonDecrementItem.setTitleColor(.white, for: .normal)
         
        cell.buttonIncrementItem.setTitleColor(.white, for: .normal)
        
        if let arrayDataTemp = arrayData[indexPath.section]["child"].array
        {
            
            cell.buttonRemoveItem.tag = indexPath.row
            cell.buttonDecrementItem.tag = indexPath.row
            cell.buttonIncrementItem.tag = indexPath.row
            cell.buttonRightQtyIncre.tag = indexPath.row
            cell.buttonRightQtyDecre.tag = indexPath.row
            
            cell.buttonIncrementItem.tag = indexPath.row
            cell.buttonMoveToWishList.tag = indexPath.row
            cell.buttonViewProduct.tag = indexPath.row
            
            cell.buttonRemoveItem.addTarget(self, action: #selector(buttonRemoveItem), for: .touchUpInside)
            
            cell.buttonDecrementItem.addTarget(self, action: #selector(buttonDecrementItem), for: .touchUpInside)
            cell.buttonIncrementItem.addTarget(self, action: #selector(buttonIncrementItem), for: .touchUpInside)
            
            
            cell.buttonRightQtyDecre.addTarget(self, action: #selector(buttonRightDecrementItem), for: .touchUpInside)
            cell.buttonRightQtyIncre.addTarget(self, action: #selector(buttonRightIncrementItem), for: .touchUpInside)
            
            cell.buttonMoveToWishList.addTarget(self, action: #selector(buttonMoveToWishList), for: .touchUpInside)
            cell.buttonViewProduct.addTarget(self, action: #selector(buttonViewProduct), for: .touchUpInside)
            
            
            
            
            cell.labelHeaderItemNumber.text = "\(NSLocalizedString("MSG349", comment: "")) - \(indexPath.row + 1)"
            
            cell.labelItemName.text = arrayDataTemp[indexPath.row]["product_name"].string ?? ""
            
            if(HelperArabic().isArabicLanguage())
            {
                if let title_ar =  arrayDataTemp[indexPath.row]["product_name_ar"].string
                {
                    if(title_ar.count > 0)
                    {
                        cell.labelItemName.text = title_ar
                    }
                }
            }
            
            
            
            
            
            //@IBOutlet weak var rightQTYViewConstraints: NSLayoutConstraint! 29
            //@IBOutlet weak var rightPriceConstraint: NSLayoutConstraint! 18
            
            cell.labelQty.isHidden = false
            cell.buttonDecrementItem.isHidden = false
            cell.buttonIncrementItem.isHidden = false
            
            cell.rightQTYViewConstraints.constant = 0
            cell.rightPriceConstraint.constant = 0
            cell.leftPriceHeightconstraints.constant = 0
            cell.rightQTYView.isHidden = true
            cell.labelQty.text = arrayDataTemp[indexPath.row]["quantity"].string ?? ""
            cell.labelRighQty.text = arrayDataTemp[indexPath.row]["quantity"].string ?? ""
            
            cell.leftQTYTitle.text = NSLocalizedString("MSG419", comment: "")
            cell.rightQTYTitle.text = NSLocalizedString("MSG418", comment: "")
            
            //cell.labelRightPrice.text = NSLocalizedString("MSG422", comment: "") + ": " + "0.0 \(currency)"
            cell.labelItemCurrentAmount.text  = NSLocalizedString("MSG420", comment: "") + ": " + self.getPrice(dictData: arrayDataTemp[indexPath.row].dictionary!, key: "price") + " \(currency)"
            
            
            let quantity_left = Int(arrayDataTemp[indexPath.row]["quantity_left"].string ?? "0") ?? 0
            if(quantity_left > 0)
            {
                cell.labelQty.text = arrayDataTemp[indexPath.row]["quantity_left"].string ?? ""
                cell.leftQTYTitle.text = NSLocalizedString("MSG417", comment: "")
                cell.labelItemCurrentAmount.text  = NSLocalizedString("MSG421", comment: "") + ": " + self.getPrice(dictData: arrayDataTemp[indexPath.row].dictionary!, key: "base_price_left") + " \(currency)"
                cell.labelQty.isHidden = false
                cell.buttonDecrementItem.isHidden = false
                cell.buttonIncrementItem.isHidden = false
                cell.leftPriceHeightconstraints.constant = 18
                cell.leftQTYViewConstraints.constant = 29
                cell.leftQTYView.isHidden = false
            }
            
            let quantity_right = Int(arrayDataTemp[indexPath.row]["quantity_right"].string ?? "0") ?? 0
            if(quantity_right > 0)
            {
                cell.labelRighQty.text = arrayDataTemp[indexPath.row]["quantity_right"].string ?? ""
                cell.rightQTYTitle.text = NSLocalizedString("MSG418", comment: "")
                cell.labelRightPrice.text  = NSLocalizedString("MSG422", comment: "") + ": " + self.getPrice(dictData: arrayDataTemp[indexPath.row].dictionary!, key: "base_price_right") + " \(currency)"
                cell.rightPriceConstraint.constant = 18
                cell.rightQTYViewConstraints.constant = 29
                cell.rightQTYView.isHidden = false
                
                
                if(quantity_left == 0)
                {
                    cell.labelQty.isHidden = true
                    cell.buttonDecrementItem.isHidden = true
                    cell.buttonIncrementItem.isHidden = true
                    cell.leftPriceHeightconstraints.constant = 0
                    cell.leftQTYViewConstraints.constant = 0
                    cell.leftQTYView.isHidden = true
                }
                else
                {
                    
                    cell.labelQty.isHidden = false
                    cell.buttonDecrementItem.isHidden = false
                    cell.buttonIncrementItem.isHidden = false
                    cell.leftPriceHeightconstraints.constant = 18
                    cell.leftQTYViewConstraints.constant = 29
                    cell.leftQTYView.isHidden = false
                    
                }
                
            }
            
            
            if(quantity_right == 0 && quantity_left == 0)
            {
                cell.leftPriceHeightconstraints.constant = 18
                cell.labelQty.isHidden = false
                cell.buttonDecrementItem.isHidden = false
                cell.buttonIncrementItem.isHidden = false
                cell.leftQTYViewConstraints.constant = 29
                cell.leftQTYView.isHidden = false
            }
            
            
            // strSalePrice = self.getSalePrice(dictData: self.arrayData[indexPath.row].dictionary!)
            //        strSalePrice = self.getSalePrice(dictData: self.arrayData[indexPath.row].dictionary!)
            
            
            
            
            let quantity = Int(arrayDataTemp[indexPath.row]["quantity"].string ?? "0") ?? 0
            let product_quantity = Int(arrayDataTemp[indexPath.row]["product_quantity"].string ?? "0") ?? 0
            let strStockFlag = arrayDataTemp[indexPath.row]["stock_flag"].string ?? "0"
            cell.heightConstraintPower.constant = 0
            
            
            cell.labelPower.text = ""
            if let isPowerAvailable = arrayDataTemp[indexPath.row]["right_eye_power"].string
            {
                if(isPowerAvailable.count > 0)
                {
                    cell.labelPower.isHidden = false
                    cell.heightConstraintPower.constant = 20
                    let rightSelected  = NSLocalizedString("MSG259", comment: "") + String(arrayDataTemp[indexPath.row]["right_eye_power"].string ?? "0.0")
                    if let left_eye_power = arrayDataTemp[indexPath.row]["left_eye_power"].string
                    {
                        if(left_eye_power.count > 0)
                        {
                            let leftSelected  = NSLocalizedString("MSG258", comment: "") + String(arrayDataTemp[indexPath.row]["left_eye_power"].string ?? "0.0")
                            cell.labelPower.text = rightSelected + ", " + leftSelected
                            
                        }
                        else
                        {
                            cell.labelPower.text = rightSelected
                        }
                        
                    }
                    else
                    {
                        cell.labelPower.text = rightSelected
                        
                    }
                    
                    
                    
                }
                
            }
            if(cell.labelPower.text!.count == 0)
            {
                if let isPowerLeftAvailable = arrayDataTemp[indexPath.row]["left_eye_power"].string
                {
                    if(isPowerLeftAvailable.count > 0)
                    {
                        cell.labelPower.isHidden = false
                        cell.heightConstraintPower.constant = 20
                        let left_eye_power  = NSLocalizedString("MSG258", comment: "") + String(arrayDataTemp[indexPath.row]["left_eye_power"].string ?? "0.0")
                        cell.labelPower.text = left_eye_power
                    }
                    
                }
            }
            if( cell.labelPower.text!.count == 0)
            {
                cell.labelPower.isHidden = true
                cell.heightConstraintPower.constant = 0
            }
            else
            {
                
                cell.labelPower.isHidden = false
                cell.heightConstraintPower.constant = 20
            }
            
            if(quantity > 0 && (quantity < product_quantity + 1))
            {
                if((Int(strStockFlag) ?? 0) < 1 || strStockFlag.count < 1)
                {
                    
                    cell.labelOutStock.text = NSLocalizedString("MSG323", comment: "")
                    cell.labelOutStock.isHidden = false
                    cell.heightConstraintPower.constant = 20
                    
                }
                else
                {
                    cell.labelOutStock.text = ""
                    cell.labelOutStock.isHidden = true
                }
            }
            else
            {
                
                
                cell.labelOutStock.text = NSLocalizedString("MSG323", comment: "")
                cell.labelOutStock.isHidden = false
                cell.heightConstraintPower.constant = 20
                
                
                
            }
            
            
            
            
            
            
            cell.labelHeaderItemPrice.text = String(format:"\(NSLocalizedString("MSG348", comment: "")) : %@ \(currency)",self.getTotalPriceEachCart(dictData: arrayDataTemp[indexPath.row].dictionary!))
            
            
            if let strUrl = arrayDataTemp[indexPath.row]["product_image"].string
            {
                if(strUrl.count > 0)
                {
                    let urlString = strUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    
                    
                    cell.imageViewItem.kf.setImage(with: URL(string: KeyConstant.kImageBaseProductURL + urlString!)!, placeholder: UIImage.init(named: "noImage"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: { (downloadImage, error, cacheType, url) in
                        if(downloadImage != nil)
                        {
                            cell.imageViewItem.image = downloadImage!
                        }
                    })
                }
                else
                {
                    cell.imageViewItem.image = UIImage(named: "noImage")
                    
                }
            }
            else
            {
                cell.imageViewItem.image = UIImage(named: "noImage")
                
            }
            
        }
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 49
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        
        
        if let dicData = self.arrayData[section].dictionary
        {
            
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "CartTableFooterSection") as! CartTableViewCell
            
            headerCell.labelFamilyName.text = ""
            headerCell.labelFamilyAmount.text = String(format:"\(NSLocalizedString("MSG348", comment: "")) : %@ \(dicData["current_currency"]?.string ?? currency)",self.getTotalPriceEachCart(dictData: dicData))
            
            headerCell.labelFamilyName.font = UIFont(name: FontLocalization.medium.strValue, size: 13.0)
            
            headerCell.labelFamilyAmount.font = UIFont(name: FontLocalization.medium.strValue, size: 14.0)
            
            if let free_quantity = dicData["free_quantity"]?.int
            {
                if(free_quantity > 0)
                {
                    if let offerName = dicData["offer_name"]?.string
                    {
                        headerCell.labelFamilyName.text = "\(NSLocalizedString("MSG430", comment: "")): \(offerName)"
                        if(HelperArabic().isArabicLanguage())
                        {
                            if let title_ar =  dicData["offer_name_ar"]?.string
                            {
                                if(title_ar.count > 0)
                                {
                                    
                                    
                                    headerCell.labelFamilyName.text = "\(NSLocalizedString("MSG430", comment: "")): \(title_ar)"
                                    
                                }
                            }
                        }
                        
                    }
                    
                }
                
            }
            else if let discount_type = dicData["discount"]?.int
            {
                if(discount_type > 0)
                {
                    if let offerName = dicData["offer_name"]?.string
                    {
                        headerCell.labelFamilyName.text = "\(NSLocalizedString("MSG430", comment: "")): \(offerName)"
                        if(HelperArabic().isArabicLanguage())
                        {
                            if let title_ar =  dicData["offer_name_ar"]?.string
                            {
                                if(title_ar.count > 0)
                                {
                                    
                                    
                                    headerCell.labelFamilyName.text = "\(NSLocalizedString("MSG430", comment: "")): \(title_ar)"
                                    
                                }
                            }
                        }
                        
                    }
                    
                }
                
            }
            return headerCell
        }
        
        
        return UIView()
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //
        //        if(self.stringIsOfferApply.count > 0)
        //        {
        //        let headerCell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCellSection") as! CartTableViewCell
        //
        //            headerCell.labelOfferAlertProductName.text = self.stringIsOfferApply
        //            headerCell.labelOfferAlertTitle.text = NSLocalizedString("MSG248", comment: "")
        //            headerCell.labelOfferAlertDescr.text = NSLocalizedString("MSG250", comment: "")
        //            return headerCell
        //
        //        }
        
        if let dicData = self.arrayData[section].dictionary
        {
            
            if let offer_flag = dicData["offer_flag"]?.int
            {
                if(offer_flag == 1)
                {
                    let headerCell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCellSection") as! CartTableViewCell
                    
                    if let offerName = dicData["offer_name"]?.string
                    {
                        headerCell.labelOfferAlertProductName.text = offerName
                        if(HelperArabic().isArabicLanguage())
                        {
                            if let title_ar =  dicData["offer_name_ar"]?.string
                            {
                                if(title_ar.count > 0)
                                {
                                    
                                    headerCell.labelOfferAlertProductName.text = title_ar
                                    
                                }
                            }
                        }
                        
                    }
                    
                    headerCell.labelOfferAlertTitle.text = NSLocalizedString("MSG248", comment: "")
                    headerCell.labelOfferAlertDescr.text = NSLocalizedString("MSG250", comment: "")
                    
                    
                    if let family_name = dicData["family_name"]?.string
                    {
                        headerCell.labelFamilyName.text = family_name
                        if(HelperArabic().isArabicLanguage())
                        {
                            if let title_ar =  dicData["family_name_ar"]?.string
                            {
                                if(title_ar.count > 0)
                                {
                                    
                                    headerCell.labelFamilyName.text = title_ar
                                    
                                }
                            }
                        }
                    }
                    else
                    {
                        if let product_name = dicData["child"]?[0]["product_name"].string
                        {
                            
                            headerCell.labelFamilyName.text = product_name
                            if(HelperArabic().isArabicLanguage())
                            {
                                if let title_ar =  dicData["child"]?[0]["product_name_ar"].string
                                {
                                    if(title_ar.count > 0)
                                    {
                                        
                                        headerCell.labelFamilyName.text = title_ar
                                        
                                    }
                                }
                            }
                        }
                    }
                    
                    //headerCell.labelFamilyAmount.text = String(format:"\(NSLocalizedString("MSG348", comment: "")) : %@ \(currency)",self.getTotalPriceEachCart(dictData: dicData))
                    headerCell.labelFamilyAmount.text = ""
                    
                    
                    return headerCell
                }
            }
            
            
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewFamilySection") as! CartTableViewCell
            
            
            
            if let family_name = dicData["family_name"]?.string
            {
                headerCell.labelFamilyName.text = family_name
                if(HelperArabic().isArabicLanguage())
                {
                    if let title_ar =  dicData["family_name_ar"]?.string
                    {
                        if(title_ar.count > 0)
                        {
                            
                            headerCell.labelFamilyName.text = title_ar
                            
                        }
                    }
                }
            }
            else
            {
                if let product_name = dicData["child"]?[0]["product_name"].string
                {
                    
                    headerCell.labelFamilyName.text = product_name
                    if(HelperArabic().isArabicLanguage())
                    {
                        if let title_ar =  dicData["child"]?[0]["product_name_ar"].string
                        {
                            if(title_ar.count > 0)
                            {
                                
                                headerCell.labelFamilyName.text = title_ar
                                
                            }
                        }
                    }
                }
            }
            headerCell.labelFamilyAmount.text = ""
            headerCell.labelFamilyName.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
            headerCell.labelFamilyAmount.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
            // headerCell.labelFamilyAmount.text = String(format:"\(NSLocalizedString("MSG348", comment: "")) : %@ \(dicData["current_currency"]?.string ?? currency)",self.getTotalPriceEachCart(dictData: dicData))
            
            return headerCell
        }
        
        
        return UIView()
        
    }
    
    func getStrikeText(price:String)-> NSMutableAttributedString
    {
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: price)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
        return attributeString
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return  UITableView.automaticDimension
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
    }
    
    
    func calculatePrice(price:String, qty:String) -> String
    {
        let currency = KeyConstant.user_Default.value(forKey: KeyConstant.kSelectedCurrency) as! String
        if(self.currency.uppercased() == "KWD")
        {
            return String(format:"%.3f",(Double(price) ?? 0.0) * Double((Int(qty) ?? 0))) + " \(currency)"
        }
        else
        {
            return String(format:"%.2f",(Double(price) ?? 0.0) * Double((Int(qty) ?? 0))) + " \(currency)"
            
        }
    }
    
    func calculateTotalPrice(price:String, qty:String) -> Double
    {
        
        return (Double(price) ?? 0.0) * Double(Int(qty) ?? 0)
    }
    
    
    @objc func buttonViewProduct(sender:UIButton)
    {
        
        let point = tableView.convert(CGPoint.zero, from: sender)
        
        if let indexPath = self.tableView.indexPathForRow(at: point)
        {
            
            if let arrayDataTemp = self.arrayData[indexPath.section]["child"].array
            {
                
                if let pID = arrayDataTemp[sender.tag]["product_id"].string
                {
                    if(pID.count > 0)
                    {
                        let brandVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC
                        brandVC.productId = pID
                        
                        brandVC.stringTitle = arrayDataTemp[sender.tag]["product_name"].string ?? ""
                        if(HelperArabic().isArabicLanguage())
                        {
                            if let title_ar =  arrayDataTemp[sender.tag]["product_name_ar"].string
                            {
                                if(title_ar.count > 0)
                                {
                                    brandVC.stringTitle = title_ar
                                }
                            }
                        }
                        self.present(brandVC, animated: false, completion: nil)
                    }
                }
            }
            
        }
        
    }
    @objc func buttonRemoveItem(sender:UIButton)
    {
        let alertView = UIAlertController(title: NSLocalizedString("MSG31", comment: "").uppercased(), message: "", preferredStyle: .alert)
        
        let msgFont = [NSAttributedString.Key.font: UIFont(name: FontLocalization.medium.strValue, size: 15.0)!]
        
        let msgAttrString = NSMutableAttributedString(string: NSLocalizedString("MSG206", comment: ""), attributes: msgFont)
        
        alertView.setValue(msgAttrString, forKey: "attributedMessage")
        
        let alertAction = UIAlertAction(title: NSLocalizedString("MSG87", comment: ""), style: .default) { (alert) in
            
            
            
        }
        let alertYes = UIAlertAction(title: NSLocalizedString("MSG86", comment: ""), style: .default) { (alert) in
            
            
            let point = self.tableView.convert(CGPoint.zero, from: sender)
            
            if let indexPath = self.tableView.indexPathForRow(at: point)
            {
                
                if let arrayDataTemp = self.arrayData[indexPath.section]["child"].array
                {
                    
                    
                    CartViewModel().deleteToCart(vc: self, param: ["user_cart_id":arrayDataTemp[sender.tag]["id"].string ?? ""], completionHandler: { (isDone:Bool, error:Error?) in
                        
                        if(isDone)
                        {
                            KeyConstant.sharedAppDelegate.showAlertView(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG204", comment: ""))
                            self.getCartList()
                            
                        }
                        else
                        {
                            KeyConstant.sharedAppDelegate.showAlertView(vc: self,titleString:NSLocalizedString("MSG21", comment: ""), messageString: error?.localizedDescription ?? NSLocalizedString("MSG203", comment: ""))
                        }
                    })
                }
            }
            
        }
        alertView.addAction(alertYes)
        
        alertView.addAction(alertAction)
        alertAction.setValue(AppColors.SelcetedColor, forKey: "titleTextColor")
        alertYes.setValue(AppColors.SelcetedColor, forKey: "titleTextColor")
        
        alertView.view.tintColor = UIColor.black
        alertView.view.layer.cornerRadius = 40
        alertView.view.backgroundColor = UIColor.white
        DispatchQueue.main.async(execute: {
            
            self.present(alertView, animated: true, completion: nil)
        })
        
        
    }
    
    
    @objc func buttonRightDecrementItem(sender:UIButton)
    {
        
        
        let point = self.tableView.convert(CGPoint.zero, from: sender)
        
        if let indexPath = self.tableView.indexPathForRow(at: point)
        {
            
            if let arrayDataTemp = self.arrayData[indexPath.section]["child"].array
            {
                
                
                
                let quantity = Int(arrayDataTemp[sender.tag]["quantity"].string ?? "0") ?? 0
                let quantity_left = Int(arrayDataTemp[sender.tag]["quantity_left"].string ?? "0") ?? 0
                let quantity_right = Int(arrayDataTemp[sender.tag]["quantity_right"].string ?? "0") ?? 0
                
                let left_eye_power = arrayDataTemp[sender.tag]["left_eye_power"].string ?? ""
                let right_eye_power = arrayDataTemp[sender.tag]["right_eye_power"].string ?? ""
                
                if(quantity > 1)
                {
                    var parama = ["user_cart_id":arrayDataTemp[sender.tag]["id"].string ?? "","user_id":user_id, "quantity" :String(quantity - 1)]
                    
                    if(quantity_left > 0)
                    {
                        parama["quantity_left"] = String(quantity_left)
                    }
                    if(quantity_right > 0)
                    {
                        parama["quantity_right"] = String(quantity_right - 1)
                    }
                    if(left_eye_power.count > 0)
                    {
                        parama["left_eye_power"] = left_eye_power
                    }
                    if(right_eye_power.count > 0)
                    {
                        parama["right_eye_power"] = right_eye_power
                    }
                    
                    if(quantity_right > 0 && quantity_right < 2)
                    {
                        return
                    }
                    
                    
                    CartViewModel().updateToCart(vc: self, param: parama, completionHandler: { (isDone:Bool, error:Error?) in
                        
                        if(isDone)
                        {
                            self.getCartList()
                        }
                        else
                        {
                            KeyConstant.sharedAppDelegate.showAlertView(vc: self,titleString:NSLocalizedString("MSG21", comment: ""), messageString: error?.localizedDescription ?? NSLocalizedString("MSG203", comment: ""))
                        }
                    })
                }
            }
        }
        
    }
    
    @objc func buttonDecrementItem(sender:UIButton)
    {
        
        let point = self.tableView.convert(CGPoint.zero, from: sender)
        
        if let indexPath = self.tableView.indexPathForRow(at: point)
        {
            
            if let arrayDataTemp = self.arrayData[indexPath.section]["child"].array
            {
                
                let quantity = Int(arrayDataTemp[sender.tag]["quantity"].string ?? "0") ?? 0
                let quantity_left = Int(arrayDataTemp[sender.tag]["quantity_left"].string ?? "0") ?? 0
                let quantity_right = Int(arrayDataTemp[sender.tag]["quantity_right"].string ?? "0") ?? 0
                let left_eye_power = arrayDataTemp[sender.tag]["left_eye_power"].string ?? ""
                let right_eye_power = arrayDataTemp[sender.tag]["right_eye_power"].string ?? ""
                
                if(quantity > 1)
                {
                    var parama = ["user_cart_id":arrayDataTemp[sender.tag]["id"].string ?? "","user_id":user_id, "quantity" :String(quantity - 1)]
                    
                    if(quantity_left > 0)
                    {
                        parama["quantity_left"] = String(quantity_left - 1)
                    }
                    if(quantity_right > 0)
                    {
                        parama["quantity_right"] = String(quantity_right)
                    }
                    if(left_eye_power.count > 0)
                    {
                        parama["left_eye_power"] = left_eye_power
                    }
                    if(right_eye_power.count > 0)
                    {
                        parama["right_eye_power"] = right_eye_power
                    }
                    
                    if(quantity_left > 0 && quantity_left < 2)
                    {
                        return
                    }
                    
                    
                    CartViewModel().updateToCart(vc: self, param: parama, completionHandler: { (isDone:Bool, error:Error?) in
                        
                        if(isDone)
                        {
                            self.getCartList()
                        }
                        else
                        {
                            KeyConstant.sharedAppDelegate.showAlertView(vc: self,titleString:NSLocalizedString("MSG21", comment: ""), messageString: error?.localizedDescription ?? NSLocalizedString("MSG203", comment: ""))
                        }
                    })
                }
            }}
        
    }
    
    @objc func buttonRightIncrementItem(sender:UIButton)
    {
        let point = self.tableView.convert(CGPoint.zero, from: sender)
        
        
        if let indexPath = self.tableView.indexPathForRow(at: point)
        {
            
            if let arrayDataTemp = self.arrayData[indexPath.section]["child"].array
            {
                
                let quantity = Int(arrayDataTemp[sender.tag]["quantity"].string ?? "0") ?? 0
                let quantity_left = Int(arrayDataTemp[sender.tag]["quantity_left"].string ?? "0") ?? 0
                let quantity_right = Int(arrayDataTemp[sender.tag]["quantity_right"].string ?? "0") ?? 0
                let product_quantity = Int(arrayDataTemp[sender.tag]["product_quantity"].string ?? "0") ?? 0
                let stock_flag = Int(arrayDataTemp[sender.tag]["stock_flag"].string ?? "0") ?? 0
                let left_eye_power = arrayDataTemp[sender.tag]["left_eye_power"].string ?? ""
                let right_eye_power = arrayDataTemp[sender.tag]["right_eye_power"].string ?? ""
                
                if(quantity > 0 && (quantity < product_quantity))
                {
                    
                    if(stock_flag > 0)
                    {
                        var parama = ["user_cart_id":arrayDataTemp[sender.tag]["id"].string ?? "","user_id":user_id, "quantity" :String(quantity + 1)]
                        
                        if(quantity_left > 0)
                        {
                            parama["quantity_left"] = String(quantity_left)
                        }
                        if(quantity_right > 0)
                        {
                            parama["quantity_right"] = String(quantity_right + 1)
                        }
                        if(left_eye_power.count > 0)
                        {
                            parama["left_eye_power"] = left_eye_power
                        }
                        if(right_eye_power.count > 0)
                        {
                            parama["right_eye_power"] = right_eye_power
                        }
                        
                        
                        
                        
                        CartViewModel().updateToCart(vc: self, param: parama, completionHandler: { (isDone:Bool, error:Error?) in
                            
                            if(isDone)
                            {
                                self.getCartList()
                                
                            }
                            else
                            {
                                KeyConstant.sharedAppDelegate.showAlertView(vc: self,titleString:NSLocalizedString("MSG21", comment: ""), messageString: error?.localizedDescription ?? NSLocalizedString("MSG203", comment: ""))
                            }
                            
                        })
                    }
                    else
                    {
                        self.showAlertStock()
                        
                    }
                }
                else
                {
                    self.showAlertStock()
                }
            }
        }
        
        
    }
    @objc func buttonIncrementItem(sender:UIButton)
    {
        
        let point = self.tableView.convert(CGPoint.zero, from: sender)
        
        
        if let indexPath = self.tableView.indexPathForRow(at: point)
        {
            
            if let arrayDataTemp = self.arrayData[indexPath.section]["child"].array
            {
                let quantity = Int(arrayDataTemp[sender.tag]["quantity"].string ?? "0") ?? 0
                let quantity_left = Int(arrayDataTemp[sender.tag]["quantity_left"].string ?? "0") ?? 0
                let quantity_right = Int(arrayDataTemp[sender.tag]["quantity_right"].string ?? "0") ?? 0
                let left_eye_power = arrayDataTemp[sender.tag]["left_eye_power"].string ?? ""
                let right_eye_power = arrayDataTemp[sender.tag]["right_eye_power"].string ?? ""
                
                let product_quantity = Int(arrayDataTemp[sender.tag]["product_quantity"].string ?? "0") ?? 0
                let stock_flag = Int(arrayDataTemp[sender.tag]["stock_flag"].string ?? "0") ?? 0
                
                if(quantity > 0 && (quantity <= product_quantity))
                {
                    
                    if(stock_flag == 1)
                    {
                        var parama = ["user_cart_id":arrayDataTemp[sender.tag]["id"].string ?? "","user_id":user_id, "quantity" :String(quantity + 1)]
                        
                        if(quantity_left > 0)
                        {
                            parama["quantity_left"] = String(quantity_left + 1)
                        }
                        if(quantity_right > 0)
                        {
                            parama["quantity_right"] = String(quantity_right)
                        }
                        if(left_eye_power.count > 0)
                        {
                            parama["left_eye_power"] = left_eye_power
                        }
                        if(right_eye_power.count > 0)
                        {
                            parama["right_eye_power"] = right_eye_power
                        }
                        CartViewModel().updateToCart(vc: self, param: parama, completionHandler: { (isDone:Bool, error:Error?) in
                            
                            if(isDone)
                            {
                                self.getCartList()
                                
                            }
                            else
                            {
                                KeyConstant.sharedAppDelegate.showAlertView(vc: self,titleString:NSLocalizedString("MSG21", comment: ""), messageString: error?.localizedDescription ?? NSLocalizedString("MSG203", comment: ""))
                            }
                            
                        })
                    }
                    else
                    {
                        self.showAlertStock()
                        
                    }
                }
                else
                {
                    self.showAlertStock()
                }
                
            }
        }
        
    }
    
    func showAlertStock()
    {
        let alertView = UIAlertController(title: NSLocalizedString("MSG31", comment: "").uppercased(), message: "", preferredStyle: .alert)
        let msgFont = [NSAttributedString.Key.font: UIFont(name: FontLocalization.medium.strValue, size: 15.0)!]
        let msgAttrString = NSMutableAttributedString(string: NSLocalizedString("MSG315", comment: ""), attributes: msgFont)
        alertView.setValue(msgAttrString, forKey: "attributedMessage")
        
        let alertAction = UIAlertAction(title: NSLocalizedString("MSG18", comment: ""), style: .default) { (alert) in
        }
        alertAction.setValue(AppColors.SelcetedColor, forKey: "titleTextColor")
        alertView.addAction(alertAction)
        self.present(alertView, animated: true, completion: nil)
    }
    
    @objc func buttonMoveToWishList(sender:UIButton)
    {
        
        
        let alertView = UIAlertController(title: NSLocalizedString("MSG31", comment: "").uppercased(), message: "", preferredStyle: .alert)
        
        
        let msgFont = [NSAttributedString.Key.font: UIFont(name: FontLocalization.medium.strValue, size: 15.0)!]
        
        let msgAttrString = NSMutableAttributedString(string: NSLocalizedString("MSG207", comment: ""), attributes: msgFont)
        
        alertView.setValue(msgAttrString, forKey: "attributedMessage")
        
        
        let alertAction = UIAlertAction(title: NSLocalizedString("MSG87", comment: ""), style: .default) { (alert) in
            
            
            
        }
        let alertYes = UIAlertAction(title: NSLocalizedString("MSG86", comment: ""), style: .default) { (alert) in
            
            let point = self.tableView.convert(CGPoint.zero, from: sender)
            
            
            if let indexPath = self.tableView.indexPathForRow(at: point)
            {
                
                if let arrayDataTemp = self.arrayData[indexPath.section]["child"].array
                {
                    
                    
                    CartViewModel().moveToWishlistFromCart(vc: self, param: ["user_cart_id":arrayDataTemp[sender.tag]["id"].string ?? "","user_id":self.user_id], completionHandler: { (isDone:Bool, error:Error?) in
                        
                        if(isDone)
                        {
                            KeyConstant.sharedAppDelegate.showAlertView(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG205", comment: ""))
                            self.getCartList()
                            
                        }
                        else
                        {
                            KeyConstant.sharedAppDelegate.showAlertView(vc: self,titleString:NSLocalizedString("MSG21", comment: ""), messageString: error?.localizedDescription ?? NSLocalizedString("MSG203", comment: ""))
                        }
                    })
                    
                }
            }
        }
        alertView.addAction(alertYes)
        
        alertView.addAction(alertAction)
        
        alertYes.setValue(AppColors.SelcetedColor, forKey: "titleTextColor")
        alertAction.setValue(AppColors.SelcetedColor, forKey: "titleTextColor")
        
        alertView.view.tintColor = UIColor.black
        alertView.view.layer.cornerRadius = 40
        alertView.view.backgroundColor = UIColor.white
        DispatchQueue.main.async(execute: {
            self.present(alertView, animated: true, completion: nil)
        })
        
        
    }
    
    
    
    
    func getPrice(dictData:[String:JSON],key:String) -> String
    {
        var price = ""
        if let priceDouble = dictData[key]?.double
        {
            if(self.currency.uppercased() == "KWD")
            {
                price = String(format:"%.3f", priceDouble)
            }
            else
            {
                price = String(format:"%.2f", priceDouble)
                
            }
        }
        else if let priceInt = dictData[key]?.int
        {
            price = String(format:"%d",priceInt)
        }
        else
        {
            var strPrice = dictData[key]?.string ?? "0.0"
            strPrice = strPrice.replacingOccurrences(of: ",", with: "")
            if(self.currency.uppercased() == "KWD")
            {
                price = String(format:"%.3f", Double(strPrice)?.roundTo(places: 3) ?? 0.0)
                
            }
            else
            {
                price = String(format:"%.2f", Double(strPrice)?.roundTo(places: 2) ?? 0.0)
                
            }
        }
        return price
    }
    
    func getSalePrice(dictData:[String:JSON]) -> String
    {
        var price = ""
        if let priceDouble = dictData["sale_price"]?.double
        {
            if(self.currency.uppercased() == "KWD")
            {
                price = String(format:"%.3f", priceDouble)
            }
            else
            {
                price = String(format:"%.2f", priceDouble)
                
            }
        }
        else if let priceInt = dictData["sale_price"]?.int
        {
            price = String(format:"%d",priceInt)
        }
        else
        {
            var strPrice = dictData["sale_price"]?.string ?? "0.0"
            strPrice = strPrice.replacingOccurrences(of: ",", with: "")
            if(self.currency.uppercased() == "KWD")
            {
                price = String(format:"%.3f", Double(strPrice)?.roundTo(places: 3) ?? 0.0)
                
            }
            else
            {
                price = String(format:"%.2f", Double(strPrice)?.roundTo(places: 2) ?? 0.0)
                
            }
            
        }
        return price
    }
    
    func getTotalPriceEachCart(dictData:[String:JSON]) -> String
    {
        var price = ""
        if let priceDouble = dictData["total"]?.double
        {
            if(self.currency.uppercased() == "KWD")
            {
                price = String(format:"%.3f", priceDouble)
            }
            else
            {
                price = String(format:"%.2f", priceDouble)
                
            }
        }
        else if let priceInt = dictData["total"]?.int
        {
            price = String(format:"%d",priceInt)
        }
        else
        {
            var strPrice = dictData["total"]?.string ?? "0.0"
            strPrice = strPrice.replacingOccurrences(of: ",", with: "")
            if(self.currency.uppercased() == "KWD")
            {
                price = String(format:"%.3f", Double(strPrice)?.roundTo(places: 3) ?? 0.0)
                
            }
            else
            {
                price = String(format:"%.2f", Double(strPrice)?.roundTo(places: 2) ?? 0.0)
                
            }
            
        }
        return price
    }
    
    func getTotalPriceEachCartDouble(dictData:[String:JSON]) -> Double
    {
        var price = 0.0
        if let priceDouble = dictData["total"]?.double
        {
            price = priceDouble
        }
        else if let priceInt = dictData["total"]?.int
        {
            price = Double(priceInt)
        }
        else
        {
            var strPrice = dictData["total"]?.string ?? "0.0"
            strPrice = strPrice.replacingOccurrences(of: ",", with: "")
            price = Double(strPrice) ?? 0.0
            if(self.currency.uppercased() == "KWD")
            {
                price = Double(strPrice)?.roundTo(places: 3) ?? 0.0
                
            }
            else
            {
                price = Double(strPrice)?.roundTo(places: 2) ?? 0.0
                
            }
        }
        
        return price
    }
    
}


extension NSMutableAttributedString {
    
    func setColorForText(textForAttribute: String, withColor color: UIColor) {
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)
        
        // Swift 4.2 and above
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        
        // Swift 4.1 and below
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }
    
}
extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        //let textContainerOffset = CGPointMake((labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
        //(labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        
        //let locationOfTouchInTextContainer = CGPointMake(locationOfTouchInLabel.x - textContainerOffset.x,
        // locationOfTouchInLabel.y - textContainerOffset.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}
