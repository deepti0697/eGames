//
//  FilterBrandListVC.swift
//  LENZZO
//
//  Created by Apple on 12/20/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import UIKit
import Kingfisher
import AlamofireImage
import SwiftyJSON
protocol BrandFilterDelegate
{
    func backWithFilterBrand(arrayBrandSelected:[String])
}

class FilterBrandListVC: UIViewController {
    @IBOutlet weak var tableViewList: UITableView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonDone: UIButton!
    @IBOutlet weak var buttonSelect: UIButton!
    var delegateBrandFilter: BrandFilterDelegate!

    var arrayBrandSelected = [String]()

    var stringTitle = String()
    var arrayData = [JSON]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewList.tableFooterView = UIView()
        tableViewList.rowHeight = 50
        tableViewList.estimatedRowHeight = UITableView.automaticDimension
        
     
        print(arrayData)
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

        self.labelTitle.text = stringTitle
        
        if(arrayData.count == 0)
        {
            self.buttonDone.isHidden = true
            self.buttonSelect.isHidden = true

        }
      else
        {
            self.buttonDone.isHidden = false
            self.buttonSelect.isHidden = false

            self.buttonDone.setTitle(NSLocalizedString("MSG344", comment: ""), for: .normal)
            self.buttonSelect.setTitle(NSLocalizedString("MSG410", comment: ""), for: .normal)
            self.buttonSelect.setTitle(NSLocalizedString("MSG411", comment: ""), for: .selected)
            if(arrayBrandSelected.count > 0)
            {
              self.buttonSelect.isSelected = true
            }

        }
   
        
        self.tableViewList.reloadData()
        
        
      
        self.buttonSelect.isHidden = true
        
        
    }
    
    @IBAction func buttonSelectAll(_ sender: UIButton) {
        
        if(sender.isSelected == true)
        {
            sender.isSelected = false
            for ind in 0..<self.arrayData.count
            {
                if let brandID = arrayData[ind]["id"].string
                {
                    self.arrayBrandSelected.removeAll { (brandID) -> Bool in
                        return true
                    }
                    
                }
            }
            
            
        }
        else
        {
            sender.isSelected = true
            
            for ind in 0..<self.arrayData.count
            {
                if let brandID = arrayData[ind]["id"].string
                {
                        self.arrayBrandSelected.insert(brandID, at: self.arrayBrandSelected.count)
                }
            }
        }

        
        self.tableViewList.reloadData()
    }
    @IBAction func buttonBackAction(_ sender: Any) {
        self.dismiss(animated: false, completion: {
            
            
            self.delegateBrandFilter.backWithFilterBrand(arrayBrandSelected: self.arrayBrandSelected)
            
        })
        
    }
   

    
    @objc func rightSwip(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            self.buttonBackAction(UIButton())
            
        }
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    @IBAction func buttonDoneAction(_ sender: Any) {
       
        self.dismiss(animated: false, completion: {
            
          
                self.delegateBrandFilter.backWithFilterBrand(arrayBrandSelected: self.arrayBrandSelected)
            
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
extension FilterBrandListVC:UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrayData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellMenu = tableView.dequeueReusableCell(withIdentifier: "BrandFilterTVCell") as! BrandFilterTVCell
        if(indexPath.row < arrayData.count)
        {
            cellMenu.labeltitle.text = arrayData[indexPath.row]["name"].string ?? ""
            if(HelperArabic().isArabicLanguage())
            {
                if let title_ar =  arrayData[indexPath.row]["name_ar"].string
                {
                    if(title_ar.count > 0)
                    {
                        cellMenu.labeltitle.text = title_ar
                    }
                }
            }
            
            cellMenu.buttonSelection.tag = indexPath.row
            cellMenu.buttonSelection.addTarget(self, action: #selector(buttonMark), for: .touchUpInside)
            
            if(arrayBrandSelected.contains(arrayData[indexPath.row]["id"].string ?? "") == true)
            {
                cellMenu.imageViewRadio.image = UIImage(named:"slect_100x100")

            }
            else
            {
                cellMenu.imageViewRadio.image = UIImage(named:"de_select_100x100")
            }
            
            
        }
        
        
        return cellMenu
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return  UITableView.automaticDimension
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        
    }
    
    @objc func buttonMark(sender:UIButton)
    {
        
        if(self.arrayBrandSelected.count == 0)
        {
            if let brandID = arrayData[sender.tag]["id"].string
            {
                self.arrayBrandSelected.insert(brandID, at: self.arrayBrandSelected.count)

            }
        }
        else
        {
        
            for ind in 0..<self.arrayBrandSelected.count
            {
                if let brandID = arrayData[sender.tag]["id"].string
                {
                if(self.arrayBrandSelected[ind] == brandID)
                {
                    arrayBrandSelected.remove(at: ind)
                    break
                }
                else
                {
                    if(ind == self.arrayBrandSelected.count - 1)
                    {
                        arrayBrandSelected.insert(brandID, at: self.arrayBrandSelected.count)
                    }
                }
                }
            }
        }
     
        if(self.arrayBrandSelected.count > 0)
        {
            self.buttonSelect.isSelected = true

        }
        else
        {
            self.buttonSelect.isSelected = false
        }
        self.tableViewList.reloadData()
    }

    
    
   
}
