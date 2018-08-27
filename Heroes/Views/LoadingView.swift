//
//  LoadingView.swift
//  Heroes
//
//  Created by Pietro Santececca on 26.08.18.
//  Copyright © 2018 Tecnojam. All rights reserved.
//

import Foundation
import UIKit
import Lottie

class LoadingView: UIView {
    
    // Properties
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var animationView: LOTAnimationView! {
        didSet {
            animationView.setAnimation(named: "loadingAnimationView")
            animationView.loopAnimation = true
            animationView.play()
        }
    }
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = "Loading"
        }
    }
    
    // Initializers
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        self.clipsToBounds = true
        Bundle.main.loadNibNamed("LoadingView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
