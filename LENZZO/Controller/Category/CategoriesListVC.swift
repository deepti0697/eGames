//
//  CategoriesListVC.swift
//  LENZZO
//
//  Created by Apple on 8/14/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import UIKit
import Kingfisher
import AlamofireImage
import SwiftyJSON

class CategoriesListVC: UIViewController {
    @IBOutlet weak var buttonMenu: UIButton!
    var titleArray = [String]()
    @IBOutlet weak var labelNotFound: UILabel!
    @IBOutlet weak var labelCountCart: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.buttonMenu.addTarget(self, action:#selector(backAction), for: .touchUpInside)
        self.labelNotFound.isHidden = true
        
        CategoriesModelView().getCategoriesInfo(vc: self, completionHandler: { (success: Bool, errorC:Error?) in
            
            if(CategoriesModel.sharedInstance.arrayCatList.count == 0)
            {
                self.labelNotFound.isHidden = false
            }
            else
            {
                self.labelNotFound.isHidden = true
                
            }
            
            self.tableView.reloadData()
        })
        
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
    @objc func backAction(sender:UIButton)
    {
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

extension CategoriesListVC:UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return CategoriesModel.sharedInstance.arrayCatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BannerTableViewCell") as! BannerTableViewCell
        cell.imageBanner.contentMode = .scaleAspectFit
        if let strUrl = CategoriesModel.sharedInstance.arrayCatList[indexPath.row].cat_image
        {
            if(strUrl.count > 0)
            {
                let urlString = strUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                
                cell.imageBanner.kf.setImage(with: URL(string: KeyConstant.kImageBaseCategoryURL + urlString!)!, placeholder: UIImage.init(named: "noImage"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: { (downloadImage, error, cacheType, url) in
                    if(downloadImage != nil)
                    {
                        cell.imageBanner.image = downloadImage!
                    }
                })
            }
            else
            {
                cell.imageBanner.image = UIImage(named: "noImage")
                
            }
        }
        else
        {
            cell.imageBanner.image = UIImage(named: "noImage")
            
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return  ((CGFloat(UIScreen.main.bounds.width))/3) + 7
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        BrandModel.sharedInstance.arrayBrandList.removeAll()
        
        tableView.deselectRow(at: indexPath, animated: false)
        let brandVC = self.storyboard?.instantiateViewController(withIdentifier: "BrandsListVC") as! BrandsListVC
        self.definesPresentationContext = true
        brandVC.modalPresentationStyle = .overCurrentContext
        brandVC.stringTitle = CategoriesModel.sharedInstance.arrayCatList[indexPath.row].name
        brandVC.stringCatId = CategoriesModel.sharedInstance.arrayCatList[indexPath.row].id
        self.present(brandVC, animated: false, completion: nil)
        
        
        
        
    }
}
