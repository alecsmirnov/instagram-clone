//
//  Post.swift
//  Instagram
//
//  Created by Admin on 03.02.2021.
//

import Foundation

struct Post {
    let imageURL: String
    let caption: String?
    let timestamp: TimeInterval
}

// MARK: - Codable

extension Post: Codable {
    enum CodingKeys: String, CodingKey {
        case imageURL = "image_url"
        case caption
        case timestamp
    }
}
