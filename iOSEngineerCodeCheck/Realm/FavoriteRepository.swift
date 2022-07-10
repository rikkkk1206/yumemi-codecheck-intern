//
//  FavoriteRepository.swift
//  iOSEngineerCodeCheck
//
//  Created by RIKU on 2022/07/09.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation
import RealmSwift

class FavoriteRepository: Object {
    @Persisted(primaryKey: true) var _id: ObjectId  // idを自動発行
    @Persisted var favorite: Bool = false   // お気に入りボタンのON/OFF
    // お気に入りしたリポジトリはRepositoryの内容を保持しておく
    @Persisted var repository_id: Int = 0   // repositoryのid
    @Persisted var full_name: String = ""
    @Persisted var language: String = ""
    @Persisted var stargazers_count: Int = 0
    @Persisted var wachers_count: Int = 0
    @Persisted var forks_count: Int = 0
    @Persisted var open_issues_count: Int = 0
    // Ownerの内容も保持
    @Persisted var owner_avatarUrl: String = ""
    
    // 同一realmオブジェクトが存在すれば更新、なければ追加してrealmオブジェクトを返す
    static func upsert(id: ObjectId?, favorite: Bool = false, repository: Repository) -> FavoriteRepository {
        let realm = try? Realm()
        let favoriteRepository: FavoriteRepository
        if let id = id {
            favoriteRepository = realm?.object(ofType: FavoriteRepository.self, forPrimaryKey: id) ?? FavoriteRepository()
        } else {
            favoriteRepository = FavoriteRepository()
        }
        
        try? realm?.write {
            favoriteRepository.favorite = favorite
            favoriteRepository.repository_id = repository.id
            favoriteRepository.full_name = repository.fullName
            favoriteRepository.language = repository.language
            favoriteRepository.stargazers_count = repository.stargazersCount
            favoriteRepository.wachers_count = repository.wachersCount
            favoriteRepository.forks_count = repository.forksCount
            favoriteRepository.open_issues_count = repository.openIssuesCount
            favoriteRepository.owner_avatarUrl = repository.owner.avatarUrl
            if id == nil {
                realm?.add(favoriteRepository)
            }
        }
        return favoriteRepository
    }
    
    // お気に入りボタンのON/OFF状態を更新
    static func updateFavorite(id: ObjectId) {
        let realm = try? Realm()
        let favoriteRepository = realm?.object(ofType: FavoriteRepository.self, forPrimaryKey: id)
        try? realm?.write {
            favoriteRepository?.favorite.toggle()   // お気に入りのON/OFFを反転
        }
    }
    
    // リポジトリのidから、該当する「お気に入り登録済みのリポジトリ」が存在すれば取得する
    static func tryGetFavoriteRepository(repositoryId: Int) -> FavoriteRepository? {
        let realm = try? Realm()
        let favoriteRepositories = realm?.objects(FavoriteRepository.self)
        let predicate = NSPredicate(format: "repository_id == %@", NSNumber(value: repositoryId))
        if let favoriteRepository = favoriteRepositories?.filter(predicate).first {
            return favoriteRepository
        }
        return nil
    }
    
    // 検索結果のリポジトリからお気に入り登録済みのリポジトリのみを絞り込む
    static func filterFavoriteRepositories(repositories: [Repository]) -> [Repository] {
        let realm = try? Realm()
        let favoriteRepositories = realm?.objects(FavoriteRepository.self)
        guard let filteredRepositories = favoriteRepositories?.filter({$0.favorite}) else {
            fatalError("ERROR filter favorite repositories")
        }
        return repositories.filter({ repository in
            filteredRepositories.contains(where: { $0.repository_id == repository.id})
        })
    }
}
