//
//  HomeCategoryTVCell.swift
//  LENZZO
//
//  Created by Apple on 8/14/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol HomeCategoryTVCellDelegate{
    func presentControllerFromCell(collectionTag:Int,index:Int)
}


class HomeCategoryTVCell: UITableViewCell,UIScrollViewDelegate {

    var viewController = HomeVC()
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var buttonActionView: UIButton!
    @IBOutlet weak var labelCategoryName: PaddingLabel!
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var scrollSubView: UIView!
    @IBOutlet weak var scrollConstantWidth: NSLayoutConstraint!
    @IBOutlet weak var collectionWidthcon: NSLayoutConstraint!
    var collectionViewObserver: NSKeyValueObservation?
    var delegate:HomeCategoryTVCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        

    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = AppColors.themeColor
        
       contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
        self.initialSetUp()
//        self.contentView.backgroundColor = .red
//        self.scrollView.backgroundColor = .green
//        self.collectionView.backgroundColor = .cyan
        
        self.scrollView.delegate = self
        
        if #available(iOS 13.0, *) {

        self.contentView.clipsToBounds = false
        self.contentView.layer.masksToBounds = false
        }

        addObserver()
        
      
    }
  
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
      

      //  if let currency = UserDefaults.standard.array(forKey: KeyConstant.kSelectedDeviceCurrency)?.first as?
     //       String,currency == "ar"
            
        if (HelperArabic().isArabicLanguage())
        
        {
            if (scrollView.contentOffset.x < -15) {
                scrollView.contentOffset = CGPoint(x: -15, y: 0)
            }
            else
            {
                if(scrollView.contentOffset.x > 0)
                {
                    
                if ((scrollView.contentOffset.x + scrollView.bounds.size.width)  >  scrollView.contentSize.width + 20)
                {
                    scrollView.contentOffset = CGPoint(x: (scrollView.contentSize.width - scrollView.bounds.size.width + 20), y: 0)
                }
                    
                }
                
            }
        }
            
            
        else
        {
        if (scrollView.contentOffset.x < -20) {
            scrollView.contentOffset = CGPoint(x: -20, y: 0)
        }
        else{
            
            
            if ((scrollView.contentOffset.x + scrollView.bounds.size.width ) >  scrollView.contentSize.width + 15)
            {
                scrollView.contentOffset = CGPoint(x:  (scrollView.contentSize.width - scrollView.bounds.size.width + 15), y: 0)
            }
            
        }
        }
        
        

    }
    func addObserver() {
        collectionViewObserver = collectionView.observe(\.contentSize, changeHandler: { [weak self] (collectionView, change) in

     
            self?.collectionWidthcon.constant = collectionView.contentSize.width
            self?.scrollConstantWidth.constant = collectionView.contentSize.width -  (self?.scrollView.frame.width ?? 0)
           
            if(Int(collectionView.contentSize.width ) < Int(self?.frame.width ?? 0.0))
            {
                self?.scrollConstantWidth.constant = ((self?.frame.width ?? 0) -  (self?.scrollView.frame.width ?? 0)) - 20
            }


//            self?.scrollSubView.layer.masksToBounds = false
//            self?.scrollSubView.clipsToBounds = false
            
            self?.scrollView.clipsToBounds = false
            self?.scrollView.layer.masksToBounds = false
            self?.scrollView.backgroundColor = AppColors.themeColor
            self?.scrollSubView.backgroundColor = AppColors.themeColor

            //self?.scrollSubView.dropShadow(color: .gray, opacity: 1, offSet: CGSize(width: 0, height: 4), radius: 5, scale: true)
            
        
            if((UserDefaults.standard.array(forKey: "AppleLanguages")?.first as?
                String) == "ar")
            {
            self?.scrollView.scrollToBottom(animated: false)
            }


        })
    }
    deinit {
        collectionViewObserver = nil
    }
    func initialSetUp(){
        if collectionView.tag == 0{
            if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
                let horizontalSpacing = flowLayout.scrollDirection == .vertical ? flowLayout.minimumInteritemSpacing : flowLayout.minimumLineSpacing
                
                //let tablewidth = ((CGFloat(UIScreen.main.bounds.width) - CGFloat(55)))/2.1
                let tablewidth = ((CGFloat(UIScreen.main.bounds.width) - CGFloat(55)))/3.1
                flowLayout.itemSize = CGSize(width: tablewidth, height: tablewidth)
            }
        }else{
            if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
               // let horizontalSpacing = flowLayout.scrollDirection == .vertical ? flowLayout.minimumInteritemSpacing : flowLayout.minimumLineSpacing
                
                let tablewidth = ((CGFloat(UIScreen.main.bounds.width) - CGFloat(55)))/3.1
                flowLayout.itemSize = CGSize(width: tablewidth, height: tablewidth)
            }
        }
        
        
        self.buttonActionView.setTitle(NSLocalizedString("MSG435", comment: ""), for: .normal)
        self.buttonActionView.titleLabel?.font = UIFont(name: FontLocalization.medium.strValue, size: 12.0)
        self.labelCategoryName.font = UIFont(name: FontLocalization.Light.strValue, size: 14.0)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension HomeCategoryTVCell: UICollectionViewDelegate,UICollectionViewDataSource
{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0{
            return HomeInfoModel.sharedInstance.arrayTopSelling.count
        }
        else if collectionView.tag == 2{
            return HomeInfoModel.sharedInstance.arrayNewRelease.count // replace New Release in place of arrayTopBrand
        }
        else if collectionView.tag == 3{
            if HomeInfoModel.sharedInstance.arrayProduct.count > 0{
                 return HomeInfoModel.sharedInstance.arrayProduct[0].brand_list.count
            }
           
        }
        else if collectionView.tag == 4{
            if HomeInfoModel.sharedInstance.arrayProduct.count > 1{
            return HomeInfoModel.sharedInstance.arrayProduct[1].brand_list.count
            }
        }
        else if collectionView.tag == 6{
            if HomeInfoModel.sharedInstance.arrayProduct.count > 2{
            return HomeInfoModel.sharedInstance.arrayProduct[2].brand_list.count
            }
        }
        else if collectionView.tag == 7{
            if HomeInfoModel.sharedInstance.arrayProduct.count > 3{
            return HomeInfoModel.sharedInstance.arrayProduct[3].brand_list.count
            }
        }
        else if collectionView.tag == 8{
            if HomeInfoModel.sharedInstance.arrayProduct.count > 4{
            return HomeInfoModel.sharedInstance.arrayProduct[4].brand_list.count
            }
        }
        else if collectionView.tag == 9{
            if HomeInfoModel.sharedInstance.arrayProduct.count > 5{
            return HomeInfoModel.sharedInstance.arrayProduct[5].brand_list.count
            }
        }
        else if collectionView.tag == 10{
            if HomeInfoModel.sharedInstance.arrayProduct.count > 6{
            return HomeInfoModel.sharedInstance.arrayProduct[6].brand_list.count
            }
        }
        else if collectionView.tag == 11{
            if HomeInfoModel.sharedInstance.arrayProduct.count > 7{
            return HomeInfoModel.sharedInstance.arrayProduct[7].brand_list.count
            }
        }
        
//        if section == 0{
//
//
//
//        }
//        if section == 1{
//
//
//        }
//         else{
//            if(self.contentView.tag < HomeInfoModel.sharedInstance.arrayProduct.count)
//            {
//
//            }
//        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
       

        let imageView = UIImageView()
        // TopSelling section
         if collectionView.tag == 0{
            let cell:HomeCollectionViewCell!
             cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as? HomeCollectionViewCell
            cell.offerView.isHidden = true
            cell.imageViewCategory.contentMode = .scaleToFill
        

            if let strUrl = HomeInfoModel.sharedInstance.arrayTopSelling[indexPath.item].product_image
                      {
                          if(strUrl.count > 0)
                          {
                              let urlString = strUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

                              imageView.kf.setImage(with: URL(string: KeyConstant.kImageBaseProductURL + urlString!)!, placeholder: UIImage.init(named: "noImage"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: { (downloadImage, error, cacheType, url) in
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
            return cell
        }
//            // Top brand section
        else if collectionView.tag == 2{
            let cell:HomeCollectionViewCell!
             cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as? HomeCollectionViewCell
           cell.offerView.isHidden = true
            cell.imageViewCategory.contentMode = .scaleToFill


            if let strUrl = HomeInfoModel.sharedInstance.arrayNewRelease[indexPath.item].product_image
                      {
                          if(strUrl.count > 0)
                          {
                              let urlString = strUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

                            print(KeyConstant.kImageBaseProductURL + urlString!)
                              imageView.kf.setImage(with: URL(string: KeyConstant.kImageBaseProductURL + urlString!)!, placeholder: UIImage.init(named: "noImage"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: { (downloadImage, error, cacheType, url) in
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
           return cell
        }
        // Category section
        else if collectionView.tag == 3 {
            let cell:HomeCollectionViewCell!
             cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCellXbox", for: indexPath) as? HomeCollectionViewCell
            cell.offerView.isHidden = true
            
            if let strOfferName = HomeInfoModel.sharedInstance.arrayProduct[self.contentView.tag].brand_list[indexPath.item]["offer"]["offer_subtitle"].string
            {
                if(strOfferName.count > 0)
                {
                    cell.offerView.isHidden = false
                    cell.labelOfferType.text = strOfferName
                }
            }
            if(HelperArabic().isArabicLanguage())
            {
                
                if let strOfferName = HomeInfoModel.sharedInstance.arrayProduct[self.contentView.tag].brand_list[indexPath.item]["offer"]["offer_subtitle_ar"].string
                {
                    if(strOfferName.count > 0)
                    {
                        cell.offerView.isHidden = false
                        cell.labelOfferType.text = strOfferName
                    }
                }
            }
            cell.imageViewCategory.contentMode = .scaleToFill

            if HomeInfoModel.sharedInstance.arrayProduct.count > 0{
                if let strUrl = HomeInfoModel.sharedInstance.arrayProduct[0].brand_list[indexPath.item]["brand_image"].string
                {
                    if(strUrl.count > 0)
                    {
                        let urlString = strUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

                        imageView.kf.setImage(with: URL(string: KeyConstant.kImageBaseBrandURL + urlString!)!, placeholder: UIImage.init(named: "noImage"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: { (downloadImage, error, cacheType, url) in
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
                
            }
            

            else
            {
                cell.imageViewCategory.image = UIImage(named: "noImage")

            }
            return cell
        }
        else if collectionView.tag == 4 {
            let cell:HomeCollectionViewCell!
             cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCellPlayStation", for: indexPath) as? HomeCollectionViewCell
            cell.offerView.isHidden = true
            
            if let strOfferName = HomeInfoModel.sharedInstance.arrayProduct[self.contentView.tag].brand_list[indexPath.item]["offer"]["offer_subtitle"].string
            {
                if(strOfferName.count > 0)
                {
                    cell.offerView.isHidden = false
                    cell.labelOfferType.text = strOfferName
                }
            }
            if(HelperArabic().isArabicLanguage())
            {
                
                if let strOfferName = HomeInfoModel.sharedInstance.arrayProduct[self.contentView.tag].brand_list[indexPath.item]["offer"]["offer_subtitle_ar"].string
                {
                    if(strOfferName.count > 0)
                    {
                        cell.offerView.isHidden = false
                        cell.labelOfferType.text = strOfferName
                    }
                }
            }
            cell.imageViewCategory.contentMode = .scaleToFill

           if HomeInfoModel.sharedInstance.arrayProduct.count > 1{
            if let strUrl = HomeInfoModel.sharedInstance.arrayProduct[1].brand_list[indexPath.item]["brand_image"].string
            {
                if(strUrl.count > 0)
                {
                    let urlString = strUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

                    imageView.kf.setImage(with: URL(string: KeyConstant.kImageBaseBrandURL + urlString!)!, placeholder: UIImage.init(named: "noImage"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: { (downloadImage, error, cacheType, url) in
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
         }
            else
            {
                cell.imageViewCategory.image = UIImage(named: "noImage")

            }
            return cell
        }
         else if collectionView.tag >= 6{
            let cell:HomeCollectionViewCell!
             cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCellNintendo", for: indexPath) as? HomeCollectionViewCell
            cell.offerView.isHidden = true
            
            if let strOfferName = HomeInfoModel.sharedInstance.arrayProduct[self.contentView.tag].brand_list[indexPath.item]["offer"]["offer_subtitle"].string
            {
                if(strOfferName.count > 0)
                {
                    cell.offerView.isHidden = false
                    cell.labelOfferType.text = strOfferName
                }
            }
            if(HelperArabic().isArabicLanguage())
            {
                
                if let strOfferName = HomeInfoModel.sharedInstance.arrayProduct[self.contentView.tag].brand_list[indexPath.item]["offer"]["offer_subtitle_ar"].string
                {
                    if(strOfferName.count > 0)
                    {
                        cell.offerView.isHidden = false
                        cell.labelOfferType.text = strOfferName
                    }
                }
            }
            cell.imageViewCategory.contentMode = .scaleToFill

          if HomeInfoModel.sharedInstance.arrayProduct.count > 2{
            if let strUrl = HomeInfoModel.sharedInstance.arrayProduct[collectionView.tag - 4].brand_list[indexPath.item]["brand_image"].string
            {
                if(strUrl.count > 0)
                {
                    let urlString = strUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

                    imageView.kf.setImage(with: URL(string: KeyConstant.kImageBaseBrandURL + urlString!)!, placeholder: UIImage.init(named: "noImage"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: { (downloadImage, error, cacheType, url) in
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
         }
            else
            {
                cell.imageViewCategory.image = UIImage(named: "noImage")

            }
            return cell
        }

        return UICollectionViewCell()
        
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
        print(self.contentView.tag,indexPath.item)
        
        
        if collectionView.tag == 0{
            self.delegate?.presentControllerFromCell(collectionTag: collectionView.tag, index: indexPath.row)
        }
            
        else if collectionView.tag == 2{

            
            self.delegate?.presentControllerFromCell(collectionTag: collectionView.tag, index: indexPath.row)
            
        }
            
        else{
            
            
            if let brandDic = HomeInfoModel.sharedInstance.arrayProduct[self.contentView.tag].brand_list[indexPath.item].dictionary
            {
                ProductListModel.sharedInstance.arrayProductList.removeAll()
                BannerSliderCollection.sharedInstance.arrayBrandList.removeAll()
                
                
                //
                //                       let brandVC =  UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TopBrandListVC") as! TopBrandListVC
                //                      // self.definesPresentationContext = true
                //                       brandVC.modalPresentationStyle = .overCurrentContext
                //                brandVC.stringTitle = brandDic["name"]?.string ?? ""
                //                       //brandVC.delegateReloadData = self
                //                       if(HelperArabic().isArabicLanguage())
                //                       {
                //                        if let title_ar =  brandDic["name_ar"]?.string
                //                           {
                //                               brandVC.stringTitle = title_ar
                //
                //                           }
                //                       }
                //                      // brandVC.familyID = dic?["id"]?.string ?? ""
                //                brandVC.brandId = brandDic[""]
                //                       self.present(brandVC, animated: false, completion: nil)
                //
                
                
                let brandVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductListVC") as! ProductListVC
                self.viewController.definesPresentationContext = true
                brandVC.modalPresentationStyle = .overCurrentContext
                brandVC.stringTitle = HomeInfoModel.sharedInstance.arrayProduct[self.contentView.tag].brand_list[indexPath.item]["name"].string ?? ""
                
                if HelperArabic().isArabicLanguage(){
                    
                    if let nameAr = HomeInfoModel.sharedInstance.arrayProduct[self.contentView.tag].brand_list[indexPath.item]["name_ar"].string{
                      brandVC.stringTitle = nameAr
                    }
                }
                
                
                
                
               // HomeInfoModel.sharedInstance.arrayProduct[collectionView.tag - 4].brand_list[indexPath.item]["brand_image"].string
                brandVC.brandId = brandDic["id"]?.string ?? ""
                
                self.viewController.present(brandVC, animated: false, completion: nil)
                
                //                if(brandDic["child"]?.array?.count ?? 0 > 0)
                //                {
                //
                //                    let brandVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC
                //                    self.viewController.definesPresentationContext = true
                //                    brandVC.modalPresentationStyle = .overCurrentContext
                //                    brandVC.stringTitle = HomeInfoModel.sharedInstance.arrayProduct[self.contentView.tag].categoryName.uppercased()
                //                    brandVC.productId = brandDic["id"]?.string ?? ""
                //                   // brandVC.arrayChildData = brandDic["child"]?.array ?? [JSON]()
                //                   // brandVC.sliderFamilyImages = brandDic["brand_slider_images"]?.string ?? ""
                //                   // brandVC.stringTitle = brandDic["name"]
                //                    self.viewController.present(brandVC, animated: false, completion: nil)
                //                }
                //
                //                else
                //                {
                //
                //                    let brandVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductListVC") as! ProductListVC
                //                    self.viewController.definesPresentationContext = true
                //                    brandVC.modalPresentationStyle = .overCurrentContext
                //                    brandVC.stringTitle = HomeInfoModel.sharedInstance.arrayProduct[self.contentView.tag].categoryName.uppercased()
                //                    brandVC.brandId = brandDic["id"]?.string ?? ""
                //
                //                    self.viewController.present(brandVC, animated: false, completion: nil)
                //                }
                
            }
            
        }
        
        
        
        
        //     }
        
        
        
    }
    
    
}
extension UIScrollView {
    func scrollToBottom(animated: Bool) {
        if self.contentSize.height < self.bounds.size.height { return }
        let bottomOffset = CGPoint(x: self.contentSize.width - self.bounds.size.width, y: 0)
        self.setContentOffset(bottomOffset, animated: animated)
    }
}
