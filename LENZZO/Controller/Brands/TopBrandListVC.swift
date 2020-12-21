//
//  TopBrandListVC.swift
//  LENZZO
//
//  Created by sanjay mac on 17/06/20.
//  Copyright © 2020 LENZZO. All rights reserved.
//

import UIKit
import Kingfisher
import AlamofireImage
import MBProgressHUD
import SwiftyGif
import SwiftyJSON


class TopBrandListVC: UIViewController {

    
    @IBOutlet weak var labelNotFound: UILabel!
    
    @IBOutlet weak var cartCount: UILabel!
    
    @IBOutlet weak var carouselView: AACarousel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cartBtn: UIButton!
    @IBOutlet weak var searchBtn: UIButton!
    
    @IBOutlet weak var backBtnTopContraint: NSLayoutConstraint!
    
    @IBOutlet weak var corosulContainerView: UIView!
    
    @IBOutlet weak var backBtn: UIButton!
    var brandId = String()
    var stringTitle = String()
    var currency = ""
    var paramOfAction = [String:String]()
    var APITypeAction = String()
    let htmlfontStyle =  "<style>body{font-family:'FuturaBT-Medium'; font-size:'13.0';}</style>"
    let topPadding = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initialSetup()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        currency = KeyConstant.user_Default.value(forKey: KeyConstant.kSelectedCurrency) as! String
//        HomeModelView().getAllHomeInfo(vc: self, completionHandler: { (success: Bool, errorC:Error?) in
//
//
////            if(self.categoryArray.count == 0)
////            {
////                self.labelNotFound.isHidden = false
////            }
////            else
////            {
////                self.labelNotFound.isHidden = true
////
////            }
//           // self.tableView.reloadData()
//        })
//        CartViewModel().viewCartList(vc: self, param: ["user_id":KeyConstant.sharedAppDelegate.getUserId()], completionHandler: { (result:[JSON], totalCount:String ,error:Error?) in
//
//            self.cartCount.text = ""
//
//
//
//
//            if(result.count > 0)
//            {
//                print(result.count)
//                self.cartCount.text = totalCount
//            }})
        if(HelperArabic().isArabicLanguage())
                      {
                          
                       self.backBtn.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                          
                      }
                      else
                      {
                          self.backBtn.transform = CGAffineTransform(rotationAngle: 245)
                      }
        
        self.labelNotFound.isHidden = true
        
        self.displayProductList()
    }
    
    
    //MARK:-  displayProductList
        func displayProductList()
        {
            ProductListModel.sharedInstance.arrayProductList.removeAll()
            ProductListModel.sharedInstance.sliderArr.removeAll()
            self.tableView.reloadData()
            
//            if(stringTitle == NSLocalizedString("MSG214", comment: ""))
//            {
//                //filter
//
//                self.setFilterData()
//
//            }
//            else if(stringTitle == NSLocalizedString("MSG216", comment: "") && searchKeyWord.count > 0)
//            {
//                //search with all keyword
//                setSearchList()
//            }
//             if(stringTitle == NSLocalizedString("MSG216", comment: "") && searchKeyWord.count == 0)
//            {
//                //search with one selected data
//                if(ProductListModel.sharedInstance.arrayProductList.count == 0)
//                {
//                    self.labelNotFound.isHidden = false
//                }
//                else
//                {
//                    self.labelNotFound.isHidden = true
//
//                }
//
//                self.tableView.reloadData()
//            }
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
//            else
//            {
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
                
    //        }
            self.showCartCount()
        }
    
    
    
    
    //MARK:- IBACTIONS
    
    
    
    @IBAction func backBtnClicked(_ sender: UIButton) {
//        if(stringTitle == NSLocalizedString("MSG214", comment: "") || stringTitle == NSLocalizedString("MSG216", comment: "") || isFromCartList == true || stringTitle == NSLocalizedString("MSG217", comment: "") || stringTitle == NSLocalizedString("MSG218", comment: ""))
//        {
//            self.dismiss(animated: false, completion: {
//                if(self.delegateReloadData != nil)
//                {
//                    self.delegateReloadData.reloadDataSelected()
//                }
//            })
//            return
//        }
//
//
//        if(self.brandId.count < 1)
//        {
//            KeyConstant.sharedAppDelegate.setRoot()
//        }
//        else
//        {
            self.dismiss(animated: false, completion: {
//                if(self.delegateReloadData != nil)
//                {
//                    self.delegateReloadData.reloadDataSelected()
//                }
                self.tabBarController?.selectedIndex = 0
            })
            
//        }
    }
    
    
    
    @IBAction func searchBtnClicked(_ sender: UIButton) {
         KeyConstant.sharedAppDelegate.showSearchScreen(vc: self)
        
    }
    
    @IBAction func shareBtnClicked(_ sender: UIButton) {
        let productList = ProductListModel.sharedInstance.arrayProductList
        if productList.count > 0{
            if let productId = productList[0].id
            {

                if(productId.count > 0)
                {
                    // let shareProductURL = "com.Lenzzo://product?id=\(productId)"http://139.59.93.33/
                    let shareProductURL = "http://e-gamesstore.com/share?productId=\(productId)"
//                        "http://139.59.93.33/share?productId=\(productId)"

                    let url1 = URL(string:shareProductURL)

                    let activityViewController : UIActivityViewController = UIActivityViewController(
                        activityItems: [url1], applicationActivities: nil)

                    activityViewController.popoverPresentationController?.sourceView = sender

                    self.present(activityViewController, animated: true, completion: nil)

                }
            }
        }

        
    }
    
    
    @IBAction func cartBtnClicked(_ sender: UIButton) {
        
        let myCartVC = self.storyboard?.instantiateViewController(withIdentifier: "MyCartVC") as! MyCartVC
        self.present(myCartVC, animated: false, completion: nil)
        
    }
    
    
    
    func initialSetup(){
        carouselView.tag = 10
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        carouselView.setCarouselData(paths: [String](),  describedTitle: [], isAutoScroll: true, timer: 1.0, defaultImage: "noImage")
        carouselView.setCarouselOpaque(layer: false, describedTitle: false, pageIndicator: false)
        carouselView.setCarouselLayout(displayStyle: 0, pageIndicatorPositon: 2, pageIndicatorColor: AppColors.SelcetedColor, describedTitleColor: nil, layerColor: .clear)
        
        
        carouselView.frame.size.height = 200 + topPadding
        self.corosulContainerView.frame.size.height = carouselView.frame.size.height
        if topPadding > 24{
           self.backBtnTopContraint.constant = 24 + 20
        }else{
           self.backBtnTopContraint.constant = 24
        }
        
        self.carouselView.frame.size.width = UIScreen.main.bounds.size.width
       // carouselView.setGradientBackground(layerFrame: self.carouselView.bounds)
        carouselView.setGradientBackground(layerFrame: self.carouselView.bounds, isTopGradient: true)
        
        self.labelNotFound.font = UIFont(name: FontLocalization.medium.strValue, size: 14.0)
        }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
        

    
    
    func showCartCount()
    {
        cartCount.text = ""
        
        
        CartViewModel().viewCartList(vc: self, param: ["user_id":KeyConstant.sharedAppDelegate.getUserId()], completionHandler: { (result:[JSON], totalCount:String ,error:Error?) in
            
            self.cartCount.text = ""
            
            
            
            if(result.count > 0)
            {
                self.cartCount.text = totalCount
                
                print(result.count)
            }})
        
    }
    
//    func setSearchList()
//    {
//        var customParam:[String:String]!
//
//        customParam = ["search_text":searchKeyWord]
//
//        ProductListViewModel().getBrandCatProductList(vc: self, itemId: "", APIName: KeyConstant.APIBrandProductList, sortIndex: selectedType, customParam: customParam, filterParam: filterDicData, completionHandler: { (result:[JSON], success: Bool, errorC:Error?) in
//
//            if(result.count == 0)
//            {
//                self.labelNotFound.isHidden = false
//            }
//            else
//            {
//                self.labelNotFound.isHidden = true
//
//            }
//            self.productTableView.reloadData()
//        } )
//    }
    
    
    func setProductList()
    {
        if(brandId.count > 0)
        {

            ProductListViewModel().getBrandCatProductList(vc: self, itemId: brandId, APIName: KeyConstant.APIProductSearchByName, sortIndex: [String:String](), customParam: [:], filterParam: [String:String](), completionHandler: { (result:[JSON], success: Bool, errorC:Error?) in

                if(result.count == 0)
                {
                    self.labelNotFound.isHidden = false
                }
                else
                {
                    self.labelNotFound.isHidden = true

                }
                
                self.setSlider()
                self.tableView.reloadData()
            })

        }
    }
//
//    func setFamilyProductList()
//    {
//        if(familyID.count > 0 && brandId.count > 0)
//        {
//            ProductListViewModel().getBrandCatProductList(vc: self, itemId: brandId, APIName: KeyConstant.APIProductSearchByName, sortIndex: selectedType, customParam: ["family_id":familyID], filterParam: filterDicData, completionHandler: { (result:[JSON], success: Bool, errorC:Error?) in
//
//                if(result.count == 0)
//                {
//                    self.labelNotFound.isHidden = false
//                }
//                else
//                {
//                    self.labelNotFound.isHidden = true
//
//                }
//                self.productTableView.reloadData()
//            })
//        }
//    }
    
    
    
    func setSlider()
    {
        
        
        
//        print(ProductListModel.sharedInstance.arrayProductList)
        if(ProductListModel.sharedInstance.sliderArr.count > 0)
        {

            carouselView.delegate = self
            print(ProductListModel.sharedInstance.sliderArr)
            var imageArray = [String]()

            for ind in 0..<ProductListModel.sharedInstance.sliderArr.count
            {
                imageArray.insert(KeyConstant.kImageBaseBannerSliderURL + ProductListModel.sharedInstance.sliderArr[ind].path, at: imageArray.count)
            }

            carouselView.setCarouselData(paths: imageArray,  describedTitle: [], isAutoScroll: true, timer: 4.0, defaultImage: "noImage")
        }
        
        carouselView.setCarouselOpaque(layer: false, describedTitle: false, pageIndicator: false)
        carouselView.setCarouselLayout(displayStyle: 0, pageIndicatorPositon: 2, pageIndicatorColor: nil, describedTitleColor: nil, layerColor: .clear)
        
    }
    


}

extension TopBrandListVC:AACarouselDelegate{
    
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
        
       // self.showBannerSliderData(tag: index, type: "slider")
        
        
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
    

}



extension TopBrandListVC:UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProductListModel.sharedInstance.arrayProductList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopBrandTVCell", for: indexPath) as! TopBrandTVCell
        cell.productImgView.backgroundColor = .white
        
        if(indexPath.row < ProductListModel.sharedInstance.arrayProductList.count)
        {
            let dic = ProductListModel.sharedInstance.arrayProductList[indexPath.row]
            
            
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
            
            
            cell.productNameLbl.text = dic.title
            //cell.labelProductDetails.text = dic.description.html2String
            
            //cell.labelProductDetails.setHTML1(html:(dic.description) + self.htmlfontStyle)
            
            var price = ""
            
            if(self.currency.uppercased() == "KWD")
            {
                price = String(format:"%.3f",Double(dic.price)?.roundTo(places: 3) ?? 0.0)
            }
            else
            {
                price = String(format:"%.2f",Double(dic.price)?.roundTo(places: 2) ?? 0.0)
                
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
                            sprice = String(format:"%.3f",Double(tempPrice).roundTo(places: 3) )
                        }
                        else
                        {
                            sprice = String(format:"%.2f",Double(tempPrice).roundTo(places: 2) )
                            
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
            
            
            if(dic.tags == "new")
            {
                //                cell.labelExclusive.isHidden = false
                //                cell.labelExclusive.text = NSLocalizedString("MSG224", comment: "")
            }
            else if(dic.tags == "latest")
            {
                //                cell.labelExclusive.isHidden = false
                //                cell.labelExclusive.text = NSLocalizedString("MSG224", comment: "")
            }
            else if(dic.tags == "exclusive")
            {
                //                cell.labelExclusive.isHidden = false
                //                cell.labelExclusive.text = NSLocalizedString("MSG223", comment: "")
                
            }
            else
            {
                // cell.labelExclusive.isHidden = true
            }
            //cell.imageViewProduct.contentMode = .scaleAspectFill
            
            cell.productImgView.contentMode = .scaleToFill
            
            if let strUrl = dic.product_image
            {
                if(strUrl.count > 0)
                {
                    let urlString = strUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    let url = URL(string: KeyConstant.kImageBaseProductURL +  urlString!)
                    let processor = DownsamplingImageProcessor(size:  cell.productImgView.frame.size)
                        >> RoundCornerImageProcessor(cornerRadius: 0)
                    cell.productImgView.kf.indicatorType = .none
                    cell.productImgView.kf.setImage(
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
                    cell.productImgView.image = UIImage(named: "noImage")
                    
                }
            }
            else
            {
                cell.productImgView.image = UIImage(named: "noImage")
                
            }
            
            
            //            cell.imageFav.image = UIImage(named: "heart-s")
            //            cell.buttonFav.tag = indexPath.item
            //            cell.buttonFav.addTarget(self, action: #selector(buttonFav), for: .touchUpInside)
            cell.addToCartBtn.tag = indexPath.item
            cell.viewDetailBtn.tag = indexPath.item
            cell.addToCartBtn.addTarget(self, action: #selector(buttonBuyNow), for: .touchUpInside)
            
            cell.viewDetailBtn.addTarget(self, action: #selector(viewDetailBtnTapped), for: .touchUpInside)
            cell.addToCartBtn.isUserInteractionEnabled = true
            cell.addToCartBtn.setTitleColor(.white, for: .normal)
            
            
            if(dic.cate_id == "2")
            {
               // cell.viewDetailBtn.setTitle(NSLocalizedString("MSG357", comment: ""), for: .normal)
                cell.addToCartBtn.setTitle(NSLocalizedString("MSG432", comment: ""), for: .normal)
              //  cell.viewDetailBtn.setTitleColor(.white, for: .normal)
                cell.addToCartBtn.isHidden = false
                cell.viewDetailBtn.isHidden = true
            }
            else
            {
                cell.addToCartBtn.setTitle(NSLocalizedString("MSG432", comment: ""), for: .normal)
                cell.addToCartBtn.isHidden = false
                cell.viewDetailBtn.isHidden = true
            }
            
            if let strQuantity = dic.quantity
            {
                if((Int(strQuantity) ?? 0) < 1 || strQuantity.count < 1)
                {
                    cell.addToCartBtn.setTitle(NSLocalizedString("MSG195", comment: ""), for: .normal)
                    cell.addToCartBtn.isUserInteractionEnabled = false
                    cell.addToCartBtn.setTitleColor(.white, for: .normal)
                    
                }
                else
                {
                    if let strStockFlag = dic.stock_flag
                        
                    {
                        if((Int(strStockFlag) ?? 0) < 1 || strStockFlag.count < 1)
                        {
                            cell.addToCartBtn.setTitle(NSLocalizedString("MSG195", comment: ""), for: .normal)
                            cell.addToCartBtn.isUserInteractionEnabled = false
                            cell.addToCartBtn.setTitleColor(.white, for: .normal)
                            
                        }
                        
                        
                    }
                    
                }
                
                
            }
            
            
            
            
            
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
            
            
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let brandVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC
        brandVC.productId = ProductListModel.sharedInstance.arrayProductList[indexPath.row].id
        brandVC.stringTitle = ProductListModel.sharedInstance.arrayProductList[indexPath.row].title
       // brandVC.delegateReloadData = self
        self.present(brandVC, animated: false, completion: nil)
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
        
        
        
        paramOfAction = ["product_id":ProductListModel.sharedInstance.arrayProductList[sender.tag].id]
        self.addToCart()
        
//        if(ProductListModel.sharedInstance.arrayProductList[sender.tag].cate_id == "2")
//        {
//
////            let brandVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC
////            brandVC.productId = ProductListModel.sharedInstance.arrayProductList[sender.tag].id
////            brandVC.stringTitle = ProductListModel.sharedInstance.arrayProductList[sender.tag].title
////            //brandVC.delegateReloadData = self
////            self.present(brandVC, animated: false, completion: nil)
//
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
////            paramOfAction = ["product_id":ProductListModel.sharedInstance.arrayProductList[sender.tag].id,"shade":colorDefault]
////
////            if(ProductListModel.sharedInstance.arrayProductList[sender.tag].start_range.count > 0)
////            {
////                paramOfAction["left_eye_power"] = "0.0"
////                paramOfAction["right_eye_power"] = "0.0"
////
////            }
////            APITypeAction = KeyConstant.APIAddCart
//
//            self.addToCart()
//
//        }
    }
    
    
    @objc func viewDetailBtnTapped(sender:UIButton)
    {
        
//        let brandVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC
//        brandVC.productId = ProductListModel.sharedInstance.arrayProductList[sender.tag].id
//        brandVC.stringTitle = ProductListModel.sharedInstance.arrayProductList[sender.tag].title
//      //  brandVC.delegateReloadData = self
//        self.present(brandVC, animated: false, completion: nil)
        
        paramOfAction = ["product_id":ProductListModel.sharedInstance.arrayProductList[sender.tag].id]
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
        //    myCartVC.delegateReloadData = self
            
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
