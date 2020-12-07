//
//  BrandsListVC.swift
//  LENZZO
//
//  Created by Apple on 8/14/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import UIKit
import Kingfisher
import AlamofireImage
import SwiftyJSON


class BrandsListVC: UIViewController {
    @IBOutlet weak var buttonMenu: UIButton!
    var stringTitle = String()
    var stringCatId = String()
    
    var arrayFilterAllBrands = [JSON]()
    
    
    @IBOutlet weak var navTitleLbl: PaddingLabel!
    @IBOutlet weak var labelNotFound: UILabel!
    @IBOutlet weak var backImgView: UIImageView!
    
    @IBOutlet weak var cartBtn: UIButton!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var labelCountCart: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.buttonMenu.addTarget(self, action:#selector(backAction), for: .touchUpInside)
        self.initialSetUp()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(rightSwip))
        self.labelNotFound.isHidden = true
        
        if(HelperArabic().isArabicLanguage())
        {
            
            swipeRight.direction = UISwipeGestureRecognizer.Direction.left
            
        }
        else
        {
            swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        }
        
        
        self.view.addGestureRecognizer(swipeRight)
        
        BrandModel.sharedInstance.arrayBrandList.removeAll()
        if(arrayFilterAllBrands.count > 0)
        {
            BrandModel.sharedInstance.addFilterData(arrayData: arrayFilterAllBrands)
            if(BrandModel.sharedInstance.arrayBrandList.count == 0)
            {
                self.labelNotFound.isHidden = false
            }
            else
            {
                self.labelNotFound.isHidden = true
                
            }
            self.collectionView.reloadData()
            
            
        }
        else if(stringCatId.count == 0)
        {
            
            BrandModelview().getAllBrandInfo(vc: self, brandId: "", completionHandler: { (success: Bool, errorC:Error?) in
                
                if(BrandModel.sharedInstance.arrayBrandList.count == 0)
                {
                    self.labelNotFound.isHidden = false
                }
                else
                {
                    self.labelNotFound.isHidden = true
                    
                }
                self.collectionView.reloadData()
            })
        }
        else if(stringCatId.count > 0)
        {
            BrandModelview().getAllBrandByCategory(vc: self, catId: stringCatId, completionHandler: { (success: Bool, errorC:Error?) in
                if(BrandModel.sharedInstance.arrayBrandList.count == 0)
                {
                    self.labelNotFound.isHidden = false
                }
                else
                {
                    self.labelNotFound.isHidden = true
                    
                }
                self.collectionView.reloadData()
            })
        }
        
        self.changeTintAndThemeColor()
        
        
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
        
        
        CartViewModel().viewCartList(vc: self, param: ["user_id":KeyConstant.sharedAppDelegate.getUserId()], completionHandler: { (result:[JSON], totalCount:String ,error:Error?) in
            
            self.labelCountCart.text = ""
            
            
            
            if(result.count > 0)
            {
                print(result.count)
                self.labelCountCart.text = totalCount
                
            }})
        
        if(HelperArabic().isArabicLanguage())
        {
         self.backImgView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }
        else
        {
        self.backImgView.transform = CGAffineTransform(rotationAngle: 245)
        }
        
        
    }
    func initialSetUp(){
        self.navTitleLbl.text = self.stringTitle
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            let horizontalSpacing = flowLayout.scrollDirection == .vertical ? flowLayout.minimumInteritemSpacing : flowLayout.minimumLineSpacing
            
            let tablewidth = ((CGFloat(UIScreen.main.bounds.width) - CGFloat(35)))/3
            
            
            flowLayout.itemSize = CGSize(width: tablewidth, height: tablewidth)
        }
    }
    @objc func backAction(sender:UIButton)
    {
        //KeyConstant.sharedAppDelegate.setRoot()
        self.dismiss(animated: true, completion: nil)
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


extension BrandsListVC: UICollectionViewDelegate,UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return BrandModel.sharedInstance.arrayBrandList.count
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:HomeCollectionViewCell!
        
        cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as? HomeCollectionViewCell
        
        cell.offerView.isHidden = true
        if let strOfferName = BrandModel.sharedInstance.arrayBrandList[indexPath.item].offer_name
        {
            if(strOfferName.count > 0)
            {
                cell.offerView.isHidden = false
                cell.labelOfferType.text = strOfferName
            }
        }
        
        cell.imageViewCategory.contentMode = .scaleToFill
        
        if let strUrl = BrandModel.sharedInstance.arrayBrandList[indexPath.item].brand_image
        {
            if(strUrl.count > 0)
            {
                
                
                cell.imageViewCategory.kf.setImage(with: URL(string: KeyConstant.kImageBaseBrandURL + strUrl)!, placeholder: UIImage.init(named: "noImage"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: { (downloadImage, error, cacheType, url) in
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
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        //        if(arrayFilterAllBrands.count > 0)
        //        {
        //
        //            self.dismiss(animated: true, completion: {
        //
        //            self.delegateFilterBack.backWithBrandSelect(brandId: BrandModel.sharedInstance.arrayBrandList[indexPath.item].id)
        //            })
        //
        //        }
        //        else
        //        {
        //
        ProductListModel.sharedInstance.arrayProductList.removeAll()
        BannerSliderCollection.sharedInstance.arrayBrandList.removeAll()
        
        
//        if(BrandModel.sharedInstance.arrayBrandList[indexPath.item].arrChild.count > 0)
//        {
//            let brandVC = self.storyboard?.instantiateViewController(withIdentifier: "FamilyListVC") as! FamilyListVC
//            self.definesPresentationContext = true
//            brandVC.modalPresentationStyle = .overCurrentContext
//            brandVC.stringTitle = BrandModel.sharedInstance.arrayBrandList[indexPath.item].name
//            brandVC.brandId = BrandModel.sharedInstance.arrayBrandList[indexPath.item].id
//            brandVC.arrayChildData = BrandModel.sharedInstance.arrayBrandList[indexPath.item].arrChild
//            brandVC.sliderFamilyImages = BrandModel.sharedInstance.arrayBrandList[indexPath.item].brand_slider_images
//            print(brandVC.arrayChildData)
//
//            self.present(brandVC, animated: false, completion: nil)
//        }
//        else
//        {
            
            let brandVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductListVC") as! ProductListVC
            self.definesPresentationContext = true
            brandVC.modalPresentationStyle = .overCurrentContext
            brandVC.stringTitle = BrandModel.sharedInstance.arrayBrandList[indexPath.item].name
            brandVC.brandId = BrandModel.sharedInstance.arrayBrandList[indexPath.item].id
            self.present(brandVC, animated: false, completion: nil)
        
        
        
            
       // }
    }
    
    
    
    
    //  }
    
    
}
