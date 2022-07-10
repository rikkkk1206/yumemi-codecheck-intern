//
//  SearchRepositoryViewModel.swift
//  iOSEngineerCodeCheck
//
//  Created by RIKU on 2022/07/06.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

class SearchRepositoryViewModel {
    // 値の変化を検知して適宜リロード処理を書く
    var repositories: [Repository] = [] {
        didSet {
            reloadHandler()
        }
    }
    
    var reloadHandler: () -> Void = {}
    
    func fetchRepositories(url: URL) -> URLSessionTask {
        // GitHubにアクセスするタスクを生成
        let task: URLSessionTask = URLSession.shared.dataTask(with: url) { (data, res, err) in
            if let data = data {
                do {
                    let object = try JSONSerialization.jsonObject(with: data)
                    if let object = object as? [String: Any],
                       let items = object["items"] as? [[String: Any]] {
                        // 検索結果から該当するリポジトリを取得
                        let repositories = items.map { (json: [String: Any]) -> Repository in
                            return Repository(json: json)
                        }
                        DispatchQueue.main.async {
                            self.repositories = repositories
                        }
                    }
                } catch {
                    fatalError("ERROR get JSON object: \(error)")
                }
            }
            if let err = err {
                fatalError("ERROR create a task to access GitHub: \(err)")
            }
        }
        // これ呼ばなきゃリストが更新されません
        task.resume()
        
        return task
    }
}
