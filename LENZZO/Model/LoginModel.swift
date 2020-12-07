//
//  LoginModel.swift
//  LENZZO
//
//  Created by Apple on 8/30/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import Foundation
import  UIKit

struct LoginModel
{
    let email: String!
    let password: String!
    
    init(email:String, password:String) {
        self.email = email
        self.password = password
    }
}
