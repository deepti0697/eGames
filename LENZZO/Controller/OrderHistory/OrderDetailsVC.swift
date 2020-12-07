//
//  OrderDetailsVC.swift
//  LENZZO
//
//  Created by Apple on 9/30/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import UIKit
import SwiftyJSON

class OrderDetailsVC: UIViewController {
    
    @IBOutlet weak var leftTableView: UITableView!
    
    @IBOutlet weak var doneBtn: UIButton!
    
    @IBOutlet weak var orderDetailTitleLbl: PaddingLabel!
    var dicData = [String:JSON]()
    var countData = 0
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
        //        leftTableView.tableFooterView = UIView()
        leftTableView.rowHeight = UITableView.automaticDimension
        leftTableView.estimatedRowHeight = UITableView.automaticDimension
        if(dicData.count > 0)
        {
            countData = 12
        }
        
        self.orderDetailTitleLbl.font = UIFont(name: FontLocalization.Bold.strValue, size: 15.0)
        self.doneBtn.titleLabel?.font = UIFont(name: FontLocalization.Bold.strValue, size: 15.0)
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func buttonDone(_ sender: Any) {
        self.dismiss(animated: false, completion:nil)
        
    }
    
    @IBAction func buttonCancel(_ sender: Any) {
        
        self.dismiss(animated: false, completion: nil)
    }
    
    
    @objc func rightSwip(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            self.buttonCancel(UIButton())
            
        }
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
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
extension OrderDetailsVC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return countData
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PowerTVCell") as! PowerTVCell
        switch(indexPath.row)
        {
        case 0 :cell.labelPower.text = "\(NSLocalizedString("MSG288", comment: "")) \(dicData["product_name"]?.string ?? "")"
        
        if(HelperArabic().isArabicLanguage())
        {
            if let title_ar =  dicData["product_name_ar"]?.string
            {
                cell.labelPower.text  = "\(NSLocalizedString("MSG288", comment: "")) \(title_ar)"
            }
        }
        
        
        if let gift_name = dicData["gift_name"]?.string
        {
            var giftName = gift_name
            if(gift_name.count > 0)
            {
                
                giftName = gift_name
            }
            if(HelperArabic().isArabicLanguage())
            {
                if let gift_name_ar = dicData["gift_name_ar"]?.string
                {
                    if(gift_name_ar.count > 0)
                    {
                        giftName = gift_name_ar
                    }
                }
            }
            
            cell.labelPower.text = cell.labelPower.text! + "\n" + "\(NSLocalizedString("MSG381", comment: "")) \(giftName)"
            
        }
        
        
            break
        case 1 :cell.labelPower.text = "\(NSLocalizedString("MSG289", comment: "")) \(self.getOrderId(dictData:dicData) )"
            break
            
        case 2 :
            
            var priceTemp = ""
            let currency = dicData["current_currency"]?.string ?? ""
            if(currency.uppercased() == "KWD")
            {
                priceTemp = String(format:"%.3f",Double(self.getPrice(dictData:dicData)) ?? 0.0)
            }
            else
            {
                priceTemp = String(format:"%.2f",Double(self.getPrice(dictData:dicData)) ?? 0.0)
                
            }
            cell.labelPower.text = "\(NSLocalizedString("MSG290", comment: "")) \(priceTemp) \(dicData["current_currency"]?.string ?? "")"
            
            if let discount = dicData["display_discount"]?.string
            {
                if(Double(discount) ?? 0.00 > 0.00)
                {
                    var priceTemp1 = ""
                    if(currency.uppercased() == "KWD")
                    {
                        priceTemp1 = String(format:"%.3f",Double(discount)?.roundTo(places: 3) ?? 0.0)
                    }
                    else
                    {
                        priceTemp1 = String(format:"%.2f",Double(discount)?.roundTo(places: 2) ?? 0.0)
                        
                    }
                    cell.labelPower.text = cell.labelPower.text! + "\n" + "\(NSLocalizedString("MSG291", comment: "")) \(priceTemp1) \(dicData["current_currency"]?.string ?? "")"
                }
            }
            
            
            
            break
        case 3 :
            var priceTemp = ""
            let currency = dicData["current_currency"]?.string ?? ""
            if(currency.uppercased() == "KWD")
            {
                priceTemp = String(format:"%.3f",Double(self.getDeliveryPrice(dictData:dicData)) ?? 0.0)
            }
            else
            {
                priceTemp = String(format:"%.2f",Double(self.getDeliveryPrice(dictData:dicData)) ?? 0.0)
                
            }
            
            cell.labelPower.text = "\(NSLocalizedString("MSG292", comment: "")) \(priceTemp) \(dicData["current_currency"]?.string ?? "")"
            break
        case 4 :
            var priceTemp = ""
            let currency = dicData["current_currency"]?.string ?? ""
            if(currency.uppercased() == "KWD")
            {
                priceTemp = String(format:"%.3f",Double(self.getGrandPrice(dictData:dicData)) ?? 0.0)
            }
            else
            {
                priceTemp = String(format:"%.2f",Double(self.getGrandPrice(dictData:dicData)) ?? 0.0)
                
            }
            
            cell.labelPower.text = "\(NSLocalizedString("MSG295", comment: "")) \(priceTemp) \(dicData["current_currency"]?.string ?? "")"
            if let coupon_code = dicData["coupon_code"]?.string
            {
                if(coupon_code.count >  0)
                {
                    var coupon_price = 0.0
                    var coupon_priceTemp = ""
                    
                    if(String(dicData["current_currency"]?.string ?? "").uppercased() == "KWD")
                    {
                        coupon_price = Double(dicData["coupon_price"]?.string ?? "0.0")?.roundTo(places: 3) ?? 0.000
                        coupon_priceTemp = String(format:"%.3f",coupon_price)
                        
                    }
                    else
                    {
                        coupon_price = Double(dicData["coupon_price"]?.string ?? "0.0")?.roundTo(places: 2) ?? 0.00
                        coupon_priceTemp = String(format:"%.2f",coupon_price)
                        
                    }
                    
                    
                    let couponC =  "\n" + "\(NSLocalizedString("MSG367", comment: ""))" + " \(coupon_code)"
                    cell.labelPower.text = cell.labelPower.text! + "\n" + "\(NSLocalizedString("MSG332", comment: "")): \(String(coupon_priceTemp)) \(dicData["current_currency"]?.string ?? "")" + couponC
                }
            }
            
            break
        case 5 :
            
            cell.labelPower.text = "\(NSLocalizedString("MSG293", comment: "")) \(dicData["quantity"]?.string ?? "")"
            if let free_quantity = dicData["free_quantity"]?.string
            {
                if(Int(free_quantity) ?? 0 > 0)
                {
                    cell.labelPower.text = cell.labelPower.text! + " " + "( \(NSLocalizedString("MSG294", comment: "")) \(free_quantity) )"
                }
            }
            
            
            
            if let leftQTY = dicData["quantity_left"]?.string
            {
                if(leftQTY.count > 0)
                {
                    if(Int(leftQTY)! > 0)
                    {
                        cell.labelPower.text = cell.labelPower.text! + "\n" + "\(NSLocalizedString("MSG417", comment: "")): \(leftQTY)"
                    }
                }
                
            }
            
            if let quantity_right = dicData["quantity_right"]?.string
            {
                if(quantity_right.count > 0)
                {
                    if(Int(quantity_right)! > 0)
                    {
                        cell.labelPower.text = cell.labelPower.text! + "\n" + "\(NSLocalizedString("MSG418", comment: "")): \(quantity_right)"
                    }
                }
                
            }
            
            
            if let offer_name = dicData["offer_name"]?.string
            {
                if(offer_name.count ?? 0 > 0)
                {
                    cell.labelPower.text = cell.labelPower.text! + "\n" + "\(NSLocalizedString("MSG366", comment: "")) \(offer_name)"
                }
            }
            
            
            break
            
            
            //        case 6 :cell.labelPower.text = "\(NSLocalizedString("MSG296", comment: "")) \(dicData["shade"]?.string ?? "")"
            //            break
            
        case 6 :cell.labelPower.text = "\(NSLocalizedString("MSG297", comment: "")) \(dicData["left_eye_power"]?.string ?? NSLocalizedString("MSG299", comment: "")) \n\(NSLocalizedString("MSG298", comment: "")) \(dicData["right_eye_power"]?.string ?? NSLocalizedString("MSG299", comment: ""))"
        
            break
            
            
        case 7 :cell.labelPower.text = "\(NSLocalizedString("MSG300", comment: "")) \(dicData["payment_mode_name"]?.string ?? "")"
        if(HelperArabic().isArabicLanguage())
        {
            if let title_ar =  dicData["payment_mode_name_ar"]?.string
            {
                
                cell.labelPower.text  = "\(NSLocalizedString("MSG300", comment: "")) \(title_ar))"
            }
        }
        
        if let loyalityPoint = dicData["loyality_point"]?.string
        {
            if(loyalityPoint.count ?? 0 > 0)
            {
                cell.labelPower.text = cell.labelPower.text! + "\n" + "\(NSLocalizedString("MSG390", comment: "")): \(loyalityPoint)"
            }
        }
        if let earnloyalityPoint = dicData["earn_loyality_point"]?.string
        {
            if(earnloyalityPoint.count ?? 0 > 0)
            {
                if let earnloyalityPointStatus = dicData["earn_loyality_point_status"]?.string
                {
                    if(earnloyalityPointStatus == "0")
                    {
                        
                        cell.labelPower.text = cell.labelPower.text! + "\n" + "\(String(format:"\(NSLocalizedString("MSG393", comment: ""))",earnloyalityPoint))"
                        
                    }
                    else
                    {
                        cell.labelPower.text = cell.labelPower.text! + "\n" + "\(NSLocalizedString("MSG391", comment: "")): \(earnloyalityPoint)"
                        
                    }
                    
                }
                
            }
            }
            //        if let earn_loyality_point_price = dicData["earn_loyality_point_price"]?.string
            //        {
            //            if(earn_loyality_point_price.count ?? 0 > 0)
            //            {
            //                cell.labelPower.text = cell.labelPower.text! + "\n" + "\(NSLocalizedString("MSG393", comment: "")): \(earn_loyality_point_price) \(dicData["current_currency"]?.string ?? "")"
            //            }
            //        }
            //        if let loyality_point_price = dicData["loyality_point_price"]?.string
            //        {
            //            if(loyality_point_price.count ?? 0 > 0)
            //            {
            //
            //                cell.labelPower.text = cell.labelPower.text! + "\n" + "\(NSLocalizedString("MSG392", comment: "")): \(loyality_point_price) \(dicData["current_currency"]?.string ?? "")"
            //            }
            //        }
        //            break
        case 8 :
            
            
            cell.labelPower.text = self.getAddress(dicData: dicData)
            break
            
        case 9 :cell.labelPower.text = "\(NSLocalizedString("MSG314", comment: "")) \(dicData["created_at"]?.string ?? "")"
            break
        case 10 :cell.labelPower.text = NSLocalizedString("MSG403", comment: "") + ": " + self.getStatus(dictData: dicData)
            break
        case 11 :cell.labelPower.text = self.getPaymentStatus(dictData: dicData)
        cell.labelPower.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
            break
            
        default:
            cell.labelPower.text = ""
            break
            
        }
        
        cell.labelPower.attributedText = self.getBoldTitle(stringAddress:   cell.labelPower.text ?? "")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func getPrice(dictData:[String:JSON]) -> String
    {
        var price = ""
        let currency = dicData["current_currency"]?.string ?? ""
        if let priceDouble = dictData["display_total"]?.double
        {
            if(currency.uppercased() == "KWD")
            {
                price = String(format:"%.3f", priceDouble)
                
            }
            else
            {
                price = String(format:"%.2f", priceDouble)
                
            }
        }
        else if let priceInt = dictData["display_total"]?.int
        {
            price = String(format:"%d",priceInt)
        }
        else
        {
            var strPrice = dictData["display_total"]?.string ?? "0.0"
            strPrice = strPrice.replacingOccurrences(of: ",", with: "")
            
            if(currency.uppercased() == "KWD")
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
    
    func getGrandPrice(dictData:[String:JSON]) -> String
    {
        var price = ""
        let currency = dicData["current_currency"]?.string ?? ""
        
        if let priceDouble = dictData["total_order_price"]?.double
        {
            if(currency.uppercased() == "KWD")
            {
                price = String(format:"%.3f", priceDouble)
                
            }
            else
            {
                price = String(format:"%.2f", priceDouble)
                
            }
        }
        else if let priceInt = dictData["total_order_price"]?.int
        {
            price = String(format:"%d",priceInt)
        }
        else
        {
            var strPrice = dictData["total_order_price"]?.string ?? "0.0"
            strPrice = strPrice.replacingOccurrences(of: ",", with: "")
            if(currency.uppercased() == "KWD")
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
    
    func getDeliveryPrice(dictData:[String:JSON]) -> String
    {
        var price = ""
        let currency = dicData["current_currency"]?.string ?? ""
        
        if let priceDouble = dictData["delivery_charge"]?.double
        {
            if(currency.uppercased() == "KWD")
            {
                price = String(format:"%.3f", priceDouble)
                
            }
            else
            {
                price = String(format:"%.2f", priceDouble)
                
            }        }
        else if let priceInt = dictData["delivery_charge"]?.int
        {
            price = String(format:"%d",priceInt)
        }
        else
        {
            var strPrice = dictData["delivery_charge"]?.string ?? "0.0"
            strPrice = strPrice.replacingOccurrences(of: ",", with: "")
            if(currency.uppercased() == "KWD")
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
    func getOrderId(dictData:[String:JSON]) -> String
    {
        var pid = ""
        
        if let priceInt = dictData["product_order_id"]?.int
        {
            pid = String(format:"%d",priceInt)
            return pid
            
        }
        
        pid = dictData["product_order_id"]?.string ?? ""
        
        return pid
    }
    
    func getStatus(dictData:[String:JSON]) -> String
    {
        if let status = dictData["order_status"]?.string
        {
            if(status.uppercased() == "PENDING" )
            {
                return NSLocalizedString("MSG395", comment: "")
                
            }
            if(status.uppercased() == "FAILED" )
            {
                return NSLocalizedString("MSG396", comment: "")
                
            }
            if(status.uppercased() == "PROCESSING" )
            {
                return NSLocalizedString("MSG397", comment: "")
                
            }
            if(status.uppercased() == "COMPLETED" )
            {
                return NSLocalizedString("MSG398", comment: "")
                
            }
            if(status.uppercased() == "ON-HOLD" )
            {
                return NSLocalizedString("MSG399", comment: "")
                
            }
            else if(status == "CANCELLED" )
            {
                return NSLocalizedString("MSG400", comment: "")
                
            }
            else if(status == "REFUNDED" )
            {
                return NSLocalizedString("MSG401", comment: "")
                
            }
        }
        return NSLocalizedString("MSG396", comment: "")
        
        
    }
    func getPaymentStatus(dictData:[String:JSON]) -> String
    {
        let status = NSLocalizedString("MSG285", comment: "")
        
        if let status = dictData["payment_status"]?.string
        {
            if(status.uppercased() == "CAPTURED" || status.uppercased() == "APPROVED" || status.uppercased() == "SUCCESS")
            {
                return NSLocalizedString("MSG287", comment: "")
            }
            else if(status.uppercased() == "PENDING")
            {
                return NSLocalizedString("MSG286", comment: "")
            }
            else if(status.uppercased() == "FREE")
            {
                return NSLocalizedString("MSG389", comment: "")
            }
        }
        return status
        
    }
    func getAddress(dicData:[String:JSON])->String
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
            strAddress = strAddress + "\n\(NSLocalizedString("MSG313", comment: ""))\(String(format:"%@",(dicData["currrent_location"]?.string)!))"
        }
        return strAddress
    }
    
    func getBoldTitle(stringAddress:String)->NSAttributedString
    {
        
        
        let stringBold = [NSLocalizedString("MSG288", comment: ""),NSLocalizedString("MSG381", comment: ""),NSLocalizedString("MSG289", comment: ""),NSLocalizedString("MSG290", comment: ""),NSLocalizedString("MSG291", comment: ""),NSLocalizedString("MSG292", comment: ""),NSLocalizedString("MSG295", comment: ""),NSLocalizedString("MSG367", comment: ""),NSLocalizedString("MSG332", comment: ""),NSLocalizedString("MSG293", comment: ""),NSLocalizedString("MSG294", comment: ""),NSLocalizedString("MSG366", comment: ""),NSLocalizedString("MSG297", comment: ""),NSLocalizedString("MSG299", comment: ""),NSLocalizedString("MSG298", comment: ""),NSLocalizedString("MSG299", comment: ""),NSLocalizedString("MSG300", comment: ""),NSLocalizedString("MSG390", comment: ""),NSLocalizedString("MSG393", comment: ""),NSLocalizedString("MSG391", comment: ""),NSLocalizedString("MSG314", comment: ""),NSLocalizedString("MSG403", comment: ""),NSLocalizedString("MSG285", comment: ""),NSLocalizedString("MSG287", comment: ""),NSLocalizedString("MSG286", comment: ""),NSLocalizedString("MSG389", comment: ""),NSLocalizedString("MSG302", comment: ""),NSLocalizedString("MSG303", comment: ""),NSLocalizedString("MSG304", comment: ""),NSLocalizedString("MSG305", comment: ""),NSLocalizedString("MSG306", comment: ""),NSLocalizedString("MSG307", comment: ""),NSLocalizedString("MSG308", comment: ""),NSLocalizedString("MSG309", comment: ""),NSLocalizedString("MSG310", comment: ""),NSLocalizedString("MSG311", comment: ""),NSLocalizedString("MSG312", comment: ""),NSLocalizedString("MSG313", comment: ""),NSLocalizedString("MSG417", comment: ""),NSLocalizedString("MSG418", comment: "")]
        
        return stringAddress.withBoldTextParagraphLineSpace(arraytext: stringBold, font: UIFont.init(name: FontLocalization.SemiBold.strValue, size: 13.0),boldFont:UIFont.init(name: FontLocalization.Bold.strValue, size: 13.0))
        
        
    }
}
