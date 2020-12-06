//
//  UserResponse.swift
//  ReqresParser
//
//  Created by Nikita Sosyuk on 01.12.2020.
//

import Foundation

struct UserResponse: Codable {
    let user: User
    let support: SupportData
    
    enum CodingKeys: String, CodingKey {
        case support
        case user = "data"
    }
}

struct SupportData: Codable {
    let url: URL
    let text: String
}
