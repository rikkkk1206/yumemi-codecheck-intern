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
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var repositoryNameLabel: UILabel!
    
    @IBOutlet weak var languageLabel: UILabel!
    
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var watchersLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var issuesLabel: UILabel!
    
    private let ownerViewModel = OwnerViewModel()
    
    var repository: Repository!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        repositoryNameLabel.lineBreakMode = .byTruncatingTail
        
        repositoryNameLabel.text = repository.fullName
        languageLabel.text = "Written in \(repository.language)"
        starsLabel.text = "\(repository.stargazersCount) stars"
        watchersLabel.text = "\(repository.wachersCount) watchers"
        forksLabel.text = "\(repository.forksCount) forks"
        issuesLabel.text = "\(repository.openIssuesCount) open issues"
        setOwnerIconImage()
        updateFavoriteButtonState()
    }
    
    private func updateFavoriteButtonState() {
        if let favoriteRepository = FavoriteRepository.tryGetFavoriteRepository(repositoryId: repository.id), favoriteRepository.favorite {
            favoriteButton.setImage(UIImage(systemName: "star.fill"), for: UIControl.State())
        } else {
            favoriteButton.setImage(UIImage(systemName: "star"), for: UIControl.State())
        }
    }
    
    private func setOwnerIconImage() {
        let owner = repository.owner
        let avatarUrl = owner.avatarUrl
        if let url = URL(string: avatarUrl) {
            ownerViewModel.fetchOwnerIconImage(url: url, completion: { ownerIconImage in
                // 画像の取得を待ち合わせる
                self.ownerIconImageView.image = ownerIconImage
            })
        }
    }
    
    // MARK: Actions
    @IBAction func tapFavoriteButton(_ sender: Any) {
        if let favoriteRepository = FavoriteRepository.tryGetFavoriteRepository(repositoryId: repository.id) {
            FavoriteRepository.updateFavorite(id: favoriteRepository._id)
        } else {
            FavoriteRepository.upsert(id: nil, favorite: true, repository: repository)
        }
        updateFavoriteButtonState()
    }
}
