//
//  PaymentOptionVC.swift
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
import MFSDK
class PaymentOptionVC: UIViewController {

    @IBOutlet weak var backImgView: UIImageView!
    var selectedMethod:String?
    var paymentOd = [PaymentModel]()
    var arraySelectedAllCartItems = [JSON]()
    var dicSelectedAddress = [String:JSON]()
    var promoDetails = [String:String]()
    var redeemPointsApplied = [String:String]()

    @IBOutlet weak var labelGrandTotal: PaddingLabel!
    @IBOutlet weak var labelDeliveryCharge: PaddingLabel!
    @IBOutlet weak var labelSubTotal: PaddingLabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelCountCart: UILabel!
    
    
    @IBOutlet weak var patmentOptionsTitleLbl: PaddingLabel!
    
    @IBOutlet weak var paymentTitleLbl: PaddingLabel!
    @IBOutlet weak var showShippingAddLbl: UIButton!
    @IBOutlet weak var stepLbl: PaddingLabel!
    var arrayData = [JSON]()
    var arrayTempData = [Int]()
    var subTotal = Double()
    var address = String()
    var deliveryCharge = Double()
    var giftId = String()
    var currency = ""
    var cartIds = ""
    var grandTotal = 0.0
    var user_id = KeyConstant.sharedAppDelegate.getUserId()
    var selectedPaymentMethodId:Int?
    var paymentMethods = [MFPaymentMethod]()
    var selectedIndex:Int?
    var headerIndex:Int?
    var indexPth:IndexPath?
//    let headers = [
//        "authorization": "Bearer sk_test_XKokBfNWv6FIYuTMg5sLPjhJ",
//        "content-type": "application/json"
//    ]
    
    let headers = [
        "authorization": "Bearer sk_live_srmq974IH51KQEYABvhCwMoF",
        "content-type": "application/json"
    ]
    
    @IBOutlet weak var labelPayNow: PaddingLabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
      
        
        for ind in 0..<self.arrayData.count
        {
            self.arrayTempData.insert(0, at: self.arrayTempData.count)
        }
        currency = KeyConstant.user_Default.value(forKey: KeyConstant.kSelectedCurrency) as! String
        
        grandTotal = Double(self.subTotal + self.deliveryCharge).roundTo(places: 3)
        if(currency.uppercased() == "KWD")
        {
            self.labelSubTotal.text = "\(NSLocalizedString("MSG329", comment: "")) : \(String(format:"%.3f",self.subTotal)) \(currency)"
            self.labelDeliveryCharge.text = "\(NSLocalizedString("MSG353", comment: "")) : \(String(format:"%.3f",self.deliveryCharge)) \(currency)"
            self.labelGrandTotal.text = "\(NSLocalizedString("MSG354", comment: "")) : \(String(format:"%.3f",grandTotal)) \(currency)"        }
        else
        {
            self.labelSubTotal.text = "\(NSLocalizedString("MSG329", comment: "")) : \(String(format:"%.2f",self.subTotal)) \(currency)"
            self.labelDeliveryCharge.text = "\(NSLocalizedString("MSG353", comment: "")) : \(String(format:"%.2f",self.deliveryCharge)) \(currency)"
            self.labelGrandTotal.text = "\(NSLocalizedString("MSG354", comment: "")) : \(String(format:"%.2f",grandTotal)) \(currency)"
        }
        
      
        cartIds = ""
        for indexTemp in 0..<arraySelectedAllCartItems.count
        {
            if let arrayDataTemp = self.arraySelectedAllCartItems[indexTemp]["child"].array
                              {
                              for ind in 0..<arrayDataTemp.count
                                                   {
            if(cartIds.count == 0)
            {
                cartIds = arrayDataTemp[ind]["id"].string!
            }
            else
            {
                cartIds = cartIds + "," + arrayDataTemp[ind]["id"].string!
            }
                                }}
            }
        
        
        if(grandTotal >= 0.0)
        {
            self.labelPayNow.text = NSLocalizedString("MSG387", comment: "")
        self.getAllPaymentOptions()
        }
        else
        {
            self.labelPayNow.text = NSLocalizedString("MSG388", comment: "")

        }
        
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
        
        
        
        self.labelGrandTotal.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        self.labelPayNow.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        self.labelDeliveryCharge.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        self.labelSubTotal.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        
        self.patmentOptionsTitleLbl.font = UIFont(name: FontLocalization.Bold.strValue, size: 15.0)
        self.paymentTitleLbl.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        self.showShippingAddLbl.titleLabel?.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        self.stepLbl.font = UIFont(name: FontLocalization.Bold.strValue, size: 15.0)
        // initiatePayment
       // let totalAmt = self.grandTotal
        let invoiceValue = self.grandTotal
        
        let initiatePayment = MFInitiatePaymentRequest(invoiceAmount: Decimal(invoiceValue), currencyIso: MFCurrencyISO(rawValue: "KWD")!)
            MFPaymentRequest.shared.initiatePayment(request: initiatePayment, apiLanguage: HelperArabic().isArabicLanguage() ? .arabic : .english) { [weak self] (response) in
                switch response {
                case .success(let initiatePaymentResponse):
                   // let paymentMethods = initiatePaymentResponse.paymentMethods
                    if let paymentMethods = initiatePaymentResponse.paymentMethods, !paymentMethods.isEmpty {
                       // self?.selectedPaymentMethod = paymentMethods[0].paymentMethodId
                        self?.paymentMethods = paymentMethods
                        DispatchQueue.main.async {
                            self?.tableView.reloadData()
                        }
                    }
                case .failure(let failError):
                    print(failError)
                }
            }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.backImgView.image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate)
        self.backImgView.tintColor = .white
        if(HelperArabic().isArabicLanguage())
               {
                self.backImgView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                
               }
               else
               {
               self.backImgView.transform = CGAffineTransform(rotationAngle: 245)
               }
        
        getCartList()
        getCountryLanguage()
        
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
                if let isCountrySelected = KeyConstant.user_Default.value(forKey: KeyConstant.kSelectedCurrency) as? String
                {
                    if(isCountrySelected.count > 0)
                    {
                        for ind in 0..<arrayData.count
                        {
                            if(arrayData[ind]["currency_code"].string?.lowercased() == isCountrySelected.lowercased())
                            {
                                self.deliveryCharge = self.getPrice(dictData: arrayData[ind].dictionary!)
                                self.labelDeliveryCharge.text = "\(self.getPrice(dictData: arrayData[ind].dictionary!))"
                                self.grandTotal = Double(self.subTotal + self.deliveryCharge).roundTo(places: 3)
                                if(self.currency.uppercased() == "KWD")
                                {
                                    self.labelSubTotal.text = "\(NSLocalizedString("MSG329", comment: "")) : \(String(format:"%.3f",self.subTotal)) \(self.currency)"
                                    self.labelDeliveryCharge.text = "\(NSLocalizedString("MSG353", comment: "")) : \(String(format:"%.3f",self.deliveryCharge)) \(self.currency)"
                                    self.labelGrandTotal.text = "\(NSLocalizedString("MSG354", comment: "")) : \(String(format:"%.3f",self.grandTotal)) \(self.currency)"        }
                                else
                                {
                                    self.labelSubTotal.text = "\(NSLocalizedString("MSG329", comment: "")) : \(String(format:"%.2f",self.subTotal)) \(self.currency)"
                                    self.labelDeliveryCharge.text = "\(NSLocalizedString("MSG353", comment: "")) : \(String(format:"%.2f",self.deliveryCharge)) \(self.currency)"
                                    self.labelGrandTotal.text = "\(NSLocalizedString("MSG354", comment: "")) : \(String(format:"%.2f",self.grandTotal)) \(self.currency)"
                                }
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
    func getAllPaymentOptions()
    {
        
        MBProgress().showIndicator(view: self.view)
        
        self.arrayData.removeAll()
        self.arrayTempData.removeAll()

        WebServiceHelper.sharedInstanceAPI.hitPostAPI(urlString: KeyConstant.APIGetPaymentMode, params: ["user_id":user_id], completionHandler: { (result: [String:Any], err:Error?) in
            print(result)
            DispatchQueue.main.async {
                MBProgress().hideIndicator(view: self.view)
            }
            
            if(!(err == nil))
            {
//                KeyConstant.sharedAppDelegate.showAlertView(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: err?.localizedDescription ?? NSLocalizedString("MSG21", comment: ""))
                self.getAllPaymentOptions()
                
                return
            }
            
            let json = JSON(result)
            
            let statusCode = json["status"].string
            print(json)
            if(statusCode == "success")
            {
                self.arrayData = json["result"].arrayValue
                
                for ind in self.arrayData
                {
                    self.paymentOd.append(PaymentModel(response: ind))
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
                KeyConstant.sharedAppDelegate.showAlertView(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: message  ?? NSLocalizedString("MSG21", comment: ""))
                
              
            }
            
        })
        
        
        
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
    
    @IBAction func buttonShowAddress(_ sender: Any) {
        let objAdd = self.storyboard?.instantiateViewController(withIdentifier: "AddressPopupVC") as! AddressPopupVC
        objAdd.address = address
        objAdd.titleTop = NSLocalizedString("MSG377", comment: "")
        objAdd.modalPresentationStyle = .overCurrentContext
        self.present(objAdd, animated: false, completion: nil)
    }
    
    func actionPayButton()
    {
        var strDCharge = ""
        var subTotalTemp = ""
        var grandTotalTemp = ""
        if(currency.uppercased() == "KWD")
        {
            strDCharge = String(format:"%.3f",self.deliveryCharge)
            subTotalTemp = String(format:"%.3f",self.subTotal)
            grandTotalTemp = String(format:"%.3f",self.grandTotal)

        }
        else
        {
            strDCharge = String(format:"%.2f",self.deliveryCharge)
            subTotalTemp = String(format:"%.2f",self.subTotal)
            grandTotalTemp = String(format:"%.2f",self.grandTotal)
        }
        var param:[String:String] = ["user_id":user_id,"address_id":(dicSelectedAddress["id"]?.string)!,"cart_id":cartIds,"gift_id":giftId,"delivery_charge":strDCharge,"sub_total":subTotalTemp,"total_order_price":grandTotalTemp,"current_currency":self.currency]
        if self.headerIndex != nil{
       

       
//            params.put("user_id", sessionManager.getUserId());
//                           params.put("address_id", address_id);
//                           params.put("cart_id", cart_id);
//                           params.put("gift_id", giftId);
//                           params.put("payment_mode_id", paymentModeid);
//                           params.put("delivery_charge", shippingCharge);
//                           params.put("sub_total", sub_total);
//                           params.put("total_order_price", "" + grand_total);
//                           params.put("current_currency", sessionManager.getCurrencyCode());
//                           params.put("tap_id", tap_id);
        //,"address_id":(dicSelectedAddress["id"]?.string)!
         
            
        if(promoDetails.count > 0)
        {
            let replacingCurrent = param.merging(promoDetails) {
                (_, new) in new

            }
            param = replacingCurrent
        }
            
        if(redeemPointsApplied.count > 0)
        {
            let replacingCurrentRedeem = param.merging(redeemPointsApplied) {
                (_, new) in new

            }
            param = replacingCurrentRedeem
        }
        print("payment parmaeter: \(param)")

        if(grandTotal <= 0.0)
        {
            param["payment_status"] = "free"
            param["payment_mode_id"] = paymentOd[0].id
            self.makeCODPayment(param: param)
        }
        else
        {
        if(self.arrayData.count > 0)
        {
//            if(self.arrayTempData.contains(1) == true)
//            {
//
//
//                for ind in 0..<arrayData.count
//                {
//                    if(self.arrayTempData[ind] == 1)
//                    {
//                        param["payment_mode_id"] = arrayData[ind]["id"].string!
//
//
//                        if(arrayData[ind]["name"].string?.uppercased() == "TAP")
//                        {
//                            // KeyConstant.sharedAppDelegate.showAlertView(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: "Under development")
//
//                            self.makeTapPayment(sourceType: "src_all", param: param)
//                            return
//                        }
//                        else if(arrayData[ind]["name"].string?.uppercased() == "VISA/MASTER")
//                        {
//                            self.makeTapPayment(sourceType: "src_card", param: param)
//                            return
//                        }
//                        else if(arrayData[ind]["name"].string?.uppercased() == "KNET")
//                        {
//                            self.makeTapPayment(sourceType: "src_kw.knet", param: param)
//                            return
//                        }
//                        else if(arrayData[ind]["name"].string?.uppercased() == "CASH ON DELIVERY") || (arrayData[ind]["name"].string?.uppercased() == "PAYMENT VIA OFFLINE LINK")
//                        {
//
//                            //self.paymentFatoorahApiCall()
//                            param["payment_status"] = "pending"
//                            self.makeCODPayment(param: param)
//                            return
//                        }
//                        else
//                        {
//                           // KeyConstant.sharedAppDelegate.showAlertView(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: "Under development")
//                            self.paymentFatoorahApiCall()
//                            return
//
//                        }
//
//
//
//                    }
//                }
//
//            }
//            KeyConstant.sharedAppDelegate.showAlertView(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG231", comment: ""))
            
            
            param["payment_status"] = "pending"
            param["payment_mode_id"] = paymentOd[0].id
            self.makeCODPayment(param: param)

        }
        else
        {
            if(grandTotal <= 0.0)
            {
                param["payment_status"] = "free"
                param["payment_mode_id"] = paymentOd[0].id
                self.makeCODPayment(param: param)
            }
            else
            {
                self.setAlertSomeThingWentWrong()

            }
        }
        }
    }
        else{
            
            param["payment_mode_id"] = "\(self.selectedMethod ?? "")"
            self.paymentFatoorahApiCall(parms: param)
        }
        
        
    }
    
    func paymentFatoorahApiCall(parms:[String:String]){

        guard let paymentMethodId = self.selectedPaymentMethodId else{
            return
        }
        var parmaStore = parms
        // executePayment
        let request = MFExecutePaymentRequest(invoiceValue: Decimal(self.grandTotal), paymentMethod: paymentMethodId)
            
            // Uncomment this to add ptoducts for your invoice
            // var productList = [MFProduct]()
            // let product = MFProduct(name: "ABC", unitPrice: 1, quantity: 2)
            // productList.append(product)
            // request.invoiceItems = productList
        
        MFPaymentRequest.shared.executePayment(request: request, apiLanguage: HelperArabic().isArabicLanguage() ? .arabic : .english) { [weak self] (response,invoiceId) in
            
                switch response {
                case .success(let executePaymentResponse):
                    print(executePaymentResponse.invoiceID)
                    
                    print("executePaymentResponse.invoiceStatus:- \(executePaymentResponse.invoiceStatus ?? "")")
//                    let alertView = UIAlertController(title: NSLocalizedString("MSG31", comment: "").uppercased(), message: "", preferredStyle: .alert)
//                                       let msgFont = [NSAttributedString.Key.font: UIFont(name: FontLocalization.medium.strValue, size: 15.0)!]
//                                       let msgAttrString = NSMutableAttributedString(string: NSLocalizedString("MSG233", comment: ""), attributes: msgFont)
//                                       alertView.setValue(msgAttrString, forKey: "attributedMessage")
//                                       let alertAction = UIAlertAction(title: NSLocalizedString("MSG18", comment: ""), style: .default) { (alert) in
                                        parmaStore["tap_id"] = "\(executePaymentResponse.invoiceID ?? 0)"
//
                                           

                    
                    
                    
////                                           KeyConstant.sharedAppDelegate.setRoot()
//
//                                       }
//                                       alertAction.setValue(AppColors.SelcetedColor, forKey: "titleTextColor")
//
//                                       alertView.addAction(alertAction)
//                    self?.present(alertView, animated: true, completion: nil)
                    self?.makeUserPayment(param: parmaStore)
                                       
                    
                case .failure(let failError):
//                    parmaStore["tap_id"] = "175988590"
//
//                    self?.makeUserPayment(param: parmaStore)
                    print(failError.errorDescription)
                    print(failError.localizedDescription)
                    
                    let alertView = UIAlertController(title: NSLocalizedString("MSG31", comment: "").uppercased(), message: "", preferredStyle: .alert)
                                       let msgFont = [NSAttributedString.Key.font: UIFont(name: FontLocalization.medium.strValue, size: 15.0)!]
                                       let msgAttrString = NSMutableAttributedString(string: failError.errorDescription, attributes: msgFont)
                                       alertView.setValue(msgAttrString, forKey: "attributedMessage")
                                       let alertAction = UIAlertAction(title: NSLocalizedString("MSG18", comment: ""), style: .default) { (alert) in
                                           
                                          // KeyConstant.sharedAppDelegate.setRoot()

                                          
                                           
                                       }
                                       alertAction.setValue(AppColors.SelcetedColor, forKey: "titleTextColor")

                                       alertView.addAction(alertAction)
                    self?.present(alertView, animated: true, completion: nil)
                                       
                }
            }
        
        
     
    }
    
    
    
    @IBAction func buttonPayNow(_ sender: Any) {
        
     
        if self.selectedIndex != nil || self.headerIndex != nil{
            self.recheckCartItemes()
        }else{
            KeyConstant.sharedAppDelegate.showAlertView(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG231", comment: ""))
        }
        
    }
    
  
    
    func makeTapPayment(sourceType:String,param:[String:String])
    {
        MBProgress().showIndicator(view: self.view)
        //            "amount": Int(self.subTotal + self.deliveryCharge),
        //            "amount":1.0,
      
        var grandTotal = ""
        
        if(currency.uppercased() == "KWD")
        {

            grandTotal = String(format:"%.3f",self.grandTotal)
            
        }
        else
        {
        
            grandTotal = String(format:"%.2f",self.grandTotal)
        }
       

        let parameters = [
            "amount":grandTotal,
            "currency": currency,
            "threeDSecure": true,
            "save_card": false,
            "description": "Egames Store Payment",
            "statement_descriptor": "Egames",
            "receipt": [
                "email": true,
                "sms": false
            ],
            "customer": [
                "first_name": KeyConstant.user_Default.value(forKey: KeyConstant.kuserName) as! String,
                "email": KeyConstant.user_Default.value(forKey: KeyConstant.kuserEmail) as! String
            ],
            "source": ["id": sourceType],
            "post":["url": KeyConstant.kBaseDomain + "mobile/payment_by_tap/post"],
            "redirect": ["url": KeyConstant.kBaseDomain + "mobile/payment_by_tap/response"]
            ] as [String : Any]
        print(parameters)

        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
        
        // create post request
        let url = URL(string: "https://api.tap.company/v2/charges")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers

        // insert json data to the request
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                KeyConstant.sharedAppDelegate.showAlertView(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: error?.localizedDescription ?? NSLocalizedString("MSG21", comment: ""))
                DispatchQueue.main.async {

                MBProgress().hideIndicator(view: self.view)
                }
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
           
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
                DispatchQueue.main.async {

                    MBProgress().hideIndicator(view: self.view)
                    
                if let dicTrassactionURL = responseJSON["transaction"] as? [String: Any]
                {
                    if let trassactionURL = dicTrassactionURL["url"] as? String
                    {
                        if(trassactionURL.count > 0)
                        {
                        let objTap = self.storyboard?.instantiateViewController(withIdentifier: "TapWebView") as! TapWebView
                        objTap.urlString = trassactionURL
                           objTap.param =  param

                        self.present(objTap, animated: false, completion: nil)
                            return
                        }
                    }
                   
                        KeyConstant.sharedAppDelegate.showAlertView(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG237", comment: ""))
                        
                    
                    
                }
                else
                {
                    KeyConstant.sharedAppDelegate.showAlertView(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG237", comment: ""))
                    
                    }
            }
           

        }
            
            
        }
        
        task.resume()
     
        
       
    }
    
    func makeCODPayment(param:[String:String])
    {
       
       print(param)
        
            MBProgress().showIndicator(view: self.view)
            
            WebServiceHelper.sharedInstanceAPI.hitPostAPI(urlString: KeyConstant.APIPayment_by_cod, params: param, completionHandler: { (result: [String:Any], err:Error?) in
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
                    
                    
                    let alertView = UIAlertController(title: NSLocalizedString("MSG31", comment: "").uppercased(), message: "", preferredStyle: .alert)
                    let msgFont = [NSAttributedString.Key.font: UIFont(name: FontLocalization.medium.strValue, size: 15.0)!]
                    let msgAttrString = NSMutableAttributedString(string: NSLocalizedString("MSG233", comment: ""), attributes: msgFont)
                    alertView.setValue(msgAttrString, forKey: "attributedMessage")
                    let alertAction = UIAlertAction(title: NSLocalizedString("MSG18", comment: ""), style: .default) { (alert) in
                        
                        KeyConstant.sharedAppDelegate.setRoot()

                        
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
                    KeyConstant.sharedAppDelegate.showAlertView(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: message ?? NSLocalizedString("MSG21", comment: ""))
                }
                
            })
            
            
            
        
        
    }
    
    func makeUserPayment(param:[String:String])
    {
       
       print(param)
        
            MBProgress().showIndicator(view: self.view)
            
            WebServiceHelper.sharedInstanceAPI.hitPostAPI(urlString: KeyConstant.payment_by_tap, params: param, completionHandler: { (result: [String:Any], err:Error?) in
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
                   
                    let alertView = UIAlertController(title: NSLocalizedString("MSG31", comment: "").uppercased(), message: "", preferredStyle: .alert)
                    let msgFont = [NSAttributedString.Key.font: UIFont(name: FontLocalization.medium.strValue, size: 15.0)!]
                    let msgAttrString = NSMutableAttributedString(string: NSLocalizedString("MSG233", comment: ""), attributes: msgFont)
                    alertView.setValue(msgAttrString, forKey: "attributedMessage")
                    let alertAction = UIAlertAction(title: NSLocalizedString("MSG18", comment: ""), style: .default) { (alert) in
                        
                        KeyConstant.sharedAppDelegate.setRoot()

                       
                        
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
                    KeyConstant.sharedAppDelegate.showAlertView(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: message ?? NSLocalizedString("MSG21", comment: ""))
                }
                
            })
            
            
            
        
        
    }
    
    
    @objc func rightSwip(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            self.buttonBack(UIButton())
        }
    }
    
    
    func recheckCartItemes()
    {
        MBProgress().showIndicator(view: self.view)
        
         CartViewModel().viewCartList(vc: self, param: ["user_id":KeyConstant.sharedAppDelegate.getUserId()], completionHandler: { (result:[JSON], totalCount:String ,error:Error?) in
            
            self.labelCountCart.text = ""
        
            DispatchQueue.main.async {
                
                MBProgress().hideIndicator(view: self.view)
            }
            if(error != nil)
            {
                self.recheckCartItemes()
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
                                        }}
                }
                print(self.arraySelectedAllCartItems)
                print(result)

                if(!(self.arraySelectedAllCartItems.count == result.count))
                {
                    self.setAlertSomeThingWentWrong()
                    return
                }
                for indexTemp in 0..<self.arraySelectedAllCartItems.count
                {
                    
                    if let arrayDataTemp = self.arraySelectedAllCartItems[indexTemp]["child"].array
                    {
                    for ind in 0..<arrayDataTemp.count
                    {
                       
                    let myID = arrayDataTemp[ind]["id"].string ?? ""
                        let arrayTempQ = result[indexTemp]["child"].array

                    if(!(arrayTempQ?[ind]["id"].string == myID))
                    {
                        self.setAlertSomeThingWentWrong()
                        return
                        
                    }
                    
                    let totalMyPrice = self.getTotalPriceEachCart(dictData: arrayDataTemp[ind].dictionary ?? [:])
                    
                    let totalCartPrice = self.getTotalPriceEachCart(dictData: self.arraySelectedAllCartItems[indexTemp]["child"][ind].dictionary ?? [:])

                    if(!(totalMyPrice == totalCartPrice))
                    {
                        self.setAlertSomeThingWentWrong()
                        return
                    }
                    }
                    }
                }
                
                print("done")
                self.actionPayButton()
                
                
            }
            else
            {
                self.setAlertSomeThingWentWrong()
                return

            }
            
        } )
    }
    
    
    func setAlerOutOfStock()
    {
        let alertView = UIAlertController(title: NSLocalizedString("MSG31", comment: "").uppercased(), message: "", preferredStyle: .alert)
        let msgFont = [NSAttributedString.Key.font: UIFont(name: FontLocalization.medium.strValue, size: 15.0)!]
        let msgAttrString = NSMutableAttributedString(string: NSLocalizedString("MSG322", comment: ""), attributes: msgFont)
        alertView.setValue(msgAttrString, forKey: "attributedMessage")
        
        let alertAction = UIAlertAction(title: NSLocalizedString("MSG18", comment: ""), style: .default) { (alert) in
            KeyConstant.sharedAppDelegate.setRoot()

        }
        alertAction.setValue(AppColors.SelcetedColor, forKey: "titleTextColor")
        alertView.addAction(alertAction)
        self.present(alertView, animated: true, completion: nil)
        
    }
    func setAlertSomeThingWentWrong()
    {
        let alertView = UIAlertController(title: NSLocalizedString("MSG31", comment: "").uppercased(), message: "", preferredStyle: .alert)
        let msgFont = [NSAttributedString.Key.font: UIFont(name: FontLocalization.medium.strValue, size: 15.0)!]
        let msgAttrString = NSMutableAttributedString(string: NSLocalizedString("MSG404", comment: ""), attributes: msgFont)
        alertView.setValue(msgAttrString, forKey: "attributedMessage")
        
        let alertAction = UIAlertAction(title: NSLocalizedString("MSG18", comment: ""), style: .default) { (alert) in
            KeyConstant.sharedAppDelegate.setRoot()
        }
        alertAction.setValue(AppColors.SelcetedColor, forKey: "titleTextColor")
        alertView.addAction(alertAction)
        self.present(alertView, animated: true, completion: nil)
        
    }
    
    func getTotalPriceEachCart(dictData:[String:JSON]) -> String
    {
        var price = ""
        if let priceDouble = dictData["total"]?.double
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
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    @IBAction func buttonBack(_ sender: Any) {
        
        self.dismiss(animated: false, completion: nil)
        
    }
    @IBAction func buttonCartList(_ sender: Any) {
        
//        let myCartVC = self.storyboard?.instantiateViewController(withIdentifier: "MyCartVC") as! MyCartVC
//        self.present(myCartVC, animated: false, completion: nil)
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
extension PaymentOptionVC:UITableViewDelegate, UITableViewDataSource,radioBtnDelegate
{
    func radioBtnclicked(indexPth: IndexPath) {
                if indexPth.section == 0{
                    self.headerIndex = indexPth.row
            self.selectedIndex = nil

        }else{
            self.selectedIndex = indexPth.row
            self.headerIndex = nil
        }
        if self.selectedIndex != nil{
            
            let methodId = self.paymentMethods[indexPth.row].paymentMethodId
            for i in paymentOd {
                if self.paymentMethods[indexPth.row].paymentMethodAr == i.name_ar {
                    self.selectedMethod = i.id
            }
//            self.selectedMethod = self.paymentMethods[indexPth.row].paymentMethodAr
            
        }
            
            selectedPaymentMethodId = methodId
        }
        
        self.tableView.reloadData()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else{
            return self.paymentMethods.count
        }
        //arrayData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentOptionTVCell") as! PaymentOptionTVCell
        //arrayData[indexPath.row]["name"].string
        
        if indexPath.section == 0{
            //http://139.59.93.33/uploads/logo/cash.png
                    if(HelperArabic().isArabicLanguage())
                    {
            //            if let title_ar = self.arrayData[indexPath.row]["name_ar"].string
            //            {
            //                if(title_ar.count > 0)
            //                {
            //                cell.labelTitle.text = title_ar
            //                }
            //            }
                      cell.labelTitle.text = "CASH ON DELIVERY"
                    }else{
                      cell.labelTitle.text = "CASH ON DELIVERY"
                    }
            
            
                    let strUrl = "http://139.59.93.33/uploads/logo/cash.png"
                    let urlString = strUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    
                    
                    cell.imagePaytype.kf.setImage(with: URL(string: urlString!)!, placeholder: UIImage.init(named: "noImage"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: { (downloadImage, error, cacheType, url) in
                        if(downloadImage != nil)
                        {
                            cell.imagePaytype.image = downloadImage!
                        }
                    })
           
            
            
        }else{
                    if(HelperArabic().isArabicLanguage())
                    {
         
                      cell.labelTitle.text = self.paymentMethods[indexPath.row].paymentMethodAr
                    }else{
                        cell.labelTitle.text = self.paymentMethods[indexPath.row].paymentMethodEn
                    }
            
            if let strUrl = self.paymentMethods[indexPath.row].imageUrl
            {
                if(strUrl.count > 0)
                {
                    let urlString = strUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    
                    
                    cell.imagePaytype.kf.setImage(with: URL(string: urlString!)!, placeholder: UIImage.init(named: "noImage"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: { (downloadImage, error, cacheType, url) in
                        if(downloadImage != nil)
                        {
                            cell.imagePaytype.image = downloadImage!
                        }
                    })
                }
                else
                {
                    cell.imagePaytype.image = UIImage(named: "noImage")
                    
                }
            }
            else
            {
                cell.imagePaytype.image = UIImage(named: "noImage")
                
            }
        }

        
        cell.delegate = self
        cell.buttonSelection.tag = indexPath.row
        cell.indexPth = indexPath
       
       // cell.buttonSelection.addTarget(self, action: #selector(buttonSelection), for: .touchUpInside)
        
        if indexPath.section == 0{
            if(indexPath.row == headerIndex)
            {
                cell.buttonSelection.setImage(UIImage(named: "slect_100x100")?.withRenderingMode(.alwaysTemplate), for: .normal)
                cell.buttonSelection.tintColor = .white//AppColors.SelcetedColor
            }
            else
            {
                cell.buttonSelection.setImage(UIImage(named: "de_select_100x100")?.withRenderingMode(.alwaysTemplate), for: .normal)
                cell.buttonSelection.tintColor = .white//AppColors.SelcetedColor
            }
        }else{
            if indexPath.row == selectedIndex
            {
                cell.buttonSelection.setImage(UIImage(named: "slect_100x100")?.withRenderingMode(.alwaysTemplate), for: .normal)
                cell.buttonSelection.tintColor = .white//AppColors.SelcetedColor
            }
            else
            {
                cell.buttonSelection.setImage(UIImage(named: "de_select_100x100")?.withRenderingMode(.alwaysTemplate), for: .normal)
                cell.buttonSelection.tintColor = .white//AppColors.SelcetedColor
            }
        }
        
        
        
        

        return cell
            
        
    }
    
    @objc func buttonSelection(sender:UIButton){
        
        if self.indexPth?.section == 0{
            self.headerIndex = sender.tag
            self.selectedIndex = nil

        }else{
            self.selectedIndex = sender.tag
            self.headerIndex = nil
        }
        if self.selectedIndex != nil{
            
            let methodId = self.paymentMethods[sender.tag].paymentMethodId
            selectedPaymentMethodId = methodId
        }
        
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return  40

        //return  UITableView.automaticDimension
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
    }
  
}

extension Double {
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(format: "%.2f", self)
    }
}
