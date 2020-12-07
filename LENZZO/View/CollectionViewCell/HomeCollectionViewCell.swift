//
//  HomeCollectionViewCell.swift
//  LENZZO
//
//  Created by Apple on 8/14/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var offerView: UIView!
    
    @IBOutlet weak var imageViewCategory: UIImageView!
    
    @IBOutlet weak var labelOfferType: UILabel!

    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.imageViewCategory.layer.borderColor = UIColor.white.cgColor
//        self.imageViewCategory.layer.borderWidth = 2
//        self.imageViewCategory.backgroundColor = UIColor.white
//        self.imageViewCategory.layer.cornerRadius = 4
        labelOfferType.font = UIFont(name: FontLocalization.Bold.strValue, size: 7.0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
                contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1))
        contentView.backgroundColor = .clear//AppColors.themeColor
               //contentView.dropShadow(color: UIColor.init(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1.0), opacity: 1, offSet: CGSize(width: -1, height: -1), radius: 3, scale: true)
        labelOfferType.font = UIFont(name: FontLocalization.Bold.strValue, size: 7.0)
        
    }
}
