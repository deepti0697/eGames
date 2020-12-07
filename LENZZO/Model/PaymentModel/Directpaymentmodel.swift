//
//  Directpaymentmodel.swift
//  LENZZO
//
//  Created by sanjay mac on 11/11/20.
//  Copyright © 2020 LENZZO. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Directpaymentmodel{
    
    let PaymentType = "PaymentType"
    let SaveToken = "SaveToken"
    let IsRecurring = "IsRecurring"
    let IntervalDays = "IntervalDays"
    let Card:CardModel?
    let Bypass3DS = "Bypass3DS"
    let token = "token"
    
   
    
}
