//
//  SerachResult.swift
//  MaximalTest
//
//  Created by Anton Kinstler on 04.10.2022.
//

import Foundation

struct SearchResult: Decodable {
    let totalCount: Int
    let items: [User]
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case items
    }
}

struct User: Decodable, Identifiable {
    let login: String
    let id: Int
    let url: String
    let avatar: String
    let followers: String
    var followersCount: Int? = nil
    
    mutating func setFollowersCount(_ count: Int) {
        self.followersCount = count
    }
    
    enum CodingKeys: String, CodingKey  {
        case login, id, url
        case avatar = "avatar_url"
        case followers = "followers_url"
    }
}
