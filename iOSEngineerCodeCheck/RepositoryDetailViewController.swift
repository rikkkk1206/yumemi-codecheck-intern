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
    
    var searchRepositoryViewController: SearchRepositoryViewController!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let repository = searchRepositoryViewController.repositories[searchRepositoryViewController.currentIndex]
        
        languageLabel.text = "Written in \(repository["language"] as? String ?? "")"
        starsLabel.text = "\(repository["stargazers_count"] as? Int ?? 0) stars"
        watchersLabel.text = "\(repository["wachers_count"] as? Int ?? 0) watchers"
        forksLabel.text = "\(repository["forks_count"] as? Int ?? 0) forks"
        issuesLabel.text = "\(repository["open_issues_count"] as? Int ?? 0) open issues"
        getOwnerIconImage()
        
    }
    
    func getOwnerIconImage() {
        
        let repository = searchRepositoryViewController.repositories[searchRepositoryViewController.currentIndex]
        
        repositoryNameLabel.text = repository["full_name"] as? String
        
        if let owner = repository["owner"] as? [String: Any],
           let avatarUrl = owner["avatar_url"] as? String {
            URLSession.shared.dataTask(with: URL(string: avatarUrl)!) { (data, res, err) in
                let ownerIcon = UIImage(data: data!)!
                DispatchQueue.main.async {
                    self.ownerIconImageView.image = ownerIcon
                }
            }.resume()
        }
        
    }
    
}
