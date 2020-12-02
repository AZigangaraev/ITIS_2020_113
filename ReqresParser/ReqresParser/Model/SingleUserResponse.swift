//
//  SingleUserResponse.swift
//  ReqresParser
//
//  Created by Ruslan Khanov on 02.12.2020.
//

import Foundation

struct SingleUserResponse : Codable {
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case user = "data"
    }
}
