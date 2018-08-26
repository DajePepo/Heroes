//
//  HereosViewController.swift
//  Heroes
//
//  Created by Pietro Santececca on 25.08.18.
//  Copyright © 2018 Tecnojam. All rights reserved.
//

import UIKit
import Hero

class HereosViewController: UIViewController {

    // Private properties
    private var hereos = [SuperHero]()
    private let reuseIdentifier = "HeroTableCell"
    private let segueIdentifier = "GoToHeroDetailView"
    private let rowHeight: CGFloat = 300
    private var downloading: Bool = false
    
    
    // Public variables
    var count: Int {
        return hereos.count
    }
    
    @IBOutlet weak var hereosTableView: UITableView!
    @IBOutlet weak var hereosTableTitle: UILabel! {
        didSet {
            hereosTableTitle.text = "Hereos"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNewHereos {
            print("Hide loading!!!")
        }
    }

    // Load data from yoox server and update the collection with the new items
    func loadNewHereos(completionHandler: @escaping () -> Void) {
        HeroesDataManager.retrieveHeroes(offset: self.hereos.count, completion: { newHereos in
            
            // Increment the data source with the new items
            // and create an array of IndexPath
            let startIndex = self.hereos.count
            self.hereos.append(contentsOf: newHereos)
            let finalIndex = self.hereos.count
            var indexes = [IndexPath]()
            for i in startIndex ..< finalIndex {
                indexes.append(IndexPath(item: i, section: 0))
            }
            
            // Add the new items in the collection view using the IndexPath array
            self.hereosTableView.insertRows(at: indexes,with: .fade)
            completionHandler()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == segueIdentifier) {
            guard let cell = sender as? HeroTableViewCell,
                let detailViewController = segue.destination as? HeroDetailViewController,
                let indexPath = self.hereosTableView.indexPath(for: cell) else {
                return
            }
            
            detailViewController.hero = hereos[indexPath.row]
        }
    }
}

// MARK: - TableView data source

extension HereosViewController: UITableViewDataSource  {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let hero = self.hereos[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier) as! HeroTableViewCell
        cell.setValues(identifier: hero.identifier, name: hero.name, imageUrl: hero.imageUrl)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.hereos.count
    }
    
}

// MARK: - TableView delegate

extension HereosViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.rowHeight
    }
}

// MARK: - ScrollView delegate

extension HereosViewController : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        // If it's the table view bottom
        if !downloading && offsetY >= contentHeight - scrollView.frame.size.height {
            print("Show loading!!!")
            downloading = true
            self.loadNewHereos { [unowned self] in
                self.downloading = false
                print("Hide loading!!!")
            }
        }
    }
    
}
