//
//  GitHubApiManager.swift
//  GitHubSearh
//
//  Created by Tyler Helmrich on 10/23/19.
//  Copyright © 2019 Tyler Helmrich. All rights reserved.
//

import Foundation

protocol GitHubApiProtocol : class {
//    func usernamesReceived(data: Data);
//    func userReceived(data: Data);
    func userReceived(inFull user: GitHubUser);
}

class GitHubApiManager {
    
    weak var apiDelegate: GitHubApiProtocol?;
    
    var usernames: [GitHubUser]?;
    
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
                self.parseUsernames(data: data);
                if let validUsernames = self.usernames {
                    for user in validUsernames {
                        self.fetchUser(with: user.username);
                    }
                }
                //self.apiDelegate?.usernamesReceived(data: data);
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
                if let user = self.parseUser(data: data) {
                    self.fetchImage(with: user);
                }
                //self.apiDelegate?.userReceived(data: data);
            }
        }

        task.resume();
    }
    
    private func fetchImage(with user: GitHubUser){
        let url: URL = URL(string: user.avatarUrl)!;
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else{
                return;
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    return;
            }
            
            if let data = data {
                var userWithImage = user;
                userWithImage.avatar = data;
                self.apiDelegate?.userReceived(inFull: userWithImage);
            }
        }
        
        task.resume();
    }
    
    private func parseUsernames(data: Data) {
        let decoder = JSONDecoder();
        do {
            let packet = try decoder.decode(GitHubUsersPacket.self, from: data);
            self.usernames = packet.usernames;
        } catch {
            print(error);
        }
    }
    
    private func parseUser(data: Data) -> GitHubUser? {
        let decoder = JSONDecoder();
        do {
            let user = try decoder.decode(GitHubUser.self, from: data);
            return user;
        } catch {
            print(error);
        }
        
        return nil;
    }
}
