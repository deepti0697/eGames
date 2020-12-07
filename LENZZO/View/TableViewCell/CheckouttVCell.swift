//
//  CheckouttVCell.swift
//  LENZZO
//
//  Created by Apple on 9/7/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import UIKit

class CheckouttVCell: UITableViewCell {

    @IBOutlet weak var buttonSelectAddress: UIButton!
    @IBOutlet weak var labelInfo: PaddingLabel!
    @IBOutlet weak var buttonCart: UIButton!
    @IBOutlet weak var buttonEdit: UIButton!
    @IBOutlet weak var buttonDelete: UIButton!
    
    @IBOutlet weak var pencilImgView: UIImageView!
    
    @IBOutlet weak var deleteImgView: UIImageView!
    @IBOutlet weak var editLbl: PaddingLabel!
    @IBOutlet weak var deleteLbl: PaddingLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let imgPencile = UIImage(named: "pencil")?.withRenderingMode(.alwaysTemplate)
        self.pencilImgView.image = imgPencile
        self.pencilImgView.tintColor = .white
        
        let imgDelete = UIImage(named: "delete")?.withRenderingMode(.alwaysTemplate)
        self.deleteImgView.image = imgDelete
        self.deleteImgView.tintColor = .white
        self.editLbl.font = UIFont(name: FontLocalization.medium.strValue, size: 13.0)
        self.deleteLbl.font = UIFont(name: FontLocalization.medium.strValue, size: 13.0)
        self.labelInfo.font = UIFont(name: FontLocalization.medium.strValue, size: 13.0)
        
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
