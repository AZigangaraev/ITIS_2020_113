//
//  UserResponse.swift
//  ReqresParser
//
//  Created by Руслан Ахмадеев on 01.12.2020.
//

import Foundation

struct UserResponse: Codable {
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case  user = "data"
    }
}
