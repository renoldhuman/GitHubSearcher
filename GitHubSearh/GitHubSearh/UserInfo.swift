//
//  UserInfo.swift
//  GitHubSearh
//
//  Created by Tyler Helmrich on 10/24/19.
//  Copyright © 2019 Tyler Helmrich. All rights reserved.
//

import Foundation
import UIKit

class UserInfo: UIView {
    
    @IBOutlet var containingView: UIView!
    @IBOutlet weak var avatar: UIImageView!
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var joinDate: UILabel!
    @IBOutlet weak var followerCount: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var bio: UITextView!
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        commonInit();
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder);
        commonInit();
    }
    
    func commonInit() {
        super.awakeFromNib();
        Bundle.main.loadNibNamed("UserInfoView", owner: self, options: nil);
        addSubview(containingView);
        containingView.frame = self.bounds;
        containingView.autoresizingMask = [.flexibleHeight, .flexibleWidth];
    }
    
    public func setUserInfo(with userInfo: GitHubUser?) {
        guard let userInfo = userInfo else {
            return;
        }
        setAvatar(using: userInfo.avatarUrl);
        setDate(using: userInfo.joinDate);
        
        username.text = userInfo.username;
        email.text = userInfo.email ?? "No Email";
        location.text = userInfo.location ?? "No Location";
        followerCount.text = "\(userInfo.followerCount ?? 0) Followers";
        followingCount.text = "Following \(userInfo.followingCount ?? 0)";
    }
    
    private func setAvatar(using imagePath: String) {
        DispatchQueue.global().async { [weak self] in
            if let url = URL(string: imagePath), let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.avatar.image = image;
                    }
                }
            }
        }
    }
    
    private func setDate(using date: String?) {
        if let unformattedDate = date{
            let dateFormatter = DateFormatter();
            dateFormatter.dateStyle = .medium;
            dateFormatter.timeStyle = .none;
            let formattedDate = dateFormatter.date(from: unformattedDate);
            joinDate.text = dateFormatter.string(from: formattedDate!);
        }
    }
}
