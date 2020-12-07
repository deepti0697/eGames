//
//  PaymentOptionTVCell.swift
//  LENZZO
//
//  Created by Apple on 9/10/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import UIKit

protocol radioBtnDelegate {
    func radioBtnclicked(indexPth:IndexPath)
}

class PaymentOptionTVCell: UITableViewCell {
    @IBOutlet weak var imagePaytype: UIImageView!

    @IBOutlet weak var labelTitle: PaddingLabel!
    @IBOutlet weak var buttonSelection: UIButton!
    var delegate:radioBtnDelegate?
    var indexPth:IndexPath!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        labelTitle.font = UIFont(name: FontLocalization.medium.strValue, size: 14.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func radioBtnClicked(_ sender: UIButton) {
        
        self.delegate?.radioBtnclicked(indexPth: indexPth)
    }
}
