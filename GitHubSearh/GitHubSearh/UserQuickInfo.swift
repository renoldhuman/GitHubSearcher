//
//  UserQuickInfo.swift
//  GitHubSearh
//
//  Created by Tyler Helmrich on 10/24/19.
//  Copyright © 2019 Tyler Helmrich. All rights reserved.
//

import Foundation
import UIKit

class UserQuickInfo : UIView {
    
    @IBOutlet var containingView: UIView!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var repoCount: UILabel!
    
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
        Bundle.main.loadNibNamed("UserQuickView", owner: self, options: nil);
        addSubview(containingView);
        containingView.frame = self.bounds;
        containingView.autoresizingMask = [.flexibleHeight, .flexibleWidth];
    }

}
