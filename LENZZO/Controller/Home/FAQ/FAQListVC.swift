//
//  FAQListVC.swift
//  LENZZO
//
//  Created by Apple on 9/26/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import UIKit
import Kingfisher
import AlamofireImage
import SwiftyJSON


class FAQListVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonMenu: UIButton!
    var arrayData = [JSON]()

    @IBOutlet weak var labelCountCart: UILabel!
   
    var titleString = String()

    @IBOutlet weak var labelTitle: PaddingLabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.buttonMenu.addTarget(self, action:#selector(backAction), for: .touchUpInside)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        self.labelTitle.text = titleString
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
        super.viewWillAppear(false)
        labelCountCart.text = ""
        
        
        CartViewModel().viewCartList(vc: self, param: ["user_id":KeyConstant.sharedAppDelegate.getUserId()], completionHandler: { (result:[JSON], totalCount:String ,error:Error?) in
            
            self.labelCountCart.text = ""
        
            
            
            if(result.count > 0)
            {
                print(result.count)
                self.labelCountCart.text = totalCount
                
            }})
        self.getFAQData()
        // MBProgress().showIndicator(view: self.view)
        
        
    }
    
    func getFAQData()
    {
      
        MBProgress().showIndicator(view: self.view)
        arrayData.removeAll()
        
        WebServiceHelper.sharedInstanceAPI.hitPostAPI(urlString: KeyConstant.APIFAQList, params: [:], completionHandler: { (result: [String:Any], err:Error?) in
            print(result)
            DispatchQueue.main.async {
                MBProgress().hideIndicator(view: self.view)
            }
            if(!(err == nil))
            {
                self.tableView.reloadData()

                return
            }
            let json = JSON(result)
            
            let statusCode = json["status"].string
            print(json)
            if(statusCode == "success")
            {
                if let arrayData = json["response"].array
                {
                    if(arrayData.count > 0)
                    {
                     self.arrayData = arrayData
                    }
                }
            }
            
            self.tableView.reloadData()

        })
        

        
    }
    @objc func backAction(sender:UIButton)
    {
        self.dismiss(animated: true, completion: nil)
        
    }
    @objc func rightSwip(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            self.backAction(sender: UIButton())

        }
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    @IBAction func buttoCart(_ sender: Any) {
  
        KeyConstant.sharedAppDelegate.showCartScreen(vc: self)
    }
    @IBAction func buttoSort(_ sender: Any) {
        
        KeyConstant.sharedAppDelegate.showSearchScreen(vc: self)
        
    }
    @IBAction func buttonFilter(_ sender: Any) {
        KeyConstant.sharedAppDelegate.showFilterScreen(vc: self)
        
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
extension FAQListVC:UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrayData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cellMenu = tableView.dequeueReusableCell(withIdentifier: "SearchProductTVCell") as! SearchProductTVCell
        
        cellMenu.labeltitle.text = arrayData[indexPath.row]["name"].string ?? ""
        if(HelperArabic().isArabicLanguage())
        {
            if let strTitle =  arrayData[indexPath.row]["name_ar"].string
            {
            cellMenu.labeltitle.text = strTitle
            }
        }
        
        return cellMenu
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let objFav = self.storyboard?.instantiateViewController(withIdentifier: "FAQDetailsVC") as! FAQDetailsVC
        objFav.titleString = arrayData[indexPath.row]["name"].string ?? ""
        objFav.faqID = arrayData[indexPath.row]["id"].string ?? ""
        self.present(objFav, animated: false, completion: nil)
        
        
        
    }
   
    
  
    
    
    
    
    
}
