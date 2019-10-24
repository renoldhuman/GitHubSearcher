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

    
    @IBOutlet weak var userSearchBar: UISearchBar!
    
    var gitHubApiManager: GitHubApiManager!;
    var users: [GitHubUser]?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        userSearchBar.delegate = self;
        gitHubApiManager = GitHubApiManager();
        gitHubApiManager.apiDelegate = self;
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "userDetailsSegue") {
            let controller = segue.destination as! UserInfoManager;
            let cell = sender as! UITableViewCell;
            
            guard let index = tableView.indexPath(for: cell) else {
                return;
            }
            
            let user = users![index.row];
            controller.gitHubUser = user;
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "userDetailsSegue", sender: tableView.cellForRow(at: indexPath));
    }
//
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.count ?? 0;
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell")!;
        
        let username = cell.viewWithTag(2000) as! UILabel;
        username.text = users?[indexPath.row].username ?? "NOUSERNAME";
        
        let repos = cell.viewWithTag(3000) as! UILabel;
        repos.text = "Repos:\(users?[indexPath.row].reposCount ?? 0)"
        
        return cell;
    }
    
    
    

}

extension UserSearchManager : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        gitHubApiManager.fetchUsers(with: searchText);
    }
}

extension UserSearchManager: GitHubApiProtocol {
    func usersReceived(data: Data) {
        self.users = parseUsernames(data: data);
        DispatchQueue.main.async {
            self.tableView.reloadData();
        }
    }
    
    private func parseUsernames(data: Data) -> [GitHubUser] {
        let decoder = JSONDecoder();
        do {
            let users = try decoder.decode(GitHubUsersPacket.self, from: data);
            return users.usernames ?? [GitHubUser]();
        } catch {
            print(error);
        }
        
        return [GitHubUser]();
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


