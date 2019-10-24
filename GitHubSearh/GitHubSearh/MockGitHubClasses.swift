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
        return GitHubUser(username: "regularman", avatarUrl: "", bio: "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.", joinDate: "May 20th 1993", email: "tyler.helmrich@gmail.com", location: "United States", followerCount: 5, followingCount: 922, reposCount: 2343, reposUrl: nil, avatar: nil)
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

