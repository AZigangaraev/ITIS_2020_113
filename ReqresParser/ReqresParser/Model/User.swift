//
//  User.swift
//  ReqresParser
//
//  Created by Teacher on 30.11.2020.
//

import Foundation

struct User: Codable {
    let id: Int
    let email: String
    let firstName: String
    let lastName: String
    let avatar: URL
    
    
}
