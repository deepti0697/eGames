//
//  TopBrandTVCell.swift
//  LENZZO
//
//  Created by sanjay mac on 17/06/20.
//  Copyright © 2020 LENZZO. All rights reserved.
//

import UIKit

class TopBrandTVCell: UITableViewCell {

    @IBOutlet weak var productImgView: UIImageView!

    @IBOutlet weak var productNameLbl: UILabel!

    @IBOutlet weak var productPriceLbl: UILabel!


    @IBOutlet weak var addToCartBtn: UIButton!


    @IBOutlet weak var viewDetailBtn: UIButton!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        productNameLbl.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        productPriceLbl.font = UIFont(name: FontLocalization.medium.strValue, size: 12.0)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }




}
