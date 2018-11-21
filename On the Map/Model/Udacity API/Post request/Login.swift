//
//  Login.swift
//  On the Map
//
//  Created by Maha on 13/11/2018.
//  Copyright © 2018 Maha_AlOtaibi. All rights reserved.
//

import Foundation

struct UdacityPost: Encodable {
    let udacity: Login
}

struct Login: Encodable {
    let username: String
    let password: String
    
}
