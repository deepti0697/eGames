//
//  ProdcutListTVCell.swift
//  LENZZO
//
//  Created by sanjay mac on 13/06/20.
//  Copyright © 2020 LENZZO. All rights reserved.
//

import UIKit

class ProdcutListTVCell: UITableViewCell {

    @IBOutlet weak var productImgView: UIImageView!

    @IBOutlet weak var productNameLbl: UILabel!

    @IBOutlet weak var productPriceLbl: UILabel!


    @IBOutlet weak var addToCartBtn: UIButton!


    @IBOutlet weak var viewDetailBtn: UIButton!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.productNameLbl.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        self.productPriceLbl.font = UIFont(name: FontLocalization.medium.strValue, size: 12.0)
        self.addToCartBtn.titleLabel?.font = UIFont(name: FontLocalization.medium.strValue, size: 14.0)
        self.viewDetailBtn.titleLabel?.font = UIFont(name: FontLocalization.medium.strValue, size: 14.0)
        self.productNameLbl.numberOfLines = 4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }




}
