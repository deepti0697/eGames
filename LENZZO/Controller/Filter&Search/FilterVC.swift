//
//  FilterVC.swift
//  LENZZO
//
//  Created by Apple on 9/16/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import UIKit
import Kingfisher
import AlamofireImage
import SwiftyJSON

protocol FilterReloadDelegate
{
    func filterReload(title:String,dicData:[String:String],arrTempSelectedRowAllData:Array<Any>,arrayBrandSelected:[String] )
}

class FilterVC: UIViewController,BrandFilterDelegate {
    var delegateFilter: FilterReloadDelegate!
    
    @IBOutlet weak var tableViewFilterData: UITableView!
    
    @IBOutlet weak var viewSuper: UIView!
    @IBOutlet weak var tableViewFilterMenu: UITableView!
    
    var arrTempMenu = [Bool]()
    var selectedMenuIndex = 0
    var selectedRate = 0
    var dicData = [String:String]()
    var brandID = String()
    var arrayBrandSelected = [String]()
    
    var arrTempSelectedRowAllData = Array<Any>()
    
    var arrTempSelectedRowData = [Bool]()
    var currentTag = -1
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewFilterMenu.tableFooterView = UIView()
        tableViewFilterMenu.rowHeight = UITableView.automaticDimension
        tableViewFilterMenu.estimatedRowHeight = UITableView.automaticDimension
        
        tableViewFilterData.tableFooterView = UIView()
        tableViewFilterData.rowHeight = UITableView.automaticDimension
        tableViewFilterData.estimatedRowHeight = UITableView.automaticDimension
        
        
        if(self.arrTempSelectedRowAllData.count < 1)
        {
            FilterViewModel().getAlFilterData(vc: self, completionHandler: { (success: Bool, errorC:Error?) in
                if(errorC != nil)
                {
                    self.viewDidLoad()
                    return
                }
                self.selectedMenuIndex = 0
                self.arrTempSelectedRowAllData.removeAll()
                
                for ind in 0..<FilterDataModel.sharedInstance.arrayList.count
                {
                    self.arrTempSelectedRowData.removeAll()
                    
                    for ind in 0..<FilterDataModel.sharedInstance.arrayList[ind].arrayData.count
                    {
                        self.arrTempSelectedRowData.insert(false, at: self.arrTempSelectedRowData.count)
                    }
                    
                    self.arrTempSelectedRowAllData.insert(self.arrTempSelectedRowData, at: self.arrTempSelectedRowAllData.count)
                }
                self.tableViewFilterMenu.reloadData()
                self.tableViewFilterData.reloadData()
                
            } )
        }
        else
        {
            
            FilterViewModel().getAlFilterData(vc: self, completionHandler: { (success: Bool, errorC:Error?) in
                if(errorC != nil)
                {
                    self.viewDidLoad()
                    return
                }
                self.selectedMenuIndex = 0
                self.arrTempSelectedRowData = self.arrTempSelectedRowAllData[self.selectedMenuIndex] as! [Bool]
                if(self.arrayBrandSelected.count > 0)
                {
                    self.brandID = self.arrayBrandSelected.joined(separator: ",")
                }
                self.tableViewFilterMenu.reloadData()
                self.tableViewFilterData.reloadData()
                
            } )
            
            
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
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        
        
        super.viewDidLayoutSubviews()
        
        viewSuper.dropShadow(color: .black, opacity: 0.5, offSet: CGSize(width: -1, height: 1), radius: 2, scale: true)
        
        
    }
    
    
    @objc func rightSwip(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            self.buttonBack(UIButton())
            
        }
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @IBAction func buttonclear(_ sender: Any) {
        
        self.arrTempSelectedRowAllData.removeAll()
        self.selectedRate = 0
        for ind in 0..<FilterDataModel.sharedInstance.arrayList.count
        {
            self.arrTempSelectedRowData.removeAll()
            
            for ind in 0..<FilterDataModel.sharedInstance.arrayList[ind].arrayData.count
            {
                self.arrTempSelectedRowData.insert(false, at: self.arrTempSelectedRowData.count)
            }
            
            self.arrTempSelectedRowAllData.insert(self.arrTempSelectedRowData, at: self.arrTempSelectedRowAllData.count)
        }
        brandID = ""
        arrayBrandSelected.removeAll()
        self.tableViewFilterMenu.reloadData()
        self.tableViewFilterData.reloadData()
        
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func backWithFilterBrand(arrayBrandSelected:[String])
    {
        self.arrayBrandSelected = arrayBrandSelected
        brandID = self.arrayBrandSelected.joined(separator: ",")
    }
    
    @IBAction func buttonFilter(_ sender: Any) {
        
        dicData.removeAll()
        arrTempSelectedRowData.removeAll()
        if(FilterDataModel.sharedInstance.arrayList.count > 0)
        {
            
            for ind in 0..<arrTempSelectedRowAllData.count
            {
                let slug = FilterDataModel.sharedInstance.arrayList[ind].slug ?? ""
                if(slug == "rating")
                {
                    dicData[slug] = String(selectedRate)
                    
                }
                else if(slug == "brands")
                {
                    dicData[slug] =  self.brandID
                    
                }
                else
                {
                    arrTempSelectedRowData = arrTempSelectedRowAllData[ind] as! [Bool]
                    var tempArray = [String]()
                    
                    if(arrTempSelectedRowData.contains(true))
                    {
                        
                        for indexT in 0..<arrTempSelectedRowData.count
                        {
                            if(arrTempSelectedRowData[indexT] == true)
                            {
                                tempArray.insert(FilterDataModel.sharedInstance.arrayList[ind].arrayData[indexT]["value"].string ?? "", at: tempArray.count)
                            }
                        }
                    }
                    
                    
                    dicData[slug] = tempArray.joined(separator: ",")
                    
                }
            }
        }
        
        
        ProductListModel.sharedInstance.arrayProductList.removeAll()
        
        
        print(dicData)
        
        if(delegateFilter != nil)
        {
            self.dismiss(animated: true, completion: {
                self.delegateFilter.filterReload(title: NSLocalizedString("MSG214", comment: ""), dicData: self.dicData, arrTempSelectedRowAllData: self.arrTempSelectedRowAllData, arrayBrandSelected: self.arrayBrandSelected)
                
            })
            
            
        }
        else
        {
            let brandVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductListVC") as! ProductListVC
            brandVC.stringTitle = NSLocalizedString("MSG214", comment: "")
            brandVC.filterDicData = dicData
            brandVC.arrTempSelectedRowAllData = arrTempSelectedRowAllData
            self.present(brandVC, animated: false, completion: nil)
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
extension FilterVC:UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if(tableView == tableViewFilterMenu )
        {
            if(arrTempMenu.count < 1)
            {
                self.arrTempMenu.removeAll()
                for ind in 0..<FilterDataModel.sharedInstance.arrayList.count
                {
                    self.arrTempMenu.insert(false, at: self.arrTempMenu.count)
                }
                if(selectedMenuIndex < arrTempMenu.count)
                {
                    arrTempMenu[selectedMenuIndex] = true
                }
            }
            return FilterDataModel.sharedInstance.arrayList.count
        }
        else if(tableView == tableViewFilterData)
        {
            
            if(FilterDataModel.sharedInstance.arrayList.count > 0 && selectedMenuIndex < FilterDataModel.sharedInstance.arrayList.count)
            {
                
                print(FilterDataModel.sharedInstance.arrayList[selectedMenuIndex].title)
                
                if(FilterDataModel.sharedInstance.arrayList[selectedMenuIndex].slug == "rating")
                {
                    return 1
                }
                
                
                
                return FilterDataModel.sharedInstance.arrayList[selectedMenuIndex].arrayData.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if(tableView == tableViewFilterMenu )
        {
            let cellMenu = tableView.dequeueReusableCell(withIdentifier: "FilterMenuTVCell") as! FilterMenuTVCell
            cellMenu.labelTitle.text = FilterDataModel.sharedInstance.arrayList[indexPath.row].title
            if(arrTempMenu[indexPath.row] == true)
            {
                cellMenu.viewMenu.backgroundColor = UIColor(hexString: "423F55")
                cellMenu.viewImage.backgroundColor = .black
                cellMenu.labelTitle.textColor = .white
                
            }
            else{
                cellMenu.viewMenu.backgroundColor = UIColor.init(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0)
                cellMenu.viewImage.backgroundColor = UIColor.init(red: 162.0/255.0, green: 162.0/255.0, blue: 162.0/255.0, alpha: 1.0)
                cellMenu.labelTitle.textColor = .darkGray
            }
            
            cellMenu.imageViewMenu.image = UIImage(named: "noImage")
            
            switch (FilterDataModel.sharedInstance.arrayList[indexPath.row].slug.lowercased())
            {
            case "brands":  cellMenu.imageViewMenu.image = UIImage(named: "brand")
                break
            case "color":  cellMenu.imageViewMenu.image = UIImage(named: "color")
                break
            case "tags":    cellMenu.imageViewMenu.image = UIImage(named: "tag")
                break
            case "rating":  cellMenu.imageViewMenu.image = UIImage(named: "starRate")
                break
            case "gender":  cellMenu.imageViewMenu.image = UIImage(named: "user_30*30")
            case "replacement" : cellMenu.imageViewMenu.image = UIImage(named: "replacement")
            
                break
                
            default:
                cellMenu.imageViewMenu.image = UIImage(named: "noImage")
                break
            }
            
            return cellMenu
            
        }
        else if(tableView == tableViewFilterData)
        {
            if(FilterDataModel.sharedInstance.arrayList[selectedMenuIndex].slug.lowercased() == "rating")
            {
                let cellData = tableView.dequeueReusableCell(withIdentifier: "rating") as! FilterDataTVCell
                
                cellData.buttonRate1.tag = 1
                cellData.buttonRate2.tag = 2
                cellData.buttonRate3.tag = 3
                cellData.buttonRate4.tag = 4
                cellData.buttonRate5.tag = 5
                
                cellData.buttonRate1.addTarget(self, action: #selector(buttonRate), for: .touchUpInside)
                cellData.buttonRate2.addTarget(self, action: #selector(buttonRate), for: .touchUpInside)
                cellData.buttonRate3.addTarget(self, action: #selector(buttonRate), for: .touchUpInside)
                cellData.buttonRate4.addTarget(self, action: #selector(buttonRate), for: .touchUpInside)
                cellData.buttonRate5.addTarget(self, action: #selector(buttonRate), for: .touchUpInside)
                cellData.setRating(rate: selectedRate)
                return cellData
            }
            else
            {
                let cellData = tableView.dequeueReusableCell(withIdentifier: "FilterDataTVCell") as! FilterDataTVCell
                cellData.buttonMark.tag = indexPath.row
                cellData.buttonMark.addTarget(self, action: #selector(buttonMark), for: .touchUpInside)
                
                cellData.buttonSetAction.tag = indexPath.row
                cellData.buttonSetAction.addTarget(self, action: #selector(buttonMark), for: .touchUpInside)
                
                cellData.labelTitle.text = FilterDataModel.sharedInstance.arrayList[selectedMenuIndex].arrayData[indexPath.row]["name"].string
                if(HelperArabic().isArabicLanguage())
                {
                    if let strTitle = FilterDataModel.sharedInstance.arrayList[selectedMenuIndex].arrayData[indexPath.row]["name_ar"].string
                    {
                        if(strTitle.count > 0)
                        {
                            cellData.labelTitle.text = strTitle
                        }
                    }
                }
                
                
                
                cellData.buttonMark.setImage(UIImage(named:"de_select_100x100")?.withRenderingMode(.alwaysTemplate), for: .normal)
                cellData.buttonMark.tintColor = .white
                
                if(selectedMenuIndex < self.arrTempSelectedRowAllData.count)
                {
                    self.arrTempSelectedRowData = arrTempSelectedRowAllData[selectedMenuIndex] as! [Bool]
                    if (self.arrTempSelectedRowData[indexPath.row] == true)
                    {
                        cellData.buttonMark.setImage(UIImage(named:"slect_100x100")?.withRenderingMode(.alwaysTemplate), for: .normal)
                        cellData.buttonMark.tintColor = .white
                    }
                    else
                    {
                        cellData.buttonMark.setImage(UIImage(named:"de_select_100x100")?.withRenderingMode(.alwaysTemplate), for: .normal)
                        cellData.buttonMark.tintColor = .white
                    }
                }
                
                if(FilterDataModel.sharedInstance.arrayList[selectedMenuIndex].slug == "brands")
                {
                    
                    cellData.buttonMark.setImage(UIImage(named:"next"), for: .normal)
                }
                return cellData
                
            }
            
        }
        
        return UITableViewCell()
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(tableView == tableViewFilterData)
        {
            
            if(FilterDataModel.sharedInstance.arrayList[selectedMenuIndex].slug  == "rating")
            {
                return self.tableViewFilterData.frame.height
            }
            
            
        }
        return  UITableView.automaticDimension
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        if(tableView == tableViewFilterMenu )
        {
            selectedMenuIndex = indexPath.row
            for ind in 0..<arrTempMenu.count
            {
                if(arrTempMenu[ind] == true)
                {
                    arrTempMenu[ind] = false
                    break
                }
            }
            arrTempMenu[indexPath.row] = true
            
            self.tableViewFilterMenu.reloadData()
            self.tableViewFilterData.reloadData()
            
        }
        
    }
    
    
    
    @objc func buttonMark(sender:UIButton)
    {
        

        
        currentTag = sender.tag
        
        
        if(FilterDataModel.sharedInstance.arrayList[selectedMenuIndex].slug == "brands")
        {
            
            //        if(brandSlug == "glasses" || brandSlug == "contact-lenses")
            //        {
            if(FilterDataModel.sharedInstance.arrayList[selectedMenuIndex].arrayData[sender.tag]["brand_list"].array?.count ?? 0 > 0)
            {
                let brandVC = self.storyboard?.instantiateViewController(withIdentifier: "FilterBrandListVC") as! FilterBrandListVC
                brandVC.stringTitle = FilterDataModel.sharedInstance.arrayList[selectedMenuIndex].arrayData[sender.tag]["name"].string ?? ""
                brandVC.arrayData = FilterDataModel.sharedInstance.arrayList[selectedMenuIndex].arrayData[sender.tag]["brand_list"].array ?? [JSON]()
                brandVC.delegateBrandFilter = self
                brandVC.arrayBrandSelected = self.arrayBrandSelected
                self.present(brandVC, animated: false, completion: nil)
            }
            else
            {
                let alertView = UIAlertController(title: NSLocalizedString("MSG31", comment: "").uppercased(), message: "", preferredStyle: .alert)
                let msgFont = [NSAttributedString.Key.font: UIFont(name: FontLocalization.medium.strValue, size: 15.0)!]
                let msgAttrString = NSMutableAttributedString(string: NSLocalizedString("MSG413", comment: ""), attributes: msgFont)
                alertView.setValue(msgAttrString, forKey: "attributedMessage")
                
                let alertAction = UIAlertAction(title: NSLocalizedString("MSG18", comment: ""), style: .default) { (alert) in
                    
                }
                alertAction.setValue(UIColor(red: 175.0/255.0, green: 148.0/255.0, blue: 50.0/255.0, alpha: 1.0), forKey: "titleTextColor")
                alertView.addAction(alertAction)
                self.present(alertView, animated: true, completion: nil)
                
            }
            return
            
        }
        
        
        self.setMarkUnMark(tag: sender.tag)
    }
    
    func setMarkUnMark(tag:Int)
    {
        
        if(selectedMenuIndex < self.arrTempSelectedRowAllData.count)
        {
            self.arrTempSelectedRowData = arrTempSelectedRowAllData[selectedMenuIndex] as! [Bool]
            
            if selectedMenuIndex == 5{
                               if self.arrTempSelectedRowData.contains(true){
                                for selecteRowData in 0..<self.arrTempSelectedRowData.count{
                                    let selectedValue = self.arrTempSelectedRowData[selecteRowData]
                                    if selectedValue == true{
                                        self.arrTempSelectedRowData[selecteRowData] = false
                                    }
                                }
                               
                               }
                           }
            
            
            if(tag < self.arrTempSelectedRowData.count)
                
            {
               
                if (self.arrTempSelectedRowData[tag] == true)
                {
                    arrTempSelectedRowData[tag] = false
                    
                }
                else
                {
                    arrTempSelectedRowData[tag] = true
                    
                }
                arrTempSelectedRowAllData.remove(at: selectedMenuIndex)
                arrTempSelectedRowAllData.insert(arrTempSelectedRowData, at: selectedMenuIndex)
            }
            
        }
        
        
        tableViewFilterData.reloadData()
    }
    
    
    
    @objc func buttonRate(sender:UIButton)
    {
        if(selectedRate == sender.tag)
        {
            selectedRate = 0
            
        }
        else
        {
            selectedRate = sender.tag
            
        }
        tableViewFilterData.reloadData()
        
    }
    
    
    
//    {
//
//        if(self.arrayBrandSelected.count == 0)
//        {
//            if let brandID = arrayData[sender.tag]["id"].string
//            {
//                self.arrayBrandSelected.insert(brandID, at: self.arrayBrandSelected.count)
//
//            }
//        }
//        else
//        {
//
//            for ind in 0..<self.arrayBrandSelected.count
//            {
//                if let brandID = arrayData[sender.tag]["id"].string
//                {
//                if(self.arrayBrandSelected[ind] == brandID)
//                {
//                    arrayBrandSelected.remove(at: ind)
//                    break
//                }
//                else
//                {
//                    if(ind == self.arrayBrandSelected.count - 1)
//                    {
//                        arrayBrandSelected.insert(brandID, at: self.arrayBrandSelected.count)
//                    }
//                }
//                }
//            }
//        }
//
//        if(self.arrayBrandSelected.count > 0)
//        {
//            self.buttonSelect.isSelected = true
//
//        }
//        else
//        {
//            self.buttonSelect.isSelected = false
//        }
//        self.tableViewList.reloadData()
//    }
    
}
