//
//  GiftTableViewCell.swift
//  LENZZO
//
//  Created by Apple on 9/10/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import UIKit

class GiftTableViewCell: UITableViewCell {

    @IBOutlet weak var buttonSelectionGift: UIButton!
    @IBOutlet weak var buttonViewImage: UIButton!
    @IBOutlet weak var buttonViewDesc: UIButton!
    @IBOutlet weak var buttonGiftsDesc: PaddingLabel!
    @IBOutlet weak var labelgiftsTitle: PaddingLabel!
    @IBOutlet weak var imageViewGift: UIImageView!
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
