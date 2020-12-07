//
//  CartTableViewCell.swift
//  LENZZO
//
//  Created by Apple on 9/3/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import UIKit

class CartTableViewCell: UITableViewCell {
    @IBOutlet weak var labelPower: PaddingLabel!
    
    @IBOutlet weak var trackOrderLbl: PaddingLabel!
    @IBOutlet weak var heightConstraintsFeedback: NSLayoutConstraint!
    
    @IBOutlet weak var deleteImgView: UIImageView!
    @IBOutlet weak var labelFamilyAmount: PaddingLabel!
    @IBOutlet weak var labelFamilyName: PaddingLabel!
    @IBOutlet weak var rightQTYTitle: PaddingLabel!
    @IBOutlet weak var leftQTYTitle: PaddingLabel!
    @IBOutlet weak var labelRightPrice: PaddingLabel!
    @IBOutlet weak var heightConstraintsTracking: NSLayoutConstraint!
    
    @IBOutlet weak var heightConstraintPower: NSLayoutConstraint!
    @IBOutlet weak var buttonViewProduct: UIButton!
    @IBOutlet weak var viewTrackOrder: UIView!
    @IBOutlet weak var buttonMoveToWishList: UIButton!
    @IBOutlet weak var buttonRemoveItem: UIButton!
    @IBOutlet weak var buttonIncrementItem: UIButton!
    @IBOutlet weak var buttonDecrementItem: UIButton!
    @IBOutlet weak var labelQty: PaddingLabel!
    @IBOutlet weak var labelItemCurrentAmount: PaddingLabel!
    @IBOutlet weak var labelItemName: PaddingLabel!
    @IBOutlet weak var imageViewItem: UIImageView!
    @IBOutlet weak var labelHeaderItemPrice: PaddingLabel!
    @IBOutlet weak var labelHeaderItemNumber: PaddingLabel!
    
    @IBOutlet weak var leftPriceHeightconstraints: NSLayoutConstraint!
    @IBOutlet weak var feedbackView: UIView!
       @IBOutlet weak var leftQTYView: UIView!
    @IBOutlet weak var leftQTYViewConstraints: NSLayoutConstraint!

    @IBOutlet weak var rightQTYView: UIView!
    @IBOutlet weak var rightQTYViewConstraints: NSLayoutConstraint!
    @IBOutlet weak var rightPriceConstraint: NSLayoutConstraint!

    @IBOutlet weak var buttonRightQtyIncre: UIButton!
    @IBOutlet weak var labelRighQty: PaddingLabel!
    @IBOutlet weak var buttonRightQtyDecre: UIButton!
    @IBOutlet weak var labelOrderQty: PaddingLabel!
    @IBOutlet weak var labelDate: PaddingLabel!
    @IBOutlet weak var buttonViewDetails: UIButton!
    @IBOutlet weak var buttonTrackOrders: UIButton!
    @IBOutlet weak var labelStatus: PaddingLabel!
    
    
    @IBOutlet weak var labelFeedback: PaddingLabel!
    @IBOutlet weak var buttonFeedback: UIButton!
    @IBOutlet weak var labelOfferAlertTitle: PaddingLabel!
    @IBOutlet weak var labelOfferAlertDescr: PaddingLabel!
    @IBOutlet weak var labelOfferAlertProductName: PaddingLabel!
    
    @IBOutlet weak var labelOutStock: PaddingLabel!
    
    @IBOutlet weak var removeLbl: PaddingLabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code


        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
