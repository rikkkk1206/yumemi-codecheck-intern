//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class RepositoryDetailViewController: UIViewController {
    @IBOutlet weak var ownerIconImageView: UIImageView!
    
    @IBOutlet weak var repositoryNameLabel: UILabel!
    
    @IBOutlet weak var languageLabel: UILabel!
    
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var watchersLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var issuesLabel: UILabel!
    
    weak var searchRepositoryViewController: SearchRepositoryViewController!    // 循環参照を防ぐために弱参照する
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let repository = searchRepositoryViewController.repositories[searchRepositoryViewController.currentIndex]
        
        languageLabel.text = "Written in \(repository.language)"
        starsLabel.text = "\(repository.stargazersCount) stars"
        watchersLabel.text = "\(repository.wachersCount) watchers"
        forksLabel.text = "\(repository.forksCount) forks"
        issuesLabel.text = "\(repository.openIssuesCount) open issues"
        getOwnerIconImage()
    }
    
    func getOwnerIconImage() {
        let repository = searchRepositoryViewController.repositories[searchRepositoryViewController.currentIndex]
        
        repositoryNameLabel.text = repository.fullName
        
        let owner = repository.owner
        let avatarUrl = owner.avatarUrl
        if let url = URL(string: avatarUrl) {
            URLSession.shared.dataTask(with: url) { (data, res, err) in
                if let data = data, let ownerIcon = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.ownerIconImageView.image = ownerIcon
                    }
                }
                if let err = err {
                    fatalError("ERROR create a task to retrieve the owner icon: \(err)")
                }
            }.resume()
        }
    }
}
