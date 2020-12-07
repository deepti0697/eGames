//
//  SearchProductVC.swift
//  LENZZO
//
//  Created by Apple on 9/17/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import UIKit
import Kingfisher
import AlamofireImage
import SwiftyJSON
class SearchProductVC: UIViewController, FilterReloadDelegate,SelectedSortDelegate {
   
    @IBOutlet weak var sortImgView: UIImageView!
    
    @IBOutlet weak var filterImgView: UIImageView!
    @IBOutlet weak var textFieldSearch: UITextField!
    @IBOutlet weak var tableViewList: UITableView!
    var arrayData = [JSON]()

    @IBOutlet weak var backImgView: UIImageView!
    
    @IBOutlet weak var searchBtn: UIButton!
    var filterParam = [String:String]()
    var arrTempSelectedRowAllData = Array<Any>()
    @IBOutlet weak var sortTitleLbl: UILabel!
   
    @IBOutlet weak var filterTitleLbl: UILabel!
    
    
    
    var arrayBrandSelected = [String]()
    var searchTxt = ""
    var selectedType = [String:String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.sortTitleLbl.font = UIFont(name: FontLocalization.medium.strValue, size: 16.0)
        self.filterTitleLbl.font = UIFont(name: FontLocalization.medium.strValue, size: 16.0)
        self.sortTitleLbl.text = NSLocalizedString("MSG440", comment: "")
        self.filterTitleLbl.text = NSLocalizedString("MSG441", comment: "")
        
        self.filterImgView.image = UIImage(named: "filter")?.withRenderingMode(.alwaysTemplate)
        self.filterImgView.tintColor = .white
        self.sortImgView.image = UIImage(named: "sort")?.withRenderingMode(.alwaysTemplate)
        self.sortImgView.tintColor = .white
        tableViewList.tableFooterView = UIView()
        tableViewList.rowHeight = 50
        tableViewList.estimatedRowHeight = UITableView.automaticDimension
       tableViewList.isHidden = true
        textFieldSearch.becomeFirstResponder()
        textFieldSearch.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("MSG444", comment: ""),
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
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
        self.searchBtn.titleLabel?.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        self.textFieldSearch.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.backImgView.image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate)
        self.backImgView.tintColor = .white
        if(HelperArabic().isArabicLanguage())
        {
            self.textFieldSearch.semanticContentAttribute = .forceRightToLeft
         self.backImgView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            
        }
        else
        {
            self.textFieldSearch.semanticContentAttribute = .forceLeftToRight
            self.backImgView.transform = CGAffineTransform(rotationAngle: 245)
        }
    }
    
    
    @IBAction func buttonBackAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)

    }
    
    @IBAction func buttonSearchProduct(_ sender: Any) {
        
        if(textFieldSearch.text?.count ?? 0 > 0)
        {
        let brandVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductListVC") as! ProductListVC
        brandVC.stringTitle = NSLocalizedString("MSG216", comment: "")
        brandVC.searchKeyWord = textFieldSearch.text ?? ""
        self.present(brandVC, animated: false, completion: nil)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func filterBtnClicked(_ sender: UIButton) {
        
       // KeyConstant.sharedAppDelegate.showFilterScreen(vc: self)
        let filterVC = self.storyboard?.instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
        filterVC.delegateFilter = self
       // self.present(filterVC, animated: false, completion: nil)
        
        
        filterVC.arrTempSelectedRowAllData = arrTempSelectedRowAllData
              var tempArrayBrandSelected = [String]()
              tempArrayBrandSelected = arrayBrandSelected
              filterVC.modalPresentationStyle = .overCurrentContext
              
              filterVC.arrayBrandSelected = tempArrayBrandSelected
              self.present(filterVC, animated: false, completion: nil)
    }
    
    
    @IBAction func sortBtnClicked(_ sender: UIButton) {
        
      let myCartVC = self.storyboard?.instantiateViewController(withIdentifier: "SortListVC") as! SortListVC
      myCartVC.selectedType = selectedType
      myCartVC.delegateSort = self
      myCartVC.modalPresentationStyle = .overCurrentContext
      self.present(myCartVC, animated: false, completion: nil)
    }
    
    func filterReload(title: String, dicData: [String : String], arrTempSelectedRowAllData: Array<Any>, arrayBrandSelected: [String]) {
           
        print(title,"dicData:- \(dicData)","arrayBrandSelected:- \(arrayBrandSelected)","arrTempSelectedRowAllData:- \(arrTempSelectedRowAllData)")
        self.filterParam = dicData
        self.arrTempSelectedRowAllData = arrTempSelectedRowAllData
        self.arrayBrandSelected = arrayBrandSelected
        
       }
    
    func updateSelected(index:[String:String])
    {
        selectedType = index
        //0 = "MSG226"   1= "MSG227"    2= "MSG228"
        if self.searchTxt.count > 0{
            self.tableViewList.isHidden = false
            self.arrayData.removeAll()
               
            
            ProductListViewModel().getBrandCatProductList(vc: self, itemId: "", APIName: KeyConstant.APIBrandProductList, sortIndex: index, customParam: ["search_text":self.searchTxt], filterParam: self.filterParam, completionHandler: { (result:[JSON], success: Bool, errorC:Error?) in
                   if(errorC != nil)
                   {
                       return
                       
                   }
                   self.arrayData = result
                   self.tableViewList.reloadData()
                   
               } )
        }
        
    }

}
extension SearchProductVC:UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrayData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  
            let cellMenu = tableView.dequeueReusableCell(withIdentifier: "SearchProductTVCell") as! SearchProductTVCell
        if(indexPath.row < arrayData.count)
        {
        cellMenu.labeltitle.text = arrayData[indexPath.row]["title"].string ?? ""
            if(HelperArabic().isArabicLanguage())
            {
                if let title_ar =  arrayData[indexPath.row]["title_ar"].string
                {
                cellMenu.labeltitle.text = title_ar
                }
            }
            
            
            if let arrayModelNum = arrayData[indexPath.row]["model_no"].string
            {
                if(arrayModelNum.count > 0)
                {
                    cellMenu.labeltitle.text = cellMenu.labeltitle.text! + " (\(arrayModelNum))"

                }
                
            }
            
        }
        
    
        return cellMenu
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     
        return  UITableView.automaticDimension
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
//        let brandVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductListVC") as! ProductListVC
//        brandVC.stringTitle = NSLocalizedString("MSG216", comment: "")
//        brandVC.searchKeyWord = ""

        if(arrayData.count > 0 && indexPath.row < arrayData.count)
        {
//            var arraTempJSON = [JSON]()
//            print(arrayData[indexPath.row])
//            arraTempJSON.append(arrayData[indexPath.row])
//            if(arraTempJSON.count > 0)
//            {
//                ProductListModel.sharedInstance.addSearchedData(arrData: arraTempJSON)
//                self.present(brandVC, animated: false, completion: nil)
//            }
            
            let brandVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC
            brandVC.productId = arrayData[indexPath.row]["id"].string ?? ""
            var title = arrayData[indexPath.row]["title"].string ?? ""
            if let title_ar =  arrayData[indexPath.row]["title_ar"].string
            {
                if(title_ar.count > 0)
                {
                    title = title_ar
                }
                
            }
            brandVC.stringTitle = title
                self.present(brandVC, animated: false, completion: nil)
        }
    }
    
    
    func getAllData(keyWord:String)
    {
      
        self.arrayData.removeAll()
        
     
        ProductListViewModel().getBrandCatProductList(vc: self, itemId: "", APIName: KeyConstant.APIBrandProductList, sortIndex: self.selectedType, customParam: ["search_text":keyWord], filterParam: self.filterParam, completionHandler: { (result:[JSON], success: Bool, errorC:Error?) in
            if(errorC != nil)
            {
                self.getAllData(keyWord: keyWord)
                return
                
            }
            self.arrayData = result
            self.tableViewList.reloadData()
            
        } )
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if(textField == textFieldSearch)
        {
           
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
          print("Search text:- \(newString)")
            self.searchTxt = newString as String
            if(newString.length > 0)
            {
                
                tableViewList.isHidden = false
                self.getAllData(keyWord: String(newString))

            }
            else
            {
                if(newString.length == 0)
                {
                    self.arrayData.removeAll()
                    
                    DispatchQueue.main.async {
                        self.tableViewList.reloadData()
                    }
                    
                tableViewList.isHidden = true
               // self.getAllData(keyWord: "")
                    
                    
                }

            }
        }
        return true
    }
}
