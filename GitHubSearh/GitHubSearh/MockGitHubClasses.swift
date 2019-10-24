//
//  MockGitHubUser.swift
//  GitHubSearh
//
//  Created by Tyler Helmrich on 10/24/19.
//  Copyright © 2019 Tyler Helmrich. All rights reserved.
//

import Foundation


class MockGitHubUser {
    public static func getMockGitHubUsers(count: Int) -> [GitHubUser] {
        return [GitHubUser].init(repeating: getGitHubUserMockUp(), count: count);
    }

    public static func getGitHubUserMockUp() -> GitHubUser {
        return GitHubUser(username: "regularman", avatarUrl: "", bio: "It all starts here", joinDate: nil, email: "tyler.helmrich@gmail.com", location: "United States", followerCount: 5, followingCount: 922, reposCount: 2343, reposUrl: nil, avatar: nil)
    }
}

class MockGitHubRepository {
    public static func getMockGitHubRepositories(count: Int) -> [GitHubRepository] {
        return [GitHubRepository].init(repeating: getGitHubRepositoryMockUp(), count: count);
    }
    
    public static func getGitHubRepositoryMockUp() -> GitHubRepository {
        return GitHubRepository(repositoryUrl: "https://github.com/trustin/armeria", repositoryName: "armeria", forkCount: 2, starCount: 9)
    }
}

