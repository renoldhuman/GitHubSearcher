//
//  RepositoryQuickView.swift
//  GitHubSearh
//
//  Created by Tyler Helmrich on 10/24/19.
//  Copyright © 2019 Tyler Helmrich. All rights reserved.
//

import Foundation
import UIKit

class RepositoryQuickInfo : UIView {
    @IBOutlet weak var containingView: UIView!
    @IBOutlet weak var repositoryName: UILabel!
    @IBOutlet weak var forkCount: UILabel!
    @IBOutlet weak var starCount: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        commonInit();
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder);
        commonInit();
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("RepositoryQuickView", owner: self, options: nil);
        addSubview(containingView);
        containingView.frame = self.bounds;
        containingView.autoresizingMask = [.flexibleHeight, .flexibleWidth];
    }
    
    public func setView(using repo: GitHubRepository) {
        repositoryName.text = repo.repositoryName;
        forkCount.text = "Forks: \(repo.forkCount ?? 0)";
        starCount.text = "Stars: \(repo.starCount ?? 0)";
    }
    
}
