//
//  FilterViewController.swift
//  Heroes
//
//  Created by Pietro Santececca on 26.08.18.
//  Copyright © 2018 Tecnojam. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {

    // Properties
    @IBOutlet weak var searchButton: UIButton! {
        didSet {
            searchButton.layer.cornerRadius = 16
            searchButton.isEnabled = false
            searchButton.clipsToBounds = true
        }
    }
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
    }
    
    // Methods
    @IBAction func dismissFilterView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissAndSearch(_ sender: Any) {
        guard let heroName = self.textField.text else { return }
        let notificationName = NSNotification.Name(rawValue: "FilterSuperHereosList")
        NotificationCenter.default.post(name: notificationName, object: self, userInfo: ["heroName" : heroName])
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        searchButton.isEnabled = !(textField.text == "")
    }
}
