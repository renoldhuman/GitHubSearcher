//
//  GitHubApiManager.swift
//  GitHubSearh
//
//  Created by Tyler Helmrich on 10/23/19.
//  Copyright © 2019 Tyler Helmrich. All rights reserved.
//

import Foundation

// The GitHubApiManager needs to retain knowledge of the GitHubUser class due to the complexities of the strucure of the user data
// In order to maintain a consistency this class also has knowledge of the GitHubRepository Class
// A cleaner less rushed solution would potentially eliminate these necessities

protocol GitHubUserDataProtocol : class {
    func userReceived(inFull user: GitHubUser);
}

protocol GitHubRepositoryDataProtocol: class {
    func repositoriesReceived(with repos: [GitHubRepository]);
}

class GitHubApiManager {
    
    weak var userDataDelegate: GitHubUserDataProtocol?;
    weak var repositoryDataDelegate: GitHubRepositoryDataProtocol?
    
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
            
            if let data = data, let delegate = self.userDataDelegate {
                var userWithImage = user;
                userWithImage.avatar = data;
                delegate.userReceived(inFull: userWithImage);
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

extension GitHubApiManager {
    public func fetchRepos(for username: String) {
        let url: URL = URL(string: "https://api.github.com/users/\(username)/repos")!;
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else{
                return;
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    return;
            }
            
            if let data = data, let delegate = self.repositoryDataDelegate {
                delegate.repositoriesReceived(with: self.parseRepositories(data: data));
            }
        }

        task.resume();
    }
    
    public func fetchRepos(forUser username: String, with query: String) {
        let url: URL = URL(string: "https://api.github.com/search/repositories?q=user:\(username)+\(query)")!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else{
                return;
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    return;
            }
            
            if let data = data, let delegate = self.repositoryDataDelegate {
                delegate.repositoriesReceived(with: self.parseRepositoryPacket(data: data));
            }
        }

        task.resume();
    }
    
    private func parseRepositoryPacket(data: Data) -> [GitHubRepository] {
        let decoder = JSONDecoder();
        do {
            let repositories = try decoder.decode(GitHubRepositoriesPacket.self, from: data);
            return repositories.repositories ?? [GitHubRepository]();
        }
        catch {
            print(error);
        }
        
        return [GitHubRepository]();
    }
    
    private func parseRepositories(data: Data) -> [GitHubRepository]{
        let decoder = JSONDecoder();
        do {
            let repositories = try decoder.decode([GitHubRepository].self, from: data);
            return repositories
        }
        catch {
            print(error);
        }
        
        return [GitHubRepository]();
    }
}
