//
//  GitHubApiManager.swift
//  GitHubSearh
//
//  Created by Tyler Helmrich on 10/23/19.
//  Copyright © 2019 Tyler Helmrich. All rights reserved.
//

import Foundation

protocol GitHubApiProtocol : class {
    func usersReceived(users: [GitHubUsername]);
}

class GitHubApiManager {
    
    weak var apiDelegate: GitHubApiProtocol?;
    
    public func fetchUsers(with query: String) {
        let url: URL = URL(string: "https://api.github.com/search/users?q=\(query)")!;
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else{
                return;
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    return;
            }
            
            if let data = data {
                self.apiDelegate?.usersReceived(users: self.parseUsernames(data: data));
            }
        }

        task.resume();
    }
    
    private func parseUsernames(data: Data) -> [GitHubUsername] {
        let decoder = JSONDecoder();
        do {
            let users = try decoder.decode(GitHubUsersPacket.self, from: data);
            return users.usernames ?? [GitHubUsername]();
        } catch {
            print(error);
        }
        
        return [GitHubUsername]();
    }
    
    public func fetchUser(with username: String) {
        
    }
}
