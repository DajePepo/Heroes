//
//  HeroDetailViewController.swift
//  Heroes
//
//  Created by Pietro Santececca on 25.08.18.
//  Copyright © 2018 Tecnojam. All rights reserved.
//

import UIKit
import Kingfisher
import Hero

class HeroDetailViewController: UIViewController {
    
    var hero: SuperHero?

    @IBOutlet weak var cardView: CardView!
    @IBOutlet weak var heroDescription: UITextView!
    
    @IBAction func dismissDetailView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let hero = hero else { return }
        let url = URL(string: hero.imageUrl)
        self.cardView.hero.id = "\(hero.identifier!)"
        self.cardView.imageView.kf.setImage(with: url)
        self.cardView.titleLabel.text = hero.name
        self.heroDescription.text = hero.description
    }

}
