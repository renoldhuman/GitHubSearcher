//
//  RepositoryInfo.swift
//  GitHubSearh
//
//  Created by Tyler Helmrich on 10/24/19.
//  Copyright © 2019 Tyler Helmrich. All rights reserved.
//

import Foundation

struct GitHubRepository: Decodable {
    var repositoryUrl: String;
    var repositoryName: String
    var forkCount: Int?;
    var starCount: Int?;
    
    enum CodingKeys: String, CodingKey {
        case repositoryUrl = "html_url"
        case repositoryName = "name"
        case forkCount = "forks"
        case starCount = "stargazers_count"
    }
}

struct GitHubRepositoriesPacket: Decodable {
    var count: Int;
    var status: Bool;
    var repositories: [GitHubRepository]?;
    
    enum CodingKeys: String, CodingKey {
        case count = "total_count"
        case status = "incomplete_results"
        case repositories = "items"
    }
}
