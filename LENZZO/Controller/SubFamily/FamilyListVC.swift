//
//  FamilyListVC.swift
//  LENZZO
//
//  Created by Apple on 11/13/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import UIKit
import Kingfisher
import AlamofireImage
import SwiftyJSON

class FamilyListVC: UIViewController,ReloadFamilyListDelegate {
    @IBOutlet weak var buttonMenu: UIButton!
    var stringTitle = String()
    var brandId = String()
    var arrayChildData = [JSON]()
    
    @IBOutlet weak var labelNotFound: UILabel!
    
    @IBOutlet weak var labelTitle: PaddingLabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var labelCountCart: UILabel!
    
    var sliderFamilyImages = String()
    var defaultSizeBanner = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BannerSliderCollection.sharedInstance.arrayBrandList.removeAll()
        self.collectionView.reloadData()
        self.view.backgroundColor = AppColors.themeColor
        self.getAllCollectioBanner()
        
        self.labelTitle.text = NSLocalizedString("MSG246", comment: "")
        
        
        self.buttonMenu.addTarget(self, action:#selector(backAction), for: .touchUpInside)
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
        
        
    }
    override func viewDidLayoutSubviews() {
        setViewCollectionView()
    }
    @objc func backAction(sender:UIButton)
    {
        self.dismiss(animated: false, completion: nil)
        
    }
    func getAllCollectioBanner()
    {
        self.defaultSizeBanner = false
        
        CartViewModel().getCollectionBanner(vc: self, param: ["brandid":brandId], completionHandler: { (result:[String:JSON], error:Error?) in
            if(!(error == nil))
            {
                self.getAllCollectioBanner()
                return
            }
            
            BannerSliderCollection.sharedInstance.arrayBrandList.removeAll()
            if(result.count > 0)
            {
                BannerSliderCollection.sharedInstance.brandSlider(arrayData:  result)
                
                self.defaultSizeBanner = true
            }
            self.collectionView.reloadData()
        } )
        
        
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
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension FamilyListVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    
    
    
    
    func setViewCollectionView()
    {
        
        let margin: CGFloat = 10
        let cellsPerRow = 2
        
        
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.minimumInteritemSpacing = margin
        flowLayout.minimumLineSpacing = margin
        flowLayout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        // flowLayout.sectionHeadersPinToVisibleBounds = true
        
        collectionView.contentInsetAdjustmentBehavior = .always
        let marginsAndInsets = flowLayout.sectionInset.left + flowLayout.sectionInset.right + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + flowLayout.minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
        let itemWidth = (((UIScreen.main.bounds.width - 13) - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
        
        flowLayout.itemSize = CGSize(width: CGFloat((itemWidth)), height: CGFloat(itemWidth * 1.2))
        
        
    }
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
    //
    //
    //
    //    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableview = UICollectionReusableView()
        
        switch kind
        {
        case UICollectionView.elementKindSectionHeader:
            
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "section", for: indexPath) as!FamilyCRView
            cell.navControll = self
            cell.carouselView.backgroundColor = AppColors.themeColor
            cell.carouselView.setCarouselData(paths: [String](),  describedTitle: [], isAutoScroll: true, timer: 1.0, defaultImage: "noImage")
            cell.carouselView.setCarouselOpaque(layer: false, describedTitle: false, pageIndicator: false)
            cell.carouselView.setCarouselLayout(displayStyle: 0, pageIndicatorPositon: 2, pageIndicatorColor: nil, describedTitleColor: nil, layerColor: .clear)
            // let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "section", for: indexPath) as! FamilyCRView
            if(BannerSliderCollection.sharedInstance.arrayBrandList.count > 0)
            {
                cell.setSlider(arrayBannerData: BannerSliderCollection.sharedInstance.arrayBrandList)
            }
            reusableview = cell
            
            return reusableview
        default:
            return reusableview
        }
        return reusableview
        
    }
    
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    // func collectionView(_ collectionView)
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if(self.defaultSizeBanner == false)
        {
            return CGSize(width: UIScreen.main.bounds.width, height: 205)
        }
        
        if(BannerSliderCollection.sharedInstance.arrayBrandList["images"]?.string?.count ?? 0 > 0)
        {
            return CGSize(width: UIScreen.main.bounds.width, height: 205)
        }
        else
        {
            return CGSize(width: UIScreen.main.bounds.width, height: 0)
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        if(arrayChildData.count == 0)
        {
            self.labelNotFound.isHidden = false
            return 0
        }
        else
        {
            self.labelNotFound.isHidden = true
            
        }
        return arrayChildData.count
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //        if(indexPath.section == 0)
        //        {
        let cell:FamilyCollectionViewCell!
        let dic = self.arrayChildData[indexPath.item].dictionary
        print(dic)
        
        if let strOfferName = dic?["offer_name"]?.string
        {
            
            if(strOfferName.count > 0)
            {
                cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "FamilyCollectionViewCellOffer", for: indexPath) as? FamilyCollectionViewCell
                
                //cell.labelEndIn.text = NSLocalizedString("MSG245", comment: "")
                //cell.labelTime.text = "12:22:33"
                
                cell.labelProductName.text = dic?["name"]?.string ?? ""
                
                cell.labelOfferTime.text = strOfferName
                
                if(HelperArabic().isArabicLanguage())
                {
                    if let title_ar =  dic?["name_ar"]?.string
                    {
                        cell.labelProductName.text = title_ar
                        
                    }
                    if let offer_name_ar =  dic?["offer"]?["name_ar"].string
                    {
                        cell.labelOfferTime.text = offer_name_ar
                    }
                }
                
                cell.imageViewCategory.contentMode = .scaleAspectFit
                
                if let strUrl = dic?["image"]?.string
                {
                    if(strUrl.count > 0)
                    {
                        
                        
                        cell.imageViewCategory.kf.setImage(with: URL(string: KeyConstant.kImageBaseProductURL + strUrl)!, placeholder: UIImage.init(named: "noImage"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: { (downloadImage, error, cacheType, url) in
                            if(downloadImage != nil)
                            {
                                cell.imageViewCategory.image = downloadImage!
                            }
                        })
                    }
                    else
                    {
                        cell.imageViewCategory.image = UIImage(named: "noImage")
                        
                    }
                }
                else
                {
                    cell.imageViewCategory.image = UIImage(named: "noImage")
                    
                }
            }
            else
            {
                cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "FamilyCollectionViewCell", for: indexPath) as? FamilyCollectionViewCell
                cell.imageViewCategory.contentMode = .scaleAspectFit
                
                cell.labelProductName.text = dic?["name"]?.string ?? ""
                if(HelperArabic().isArabicLanguage())
                {
                    if let title_ar =  dic?["name_ar"]?.string
                    {
                        cell.labelProductName.text = title_ar
                        
                    }
                    
                }
                if let strUrl = dic?["image"]?.string
                {
                    if(strUrl.count > 0)
                    {
                        
                        
                        cell.imageViewCategory.kf.setImage(with: URL(string: KeyConstant.kImageBaseProductURL + strUrl)!, placeholder: UIImage.init(named: "noImage"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: { (downloadImage, error, cacheType, url) in
                            if(downloadImage != nil)
                            {
                                cell.imageViewCategory.image = downloadImage!
                            }
                        })
                    }
                    else
                    {
                        cell.imageViewCategory.image = UIImage(named: "noImage")
                        
                    }
                }
                else
                {
                    cell.imageViewCategory.image = UIImage(named: "noImage")
                    
                }
                
            }
        }
        else
        {
            
            cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "FamilyCollectionViewCell", for: indexPath) as? FamilyCollectionViewCell
            cell.imageViewCategory.contentMode = .scaleAspectFit
            
            cell.labelProductName.text = dic?["name"]?.string ?? ""
            if(HelperArabic().isArabicLanguage())
            {
                if let title_ar =  dic?["name_ar"]?.string
                {
                    cell.labelProductName.text = title_ar
                    
                }
                
            }
            if let strUrl = dic?["image"]?.string
            {
                if(strUrl.count > 0)
                {
                    
                    
                    cell.imageViewCategory.kf.setImage(with: URL(string: KeyConstant.kImageBaseProductURL + strUrl)!, placeholder: UIImage.init(named: "noImage"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: { (downloadImage, error, cacheType, url) in
                        if(downloadImage != nil)
                        {
                            cell.imageViewCategory.image = downloadImage!
                        }
                    })
                }
                else
                {
                    cell.imageViewCategory.image = UIImage(named: "noImage")
                    
                }
            }
            else
            {
                cell.imageViewCategory.image = UIImage(named: "noImage")
                
            }
            
            
        }
        return cell
        
    }
    
    func reloadDataSelected() {
        labelCountCart.text = ""
        
        
        CartViewModel().viewCartList(vc: self, param: ["user_id":KeyConstant.sharedAppDelegate.getUserId()], completionHandler: { (result:[JSON], totalCount:String ,error:Error?) in
            
            self.labelCountCart.text = ""
            
            
            
            if(result.count > 0)
            {
                print(result.count)
                self.labelCountCart.text = totalCount
                
            }})
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let dic = self.arrayChildData[indexPath.item].dictionary
        
        if(dic?["child"]?.array?.count ?? 0 > 0)
        {
            let brandVC = self.storyboard?.instantiateViewController(withIdentifier: "FamilyListVC") as! FamilyListVC
            
            self.definesPresentationContext = true
            brandVC.modalPresentationStyle = .overCurrentContext
            brandVC.stringTitle = dic?["name"]?.string ?? ""
            if(HelperArabic().isArabicLanguage())
            {
                if let title_ar =  dic?["name_ar"]?.string
                {
                    if(title_ar.count > 0)
                    {
                        brandVC.stringTitle = title_ar
                    }
                }
            }
            brandVC.brandId = brandId
            brandVC.sliderFamilyImages = sliderFamilyImages
            brandVC.arrayChildData = dic?["child"]?.array ?? [JSON]()
            self.present(brandVC, animated: false, completion: nil)
        }
        else
        {
            
            ProductListModel.sharedInstance.arrayProductList.removeAll()
            
            let brandVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductListVC") as! ProductListVC
            self.definesPresentationContext = true
            brandVC.modalPresentationStyle = .overCurrentContext
            brandVC.stringTitle = dic?["name"]?.string ?? ""
            brandVC.delegateReloadData = self
            if(HelperArabic().isArabicLanguage())
            {
                if let title_ar =  dic?["name_ar"]?.string
                {
                    brandVC.stringTitle = title_ar
                    
                }
            }
            brandVC.familyID = dic?["id"]?.string ?? ""
            brandVC.brandId = brandId
            self.present(brandVC, animated: false, completion: nil)
            
        }
        
        
        
        
        
    }
    
    
}

extension FamilyCRView:AACarouselDelegate{
    
    
    
    func downloadImages(_ url: String, _ index:Int) {
        
        let imageView = UIImageView()
        let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        imageView.kf.setImage(with: URL(string: urlString!)!, placeholder: UIImage.init(named: "noImage"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: { (downloadImage, error, cacheType, url) in
            if(downloadImage != nil)
            {
                if(index < self.carouselView.images.count)
                {
                    self.carouselView.images[index] = downloadImage!
                }
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
        
        //imageView.kf.indicatorType = .none
        imageView.contentMode = .scaleAspectFit
        
        if (UIDevice.current.userInterfaceIdiom == .pad)
        {
            imageView.contentMode = .scaleAspectFit
        }
        
        imageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "noImage"),
            options: [
                .transition(.fade(1))
        ])
        
        
        
        
        //        let urlString = url[index].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        //        print("asdasd\(urlString)")
        //        if(urlString?.count ?? 0 > 0)
        //        {
        //
        //            imageView.kf.setImage(
        //                with: URL(string: urlString!),
        //                placeholder:  UIImage.init(named: "noImage"),
        //                options: [
        //                    .processor(DownsamplingImageProcessor(size: imageView.frame.size)),
        //                    .scaleFactor(UIScreen.main.scale),
        //                    .cacheOriginalImage
        //                ])
        //
        //        }
        //
        //                imageView.kf.setImage(with: URL(string: url[index]), placeholder: UIImage.init(named: "noImage"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: { (downloadImage, error, cacheType, url) in
        //                    //self.carouselView.images[index] = downloadImage!
        //                })
        
    }
    
    func startAutoScroll() {
        //optional method
        carouselView.startScrollImageView()
        
    }
    
    func stopAutoScroll() {
        //optional method
        carouselView.stopScrollImageView()
    }
    func showBannerSliderData(tag:Int, type:String)
    {
        
        var productID = ""
        var offerID = ""
        var categotyID = ""
        var brandID = ""
        
        
        if(type == "slider")
        {
            //let dicData = arrayBannerData[tag].dictionary ?? [:]
            
            let type = BannerSliderCollection.sharedInstance.arrayBrandList["type"]?[tag].string?.lowercased() ?? ""
            
            
            productID = ""
            offerID = ""
            categotyID = ""
            brandID = ""
            
            
            if(type == "category")
            {
                categotyID = BannerSliderCollection.sharedInstance.arrayBrandList["value"]?[tag].string ?? ""
                
            }
            if(type == "product")
            {
                productID = BannerSliderCollection.sharedInstance.arrayBrandList["value"]?[tag].string ?? ""
                
            }
            if(type == "brand")
            {
                brandID = BannerSliderCollection.sharedInstance.arrayBrandList["value"]?[tag].string ?? ""
                
            }
            if(type == "offer")
            {
                offerID = BannerSliderCollection.sharedInstance.arrayBrandList["value"]?[tag].string ?? ""
                
            }
            
            
            if(productID.count > 0)
            {
                
                let objVC =  UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC
                objVC.productId = productID
                objVC.stringTitle = ""
                self.navControll.present(objVC, animated: false, completion: nil)
                return
                
            }
            else if(categotyID.count > 0)
            {
                let brandVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BrandsListVC") as! BrandsListVC
                brandVC.modalPresentationStyle = .overCurrentContext
                brandVC.stringTitle = ""
                brandVC.stringCatId = categotyID
                self.navControll.present(brandVC, animated: false, completion: nil)
                
                return
                
            }
            else if(brandID.count > 0)
            {
                
                
                CartViewModel().getChildList(vc: self.navControll, param: ["brandid":brandID], completionHandler: { (result:[JSON], error:Error?) in
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
                        self.navControll.present(brandVC, animated: false, completion: nil)
                        
                    }
                    else
                    {
                        let brandVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductListVC") as! ProductListVC
                        brandVC.modalPresentationStyle = .overCurrentContext
                        brandVC.stringTitle = ""
                        brandVC.brandId = brandID
                        self.navControll.present(brandVC, animated: false, completion: nil)
                    }
                } )
                
                
                
                return
            }
            else if(offerID.count > 0)
            {
                let offerVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OffersHomeVC") as! OffersHomeVC
                offerVC.offerID = offerID
                navControll.definesPresentationContext = true
                offerVC.modalPresentationStyle = .overCurrentContext
                navControll.present(offerVC, animated: false, completion: nil)
                
                return
            }
            
            
        }
        
        
        
        
    }
    
    func setSlider(arrayBannerData:[String:JSON])
    {
        
        if(BannerSliderCollection.sharedInstance.arrayBrandList.count > 0)
        {
            let sliderFamilyImages = BannerSliderCollection.sharedInstance.arrayBrandList["images"]?.string ?? ""
            if(sliderFamilyImages.count > 0)
            {
                carouselView.delegate = self
                var imageArray = [String]()
                var arraImages = [String]()
                arraImages = sliderFamilyImages.components(separatedBy: ",") ?? [String]()
                
                for ind in 0..<arraImages.count
                {
                    imageArray.insert(KeyConstant.kImageBannerFamilyURL + arraImages[ind], at: imageArray.count)
                }
                
                carouselView.setCarouselData(paths: imageArray,  describedTitle: [], isAutoScroll: true, timer: 2.0, defaultImage: "noImage")
                
                carouselView.setCarouselOpaque(layer: false, describedTitle: false, pageIndicator: false)
                carouselView.setCarouselLayout(displayStyle: 0, pageIndicatorPositon: 2, pageIndicatorColor: AppColors.SelcetedColor, describedTitleColor: nil, layerColor: .clear)
            }
        }
        
        
    }
}
