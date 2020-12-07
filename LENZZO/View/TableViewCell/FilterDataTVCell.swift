//
//  FilterDataTVCell.swift
//  LENZZO
//
//  Created by Apple on 9/16/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import UIKit

class FilterDataTVCell: UITableViewCell {

    @IBOutlet weak var buttonSetAction: UIButton!
    @IBOutlet weak var buttonRate5: UIButton!
    @IBOutlet weak var buttonRate4: UIButton!
    let stringUnselectedRate = "star_blank_50x50"
    let stringSelectedRate = "star"
    
    
    
    @IBOutlet weak var buttonRate3: UIButton!
    @IBOutlet weak var buttonRate2: UIButton!
    @IBOutlet weak var buttonRate1: UIButton!
    @IBOutlet weak var buttonMark: UIButton!
    @IBOutlet weak var labelTitle: PaddingLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func setRating(rate:Int)
    {
        
        switch(rate)
        {
        case 0:
            self.buttonRate1.setImage(UIImage(named: stringUnselectedRate), for: .normal)
            self.buttonRate2.setImage(UIImage(named: stringUnselectedRate), for: .normal)
            self.buttonRate3.setImage(UIImage(named: stringUnselectedRate), for: .normal)
            self.buttonRate4.setImage(UIImage(named: stringUnselectedRate), for: .normal)
            self.buttonRate5.setImage(UIImage(named: stringUnselectedRate), for: .normal)
            break
        case 1:
            self.buttonRate1.setImage(UIImage(named: stringSelectedRate), for: .normal)
            self.buttonRate2.setImage(UIImage(named: stringUnselectedRate), for: .normal)
            self.buttonRate3.setImage(UIImage(named: stringUnselectedRate), for: .normal)
            self.buttonRate4.setImage(UIImage(named: stringUnselectedRate), for: .normal)
            self.buttonRate5.setImage(UIImage(named: stringUnselectedRate), for: .normal)
            break
        case 2:
            self.buttonRate1.setImage(UIImage(named: stringSelectedRate), for: .normal)
            self.buttonRate2.setImage(UIImage(named: stringSelectedRate), for: .normal)
            self.buttonRate3.setImage(UIImage(named: stringUnselectedRate), for: .normal)
            self.buttonRate4.setImage(UIImage(named: stringUnselectedRate), for: .normal)
            self.buttonRate5.setImage(UIImage(named: stringUnselectedRate), for: .normal)
            break
        case 3:
            self.buttonRate1.setImage(UIImage(named: stringSelectedRate), for: .normal)
            self.buttonRate2.setImage(UIImage(named: stringSelectedRate), for: .normal)
            self.buttonRate3.setImage(UIImage(named: stringSelectedRate), for: .normal)
            self.buttonRate4.setImage(UIImage(named: stringUnselectedRate), for: .normal)
            self.buttonRate5.setImage(UIImage(named: stringUnselectedRate), for: .normal)
            break
        case 4:
            self.buttonRate1.setImage(UIImage(named: stringSelectedRate), for: .normal)
            self.buttonRate2.setImage(UIImage(named: stringSelectedRate), for: .normal)
            self.buttonRate3.setImage(UIImage(named: stringSelectedRate), for: .normal)
            self.buttonRate4.setImage(UIImage(named: stringSelectedRate), for: .normal)
            self.buttonRate5.setImage(UIImage(named: stringUnselectedRate), for: .normal)
            break
        case 5:
            self.buttonRate1.setImage(UIImage(named: stringSelectedRate), for: .normal)
            self.buttonRate2.setImage(UIImage(named: stringSelectedRate), for: .normal)
            self.buttonRate3.setImage(UIImage(named: stringSelectedRate), for: .normal)
            self.buttonRate4.setImage(UIImage(named: stringSelectedRate), for: .normal)
            self.buttonRate5.setImage(UIImage(named: stringSelectedRate), for: .normal)
            break

        default:
       
            self.buttonRate1.setImage(UIImage(named: stringUnselectedRate), for: .normal)
            self.buttonRate2.setImage(UIImage(named: stringUnselectedRate), for: .normal)
            self.buttonRate3.setImage(UIImage(named: stringUnselectedRate), for: .normal)
            self.buttonRate4.setImage(UIImage(named: stringUnselectedRate), for: .normal)
            self.buttonRate5.setImage(UIImage(named: stringUnselectedRate), for: .normal)
            break

            break
        }
        
    }
    
    
}
