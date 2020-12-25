//
//  ProductListCVCell.swift
//  LENZZO
//
//  Created by Apple on 8/16/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import UIKit

class ProductListCVCell: UICollectionViewCell {
    
    @IBOutlet weak var offerPriceLbl: PaddingLabel!
    @IBOutlet weak var imageViewProduct: UIImageView!
    @IBOutlet weak var labelProductName: PaddingLabel!
    
    @IBOutlet weak var productPriceLbl: PaddingLabel!
    
    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var addToCartImgView: UIImageView!
    
    @IBOutlet weak var addtoCartLbl: UILabel!
    
    @IBOutlet weak var addtoCartView: UIView!
    
    @IBOutlet weak var addtoCartBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        productPriceLbl.font = UIFont(name: FontLocalization.medium.strValue, size: 10.0)
        addtoCartLbl.font = UIFont(name: FontLocalization.medium.strValue, size: 10.0)
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.black.withAlphaComponent(1.0).cgColor,
                                UIColor.black.withAlphaComponent(0.0).cgColor]
        //gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = imageViewProduct.frame
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        

        
        imageViewProduct.layer.insertSublayer(gradientLayer, at: 0)
        
        
    }
    

    
}


