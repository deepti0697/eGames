//
//  ProductDetailCVCell.swift
//  LENZZO
//
//  Created by sanjay mac on 14/06/20.
//  Copyright © 2020 LENZZO. All rights reserved.
//

import UIKit

class ProductDetailCVCell: UICollectionViewCell {
    
    
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var ImgView: UIImageView!
    @IBOutlet weak var productPriceLbl: UILabel!
    @IBOutlet weak var addToCartBtn: UIButton!
    @IBOutlet weak var viewDetailBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }



}
