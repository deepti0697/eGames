//
//  BrandFilterTVCell.swift
//  LENZZO
//
//  Created by Apple on 12/20/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import UIKit

class BrandFilterTVCell: UITableViewCell {
    @IBOutlet weak var labeltitle: PaddingLabel!
    @IBOutlet weak var imageViewRadio: UIImageView!
    @IBOutlet weak var buttonSelection: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
