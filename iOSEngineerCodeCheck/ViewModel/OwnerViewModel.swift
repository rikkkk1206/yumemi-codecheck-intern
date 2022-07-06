//
//  OwnerViewModel.swift
//  iOSEngineerCodeCheck
//
//  Created by RIKU on 2022/07/06.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation
import UIKit

class OwnerViewModel {
    func fetchOwnerIconImage(url: URL, completion: @escaping (UIImage) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            if let data = data, let ownerIconImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    // 画像の取得が完了したら返す
                    completion(ownerIconImage)
                }
            }
            if let err = err {
                fatalError("ERROR create a task to retrieve the owner icon: \(err)")
            }
        }.resume()
    }
}
