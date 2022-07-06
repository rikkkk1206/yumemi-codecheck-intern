//
//  Owner.swift
//  iOSEngineerCodeCheck
//
//  Created by RIKU on 2022/07/06.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

class Owner {
    let avatarUrl: String
    
    init() {
        avatarUrl = ""
    }
    
    init(owner: [String: Any]) {
        self.avatarUrl = owner["avatar_url"] as? String ?? ""
    }
}
