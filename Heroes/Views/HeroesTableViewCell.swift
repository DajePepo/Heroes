//
//  HeroTableViewCell.swift
//  Heroes
//
//  Created by Pietro Santececca on 25.08.18.
//  Copyright © 2018 Tecnojam. All rights reserved.
//

import UIKit
import Kingfisher
import Hero

class HeroesTableViewCell: UITableViewCell {

    // Properties
    @IBOutlet weak var cardWrapperView: CardWrapperView!
    
    // Methods / Initializer
    func setValues(identifier: Int, name: String, imageUrl: String) {
        let url = URL(string: imageUrl)
        self.cardWrapperView.cardView.imageView.kf.setImage(with: url)
        self.cardWrapperView.cardView.titleLabel.text = name
        self.cardWrapperView.cardView.hero.id = "\(identifier)"
        self.hero.modifiers = [.source(heroID: "\(identifier)"), .spring(stiffness: 250, damping: 25)]
    }

}
