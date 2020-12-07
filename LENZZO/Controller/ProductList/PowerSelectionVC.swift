//
//  PoweSelectionVC.swift
//  LENZZO
//
//  Created by Apple on 8/17/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import UIKit
import Kingfisher
import AlamofireImage
import SwiftyJSON


protocol DelegatePowerSelection {
    func getSlectedPower(left:Double, right:Double)
    func updateDatailClearContact()
    
}

class PowerSelectionVC: UIViewController {
    
    var delegatePower: DelegatePowerSelection!
    var leftPower = Double()
    var rightPower = Double()
    var dicDataForClearedContact = [String:String]()
    
    var leftPowerOutOfStock = [String]()
    var rightPowerOutOfStock = [String]()
    
    @IBOutlet weak var rightTableView: UITableView!
    @IBOutlet weak var leftTableView: UITableView!
    @IBOutlet weak var labelLeftEye: PaddingLabel!
    @IBOutlet weak var rightLeftEye: PaddingLabel!
    var arrayLeft = [Double]()
    var arrayRight = [Double]()
    var tempArrayLeft = [Int]()
    var tempArrayRight = [Int]()
    
    
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
        self.displayHeaderInfo()
        
        
        leftTableView.tableFooterView = UIView()
        rightTableView.tableFooterView = UIView()
        
        
        //        /////////////////remove out of stock //////////////////
        //
        //        var arrayLeftTemp = [Double]()
        //        arrayLeftTemp.insert(0.0, at:arrayLeftTemp.count)
        //
        //        for ind in 0..<arrayLeft.count
        //        {
        //
        //            if(self.isOutOfStock(power: arrayLeft[ind], outStock: self.leftPowerOutOfStock))
        //            {
        //                //out of stock remove
        //            }
        //            else
        //            {
        //                if(!(arrayLeft[ind] == 0.0))
        //                {
        //                arrayLeftTemp.insert(arrayLeft[ind], at:arrayLeftTemp.count)
        //                }
        //            }
        //        }
        //
        //        self.arrayLeft = arrayLeftTemp  //added new range without out of stock
        //
        //        leftTableView.reloadData()
        
        
        //        var arrayRightTemp = [Double]()
        //        arrayRightTemp.insert(0.0, at:arrayRightTemp.count)
        //
        //        for ind in 0..<arrayRight.count
        //        {
        //            if(self.isOutOfStock(power: arrayRight[ind], outStock: self.rightPowerOutOfStock))
        //            {
        //                //out of stock remove
        //            }
        //            else
        //            {
        //                if(!(arrayRight[ind] == 0.0))
        //                {
        //                arrayRightTemp.insert(arrayRight[ind], at:arrayRightTemp.count)
        //                }
        //            }
        //        }
        //        self.arrayRight = arrayRightTemp  //added new range without out of stock
        //
        //        rightTableView.reloadData()
        
        for ind in 0..<arrayLeft.count
        {
            if(leftPower == arrayLeft[ind])
            {
                tempArrayLeft.insert(1, at: ind)
            }
            else
            {
                tempArrayLeft.insert(0, at: ind)
                
            }
        }
        for ind in 0..<arrayRight.count
        {
            if(rightPower == arrayRight[ind])
            {
                tempArrayRight.insert(1, at: ind)
            }
            else
            {
                tempArrayRight.insert(0, at: ind)
                
            }
            
        }
        leftTableView.reloadData()
        rightTableView.reloadData()
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonDone(_ sender: Any) {
        //        if(leftPower == 1.0)
        //        {
        //            AppDelegate().showAlertView(vc: self, titleString: NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG190", comment: ""))
        //            return
        //        }
        //        if(rightPower == 1.0)
        //        {
        //
        //            AppDelegate().showAlertView(vc: self, titleString: NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG191", comment: ""))
        //
        //           return
        //        }
        
        print(self.leftPower,self.rightPower)
        
        if(dicDataForClearedContact.count > 0)
        {
            
            if(self.leftPower == 0.0)
            {
                self.showAlert(message: NSLocalizedString("MSG190", comment: ""))
            }
            else if(self.rightPower == 0.0)
            {
                self.showAlert(message: NSLocalizedString("MSG191", comment: ""))
                
            }
            else
            {
                
                if(self.leftPower == self.rightPower)
                {
                    dicDataForClearedContact["quantity"] = "1"
                }
                else
                {
                    dicDataForClearedContact["quantity"] = "2"
                }
                dicDataForClearedContact["left_eye_power"] = String(leftPower)
                dicDataForClearedContact["right_eye_power"] = String(rightPower)
                dicDataForClearedContact["quantity_right"] = "1"
                dicDataForClearedContact["quantity_left"] = "1"
                addToCart(params: dicDataForClearedContact)
            }
            
        }
        else
        {
            self.dismiss(animated: false, completion: {
                self.delegatePower.getSlectedPower(left: self.leftPower, right: self.rightPower)
            })
        }
        
    }
    func addToCart(params:[String:String])
    {
        
        CartViewModel().addToCart(vc: self, param:params ) { (isDone:Bool, error:Error?) in
            
            if(isDone == true)
            {
                self.dismiss(animated: false, completion: {
                    self.delegatePower.updateDatailClearContact()
                })
                
            }
            else
            {
                KeyConstant.sharedAppDelegate.showAlertView(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString:error?.localizedDescription ?? NSLocalizedString("MSG21", comment: ""))
                
            }
            
            
        }
        
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
extension PowerSelectionVC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == leftTableView)
        {
            return arrayLeft.count
            
        }
        else if(tableView == rightTableView)
        {
            return arrayRight.count
            
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(tableView == leftTableView)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PowerTVCell") as! PowerTVCell
            cell.labelPower.text = String(format:"%.2f",arrayLeft[indexPath.row])
            cell.buttonSelected.tag = indexPath.row
            cell.buttonSelected.addTarget(self, action: #selector(leftAction), for: .touchUpInside)
            if(tempArrayLeft[indexPath.row] == 1)
            {
                cell.buttonRadio.setImage(UIImage(named: "radio_fill"), for: .normal)
                
            }
            else
            {
                cell.buttonRadio.setImage(UIImage(named: "radio"), for: .normal)
            }
            
            if(self.isOutOfStock(power: arrayLeft[indexPath.row], outStock: self.leftPowerOutOfStock))
            {
                cell.labelPower.text = String(format:"%.2f",arrayLeft[indexPath.row]) + " " + NSLocalizedString("MSG260", comment: "")
                cell.buttonSelected.isUserInteractionEnabled = true
                cell.labelPower.textColor = .red
            }
            else
            {
                cell.labelPower.text = String(format:"%.2f",arrayLeft[indexPath.row])
                cell.buttonSelected.isUserInteractionEnabled = true
                cell.labelPower.textColor = .black
                
            }
            
            return cell
        }
            
        else if(tableView == rightTableView)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PowerTVCellRight") as! PowerTVCell
            cell.labelPower.text = String(format:"%.2f",arrayRight[indexPath.row])
            cell.buttonSelected.tag = indexPath.row
            cell.buttonSelected.addTarget(self, action: #selector(rightAction), for: .touchUpInside)
            if(tempArrayRight[indexPath.row] == 1)
            {
                cell.buttonRadio.setImage(UIImage(named: "radio_fill"), for: .normal)
                
            }
            else
            {
                cell.buttonRadio.setImage(UIImage(named: "radio"), for: .normal)
            }
            
            if(self.isOutOfStock(power: arrayRight[indexPath.row], outStock: self.rightPowerOutOfStock))
            {
                cell.labelPower.text = String(format:"%.2f",arrayRight[indexPath.row]) + " " + NSLocalizedString("MSG260", comment: "")
                cell.buttonSelected.isUserInteractionEnabled = true
                cell.labelPower.textColor = .red
            }
            else
            {
                cell.labelPower.text = String(format:"%.2f",arrayLeft[indexPath.row])
                cell.buttonSelected.isUserInteractionEnabled = true
                cell.labelPower.textColor = .black
                
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    @objc func leftAction(sender:UIButton)
    {
        
        if(self.isOutOfStock(power: arrayLeft[sender.tag], outStock: self.leftPowerOutOfStock))
        {
            self.showAlertOutOfStock()
            return
        }
        else
        {
            
            self.leftPower = KeyConstant.kNoPower
            if(self.rightPower == KeyConstant.kNoPower)
            {
                for ind in 0..<arrayLeft.count
                {
                    tempArrayLeft.insert(0, at: ind)
                }
                
            }
            
            for ind in 0..<arrayLeft.count
            {
                if(tempArrayLeft[ind] == 1)
                {
                    
                    tempArrayLeft[ind] = 0
                    
                    
                    
                }
                else
                {
                    
                    if(ind == sender.tag)
                    {
                        tempArrayLeft[ind] = 1
                        self.leftPower = arrayLeft[sender.tag]
                    }
                    else
                    {
                        tempArrayLeft[ind] = 0
                        
                    }
                }
            }
            
            
            self.displayHeaderInfo()
            leftTableView.reloadData()
        }
    }
    func displayHeaderInfo()
    {
        labelLeftEye.text = NSLocalizedString("MSG256", comment: "")
        if(!(leftPower == KeyConstant.kNoPower))
        {
            labelLeftEye.text = labelLeftEye.text! + " (\(String(format:"%.2f",leftPower)))"
        }
        
        rightLeftEye.text = NSLocalizedString("MSG257", comment: "")
        if(!(rightPower == KeyConstant.kNoPower))
        {
            rightLeftEye.text = rightLeftEye.text! + " (\(String(format:"%.2f",rightPower)))"
        }
    }
    func isOutOfStock(power:Double, outStock:[String])->Bool
    {
        for ind in 0..<outStock.count
        {
            if(Double(outStock[ind]) == power)
            {
                return true
            }
        }
        return false
    }
    
    @objc func rightAction(sender:UIButton)
    {
        //        tempArrayRight.removeAll()
        if(self.isOutOfStock(power: arrayRight[sender.tag], outStock: self.rightPowerOutOfStock))
        {
            self.showAlertOutOfStock()
            return
        }
        else
        {
            self.rightPower = KeyConstant.kNoPower
            if(self.leftPower == KeyConstant.kNoPower)
            {
                for ind in 0..<arrayRight.count
                {
                    tempArrayRight.insert(0, at: ind)
                }
                
            }
            for ind in 0..<arrayRight.count
            {
                if(tempArrayRight[ind] == 1)
                {
                    tempArrayRight[ind] = 0
                }
                else
                {
                    if(ind == sender.tag)
                    {
                        tempArrayRight[ind] = 1
                        self.rightPower = arrayRight[sender.tag]
                    }
                    else
                    {
                        tempArrayRight[ind] = 0
                        
                    }
                }
            }
            self.displayHeaderInfo()
            
            rightTableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 31
    }
    
    
    func showAlertOutOfStock()
    {
        let alertView = UIAlertController(title: NSLocalizedString("MSG31", comment: "").uppercased(), message: "", preferredStyle: .alert)
        let msgFont = [NSAttributedString.Key.font: UIFont(name: FontLocalization.medium.strValue, size: 15.0)!]
        let msgAttrString = NSMutableAttributedString(string: NSLocalizedString("MSG260", comment: ""), attributes: msgFont)
        alertView.setValue(msgAttrString, forKey: "attributedMessage")
        
        let alertAction = UIAlertAction(title: NSLocalizedString("MSG18", comment: ""), style: .default) { (alert) in
        }
        alertAction.setValue(AppColors.SelcetedColor, forKey: "titleTextColor")
        alertView.addAction(alertAction)
        self.present(alertView, animated: true, completion: nil)
    }
    
    func showAlert(message:String)
    {
        let alertView = UIAlertController(title: NSLocalizedString("MSG31", comment: "").uppercased(), message: "", preferredStyle: .alert)
        let msgFont = [NSAttributedString.Key.font: UIFont(name: FontLocalization.medium.strValue, size: 15.0)!]
        let msgAttrString = NSMutableAttributedString(string: message, attributes: msgFont)
        alertView.setValue(msgAttrString, forKey: "attributedMessage")
        
        let alertAction = UIAlertAction(title: NSLocalizedString("MSG18", comment: ""), style: .default) { (alert) in
        }
        alertAction.setValue(AppColors.SelcetedColor, forKey: "titleTextColor")
        alertView.addAction(alertAction)
        self.present(alertView, animated: true, completion: nil)
    }
    
}
