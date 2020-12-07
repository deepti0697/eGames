//
//  GiftItemsVC.swift
//  LENZZO
//
//  Created by Apple on 9/10/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import UIKit
import Kingfisher
import AlamofireImage
import SwiftyJSON
import IQKeyboardManagerSwift
import CoreLocation
class GiftItemsVC: UIViewController {
    var arrayData = [JSON]()
    var arrayTempData = [Int]()
    var subTotalPrice = Double()
    var address = String()
var giftId = String()
    var promoDetails = [String:String]()
    var redeemPointsApplied = [String:String]()

    var arraySelectedAllCartItems = [JSON]()
    var dicSelectedAddress = [String:JSON]()
    var user_id = KeyConstant.sharedAppDelegate.getUserId()

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        for ind in 0..<3
        {
            self.arrayTempData.insert(0, at: self.arrayTempData.count)
        }
        tableView.tableFooterView = UIView()
     
        
        
        giftId = ""
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
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

            
            
        }
        
    
    
    
    override func viewWillAppear(_ animated: Bool) {

        self.getAllGiftItems()
    }
    
    @IBAction func buttonSkip(_ sender: Any) {
      
        self.getCountryLanguage()
    }
    
    @IBAction func buttonDone(_ sender: Any) {
                    
        self.getCountryLanguage()

    }
    
    
    
    func getCountryLanguage()
    {
        
        MBProgress().showIndicator(view: self.view)
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
                let arrayData = json["result"].array ?? [JSON]()
                if let isCountrySelected = KeyConstant.user_Default.value(forKey: KeyConstant.kSelectedCountry) as? String
                {
                    if(isCountrySelected.count > 0)
                    {
                        for ind in 0..<arrayData.count
                        {
                            if(arrayData[ind]["asciiname"].string?.lowercased() == isCountrySelected.lowercased())
                            {
                                let objVC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentOptionVC") as! PaymentOptionVC
                                objVC.subTotal = self.subTotalPrice
                                objVC.address = self.address
                                objVC.giftId = self.giftId
                                objVC.dicSelectedAddress = self.dicSelectedAddress
                                objVC.promoDetails =  self.promoDetails
                                objVC.redeemPointsApplied =  self.redeemPointsApplied

                                objVC.arraySelectedAllCartItems = self.arraySelectedAllCartItems
                                objVC.deliveryCharge = self.getPrice(dictData: arrayData[ind].dictionary!)
                                self.present(objVC, animated: false, completion: nil)
                                return
                            }
                        }
                    }
                }
               
            }
            
         
            
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
            
            
        })
        
        
        
    }
    func getPrice(dictData:[String:JSON]) -> Double
    {
        var price = 0.0
        
        if let priceDouble = dictData["delivery_charge"]?.double
        {
            price = priceDouble
        }
        else if let priceInt = dictData["delivery_charge"]?.int
        {
            price = Double(priceInt)
        }
        else
        {
            price =  Double(dictData["delivery_charge"]?.string ?? "0.0") ?? 0.0
        }
        return price
    }
    @IBAction func buttonCross(_ sender: Any) {
        
        self.dismiss(animated: false, completion: nil)

    }
    
    @objc func rightSwip(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            self.buttonCross(UIButton())

        }
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    func getAllGiftItems()
    {
       
            MBProgress().showIndicator(view: self.view)
            
            self.arrayData.removeAll()
            
            self.arrayTempData.removeAll()
            
        WebServiceHelper.sharedInstanceAPI.hitPostAPI(urlString: KeyConstant.APIGetAllFreeGift, params: [:], completionHandler: { (result: [String:Any], err:Error?) in
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
                        self.arrayTempData.insert(0, at: self.arrayTempData.count)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension GiftItemsVC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return self.arrayData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GiftTableViewCell") as! GiftTableViewCell
       cell.labelgiftsTitle.text = self.arrayData[indexPath.row]["title"].string ?? ""
        cell.buttonGiftsDesc.text = String(self.arrayData[indexPath.row]["description"].string ?? "")
        
        if(HelperArabic().isArabicLanguage())
        {
            if let title_ar = self.arrayData[indexPath.row]["title_ar"].string
            {
                cell.labelgiftsTitle.text = title_ar
                
            }
            if let description_ar = self.arrayData[indexPath.row]["description_ar"].string
            {
                cell.buttonGiftsDesc.text = description_ar
                
            }
        }
        

        cell.buttonSelectionGift.tag = indexPath.row
        cell.buttonSelectionGift.addTarget(self, action: #selector(buttonSelection), for: .touchUpInside)
        
        
        cell.buttonViewDesc.tag = indexPath.row
        cell.buttonViewDesc.addTarget(self, action: #selector(buttonViewDesc), for: .touchUpInside)
        
        cell.buttonViewImage.tag = indexPath.row
        cell.buttonViewImage.addTarget(self, action: #selector(buttonViewImage), for: .touchUpInside)
        
        if(arrayTempData[indexPath.row] == 1)
        {
            //cell.buttonSelection.setImage(UIImage(named: "slect_100x100"), for: .normal)
            cell.buttonSelection.setImage(UIImage(named: "slect_100x100")?.withRenderingMode(.alwaysTemplate), for: .normal)
            cell.buttonSelection.tintColor = AppColors.SelcetedColor
        }
        else
        {
            //cell.buttonSelection.setImage(UIImage(named: "de_select_100x100"), for: .normal)
            cell.buttonSelection.setImage(UIImage(named: "de_select_100x100")?.withRenderingMode(.alwaysTemplate), for: .normal)
            cell.buttonSelection.tintColor = AppColors.SelcetedColor
            
        }
        if let strUrl = self.arrayData[indexPath.row]["image"].string
        {
            if(strUrl.count > 0)
            {
                let urlString = strUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                
                
                cell.imageViewGift.kf.setImage(with: URL(string: KeyConstant.kImageBaseGiftsURL + urlString!)!, placeholder: UIImage.init(named: "noImage"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: { (downloadImage, error, cacheType, url) in
                    if(downloadImage != nil)
                    {
                        cell.imageViewGift.image = downloadImage!
                    }
                })
            }
            else
            {
                cell.imageViewGift.image = UIImage(named: "noImage")
                
            }
        }
        else
        {
            cell.imageViewGift.image = UIImage(named: "noImage")
            
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    
    
    @objc func buttonSelection(sender:UIButton){
        
        self.arrayTempData.removeAll()
        for ind in 0..<3
        {
            self.arrayTempData.insert(0, at: self.arrayTempData.count)
        }
        self.arrayTempData[sender.tag] = 1
        giftId = self.arrayData[sender.tag]["id"].string ?? ""
        self.tableView.reloadData()
    }
    
    @objc func buttonViewDesc(sender:UIButton){
        
        let objAdd = self.storyboard?.instantiateViewController(withIdentifier: "AddressPopupVC") as! AddressPopupVC
        

        objAdd.address = self.arrayData[sender.tag]["description"].string ?? ""
        objAdd.titleTop = self.arrayData[sender.tag]["title"].string ?? ""
        
        if(HelperArabic().isArabicLanguage())
        {
            if let title_ar = self.arrayData[sender.tag]["title_ar"].string
            {
                 objAdd.titleTop = title_ar
            }
            if let description = self.arrayData[sender.tag]["description_ar"].string
            {
                objAdd.address = description
            }
        }
        
        objAdd.modalPresentationStyle = .overCurrentContext
        self.present(objAdd, animated: false, completion: nil)
    }
    
    @objc func buttonViewImage(sender:UIButton){
        if let strUrl = self.arrayData[sender.tag]["image"].string
        {
            if(strUrl.count > 0)
            {
                
                let brandVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductImagePreview") as! ProductImagePreview
                self.definesPresentationContext = true
                brandVC.modalPresentationStyle = .overCurrentContext
                brandVC.currentIndex = 0
                brandVC.arrImageUrl = [String(KeyConstant.kImageBaseGiftsURL + strUrl)]
                self.present(brandVC, animated: false, completion: nil)
            }
        }
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    
}
