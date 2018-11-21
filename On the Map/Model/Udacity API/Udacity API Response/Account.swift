//
//  Account.swift
//  On the Map
//
//  Created by Maha on 13/11/2018.
//  Copyright © 2018 Maha_AlOtaibi. All rights reserved.
//

import Foundation

struct Account: Decodable {
    let isRegistered: Bool
    let key: String
    
    enum CodingKeys: String,CodingKey {
        case isRegistered = "registered"
        case key = "key"
    }
}
