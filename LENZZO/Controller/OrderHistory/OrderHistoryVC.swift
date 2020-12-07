//
//  OrderHistoryVC.swift
//  LENZZO
//
//  Created by Apple on 9/30/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import UIKit
import Kingfisher
import AlamofireImage
import SwiftyJSON
import SafariServices

class OrderHistoryVC: UIViewController,SFSafariViewControllerDelegate ,DelegateOrderUpdate{
    
    
    @IBOutlet weak var labelOrderTitle: PaddingLabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelEmptyMessage: UILabel!
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var myOrderTitleLbl: PaddingLabel!
    @IBOutlet weak var labelCountCart: UILabel!
    let attributeString = NSMutableAttributedString(string: NSLocalizedString("MSG357", comment: ""),attributes: [NSAttributedString.Key.font : UIFont.init(name: FontLocalization.medium.strValue, size: 14.0),NSAttributedString.Key.foregroundColor :AppColors.SelcetedColor])
    var arrayData = [JSON]()
    
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
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        self.labelCountCart.text = ""
        // Do any) additional setup after loading the view.
        self.labelOrderTitle.font = UIFont(name: FontLocalization.Bold.strValue, size: 15.0)
        self.labelEmptyMessage.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        self.myOrderTitleLbl.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(HelperArabic().isArabicLanguage())
        {
         self.backBtn.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }
        else
        {
        self.backBtn.transform = CGAffineTransform(rotationAngle: 245)
        }
        getCartList()
        getAllOrders()
    }
    
    func getAllOrders()
    {
        self.arrayData.removeAll()
        self.labelOrderTitle.text = ""
        CartViewModel().myOrderList(vc: self, param: ["user_id":KeyConstant.sharedAppDelegate.getUserId()], completionHandler: { (result:[JSON], error:Error?) in
            if(!(error == nil))
            {
                self.getAllOrders()
                return
            }
            self.arrayData = result
            if(self.arrayData.count == 1)
            {
                self.labelOrderTitle.text = NSLocalizedString("MSG280", comment: "") + " (" + String(self.arrayData.count) + ")"
                
            }
            else
            {
                self.labelOrderTitle.text = NSLocalizedString("MSG281", comment: "") + " (" + String(self.arrayData.count) + ")"
                
            }
            self.tableView.reloadData()
            
        } )
        
    }
    
    func orderUpdate()
    {
        getAllOrders()
    }
    func getCartList()
    {
        self.labelCountCart.text = ""
        
        CartViewModel().viewCartList(vc: self, param: ["user_id":KeyConstant.sharedAppDelegate.getUserId()], completionHandler: { (result:[JSON], totalCount:String ,error:Error?) in
            
            self.labelCountCart.text = ""
            
            if(!(error == nil))
            {
               // self.getCartList()
                
                KeyConstant.sharedAppDelegate.showAlertView(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString:error?.localizedDescription ?? NSLocalizedString("MSG21", comment: ""))
                return
            }
            
            if(result.count > 0)
            {
                self.labelCountCart.text = totalCount
            }
        } )
        
    }
    
    @IBAction func buttonBackAction(_ sender: Any) {
        
        if(self.navigationController != nil)
        {
            self.navigationController?.popViewController(animated: true)
        }
        else
        {
            
            self.dismiss(animated: false, completion: nil)
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
    
    
    @IBAction func buttonCartList(_ sender: Any) {
        
        let myCartVC = self.storyboard?.instantiateViewController(withIdentifier: "MyCartVC") as! MyCartVC
        self.present(myCartVC, animated: false, completion: nil)
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
extension OrderHistoryVC:UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(self.arrayData.count == 0)
        {
            self.labelEmptyMessage.isHidden = false
            return 0
        }
        else
        {
            self.labelEmptyMessage.isHidden = true
            
        }
        return self.arrayData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell") as! CartTableViewCell
       cell.labelStatus.font = UIFont(name: FontLocalization.medium.strValue, size: 13.0)
       cell.labelFeedback.font = UIFont(name: FontLocalization.medium.strValue, size: 13.0)
       cell.trackOrderLbl.font = UIFont(name: FontLocalization.medium.strValue, size: 13.0)
       cell.labelItemCurrentAmount.font = UIFont(name: FontLocalization.medium.strValue, size: 13.0)
       cell.labelItemName.font = UIFont(name: FontLocalization.medium.strValue, size: 13.0)
       cell.buttonViewDetails.titleLabel?.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        cell.buttonViewDetails.tag = indexPath.row
        cell.buttonTrackOrders.tag = indexPath.row
        cell.buttonViewDetails.setAttributedTitle(attributeString, for: .normal)
        
        cell.buttonTrackOrders.addTarget(self, action: #selector(buttonTrackOrders), for: .touchUpInside)
        cell.buttonViewDetails.addTarget(self, action: #selector(buttonViewDetails), for: .touchUpInside)
        
        cell.buttonFeedback.tag = indexPath.row
        cell.buttonFeedback.addTarget(self, action: #selector(buttonFeedback), for: .touchUpInside)
        cell.labelFeedback.text = NSLocalizedString("MSG276", comment: "")
        
        cell.labelDate.text = NSLocalizedString("MSG282", comment: "") + " \(arrayData[indexPath.row]["created_at"].string ?? "")"
        
        //         let price = self.getPrice(dictData: arrayData[indexPath.row].dictionary!) + " \(arrayData[indexPath.row]["current_currency"].string ?? "")"
        
        let order = NSLocalizedString("MSG283", comment: "") + " \(arrayData[indexPath.row]["product_order_id"].string ?? "")"
        
        let qty = NSLocalizedString("MSG284", comment: "") + " " + String(arrayData[indexPath.row]["quantity"].string ?? "")
        
        cell.labelItemCurrentAmount.text = order + "  " + qty
        
        
        cell.labelItemName.text = "\(arrayData[indexPath.row]["product_name"].string ?? "")"
        if(HelperArabic().isArabicLanguage())
        {
            if let title_ar =  arrayData[indexPath.row]["product_name_ar"].string
            {
                cell.labelItemName.text = title_ar
                
            }
        }
        if let strUrl = arrayData[indexPath.row]["product_image"].string
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
        
        cell.labelStatus.text = NSLocalizedString("MSG278", comment: "")
        cell.labelStatus.textColor = .red
        
        cell.buttonFeedback.isHidden = true
        cell.labelFeedback.isHidden = true
        cell.viewTrackOrder.isHidden = true
        
        cell.heightConstraintsFeedback.constant = 0
        cell.heightConstraintsTracking.constant = 0
        
        
        
        
        if let status = arrayData[indexPath.row]["order_status"].string
        {
            if(status.uppercased() == "PENDING" )
            {
                cell.labelStatus.text = NSLocalizedString("MSG402", comment: "") + ": " + NSLocalizedString("MSG395", comment: "")
                cell.labelStatus.textColor = UIColor.init(red:0.0/255.0, green:196.0/255.0, blue:143.0/255.0, alpha:1.0)
                cell.viewTrackOrder.isHidden = false
                cell.buttonFeedback.isHidden = false
                cell.labelFeedback.isHidden = false
                cell.heightConstraintsFeedback.constant = 37
                cell.heightConstraintsTracking.constant = 37
            }
            if(status.uppercased() == "FAILED" )
            {
                cell.labelStatus.text = NSLocalizedString("MSG402", comment: "") + ": " + NSLocalizedString("MSG396", comment: "")
                cell.labelStatus.textColor = .red
                cell.viewTrackOrder.isHidden = true
                cell.buttonFeedback.isHidden = true
                cell.labelFeedback.isHidden = true
                cell.heightConstraintsFeedback.constant = 0
                cell.heightConstraintsTracking.constant = 0
            }
            if(status.uppercased() == "PROCESSING" )
            {
                cell.labelStatus.text = NSLocalizedString("MSG402", comment: "") + ": " + NSLocalizedString("MSG397", comment: "")
                cell.labelStatus.textColor = UIColor.init(red:0.0/255.0, green:196.0/255.0, blue:143.0/255.0, alpha:1.0)
                cell.viewTrackOrder.isHidden = false
                cell.buttonFeedback.isHidden = false
                cell.labelFeedback.isHidden = false
                cell.heightConstraintsFeedback.constant = 37
                cell.heightConstraintsTracking.constant = 37
            }
            if(status.uppercased() == "COMPLETED" )
            {
                cell.labelStatus.text = NSLocalizedString("MSG402", comment: "") + ": " + NSLocalizedString("MSG398", comment: "")
                cell.labelStatus.textColor = UIColor.init(red:0.0/255.0, green:196.0/255.0, blue:143.0/255.0, alpha:1.0)
                cell.viewTrackOrder.isHidden = true
                cell.buttonFeedback.isHidden = false
                cell.labelFeedback.isHidden = false
                cell.heightConstraintsFeedback.constant = 37
                cell.heightConstraintsTracking.constant = 37
            }
            if(status.uppercased() == "ON-HOLD" )
            {
                cell.labelStatus.text = NSLocalizedString("MSG402", comment: "") + ": " + NSLocalizedString("MSG399", comment: "")
                cell.labelStatus.textColor = UIColor.init(red:0.0/255.0, green:196.0/255.0, blue:143.0/255.0, alpha:1.0)
                cell.viewTrackOrder.isHidden = false
                cell.buttonFeedback.isHidden = false
                cell.labelFeedback.isHidden = false
                cell.heightConstraintsFeedback.constant = 37
                cell.heightConstraintsTracking.constant = 37
            }
            if(status.uppercased() == "CANCELLED" )
            {
                cell.labelStatus.text = NSLocalizedString("MSG402", comment: "") + ": " + NSLocalizedString("MSG400", comment: "")
                cell.labelStatus.textColor = .red
                cell.viewTrackOrder.isHidden = true
                cell.buttonFeedback.isHidden = true
                cell.labelFeedback.isHidden = true
                cell.heightConstraintsFeedback.constant = 0
                cell.heightConstraintsTracking.constant = 0
            }
            if(status.uppercased() == "REFUNDED" )
            {
                cell.labelStatus.text = NSLocalizedString("MSG402", comment: "") + ": " + NSLocalizedString("MSG401", comment: "")
                cell.labelStatus.textColor = .red
                cell.viewTrackOrder.isHidden = true
                cell.buttonFeedback.isHidden = true
                cell.labelFeedback.isHidden = true
                cell.heightConstraintsFeedback.constant = 0
                cell.heightConstraintsTracking.constant = 0
            }
        }
        
        
        
        if let status = arrayData[indexPath.row]["feedback_status"].string
        {
            if(status == "1" && cell.viewTrackOrder.isHidden == true)
            {
                cell.feedbackView.isHidden = true
                cell.heightConstraintsFeedback.constant = 0
                cell.heightConstraintsTracking.constant = 0
            }
            else if(status == "1")
            {
                cell.feedbackView.isHidden = true
                
            }
            else
            {
                cell.feedbackView.isHidden = false
            }
        }
        else
        {
            cell.feedbackView.isHidden = false
            
        }
        
        
        return cell
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return  UITableView.automaticDimension
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
    }
    
    @objc func buttonViewDetails(sender:UIButton)
    {
        let objFav = self.storyboard?.instantiateViewController(withIdentifier: "OrderDetailsVC") as! OrderDetailsVC
        objFav.modalPresentationStyle = .overCurrentContext
        
        objFav.dicData = arrayData[sender.tag].dictionary ?? [:]
        self.present(objFav, animated: false, completion: nil)
    }
    
    @objc func buttonFeedback(sender:UIButton)
    {
        let objFav = self.storyboard?.instantiateViewController(withIdentifier: "ReviewVC") as! ReviewVC
        self.definesPresentationContext = true
        objFav.dicData = arrayData[sender.tag].dictionary ?? [:]
        objFav.modalPresentationStyle = .overCurrentContext
        objFav.delegateOrder = self
        self.present(objFav, animated: false, completion: nil)
    }
    @objc func buttonTrackOrders(sender:UIButton)
    {
        
        if let aramexOrderID = arrayData[sender.tag]["order_tracking_id"].string
        {
            if(aramexOrderID.count > 0)
            {
                let url = URL(string: String(KeyConstant.aramexDeliverTrack + aramexOrderID))!
                let controller = SFSafariViewController(url: url)
                controller.delegate = self
                self.present(controller, animated: false, completion: nil)
                return
            }
            
        }
        
        
        let alertView = UIAlertController(title: NSLocalizedString("MSG31", comment: "").uppercased(), message: "", preferredStyle: .alert)
        let msgFont = [NSAttributedString.Key.font: UIFont(name: FontLocalization.medium.strValue, size: 15.0)!]
        let msgAttrString = NSMutableAttributedString(string: NSLocalizedString("MSG316", comment: ""), attributes: msgFont)
        alertView.setValue(msgAttrString, forKey: "attributedMessage")
        
        let alertAction = UIAlertAction(title: NSLocalizedString("MSG18", comment: ""), style: .default) { (alert) in
        }
        alertAction.setValue(AppColors.SelcetedColor, forKey: "titleTextColor")
        alertView.addAction(alertAction)
        self.present(alertView, animated: true, completion: nil)
        
        
    }
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    func getPrice(dictData:[String:JSON]) -> String
    {
        var price = ""
        if let priceDouble = dictData["total"]?.double
        {
            price = String(format:"%.2f", priceDouble)
        }
        else if let priceInt = dictData["total"]?.int
        {
            price = String(format:"%d",priceInt)
        }
        else
        {
            var strPrice = dictData["total"]?.string ?? "0.0"
            strPrice = strPrice.replacingOccurrences(of: ",", with: "")
            price = strPrice
        }
        return price
    }
    
    
}
