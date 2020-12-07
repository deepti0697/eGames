//
//  AccountTableViewCell.swift
//  LENZZO
//
//  Created by Apple on 11/19/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import UIKit

class AccountTableViewCell: UITableViewCell {
    @IBOutlet weak var labelCategoryName: PaddingLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        labelCategoryName.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
