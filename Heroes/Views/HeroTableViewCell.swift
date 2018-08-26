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

class HeroTableViewCell: UITableViewCell {

    @IBOutlet weak var cardWrapperView: CardWrapperView!
    
    func setValues(identifier: Int, name: String, imageUrl: String) {
        let url = URL(string: imageUrl)
        self.cardWrapperView.cardView.imageView.kf.setImage(with: url)
        self.cardWrapperView.cardView.titleLabel.text = name
        self.cardWrapperView.cardView.hero.id = "\(identifier)"
        self.hero.modifiers = [.source(heroID: "\(identifier)"), .spring(stiffness: 250, damping: 25)]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
