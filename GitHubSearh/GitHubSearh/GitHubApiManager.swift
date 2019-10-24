//
//  GitHubApiManager.swift
//  GitHubSearh
//
//  Created by Tyler Helmrich on 10/23/19.
//  Copyright © 2019 Tyler Helmrich. All rights reserved.
//

import Foundation

protocol GitHubApiProtocol : class {
    func usersReceived(data: Data);
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
                self.apiDelegate?.usersReceived(data: data);
            }
        }

        task.resume();
    }
    
    public func fetchUser(with username: String,  completionHandler: @escaping (_ data: Data) -> Void) {
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
                completionHandler(data);
            }
        }

        task.resume();
    }
}
