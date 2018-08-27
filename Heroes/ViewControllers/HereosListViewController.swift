//
//  HereosViewController.swift
//  Heroes
//
//  Created by Pietro Santececca on 25.08.18.
//  Copyright © 2018 Tecnojam. All rights reserved.
//

import UIKit
import Hero
import Lottie

class HereosListViewController: UIViewController {

    // Private properties
    private let reuseIdentifier = "HereosTableViewCell"
    private let segueIdentifier = "GoToHeroDetailView"
    private let rowHeight: CGFloat = 300
    private var downloading: Bool = false
    private var loadingView: LoadingView?
    private var filterName: String = ""
    
    // Public properties
    var hereos = [SuperHero]()
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var hereosTableView: UITableView!
    @IBOutlet weak var hereosTableTitle: UILabel! {
        didSet {
            hereosTableTitle.text = "Hereos"
        }
    }
    @IBOutlet weak var clearButton: UIButton! {
        didSet {
            self.clearButton.isHidden = true
        }
    }
    var count: Int {
        return hereos.count
    }
    
    // Methods
    @IBAction func clearNameFilter(_ sender: Any) {
        
        // Remove all the items in the list
        self.addLoadingView()
        self.hereos = []
        self.hereosTableView.reloadData()
        
        // Search for any hero
        self.filterName = ""
        loadNewHereos { [unowned self] in
            self.removeLoadingView()
            
            // Switch from search to clear
            self.clearButton.isHidden = true
            self.searchButton.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addLoadingView()
        self.subscribeToFilterObserver()
        loadNewHereos { [unowned self] in
            self.removeLoadingView()
        }
    }
    
    // Load data from marvel server and update the list with the new items
    func loadNewHereos(completionHandler: @escaping () -> Void) {
        DataManager.retrieveHeroes(offset: self.hereos.count, filter: self.filterName, completion: { [unowned self] newHereos in
            
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
            self.hereosTableView.insertRows(at: indexes,with: .none)
            completionHandler()
        })
    }
    
    // Function used to test Yoox server API, take a look at AppTVTests class
    func testLoadingNewHereos(completionHandler: @escaping () -> Void) {
        DataManager.retrieveHeroes() { [unowned self] newHereos in
            self.hereos.append(contentsOf: newHereos)
            completionHandler()
        }
    }
    
    func addLoadingView() {
        loadingView = LoadingView()
        self.view.addSubview(loadingView!)
        
        loadingView!.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = loadingView!.topAnchor.constraint(equalTo: self.view.topAnchor)
        let bottomConstraint = loadingView!.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        let leadingConstraint = loadingView!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        let trailingConstraint = loadingView!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        NSLayoutConstraint.activate([topConstraint, bottomConstraint, leadingConstraint, trailingConstraint])
    }
    
    func removeLoadingView() {
        loadingView?.removeFromSuperview()
    }
    
    func subscribeToFilterObserver() {
        let notificationName = NSNotification.Name(rawValue: "FilterSuperHereosList")
        NotificationCenter.default.addObserver(self, selector: #selector(filterHereosListByName(_:)), name: notificationName, object: nil)
    }
    
    // Filter data according to the name indicated by the user
    @objc func filterHereosListByName(_ notification: Notification) {
        if let heroName = notification.userInfo?["heroName"] as? String {
            
            // Remove all the items in the list
            self.addLoadingView()
            self.hereos = []
            self.hereosTableView.reloadData()
            
            // Search for the items that match with the name
            self.filterName = heroName
            loadNewHereos { [unowned self] in
                self.removeLoadingView()
                self.clearButton.isHidden = false
                self.searchButton.isHidden = true
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == segueIdentifier) {
            guard let cell = sender as? HeroesTableViewCell,
                let detailViewController = segue.destination as? HeroDetailViewController,
                let indexPath = self.hereosTableView.indexPath(for: cell) else {
                return
            }
            detailViewController.hero = hereos[indexPath.row]
        }
    }
}

// MARK: - TableView data source

extension HereosListViewController: UITableViewDataSource  {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let hero = self.hereos[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier) as! HeroesTableViewCell
        cell.setValues(identifier: hero.identifier, name: hero.name, imageUrl: hero.imageUrl)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.hereos.count
    }
    
}

// MARK: - TableView delegate

extension HereosListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.rowHeight
    }
}

// MARK: - ScrollView delegate

extension HereosListViewController : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        // If it's the table view bottom -> Load new items
        if !downloading && offsetY >= contentHeight - scrollView.frame.size.height {
            downloading = true
            self.loadNewHereos { [unowned self] in
                self.downloading = false
            }
        }
    }
    
}
