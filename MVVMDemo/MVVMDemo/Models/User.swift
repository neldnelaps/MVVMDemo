//
//  User.swift
//  MVVMDemo
//
//  Created by Natalia Pashkova on 17.03.2023.
//

import Foundation

struct User: Codable {
    let userID, id: Int
    var title, body: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }
}
