//
//  BannerTableViewCell.swift
//  LENZZO
//
//  Created by Apple on 8/14/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import UIKit

class BannerTableViewCell: UITableViewCell {
    @IBOutlet weak var imageBanner: UIImageView!

    @IBOutlet weak var buttonBanner: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
        imageBanner.backgroundColor = .clear
        self.backgroundColor = .clear
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
