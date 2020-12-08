//
//  OffersHomeVC.swift
//  LENZZO
//
//  Created by Apple on 11/11/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import UIKit
import UIKit
import Kingfisher
import AlamofireImage
import SwiftyJSON

class OffersHomeTVC:UITableViewCell{

    @IBOutlet weak var productImgView: UIImageView!

    @IBOutlet weak var productNameLbl: UILabel!

    @IBOutlet weak var productPriceLbl: UILabel!

    @IBOutlet weak var offerPriceLbl: UILabel!
    
    @IBOutlet weak var discountPercentLbl: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.productNameLbl.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        self.productPriceLbl.font = UIFont(name: FontLocalization.medium.strValue, size: 12.0)
        self.offerPriceLbl.font = UIFont(name: FontLocalization.medium.strValue, size: 12.0)
        self.discountPercentLbl.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        self.productNameLbl.numberOfLines = 4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }




}
class OffersHomeVC: UIViewController, ReloadProductDataDelegate {
    @IBOutlet weak var buttonMenu: UIButton!
    var stringTitle = String()
    var stringCatId = String()
    @IBOutlet weak var labelNotFound: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var labelCountCart: UILabel!
    
    @IBOutlet weak var offerTableView: UITableView!
    
    @IBOutlet weak var backImgView: UIImageView!
    @IBOutlet weak var cartBtn: UIButton!
    @IBOutlet weak var searchBtn: UIButton!
    
    @IBOutlet weak var offerTitleLbl: PaddingLabel!
    
    @IBOutlet weak var offerCollectionView: UICollectionView!
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    let numberOfItemsPerRow: CGFloat = 2
    let spacingBetweenCells: CGFloat = 10
    var offerID = String()
    var currency = ""
    var paramOfAction = [String:String]()
    var APITypeAction = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        
        self.offerCollectionView.register(UINib(nibName: "ProductCVCellOffer", bundle: nil), forCellWithReuseIdentifier: "ProductCVCellOffer")
        self.offerCollectionView.reloadData()
        self.buttonMenu.addTarget(self, action:#selector(backAction), for: .touchUpInside)
      //  self.initialSetUp()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(rightSwip))
        self.labelNotFound.isHidden = true
        currency = KeyConstant.user_Default.value(forKey: KeyConstant.kSelectedCurrency) as! String
        if(HelperArabic().isArabicLanguage())
        {
            
            swipeRight.direction = UISwipeGestureRecognizer.Direction.left
            
        }
        else
        {
            swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        }
        
        
        self.view.addGestureRecognizer(swipeRight)
        
        OfferModel.sharedInstance.arrayOfferList.removeAll()
        
        BrandModelview().getOfferBrandInfo(vc: self, offerType: "", completionHandler: { (success: Bool, errorC:Error?) in
            if(OfferModel.sharedInstance.arrayOfferList.count == 0)
            {
                self.labelNotFound.isHidden = false
            }
            else
            {
                self.labelNotFound.isHidden = true
                DispatchQueue.main.async {
                    self.offerCollectionView.reloadData()
                }
            }
//            self.offerTableView.delegate = self
//            self.offerTableView.dataSource = self
//            self.offerTableView.reloadData()
            
            
//            if(self.offerID.count > 0 && OfferModel.sharedInstance.arrayOfferList.count > 0)
//            {
//
//                MBProgress().showIndicator(view: self.view)
//                for ind in 0..<OfferModel.sharedInstance.arrayOfferList.count
//                {
//                    if(OfferModel.sharedInstance.arrayOfferList[ind].offer_id == self.offerID)
//                    {
//                        if(OfferModel.sharedInstance.arrayOfferList[ind].brandid.count > 0 && OfferModel.sharedInstance.arrayOfferList[ind].familyid.count > 0)
//                        {
//                            ProductListModel.sharedInstance.arrayProductList.removeAll()
//                            let brandVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductListVC") as! ProductListVC
//                            self.definesPresentationContext = true
//                            brandVC.modalPresentationStyle = .overCurrentContext
//                            brandVC.stringTitle = OfferModel.sharedInstance.arrayOfferList[ind].name
//                            brandVC.familyID = OfferModel.sharedInstance.arrayOfferList[ind].familyid
//                            brandVC.brandId = OfferModel.sharedInstance.arrayOfferList[ind].brandid
//                            DispatchQueue.main.async {
//                                print("sdfsdfdsfdsf\(self.offerID)")
//                                self.present(brandVC, animated: false, completion: {
//                                    self.offerID =  ""
//                                    MBProgress().hideIndicator(view: self.view)
//
//                                })
//                            }
//                        }
//                        break
//                    }
//
//
//
//                    MBProgress().hideIndicator(view: self.view)
//
//                }
//            }
            
        })
        
        //        if(stringCatId.count == 0)
        //        {
        //
        //            OfferModelview().getAllBrandInfo(vc: self, brandId: "", completionHandler: { (success: Bool, errorC:Error?) in
        //
        //                self.collectionView.reloadData()
        //            })
        //        }
        //        else if(stringCatId.count > 0)
        //        {
        //            OfferModelview().getAllBrandByCategory(vc: self, catId: stringCatId, completionHandler: { (success: Bool, errorC:Error?) in
        //
        //                self.collectionView.reloadData()
        //            })
        //        }
        
         self.changeTintAndThemeColor()
        self.labelNotFound.font = UIFont(name: FontLocalization.Bold.strValue, size: 15.0)
        self.offerTitleLbl.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
            
        }
        
        
        func changeTintAndThemeColor(){
            let img = UIImage(named: "search (1)")?.withRenderingMode(.alwaysTemplate)
            self.searchBtn.setImage(img, for: .normal)
            self.searchBtn.tintColor = .white
            
            let cartImg = UIImage(named: "cart")?.withRenderingMode(.alwaysTemplate)
            self.cartBtn.setImage(cartImg, for: .normal)
            self.cartBtn.tintColor = .white
            
            self.backImgView.image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate)
            self.backImgView.tintColor = .white
        }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        labelCountCart.text = ""
        
        if(HelperArabic().isArabicLanguage())
        {
         self.backImgView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }
        else
        {
        self.backImgView.transform = CGAffineTransform(rotationAngle: 245)
        }
        CartViewModel().viewCartList(vc: self, param: ["user_id":KeyConstant.sharedAppDelegate.getUserId()], completionHandler: { (result:[JSON], totalCount:String ,error:Error?) in
            
            self.labelCountCart.text = ""
            
            
            
            if(result.count > 0)
            {
                print(result.count)
                self.labelCountCart.text = totalCount
                
            }})
        
        
    }
//    func initialSetUp(){
//
//        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
//            let horizontalSpacing = flowLayout.scrollDirection == .vertical ? flowLayout.minimumInteritemSpacing : flowLayout.minimumLineSpacing
//
//            let tablewidth = ((CGFloat(UIScreen.main.bounds.width) - CGFloat(20)))
//            let tableHigh = ((CGFloat(UIScreen.main.bounds.width) - CGFloat(35)))/2.3
//
//
//            flowLayout.itemSize = CGSize(width: tablewidth, height: tableHigh)
//        }
//    }
    @objc func backAction(sender:UIButton)
    {
        KeyConstant.sharedAppDelegate.setRoot()
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
        
        let myCartVC = self.storyboard?.instantiateViewController(withIdentifier: "MyCartVC") as! MyCartVC
        self.present(myCartVC, animated: false, completion: nil)
    }
    @IBAction func buttoSort(_ sender: Any) {
        
        KeyConstant.sharedAppDelegate.showSearchScreen(vc: self)
        
    }
    @IBAction func buttonFilter(_ sender: Any) {
        KeyConstant.sharedAppDelegate.showFilterScreen(vc: self)
        
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
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}


//extension OffersHomeVC: UICollectionViewDelegate,UICollectionViewDataSource
//{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
//        return OfferModel.sharedInstance.arrayOfferList.count
//
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let cell:HomeCollectionViewCell!
//
//        cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as? HomeCollectionViewCell
//
//        cell.offerView.isHidden = true
//        if let strOfferName = OfferModel.sharedInstance.arrayOfferList[indexPath.item].offer_name
//        {
//            if(strOfferName.count > 0)
//            {
//                cell.offerView.isHidden = false
//                cell.labelOfferType.text = strOfferName
//            }
//        }
//        cell.imageViewCategory.contentMode = .scaleToFill
//
//        if let strUrl = OfferModel.sharedInstance.arrayOfferList[indexPath.item].product_image
//        {
//            if(strUrl.count > 0)
//            {
//                cell.imageViewCategory.kf.setImage(with: URL(string: KeyConstant.kImageBaseProductURL + strUrl)!, placeholder: UIImage.init(named: "noImage"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: { (downloadImage, error, cacheType, url) in
//                    if(downloadImage != nil)
//                    {
//                        cell.imageViewCategory.image = downloadImage!
//                    }
//                })
//            }
//            else
//            {
//                cell.imageViewCategory.image = UIImage(named: "noImage")
//
//            }
//        }
//        else
//        {
//            cell.imageViewCategory.image = UIImage(named: "noImage")
//
//        }
//
//        return cell
//
//    }
//
//
//
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
//    {
//        if(OfferModel.sharedInstance.arrayOfferList[indexPath.item].brandid.count > 0 && OfferModel.sharedInstance.arrayOfferList[indexPath.item].familyid.count > 0)
//        {
//            ProductListModel.sharedInstance.arrayProductList.removeAll()
//            let brandVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductListVC") as! ProductListVC
//            self.definesPresentationContext = true
//            brandVC.modalPresentationStyle = .overCurrentContext
//            brandVC.stringTitle = OfferModel.sharedInstance.arrayOfferList[indexPath.item].name
//            brandVC.familyID = OfferModel.sharedInstance.arrayOfferList[indexPath.item].id
//            brandVC.brandId = OfferModel.sharedInstance.arrayOfferList[indexPath.item].brandid
//            self.present(brandVC, animated: false, completion: nil)
//        }
//
//    }
//
//
//}


//extension OffersHomeVC:UITableViewDelegate,UITableViewDataSource{
//
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return OfferModel.sharedInstance.arrayOfferList.count
//    }
//
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell:OffersHomeTVC!
//
//        cell =  tableView.dequeueReusableCell(withIdentifier: "OffersHomeTVC", for: indexPath) as? OffersHomeTVC
//
//        let offersModel = OfferModel.sharedInstance.arrayOfferList[indexPath.item]
//        cell.productNameLbl.text = offersModel.brand_name
//        cell.productPriceLbl.text = offersModel.price
//        cell.productImgView.contentMode = .scaleToFill
//        let discountedPrice = (offersModel.deal_otd_discount as NSString).floatValue
// //       let originalPrice = (offersModel.price as NSString).floatValue
////        let discountPercent = (originalPrice * discount)/100.00
////        let offerPrice = originalPrice - discountPercent
//        cell.offerPriceLbl.text = "Offer Price: \(discountedPrice)"
////        cell.discountPercentLbl.text = "\(discount)% OFF"
//        if let strUrl = OfferModel.sharedInstance.arrayOfferList[indexPath.item].product_image
//        {
//            if(strUrl.count > 0)
//            {
//                cell.productImgView.kf.setImage(with: URL(string: KeyConstant.kImageBaseProductURL + strUrl)!, placeholder: UIImage.init(named: "noImage"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: { (downloadImage, error, cacheType, url) in
//                    if(downloadImage != nil)
//                    {
//                        cell.productImgView.image = downloadImage!
//                    }
//                })
//            }
//            else
//            {
//                cell.productImgView.image = UIImage(named: "noImage")
//
//            }
//        }
//        else
//        {
//            cell.productImgView.image = UIImage(named: "noImage")
//
//        }
//
//        return cell
//
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if(OfferModel.sharedInstance.arrayOfferList[indexPath.item].brandid.count > 0 && OfferModel.sharedInstance.arrayOfferList[indexPath.item].id.count > 0)
//        {
//            ProductListModel.sharedInstance.arrayProductList.removeAll()
//            let brandVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductListVC") as! ProductListVC
//            self.definesPresentationContext = true
//            brandVC.modalPresentationStyle = .overCurrentContext
//            brandVC.stringTitle = OfferModel.sharedInstance.arrayOfferList[indexPath.item].name
//            brandVC.familyID = OfferModel.sharedInstance.arrayOfferList[indexPath.item].id
//            brandVC.brandId = OfferModel.sharedInstance.arrayOfferList[indexPath.item].brandid
//            self.present(brandVC, animated: false, completion: nil)
//        }
//
//    }
//}



extension OffersHomeVC:UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,ReloadProductListDelegate{
    func reloadDataSelected() {
        self.showCartCount()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return OfferModel.sharedInstance.arrayOfferList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
            let cell:ProductListCVCell!
            cell =  offerCollectionView.dequeueReusableCell(withReuseIdentifier: "ProductCVCellOffer", for: indexPath) as? ProductListCVCell
        cell.addtoCartView.layer.roundCorners(corners: [.topLeft], radius: 5.0)
            if(indexPath.row < OfferModel.sharedInstance.arrayOfferList.count)
            {
                let dic = OfferModel.sharedInstance.arrayOfferList[indexPath.row]
                cell.labelProductName.text = dic.brand_name
                
                let offerPrice = (dic.deal_otd_discount as NSString)
                
                cell.offerPriceLbl.text = NSLocalizedString("MSG442", comment: "") + " \(offerPrice)" + " KWD"
                var price = ""
    
                if(self.currency.uppercased() == "KWD")
                {
                    price = String((dic.price as NSString))
                    //String(format:"%.3f",Double(dic.price)?.roundTo(places: 3) ?? 0.0)
                }
                else
                {
                    price = String((dic.price as NSString))//String(format:"%.2f",Double(dic.price)?.roundTo(places: 2) ?? 0.0)
    
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
    
                if let strUrl = dic.product_images
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
        brandVC.productId = OfferModel.sharedInstance.arrayOfferList[indexPath.row].id
        brandVC.stringTitle = OfferModel.sharedInstance.arrayOfferList[indexPath.row].brand_name
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
            
//            if(ProductListModel.sharedInstance.arrayProductList[sender.tag].cate_id == "2")
//            {
//
//                let brandVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC
//                brandVC.productId = ProductListModel.sharedInstance.arrayProductList[sender.tag].id
//                brandVC.stringTitle = ProductListModel.sharedInstance.arrayProductList[sender.tag].title
//                brandVC.delegateReloadData = self
//                self.present(brandVC, animated: false, completion: nil)
//            }
//            else
//            {
                var colorDefault = "Black"
                
                let stringVariation = OfferModel.sharedInstance.arrayOfferList[sender.tag].variations
                
                if((stringVariation?.count) ?? 0 > 0)
                {
                    let arrayShade = stringVariation?.components(separatedBy: ",") ?? [String]()
                    if(arrayShade.count > 0)
                    {
                        colorDefault = arrayShade[0]
                    }
                }
                
                
                paramOfAction = ["product_id":OfferModel.sharedInstance.arrayOfferList[sender.tag].id,"shade":colorDefault]
                
                if(OfferModel.sharedInstance.arrayOfferList[sender.tag].start_range.count > 0)
                {
                    paramOfAction["left_eye_power"] = "0.0"
                    paramOfAction["right_eye_power"] = "0.0"
                    
                }
                APITypeAction = KeyConstant.APIAddCart
                
                self.addToCart()
                
            //}
        }
        
        
        @objc func viewDetailBtnTapped(sender:UIButton)
        {
            
    //        let brandVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC
    //        brandVC.productId = ProductListModel.sharedInstance.arrayProductList[sender.tag].id
    //        brandVC.stringTitle = ProductListModel.sharedInstance.arrayProductList[sender.tag].title
    //        brandVC.delegateReloadData = self
    //        self.present(brandVC, animated: false, completion: nil)
            
                var colorDefault = "Black"
                
                let stringVariation = OfferModel.sharedInstance.arrayOfferList[sender.tag].variations
                
                if((stringVariation?.count) ?? 0 > 0)
                {
                    let arrayShade = stringVariation?.components(separatedBy: ",") ?? [String]()
                    if(arrayShade.count > 0)
                    {
                        colorDefault = arrayShade[0]
                    }
                }
                
                
                paramOfAction = ["product_id":OfferModel.sharedInstance.arrayOfferList[sender.tag].id,"shade":colorDefault]
                
                if(OfferModel.sharedInstance.arrayOfferList[sender.tag].start_range.count > 0)
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
