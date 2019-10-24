//
//  ViewController.swift
//  GitHubSearh
//
//  Created by Tyler Helmrich on 10/23/19.
//  Copyright © 2019 Tyler Helmrich. All rights reserved.
//
import Foundation
import UIKit

class UserSearchManager: UITableViewController {

    private let API_RATE_LIMIT = true;
    
    @IBOutlet weak var userSearchBar: UISearchBar!
    
    var gitHubApiManager: GitHubApiManager!;
    var users = [GitHubUser]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        userSearchBar.delegate = self;
        
        if (API_RATE_LIMIT) {
            return;
        }
        else {
            gitHubApiManager = GitHubApiManager();
            gitHubApiManager.apiDelegate = self;
        }
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "userDetailsSegue") {
            let controller = segue.destination as! UserInfoManager;
            let cell = sender as! UITableViewCell;
            
            guard let index = tableView.indexPath(for: cell) else {
                return;
            }
            
            let user = users[index.row];
            controller.gitHubUser = user;
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "userDetailsSegue", sender: tableView.cellForRow(at: indexPath));
    }
//
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count;
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell")!;
        
        let quickInfo = cell.viewWithTag(1000) as! UserQuickInfo;
        
        quickInfo.setView(from: users[indexPath.row]);
        
        return cell;
    }
    
    
    

}

extension UserSearchManager : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        users = [GitHubUser]();
        if (API_RATE_LIMIT) {
            users = MockGitHubUser.getMockGitHubUsers(count: 20);
            self.tableView.reloadData();
        }
        else {
            gitHubApiManager.fetchUsernames(with: searchText);
        }
    }
}

extension UserSearchManager: GitHubApiProtocol {
    func userReceived(inFull user: GitHubUser) {
        users.append(user);
        DispatchQueue.main.async {
            self.tableView.reloadData();
        }
    }
}


