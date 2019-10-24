//
//  UserInfoManager.swift
//  GitHubSearh
//
//  Created by Tyler Helmrich on 10/24/19.
//  Copyright © 2019 Tyler Helmrich. All rights reserved.
//

import Foundation
import UIKit

class UserInfoManager: UIViewController {
    
    @IBOutlet weak var userInfoView: UserInfo!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    public var gitHubUser: GitHubUser?;
    private var gitHubRepos = [GitHubRepository]();
    var gitHubApiManager: GitHubApiManager!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        guard gitHubUser != nil else {
            dismiss(animated: true, completion: nil);
            return;
        }
        gitHubApiManager = GitHubApiManager();
        gitHubApiManager.repositoryDataDelegate = self;
        userInfoView.setUserInfo(with: gitHubUser);
        
        if (UserSearchManager.API_RATE_LIMIT) {
            gitHubRepos = MockGitHubRepository.getMockGitHubRepositories(count: 20);
        }
        else {
            gitHubApiManager.fetchRepos(for: gitHubUser!.username);
        }
        
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.reloadData();
    }
}

extension UserInfoManager: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        gitHubRepos = [GitHubRepository]();
        
        if (UserSearchManager.API_RATE_LIMIT) {
            gitHubRepos = MockGitHubRepository.getMockGitHubRepositories(count: 20);
        }
        else {
            gitHubApiManager.fetchRepos(forUser: gitHubUser!.username, with: searchText);
        }
        
    }
}

extension UserInfoManager: GitHubRepositoryDataProtocol {
    func repositoriesReceived(with repos: [GitHubRepository]) {
        self.gitHubRepos = repos;
        DispatchQueue.main.async {
            self.tableView.reloadData();
        }
    }
}

extension UserInfoManager: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        gitHubRepos.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repositoryCell")!;
        
        let repository = cell.viewWithTag(1000) as! RepositoryQuickInfo;
        
        repository.setView(using: gitHubRepos[indexPath.row]);
        
        return cell;
    }
    
    
}

extension UserInfoManager: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repo = gitHubRepos[indexPath.row];
        
        if let url = URL(string: repo.repositoryUrl) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil);
        }
    }
}
