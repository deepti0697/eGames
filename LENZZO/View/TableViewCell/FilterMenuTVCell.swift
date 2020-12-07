//
//  FilterMenuTVCell.swift
//  LENZZO
//
//  Created by Apple on 9/16/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import UIKit

class FilterMenuTVCell: UITableViewCell {

    @IBOutlet weak var imageViewMenu: UIImageView!
    @IBOutlet weak var labelTitle: PaddingLabel!
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var viewMenu: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
