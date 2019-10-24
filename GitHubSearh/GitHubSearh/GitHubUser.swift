//
//  GitHubUser.swift
//  GitHubSearh
//
//  Created by Tyler Helmrich on 10/23/19.
//  Copyright © 2019 Tyler Helmrich. All rights reserved.
//

import Foundation

struct GitHubUsersPacket: Decodable {
    var count: Int;
    var status: Bool;
    var usernames: [GitHubUser]?;
    
    enum CodingKeys: String, CodingKey {
        case count = "total_count"
        case status = "incomplete_results"
        case usernames = "items"
    }
}

struct GitHubUsername: Decodable {
    var username: String;
    
    enum CodingKeys: String, CodingKey {
        case username = "login"
    }
}

struct GitHubUser: Decodable {
    var username: String;
    var avatarUrl: String;
    var bio: String?;
    var joinDate: String?;
    var email: String?;
    var location: String?;
    var followerCount: Int?;
    var followingCount: Int?;
    var reposCount: Int?;
    var reposUrl: String?;
    var avatar: Data?;

    enum CodingKeys: String, CodingKey {
        case username = "login"
        case avatarUrl = "avatar_url"
        case joinDate = "created_at"
        case email = "email"
        case location = "location"
        case followerCount = "followers"
        case followingCount = "following"
        case reposCount = "public_repos"
        case reposUrl = "repos_url"
    }
    
}
