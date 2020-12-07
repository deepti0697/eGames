//
//  FamilyCollectionViewCell.swift
//  LENZZO
//
//  Created by Apple on 11/13/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import UIKit

class FamilyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageViewCategory: UIImageView!
    @IBOutlet weak var labelEndIn: PaddingLabel!
    @IBOutlet weak var labelProductName: PaddingLabel!
    
    @IBOutlet weak var labelOfferTime: PaddingLabel!
    @IBOutlet weak var labelTime: PaddingLabel!
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1))
        contentView.backgroundColor = UIColor.clear
        //contentView.dropShadow(color: UIColor.init(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1.0), opacity: 1, offSet: CGSize(width: -1, height: -1), radius: 3, scale: true)
        
        
    }
}
