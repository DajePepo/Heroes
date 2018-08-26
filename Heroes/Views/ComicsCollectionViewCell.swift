//
//  CollectionViewCell.swift
//  Heroes
//
//  Created by Pietro Santececca on 26.08.18.
//  Copyright © 2018 Tecnojam. All rights reserved.
//

import UIKit
import Kingfisher

class ComicsCollectionViewCell: UICollectionViewCell {
    
    // Properties
    @IBOutlet weak var comicImageView: UIImageView!
    @IBOutlet weak var comicTitle: UILabel!
    
    // Mothods / Initializers
    func setValues(identifier: Int, title: String, imageUrl: String) {
        let url = URL(string: imageUrl)
        self.comicImageView.kf.setImage(with: url)
        self.comicTitle.text = title
    }
}
