//
//  ProductListVC.swift
//  LENZZO
//
//  Created by Apple on 8/16/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import UIKit
import Kingfisher
import AlamofireImage
import SwiftyJSON

protocol ReloadFamilyListDelegate
{
    func reloadDataSelected()
}
class ProductListVC: UIViewController,ReloadDataDelegate,ReloadProductDataDelegate,ReloadProductListDelegate,SelectedSortDelegate,FilterReloadDelegate {
    @IBOutlet weak var imageViewBackOption: UIImageView!
    
    var filterDicData = [String:String]()
    var arrTempSelectedRowAllData = Array<Any>()
    var arrayBrandSelected = [String]()
    var stringTitle = String()
    var brandId = String()
    var familyID = String()
    var delegateReloadData: ReloadFamilyListDelegate!
    
    var isFromCartList = Bool()
    var searchKeyWord = String()
    var paramOfAction = [String:String]()
    var APITypeAction = String()
    @IBOutlet weak var labelNotFound: UILabel!
    
    @IBOutlet weak var buttonMenu: UIButton!
    @IBOutlet weak var labelCountCart: UILabel!
    var currency = ""
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var productTableView: UITableView!
    
    @IBOutlet weak var labelTitle: PaddingLabel!
    
    @IBOutlet weak var cartBtn: UIButton!
    
    @IBOutlet weak var searchBtn: UIButton!
    
    @IBOutlet weak var sortTitleLbl: UILabel!
    @IBOutlet weak var filterTitleLbl: UILabel!
    
    @IBOutlet weak var sortImgView: UIImageView!
    
    @IBOutlet weak var filterImgView: UIImageView!
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    let numberOfItemsPerRow: CGFloat = 2
    let spacingBetweenCells: CGFloat = 10
    
    
    var selectedType = [String:String]()   //0 = "MSG226"   1= "MSG227"    2= "MSG228"
    let htmlfontStyle =  "<style>body{font-family:'FuturaBT-Medium'; font-size:'13.0';}</style>"
    
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
//        productTableView.delegate = self
//        productTableView.dataSource = self
        ProductListModel.sharedInstance.arrayProductList.removeAll()
       // self.productTableView.reloadData()
        self.collectionView.delegate = self
        self.collectionView.reloadData()
        self.collectionView.register(UINib(nibName: "ProductCVCellOffer", bundle: nil), forCellWithReuseIdentifier: "ProductCVCellOffer")
        
//        let layout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: spacingBetweenCells, left: spacingBetweenCells, bottom: spacingBetweenCells, right: spacingBetweenCells)
//        layout.minimumLineSpacing = spacingBetweenCells
//        layout.minimumInteritemSpacing = spacingBetweenCells
//        self.collectionView?.collectionViewLayout = layout
//        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
//
//                       let tablewidth = (UIScreen.main.bounds.width)/2
//                        let tableheight = tablewidth + tablewidth/2
//                       flowLayout.itemSize = CGSize(width: tablewidth, height: tableheight)
//                   }
        currency = KeyConstant.user_Default.value(forKey: KeyConstant.kSelectedCurrency) as! String
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
        self.buttonMenu.addTarget(self, action:#selector(backAction), for: .touchUpInside)
        self.initialSetUp()
        self.labelNotFound.isHidden = true
        
            self.changeTintAndThemeColor()
            
        self.labelNotFound.font = UIFont(name: FontLocalization.Bold.strValue, size: 15.0)
        self.labelTitle.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        
        self.displayProductList()
        }
        
        
        func changeTintAndThemeColor(){
            
            let img = UIImage(named: "search (1)")?.withRenderingMode(.alwaysTemplate)
            self.searchBtn.setImage(img, for: .normal)
            self.searchBtn.tintColor = .white
            
            let cartImg = UIImage(named: "cart")?.withRenderingMode(.alwaysTemplate)
            self.cartBtn.setImage(cartImg, for: .normal)
            self.cartBtn.tintColor = .white
            
            self.imageViewBackOption.image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate)
            self.imageViewBackOption.tintColor = .white
            
            
        }
    func updateSelected(index:[String:String])
    {
        selectedType = index
        //0 = "MSG226"   1= "MSG227"    2= "MSG228"
        displayProductList()
        
    }
    
    
    
//MARK:-  displayProductList
    func displayProductList()
    {
        ProductListModel.sharedInstance.arrayProductList.removeAll()
       // self.productTableView.reloadData()
        self.collectionView.reloadData()
        if(stringTitle == NSLocalizedString("MSG214", comment: ""))
        {
            //filter
            
            self.setFilterData()
            
        }
        else if(stringTitle == NSLocalizedString("MSG216", comment: "") && searchKeyWord.count > 0)
        {
            //search with all keyword
            setSearchList()
        }
        else if(stringTitle == NSLocalizedString("MSG216", comment: "") && searchKeyWord.count == 0)
        {
            //search with one selected data
            if(ProductListModel.sharedInstance.arrayProductList.count == 0)
            {
                self.labelNotFound.isHidden = false
            }
            else
            {
                self.labelNotFound.isHidden = true
                
            }
            
           // self.productTableView.reloadData()
            self.collectionView.reloadData()
        }
            //        else if(stringTitle == NSLocalizedString("MSG217", comment: ""))
            //        {
            //            //exclusive tag from left menu bar
            //            setExclusiveTagList()
            //
            //        }
            //        else if(stringTitle == NSLocalizedString("MSG218", comment: ""))
            //        {
            //            //latest tag from left menu bar
            //            setLatestTagList()
            //
            //        }
        else
        {
            //            ProductListModel.sharedInstance.arrayProductList.removeAll()
            //            self.collectionView.reloadData()
            
//            if(familyID.count > 0)
//            {
//                
//                self.setFamilyProductList()
//                
//            }
//            else if(self.brandId.count < 1)
//            {
//                //wishlist data
//               // self.setFavouriteList()
//            }
//            else
//            {
                //all normal data
                self.setProductList()
//            }
            
        }
        self.showCartCount()
    }
    
    func showCartCount()
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
    
    //    func getPowerList(indexTag:Int)
    //    {
    //
    //       if let dicProductList = ProductListModel.sharedInstance.arrayProductList[indexTag].dictionary
    //
    //       {
    //
    //        if(dicProductList["power_range"]?.array?.count ?? 0 > 0)
    //        {
    //            var arrayTempRange = [Double]()
    //            var arrayRange = [JSON]()
    //
    //            arrayRange = dicProductList["power_range"]?.array ?? [JSON]()
    //            for ind in 0..<arrayRange.count
    //            {
    //                arrayTempRange.insert(Double(arrayRange[ind].string ?? "0.00")?.roundTo(places: 2) ?? 0.0, at: arrayTempRange.count)
    //            }
    //
    //            if(!(arrayTempRange.contains(0.00)))
    //            {
    //                arrayTempRange.insert(0.00, at: 0)
    //            }
    //            arrayTempRange.sort()
    //            print(arrayTempRange)
    //            let powerSelectionVC = self.storyboard?.instantiateViewController(withIdentifier: "PowerSelectionVC") as! PowerSelectionVC
    //            powerSelectionVC.modalPresentationStyle = .overCurrentContext
    //            powerSelectionVC.delegatePower = self
    //            powerSelectionVC.leftPower =  0.0
    //            powerSelectionVC.rightPower =  0.0
    //            powerSelectionVC.leftPowerOutOfStock =  [String]()
    //            powerSelectionVC.rightPowerOutOfStock = [String]()
    //            if let leftOutStockRange = dicProductList["l_p_n_available"]?.string
    //            {
    //                if(leftOutStockRange.count > 0)
    //                {
    //                    powerSelectionVC.leftPowerOutOfStock =  leftOutStockRange.components(separatedBy: ",")
    //                }
    //            }
    //
    //            if let rightOutStockRange = dicProductList["r_p_n_available"]?.string
    //            {
    //                if(rightOutStockRange.count > 0)
    //                {
    //                    powerSelectionVC.rightPowerOutOfStock =  rightOutStockRange.components(separatedBy: ",")
    //                }
    //            }
    //            powerSelectionVC.arrayLeft = arrayTempRange
    //            powerSelectionVC.arrayRight =  arrayTempRange
    //            self.present(powerSelectionVC, animated: false, completion: nil)
    //
    //        }
    //
    //        }
    //
    //
    //
    //
    //    }
    
    func setSearchList()
    {
        var customParam:[String:String]!
        
        customParam = ["search_text":searchKeyWord]
        
        ProductListViewModel().getBrandCatProductList(vc: self, itemId: "", APIName: KeyConstant.APIBrandProductList, sortIndex: selectedType, customParam: customParam, filterParam: filterDicData, completionHandler: { (result:[JSON], success: Bool, errorC:Error?) in
            
            if(result.count == 0)
            {
                self.labelNotFound.isHidden = false
            }
            else
            {
                self.labelNotFound.isHidden = true
                
            }
            //self.productTableView.reloadData()
            self.collectionView.reloadData()
        } )
    }
    
    func setFilterData()
    {
                var customParam:[String:String]!
        
        customParam = ["search_text":searchKeyWord]
        var brand_id = ""
        if brandId.count > 0{
            brand_id = brandId
        }
        
        ProductListViewModel().getBrandCatProductList(vc: self, itemId: brand_id, APIName: KeyConstant.APIProductSearchByName, sortIndex: selectedType, customParam: customParam, filterParam: filterDicData, completionHandler: { (result:[JSON], success: Bool, errorC:Error?) in
            if(errorC != nil)
            {
                self.setFilterData()
                return
            }
            
            if(result.count == 0)
            {
                self.labelNotFound.isHidden = false
            }
            else
            {
                self.labelNotFound.isHidden = true
                
            }
            self.collectionView.reloadData()
           // self.productTableView.reloadData()
        } )
        
        
        
    }
    
    //    func setLatestTagList()
    //    {
    //
    //        var customParam:[String:String]!
    //
    //        customParam = ["tags":"new"]
    //
    //        ProductListViewModel().getBrandCatProductList(vc: self, itemId: "", APIName: KeyConstant.APIBrandProductList, sortIndex: selectedType, customParam: customParam, filterParam: filterDicData, completionHandler: { (result:[JSON], success: Bool, errorC:Error?) in
    //            self.collectionView.reloadData()
    //        } )
    //    }
    //
    //    func setExclusiveTagList()
    //    {
    //        var customParam:[String:String]!
    //
    //        customParam = ["tags":"exclusive"]
    //
    //        ProductListViewModel().getBrandCatProductList(vc: self, itemId: "", APIName: KeyConstant.APIBrandProductList, sortIndex: selectedType, customParam: customParam, filterParam: filterDicData, completionHandler: { (result:[JSON], success: Bool, errorC:Error?) in
    //            self.collectionView.reloadData()
    //        } )
    //
    //    }
    //
    
    
    //MARK:-  KeyConstant.APIBrandProductList
    
    
    
    
    
    func setProductList()
    {
        if(brandId.count > 0)
        {
            
            ProductListViewModel().getBrandCatProductList(vc: self, itemId: brandId, APIName: KeyConstant.APIProductSearchByName, sortIndex: selectedType, customParam: [:], filterParam: filterDicData, completionHandler: { (result:[JSON], success: Bool, errorC:Error?) in
                
                if(result.count == 0)
                {
                    self.labelNotFound.isHidden = false
                }
                else
                {
                    self.labelNotFound.isHidden = true
                    
                }
                //self.productTableView.reloadData()
                self.collectionView.reloadData()
            })
            
        }
    }
    
    func setFamilyProductList()
    {
        if(familyID.count > 0 && brandId.count > 0)
        {
            ProductListViewModel().getBrandCatProductList(vc: self, itemId: brandId, APIName: KeyConstant.APIProductSearchByName, sortIndex: selectedType, customParam: ["family_id":familyID], filterParam: filterDicData, completionHandler: { (result:[JSON], success: Bool, errorC:Error?) in
                
                if(result.count == 0)
                {
                    self.labelNotFound.isHidden = false
                }
                else
                {
                    self.labelNotFound.isHidden = true
                    
                }
               // self.productTableView.reloadData()
                self.collectionView.reloadData()
            })
        }
    }
    
    func setFavouriteList()
    {
        
        self.labelTitle.text = NSLocalizedString("MSG345", comment: "")
        ProductListViewModel().getBrandCatProductList(vc: self, itemId: brandId, APIName: KeyConstant.APIViewWishlist, sortIndex: selectedType, customParam: [:], filterParam: filterDicData, completionHandler: { (result:[JSON], success: Bool, errorC:Error?) in
            
            if(result.count == 0)
            {
                self.labelNotFound.isHidden = false
            }
            else
            {
                self.labelNotFound.isHidden = true
                
            }
           // self.collectionView.reloadData()
        })
        
    }
    
    
    
    
    //delegate method
    func reloadDataSelected() {
        self.showCartCount()
    }
    override func viewWillLayoutSubviews() {
        
    }
    override func viewDidLayoutSubviews() {
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
//        WishListModel.sharedInstance.arrayWishList.removeAll()
//        WishListViewModel().getAllWishlistProduct(vc: self, completionHandler: { (success: Bool, errorC:Error?) in
//            self.displayProductList()
//        })
        if(HelperArabic().isArabicLanguage())
               {
                self.imageViewBackOption.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
               }
               else
               {
               self.imageViewBackOption.transform = CGAffineTransform(rotationAngle: 245)
               }
       // self.displayProductList()
        
    }
    
    
    
    
    func initialSetUp(){
        
        let margin: CGFloat = 10
        let cellsPerRow = 2
        
        
        
        guard let collectionView = collectionView, let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.minimumInteritemSpacing = margin
        flowLayout.minimumLineSpacing = margin
        flowLayout.sectionInset = UIEdgeInsets(top: margin, left: 0, bottom: margin, right: 0)
        
        collectionView.contentInsetAdjustmentBehavior = .always
        let marginsAndInsets = flowLayout.sectionInset.left + flowLayout.sectionInset.right + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + flowLayout.minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
        let itemWidth = (((UIScreen.main.bounds.width - 15) - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            flowLayout.itemSize =  CGSize(width: itemWidth, height: itemWidth)
        }
        else
        {
            if(UIScreen.main.nativeBounds.height == 960 || UIScreen.main.nativeBounds.height == 1136)
            {
                flowLayout.itemSize =  CGSize(width: itemWidth - 10, height: (itemWidth - 10) * 2 + 60)
            }
            else
            {
                flowLayout.itemSize =  CGSize(width: itemWidth, height: itemWidth * 1.8)
            }
        }
    }
    @objc func rightSwip(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            self.backAction(sender: UIButton())
            
        }
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    @objc func backAction(sender:UIButton)
    {
        if(stringTitle == NSLocalizedString("MSG214", comment: "") || stringTitle == NSLocalizedString("MSG216", comment: "") || isFromCartList == true || stringTitle == NSLocalizedString("MSG217", comment: "") || stringTitle == NSLocalizedString("MSG218", comment: ""))
        {
            self.dismiss(animated: false, completion: {
                if(self.delegateReloadData != nil)
                {
                    self.delegateReloadData.reloadDataSelected()
                }
            })
            return
        }
        
        
        if(self.brandId.count < 1)
        {
            KeyConstant.sharedAppDelegate.setRoot()
        }
        else
        {
            self.dismiss(animated: false, completion: {
                if(self.delegateReloadData != nil)
                {
                    self.delegateReloadData.reloadDataSelected()
                }
            })
            
        }
    }
    
    @IBAction func buttonSearch(_ sender: Any) {
        
        if(stringTitle == NSLocalizedString("MSG216", comment: "") )
        {
            self.dismiss(animated: false, completion: nil)
            return
        }
        KeyConstant.sharedAppDelegate.showSearchScreen(vc: self)
        
    }
    @IBAction func buttoCart(_ sender: Any) {
        
        let myCartVC = self.storyboard?.instantiateViewController(withIdentifier: "MyCartVC") as! MyCartVC
        myCartVC.delegateReloadData = self
        self.present(myCartVC, animated: false, completion: nil)
    }
    @IBAction func buttoSort(_ sender: Any) {
        
        let myCartVC = self.storyboard?.instantiateViewController(withIdentifier: "SortListVC") as! SortListVC
        myCartVC.selectedType = selectedType
        myCartVC.delegateSort = self
        myCartVC.modalPresentationStyle = .overCurrentContext
        self.present(myCartVC, animated: false, completion: nil)
    }
    @IBAction func buttonFilter(_ sender: Any) {
        
        let filterVC = self.storyboard?.instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
        filterVC.delegateFilter = self
        filterVC.arrTempSelectedRowAllData = arrTempSelectedRowAllData
        var tempArrayBrandSelected = [String]()
        tempArrayBrandSelected = arrayBrandSelected
        filterVC.modalPresentationStyle = .overCurrentContext
        
                if(brandId.count > 0)
                {
                    if(!(tempArrayBrandSelected.contains(brandId)))
                    {
                        tempArrayBrandSelected.insert(brandId, at: tempArrayBrandSelected.count)
                    }
                }
        filterVC.arrayBrandSelected = tempArrayBrandSelected
        self.present(filterVC, animated: false, completion: nil)
        
    }
    
    func filterReload(title:String,dicData:[String:String], arrTempSelectedRowAllData: Array<Any>,arrayBrandSelected:[String] )
    {
        self.stringTitle = title
        self.filterDicData = dicData
        self.arrTempSelectedRowAllData = arrTempSelectedRowAllData
        self.arrayBrandSelected = arrayBrandSelected
//        self.labelTitle.text = NSLocalizedString("MSG214", comment: "")
//
//        if(self.brandId.count > 0)
//        {
//            if(arrayBrandSelected.count == 0)
//            {
//                self.filterDicData["brand_id"] = self.brandId
//                //self.labelTitle.text = stringTitle
//            }
//        }
//
//        WishListViewModel().getAllWishlistProduct(vc: self, completionHandler: { (success: Bool, errorC:Error?) in
//            self.displayProductList()
//        })
        
        
        self.displayProductList()
        
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
//extension ProductListVC: UICollectionViewDelegate,UICollectionViewDataSource
//{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
//        if(ProductListModel.sharedInstance.arrayProductList.count == 0)
//        {
//            //self.labelNotFound.isHidden = false
//            return 0
//        }
//        else
//        {
//            self.labelNotFound.isHidden = true
//
//        }
//        return ProductListModel.sharedInstance.arrayProductList.count
//
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let cell:ProductListCVCell!
//        cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCVCellOffer", for: indexPath) as? ProductListCVCell
//
//        if(indexPath.row < ProductListModel.sharedInstance.arrayProductList.count)
//        {
//            let dic = ProductListModel.sharedInstance.arrayProductList[indexPath.row]
//
//
//
//            if let offerAvailable = dic.offer_name
//            {
//                if(offerAvailable.count > 0)
//                {
//                    cell.offerHeightConstraint.constant = 30
//                    cell.labelOffer.text = offerAvailable
//                }
//                else
//
//                {
//                    cell.offerHeightConstraint.constant = 0
//                    cell.labelOffer.text = ""
//                }
//            }
//            else
//            {
//                cell.offerHeightConstraint.constant = 0
//                cell.labelOffer.text = ""
//            }
//
//
//            cell.labelProductName.text = dic.title
//            //cell.labelProductDetails.text = dic.description.html2String
//
//            cell.labelProductDetails.setHTML1(html:(dic.description) + self.htmlfontStyle)
//
//            var price = ""
//
//            if(self.currency.uppercased() == "KWD")
//            {
//                price = String(format:"%.3f",Double(dic.price)?.roundTo(places: 3) ?? 0.0)
//            }
//            else
//            {
//                price = String(format:"%.2f",Double(dic.price)?.roundTo(places: 2) ?? 0.0)
//
//            }
//            if (dic.sale_price.count > 0)
//            {
//                let sellPriceTemp  = Double(dic.sale_price) ?? 0.0
//                if(sellPriceTemp > 0.0)
//                {
//
//                    let combination = NSMutableAttributedString()
//                    var sprice = ""
//                    var tempPrice = 0.0
//                    var basePrice = 0.0
//
//                    if(self.currency.uppercased() == "KWD")
//                    {
//                        sprice = String(format:"%.3f",Double(dic.sale_price)?.roundTo(places: 3) ?? 0.0)
//                        tempPrice = Double(dic.sale_price)?.roundTo(places: 3) ?? 0.0
//                        basePrice = Double(dic.price)?.roundTo(places: 3) ?? 0.0
//
//                    }
//                    else
//                    {
//                        sprice = String(format:"%.2f",Double(dic.sale_price)?.roundTo(places: 2) ?? 0.0)
//                        tempPrice = Double(dic.sale_price)?.roundTo(places: 2) ?? 0.0
//                        basePrice = Double(dic.price)?.roundTo(places: 2) ?? 0.0
//
//
//
//                    }
//
//                    if(tempPrice < basePrice)
//                    {
//                        tempPrice = basePrice - tempPrice
//                        if(self.currency.uppercased() == "KWD")
//                        {
//                            sprice = String(format:"%.3f",Double(tempPrice).roundTo(places: 3) )
//                        }
//                        else
//                        {
//                            sprice = String(format:"%.2f",Double(tempPrice).roundTo(places: 2) )
//
//                        }
//
//                        combination.append(self.getSimpleText(price: sprice + "\(currency) "))
//                        combination.append(self.getStrikeText(price: price + self.currency ))
//
//                        cell.labelPrice.attributedText = combination
//                    }
//                    else
//                    {
//                        cell.labelPrice.text = price + " \(currency)"
//
//                    }
//
//
//                }
//                else
//                {
//                    cell.labelPrice.text = price + " \(currency)"
//                }
//            }
//            else
//            {
//                cell.labelPrice.text = price + " \(currency)"
//
//            }
//
//
//            if(dic.tags == "new")
//            {
//                cell.labelExclusive.isHidden = false
//                cell.labelExclusive.text = NSLocalizedString("MSG224", comment: "")
//            }
//            else if(dic.tags == "latest")
//            {
//                cell.labelExclusive.isHidden = false
//                cell.labelExclusive.text = NSLocalizedString("MSG224", comment: "")
//            }
//            else if(dic.tags == "exclusive")
//            {
//                cell.labelExclusive.isHidden = false
//                cell.labelExclusive.text = NSLocalizedString("MSG223", comment: "")
//
//            }
//            else
//            {
//                cell.labelExclusive.isHidden = true
//            }
//            //cell.imageViewProduct.contentMode = .scaleAspectFill
//
//            cell.imageViewProduct.contentMode = .scaleAspectFit
//
//            if let strUrl = dic.product_image
//            {
//                if(strUrl.count > 0)
//                {
//                    let urlString = strUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//                    let url = URL(string: KeyConstant.kImageBaseProductURL +  urlString!)
//                    let processor = DownsamplingImageProcessor(size:  cell.imageViewProduct.frame.size)
//                        >> RoundCornerImageProcessor(cornerRadius: 0)
//                    cell.imageViewProduct.kf.indicatorType = .none
//                    cell.imageViewProduct.kf.setImage(
//                        with: url,
//                        placeholder: UIImage(named: "noImage"),
//                        options: [
//                            .processor(processor),
//                            .scaleFactor(UIScreen.main.scale),
//                            .transition(.fade(1)),
//                            .cacheOriginalImage
//                    ])
//
//
//                }
//                else
//                {
//                    cell.imageViewProduct.image = UIImage(named: "noImage")
//
//                }
//            }
//            else
//            {
//                cell.imageViewProduct.image = UIImage(named: "noImage")
//
//            }
//
//
//            cell.imageFav.image = UIImage(named: "heart-s")
//            cell.buttonFav.tag = indexPath.item
//            cell.buttonFav.addTarget(self, action: #selector(buttonFav), for: .touchUpInside)
//            cell.buttonBuyNow.tag = indexPath.item
//            cell.buttonBuyNow.addTarget(self, action: #selector(buttonBuyNow), for: .touchUpInside)
//
//            cell.buttonBuyNow.isUserInteractionEnabled = true
//            cell.buttonBuyNow.setTitleColor(.white, for: .normal)
//
//
//            if(dic.cate_id == "2")
//            {
//                cell.buttonBuyNow.setTitle(NSLocalizedString("MSG357", comment: ""), for: .normal)
//            }
//            else
//            {
//                cell.buttonBuyNow.setTitle(NSLocalizedString("MSG194", comment: ""), for: .normal)
//
//            }
//
//            if let strQuantity = dic.quantity
//            {
//                if((Int(strQuantity) ?? 0) < 1 || strQuantity.count < 1)
//                {
//                    cell.buttonBuyNow.setTitle(NSLocalizedString("MSG195", comment: ""), for: .normal)
//                    cell.buttonBuyNow.isUserInteractionEnabled = false
//                    cell.buttonBuyNow.setTitleColor(.red, for: .normal)
//
//                }
//                else
//                {
//                    if let strStockFlag = dic.stock_flag
//
//                    {
//                        if((Int(strStockFlag) ?? 0) < 1 || strStockFlag.count < 1)
//                        {
//                            cell.buttonBuyNow.setTitle(NSLocalizedString("MSG195", comment: ""), for: .normal)
//                            cell.buttonBuyNow.isUserInteractionEnabled = false
//                            cell.buttonBuyNow.setTitleColor(.red, for: .normal)
//
//                        }
//
//
//                    }
//
//                }
//
//
//            }
//
//
//
//
//
//            if(WishListModel.sharedInstance.arrayWishList.count > 0)
//            {
//                for ind in 0..<WishListModel.sharedInstance.arrayWishList.count
//                {
//                    print("vdsfdsf \(WishListModel.sharedInstance.arrayWishList[ind].wishlistProductId)  \(dic.id)")
//                    if(WishListModel.sharedInstance.arrayWishList[ind].wishlistProductId == dic.id)
//                    {
//                        cell.imageFav.image = UIImage(named: "heart-fill")
//
//                    }
//                }
//
//
//            }
//
//
//
//        }
//        return cell
//
//    }
//
//
//
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
//    {
//        collectionView.deselectItem(at: indexPath, animated: false)
//
//
//        let brandVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC
//        brandVC.productId = ProductListModel.sharedInstance.arrayProductList[indexPath.item].id
//        brandVC.stringTitle = ProductListModel.sharedInstance.arrayProductList[indexPath.item].title
//        brandVC.delegateReloadData = self
//        self.present(brandVC, animated: false, completion: nil)
//
//    }
//
//    @objc func buttonFav(sender:UIButton)
//    {
//        var colorDefault = "Black"
//
//        let stringVariation = ProductListModel.sharedInstance.arrayProductList[sender.tag].variations
//
//        if((stringVariation?.count) ?? 0 > 0)
//        {
//            let arrayShade = stringVariation?.components(separatedBy: ",") ?? [String]()
//            if(arrayShade.count > 0)
//            {
//                colorDefault = arrayShade[0]
//            }
//        }
//
//
//        var paramOfAction: [String:String] = ["user_id":KeyConstant.sharedAppDelegate.getUserId(),"product_id":ProductListModel.sharedInstance.arrayProductList[sender.tag].id,"shade":colorDefault]
//
//        if(ProductListModel.sharedInstance.arrayProductList[sender.tag].start_range.count > 0)
//        {
//            paramOfAction["left_eye_power"] = "0.0"
//            paramOfAction["right_eye_power"] = "0.0"
//
//        }
//
//        WishListViewModel().addToWishlist(vc: self, param: paramOfAction) { (isDone:Bool, error:Error?) in
//
//
//            WishListViewModel().getAllWishlistProduct(vc: self, completionHandler: { (success: Bool, errorC:Error?) in
//                self.displayProductList()
//            })
//        }
//    }
//    func getStrikeText(price:String)-> NSMutableAttributedString
//    {
//        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: price)
//        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
//        return attributeString
//
//    }
//
//    func getSimpleText(price:String)-> NSMutableAttributedString
//    {
//        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: price)
//        return attributeString
//
//    }
//    @objc func buttonBuyNow(sender:UIButton)
//    {
//
//        if(ProductListModel.sharedInstance.arrayProductList[sender.tag].cate_id == "2")
//        {
//
//            let brandVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC
//            brandVC.productId = ProductListModel.sharedInstance.arrayProductList[sender.tag].id
//            brandVC.stringTitle = ProductListModel.sharedInstance.arrayProductList[sender.tag].title
//            brandVC.delegateReloadData = self
//            self.present(brandVC, animated: false, completion: nil)
//        }
//        else
//        {
//            var colorDefault = "Black"
//
//            let stringVariation = ProductListModel.sharedInstance.arrayProductList[sender.tag].variations
//
//            if((stringVariation?.count) ?? 0 > 0)
//            {
//                let arrayShade = stringVariation?.components(separatedBy: ",") ?? [String]()
//                if(arrayShade.count > 0)
//                {
//                    colorDefault = arrayShade[0]
//                }
//            }
//
//
//            paramOfAction = ["product_id":ProductListModel.sharedInstance.arrayProductList[sender.tag].id,"shade":colorDefault]
//
//            if(ProductListModel.sharedInstance.arrayProductList[sender.tag].start_range.count > 0)
//            {
//                paramOfAction["left_eye_power"] = "0.0"
//                paramOfAction["right_eye_power"] = "0.0"
//
//            }
//            APITypeAction = KeyConstant.APIAddCart
//
//            self.addToCart()
//
//        }
//    }
//
//    func checkoutAlertView()
//    {
//
//        let alert = UIAlertController(title: NSLocalizedString("MSG31", comment: "").uppercased(), message: "", preferredStyle: .alert)
//
//        let msgFont = [NSAttributedString.Key.font: UIFont(name: "Futura-Medium", size: 15.0)!]
//        let msgAttrString = NSMutableAttributedString(string: NSLocalizedString("MSG197", comment: ""), attributes: msgFont)
//        alert.setValue(msgAttrString, forKey: "attributedMessage")
//
//        let action1 = UIAlertAction(title: NSLocalizedString("MSG198", comment: ""), style: .default) { (action) in
//
//            self.showCartCount()
//
//        }
//
//        let action2 = UIAlertAction(title: NSLocalizedString("MSG199", comment: ""), style: .default) { (action) in
//
//            let myCartVC = self.storyboard?.instantiateViewController(withIdentifier: "MyCartVC") as! MyCartVC
//            myCartVC.delegateReloadData = self
//
//            self.present(myCartVC, animated: false, completion: nil)
//
//        }
//
//        alert.addAction(action1)
//        alert.addAction(action2)
//        action1.setValue(UIColor(red: 175.0/255.0, green: 148.0/255.0, blue: 50.0/255.0, alpha: 1.0), forKey: "titleTextColor")
//        action2.setValue(UIColor(red: 175.0/255.0, green: 148.0/255.0, blue: 50.0/255.0, alpha: 1.0), forKey: "titleTextColor")
//
//        alert.view.tintColor = UIColor.black
//        alert.view.layer.cornerRadius = 40
//        alert.view.backgroundColor = UIColor.white
//        DispatchQueue.main.async(execute: {
//            self.present(alert, animated: true, completion: nil)
//        })
//
//
//    }
//
//
//    func addToCart()
//    {
//
//
//        CartViewModel().addToCart(vc: self, param: ["user_id":KeyConstant.sharedAppDelegate.getUserId(),"product_id":paramOfAction["product_id"] ?? "","quantity":"1","shade":paramOfAction["shade"] ?? "","left_eye_power":paramOfAction["left_eye_power"] ?? "","right_eye_power":paramOfAction["right_eye_power"] ?? ""]) { (isDone:Bool, error:Error?) in
//
//
//            self.paramOfAction.removeAll()
//            self.APITypeAction = ""
//
//            if(isDone == true)
//            {
//                self.checkoutAlertView()
//            }
//            else
//            {
//                KeyConstant.sharedAppDelegate.showAlertView(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString:error?.localizedDescription ?? NSLocalizedString("MSG21", comment: ""))
//
//            }
//
//        }
//
//    }
//}



//extension ProductListVC:UITableViewDelegate,UITableViewDataSource{
//
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return ProductListModel.sharedInstance.arrayProductList.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ProdcutListTVCell", for: indexPath) as! ProdcutListTVCell
//        cell.productImgView.backgroundColor = .white
//
//        if(indexPath.row < ProductListModel.sharedInstance.arrayProductList.count)
//        {
//            let dic = ProductListModel.sharedInstance.arrayProductList[indexPath.row]
//
//
//            //
//            //            if let offerAvailable = dic.offer_name
//            //            {
//            //                if(offerAvailable.count > 0)
//            //                {
//            //                    cell.offerHeightConstraint.constant = 30
//            //                    cell.labelOffer.text = offerAvailable
//            //                }
//            //                else
//            //
//            //                {
//            //                    cell.offerHeightConstraint.constant = 0
//            //                    cell.labelOffer.text = ""
//            //                }
//            //            }
//            //            else
//            //            {
//            //                cell.offerHeightConstraint.constant = 0
//            //                cell.labelOffer.text = ""
//            //            }
//
//
//            cell.productNameLbl.text = dic.title
//            //cell.labelProductDetails.text = dic.description.html2String
//
//            //cell.labelProductDetails.setHTML1(html:(dic.description) + self.htmlfontStyle)
//
//            var price = ""
//
//            if(self.currency.uppercased() == "KWD")
//            {
//                price = String(format:"%.3f",Double(dic.price)?.roundTo(places: 3) ?? 0.0)
//            }
//            else
//            {
//                price = String(format:"%.2f",Double(dic.price)?.roundTo(places: 2) ?? 0.0)
//
//            }
//            if (dic.sale_price.count > 0)
//            {
//                let sellPriceTemp  = Double(dic.sale_price) ?? 0.0
//                if(sellPriceTemp > 0.0)
//                {
//
//                    let combination = NSMutableAttributedString()
//                    var sprice = ""
//                    var tempPrice = 0.0
//                    var basePrice = 0.0
//
//                    if(self.currency.uppercased() == "KWD")
//                    {
//                        sprice = String(format:"%.3f",Double(dic.sale_price)?.roundTo(places: 3) ?? 0.0)
//                        tempPrice = Double(dic.sale_price)?.roundTo(places: 3) ?? 0.0
//                        basePrice = Double(dic.price)?.roundTo(places: 3) ?? 0.0
//
//                    }
//                    else
//                    {
//                        sprice = String(format:"%.2f",Double(dic.sale_price)?.roundTo(places: 2) ?? 0.0)
//                        tempPrice = Double(dic.sale_price)?.roundTo(places: 2) ?? 0.0
//                        basePrice = Double(dic.price)?.roundTo(places: 2) ?? 0.0
//
//
//
//                    }
//
//                    if(tempPrice < basePrice)
//                    {
//                        tempPrice = basePrice - tempPrice
//                        if(self.currency.uppercased() == "KWD")
//                        {
//                            sprice = String(format:"%.3f",Double(tempPrice).roundTo(places: 3) )
//                        }
//                        else
//                        {
//                            sprice = String(format:"%.2f",Double(tempPrice).roundTo(places: 2) )
//
//                        }
//
//                        combination.append(self.getSimpleText(price: sprice + "\(currency) "))
//                        combination.append(self.getStrikeText(price: price + self.currency ))
//
//                        cell.productPriceLbl.attributedText = combination
//                    }
//                    else
//                    {
//                        cell.productPriceLbl.text = price + " \(currency)"
//
//                    }
//
//
//                }
//                else
//                {
//                    cell.productPriceLbl.text = price + " \(currency)"
//                }
//            }
//            else
//            {
//                cell.productPriceLbl.text = price + " \(currency)"
//
//            }
//
//
//            if(dic.tags == "new")
//            {
//                //                cell.labelExclusive.isHidden = false
//                //                cell.labelExclusive.text = NSLocalizedString("MSG224", comment: "")
//            }
//            else if(dic.tags == "latest")
//            {
//                //                cell.labelExclusive.isHidden = false
//                //                cell.labelExclusive.text = NSLocalizedString("MSG224", comment: "")
//            }
//            else if(dic.tags == "exclusive")
//            {
//                //                cell.labelExclusive.isHidden = false
//                //                cell.labelExclusive.text = NSLocalizedString("MSG223", comment: "")
//
//            }
//            else
//            {
//                // cell.labelExclusive.isHidden = true
//            }
//            //cell.imageViewProduct.contentMode = .scaleAspectFill
//
//            cell.productImgView.contentMode = .scaleToFill
//
//            if let strUrl = dic.product_image
//            {
//                if(strUrl.count > 0)
//                {
//                    let urlString = strUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//                    let url = URL(string: KeyConstant.kImageBaseProductURL +  urlString!)
//                    let processor = DownsamplingImageProcessor(size:  cell.productImgView.frame.size)
//                        >> RoundCornerImageProcessor(cornerRadius: 0)
//                    cell.productImgView.kf.indicatorType = .none
//                    cell.productImgView.kf.setImage(
//                        with: url,
//                        placeholder: UIImage(named: "noImage"),
//                        options: [
//                            .processor(processor),
//                            .scaleFactor(UIScreen.main.scale),
//                            .transition(.fade(1)),
//                            .cacheOriginalImage
//                    ])
//
//
//                }
//                else
//                {
//                    cell.productImgView.image = UIImage(named: "noImage")
//
//                }
//            }
//            else
//            {
//                cell.productImgView.image = UIImage(named: "noImage")
//
//            }
//
//
//            //            cell.imageFav.image = UIImage(named: "heart-s")
//            //            cell.buttonFav.tag = indexPath.item
//            //            cell.buttonFav.addTarget(self, action: #selector(buttonFav), for: .touchUpInside)
//            cell.addToCartBtn.tag = indexPath.item
//            cell.viewDetailBtn.tag = indexPath.item
//            cell.addToCartBtn.addTarget(self, action: #selector(buttonBuyNow), for: .touchUpInside)
//
//            cell.viewDetailBtn.addTarget(self, action: #selector(viewDetailBtnTapped), for: .touchUpInside)
//            cell.addToCartBtn.isUserInteractionEnabled = true
//            cell.addToCartBtn.setTitleColor(.white, for: .normal)
//
//
//            if(dic.cate_id == "2")
//            {
//                //View Detail MSG357 replace with add to cart MSG432
//                cell.viewDetailBtn.setTitle(NSLocalizedString("MSG432", comment: ""), for: .normal)
//                cell.viewDetailBtn.setTitleColor(.white, for: .normal)
//                cell.addToCartBtn.isHidden = true
//                cell.viewDetailBtn.isHidden = false
//            }
//            else
//            {
//                cell.addToCartBtn.setTitle(NSLocalizedString("MSG432", comment: ""), for: .normal)
//                cell.addToCartBtn.setTitleColor(.white, for: .normal)
//                cell.addToCartBtn.isHidden = false
//                cell.viewDetailBtn.isHidden = true
//            }
//
//            if let strQuantity = dic.quantity
//            {
//                if((Int(strQuantity) ?? 0) < 1 || strQuantity.count < 1)
//                {
//                    cell.addToCartBtn.setTitle(NSLocalizedString("MSG195", comment: ""), for: .normal)
//                    cell.addToCartBtn.isUserInteractionEnabled = false
//                    cell.addToCartBtn.setTitleColor(.white, for: .normal)
//
//                }
//                else
//                {
//                    if let strStockFlag = dic.stock_flag
//
//                    {
//                        if((Int(strStockFlag) ?? 0) < 1 || strStockFlag.count < 1)
//                        {
//                            cell.addToCartBtn.setTitle(NSLocalizedString("MSG195", comment: ""), for: .normal)
//                            cell.addToCartBtn.isUserInteractionEnabled = false
//                            cell.addToCartBtn.setTitleColor(.white, for: .normal)
//
//                        }
//
//
//                    }
//
//                }
//
//
//            }
//
//
//
//
//
//            //            if(WishListModel.sharedInstance.arrayWishList.count > 0)
//            //            {
//            //                for ind in 0..<WishListModel.sharedInstance.arrayWishList.count
//            //                {
//            //                    print("vdsfdsf \(WishListModel.sharedInstance.arrayWishList[ind].wishlistProductId)  \(dic.id)")
//            //                    if(WishListModel.sharedInstance.arrayWishList[ind].wishlistProductId == dic.id)
//            //                    {
//            //                        cell.imageFav.image = UIImage(named: "heart-fill")
//            //
//            //                    }
//            //                }
//            //
//            //
//            //            }
//
//
//
//        }
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        let brandVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC
//        brandVC.productId = ProductListModel.sharedInstance.arrayProductList[indexPath.row].id
//        brandVC.stringTitle = ProductListModel.sharedInstance.arrayProductList[indexPath.row].title
//        brandVC.delegateReloadData = self
//        self.present(brandVC, animated: false, completion: nil)
//
//    }
//
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//
//
//    func getSimpleText(price:String)-> NSMutableAttributedString
//    {
//        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: price)
//        return attributeString
//
//    }
//
//    func getStrikeText(price:String)-> NSMutableAttributedString
//    {
//        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: price)
//        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
//        return attributeString
//
//    }
//
//    @objc func buttonBuyNow(sender:UIButton)
//    {
//
//        if(ProductListModel.sharedInstance.arrayProductList[sender.tag].cate_id == "2")
//        {
//
//            let brandVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC
//            brandVC.productId = ProductListModel.sharedInstance.arrayProductList[sender.tag].id
//            brandVC.stringTitle = ProductListModel.sharedInstance.arrayProductList[sender.tag].title
//            brandVC.delegateReloadData = self
//            self.present(brandVC, animated: false, completion: nil)
//        }
//        else
//        {
//            var colorDefault = "Black"
//
//            let stringVariation = ProductListModel.sharedInstance.arrayProductList[sender.tag].variations
//
//            if((stringVariation?.count) ?? 0 > 0)
//            {
//                let arrayShade = stringVariation?.components(separatedBy: ",") ?? [String]()
//                if(arrayShade.count > 0)
//                {
//                    colorDefault = arrayShade[0]
//                }
//            }
//
//
//            paramOfAction = ["product_id":ProductListModel.sharedInstance.arrayProductList[sender.tag].id,"shade":colorDefault]
//
//            if(ProductListModel.sharedInstance.arrayProductList[sender.tag].start_range.count > 0)
//            {
//                paramOfAction["left_eye_power"] = "0.0"
//                paramOfAction["right_eye_power"] = "0.0"
//
//            }
//            APITypeAction = KeyConstant.APIAddCart
//
//            self.addToCart()
//
//        }
//    }
//
//
//    @objc func viewDetailBtnTapped(sender:UIButton)
//    {
//
////        let brandVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC
////        brandVC.productId = ProductListModel.sharedInstance.arrayProductList[sender.tag].id
////        brandVC.stringTitle = ProductListModel.sharedInstance.arrayProductList[sender.tag].title
////        brandVC.delegateReloadData = self
////        self.present(brandVC, animated: false, completion: nil)
//
//            var colorDefault = "Black"
//
//            let stringVariation = ProductListModel.sharedInstance.arrayProductList[sender.tag].variations
//
//            if((stringVariation?.count) ?? 0 > 0)
//            {
//                let arrayShade = stringVariation?.components(separatedBy: ",") ?? [String]()
//                if(arrayShade.count > 0)
//                {
//                    colorDefault = arrayShade[0]
//                }
//            }
//
//
//            paramOfAction = ["product_id":ProductListModel.sharedInstance.arrayProductList[sender.tag].id,"shade":colorDefault]
//
//            if(ProductListModel.sharedInstance.arrayProductList[sender.tag].start_range.count > 0)
//            {
//                paramOfAction["left_eye_power"] = "0.0"
//                paramOfAction["right_eye_power"] = "0.0"
//
//            }
//            APITypeAction = KeyConstant.APIAddCart
//
//            self.addToCart()
//
//
//    }
//
//
//
//
//
//    func checkoutAlertView()
//    {
//
//        let alert = UIAlertController(title: NSLocalizedString("MSG31", comment: "").uppercased(), message: "", preferredStyle: .alert)
//
//        let msgFont = [NSAttributedString.Key.font: UIFont(name: FontLocalization.medium.strValue, size: 15.0)!]
//        let msgAttrString = NSMutableAttributedString(string: NSLocalizedString("MSG197", comment: ""), attributes: msgFont)
//        alert.setValue(msgAttrString, forKey: "attributedMessage")
//
//        let action1 = UIAlertAction(title: NSLocalizedString("MSG198", comment: ""), style: .default) { (action) in
//
//            self.showCartCount()
//
//        }
//
//        let action2 = UIAlertAction(title: NSLocalizedString("MSG199", comment: ""), style: .default) { (action) in
//
//            let myCartVC = self.storyboard?.instantiateViewController(withIdentifier: "MyCartVC") as! MyCartVC
//            myCartVC.delegateReloadData = self
//
//            self.present(myCartVC, animated: false, completion: nil)
//
//        }
//
//        alert.addAction(action1)
//        alert.addAction(action2)
//        action1.setValue(AppColors.SelcetedColor, forKey: "titleTextColor")
//        action2.setValue(AppColors.SelcetedColor, forKey: "titleTextColor")
//
//        alert.view.tintColor = UIColor.black
//        alert.view.layer.cornerRadius = 40
//        alert.view.backgroundColor = UIColor.white
//        DispatchQueue.main.async(execute: {
//            self.present(alert, animated: true, completion: nil)
//        })
//
//
//    }
//
//
//    func addToCart()
//    {
//
//
//        CartViewModel().addToCart(vc: self, param: ["user_id":KeyConstant.sharedAppDelegate.getUserId(),"product_id":paramOfAction["product_id"] ?? "","quantity":"1","shade":paramOfAction["shade"] ?? "","left_eye_power":paramOfAction["left_eye_power"] ?? "","right_eye_power":paramOfAction["right_eye_power"] ?? ""]) { (isDone:Bool, error:Error?) in
//
//
//            self.paramOfAction.removeAll()
//            self.APITypeAction = ""
//
//            if(isDone == true)
//            {
//                self.showCartCount()
//                self.checkoutAlertView()
//            }
//            else
//            {
//                KeyConstant.sharedAppDelegate.showAlertView(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString:error?.localizedDescription ?? NSLocalizedString("MSG21", comment: ""))
//
//            }
//
//        }
//
//    }
//
//
//
//
//
//
//}


extension ProductListVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ProductListModel.sharedInstance.arrayProductList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
            let cell:ProductListCVCell!
            cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCVCellOffer", for: indexPath) as? ProductListCVCell
        cell.addtoCartView.layer.roundCorners(corners: [.topLeft], radius: 5.0)
            if(indexPath.row < ProductListModel.sharedInstance.arrayProductList.count)
            {
                let dic = ProductListModel.sharedInstance.arrayProductList[indexPath.row]
                cell.labelProductName.text = dic.title
    
                var price = ""
    
                if(self.currency.uppercased() == "KWD")
                {
                    price = String((dic.price as NSString).integerValue)
                    //String(format:"%.3f",Double(dic.price)?.roundTo(places: 3) ?? 0.0)
                }
                else
                {
                    price = String((dic.price as NSString).integerValue)//String(format:"%.2f",Double(dic.price)?.roundTo(places: 2) ?? 0.0)
    
                }
                if (dic.sale_price.count > 0)
                {
                    let sellPriceTemp  = Double(dic.sale_price) ?? 0.0
                    if(sellPriceTemp > 0.0)
                    {
    
                        let combination = NSMutableAttributedString()
                        var sprice = ""
                        var tempPrice = 0.0
                        var basePrice = 0.0
    
                        if(self.currency.uppercased() == "KWD")
                        {
                            sprice = String(format:"%.3f",Double(dic.sale_price)?.roundTo(places: 3) ?? 0.0)
                            tempPrice = Double(dic.sale_price)?.roundTo(places: 3) ?? 0.0
                            basePrice = Double(dic.price)?.roundTo(places: 3) ?? 0.0
    
                        }
                        else
                        {
                            sprice = String(format:"%.2f",Double(dic.sale_price)?.roundTo(places: 2) ?? 0.0)
                            tempPrice = Double(dic.sale_price)?.roundTo(places: 2) ?? 0.0
                            basePrice = Double(dic.price)?.roundTo(places: 2) ?? 0.0
    
    
    
                        }
    
                        if(tempPrice < basePrice)
                        {
                            tempPrice = basePrice - tempPrice
                            if(self.currency.uppercased() == "KWD")
                            {
                                sprice = "\(Int(tempPrice))"//String(format:"%.3f",Double(tempPrice).roundTo(places: 3) )
                            }
                            else
                            {
                                sprice = "\(Int(tempPrice))"//String(format:"%.2f",Double(tempPrice).roundTo(places: 2) )
    
                            }
    
                            combination.append(self.getSimpleText(price: sprice + "\(currency) "))
                            combination.append(self.getStrikeText(price: price + self.currency ))
    
                            cell.productPriceLbl.attributedText = combination
                        }
                        else
                        {
                            cell.productPriceLbl.text = price + " \(currency)"
    
                        }
    
    
                    }
                    else
                    {
                        cell.productPriceLbl.text = price + " \(currency)"
                    }
                }
                else
                {
                    cell.productPriceLbl.text = price + " \(currency)"
    
                }
    
    
                cell.imageViewProduct.contentMode = .scaleToFill
    
                if let strUrl = dic.product_image
                {
                    if(strUrl.count > 0)
                    {
                        let urlString = strUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                        let url = URL(string: KeyConstant.kImageBaseProductURL +  urlString!)
                        let processor = DownsamplingImageProcessor(size:  cell.imageViewProduct.frame.size)
                            >> RoundCornerImageProcessor(cornerRadius: 0)
                        cell.imageViewProduct.kf.indicatorType = .none
                        cell.imageViewProduct.kf.setImage(
                            with: url,
                            placeholder: UIImage(named: "noImage"),
                            options: [
                                .processor(processor),
                                .scaleFactor(UIScreen.main.scale),
                                .transition(.fade(1)),
                                .cacheOriginalImage
                        ])
    
    
                    }
                    else
                    {
                        cell.imageViewProduct.image = UIImage(named: "noImage")
    
                    }
                }
                else
                {
                    cell.imageViewProduct.image = UIImage(named: "noImage")
    
                }
    
    
                
                cell.addtoCartBtn.tag = indexPath.item
                cell.addtoCartBtn.addTarget(self, action: #selector(buttonBuyNow), for: .touchUpInside)
    
                cell.addtoCartBtn.isUserInteractionEnabled = true
                cell.addtoCartBtn.setTitleColor(UIColor(hexString: "8BC6E9"), for: .normal)
    
    
                if(dic.cate_id == "2")
                {
                   // cell.addtoCartLbl.setTitle(NSLocalizedString("MSG432", comment: ""), for: .normal)
                    cell.addtoCartLbl.text = NSLocalizedString("MSG432", comment: "")
                }
                else
                {
                  //  cell.addtoCartLbl.setTitle(NSLocalizedString("MSG432", comment: ""), for: .normal)
                    cell.addtoCartLbl.text = NSLocalizedString("MSG432", comment: "")

                }
    
                if let strQuantity = dic.quantity
                {
                    if((Int(strQuantity) ?? 0) < 1 || strQuantity.count < 1)
                    {
                      //  cell.addtoCartLbl.setTitle(NSLocalizedString("MSG195", comment: ""), for: .normal)
                        cell.addtoCartLbl.text = NSLocalizedString("MSG195", comment: "")
                        cell.addtoCartBtn.isUserInteractionEnabled = false
                        cell.addtoCartLbl.textColor = UIColor(hexString: "8BC6E9")//.white
    
                    }
                    else
                    {
                        if let strStockFlag = dic.stock_flag
    
                        {
                            if((Int(strStockFlag) ?? 0) < 1 || strStockFlag.count < 1)
                            {
                               // cell.addtoCartLbl.setTitle(NSLocalizedString("MSG195", comment: ""), for: .normal)
                                cell.addtoCartLbl.text = NSLocalizedString("MSG195", comment: "")
                                cell.addtoCartBtn.isUserInteractionEnabled = false
                               // cell.addtoCartLbl.setTitleColor(.white, for: .normal)
                                cell.addtoCartLbl.textColor = UIColor(hexString: "8BC6E9")//.white
    
                            }
    
    
                        }
    
                    }
    
    
                }
    
    
            }
            return cell
    
        }
 
    

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let brandVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC
        brandVC.productId = ProductListModel.sharedInstance.arrayProductList[indexPath.row].id
        brandVC.stringTitle = ProductListModel.sharedInstance.arrayProductList[indexPath.row].title
        brandVC.delegateReloadData = self
        self.present(brandVC, animated: false, completion: nil)
        
    }
    
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         let totalSpacing = (2 * sectionInsets.left) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row

            let width = (UIScreen.main.bounds.width - totalSpacing)/numberOfItemsPerRow
             return CGSize(width: width, height: width + width/2)
     }

     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
         return sectionInsets
     }

     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         return spacingBetweenCells
     }
    
    func getSimpleText(price:String)-> NSMutableAttributedString
    {
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: price)
        return attributeString
        
    }
    
    func getStrikeText(price:String)-> NSMutableAttributedString
    {
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: price)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
        return attributeString
        
    }
    
    @objc func buttonBuyNow(sender:UIButton)
    {
        
        if(ProductListModel.sharedInstance.arrayProductList[sender.tag].cate_id == "2")
        {
            
            let brandVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC
            brandVC.productId = ProductListModel.sharedInstance.arrayProductList[sender.tag].id
            brandVC.stringTitle = ProductListModel.sharedInstance.arrayProductList[sender.tag].title
            brandVC.delegateReloadData = self
            self.present(brandVC, animated: false, completion: nil)
        }
        else
        {
            var colorDefault = "Black"
            
            let stringVariation = ProductListModel.sharedInstance.arrayProductList[sender.tag].variations
            
            if((stringVariation?.count) ?? 0 > 0)
            {
                let arrayShade = stringVariation?.components(separatedBy: ",") ?? [String]()
                if(arrayShade.count > 0)
                {
                    colorDefault = arrayShade[0]
                }
            }
            
            
            paramOfAction = ["product_id":ProductListModel.sharedInstance.arrayProductList[sender.tag].id,"shade":colorDefault]
            
            if(ProductListModel.sharedInstance.arrayProductList[sender.tag].start_range.count > 0)
            {
                paramOfAction["left_eye_power"] = "0.0"
                paramOfAction["right_eye_power"] = "0.0"
                
            }
            APITypeAction = KeyConstant.APIAddCart
            
            self.addToCart()
            
        }
    }
    
    
    @objc func viewDetailBtnTapped(sender:UIButton)
    {
        
//        let brandVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC
//        brandVC.productId = ProductListModel.sharedInstance.arrayProductList[sender.tag].id
//        brandVC.stringTitle = ProductListModel.sharedInstance.arrayProductList[sender.tag].title
//        brandVC.delegateReloadData = self
//        self.present(brandVC, animated: false, completion: nil)
        
            var colorDefault = "Black"
            
            let stringVariation = ProductListModel.sharedInstance.arrayProductList[sender.tag].variations
            
            if((stringVariation?.count) ?? 0 > 0)
            {
                let arrayShade = stringVariation?.components(separatedBy: ",") ?? [String]()
                if(arrayShade.count > 0)
                {
                    colorDefault = arrayShade[0]
                }
            }
            
            
            paramOfAction = ["product_id":ProductListModel.sharedInstance.arrayProductList[sender.tag].id,"shade":colorDefault]
            
            if(ProductListModel.sharedInstance.arrayProductList[sender.tag].start_range.count > 0)
            {
                paramOfAction["left_eye_power"] = "0.0"
                paramOfAction["right_eye_power"] = "0.0"
                
            }
            APITypeAction = KeyConstant.APIAddCart
            
            self.addToCart()
            
        
    }
    
    
    
    
    
    func checkoutAlertView()
    {
        
        let alert = UIAlertController(title: NSLocalizedString("MSG31", comment: "").uppercased(), message: "", preferredStyle: .alert)
        
        let msgFont = [NSAttributedString.Key.font: UIFont(name: FontLocalization.medium.strValue, size: 15.0)!]
        let msgAttrString = NSMutableAttributedString(string: NSLocalizedString("MSG197", comment: ""), attributes: msgFont)
        alert.setValue(msgAttrString, forKey: "attributedMessage")
        
        let action1 = UIAlertAction(title: NSLocalizedString("MSG198", comment: ""), style: .default) { (action) in
            
            self.showCartCount()
            
        }
        
        let action2 = UIAlertAction(title: NSLocalizedString("MSG199", comment: ""), style: .default) { (action) in
            
            let myCartVC = self.storyboard?.instantiateViewController(withIdentifier: "MyCartVC") as! MyCartVC
            myCartVC.delegateReloadData = self
            
            self.present(myCartVC, animated: false, completion: nil)
            
        }
        
        alert.addAction(action1)
        alert.addAction(action2)
        action1.setValue(AppColors.SelcetedColor, forKey: "titleTextColor")
        action2.setValue(AppColors.SelcetedColor, forKey: "titleTextColor")
        
        alert.view.tintColor = UIColor.black
        alert.view.layer.cornerRadius = 40
        alert.view.backgroundColor = UIColor.white
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true, completion: nil)
        })
        
        
    }
    
    
    func addToCart()
    {
        
        
        CartViewModel().addToCart(vc: self, param: ["user_id":KeyConstant.sharedAppDelegate.getUserId(),"product_id":paramOfAction["product_id"] ?? "","quantity":"1","shade":paramOfAction["shade"] ?? "","left_eye_power":paramOfAction["left_eye_power"] ?? "","right_eye_power":paramOfAction["right_eye_power"] ?? ""]) { (isDone:Bool, error:Error?) in
            
            
            self.paramOfAction.removeAll()
            self.APITypeAction = ""
            
            if(isDone == true)
            {
                self.showCartCount()
                self.checkoutAlertView()
            }
            else
            {
                KeyConstant.sharedAppDelegate.showAlertView(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString:error?.localizedDescription ?? NSLocalizedString("MSG21", comment: ""))
                
            }
            
        }
        
    }
    
    

    
    
    
}
