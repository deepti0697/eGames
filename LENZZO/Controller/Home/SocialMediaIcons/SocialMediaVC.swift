//
//  SocialMediaVC.swift
//  LENZZO
//
//  Created by Apple on 9/26/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import UIKit
import SwiftyJSON
import AlamofireImage

class SocialMediaVC: UIViewController {
    @IBOutlet weak var buttonMenu: UIButton!
    var imagesArray = ["icons8-facebook-f-50.png","icons8-google-plus-50.png","icons8-instagram-50.png","icons8-pinterest-p-50.png","icons8-twitter-50.png","icons8-youtube-50.png"]
    @IBOutlet weak var labelCountCart: UILabel!
    var titleString = String()
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var labelTitle: PaddingLabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.buttonMenu.addTarget(self, action:#selector(backAction), for: .touchUpInside)
        
        self.labelTitle.text = titleString
        collectionView.delegate = self
        collectionView.dataSource = self
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        self.initialSetUp()
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
    
    func initialSetUp(){
        
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            let horizontalSpacing = flowLayout.scrollDirection == .vertical ? flowLayout.minimumInteritemSpacing : flowLayout.minimumLineSpacing
            
            let tablewidth = ((CGFloat(UIScreen.main.bounds.width) - CGFloat(25)))/2
            flowLayout.itemSize = CGSize(width: tablewidth, height: tablewidth)
        }
    }
    @objc func backAction(sender:UIButton)
    {
        self.dismiss(animated: true, completion: nil)
        
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
extension SocialMediaVC: UICollectionViewDelegate,UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return  imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:HomeCollectionViewCell!
        
        cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as? HomeCollectionViewCell
        cell.imageViewCategory.image = UIImage(named: imagesArray[indexPath.row])
        return cell
        
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
    }
    
    
}
