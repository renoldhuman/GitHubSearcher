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
    var forkCount: Int?;
    var starCount: Int?;
    
    enum CodingKeys: String, CodingKey {
        case repositoryUrl = "html_url"
        case forkCount = "forks"
        case starCount = "stargazers_count"
    }
}
