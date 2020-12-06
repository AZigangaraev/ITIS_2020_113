//
//  UserResponse.swift
//  ReqresParser
//
//  Created by Robert Mukhtarov on 05.12.2020.
//

struct UserResponse: Codable {
    let user: User

    enum CodingKeys: String, CodingKey {
        case user = "data"
    }
}
