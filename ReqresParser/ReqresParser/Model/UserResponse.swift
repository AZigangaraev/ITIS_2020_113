//
//  UserResponse.swift
//  ReqresParser
//
//  Created by Никита Ляпустин on 03.12.2020.
//

import Foundation

struct UserResponse: Codable {
    let user: User

    enum CodingKeys: String, CodingKey {
        case user = "data"
    }
}
