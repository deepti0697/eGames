//
//  HomeVC.swift
//  LENZZO
//
//  Created by Apple on 8/13/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import UIKit
import Kingfisher
import AlamofireImage
import MBProgressHUD
import SwiftyGif
import SwiftyJSON
class HomeVC: UIViewController {
    @IBOutlet weak var buttonMenu: UIButton!
    @IBOutlet weak var carouselView: AACarousel!
    var indexCurrent = 0
    var catBanner = [String]()
    var categoryArray = [String]()
    var strWhatsappNumber = String()
    
    @IBOutlet weak var labelCountCart: UILabel!
    
    
    @IBOutlet weak var imageViewLogo: UIImageView!
    
    
    @IBOutlet weak var tableHCons: NSLayoutConstraint!
    @IBOutlet weak var labelNotFound: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var whatsappContainerView: UIView!
    let topPadding = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.labelNotFound.isHidden = true
        self.tableView.isHidden = true
//        let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
//        statusBar?.backgroundColor = UIColor.clear
        if(HelperArabic().isArabicLanguage())
        {
            
            self.buttonMenu.addTarget(self, action:#selector(toggleRight), for: .touchUpInside)
        }
        else{
            
            self.buttonMenu.addTarget(self, action:#selector(toggleLeft), for: .touchUpInside)
        }
        carouselView.tag = 10
        
        
        carouselView.setCarouselData(paths: [String](),  describedTitle: [], isAutoScroll: true, timer: 1.0, defaultImage: "noImage")
        carouselView.setCarouselOpaque(layer: false, describedTitle: false, pageIndicator: false)
        carouselView.setCarouselLayout(displayStyle: 0, pageIndicatorPositon: 2, pageIndicatorColor: AppColors.SelcetedColor, describedTitleColor: nil, layerColor: .clear)
        
        
        
//        WishListViewModel().getAllWishlistProduct(vc: self, completionHandler: { (success: Bool, errorC:Error?) in
//            print(WishListModel.sharedInstance.arrayWishList.count)
//
//        })
        labelCountCart.text = ""
        
        if let guest = KeyConstant.user_Default.value(forKey: KeyConstant.kFromGuestCheckoutLogin) as? String
        {
            if(guest == "yes")
            {
                
                let myCartVC = self.storyboard?.instantiateViewController(withIdentifier: "MyCartVC") as! MyCartVC
                myCartVC.isFromGuestLogin = true
                KeyConstant.user_Default.removeObject(forKey: KeyConstant.kFromGuestCheckoutLogin)
                DispatchQueue.main.async {
                    
                    self.present(myCartVC, animated: false, completion: nil)
                }
            }
            
        }
        else
        {
            if let kpush_notification_offerid = KeyConstant.user_Default.value(forKey: KeyConstant.kpush_notification_offerid) as? String
            {
                self.tabBarController?.selectedIndex = 2
                
                let offerVC = self.storyboard?.instantiateViewController(withIdentifier: "OffersHomeVC") as! OffersHomeVC
                self.definesPresentationContext = true
                offerVC.modalPresentationStyle = .overCurrentContext
                offerVC.offerID = kpush_notification_offerid
                DispatchQueue.main.async {
                    
                    self.present(offerVC, animated: false, completion: {
                        KeyConstant.user_Default.removeObject(forKey: KeyConstant.kpush_notification_offerid)
                    })
                }
            }
                
            else if let push_notification_myorder = KeyConstant.user_Default.value(forKey: KeyConstant.push_notification_myorder) as? String
            {
                self.tabBarController?.selectedIndex = 3
                let brandVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderHistoryVC") as! OrderHistoryVC
                self.definesPresentationContext = true
                brandVC.modalPresentationStyle = .overCurrentContext
                DispatchQueue.main.async {
                    
                    self.present(brandVC, animated: false, completion: {
                        KeyConstant.user_Default.removeObject(forKey: KeyConstant.push_notification_myorder)
                        
                    })
                }
            }
            
        }
        
        
        self.view.backgroundColor = AppColors.themeColor
        // var timer = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        
        
        //  tableView.rowHeight = UITableView.automaticDimension
        //  tableView.estimatedRowHeight = UITableView.automaticDimension
        
        // Do any additional setup after loading the view.
       // carouselView.setGradientBackground(layerFrame: self.carouselView.bounds)
        carouselView.setGradientBackground(layerFrame: self.carouselView.bounds, isTopGradient: false)
        carouselView.frame.size.height = 200 + topPadding
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func update()
    {
        CartViewModel().viewCartListWithoutLoader(vc: self, param: ["user_id":KeyConstant.sharedAppDelegate.getUserId()], completionHandler: { (result:[JSON],totalCount:String ,error:Error?) in
            
            self.labelCountCart.text = ""
            if(result.count > 0)
            {
                print(result.count)
                self.labelCountCart.text = totalCount
                
               
            }
            
            
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        HomeModelView().getAllHomeInfo(vc: self, completionHandler: { (success: Bool, errorC:Error?) in
            
            self.setSlider()
            self.setBanner()
            self.setProduct()
            if(self.categoryArray.count == 0)
            {
                self.labelNotFound.isHidden = false
                self.tableView.isHidden = true
            }
            else
            {
                self.labelNotFound.isHidden = true
                self.tableView.isHidden = false
                
            }
            self.tableView.reloadData()
        })
        CartViewModel().viewCartList(vc: self, param: ["user_id":KeyConstant.sharedAppDelegate.getUserId()], completionHandler: { (result:[JSON], totalCount:String ,error:Error?) in

            self.labelCountCart.text = ""




            if(result.count > 0)
            {
                print(result.count)
                self.labelCountCart.text = totalCount
                if (totalCount as NSString).integerValue > 0{
                                   if let tabItems = self.tabBarController?.tabBar.items {
                                       // In this case we want to modify the badge number of the forth tab:
                                       let tabItem = tabItems[3]
                                       tabItem.badgeValue = totalCount
                                   }
                               }
                               else{
                                   if let tabItems = self.tabBarController?.tabBar.items {
                                                         // In this case we want to modify the badge number of the forth tab:
                                                         let tabItem = tabItems[3]
                                                         tabItem.badgeValue = nil
                                                     }
                               }
            }})
        
       // self.view.bringSubviewToFront(self.whatsappContainerView)
        self.whatsappContainerView.isHidden = true
        
    }
    override func viewDidLayoutSubviews() {
        
        //        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        //        {
        //             heightConstant.constant = carouselView.frame.width / 5
        //
        //        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       // carouselView.setGradientBackground(colorTop: .clear, colorBottom: UIColor(white: 0, alpha: 0.6))
    }
    
    

    
    @IBAction func websiteLinkAction(_ sender: UIButton) {
        
        //        if let url = URL(string: "http://www.kdakw.com/") {
        //            UIApplication.shared.open(url)
        //        }
        
        
        if let url = URL(string: "http://www.kdakw.com/") {
            if UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
    
    
    @IBAction func searchBarBtnAction(_ sender: Any) {
        
        KeyConstant.sharedAppDelegate.showSearchScreen(vc: self)
    }
    
    
    @IBAction func buttonWhatsapp(_ sender: Any) {
        
        if(strWhatsappNumber.count > 0)
        {
            self.openWhatsapp()
        }
        else
        {
            self.getContactsData()
        }
        
    }
    
    
    func setBanner()
    {
        if(HomeInfoModel.sharedInstance.arrayBanner.count > 0)
        {
            catBanner.removeAll()
            for ind in 0..<HomeInfoModel.sharedInstance.arrayBanner.count
            {
                if(catBanner.count > 3)
                {
                    break
                    
                }
                else{
                    
                    catBanner.insert(KeyConstant.kImageBaseBannerSliderURL + HomeInfoModel.sharedInstance.arrayBanner[ind].path, at: catBanner.count)
                    
                }
            }
        }
    }
    func setSlider()
    {
        
        if(HomeInfoModel.sharedInstance.arraySlider.count > 0)
        {
            
            carouselView.delegate = self
            print(HomeInfoModel.sharedInstance.arraySlider)
            var imageArray = [String]()
            
            for ind in 0..<HomeInfoModel.sharedInstance.arraySlider.count
            {
                imageArray.insert(KeyConstant.kImageBaseBannerSliderURL + HomeInfoModel.sharedInstance.arraySlider[ind].path, at: imageArray.count)
            }
            
            carouselView.setCarouselData(paths: imageArray,  describedTitle: [], isAutoScroll: true, timer: 4.0, defaultImage: "noImage")
        }
        
        carouselView.setCarouselOpaque(layer: false, describedTitle: false, pageIndicator: false)
        carouselView.setCarouselLayout(displayStyle: 0, pageIndicatorPositon: 2, pageIndicatorColor: nil, describedTitleColor: nil, layerColor: .clear)
        
    }
    func setProduct()
    {
        if(HomeInfoModel.sharedInstance.arrayProduct.count > 0)
        {
            categoryArray.removeAll()
            
            for ind in 0..<HomeInfoModel.sharedInstance.arrayProduct.count
            {
                categoryArray.insert(HomeInfoModel.sharedInstance.arrayProduct[ind].categoryName, at: categoryArray.count)
            }
        }
        
        if(HomeInfoModel.sharedInstance.appHeaderLogo.count > 0)
        {
            let urlString = HomeInfoModel.sharedInstance.appHeaderLogo.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            
            imageViewLogo.kf.setImage(with: URL(string: urlString!)!, placeholder: UIImage.init(named: "logo (3)"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: { (downloadImage, error, cacheType, url) in
                if(downloadImage != nil)
                {
                    self.imageViewLogo.image = downloadImage
                }
            })
        }
    }
    
  /// func setTopBrand
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}


//MARK:-  UITableViewDelegate, UITableViewDataSource


extension HomeVC:UITableViewDelegate, UITableViewDataSource
{
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categoryArray.count + 2 + 2//7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1//categoryArray.count + catBanner.count //7//
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCategoryTVCellTopSelling") as! HomeCategoryTVCell
            cell.collectionView.tag = indexPath.section
            cell.delegate = self
            //UIFont(name: "futura-medium-bt", size: 20.0)!
            //UIFont(name: "futura-medium-bt", size: 20.0)!
            //"BEST SELLING".uppercased()
            let attributedString = NSMutableAttributedString(string: NSLocalizedString("MSG433", comment: "").uppercased() , attributes: [
                .font: UIFont(name: FontLocalization.medium.strValue, size: 17.0)!,
              .foregroundColor: UIColor(white: 1.0, alpha: 1.0)
            ])
            attributedString.addAttributes([
              .font: UIFont(name: FontLocalization.medium.strValue, size: 17.0)!,
              .foregroundColor: UIColor(white: 1.0, alpha: 1.0)
            ], range: NSRange(location: 0, length: 4))
            cell.labelCategoryName.attributedText = attributedString
            cell.collectionView.reloadData()
            
            return cell
        }
        else if  indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCategoryTVCellTopBrand") as! HomeCategoryTVCell
            cell.collectionView.tag = indexPath.section
             cell.delegate = self
            //was MSG434 top brands
            let attributedString = NSMutableAttributedString(string: NSLocalizedString("MSG439", comment: "").uppercased(), attributes: [
              .font: UIFont(name: FontLocalization.medium.strValue, size: 17.0)!,
              .foregroundColor: UIColor(white: 1.0, alpha: 1.0)
            ])
            
            //used for top brands red color ,.foregroundColor: UIColor(red: 248.0 / 255.0, green: 0.0, blue: 0.0, alpha: 1.0)
            attributedString.addAttributes([
              .font: UIFont(name: FontLocalization.medium.strValue, size: 17.0)!,.foregroundColor: UIColor(white: 1.0, alpha: 1.0)
            ], range: NSRange(location: 0, length: 3))
            cell.labelCategoryName.attributedText = attributedString
            cell.collectionView.reloadData()
            return cell
            
        }
            else if  indexPath.section == 3{
            self.indexCurrent = 0
                       let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCategoryTVCellXbox") as! HomeCategoryTVCell
                                   print(indexCurrent,indexPath.row ,categoryArray.count,catBanner.count)
                       cell.collectionView.tag = indexPath.section
                       cell.buttonActionView.tag = indexCurrent
                        cell.delegate = self
                       cell.buttonActionView.addTarget(self, action: #selector(actionViewAll), for: .touchUpInside)
                       if(categoryArray.count > 0)
                           
                       {
                           cell.labelCategoryName.text = categoryArray[0]
                       }
                       cell.contentView.tag = indexCurrent
                       cell.viewController = self
                       //cell.layoutIfNeeded()
                       cell.collectionView.reloadData()
                       return cell
                       
                   }
            else if  indexPath.section == 4{
            self.indexCurrent = 1
                       let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCategoryTVCellPlayStation") as! HomeCategoryTVCell
                                   print(indexCurrent,indexPath.row ,categoryArray.count,catBanner.count)
                       cell.collectionView.tag = indexPath.section
                       cell.buttonActionView.tag = indexCurrent
                        cell.delegate = self
                       cell.buttonActionView.addTarget(self, action: #selector(actionViewAll), for: .touchUpInside)
                       if(categoryArray.count > 1)
                           
                       {
                           cell.labelCategoryName.text = categoryArray[1]
                       }
                       cell.contentView.tag = indexCurrent
                       cell.viewController = self
                       //cell.layoutIfNeeded()
                       cell.collectionView.reloadData()
                       return cell
                       
                   }
            else if  indexPath.section >= 6{
            
            
                self.indexCurrent = indexPath.section - 4
            
                       let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCategoryTVCellNintendo") as! HomeCategoryTVCell
                                   print(indexCurrent,indexPath.row ,categoryArray.count,catBanner.count)
                       cell.collectionView.tag = indexPath.section
                       cell.buttonActionView.tag = indexCurrent
                        cell.delegate = self
                       cell.buttonActionView.addTarget(self, action: #selector(actionViewAll), for: .touchUpInside)
                       
                           cell.labelCategoryName.text = categoryArray[self.indexCurrent]
                      
            
            
                       cell.contentView.tag = indexCurrent
                       cell.viewController = self
                       //cell.layoutIfNeeded()
                       cell.collectionView.reloadData()
                       return cell
                       
                   }
       else if(catBanner.count > 0 && indexPath.section ==  1)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BannerTableViewCell") as! BannerTableViewCell
            indexCurrent = 0
            cell.buttonBanner.tag = indexCurrent
            cell.buttonBanner.addTarget(self, action: #selector(buttonBanner), for: .touchUpInside)
            
            let imageView = UIImageView()
            let urlString = catBanner[indexCurrent].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            
            imageView.kf.setImage(with: URL(string: urlString!)!, placeholder: UIImage.init(named: "noImage"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: { (downloadImage, error, cacheType, url) in
                if(downloadImage != nil)
                {
                    cell.imageBanner.image = downloadImage!
                    cell.imageBanner.backgroundColor = AppColors.themeColor
                    //cell.imageBanner.contentMode = .scaleAspectFit
                    //cell.imageBanner.contentMode = .scaleAspectFill
                    cell.imageBanner.contentMode = .scaleToFill
                    
                }
            })
            return cell
        }
        else if(catBanner.count > 1 && indexPath.section == 5 )
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BannerTableViewCell") as! BannerTableViewCell
            indexCurrent = 1
            cell.buttonBanner.tag = indexCurrent
            cell.buttonBanner.addTarget(self, action: #selector(buttonBanner), for: .touchUpInside)
            let imageView = UIImageView()
            let urlString = catBanner[indexCurrent].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            
            imageView.kf.setImage(with: URL(string: urlString!)!, placeholder: UIImage.init(named: "noImage"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: { (downloadImage, error, cacheType, url) in
                if(downloadImage != nil)
                {
                    cell.imageBanner.image = downloadImage!
                    cell.imageBanner.backgroundColor = AppColors.themeColor
                    cell.imageBanner.contentMode = .scaleAspectFit
                    cell.imageBanner.contentMode = .scaleToFill
                    
                    //cell.imageBanner.contentMode = .scaleAspectFill
                    
                }
            })
            return cell
        }
        else if(catBanner.count > 2 && indexPath.row == 7 )
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BannerTableViewCell") as! BannerTableViewCell
            indexCurrent = 2
            cell.buttonBanner.tag = indexCurrent
            cell.buttonBanner.addTarget(self, action: #selector(buttonBanner), for: .touchUpInside)
            let imageView = UIImageView()
            let urlString = catBanner[indexCurrent].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            
            imageView.kf.setImage(with: URL(string: urlString!)!, placeholder: UIImage.init(named: "noImage"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: { (downloadImage, error, cacheType, url) in
                if(downloadImage != nil)
                {
                    cell.imageBanner.image = downloadImage!
                    cell.imageBanner.backgroundColor = AppColors.themeColor
                    cell.imageBanner.contentMode = .scaleAspectFit
                    //cell.imageBanner.contentMode = .scaleAspectFill
                    cell.imageBanner.contentMode = .scaleToFill
                    
                }
            })
            return cell
        }
        else if(catBanner.count > 3 && indexPath.row == 10 )
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BannerTableViewCell") as! BannerTableViewCell
            indexCurrent = 3
            cell.buttonBanner.tag = indexCurrent
            cell.buttonBanner.addTarget(self, action: #selector(buttonBanner), for: .touchUpInside)
            let imageView = UIImageView()
            let urlString = catBanner[indexCurrent].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            
            imageView.kf.setImage(with: URL(string: urlString!)!, placeholder: UIImage.init(named: "noImage"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: { (downloadImage, error, cacheType, url) in
                if(downloadImage != nil)
                {
                    cell.imageBanner.image = downloadImage!
                    cell.imageBanner.backgroundColor = AppColors.themeColor
                    cell.imageBanner.contentMode = .scaleAspectFit
                    //cell.imageBanner.contentMode = .scaleAspectFill
                    cell.imageBanner.contentMode = .scaleToFill
                    
                }
            })
            return cell
        }
            
//        else
//        {
//
//            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCategoryTVCell") as! HomeCategoryTVCell
//
//            //(indexPath.row == 3 && catBanner.count > 0 || indexPath.row == 4 && catBanner.count > 0)
//            if(indexPath.row == 2 && catBanner.count > 0) || (indexPath.row == 3 && catBanner.count > 0)
//            {
//                indexCurrent = indexPath.row - 1
//
//            }
//
//            else if(indexPath.row == 5 && catBanner.count > 1 || indexPath.row == 6 && catBanner.count > 1)
//            {
//                indexCurrent = indexPath.row - 2
//
//            }
//            else if(indexPath.row == 9 && catBanner.count > 2 || indexPath.row == 10 && catBanner.count > 2)
//            {
//                indexCurrent = indexPath.row - 3
//
//            }
//            else if(indexPath.row == 12 && catBanner.count > 3 || indexPath.row == 13 && catBanner.count > 3)
//            {
//                indexCurrent = indexPath.row - 4
//
//            }
//            else if(indexPath.row > 13 && catBanner.count > 3)
//            {
//                indexCurrent = indexPath.row - 4
//
//            }
//            else
//            {
//                indexCurrent = indexPath.row
//
//            }
//
//
//
//            print(indexCurrent,indexPath.row ,categoryArray.count,catBanner.count)
//
//            cell.buttonActionView.tag = indexCurrent
//
//            cell.buttonActionView.addTarget(self, action: #selector(actionViewAll), for: .touchUpInside)
//            if(indexCurrent < categoryArray.count)
//
//            {
//                cell.labelCategoryName.text = categoryArray[indexCurrent].uppercased()
//            }
//            cell.contentView.tag = indexCurrent
//            cell.viewController = self
//            //cell.layoutIfNeeded()
//            cell.collectionView.reloadData()
//
//
//
//            return cell
//        }
        
        
        return UITableViewCell()
    }
    
    @objc func buttonBanner(sender:UIButton)
    {
        if(sender.tag < HomeInfoModel.sharedInstance.arrayBanner.count)
        {
            self.showBannerSliderData(tag: sender.tag, type: "banner")
        }
        
    }
    
    func showBannerSliderData(tag:Int, type:String)
    {
        
        var productID = ""
        var offerID = ""
        var categotyID = ""
        var brandID = ""
        var is_redirect_deal_otd = "0"
        
        if(type == "slider")
        {
            productID = HomeInfoModel.sharedInstance.arraySlider[tag].product_id
            offerID = HomeInfoModel.sharedInstance.arraySlider[tag].offer_id
            categotyID = HomeInfoModel.sharedInstance.arraySlider[tag].category_id
            brandID = HomeInfoModel.sharedInstance.arraySlider[tag].brand_id
            
            if(productID.count > 0)
            {
                
                let objVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC
                objVC.productId = productID
                objVC.stringTitle = HomeInfoModel.sharedInstance.arraySlider[tag].product_name
                self.present(objVC, animated: false, completion: nil)
                return
                
            }
            else if(categotyID.count > 0)
            {
                let brandVC = self.storyboard?.instantiateViewController(withIdentifier: "BrandsListVC") as! BrandsListVC
                self.definesPresentationContext = true
                brandVC.modalPresentationStyle = .overCurrentContext
                brandVC.stringTitle = HomeInfoModel.sharedInstance.arraySlider[tag].category_name
                brandVC.stringCatId = categotyID
                DispatchQueue.main.async {
                    
                    self.present(brandVC, animated: false, completion: nil)
                }
                return
                
            }
            else if(brandID.count > 0)
            {
                
                
                
                
                CartViewModel().getChildList(vc: self, param: ["brandid":brandID], completionHandler: { (result:[JSON], error:Error?) in
                    if(!(error == nil))
                    {
                        return
                    }
                    if(result.count > 0)
                    {
                        
                        let brandVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FamilyListVC") as! FamilyListVC
                        brandVC.modalPresentationStyle = .overCurrentContext
                        brandVC.stringTitle = ""
                        brandVC.brandId = brandID
                        brandVC.arrayChildData = result
                        print(brandVC.arrayChildData)
                        DispatchQueue.main.async {
                            
                            self.present(brandVC, animated: false, completion: nil)
                        }
                        return
                    }
                    else
                    {
                        let brandVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductListVC") as! ProductListVC
                        self.definesPresentationContext = true
                        brandVC.modalPresentationStyle = .overCurrentContext
                        brandVC.stringTitle = HomeInfoModel.sharedInstance.arraySlider[tag].brand_name
                        brandVC.brandId = brandID
                        DispatchQueue.main.async {
                            
                            self.present(brandVC, animated: false, completion: nil)
                        }
                        return
                    }
                } )
                
            }
            else if(offerID.count > 0)
            {
                let offerVC = self.storyboard?.instantiateViewController(withIdentifier: "OffersHomeVC") as! OffersHomeVC
                self.definesPresentationContext = true
                offerVC.modalPresentationStyle = .overCurrentContext
                offerVC.offerID = offerID
                DispatchQueue.main.async {
                    
                    self.present(offerVC, animated: false, completion: nil)
                }
                
                return
            }
            
            
        }
        else if(type == "banner")
        {
            productID = HomeInfoModel.sharedInstance.arrayBanner[tag].product_id
            offerID = HomeInfoModel.sharedInstance.arrayBanner[tag].offer_id
            categotyID = HomeInfoModel.sharedInstance.arrayBanner[tag].category_id
            brandID = HomeInfoModel.sharedInstance.arrayBanner[tag].brand_id
            is_redirect_deal_otd = HomeInfoModel.sharedInstance.arrayBanner[tag].is_redirect_deal_otd
            if(productID.count > 0)
            {
                
                let objVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC
                objVC.productId = productID
                objVC.stringTitle = HomeInfoModel.sharedInstance.arrayBanner[tag].product_name
                
                self.present(objVC, animated: false, completion: nil)
                return
                
            }
            else if(categotyID.count > 0)
            {
                let brandVC = self.storyboard?.instantiateViewController(withIdentifier: "BrandsListVC") as! BrandsListVC
                self.definesPresentationContext = true
                brandVC.modalPresentationStyle = .overCurrentContext
                brandVC.stringTitle = HomeInfoModel.sharedInstance.arrayBanner[tag].category_name
                brandVC.stringCatId = categotyID
                DispatchQueue.main.async {
                    
                    self.present(brandVC, animated: false, completion: nil)
                }
                return
                
            }
            else if(brandID.count > 0)
            {
                let brandVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductListVC") as! ProductListVC
                self.definesPresentationContext = true
                brandVC.modalPresentationStyle = .overCurrentContext
                brandVC.stringTitle = HomeInfoModel.sharedInstance.arrayBanner[tag].brand_name
                brandVC.brandId = brandID
                DispatchQueue.main.async {
                    
                    self.present(brandVC, animated: false, completion: nil)
                }
                return
            }
            else if(offerID.count > 0)
            {
                
                let offerVC = self.storyboard?.instantiateViewController(withIdentifier: "OffersHomeVC") as! OffersHomeVC
                self.definesPresentationContext = true
                offerVC.modalPresentationStyle = .overCurrentContext
                offerVC.offerID = offerID
                DispatchQueue.main.async {
                    self.present(offerVC, animated: false, completion: nil)
                }
                return
            }
            
            else if (is_redirect_deal_otd == "1"){
                self.tabBarController?.selectedIndex = 2
            }
            
            
        }
        
        
        
    }
    
    @IBAction func buttoCart(_ sender: Any) {
        
        let myCartVC = self.storyboard?.instantiateViewController(withIdentifier: "MyCartVC") as! MyCartVC
        self.present(myCartVC, animated: false, completion: nil)
        
    }
    @IBAction func buttoSearch(_ sender: Any) {
        KeyConstant.sharedAppDelegate.showSearchScreen(vc: self)
        
    }
    @IBAction func buttonFilter(_ sender: Any) {
        
        KeyConstant.sharedAppDelegate.showFilterScreen(vc: self)
        
    }
    
    @objc func actionViewAll(sender:UIButton)
    {
        
        let brandVC = self.storyboard?.instantiateViewController(withIdentifier: "BrandsListVC") as! BrandsListVC
        self.definesPresentationContext = true
        brandVC.modalPresentationStyle = .overCurrentContext
        brandVC.stringTitle = categoryArray[sender.tag]
        brandVC.stringCatId = HomeInfoModel.sharedInstance.arrayProduct[sender.tag].categoryID ?? ""
        self.present(brandVC, animated: false, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        if indexPath.section == 1{
            if catBanner.count > 0{
                return  ((CGFloat(UIScreen.main.bounds.width))/3) + 24
            }else{
                return 0
            }
            
        }
        else if indexPath.section == 5{
              if catBanner.count > 1{
                             return  ((CGFloat(UIScreen.main.bounds.width))/3) + 24
                         }else{
                             return 0
                         }
        }
        else{

            if indexPath.section == 0{
//             let tableHigh = ((CGFloat(UIScreen.main.bounds.width) - CGFloat(35)))/2.3
                let tableHigh = ((CGFloat(UIScreen.main.bounds.width) - CGFloat(35)))/3.4
                return  tableHigh + 68
            }else{
                let tableHigh = ((CGFloat(UIScreen.main.bounds.width) - CGFloat(35)))/3.4
                return  tableHigh + 68
            }
                
            
            
        }
//        if(catBanner.count > 0 && indexPath.row == 2 || catBanner.count > 1 && indexPath.row == 5 || catBanner.count > 2 && indexPath.row == 8 || catBanner.count > 3 && indexPath.row == 11)
//        {
//            return  ((CGFloat(UIScreen.main.bounds.width))/3) + 24
//
//        }
//
//
//
//        let tableHigh = ((CGFloat(UIScreen.main.bounds.width) - CGFloat(35)))/2.3
//
//        return  tableHigh + 91
        
        
        
    }
}
extension HomeVC:AACarouselDelegate{
    
    func downloadImages(_ url: String, _ index:Int) {
        
        let imageView = UIImageView()
        let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        imageView.kf.setImage(with: URL(string: urlString!)!, placeholder: UIImage.init(named: "noImage"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: { (downloadImage, error, cacheType, url) in
            if(downloadImage != nil)
            {
                self.carouselView.images[index] = downloadImage!
            }
        })
        
    }
    
    //optional method (interaction for touch image)
    func didSelectCarouselView(_ view:AACarousel ,_ index:Int) {
        
        self.showBannerSliderData(tag: index, type: "slider")
        
        
    }
    
    //optional method (show first image faster during downloading of all images)
    func callBackFirstDisplayView(_ imageView: UIImageView, _ url: [String], _ index: Int) {
        
        
        let urlString = url[index].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string:  urlString!)
        let processor = DownsamplingImageProcessor(size:  imageView.frame.size)
            >> RoundCornerImageProcessor(cornerRadius: 0)
        //imageView.kf.indicatorType = .none
        if (UIDevice.current.userInterfaceIdiom == .pad)
        {
            imageView.contentMode = .scaleAspectFit
        }
        
        imageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "noImage"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
        ])
        
        
        //        imageView.kf.setImage(with: URL(string: url[index]), placeholder: UIImage.init(named: "noImage"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: { (downloadImage, error, cacheType, url) in
        //            //self.carouselView.images[index] = downloadImage!
        //        })
        
    }
    
    func startAutoScroll() {
        //optional method
        carouselView.startScrollImageView()
        
    }
    
    func stopAutoScroll() {
        //optional method
        carouselView.stopScrollImageView()
    }
    
    
    func getContactsData()
    {
        
        MBProgress().showIndicator(view: self.view)
        
        
        WebServiceHelper.sharedInstanceAPI.hitPostAPI(urlString: KeyConstant.APIContactDetails, params: [:], completionHandler: { (result: [String:Any], err:Error?) in
            print(result)
                MBProgress().hideIndicator(view: self.view)
            if(!(err == nil))
            {
                
                return
            }
            let json = JSON(result)
            
            let statusCode = json["status"].string
            print(json)
            if(statusCode == "success")
            {
                if let dicData = json["response"]["cms_detail_Array"]["admin_settings"].dictionary
                {
                    if(dicData.count > 0)
                    {
                        self.strWhatsappNumber = dicData["whatsup_number"]?.string ?? ""
                        self.openWhatsapp()
                        
                        
                    }
                }
            }})
        
        
        
    }
    
    func openWhatsapp()
    {
        if( self.strWhatsappNumber.count > 0)
        {
            let phoneNumber = self.strWhatsappNumber.replacingOccurrences(of: " ", with: "")
            
            let urlWhats = "whatsapp://send?phone=" + String(phoneNumber)
            if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
                if let whatsappURL = URL(string: urlString) {
                    if UIApplication.shared.canOpenURL(whatsappURL) {
                        UIApplication.shared.openURL(whatsappURL)
                    } else {
                        print("Install Whatsapp")
                    }
                }
            }
            else
            {
                let whatsappURL = URL(string: "https://api.whatsapp.com/send?phone=" + String(phoneNumber ?? ""))
                if UIApplication.shared.canOpenURL(whatsappURL!) {
                    UIApplication.shared.open(whatsappURL!, options: [:], completionHandler: nil)
                }
            }
        }
    }
}

extension HomeVC:HomeCategoryTVCellDelegate{
    func presentControllerFromCell(collectionTag: Int,index: Int) {
        
        if collectionTag == 0{
            if let productID =  HomeInfoModel.sharedInstance.arrayTopSelling[index].id,productID.count > 0
            {
                
                
                let objVC =  UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC
                
                self.definesPresentationContext = true
                objVC.modalPresentationStyle = .overCurrentContext
                objVC.productId = productID
                objVC.stringTitle = HomeInfoModel.sharedInstance.arrayTopSelling[index].brand_name //HomeInfoModel.sharedInstance.arraySlider[tag].product_name
                
                self.present(objVC, animated: false, completion: nil)
                return
                
            }
            
        }
      
       else if collectionTag == 2{
            let brand = HomeInfoModel.sharedInstance.arrayNewRelease[index]
//            ProductListModel.sharedInstance.arrayProductList.removeAll()
//            BannerSliderCollection.sharedInstance.arrayBrandList.removeAll()
//            
            let brandVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC
            self.definesPresentationContext = true
            brandVC.modalPresentationStyle = .overCurrentContext
            brandVC.stringTitle = brand.name
            brandVC.productId = brand.id
            self.present(brandVC, animated: false, completion: nil)
        }
        
      

    }
    
    
}
