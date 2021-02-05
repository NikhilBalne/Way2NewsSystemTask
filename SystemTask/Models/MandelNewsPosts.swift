//
//  MandelPosts.swift
//  SystemTask
//
//  Created by Nikhil Balne on 29/10/20.
//

import Foundation

struct MandelNewsPosts: Decodable {
    let message: String
    let mandals: [Mandal]
    let data, alert: String

    enum CodingKeys: String, CodingKey {
        case message = "MESSAGE"
        case mandals
        case data = "DATA"
        case alert = "ALERT"
    }
}

// MARK: - Mandal
struct Mandal: Decodable {
    let mandalPostsCount, mandalPer, mandalID: Int
    let mandalName: String

    enum CodingKeys: String, CodingKey {
        case mandalPostsCount, mandalPer
        case mandalID = "mandal_id"
        case mandalName = "mandal_name"
    }
}
