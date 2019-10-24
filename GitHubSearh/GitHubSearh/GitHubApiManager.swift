//
//  GitHubApiManager.swift
//  GitHubSearh
//
//  Created by Tyler Helmrich on 10/23/19.
//  Copyright © 2019 Tyler Helmrich. All rights reserved.
//

import Foundation

protocol GitHubApiProtocol : class {
    func usernamesReceived(data: Data);
    func userReceived(data: Data);
}

class GitHubApiManager {
    
    weak var apiDelegate: GitHubApiProtocol?;
    
    public func fetchUsernames(with query: String) {
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
                self.apiDelegate?.usernamesReceived(data: data);
            }
        }

        task.resume();
    }
    
    public func fetchUser(with username: String) {
        let append = username.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "";
        let url: URL = URL(string: "https://api.github.com/users/\(append)")!;
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else{
                return;
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    return;
            }
            
            if let data = data {
                self.apiDelegate?.userReceived(data: data);
            }
        }

        task.resume();
    }
}
