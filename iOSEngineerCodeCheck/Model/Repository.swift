//
//  Repository.swift
//  iOSEngineerCodeCheck
//
//  Created by RIKU on 2022/07/06.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation
import RealmSwift

class Repository {
    let id: Int
    let fullName: String
    let language: String
    let stargazersCount: Int
    let wachersCount: Int
    let forksCount: Int
    let openIssuesCount: Int
    let owner: Owner
    
    init() {
        id = 0
        fullName = ""
        language = ""
        stargazersCount = 0
        wachersCount = 0
        forksCount = 0
        openIssuesCount = 0
        owner = Owner()
    }
    
    init(json: [String: Any]) {
        id = json["id"] as? Int ?? 0
        fullName = json["full_name"] as? String ?? ""
        language = json["language"] as? String ?? ""
        stargazersCount = json["stargazers_count"] as? Int ?? 0
        wachersCount = json["wachers_count"] as? Int ?? 0
        forksCount = json["forks_count"] as? Int ?? 0
        openIssuesCount = json["open_issues_count"] as? Int ?? 0
        let owner = json["owner"] as? [String: Any] ?? [:]
        self.owner = Owner(owner: owner)
    }
}
