//
//  ProductDetailsVC.swift
//  LENZZO
//
//  Created by Apple on 8/16/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import UIKit
import Kingfisher
import AlamofireImage
import SwiftyJSON

protocol ReloadProductDataDelegate
{
    func reloadDataSelected()
}


class ProductDetailsVC: UIViewController, UITextFieldDelegate,DelegatePowerSelection,ReloadDataDelegate,UIScrollViewDelegate,ReloadProductDataDelegate {

    func getSlectedPower(left: Double, right: Double) {
        
    }
    
    var productId = String()
    var imageArray = [String]()
    
    @IBOutlet weak var egamesImgView: UIImageView!
    @IBOutlet weak var textViewDescriptions: UITextView!

    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var productOfferLbl: UILabel!
    
//    @IBOutlet weak var backImgView: UIImageView!
    
    
    var paramOfAction = [String:String]()
    var APITypeAction = String()
    

    var arraTypeCart = ["detailsProduct","relatedProduct"]
    var typeCart = ""
    var itemWidth = CGFloat(0.0)
    var currency = ""
    var oldContentOffset = CGPoint.zero
    let topConstraintRange = (CGFloat(0)..<CGFloat(140))
    var delegateReloadData: ReloadProductDataDelegate!
    @IBOutlet weak var labelCountCart: UILabel!
    
  //  @IBOutlet weak var buttonBuyNow: UIButton!
    @IBOutlet weak var buttonAddCart: UIButton!
  //  @IBOutlet weak var collectionViewConstant: NSLayoutConstraint!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
  //  @IBOutlet weak var descriptionHeightConstant: NSLayoutConstraint!
    
    @IBOutlet weak var labelRelatedProduct: PaddingLabel!
    @IBOutlet weak var buttonMenu: UIButton!
    @IBOutlet weak var carouselView: AACarousel!
    
  
    
    var titleArray = [String]()
    var stringTitle = String()
    var stringDesc = String()
    let htmlfontStyle =  "<style>body{font-family:'\(FontLocalization.medium.strValue)'; font-size:'13.0';}</style>"
   // @IBOutlet weak var labelTitle: PaddingLabel!
    
    @IBOutlet weak var imageNoImage: UIImageView!
  //  @IBOutlet weak var buttonFav: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var relatedProductContainerViewHieghtConstraint: NSLayoutConstraint!
    
    
    
 //   @IBOutlet weak var labelProductTitle: PaddingLabel!
    
//    @IBOutlet weak var labelLeftTitleQty: PaddingLabel!
//    @IBOutlet weak var labelLeftQty: PaddingLabel!
    
    @IBOutlet weak var leftpriceLbl: UILabel!
    
    @IBOutlet weak var rightPriceLbl: UILabel!
    //    @IBOutlet weak var labelPriceTitleLeft: PaddingLabel!
//
//    @IBOutlet weak var labelPriceTitleRight: PaddingLabel!
    
    
//    @IBOutlet weak var labelRightTitleQty: PaddingLabel!
//    @IBOutlet weak var labelRightQty: PaddingLabel!
    
//    @IBOutlet weak var imageRating4: UIImageView!
//
//    @IBOutlet weak var imageRating5: UIImageView!
    
//    @IBOutlet weak var labelOffer: PaddingLabel!
//    @IBOutlet weak var labelDesc: PaddingLabel!
    @IBOutlet weak var collectionView: UICollectionView!

    
    var indexCurrent = 0
    var arrayRelatedProductList = [JSON]()
    var dicProductList = [String:JSON]()
    var dicRatingList = [String:JSON]()
    
 //   @IBOutlet weak var labelOffers: PaddingLabel!
    
    var pickerView: UIPickerView!
    var arrayQunatity = [1,2,3,4,5,6,7,8,9,10]
    var arrayShade = [String]()
    var tempTextField = UITextField()
    var leftPower = 0.0
    var rightPower = 0.0
    
    var rightPowerPrice = 0.0
    var leftPowerPrice = 0.0
    
    var leftSalePriceAttributed = NSMutableAttributedString()
    var rightSalePriceAttributed = NSMutableAttributedString()
    
    var headerViewMaxHeight: CGFloat = 200
    let headerViewMinHeight: CGFloat = 0
    let topPadding = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textViewDescriptions.isScrollEnabled = false
        self.textViewDescriptions.isHidden = false
//        self.labelDesc.isHidden = true
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.itemWidth = 0.1
//        self.collectionView.register(UINib(nibName: "ProductCVCellOffer", bundle: nil), forCellWithReuseIdentifier: "ProductCVCellOffer")
//        self.labelLeftTitleQty.text = NSLocalizedString("MSG419", comment: "")
//        self.labelPriceTitleLeft.text = NSLocalizedString("MSG420", comment: "")
//        self.labelPriceTitleRight.text = NSLocalizedString("MSG420", comment: "")
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(rightSwip))
        
        if(HelperArabic().isArabicLanguage())
        {
            
            swipeRight.direction = UISwipeGestureRecognizer.Direction.left
            textViewDescriptions.textAlignment = .right
            productNameLbl.textAlignment = .right
            productOfferLbl.textAlignment = .right
            
        }
        else
        {
            swipeRight.direction = UISwipeGestureRecognizer.Direction.right
            textViewDescriptions.textAlignment = .left
            productNameLbl.textAlignment = .left
            productOfferLbl.textAlignment = .left
        }
        
        
        self.view.addGestureRecognizer(swipeRight)
        
//        rightPowerHeightConstraint.constant = 0
//        self.rightView.isHidden = true
        
        
     //   self.labelTitle.text = stringTitle
        currency = KeyConstant.user_Default.value(forKey: KeyConstant.kSelectedCurrency) as! String
        carouselView.tag = 11
        
        carouselView.setCarouselData(paths: [String](),  describedTitle: [], isAutoScroll: true, timer: 4.0, defaultImage: "noImage")
        carouselView.setCarouselOpaque(layer: false, describedTitle: false, pageIndicator: false)
        carouselView.setCarouselLayout(displayStyle: 0, pageIndicatorPositon: 2, pageIndicatorColor: nil, describedTitleColor: nil, layerColor: .clear)
        
        
        self.buttonMenu.addTarget(self, action:#selector(backAction), for: .touchUpInside)
        
        pickerView = UIPickerView()
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        
        self.toolbar()
        headerViewMaxHeight = self.carouselView.frame.size.height
        self.carouselView.frame.size.height = self.carouselView.frame.size.height + topPadding
        headerViewHeightConstraint.constant = self.carouselView.frame.size.height
        //scrollView.contentOffset.y = carouselView.frame.origin.y
       // carouselView.setGradientBackground(layerFrame: self.carouselView.bounds)
        carouselView.setGradientBackground(layerFrame: self.carouselView.bounds, isTopGradient: true)
        ////default
        self.buttonAddCart.setTitle(NSLocalizedString("MSG432", comment: ""), for: .normal)
//        self.buttonBuyNow.setTitle(NSLocalizedString("MSG238", comment: ""), for: .normal)
//
//        self.buttonBuyNow.isUserInteractionEnabled = true
        self.buttonAddCart.isUserInteractionEnabled = true
        
        arrayQunatity = [1,2,3,4,5,6,7,8,9,10]
        
        self.pickerView.reloadAllComponents()
        
        arrayRelatedProductList.removeAll()
        dicProductList.removeAll()
      //  self.showPower()
        
        ProductDetailsViewModel().getProductDetailsJSON(vc: self, productId: productId, completionHandler: { (result:[String:JSON], relatedArray:[JSON],ratingResult:[String:JSON],success: Bool, errorC:Error?) in
            
            
//            if(ratingResult.count > 0)
//            {
//                self.dicRatingList = ratingResult
//                self.ratingShow()
//
//            }
            
            
            
            if(result.count > 0)
            {
                self.dicProductList = result
            }
            
            if(self.dicProductList.count > 0)
            {
                
//                if let isPowerAvailable = self.dicProductList["power"]?.dictionary
//                {
//                    if (isPowerAvailable.count == 0)
//                    {
//                        self.hidePower()
//                    }
//                    else
//                    {
//
//                        if let isPowerAvailablee = self.dicProductList["power_range"]?.array
//                        {
//                            if(isPowerAvailablee.count > 0)
//                            {
//
//                                if let powerAvailable = isPowerAvailable["start_range"]?.string
//                                {
//                                    if(powerAvailable.count == 0)
//                                    {
//                                        self.hidePower()
//                                    }
//                                }
//                                else
//                                {
//                                    self.hidePower()
//
//                                }
//                            }
//                            else
//                            {
//                                self.hidePower()
//
//                            }
//                        }
//
//                        else
//                        {
//                            self.hidePower()
//
//                        }
//                    }
//                }
//                else
//                {
//                    self.hidePower()
//
//                }
//
                self.productNameLbl.text = self.dicProductList["title"]?.string ?? ""
                self.productNameLbl.numberOfLines = 4
                //self.labelDesc.text = self.dicProductList["description"]?.string?.html2String ?? ""
                
                
                
                
                if(HelperArabic().isArabicLanguage())
                {
                    if let title_ar =  self.dicProductList["title_ar"]?.string
                    {
                        if(title_ar.count > 0)
                        {
                            self.productNameLbl.text = title_ar
                        }
                        
                    }
                    if let description_ar =  self.dicProductList["description_ar"]?.string
                    {
                        if(description_ar.count > 0)
                        {
                            //  self.labelDesc.text = description_ar.html2String
//                            self.labelDesc.setHTML(html: description_ar + self.htmlfontStyle)
                            self.textViewDescriptions.setHTML(html: description_ar)
                            self.textViewDescriptions.textColor = .white
                            if HelperArabic().isArabicLanguage(){
                                self.textViewDescriptions.textAlignment = .right
                            }else{
                                self.textViewDescriptions.textAlignment = .left
                            }
                            
                        }
                        else
                        {
//                            self.labelDesc.setHTML(html:(self.dicProductList["description"]?.string ?? "") + self.htmlfontStyle)
                            
                            self.textViewDescriptions.setHTML(html:(self.dicProductList["description"]?.string ?? "") )
                            self.textViewDescriptions.textColor = .white
                            if HelperArabic().isArabicLanguage(){
                                self.textViewDescriptions.textAlignment = .right
                            }else{
                                self.textViewDescriptions.textAlignment = .left
                            }
                        }
                    }
                    else
                    {
//                        self.labelDesc.setHTML(html:(self.dicProductList["description"]?.string ?? "") + self.htmlfontStyle)
                        
                        self.textViewDescriptions.setHTML(html:(self.dicProductList["description"]?.string ?? "") )
                        self.textViewDescriptions.textColor = .white
                        if HelperArabic().isArabicLanguage(){
                            self.textViewDescriptions.textAlignment = .right
                        }else{
                            self.textViewDescriptions.textAlignment = .left
                        }
                    }
                    
                }
                else
                {
//                    self.labelDesc.setHTML(html:(self.dicProductList["description"]?.string ?? "") + self.htmlfontStyle)
                    
                    self.textViewDescriptions.setHTML(html:(self.dicProductList["description"]?.string ?? ""))
                    self.textViewDescriptions.textColor = .white
                    if HelperArabic().isArabicLanguage(){
                        self.textViewDescriptions.textAlignment = .right
                    }else{
                        self.textViewDescriptions.textAlignment = .left
                    }
                }
                
                
                if let arrayModelNum = self.dicProductList["model_no"]?.string
                {
                    if(arrayModelNum.count > 0)
                    {
                       // self.labelProductCode.text = "\(NSLocalizedString("MSG405", comment: "")): \(arrayModelNum)"
                        
                    }
                    
                }
                
                
                
                
                
               
                
                
                print(self.dicProductList)
                
                if (self.dicProductList["sale_price"]?.string?.count ?? 0 > 0)
                {
                    let sellPriceTemp  = Double(self.dicProductList["sale_price"]?.string ?? "0.0") ?? 0.0
                    if(sellPriceTemp > 0.0)
                    {
                        var tempPrice = 0.0
                        var basePrice = 0.0
                        
                        if(self.currency.uppercased() == "KWD")
                        {
                            tempPrice = Double(self.dicProductList["sale_price"]?.string ?? "0.0")?.roundTo(places: 3) ?? 0.0
                            basePrice = Double(self.dicProductList["price"]?.string ?? "0.0")?.roundTo(places: 3) ?? 0.0
                            
                        }
                        else
                        {
                            tempPrice = Double(self.dicProductList["sale_price"]?.string ?? "0.0")?.roundTo(places: 2) ?? 0.0
                            basePrice = Double(self.dicProductList["price"]?.string ?? "0.0")?.roundTo(places: 2) ?? 0.0
                            
                        }
                        
                        if(tempPrice < basePrice)
                        {
                            tempPrice = basePrice - tempPrice
                            var sprice = ""
                            if(self.currency.uppercased() == "KWD")
                            {
                                sprice = String(format:"%.3f",Double(tempPrice).roundTo(places: 3) )
                            }
                            else
                            {
                                sprice = String(format:"%.2f",Double(tempPrice).roundTo(places: 2) )
                                
                            }
                            let combination = NSMutableAttributedString()
                            
                            combination.append(self.getSimpleText(price: String(sprice) + " \(self.currency) "))
                            
                            
                            self.leftSalePriceAttributed = self.getStrikeText(price: String(self.dicProductList["price"]?.string ?? "") + " \(self.currency)")
                            
                            combination.append(self.getStrikeText(price: String(self.dicProductList["price"]?.string ?? "")))
                            combination.append(self.getSimpleText(price: " \(self.currency)"))
                            self.leftpriceLbl.attributedText = combination
                            if(self.currency.uppercased() == "KWD")
                            {
                                self.leftPowerPrice = Double(tempPrice).roundTo(places: 3)
                            }
                            else
                            {
                                self.leftPowerPrice = Double(tempPrice).roundTo(places: 2)
                                
                            }
                        }
                        else
                        {
                            if(self.currency.uppercased() == "KWD")
                            {
                                self.leftPowerPrice = Double(self.dicProductList["price"]?.string ?? "0.0")?.roundTo(places: 3) ?? 0.0

                                self.leftpriceLbl.text = String(format:"%.3f",self.leftPowerPrice) + " \(self.currency)"

                            }
                            else
                            {

                                self.leftPowerPrice = Double(self.dicProductList["price"]?.string ?? "0.0")?.roundTo(places: 2) ?? 0.0

                                self.leftpriceLbl.text = String(format:"%.3f", self.leftPowerPrice) + " \(self.currency)"


                            }
                        }
                        
                        
                    }
                    else
                    {
                        if(self.currency.uppercased() == "KWD")
                        {
                            self.leftPowerPrice = Double(self.dicProductList["price"]?.string ?? "0.0")?.roundTo(places: 3) ?? 0.0

                            //self.labelLeftPrice.text = String(format:"%.3f",self.leftPowerPrice) + " \(self.currency)"
                            self.leftpriceLbl.text = String(format:"%.3f",self.leftPowerPrice) + " \(self.currency)"

                        }
                        else
                        {

                            self.leftPowerPrice = Double(self.dicProductList["price"]?.string ?? "0.0")?.roundTo(places: 2) ?? 0.0

                            self.leftpriceLbl.text = String(format:"%.3f", self.leftPowerPrice) + " \(self.currency)"


                        }

                    }
                }
                else
                    
                {
                    
                    if(self.currency.uppercased() == "KWD")
                    {
                        self.leftPowerPrice = Double(self.dicProductList["price"]?.string ?? "0.0")?.roundTo(places: 3) ?? 0.0
                        
                        self.leftpriceLbl.text =  String(format:"%.3f",self.leftPowerPrice) + " \(self.currency)"
                        
                    }
                    else
                    {
                        
                        self.leftPowerPrice = Double(self.dicProductList["price"]?.string ?? "0.0")?.roundTo(places: 2) ?? 0.0
                        
                        self.leftpriceLbl.text =  String(format:"%.3f", self.leftPowerPrice) + " \(self.currency)"
                        
                        
                    }
                    
                }
                
                if let offerAvailable = self.dicProductList["offer_name"]?.string
                {
//                    if(offerAvailable.count > 0)
//                    {
//                        self.labelOffer.text = offerAvailable
//
//                        if(HelperArabic().isArabicLanguage())
//                        {
//
//                            if let offerName_ar = self.dicProductList["offer"]?["name_ar"].string
//                            {
//                                self.labelOffer.text = offerName_ar
//                            }
//                        }
//                        self.labelOffers.isHidden = false
//                        self.heightConstraintOfferTitle.constant = 30
//                        self.offerHeightConstraint.constant = 30
//                    }
//                    else
//                    {
//                        self.labelOffer.text = ""
//                        self.labelOffers.isHidden = true
//                        self.heightConstraintOfferTitle.constant = 0
//                        self.offerHeightConstraint.constant = 0
//                    }
                    
                    self.productOfferLbl.text = offerAvailable
                }
//                else
//                {
//                    self.labelOffer.text = ""
//                    self.labelOffers.isHidden = true
//                    self.heightConstraintOfferTitle.constant = 0
//                    self.offerHeightConstraint.constant = 0
//                }
                
                if let deal_otd = self.dicProductList["deal_otd"]?.stringValue,deal_otd == "1"{
                                   if let deal_otd_discount = self.dicProductList["deal_otd_discount"]?.stringValue{
                                       self.productOfferLbl.text = NSLocalizedString("MSG442", comment: "") + " " + deal_otd_discount + " KWD"
                                   }

                               }
                
                
                
                
                self.buttonAddCart.setTitleColor(.white, for: .normal)
                
                
                if let strQuantity = self.dicProductList["quantity"]?.string
                {
                    
                    if((Int(strQuantity) ?? 0) < 1 || strQuantity.count < 1)
                    {
                        
                        self.buttonAddCart.setTitle( NSLocalizedString("MSG195", comment: ""), for: .normal)
                        
                        self.buttonAddCart.isUserInteractionEnabled = false
                        self.arrayQunatity.removeAll()
                        self.pickerView.reloadAllComponents()
                       // self.labelLeftQty.text = "0"
                        self.buttonAddCart.setTitleColor(.white, for: .normal)
                        
                        
                    }
                    else if(Int(strQuantity) ?? 0 > 0)
                    {
                        self.arrayQunatity.removeAll()
                        
                        
                        
                        let countQunt = Int(strQuantity) ?? 0
                        if(countQunt > 10)
                        {
                            for indexT in 0..<10
                            {
                                self.arrayQunatity.insert(indexT + 1, at: self.arrayQunatity.count)
                                
                            }
                        }
                        else
                        {
                            for indexT in 0..<countQunt
                            {
                                self.arrayQunatity.insert(indexT + 1, at: self.arrayQunatity.count)
                                
                            }
                        }
                        
//                        if( self.arrayQunatity.count > 0)
//                        {
//                            self.labelLeftQty.text = String(self.arrayQunatity[0])
//                        }
//                        else
//                        {
//                            self.labelLeftQty.text = "0"
//                        }
                        if let strStockFlag = self.dicProductList["stock_flag"]?.string
                            
                        {
                            if((Int(strStockFlag) ?? 0) < 1 || strStockFlag.count < 1)
                            {
                                self.buttonAddCart.setTitle( NSLocalizedString("MSG195", comment: ""), for: .normal)
                                self.buttonAddCart.setTitleColor(.white, for: .normal)
                                
                                self.buttonAddCart.isUserInteractionEnabled = false
                                self.arrayQunatity.removeAll()
                                self.pickerView.reloadAllComponents()
                               // self.labelLeftQty.text = "0"
                            }
                        }
                        self.pickerView.reloadAllComponents()
                        
                    }
                }
                
                
                // self.viewWillLayoutSubviews()
                
                
                //                let stringVariation = ProductDetailsModel.sharedInstance.arrayProductList[0].variations
                //                if((stringVariation?.count) ?? 0 > 0)
                //                {
                //                    self.arrayShade = stringVariation?.components(separatedBy: ",") ?? [String]()
                //                    if(self.arrayShade.count > 0)
                //                    {
                //                    self.textFieldSelectShade.text = self.arrayShade[0]
                //                    }
                //                    else
                //                    {
                //                        self.textFieldSelectShade.text = ""
                //                    }
                //                }
                
                self.setSlider()
                self.pickerView.reloadAllComponents()
                if let img = self.dicProductList["product_image"]?.stringValue{
                    let imgStr = KeyConstant.kImageBaseProductURL + img
                    let urlString = imgStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

                    let url = URL(string: urlString!)
                    let processor = DownsamplingImageProcessor(size:  (self.egamesImgView.frame.size))
                                          >> RoundCornerImageProcessor(cornerRadius: 0)
                    self.egamesImgView.kf.indicatorType = .none
                    self.egamesImgView.kf.setImage(
                                          with: url,
                                          placeholder: UIImage(named: "no_image"),
                                          options: [
                                              .processor(processor),
                                              .scaleFactor(UIScreen.main.scale),
                                              .transition(.fade(1)),
                                              .cacheOriginalImage
                                      ])
                    
                }
               
                
            }
            if(relatedArray.count > 0)
            {
                
                self.arrayRelatedProductList = relatedArray
                self.itemWidth = 0.0
                self.viewDidLayoutSubviews()
                
            }
            
            
            
        })
        
//        self.backImgView.image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate)
//        self.backImgView.tintColor = .white
      //  self.showFavIcon()
        startAutoScroll()
        self.navigationController?.navigationBar.isTranslucent = true
        let columnLayout = ColumnFlowLayout(
                  cellsPerRow: 3,
                  minimumInteritemSpacing: 0,
                  minimumLineSpacing: 10,
                  sectionInset: UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 0)
              )
        
              collectionView.collectionViewLayout = columnLayout
              collectionView.contentInsetAdjustmentBehavior = .always
        columnLayout.scrollDirection = .horizontal
        collectionView.isScrollEnabled = true
        let attributedString = NSMutableAttributedString(string: "RELATED PRODUCTS".uppercased(), attributes: [
            .font: UIFont(name: FontLocalization.medium.strValue, size: 14.0)!,
          .foregroundColor: UIColor(white: 1.0, alpha: 1.0)
        ])
        attributedString.addAttributes([
          .font: UIFont(name: FontLocalization.medium.strValue, size: 14.0)!,
          .foregroundColor: AppColors.SelcetedColor
        ], range: NSRange(location: 0, length: 7))
        labelRelatedProduct.attributedText = attributedString
        self.leftpriceLbl.font = UIFont(name: FontLocalization.medium.strValue, size: 12.0)
        self.productNameLbl.font = UIFont(name: FontLocalization.medium.strValue, size: 14.0)
       // self.textViewDescriptions.font = UIFont(name: FontLocalization.medium.strValue, size: 13.0)
        self.productOfferLbl.font = UIFont(name: FontLocalization.medium.strValue, size: 12.0)
        self.buttonAddCart.titleLabel?.font = UIFont(name: FontLocalization.medium.strValue, size: 14.0)
        //self.textViewDescriptions.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
       // self.showPowerList()
        showCartCount()
    }
    
    
//    @IBAction func buttonLeftPowerDecre(_ sender: Any) {
//        if(Int(self.labelLeftQty.text!)! > 1 && (Int(self.labelLeftQty.text!)! < arrayQunatity.count + 1))
//        {
//            self.labelLeftQty.text = String(Int(self.labelLeftQty.text!)! - 1)
//
//            let qty = Int(self.labelLeftQty.text!)!
//            if(self.currency.uppercased() == "KWD")
//            {
//
//                if(leftSalePriceAttributed.string.count > 0)
//                {
//                    let combination = NSMutableAttributedString()
//                    combination.append(self.getSimpleText(price: String(format:"%.3f",Double(Double(qty).roundTo(places: 3) * self.leftPowerPrice).roundTo(places:3)) + " \(currency) "))
//                    combination.append(leftSalePriceAttributed)
//
//                    self.labelLeftPrice.attributedText = combination
//                }
//                else
//                {
//                    self.labelLeftPrice.text = String(format:"%.3f",Double(Double(qty).roundTo(places: 3) * self.leftPowerPrice).roundTo(places:3)) + " \(currency)"
//
//                }
//            }
//            else
//            {
//
//                if(leftSalePriceAttributed.string.count > 0)
//                {
//                    let combination = NSMutableAttributedString()
//                    combination.append(self.getSimpleText(price: String(format:"%.2f",Double(Double(qty).roundTo(places: 2) * self.leftPowerPrice).roundTo(places:2)) + " \(currency) "))
//                    combination.append(leftSalePriceAttributed)
//                    self.labelLeftPrice.attributedText = combination
//                }
//                else
//                {
//                    self.labelLeftPrice.text = String(format:"%.2f",Double(Double(qty).roundTo(places: 2) * self.leftPowerPrice).roundTo(places: 2)) + " \(currency)"
//
//                }
//
//            }
//
//        }
//
//    }
//    @IBAction func buttonLeftPowerIncrement(_ sender: Any) {
//
//        if(Int(self.labelLeftQty.text!)! < arrayQunatity.count)
//        {
//            self.labelLeftQty.text = String(Int(self.labelLeftQty.text!)! + 1)
//            let qty = Int(self.labelLeftQty.text!)!
//            if(self.currency.uppercased() == "KWD")
//            {
//
//                if(leftSalePriceAttributed.string.count > 0)
//                {
//                    let combination = NSMutableAttributedString()
//                    combination.append(self.getSimpleText(price: String(format:"%.3f",Double(Double(qty).roundTo(places: 3) * self.leftPowerPrice).roundTo(places:3)) + " \(currency) "))
//                    combination.append(leftSalePriceAttributed)
//                    self.labelLeftPrice.attributedText = combination
//                }
//                else
//                {
//                    self.labelLeftPrice.text = String(format:"%.3f",Double(Double(qty).roundTo(places: 3) * self.leftPowerPrice).roundTo(places:3)) + " \(currency)"
//
//                }
//            }
//            else
//            {
//
//                if(leftSalePriceAttributed.string.count > 0)
//                {
//                    let combination = NSMutableAttributedString()
//                    combination.append(self.getSimpleText(price: String(format:"%.2f",Double(Double(qty).roundTo(places: 2) * self.leftPowerPrice).roundTo(places:2)) + " \(currency) "))
//                    combination.append(leftSalePriceAttributed)
//                    self.labelLeftPrice.attributedText = combination
//                }
//                else
//                {
//                    self.labelLeftPrice.text = String(format:"%.2f",Double(Double(qty).roundTo(places: 2) * self.leftPowerPrice).roundTo(places: 2)) + " \(currency)"
//
//                }
//
//            }
//
//        }
//
//    }
//    @IBAction func buttonRightPowerDecre(_ sender: Any) {
//
//
//        if(Int(self.labelRightQty.text!)! > 1 && (Int(self.labelRightQty.text!)! < arrayQunatity.count + 1))
//        {
//            self.labelRightQty.text = String(Int(self.labelRightQty.text!)! - 1)
//
//            let qty = Int(self.labelRightQty.text!)!
//            if(self.currency.uppercased() == "KWD")
//            {
//                if(rightSalePriceAttributed.string.count > 0)
//                {
//                    let combination = NSMutableAttributedString()
//                    combination.append(self.getSimpleText(price: String(format:"%.3f",Double(Double(qty).roundTo(places: 3) * self.rightPowerPrice).roundTo(places:3)) + " \(currency) "))
//                    combination.append(rightSalePriceAttributed)
//                    self.labelRightPrice.attributedText = combination
//                }
//                else
//                {
//
//                    self.labelRightPrice.text = String(format:"%.3f",Double(Double(qty).roundTo(places: 3) * self.rightPowerPrice).roundTo(places: 3)) + " \(currency)"
//                }
//            }
//            else
//            {
//
//                if(rightSalePriceAttributed.string.count > 0)
//                {
//                    let combination = NSMutableAttributedString()
//                    combination.append(self.getSimpleText(price: String(format:"%.2f",Double(Double(qty).roundTo(places: 2) * self.rightPowerPrice).roundTo(places:2)) + " \(currency) "))
//                    combination.append(rightSalePriceAttributed)
//                    self.labelRightPrice.attributedText = combination
//                }
//                else
//                {
//
//                    self.labelRightPrice.text = String(format:"%.2f",Double(Double(qty).roundTo(places: 2) * self.rightPowerPrice).roundTo(places: 2)) + " \(currency)"
//                }
//
//            }
//        }
//
//    }
//    @IBAction func buttonRightPowerIncrement(_ sender: Any) {
//
//
//        if(Int(self.labelRightQty.text!)! < arrayQunatity.count)
//        {
//            self.labelRightQty.text = String(Int(self.labelRightQty.text!)! + 1)
//            let qty = Int(self.labelRightQty.text!)!
//            if(self.currency.uppercased() == "KWD")
//            {
//                if(rightSalePriceAttributed.string.count > 0)
//                {
//                    let combination = NSMutableAttributedString()
//                    combination.append(self.getSimpleText(price: String(format:"%.3f",Double(Double(qty).roundTo(places: 3) * self.rightPowerPrice).roundTo(places:3)) + " \(currency) "))
//                    combination.append(rightSalePriceAttributed)
//                    self.labelRightPrice.attributedText = combination
//                }
//                else
//                {
//
//                    self.labelRightPrice.text = String(format:"%.3f",Double(Double(qty).roundTo(places: 3) * self.rightPowerPrice).roundTo(places: 3)) + " \(currency)"
//                }
//            }
//            else
//            {
//
//                if(rightSalePriceAttributed.string.count > 0)
//                {
//                    let combination = NSMutableAttributedString()
//                    combination.append(self.getSimpleText(price: String(format:"%.2f",Double(Double(qty).roundTo(places: 2) * self.rightPowerPrice).roundTo(places:2)) + " \(currency) "))
//                    combination.append(rightSalePriceAttributed)
//                    self.labelRightPrice.attributedText = combination
//                }
//                else
//                {
//
//                    self.labelRightPrice.text = String(format:"%.2f",Double(Double(qty).roundTo(places: 2) * self.rightPowerPrice).roundTo(places: 2)) + " \(currency)"
//                }
//
//            }
//        }
//    }
    
    func showAlertStock()
    {
        let alertView = UIAlertController(title: NSLocalizedString("MSG31", comment: "").uppercased(), message: "", preferredStyle: .alert)
        let msgFont = [NSAttributedString.Key.font: UIFont(name: FontLocalization.medium.strValue, size: 15.0)!]
        let msgAttrString = NSMutableAttributedString(string: NSLocalizedString("MSG315", comment: ""), attributes: msgFont)
        alertView.setValue(msgAttrString, forKey: "attributedMessage")
        
        let alertAction = UIAlertAction(title: NSLocalizedString("MSG18", comment: ""), style: .default) { (alert) in
        }
        alertAction.setValue(AppColors.SelcetedColor, forKey: "titleTextColor")
        alertView.addAction(alertAction)
        self.present(alertView, animated: true, completion: nil)
    }
//    func hidePower()
//    {
//        self.labelPower.isHidden = true
//        heightConstrintsPower.constant = 0
//        self.buttonSelectPower.isHidden = true
//    }
//    func showPower()
//    {
//        self.labelPower.isHidden = false
//        heightConstrintsPower.constant = 40
//        self.buttonSelectPower.isHidden = false
//    }
//    func showPowerList()
//    {
//        self.labelPower.text = ""
//
//        //        if(leftPower == KeyConstant.kNoPower && rightPower == KeyConstant.kNoPower)
//        //        {
//        //            leftPower = 0.0
//        //            rightPower = 0.0
//        //            self.viewDidLoad()
//        //        }
//
//
//        if(!(rightPower == KeyConstant.kNoPower))
//        {
//            let rightSelected  = NSLocalizedString("MSG259", comment: "") + String(format:"%.2f",rightPower)
//            self.labelPower.text = rightSelected
//        }
//        if(!(leftPower == KeyConstant.kNoPower))
//        {
//            let leftSelected  = NSLocalizedString("MSG258", comment: "") + String(format:"%.2f",leftPower)
//
//            if((self.labelPower.text?.count)! > 0)
//            {
//                self.labelPower.text = self.labelPower.text! + "\n" + leftSelected
//
//            }
//            else
//            {
//               // self.labelPower.text =  leftSelected
//            }
//        }
//
//
//
//    }
//    func showFavIcon()
//    {
//        self.buttonFav.setImage(UIImage(named: "heart-s"), for: .normal)
//        self.buttonBuyNow.setTitle(NSLocalizedString("MSG238", comment: ""), for: .normal)
//
//
//
//        print(KeyConstant.sharedAppDelegate.getUserId())
//        WishListViewModel().getAllWishlistProduct(vc: self, completionHandler: { (success: Bool, errorC:Error?) in
//            DispatchQueue.main.async {
//
//                self.collectionView.reloadData()
//
//                if(WishListModel.sharedInstance.arrayWishList.count > 0)
//                {
//                    for ind in 0..<WishListModel.sharedInstance.arrayWishList.count
//                    {
//                        if(WishListModel.sharedInstance.arrayWishList[ind].wishlistProductId == self.productId)
//                        {
//                            self.buttonFav.setImage(UIImage(named: "heart-fill"), for: .normal)
//                            self.buttonBuyNow.setTitle(NSLocalizedString("MSG239", comment: ""), for: .normal)
//
//                        }
//                    }
//                }
//            }
//
//        })
//
//    }
    
    @IBAction func buttonShare(_ sender: UIButton) {


        //            //com.Lenzzo://product?id=%@&name=%@
        if let productId = self.dicProductList["id"]?.string
        {

            if(productId.count > 0)
            {
                // let shareProductURL = "com.Lenzzo://product?id=\(productId)"
                 
                let shareProductURL = "http://e-gamesstore.com/share?productId=\(productId)"
//                    "http://139.59.93.33/share?productId=\(productId)"
//                    "http://139.59.93.33/share?productId=\(productId)" //"https://www.e-gamesstore.com/share.php?productid=\(productId)"

                let url1 = URL(string:shareProductURL)

                let activityViewController : UIActivityViewController = UIActivityViewController(
                    activityItems: [url1], applicationActivities: nil)

                activityViewController.popoverPresentationController?.sourceView = sender

                self.present(activityViewController, animated: true, completion: nil)

            }
        }
    }
    
    
//    func ratingShow()
//    {
//
//        if let rating = Double(self.dicRatingList["avg_rating"]?.string ?? "0.0")?.roundTo(places: 0)
//        {
//            let imageSelected = UIImage(named:"star")
//            let imageUnSelected = UIImage(named:"star_blank_50x50")
//
//            self.imageRating1.image = imageUnSelected
//            self.imageRating2.image = imageUnSelected
//            self.imageRating3.image = imageUnSelected
//            self.imageRating4.image = imageUnSelected
//            self.imageRating5.image = imageUnSelected
//
//
//            switch Int(rating)
//            {
//            case 0 :
//                break
//            case 1 :
//                self.imageRating1.image = imageSelected
//                break
//            case 2 :
//                self.imageRating1.image = imageSelected
//                self.imageRating2.image = imageSelected
//                break
//            case 3 :
//                self.imageRating1.image = imageSelected
//                self.imageRating2.image = imageSelected
//                self.imageRating3.image = imageSelected
//                break
//            case 4 :
//                self.imageRating1.image = imageSelected
//                self.imageRating2.image = imageSelected
//                self.imageRating3.image = imageSelected
//                self.imageRating4.image = imageSelected
//                break
//            case 5 :
//                self.imageRating1.image = imageSelected
//                self.imageRating2.image = imageSelected
//                self.imageRating3.image = imageSelected
//                self.imageRating4.image = imageSelected
//                self.imageRating5.image = imageSelected
//
//                break
//            default:
//                break
//
//            }
//        }
//
//        if let reviewed = self.dicRatingList["rating_count"]?.int
//        {
//            if(reviewed > 1)
//            {
//                self.labelReviewTotal.text = String(reviewed) + " " + NSLocalizedString("MSG274", comment: "")
//            }
//            else if(reviewed > 0)
//            {
//                self.labelReviewTotal.text = String(reviewed) + " " + NSLocalizedString("MSG275", comment: "")
//
//            }
//            else
//            {
//                self.labelReviewTotal.text = ""
//            }
//        }
//    }
    func reloadDataSelected() {
//
//
//
//
//        print(KeyConstant.sharedAppDelegate.getUserId())
//
//        if(APITypeAction.count > 0 && paramOfAction.count > 0)
//        {
//            if(APITypeAction == KeyConstant.APIAddWishlist)
//            {
//                let productId = paramOfAction["product_id"]
//                var params: [String:String]?
//                if(typeCart == arraTypeCart[0])
//                {
//
//
//                    params = ["user_id":KeyConstant.sharedAppDelegate.getUserId(),"product_id":paramOfAction["product_id"] ?? "","quantity":labelLeftQty.text ?? "","shade":""]
//
//                    if(self.buttonSelectPower.isHidden == false)
//                    {
//                        params?["left_eye_power"] = String(leftPower)
//                        params?["right_eye_power"] = String(rightPower)
//                    }
//                }
//                else
//                {
//                    params = ["user_id":KeyConstant.sharedAppDelegate.getUserId(),"product_id":paramOfAction["product_id"] ?? "","quantity":"1","shade":"","left_eye_power":paramOfAction["left_eye_power"] ?? "","right_eye_power":paramOfAction["right_eye_power"] ?? ""]
//                }
//                WishListViewModel().addToWishlist(vc: self, param: params!) { (isDone:Bool, error:Error?) in
//
//                    self.APITypeAction = ""
//                    self.paramOfAction.removeAll()
//                    self.showFavIcon()
//
//
//                }
//            }
//
//            else if(APITypeAction == KeyConstant.APIAddCart)
//            {
//                self.addToCart()
//
//            }
//            else
//            {
//                self.paramOfAction.removeAll()
//                self.APITypeAction = ""
//
//            }
//        }
//        else
//        {
//            self.paramOfAction.removeAll()
//            self.APITypeAction = ""
//
//        }
//
//
//
        showCartCount()
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
        if(HelperArabic().isArabicLanguage())
               {
                   
                self.buttonMenu.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                   
               }
               else
               {
                   self.buttonMenu.transform = CGAffineTransform(rotationAngle: 245)
               }
        
        
        
    }
    
    
    func setSlider()
    {
        
        imageArray.removeAll()
        
        if(self.dicProductList["product_images"]?.string?.count ?? 0 > 0)
        {
            self.imageNoImage.isHidden = true
            
            carouselView.delegate = self
            
            var arraImages = [String]()
            
            let stringProductImages = self.dicProductList["product_images"]?.string ?? ""
            if((stringProductImages.count) ?? 0 > 0)
            {
                arraImages = stringProductImages.components(separatedBy: ",") ?? [String]()
                
            }
            
            
            for ind in 0..<arraImages.count
            {
                imageArray.insert(KeyConstant.kImageBaseProductURL + arraImages[ind], at: imageArray.count)
            }
            
            carouselView.setCarouselData(paths: imageArray,  describedTitle: [], isAutoScroll: true, timer: 4.0, defaultImage: "noImage")
        }
        else
        {
            self.imageNoImage.isHidden = false
        }
        carouselView.setCarouselOpaque(layer: false, describedTitle: false, pageIndicator: false)
        carouselView.setCarouselLayout(displayStyle: 0, pageIndicatorPositon: 2, pageIndicatorColor: AppColors.SelcetedColor, describedTitleColor: nil, layerColor: .clear)
        
    }
    
    override func viewDidLayoutSubviews() {

        if(self.arrayRelatedProductList.count > 0)
        {
            self.relatedProductContainerViewHieghtConstraint.constant = 184
            //            self.labelDesc.text = self.labelDesc.text
            //            if(HelperArabic().isArabicLanguage())
            //            {
            //                if let description_ar =  self.dicProductList["description_ar"]?.string
            //                {
            //                    self.labelDesc.text = description_ar.html2String
            //                }
            //            }
            //
            if(self.itemWidth == 0.0)
            {
                
                


               // let margin: CGFloat = 10
                //let cellsPerRow = 2.1

//                guard let collectionView = self.collectionView, let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
//                flowLayout.minimumInteritemSpacing = margin
//                flowLayout.minimumLineSpacing = margin
//                flowLayout.sectionInset = UIEdgeInsets(top: margin, left: 5, bottom: margin, right: 5)
//
//                collectionView.contentInsetAdjustmentBehavior = .always
//                let marginsAndInsets = flowLayout.sectionInset.left + flowLayout.sectionInset.right + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + flowLayout.minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
//                self.itemWidth = (216 - marginsAndInsets)
//                flowLayout.itemSize =  CGSize(width: self.itemWidth, height: self.itemWidth * 1.9)

//                if(self.arrayRelatedProductList.count == 0)
//                {
//                    self.collectionViewConstant.constant = 0
//                    self.labelRelatedProduct.isHidden = true
//                    self.scrollView.contentSize = CGSize(width: self.scrollView.bounds.size.width, height: self.labelRelatedProduct.frame.origin.y + self.descriptionHeightConstant.constant + 50)
//                }
//                else
//                {
//                    self.collectionViewConstant.constant = (self.itemWidth * 2) + 20
//
//                    self.scrollView.contentSize = CGSize(width:self.scrollView.bounds.size.width, height: self.labelRelatedProduct.frame.origin.y + self.collectionViewConstant.constant + self.labelDesc.requiredHeight )
//                }

                self.collectionView.reloadData()
            }
        }
        else
        {
            
            self.relatedProductContainerViewHieghtConstraint.constant = 0
//            self.collectionViewConstant.constant = 0
//            self.labelRelatedProduct.isHidden = true
//            self.scrollView.contentSize = CGSize(width: self.scrollView.bounds.size.width, height: self.labelDesc.frame.origin.y + self.labelDesc.requiredHeight)
        }


    }
    
    @IBAction func buttonActionBrand(_ sender: Any) {
        
    }
    
    
    @IBAction func buttonSelectPower(_ sender: Any) {
        
        self.getPowerList(dicDataForClearedContact: [:])
        
        
        /*
         
         
         if let leftStartRange = self.dicProductList["power"]?["start_range"].string
         {
         if(leftStartRange.count > 0)
         {
         
         //                let startRange = Double(leftStartRange)?.roundTo(places: 2) ?? 0.0
         //                let endRange = Double(self.dicProductList["power"]?["end_range"].string ?? "0.0")?.roundTo(places: 2) ?? 0.0
         //                let diff_range = Double(self.dicProductList["power"]?["diff_range"].string ?? "0.0")?.roundTo(places: 2) ?? 0.0
         //
         //              let diff_range_above = Double(self.dicProductList["power"]?["diff_range_above"].string ?? "0.0")?.roundTo(places: 2) ?? 0.0
         //
         //
         //                  let range_above = Double(self.dicProductList["power"]?["range_above"].string ?? "0.0")?.roundTo(places: 2) ?? 0.0
         //
         self.getPowerList()
         
         
         //                var rangeAboveNegative = 0.0
         //                var rangeAbovePositive = 0.0
         //
         //                if(range_above < 0)
         //                {
         //                 rangeAboveNegative = range_above
         //                rangeAbovePositive = range_above * -1
         //                }
         //                else
         //                {
         //                    rangeAboveNegative = range_above * -1
         //                    rangeAbovePositive = range_above
         //                }
         //
         //                var arrayTempRange = [Double]()
         ////                var arrayTempAboveRange = [Double]()
         //
         //
         //
         //                let sequenceBelowRange = stride(from: rangeAboveNegative, to: rangeAbovePositive, by: diff_range)
         //                for element in sequenceBelowRange {
         //                    arrayTempRange.insert(element.roundTo(places: 2), at: arrayTempRange.count)
         //
         //                }
         //
         //                let sequenceAbovePositive = stride(from: rangeAbovePositive, to: endRange, by: diff_range_above)
         //                for element in sequenceAbovePositive {
         //
         //                    arrayTempRange.insert(element.roundTo(places: 2), at: arrayTempRange.count)
         //
         //                }
         //
         //                let sequenceAboveNegative = stride(from: rangeAboveNegative, to: startRange, by: -diff_range_above)
         //                for element in sequenceAboveNegative {
         //
         //
         //                    arrayTempRange.insert(element.roundTo(places: 2), at: arrayTempRange.count)
         //
         //
         //                }
         //
         //
         
         //                for range in stride(from: startRange, to: endRange, by: diff_range) {
         //                    print("diff_range \(range)")
         //
         //                    if(range.roundTo(places: 2) > rangeAboveNegative && range.roundTo(places: 2) < 0)
         //                    {
         //                        print("a00 \(range.roundTo(places: 2))")
         //
         //                        arrayTempRange.insert(range.roundTo(places: 2), at: arrayTempRange.count)
         //                    }
         //                    else if(range.roundTo(places: 2) < rangeAbovePositive && range.roundTo(places: 2) > 0)
         //                    {
         //                        print("a0 \(range.roundTo(places: 2))")
         //
         //                        arrayTempRange.insert(range.roundTo(places: 2), at: arrayTempRange.count)
         //                    }
         //                    else if(range.roundTo(places: 2) == rangeAbovePositive || range.roundTo(places: 2) == rangeAboveNegative)
         //                    {
         //                        print("a1 \(range.roundTo(places: 2))")
         //
         //                        arrayTempRange.insert(range.roundTo(places: 2), at: arrayTempRange.count)
         //
         //                    }
         //                }
         //
         //                for range1 in stride(from: startRange, to: endRange, by: diff_range_above) {
         //                    print("diff_range_above \(range1)")
         //                    if(range1.roundTo(places: 2) > 0)
         //                    {
         //                    if(range1.roundTo(places: 2) > rangeAbovePositive)
         //                    {
         //                        print("a2 \(range1.roundTo(places: 2))")
         //                    arrayTempAboveRange.insert(range1.roundTo(places: 2), at: arrayTempAboveRange.count)
         //                    }
         //                    else if(range1.roundTo(places: 2) < rangeAboveNegative )
         //                    {
         //                        print("a3 \(range1.roundTo(places: 2))")
         //
         //                        arrayTempAboveRange.insert(range1.roundTo(places: 2), at: arrayTempAboveRange.count)
         //                    }
         //                    }
         //
         //                }
         //
         //                for range2 in stride(from: startRange, to: endRange, by: -diff_range_above) {
         //                    print("diff_range_above_minise \(range2)")
         //                    if(range2.roundTo(places: 2) < 0)
         //                    {
         //                        if(range2.roundTo(places: 2) > rangeAbovePositive)
         //                        {
         //                            print("a4 \(range2.roundTo(places: 2))")
         //                            arrayTempAboveRange.insert(range2.roundTo(places: 2), at: arrayTempAboveRange.count)
         //                        }
         //                        else if(range2.roundTo(places: 2) < rangeAboveNegative )
         //                        {
         //                            print("a5 \(range2.roundTo(places: 2))")
         //
         //                            arrayTempAboveRange.insert(range2.roundTo(places: 2), at: arrayTempAboveRange.count)
         //                        }
         //                    }
         //
         //                }
         //
         //                arrayTempAboveRange.insert(endRange.roundTo(places: 2), at: arrayTempAboveRange.count)
         //                arrayTempRange.append(contentsOf: arrayTempAboveRange)
         
         
         //                if(!(arrayTempRange.contains(0.00)))
         //                {
         //                    arrayTempRange.insert(0.00, at: 0)
         //
         //                }
         //                arrayTempRange.sort()
         //               // var mySet = Set<Double>(arrayTempRange)
         //
         //               // arrayTempRange = Array(mySet)
         //                print(arrayTempRange)
         //                powerSelectionVC.leftPowerOutOfStock =  [String]()
         //                powerSelectionVC.rightPowerOutOfStock = [String]()
         //                if let leftOutStockRange = self.dicProductList["l_p_n_available"]?.string
         //                {
         //                    if(leftOutStockRange.count > 0)
         //                    {
         //                        powerSelectionVC.leftPowerOutOfStock =  leftOutStockRange.components(separatedBy: ",")
         //                    }
         //                }
         //                if let rightOutStockRange = self.dicProductList["r_p_n_available"]?.string
         //                {
         //                    if(rightOutStockRange.count > 0)
         //                    {
         //                        powerSelectionVC.rightPowerOutOfStock =  rightOutStockRange.components(separatedBy: ",")
         //                    }
         //                }
         //                powerSelectionVC.arrayLeft = arrayTempRange
         //                powerSelectionVC.arrayRight =  arrayTempRange
         //                self.present(powerSelectionVC, animated: false, completion: nil)
         return
         }
         }
         
         //        powerSelectionVC.leftPowerOutOfStock =  [String]()
         //        powerSelectionVC.rightPowerOutOfStock =  [String]()
         //        powerSelectionVC.arrayLeft =  [0.0]
         //        powerSelectionVC.arrayRight =  [0.0]
         //self.present(powerSelectionVC, animated: false, completion: nil)
         
         */
    }
    
    
    func getPowerList(dicDataForClearedContact:[String:String])
    {
        
        
        
        
        if(self.dicProductList["power_range"]?.array?.count ?? 0 > 0)
        {
            var arrayTempRange = [Double]()
            var arrayRange = [JSON]()
            
            arrayRange = self.dicProductList["power_range"]?.array ?? [JSON]()
            for ind in 0..<arrayRange.count
            {
                arrayTempRange.insert(Double(arrayRange[ind].string ?? "0.00")?.roundTo(places: 2) ?? 0.0, at: arrayTempRange.count)
            }
            
            if(!(arrayTempRange.contains(0.00)))
            {
                arrayTempRange.insert(0.00, at: 0)
            }
            arrayTempRange.sort()
            print(arrayTempRange)
            let powerSelectionVC = self.storyboard?.instantiateViewController(withIdentifier: "PowerSelectionVC") as! PowerSelectionVC
            powerSelectionVC.modalPresentationStyle = .overCurrentContext
            powerSelectionVC.delegatePower = self
            powerSelectionVC.leftPower =  self.leftPower
            powerSelectionVC.rightPower =  self.rightPower
            powerSelectionVC.leftPowerOutOfStock =  [String]()
            powerSelectionVC.rightPowerOutOfStock = [String]()
            if let leftOutStockRange = self.dicProductList["l_p_n_available"]?.string
            {
                if(leftOutStockRange.count > 0)
                {
                    powerSelectionVC.leftPowerOutOfStock =  leftOutStockRange.components(separatedBy: ",")
                }
            }
            
            if let rightOutStockRange = self.dicProductList["r_p_n_available"]?.string
            {
                if(rightOutStockRange.count > 0)
                {
                    powerSelectionVC.rightPowerOutOfStock =  rightOutStockRange.components(separatedBy: ",")
                }
            }
            powerSelectionVC.arrayLeft = arrayTempRange
            powerSelectionVC.arrayRight =  arrayTempRange
            
            if(dicDataForClearedContact.count > 0)
            {
                powerSelectionVC.dicDataForClearedContact =  dicDataForClearedContact
            }
            self.present(powerSelectionVC, animated: false, completion: nil)
            
        }
        
        
        
        
        
        
    }
    func updateDatailClearContact()
    {
       // showCartCount()
       // self.checkoutAlertView()
        
    }
    
//    func getSlectedPower(left: Double, right: Double) {
//
//        self.labelLeftPrice.text = ""
//        self.labelRightPrice.text = ""
//        leftSalePriceAttributed = NSMutableAttributedString()
//        rightSalePriceAttributed = NSMutableAttributedString()
//
//
//        leftPower = left
//        rightPower = right
//
//
//        self.labelLeftQty.text = String(self.arrayQunatity[0])
//        self.labelLeftTitleQty.text = NSLocalizedString("MSG419", comment: "")
//
//
//
//        rightPowerHeightConstraint.constant = 0
//        self.rightView.isHidden = true
//
//        print(leftPower,rightPower)
//        if(leftPower == KeyConstant.kNoPower && rightPower == KeyConstant.kNoPower)
//        {
//            leftPower = 0.0
//            rightPower = 0.0
//        }
//
//        if(!(leftPower == KeyConstant.kNoPower || rightPower == KeyConstant.kNoPower))
//        {
//            if(!(leftPower == rightPower))
//            {
//                rightPowerHeightConstraint.constant = 52
//                self.rightView.isHidden = false
//                self.labelLeftTitleQty.text = NSLocalizedString("MSG417", comment: "")
//                self.labelRightTitleQty.text = NSLocalizedString("MSG418", comment: "")
//                setLeftView()
//                setRightView()
//                self.showPowerList()
//
//                return
//
//
//            }
//        }
//
//        if(!(leftPower == 0.0 || rightPower == 0.0))
//        {
//            if let strWithPowerPrice = self.dicProductList["with_power_price"]?.string
//            {
//                if(strWithPowerPrice.count > 0)
//                {
//
//
//                    if (self.dicProductList["sale_price"]?.string?.count ?? 0 > 0)
//                    {
//                        let sellPriceTemp  = Double(self.dicProductList["sale_price"]?.string ?? "0.0") ?? 0.0
//
//                        if(sellPriceTemp > 0.0)
//                        {
//                            var baseprice = 0.0
//                            var tempprice = 0.0
//                            var sprice = ""
//                            if(self.currency.uppercased() == "KWD")
//                            {
//                                tempprice = Double(self.dicProductList["sale_price"]?.string ?? "0.0")?.roundTo(places: 3) ?? 0.0
//                                baseprice = Double(self.dicProductList["with_power_price"]?.string ?? "0.0")?.roundTo(places: 3) ?? 0.0
//
//                            }
//                            else
//                            {
//                                tempprice = Double(self.dicProductList["sale_price"]?.string ?? "0.0")?.roundTo(places: 3) ?? 0.0
//                                baseprice = Double(self.dicProductList["with_power_price"]?.string ?? "0.0")?.roundTo(places: 3) ?? 0.0
//                            }
//                            if(tempprice < baseprice)
//                            {
//                                tempprice = baseprice - tempprice
//                                if(self.currency.uppercased() == "KWD")
//                                {
//                                    sprice = String(format:"%.3f",Double(tempprice).roundTo(places: 3) )
//                                }
//                                else
//                                {
//                                    sprice = String(format:"%.2f",Double(tempprice).roundTo(places: 2) )
//
//                                }
//
//                                let combination = NSMutableAttributedString()
//                                combination.append(self.getSimpleText(price: String(sprice) + " \(self.currency) "))
//                                combination.append(self.getStrikeText(price: strWithPowerPrice))
//
//                                leftSalePriceAttributed = self.getStrikeText(price: strWithPowerPrice + " \(self.currency)")
//
//                                combination.append(self.getSimpleText(price: " \(self.currency)"))
//                                self.labelLeftPrice.attributedText = combination
//                                if(self.currency.uppercased() == "KWD")
//                                {
//                                    self.leftPowerPrice = Double(tempprice).roundTo(places: 3)
//                                }
//                                else
//                                {
//                                    self.leftPowerPrice = Double(tempprice).roundTo(places: 2)
//                                }
//
//                                self.showPowerList()
//
//
//                                return
//
//                            }
//                        }
//
//                    }
//
//                    if(self.currency.uppercased() == "KWD")
//                    {
//                        self.leftPowerPrice = Double(strWithPowerPrice)?.roundTo(places: 3) ?? 0.0
//
//                        self.labelLeftPrice.text = String(format:"%.3f", self.leftPowerPrice) + " \(self.currency)"
//
//                    }
//                    else
//                    {
//                        self.leftPowerPrice = Double(strWithPowerPrice)?.roundTo(places: 2) ?? 0.0
//
//                        self.labelLeftPrice.text = String(format:"%.2f",self.leftPowerPrice) + " \(self.currency)"
//
//
//                    }
//                    self.showPowerList()
//
//                    return
//                }
//            }
//
//        }
//
//
//
//        if (self.dicProductList["sale_price"]?.string?.count ?? 0 > 0)
//        {
//            let sellPriceTemp  = Double(self.dicProductList["sale_price"]?.string ?? "0.0") ?? 0.0
//            if(sellPriceTemp > 0.0)
//            {
//                let sellPriceTemp  = Double(self.dicProductList["sale_price"]?.string ?? "0.0") ?? 0.0
//
//                if(sellPriceTemp > 0.0)
//                {
//                    var baseprice = 0.0
//                    var tempprice = 0.0
//                    var sprice = ""
//                    if(self.currency.uppercased() == "KWD")
//                    {
//                        tempprice = Double(self.dicProductList["sale_price"]?.string ?? "0.0")?.roundTo(places: 3) ?? 0.0
//                        baseprice = Double(self.dicProductList["price"]?.string ?? "0.0")?.roundTo(places: 3) ?? 0.0
//
//                    }
//                    else
//                    {
//                        tempprice = Double(self.dicProductList["sale_price"]?.string ?? "0.0")?.roundTo(places: 3) ?? 0.0
//                        baseprice = Double(self.dicProductList["price"]?.string ?? "0.0")?.roundTo(places: 3) ?? 0.0
//                    }
//                    if(tempprice < baseprice)
//                    {
//                        tempprice = baseprice - tempprice
//                        if(self.currency.uppercased() == "KWD")
//                        {
//                            sprice = String(format:"%.3f",Double(tempprice).roundTo(places: 3) )
//                        }
//                        else
//                        {
//                            sprice = String(format:"%.2f",Double(tempprice).roundTo(places: 2) )
//
//                        }
//
//                        let combination = NSMutableAttributedString()
//                        combination.append(self.getSimpleText(price: String(sprice) + " \(self.currency) "))
//
//                        var price = ""
//                        if(self.currency.uppercased() == "KWD")
//                        {
//                            price = String(format:"%.3f",Double(self.dicProductList["price"]?.string ?? "0.0")?.roundTo(places: 3) ?? 0.0)
//                        }
//                        else
//                        {
//                            price = String(format:"%.2f",Double(self.dicProductList["price"]?.string ?? "0.0")?.roundTo(places: 2) ?? 0.0)
//
//                        }
//                        combination.append(self.getStrikeText(price: price))
//                        self.leftSalePriceAttributed = self.getStrikeText(price: price + " \(self.currency)")
//                        combination.append(self.getSimpleText(price: " \(self.currency)"))
//                        self.labelLeftPrice.attributedText = combination
//                        if(self.currency.uppercased() == "KWD")
//                        {
//                            self.leftPowerPrice = Double(tempprice).roundTo(places: 3)
//                        }
//                        else
//                        {
//                            self.leftPowerPrice = Double(tempprice).roundTo(places: 2)
//                        }
//
//                        self.showPowerList()
//
//
//                        return
//
//                    }
//                }
//
//            }
//        }
//
//        if(self.currency.uppercased() == "KWD")
//        {
//
//            self.leftPowerPrice = Double(self.dicProductList["price"]?.string ?? "0.0")?.roundTo(places: 3) ?? 0.0
//
//            self.labelLeftPrice.text = String(format:"%.3f",self.leftPowerPrice) + " \(self.currency)"
//
//        }
//        else
//        {
//
//            self.leftPowerPrice = Double(self.dicProductList["price"]?.string ?? "0.0")?.roundTo(places: 2) ?? 0.0
//
//            self.labelLeftPrice.text = String(format:"%.2f",self.leftPowerPrice) + " \(self.currency)"
//
//
//        }
//        self.showPowerList()
//    }
    
 //   func setRightView()
//    {
//        self.labelRightQty.text = String(self.arrayQunatity[0])
//        self.labelRightPrice.text = ""
//        self.rightPowerPrice = 0.0
//
//        if(!(rightPower == 0.0))
//        {
//            if let strWithPowerPrice = self.dicProductList["with_power_price"]?.string
//            {
//                if(strWithPowerPrice.count > 0)
//                {
//
//
//                    if (self.dicProductList["sale_price"]?.string?.count ?? 0 > 0)
//                    {
//                        let sellPriceTemp  = Double(self.dicProductList["sale_price"]?.string ?? "0.0") ?? 0.0
//
//                        if(sellPriceTemp > 0.0)
//                        {
//                            var baseprice = 0.0
//                            var tempprice = 0.0
//                            var sprice = ""
//                            if(self.currency.uppercased() == "KWD")
//                            {
//                                tempprice = Double(self.dicProductList["sale_price"]?.string ?? "0.0")?.roundTo(places: 3) ?? 0.0
//                                baseprice = Double(self.dicProductList["with_power_price"]?.string ?? "0.0")?.roundTo(places: 3) ?? 0.0
//
//                            }
//                            else
//                            {
//                                tempprice = Double(self.dicProductList["sale_price"]?.string ?? "0.0")?.roundTo(places: 3) ?? 0.0
//                                baseprice = Double(self.dicProductList["with_power_price"]?.string ?? "0.0")?.roundTo(places: 3) ?? 0.0
//                            }
//                            if(tempprice < baseprice)
//                            {
//                                tempprice = baseprice - tempprice
//                                if(self.currency.uppercased() == "KWD")
//                                {
//                                    sprice = String(format:"%.3f",Double(tempprice).roundTo(places: 3) )
//                                }
//                                else
//                                {
//                                    sprice = String(format:"%.2f",Double(tempprice).roundTo(places: 2) )
//
//                                }
//
//                                let combination = NSMutableAttributedString()
//                                combination.append(self.getSimpleText(price: String(sprice) + " \(self.currency) "))
//                                combination.append(self.getStrikeText(price: strWithPowerPrice))
//                                self.rightSalePriceAttributed = self.getStrikeText(price: strWithPowerPrice  + " \(self.currency)")
//
//                                combination.append(self.getSimpleText(price: " \(self.currency)"))
//                                self.labelRightPrice.attributedText = combination
//                                if(self.currency.uppercased() == "KWD")
//                                {
//                                    self.rightPowerPrice = Double(tempprice).roundTo(places: 3)
//                                }
//                                else
//                                {
//                                    self.rightPowerPrice = Double(tempprice).roundTo(places: 2)
//                                }
//
//
//
//                                return
//
//
//                            }
//
//                        }
//                    }
//
//                    if(self.currency.uppercased() == "KWD")
//                    {
//                        self.rightPowerPrice = Double(self.dicProductList["with_power_price"]?.string ?? "0.0")?.roundTo(places: 3) ?? 0.0
//                        self.labelRightPrice.text = String(format:"%.3f",self.rightPowerPrice) + " \(self.currency)"
//
//                    }
//                    else
//                    {
//                        self.rightPowerPrice = Double(self.dicProductList["with_power_price"]?.string ?? "0.0")?.roundTo(places: 2) ?? 0.0
//                        self.labelRightPrice.text = String(format:"%.2f",self.rightPowerPrice) + " \(self.currency)"
//
//
//                    }
//                    return
//                }
//            }
//
//        }
//
//
//
//        if (self.dicProductList["sale_price"]?.string?.count ?? 0 > 0)
//        {
//            let sellPriceTemp  = Double(self.dicProductList["sale_price"]?.string ?? "0.0") ?? 0.0
//            if(sellPriceTemp > 0.0)
//            {
//                let sellPriceTemp  = Double(self.dicProductList["sale_price"]?.string ?? "0.0") ?? 0.0
//
//                if(sellPriceTemp > 0.0)
//                {
//                    var baseprice = 0.0
//                    var tempprice = 0.0
//                    var sprice = ""
//                    if(self.currency.uppercased() == "KWD")
//                    {
//                        tempprice = Double(self.dicProductList["sale_price"]?.string ?? "0.0")?.roundTo(places: 3) ?? 0.0
//                        baseprice = Double(self.dicProductList["price"]?.string ?? "0.0")?.roundTo(places: 3) ?? 0.0
//
//                    }
//                    else
//                    {
//                        tempprice = Double(self.dicProductList["sale_price"]?.string ?? "0.0")?.roundTo(places: 3) ?? 0.0
//                        baseprice = Double(self.dicProductList["price"]?.string ?? "0.0")?.roundTo(places: 3) ?? 0.0
//                    }
//                    if(tempprice < baseprice)
//                    {
//                        tempprice = baseprice - tempprice
//                        if(self.currency.uppercased() == "KWD")
//                        {
//                            sprice = String(format:"%.3f",Double(tempprice).roundTo(places: 3) )
//                        }
//                        else
//                        {
//                            sprice = String(format:"%.2f",Double(tempprice).roundTo(places: 2) )
//
//                        }
//
//                        let combination = NSMutableAttributedString()
//                        combination.append(self.getSimpleText(price: String(sprice) + " \(self.currency) "))
//
//                        var price = ""
//                        if(self.currency.uppercased() == "KWD")
//                        {
//                            price = String(format:"%.3f",Double(self.dicProductList["price"]?.string ?? "0.0")?.roundTo(places: 3) ?? 0.0)
//                        }
//                        else
//                        {
//                            price = String(format:"%.2f",Double(self.dicProductList["price"]?.string ?? "0.0")?.roundTo(places: 2) ?? 0.0)
//
//                        }
//                        combination.append(self.getStrikeText(price: price))
//                        self.rightSalePriceAttributed = self.getStrikeText(price: price + " \(self.currency)")
//
//                        combination.append(self.getSimpleText(price: " \(self.currency)"))
//                        self.labelRightPrice.attributedText = combination
//                        if(self.currency.uppercased() == "KWD")
//                        {
//                            self.rightPowerPrice = Double(tempprice).roundTo(places: 3)
//                        }
//                        else
//                        {
//                            self.rightPowerPrice = Double(tempprice).roundTo(places: 2)
//                        }
//
//
//
//                        return
//
//                    }
//                }
//
//            }
//        }
//
//        if(self.currency.uppercased() == "KWD")
//        {
//            self.rightPowerPrice = Double(self.dicProductList["price"]?.string ?? "0.0")?.roundTo(places: 3) ?? 0.0
//            self.labelRightPrice.text = String(format:"%.3f",self.rightPowerPrice) + " \(self.currency)"
//
//        }
//        else
//        {
//            self.rightPowerPrice = Double(self.dicProductList["price"]?.string ?? "0.0")?.roundTo(places: 2) ?? 0.0
//            self.labelRightPrice.text = String(format:"%.2f",self.rightPowerPrice) + " \(self.currency)"
//
//
//        }
//
//    }
 //   func setLeftView()
//    {
//        self.labelLeftQty.text = String(self.arrayQunatity[0])
//        self.labelLeftPrice.text = ""
//        self.leftPowerPrice = 0.0
//
//        if(!(leftPower == 0.0))
//        {
//            if let strWithPowerPrice = self.dicProductList["with_power_price"]?.string
//            {
//                if(strWithPowerPrice.count > 0)
//                {
//
//                    if (self.dicProductList["sale_price"]?.string?.count ?? 0 > 0)
//                    {
//                        let sellPriceTemp  = Double(self.dicProductList["sale_price"]?.string ?? "0.0") ?? 0.0
//
//                        if(sellPriceTemp > 0.0)
//                        {
//                            var baseprice = 0.0
//                            var tempprice = 0.0
//                            var sprice = ""
//                            if(self.currency.uppercased() == "KWD")
//                            {
//                                tempprice = Double(self.dicProductList["sale_price"]?.string ?? "0.0")?.roundTo(places: 3) ?? 0.0
//                                baseprice = Double(self.dicProductList["with_power_price"]?.string ?? "0.0")?.roundTo(places: 3) ?? 0.0
//
//                            }
//                            else
//                            {
//                                tempprice = Double(self.dicProductList["sale_price"]?.string ?? "0.0")?.roundTo(places: 3) ?? 0.0
//                                baseprice = Double(self.dicProductList["with_power_price"]?.string ?? "0.0")?.roundTo(places: 3) ?? 0.0
//                            }
//                            if(tempprice < baseprice)
//                            {
//                                tempprice = baseprice - tempprice
//                                if(self.currency.uppercased() == "KWD")
//                                {
//                                    sprice = String(format:"%.3f",Double(tempprice).roundTo(places: 3) )
//                                }
//                                else
//                                {
//                                    sprice = String(format:"%.2f",Double(tempprice).roundTo(places: 2) )
//
//                                }
//
//                                let combination = NSMutableAttributedString()
//                                combination.append(self.getSimpleText(price: String(sprice) + " \(self.currency) "))
//                                combination.append(self.getStrikeText(price: strWithPowerPrice))
//                                self.leftSalePriceAttributed = self.getStrikeText(price: strWithPowerPrice + " \(self.currency)")
//
//                                combination.append(self.getSimpleText(price: " \(self.currency)"))
//                                self.labelLeftPrice.attributedText = combination
//                                if(self.currency.uppercased() == "KWD")
//                                {
//                                    self.leftPowerPrice = Double(tempprice).roundTo(places: 3)
//                                }
//                                else
//                                {
//                                    self.leftPowerPrice = Double(tempprice).roundTo(places: 2)
//                                }
//
//
//
//                                return
//
//                            }
//                        }
//                    }
//
//
//                    if(self.currency.uppercased() == "KWD")
//                    {
//                        self.leftPowerPrice = Double(self.dicProductList["with_power_price"]?.string ?? "0.0")?.roundTo(places: 3) ?? 0.0
//
//                        self.labelLeftPrice.text = String(format:"%.3f",self.leftPowerPrice) + " \(self.currency)"
//
//                    }
//                    else
//                    {
//                        self.leftPowerPrice = Double(self.dicProductList["with_power_price"]?.string ?? "0.0")?.roundTo(places: 2) ?? 0.0
//
//                        self.labelLeftPrice.text = String(format:"%.2f", self.leftPowerPrice) + " \(self.currency)"
//
//
//                    }
//                    return
//                }
//            }
//
//        }
//
//
//
//        if (self.dicProductList["sale_price"]?.string?.count ?? 0 > 0)
//        {
//            let sellPriceTemp  = Double(self.dicProductList["sale_price"]?.string ?? "0.0") ?? 0.0
//            if(sellPriceTemp > 0.0)
//            {
//                let sellPriceTemp  = Double(self.dicProductList["sale_price"]?.string ?? "0.0") ?? 0.0
//
//                if(sellPriceTemp > 0.0)
//                {
//                    var baseprice = 0.0
//                    var tempprice = 0.0
//                    var sprice = ""
//                    if(self.currency.uppercased() == "KWD")
//                    {
//                        tempprice = Double(self.dicProductList["sale_price"]?.string ?? "0.0")?.roundTo(places: 3) ?? 0.0
//                        baseprice = Double(self.dicProductList["price"]?.string ?? "0.0")?.roundTo(places: 3) ?? 0.0
//
//                    }
//                    else
//                    {
//                        tempprice = Double(self.dicProductList["sale_price"]?.string ?? "0.0")?.roundTo(places: 3) ?? 0.0
//                        baseprice = Double(self.dicProductList["price"]?.string ?? "0.0")?.roundTo(places: 3) ?? 0.0
//                    }
//                    if(tempprice < baseprice)
//                    {
//                        tempprice = baseprice - tempprice
//                        if(self.currency.uppercased() == "KWD")
//                        {
//                            sprice = String(format:"%.3f",Double(tempprice).roundTo(places: 3) )
//                        }
//                        else
//                        {
//                            sprice = String(format:"%.2f",Double(tempprice).roundTo(places: 2) )
//
//                        }
//
//                        let combination = NSMutableAttributedString()
//                        combination.append(self.getSimpleText(price: String(sprice) + " \(self.currency) "))
//
//                        var price = ""
//                        if(self.currency.uppercased() == "KWD")
//                        {
//                            price = String(format:"%.3f",Double(self.dicProductList["price"]?.string ?? "0.0")?.roundTo(places: 3) ?? 0.0)
//                        }
//                        else
//                        {
//                            price = String(format:"%.2f",Double(self.dicProductList["price"]?.string ?? "0.0")?.roundTo(places: 2) ?? 0.0)
//
//                        }
//                        combination.append(self.getStrikeText(price: price))
//                        self.leftSalePriceAttributed = self.getStrikeText(price: price  + " \(self.currency)")
//
//                        combination.append(self.getSimpleText(price: " \(self.currency)"))
//                        self.labelLeftPrice.attributedText = combination
//                        if(self.currency.uppercased() == "KWD")
//                        {
//                            self.leftPowerPrice = Double(tempprice).roundTo(places: 3)
//                        }
//                        else
//                        {
//                            self.leftPowerPrice = Double(tempprice).roundTo(places: 2)
//                        }
//
//
//
//                        return
//
//                    }
//                }
//
//            }
//        }
//
//
//        if(self.currency.uppercased() == "KWD")
//        {
//            self.leftPowerPrice = Double(self.dicProductList["price"]?.string ?? "0.0")?.roundTo(places: 3) ?? 0.0
//
//            self.labelLeftPrice.text = String(format:"%.3f",self.leftPowerPrice) + " \(self.currency)"
//
//        }
//        else
//        {
//            self.leftPowerPrice = Double(self.dicProductList["price"]?.string ?? "0.0")?.roundTo(places: 2) ?? 0.0
//
//            self.labelLeftPrice.text = String(format:"%.2f", self.leftPowerPrice) + " \(self.currency)"
//
//
//        }
//    }
    @objc func backAction(sender:UIButton)
    {
        self.dismiss(animated: false, completion: {
            if(self.delegateReloadData != nil)
            {
                self.delegateReloadData.reloadDataSelected()
            }
        })
    }
    @objc func rightSwip(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            self.backAction(sender: UIButton())
            
        }
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
//    @IBAction func buttonFilter(_ sender: Any) {
//        KeyConstant.sharedAppDelegate.showFilterScreen(vc: self)
//
//    }
//
//    @IBAction func buttonFav(_ sender: UIButton) {
//
//
//        paramOfAction = ["product_id":productId]
//        APITypeAction = KeyConstant.APIAddWishlist
//        self.reloadDataSelected()
//
//
//
//    }
    @IBAction func buttonSearch(_ sender: Any) {
        KeyConstant.sharedAppDelegate.showSearchScreen(vc: self)

    }
    @IBAction func buttonCart(_ sender: UIButton) {

        let myCartVC = self.storyboard?.instantiateViewController(withIdentifier: "MyCartVC") as! MyCartVC
        self.present(myCartVC, animated: false, completion: nil)

    }

//    @IBAction func buttonActionBuyNowCart(_ sender: UIButton) {
//
//        //self.buyNowPurchase()
//        paramOfAction = ["product_id":productId]
//        APITypeAction = KeyConstant.APIAddWishlist
//        self.reloadDataSelected()
//    }
//
    @IBAction func buttonActionAddCart(_ sender: Any) {
        
        
        self.buyNowPurchase()
        
    }
    
    func buyNowPurchase()
    {
        
        
        typeCart = arraTypeCart[0]
        paramOfAction = ["product_id":productId]
        APITypeAction = KeyConstant.APIAddCart
        self.addToCart()
        
        
        
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

extension ProductDetailsVC:AACarouselDelegate{
    
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
        
        
        if(imageArray.count > 0)
        {
            let brandVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductImagePreview") as! ProductImagePreview
            self.definesPresentationContext = true
            brandVC.modalPresentationStyle = .overCurrentContext
            brandVC.arrImageUrl = imageArray
            brandVC.currentIndex = index
            self.present(brandVC, animated: false, completion: nil)
            
        }
        
        //        alert.show()
        
        //startAutoScroll()
        stopAutoScroll()
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
extension ProductDetailsVC: UICollectionViewDelegate,UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(self.arrayRelatedProductList.count == 0)
        {
            self.labelRelatedProduct.isHidden = true


            return 0
        }
        else
        {
            self.labelRelatedProduct.isHidden = false

        }
        return self.arrayRelatedProductList.count
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {



        guard let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "ProductDetailCVCell", for: indexPath) as? ProductDetailCVCell else{
            return UICollectionViewCell()
        }

        if(indexPath.row <  self.arrayRelatedProductList.count)
        {
            let dic = self.arrayRelatedProductList[indexPath.row]

            cell.productNameLbl.text = dic["title"].string ?? ""
            // cell.labelProductDetails.text = dic["description"].string?.html2String ?? ""
           // cell.labelProductDetails.setHTML1(html:(dic["description"].string ?? "") + self.htmlfontStyle)

//            if let offerAvailable = dic["offer_name"].string
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

            if(HelperArabic().isArabicLanguage())
            {
                if let title_ar =  dic["title_ar"].string
                {
                    if(title_ar.count > 0)
                    {
                        cell.productNameLbl.text = title_ar
                    }

                }
//                if let description_ar =  dic["description_ar"].string
//                {
//                    if(description_ar.count > 0)
//                    {
//                        //cell.labelProductDetails.text = description_ar.html2String
//                        cell.labelProductDetails.setHTML(html:description_ar + self.htmlfontStyle)
//
//                    }
//                }
//                if let offerName_ar = self.dicProductList["offer"]?["name_ar"].string
//                {
//                    if(offerName_ar.count > 0)
//                    {
//                        self.labelOffer.text = offerName_ar
//                    }
//                }
            }

            var price = ""

            if(self.currency.uppercased() == "KWD")
            {
                price = String(format:"%.3f",Double(dic["price"].string ?? "")?.roundTo(places: 3) ?? 0.0)
            }
            else
            {
                price = String(format:"%.2f",Double(dic["price"].string ?? "")?.roundTo(places: 2) ?? 0.0)

            }
            if ((dic["sale_price"].string ?? "").count > 0)
            {
                let sellPriceTemp  = Double(dic["sale_price"].string ?? "") ?? 0.0
                if(sellPriceTemp > 0.0)
                {

                    let combination = NSMutableAttributedString()
                    var sprice = ""
                    var baseprice = 0.0
                    var tempprice = 0.0

                    if(self.currency.uppercased() == "KWD")
                    {
                        sprice = String(format:"%.3f",Double(dic["sale_price"].string ?? "")?.roundTo(places: 3) ?? 0.0)
                        baseprice = Double(dic["price"].string ?? "")?.roundTo(places: 3) ?? 0.0
                        tempprice = Double(dic["sale_price"].string ?? "")?.roundTo(places: 3) ?? 0.0

                    }
                    else
                    {
                        sprice = String(format:"%.2f",Double(dic["sale_price"].string ?? "")?.roundTo(places: 2) ?? 0.0)
                        baseprice = Double(dic["price"].string ?? "")?.roundTo(places: 2) ?? 0.0
                        tempprice = Double(dic["sale_price"].string ?? "")?.roundTo(places: 2) ?? 0.0



                    }
                    if(tempprice < baseprice)
                    {

                        tempprice = baseprice - tempprice
                        sprice = String(format:"%.2f",Double(tempprice).roundTo(places: 2) ?? 0.0)

                        combination.append(self.getSimpleText(price: sprice + "\(currency)  "))
                        combination.append(self.getStrikeText(price: price))
                        combination.append(self.getSimpleText(price: "\(currency)"))

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


//            cell.buttonFav.tag = indexPath.item
//
//            cell.buttonFav.addTarget(self, action: #selector(buttonFav1), for: .touchUpInside)

//            cell.buttonBuyNow.tag = indexPath.item
//            cell.buttonBuyNow.addTarget(self, action: #selector(buttonBuyNow1), for: .touchUpInside)





//            if(dic["tags"].string ?? "" == "new")
//            {
//                cell.labelExclusive.isHidden = false
//                cell.labelExclusive.text = NSLocalizedString("MSG224", comment: "")
//            }
//            else if(dic["tags"].string ?? "" == "latest")
//            {
//                cell.labelExclusive.isHidden = false
//                cell.labelExclusive.text = NSLocalizedString("MSG224", comment: "")
//            }
//            else if(dic["tags"].string ?? "" == "exclusive")
//            {
//                cell.labelExclusive.isHidden = false
//                cell.labelExclusive.text = NSLocalizedString("MSG223", comment: "")
//
//            }
//            else
//            {
//                cell.labelExclusive.isHidden = true
//            }

            //cell.imageViewProduct.contentMode = .scaleAspectFill

            cell.ImgView.contentMode = .scaleToFill
            cell.ImgView.image = UIImage(named: "noImage")


            if let strUrl = dic["product_image"].string
            {
                if(strUrl.count > 0)
                {
                    let urlString = strUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

                    let url = URL(string: KeyConstant.kImageBaseProductURL +  urlString!)
                    let processor = DownsamplingImageProcessor(size:  (cell.ImgView.frame.size))
                        >> RoundCornerImageProcessor(cornerRadius: 0)
                    cell.ImgView.kf.indicatorType = .none
                    cell.ImgView.kf.setImage(
                        with: url,
                        placeholder: UIImage(named: "noImage"),
                        options: [
                            .processor(processor),
                            .scaleFactor(UIScreen.main.scale),
                            .transition(.fade(1)),
                            .cacheOriginalImage
                    ])
                    //                cell.imageViewProduct.kf.setImage(with: URL(string: KeyConstant.kImageBaseProductURL + urlString!)!, placeholder: UIImage.init(named: "noImage"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: { (downloadImage, error, cacheType, url) in
                    //                    if(downloadImage != nil)
                    //                    {
                    //                        cell.imageViewProduct.image = downloadImage!
                    //                    }
                    //                })
                }
                else
                {
                    cell.ImgView.image = UIImage(named: "noImage")

                }

            }
//            cell.buttonBuyNow.isUserInteractionEnabled = true
//            cell.buttonBuyNow.setTitleColor(.white, for: .normal)
//
//            cell.buttonBuyNow.setTitle(NSLocalizedString("MSG194", comment: ""), for: .normal)

//            if let cate_id = dic["cate_id"].int
//            {
//                if(cate_id == 2)
//                {
//                    cell.buttonBuyNow.setTitle(NSLocalizedString("MSG357", comment: ""), for: .normal)
//
//                }
//                else
//                {
//                    cell.buttonBuyNow.setTitle(NSLocalizedString("MSG194", comment: ""), for: .normal)
//
//                }
//            }
//            else
//            {
//                if(dic["cate_id"].string ?? "" == "2")
//                {
//                    cell.buttonBuyNow.setTitle(NSLocalizedString("MSG357", comment: ""), for: .normal)
//
//                }
//                else
//                {
//                    cell.buttonBuyNow.setTitle(NSLocalizedString("MSG194", comment: ""), for: .normal)
//
//                }
//
//            }



//            if let strQuantity = dic["quantity"].string
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
//                    if let strStockFlag = dic["stock_flag"].string
//
//                    {
//                        if((Int(strStockFlag) ?? 0) < 1 || strStockFlag.count < 1)
//                        {
//                            cell.buttonBuyNow.setTitle(NSLocalizedString("MSG195", comment: ""), for: .normal)
//                            cell.buttonBuyNow.isUserInteractionEnabled = false
//                            cell.buttonBuyNow.setTitleColor(.red, for: .normal)
//
//                        }
//                    }
//                }
//            }

           // cell.imageFav.image = UIImage(named: "heart-s")


//            if(WishListModel.sharedInstance.arrayWishList.count > 0)
//            {
//                for ind in 0..<WishListModel.sharedInstance.arrayWishList.count
//                {
//
//                    if(WishListModel.sharedInstance.arrayWishList[ind].wishlistProductId == dic["id"].string)
//                    {
//                        cell.imageFav.image = UIImage(named: "heart-fill")
//
//                    }
//                }
//
//            }

        }


        return cell

    }




    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        collectionView.deselectItem(at: indexPath, animated: false)

        if(indexPath.item < self.arrayRelatedProductList.count)
        {
            let brandVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC
            brandVC.productId = self.arrayRelatedProductList[indexPath.item]["id"].string  ?? ""
            brandVC.stringTitle = self.arrayRelatedProductList[indexPath.item]["title"].string ?? ""
            //brandVC.delegateReloadData = self
            self.present(brandVC, animated: false, completion: nil)
        }
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//                    let width = 128
//                  return CGSize(width: width, height: width)
//    }
    



    @objc func buttonFav1(sender:UIButton)
    {
        var colorDefault = ""

        let stringVariation = self.arrayRelatedProductList[sender.tag]["variations"].string ?? ""

        if((stringVariation.count) ?? 0 > 0)
        {
            let arrayShade = stringVariation.components(separatedBy: ",") ?? [String]()
            if(arrayShade.count > 0)
            {
                colorDefault = arrayShade[0]
            }
        }

        paramOfAction = ["product_id":self.arrayRelatedProductList[sender.tag]["id"].string ?? "","shade":colorDefault]

        if((self.arrayRelatedProductList[sender.tag]["power"]["start_range"].string?.count) ?? 0 > 0)
        {
            paramOfAction["left_eye_power"] = "0.0"
            paramOfAction["right_eye_power"] = "0.0"
        }


       // APITypeAction = KeyConstant.APIAddWishlist
        self.reloadDataSelected()

    }

    @objc func buttonBuyNow1(sender:UIButton)
    {
        var cat_id = ""
        if let catid = self.arrayRelatedProductList[sender.tag]["cate_id"].string
        {
            cat_id = catid
        }
        if let catid = self.arrayRelatedProductList[sender.tag]["cate_id"].int
        {

            cat_id = String(format:"%d",catid)
        }

        if(cat_id == "2")
        {
            if(sender.tag < self.arrayRelatedProductList.count)
            {
                let brandVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC
                brandVC.productId = self.arrayRelatedProductList[sender.tag]["id"].string  ?? ""
                brandVC.stringTitle = self.arrayRelatedProductList[sender.tag]["title"].string ?? ""
                //brandVC.delegateReloadData = self
                self.present(brandVC, animated: false, completion: nil)
            }
        }
        else
        {

            typeCart = arraTypeCart[1]
            var colorDefault = ""

            let stringVariation = self.arrayRelatedProductList[sender.tag]["variations"].string ?? ""

            if((stringVariation.count) ?? 0 > 0)
            {
                let arrayShade = stringVariation.components(separatedBy: ",") ?? [String]()
                if(arrayShade.count > 0)
                {
                    colorDefault = arrayShade[0]
                }
            }

            paramOfAction = ["product_id":self.arrayRelatedProductList[sender.tag]["id"].string ?? "","shade":colorDefault]

            if((self.arrayRelatedProductList[sender.tag]["power"]["start_range"].string?.count) ?? 0 > 0)
            {
                paramOfAction["left_eye_power"] = "0.0"
                paramOfAction["right_eye_power"] = "0.0"
            }
            APITypeAction = KeyConstant.APIAddCart
            self.addToCart()
        }

    }
    func addToCart()
    {

        var params = [String:String]()
//        if(typeCart == arraTypeCart[0])
//        {
//
//
//            params = ["user_id":KeyConstant.sharedAppDelegate.getUserId(),"product_id":paramOfAction["product_id"] ?? "","shade":""]
//
//            if(self.buttonSelectPower.isHidden == false)
//            {
//                if(leftPower == KeyConstant.kNoPower)
//                {
//                    params["left_eye_power"] = ""
//                }
//                else
//                {
//                    params["left_eye_power"] = String(leftPower)
//                    params["quantity_left"] = labelLeftQty.text ?? ""
//                }
//
//
//                if(rightPower == KeyConstant.kNoPower)
//                {
//                    params["right_eye_power"] = ""
//                }
//                else
//                {
//                    params["right_eye_power"] = String(rightPower)
//                    params["quantity_right"] = labelRightQty.text ?? ""
//                }
//            }
//
//            if(!(self.rightPowerHeightConstraint.constant == 0) && Int(self.labelRightQty.text!)! > 0)
//            {
//
//                params["quantity"] = String(Int(self.labelLeftQty.text!)! + Int(self.labelRightQty.text!)!)
//
//            }
//            else
//            {
//                params["quantity"] = labelLeftQty.text ?? ""
//            }
//
//
//        }
//        else
//        {
            params = ["user_id":KeyConstant.sharedAppDelegate.getUserId(),"product_id":paramOfAction["product_id"] ?? "","quantity":"1","shade":"","left_eye_power":paramOfAction["left_eye_power"] ?? "","right_eye_power":paramOfAction["right_eye_power"] ?? ""]



   //     }

        var cat_id = ""
        if let catid = self.dicProductList["cate_id"]?.string
        {
            cat_id = catid
        }
        if let catid = self.dicProductList["cate_id"]?.int
        {

            cat_id = String(format:"%d",catid)
        }
//        if(cat_id == "2" && (leftPower == 0.0 || rightPower == 0.0))
//        {
//            self.getPowerList(dicDataForClearedContact: params)
//
//
//        }
//        else
//        {
            CartViewModel().addToCart(vc: self, param:params ) { (isDone:Bool, error:Error?) in

                self.paramOfAction.removeAll()
                self.APITypeAction = ""
                if(isDone == true)
                {
                    self.checkoutAlertView()
                }
                else
                {
                    KeyConstant.sharedAppDelegate.showAlertView(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString:error?.localizedDescription ?? NSLocalizedString("MSG21", comment: ""))

                }

            }
        //}

    }

    func checkoutAlertView()
    {

        let alert = UIAlertController(title: NSLocalizedString("MSG31", comment: "").uppercased(), message: "", preferredStyle: .alert)

        let msgFont = [NSAttributedString.Key.font: UIFont(name: FontLocalization.medium.strValue, size: 15.0)!]
        let msgAttrString = NSMutableAttributedString(string: NSLocalizedString("MSG197", comment: ""), attributes: msgFont)
        alert.setValue(msgAttrString, forKey: "attributedMessage")

        let action1 = UIAlertAction(title: NSLocalizedString("MSG198", comment: ""), style: .default) { (action) in

            if(self.typeCart == self.arraTypeCart[0])
            {
                
                self.dismiss(animated: false, completion: {
                    if(self.delegateReloadData != nil)
                    {
                        self.delegateReloadData.reloadDataSelected()
                    }
                })
            }


        }

        let action2 = UIAlertAction(title: NSLocalizedString("MSG199", comment: ""), style: .default) { (action) in


            let myCartVC = self.storyboard?.instantiateViewController(withIdentifier: "MyCartVC") as! MyCartVC
            self.present(myCartVC, animated: false, completion: nil)

        }


        alert.addAction(action1)
        alert.addAction(action2)
        action2.setValue(AppColors.SelcetedColor, forKey: "titleTextColor")
        action1.setValue(AppColors.SelcetedColor, forKey: "titleTextColor")

        alert.view.tintColor = UIColor.black
        alert.view.layer.cornerRadius = 40
        alert.view.backgroundColor = UIColor.white
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true, completion: nil)
        })


    }


}




extension ProductDetailsVC:UIPickerViewDataSource, UIPickerViewDelegate
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        //        if(tempTextField == textFieldQTY)
        //        {
        //            if(arrayQunatity.count > 0)
        //            {
        //                return arrayQunatity.count
        //            }
        //        }
        //        if(tempTextField == textFieldSelectShade)
        //        {
        //            if(arrayShade.count > 0)
        //            {
        //                return arrayShade.count
        //            }
        //        }
        return 0
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        
        //        if(tempTextField == textFieldQTY)
        //        {
        //            if(arrayQunatity.count > 0)
        //            {
        //                return String(arrayQunatity[row])
        //            }
        //        }
        //        if(tempTextField == textFieldSelectShade)
        //        {
        //            if(arrayShade.count > 0)
        //            {
        //                return String(arrayShade[row])
        //            }
        //        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //        if(tempTextField == textFieldQTY)
        //        {
        //            if(arrayQunatity.count > 0)
        //            {
        //                self.textFieldQTY.text = String(arrayQunatity[row])
        //            }
        //        }
        //        if(tempTextField == textFieldSelectShade)
        //        {
        //            if(arrayShade.count > 0)
        //            {
        //                self.textFieldSelectShade.text = String(arrayShade[row])
        //            }
        //        }
    }
    
    
    
    func toolbar()
    {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: NSLocalizedString("MSG344", comment: ""), style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: NSLocalizedString("MSG53", comment: ""), style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelPicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        // textFieldQTY.inputAccessoryView = toolBar
        //textFieldSelectShade.inputAccessoryView = toolBar
        
        
    }
    
    
    func getStrikeText(price:String)-> NSMutableAttributedString
    {
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: price)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
        return attributeString
        
    }
    
    func getSimpleText(price:String)-> NSMutableAttributedString
    {
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: price)
        return attributeString
        
    }
    @objc func donePicker (sender:UIBarButtonItem)
    {
        
        
        let row = self.pickerView.selectedRow(inComponent: 0)
        self.pickerView.selectRow(row, inComponent: 0, animated: false)
        //        if(tempTextField == textFieldQTY)
        //        {
        //            if(arrayQunatity.count > 0)
        //            {
        //                self.textFieldQTY.text = String(arrayQunatity[row])
        //            }
        //        }
        //        if(tempTextField == textFieldSelectShade)
        //        {
        //            if(arrayShade.count > 0)
        //            {
        //                self.textFieldSelectShade.text = String(arrayShade[row])
        //            }
        //        }
        self.view.endEditing(true)
    }
    
    @objc func cancelPicker (sender:UIBarButtonItem)
    {
        
        self.view.endEditing(true)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        tempTextField = textField
        return true
    }
    
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let y: CGFloat = scrollView.contentOffset.y
//        let newHeaderViewHeight: CGFloat = headerViewHeightConstraint.constant - y
//
//        if newHeaderViewHeight > headerViewMaxHeight {
//            headerViewHeightConstraint.constant = headerViewMaxHeight
//        } else if newHeaderViewHeight < headerViewMinHeight {
//            headerViewHeightConstraint.constant = headerViewMinHeight
//        } else {
//            headerViewHeightConstraint.constant = newHeaderViewHeight
//            scrollView.contentOffset.y = 0 // block scroll view
//        }
//    }
    
}
extension UILabel{
    
    public var requiredHeight: CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.attributedText = attributedText
        label.sizeToFit()
        return label.frame.height
    }
}
extension Double {
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
