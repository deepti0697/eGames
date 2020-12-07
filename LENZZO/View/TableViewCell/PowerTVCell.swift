//
//  PowerTVCell.swift
//  LENZZO
//
//  Created by Apple on 8/17/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import UIKit

class PowerTVCell: UITableViewCell {

    @IBOutlet weak var buttonSelected: UIButton!
    @IBOutlet weak var buttonRadio: UIButton!
    @IBOutlet weak var labelPower: PaddingLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.labelPower.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
