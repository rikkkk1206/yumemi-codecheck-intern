//
//  SearchRepositoryTableViewCell.swift
//  iOSEngineerCodeCheck
//
//  Created by RIKU on 2022/07/09.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import UIKit

class SearchRepositoryTableViewCell: UITableViewCell {
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var repositoryTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
