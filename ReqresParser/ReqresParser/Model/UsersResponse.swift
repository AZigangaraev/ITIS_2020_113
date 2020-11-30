//
//  UsersResponse.swift
//  ReqresParser
//
//  Created by Teacher on 30.11.2020.
//

import Foundation

struct UsersResponse: Codable {
    let page: Int
    let totalPages: Int
    let users: [User]

    enum CodingKeys: String, CodingKey {
        case page
        case totalPages
        case users = "data"
    }
}
