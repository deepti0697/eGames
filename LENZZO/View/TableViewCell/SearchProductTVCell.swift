//
//  SearchProductTVCell.swift
//  LENZZO
//
//  Created by Apple on 9/17/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import UIKit

class SearchProductTVCell: UITableViewCell {
    @IBOutlet weak var labelDesc: PaddingLabel!

    @IBOutlet weak var labeltitle: PaddingLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.labeltitle.font = UIFont(name: FontLocalization.Light.strValue, size: 15.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
