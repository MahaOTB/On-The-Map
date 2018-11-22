//
//  UserData.swift
//  On the Map
//
//  Created by Maha on 23/11/2018.
//  Copyright © 2018 Maha_AlOtaibi. All rights reserved.
//

import Foundation

struct User: Codable {
    let user: UserData
}

struct UserData: Codable {
    let nickname: String
}
