//
//  CheckOutVC.swift
//  LENZZO
//
//  Created by Apple on 9/7/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import UIKit
import Kingfisher
import AlamofireImage
import SwiftyJSON
class CheckOutVC: UIViewController {
    
    @IBOutlet weak var footerViewTable: UIView!
    @IBOutlet weak var labelSubToTalAmount: PaddingLabel!
    @IBOutlet weak var labelStep: PaddingLabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelCountCart: UILabel!
    
    @IBOutlet weak var addAddressImgView: UIImageView!
    
    @IBOutlet weak var addNewAddrsLbl: PaddingLabel!
    @IBOutlet weak var checkOutTitleLbl: PaddingLabel!
    @IBOutlet weak var plusImgView: UIImageView!
    
    @IBOutlet weak var shippingAddTitleLbl: PaddingLabel!
    @IBOutlet weak var backImgView: UIImageView!
    @IBOutlet weak var homeBtn: UIButton!
    
    @IBOutlet weak var continueToPayBtn: UIButton!
    
    var user_id = KeyConstant.sharedAppDelegate.getUserId()
    
    
    var arraySelectedAllCartItems = [JSON]()
    var sellDPrice = 0.0
    var subTotalPrice = Double()
    var arrayData = [JSON]()
    var arrayTempData = [Int]()
    var addressSelected = String()
    var redeemPointsApplied = [String:String]()
    
    var promoDetails = [String:String]()
    var isFromGuestLogin = Bool()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.tableFooterView = UIView()
        
        
        print(promoDetails, redeemPointsApplied )
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        let currency = KeyConstant.user_Default.value(forKey: KeyConstant.kSelectedCurrency) as! String
        
        if(currency.uppercased() == "KWD")
        {
            self.labelSubToTalAmount.text = NSLocalizedString("MSG329", comment: "") + " : \(String(format:"%.3f",self.subTotalPrice)) \(currency)"
        }
        else
        {
            self.labelSubToTalAmount.text = NSLocalizedString("MSG329", comment: "") + " : \(String(format:"%.2f",self.subTotalPrice)) \(currency)"
            
        }
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(rightSwip))
        
        
        
        if(HelperArabic().isArabicLanguage())
        {
            
            swipeRight.direction = UISwipeGestureRecognizer.Direction.left
            labelSubToTalAmount.textAlignment = .right
            
        }
        else
        {
            swipeRight.direction = UISwipeGestureRecognizer.Direction.right
            labelSubToTalAmount.textAlignment = .right
        }
        
        
        self.view.addGestureRecognizer(swipeRight)
        
            self.changeTintAndThemeColor()
            
        self.addNewAddrsLbl.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        self.labelSubToTalAmount.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        self.labelStep.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        self.checkOutTitleLbl.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        self.shippingAddTitleLbl.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        
        self.continueToPayBtn.titleLabel?.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        
        
        }
        
        
        func changeTintAndThemeColor(){
            
            let homeimg = UIImage(named: "homeB")?.withRenderingMode(.alwaysTemplate)
            self.homeBtn.setImage(homeimg, for: .normal)
            self.homeBtn.tintColor = .white

            self.backImgView.image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate)
            self.backImgView.tintColor = .white

            self.plusImgView.image = UIImage(named: "plus_50x50")?.withRenderingMode(.alwaysTemplate)
            self.plusImgView.tintColor = .white


            self.addAddressImgView.image = UIImage(named: "address_50x50")?.withRenderingMode(.alwaysTemplate)
            self.addAddressImgView.tintColor = .white

            
        }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if(HelperArabic().isArabicLanguage())
        {
         self.backImgView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }
        else
        {
        self.backImgView.transform = CGAffineTransform(rotationAngle: 245)
        }
        
        if (user_id.count > 0)
        {
            getCartList()
            self.getAllAddress()
        }
    }
    
    @IBAction func buttonHome(_ sender: Any) {
        
        KeyConstant.sharedAppDelegate.setRoot()
        
    }
    
    
    func getCartList()
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
    @objc func rightSwip(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            self.buttonBackAction(UIButton())
            
        }
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    @IBAction func buttonBackAction(_ sender: Any) {
        //self.dismiss(animated: false, completion: nil)
        if(self.navigationController != nil)
        {
            self.navigationController?.popViewController(animated: true)
        }
        else
        {
            self.dismiss(animated: false, completion: nil)
        }
    }
    @IBAction func buttonAddAddress(_ sender: Any) {
        
        let objFav = self.storyboard?.instantiateViewController(withIdentifier: "NewAddressVC") as! NewAddressVC
        self.present(objFav, animated: false, completion: nil)
        
        
    }
    @IBAction func buttonCheckOut(_ sender: Any) {
        print(self.addressSelected)
        for ind in 0..<self.arrayTempData.count
        {
            if(self.arrayTempData[ind] == 1)
            {
//
//                let objVC = self.storyboard?.instantiateViewController(withIdentifier: "GiftItemsVC") as! GiftItemsVC
//                objVC.modalPresentationStyle = .overCurrentContext
//                objVC.subTotalPrice = subTotalPrice
//                objVC.address = self.addressSelected
//                objVC.arraySelectedAllCartItems = self.arraySelectedAllCartItems
//                objVC.promoDetails =  promoDetails
//                objVC.redeemPointsApplied =  redeemPointsApplied
//                objVC.dicSelectedAddress = self.arrayData[ind].dictionary!
//                self.present(objVC, animated: false, completion: nil)
//                return
                
                if let objVC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentOptionVC") as? PaymentOptionVC{
                    objVC.subTotal = self.subTotalPrice
                               objVC.address = self.addressSelected
                               //objVC.giftId = self.giftId
                               objVC.dicSelectedAddress = self.arrayData[ind].dictionary!//self.dicSelectedAddress
                               objVC.promoDetails =  self.promoDetails
                               objVC.redeemPointsApplied =  self.redeemPointsApplied

                               objVC.arraySelectedAllCartItems = self.arraySelectedAllCartItems
                              // objVC.deliveryCharge = self.getPrice(dictData: arrayData[ind].dictionary!)
                               self.present(objVC, animated: false, completion: nil)
                               return
                }
               
            }
        }
        
        
        KeyConstant.sharedAppDelegate.showAlertView(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG209", comment: ""))
        
    }
    @IBAction func buttonCartList(_ sender: Any) {
        
        if(self.navigationController != nil)
        {
            self.navigationController?.popViewController(animated: true)
        }
        else
        {
            self.dismiss(animated: false, completion: nil)
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
extension CheckOutVC:UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrayData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckouttVCell") as! CheckouttVCell
        cell.buttonDelete.tag = indexPath.row
        cell.buttonEdit.tag = indexPath.row
        cell.buttonCart.tag = indexPath.row
        cell.buttonSelectAddress.tag = indexPath.row
        cell.buttonDelete.addTarget(self, action: #selector(buttonDelete), for: .touchUpInside)
        cell.buttonEdit.addTarget(self, action: #selector(buttonEdit), for: .touchUpInside)
        cell.buttonCart.addTarget(self, action: #selector(buttonSelect), for: .touchUpInside)
        cell.buttonSelectAddress.addTarget(self, action: #selector(buttonSelect), for: .touchUpInside)
        
        
        if let dicData = arrayData[indexPath.row].dictionary
        {
            cell.labelInfo.attributedText = self.getAddress(dicData: dicData)
            cell.labelInfo.setLineSpacing(lineSpacing: 3.0)
        }
        
        if HelperArabic().isArabicLanguage(){
                   cell.labelInfo.textAlignment = .right
               }else{
                   cell.labelInfo.textAlignment = .left
               }
        
        if(arrayTempData[indexPath.row] == 1)
        {
            cell.buttonCart.setImage(UIImage(named: "slect_100x100")?.withRenderingMode(.alwaysTemplate), for: .normal)
            cell.buttonCart.tintColor = .white//AppColors.SelcetedColor
            self.addressSelected = cell.labelInfo.text ?? ""
        }
        else
        {
            cell.buttonCart.setImage(UIImage(named: "de_select_100x100")?.withRenderingMode(.alwaysTemplate), for: .normal)
            cell.buttonCart.tintColor = .white//AppColors.SelcetedColor
        }
        return cell
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return  UITableView.automaticDimension
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
    }
    
    @objc func buttonDelete(sender:UIButton){
        let alertView = UIAlertController(title: NSLocalizedString("MSG31", comment: "").uppercased(), message: NSLocalizedString("MSG210", comment: ""), preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: NSLocalizedString("MSG87", comment: ""), style: .default) { (alert) in
            
            
            
        }
        let alertYes = UIAlertAction(title: NSLocalizedString("MSG86", comment: ""), style: .default) { (alert) in
            
            
            
            
            
            CartViewModel().deleteToAddress(vc: self, param: ["user_billing_address_id":self.arrayData[sender.tag]["id"].string ?? ""], completionHandler: { (isDone:Bool, error:Error?) in
                
                if(isDone)
                {
                    KeyConstant.sharedAppDelegate.showAlertView(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG204", comment: ""))
                    self.getAllAddress()
                    
                }
                else
                {
                    KeyConstant.sharedAppDelegate.showAlertView(vc: self,titleString:NSLocalizedString("MSG21", comment: ""), messageString: error?.localizedDescription ?? NSLocalizedString("MSG203", comment: ""))
                }
            })
            
        }
        alertYes.setValue(AppColors.SelcetedColor, forKey: "titleTextColor")
        alertAction.setValue(AppColors.SelcetedColor, forKey: "titleTextColor")
        alertView.addAction(alertYes)
        
        alertView.addAction(alertAction)
        
        
        let msgFont = [NSAttributedString.Key.font: UIFont(name: FontLocalization.medium.strValue, size: 15.0)!]
        let msgAttrString = NSMutableAttributedString(string: NSLocalizedString("MSG210", comment: ""), attributes: msgFont)
        alertView.setValue(msgAttrString, forKey: "attributedMessage")
        self.present(alertView, animated: true, completion: nil)
        
        
        
    }
    
    func getAddress(dicData:[String:JSON])->NSAttributedString
    {
        var strAddress = ""
        if(String(dicData["full_name"]?.string ?? "").count > 0)
        {
            strAddress = "\(NSLocalizedString("MSG302", comment: "")) \(dicData["full_name"]?.string ?? "")\n"
        }
        if(String(dicData["area"]?.string ?? "").count > 0)
        {
            strAddress = strAddress + "\(NSLocalizedString("MSG303", comment: "")) \(dicData["area"]?.string ?? "")\n"
        }
        if(String(dicData["block"]?.string ?? "").count > 0)
        {
            strAddress = strAddress + "\(NSLocalizedString("MSG304", comment: "")) \(dicData["block"]?.string ?? "")\n"
        }
        if(String(dicData["street"]?.string ?? "").count > 0)
        {
            strAddress = strAddress + "\(NSLocalizedString("MSG305", comment: "")) \(dicData["street"]?.string ?? "")\n"
        }
        if(String(dicData["avenue"]?.string ?? "").count > 0)
        {
            strAddress = strAddress + "\(NSLocalizedString("MSG306", comment: "")) \(dicData["avenue"]?.string ?? "")\n"
        }
        if(String(dicData["house_no"]?.string ?? "").count > 0)
        {
            strAddress = strAddress + "\(NSLocalizedString("MSG307", comment: "")) \(dicData["house_no"]?.string ?? "")\n"
        }
        if(String(dicData["floor_no"]?.string ?? "").count > 0)
        {
            strAddress = strAddress + "\(NSLocalizedString("MSG308", comment: "")) \(dicData["floor_no"]?.string ?? "")\n"
        }
        if(String(dicData["flat_no"]?.string ?? "").count > 0)
        {
            strAddress = strAddress + "\(NSLocalizedString("MSG309", comment: "")) \(dicData["flat_no"]?.string ?? "")\n"
        }
        if(String(dicData["phone_no"]?.string ?? "").count > 0)
        {
            strAddress = strAddress + "\(NSLocalizedString("MSG310", comment: "")) \(dicData["phone_no"]?.string ?? "")\n"
        }
        if(String(dicData["paci_number"]?.string ?? "").count > 0)
        {
            strAddress = strAddress + "\(NSLocalizedString("MSG311", comment: "")) \(dicData["paci_number"]?.string ?? "")\n"
        }
        if(String(dicData["comments"]?.string ?? "").count > 0)
        {
            strAddress = strAddress + "\(NSLocalizedString("MSG312", comment: "")) \(dicData["comments"]?.string ?? "")\n"
        }
        
        if(dicData["currrent_location"]?.string?.count ?? 0 > 0)
        {
            strAddress = strAddress + "\n\(NSLocalizedString("MSG313", comment: ""))\(String(format:"%@",(dicData["currrent_location"]?.string)!))\n\n"
        }
        
        
        
        let stringBold = [NSLocalizedString("MSG302", comment: ""),NSLocalizedString("MSG303", comment: ""),NSLocalizedString("MSG304", comment: ""),NSLocalizedString("MSG305", comment: ""),NSLocalizedString("MSG306", comment: ""),NSLocalizedString("MSG307", comment: ""),NSLocalizedString("MSG308", comment: ""),NSLocalizedString("MSG309", comment: ""),NSLocalizedString("MSG310", comment: ""),NSLocalizedString("MSG311", comment: ""),NSLocalizedString("MSG312", comment: ""),NSLocalizedString("MSG313", comment: "")]
        
        return strAddress.withBoldText(arraytext: stringBold, font: UIFont.init(name: FontLocalization.medium.strValue, size: 13.0),boldFont:UIFont.init(name: FontLocalization.Bold.strValue, size: 13.0))
    }
    
    @objc func buttonEdit(sender:UIButton){
        
        if let dicData = arrayData[sender.tag].dictionary
        {
            let objFav = self.storyboard?.instantiateViewController(withIdentifier: "NewAddressVC") as! NewAddressVC
            objFav.dicEditData = dicData
            self.present(objFav, animated: false, completion: nil)
        }
    }
    @objc func buttonSelect(sender:UIButton){
        
        self.arrayTempData.removeAll()
        for ind in 0..<self.arrayData.count
        {
            self.arrayTempData.insert(0, at: self.arrayTempData.count)
        }
        self.arrayTempData[sender.tag] = 1
        self.tableView.reloadData()
    }
    
    func getAllAddress()
    {
        
        MBProgress().showIndicator(view: self.view)
        
        self.arrayData.removeAll()
        
        self.arrayTempData.removeAll()
        
        WebServiceHelper.sharedInstanceAPI.hitPostAPI(urlString: KeyConstant.APIGetAllAddress, params: ["user_id":user_id], completionHandler: { (result: [String:Any], err:Error?) in
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
                self.arrayData = json["response"]["user_billing_address_Array"]["wishlist"].array ?? [JSON]()
                
                for ind in 0..<self.arrayData.count
                {
                    self.arrayTempData.insert(0, at: self.arrayTempData.count)
                }
                self.tableView.reloadData()
                
                if(self.arrayData.count == 0 && self.isFromGuestLogin == true)
                {
                    if let guest = KeyConstant.user_Default.value(forKey: KeyConstant.kCheckoutGuestId) as? String
                    {
                        let objFav = self.storyboard?.instantiateViewController(withIdentifier: "NewAddressVC") as! NewAddressVC
                        self.isFromGuestLogin = false
                        self.present(objFav, animated: false, completion: nil)
                        
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
                KeyConstant.sharedAppDelegate.showAlertView(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: message ?? NSLocalizedString("MSG21", comment: ""))
            }
            
        })
        
        
    }
    
    
    
    
    
    
}
