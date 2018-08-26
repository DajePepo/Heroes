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
import Lottie

class HeroDetailViewController: UIViewController {
    
    // Private properties
    private let reuseIdentifier = "ComicsCollectionViewCell"
    private var hero: SuperHero?
    private var comics: [Comic] = []

    // Public properties
    @IBOutlet weak var cardView: CardView!
    @IBOutlet weak var heroDescription: UITextView!
    @IBOutlet weak var comicsCollectionContainer: UIView!
    @IBOutlet weak var comicsCollectionView: UICollectionView!
    @IBOutlet weak var comicsTitle: UILabel! {
        didSet {
            comicsTitle.text = "Comics"
        }
    }
    @IBOutlet weak var noComicsLabel: UILabel! {
        didSet {
            noComicsLabel.text = "There are not comics :("
            noComicsLabel.isHidden = true
        }
    }
    
    // Methods
    @IBAction func dismissDetailView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure subviews props
        guard let hero = hero else { return }
        let url = URL(string: hero.imageUrl)
        self.cardView.hero.id = "\(hero.identifier!)"
        self.cardView.imageView.kf.setImage(with: url)
        self.cardView.titleLabel.text = hero.name
        self.heroDescription.text = hero.description != "" ? hero.description : "No description"
        
        // Load hero's comics data
        self.loadComics { [unowned self] in
            
            // If there are no comics -> Show warning massage
            if(self.comics.count == 0) {
                UIView.animate(withDuration: 1, animations: {
                    self.noComicsLabel.isHidden = false
                    self.comicsCollectionContainer.isHidden = true
                })
            }
        }
    }
    
    // Load comics from marvel server and fill the collectin list with the downloaded items
    func loadComics(completionHandler: @escaping () -> Void) {
        guard let hero = self.hero else { return }
        DataManager.retrieveComics(heroId: hero.identifier, completion: { [unowned self] comics in
            self.comics = comics
            self.comicsCollectionView.reloadData()
            completionHandler()
        })
    }

}

// MARK: - UICollectionViewDataSource

extension HeroDetailViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: indexPath) as! ComicsCollectionViewCell
        let comic = comics[indexPath.row]
        cell.setValues(identifier: comic.identifier, title: comic.title, imageUrl: comic.imageUrl)
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comics.count
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HeroDetailViewController : UICollectionViewDelegateFlowLayout {
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 150)
    }
}

