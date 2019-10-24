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
    
    
    public var gitHubUser: GitHubUser?;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        guard gitHubUser != nil else {
            return;
        }
        userInfoView.setUserInfo(with: gitHubUser);
    }
}
