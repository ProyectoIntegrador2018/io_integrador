//
//  ActivityIndicatorView.swift
//  EEMI
//
//  Created by Jorge Elizondo on 2/17/19.
//  Copyright © 2019 Io Labs. All rights reserved.
//

import UIKit

class ActivityIndicatorView: UIView {
    
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityBoxView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromNib()
        activityBoxView.layer.cornerRadius = 2
        activityBoxView.addDropShadow()
        activityIndicator.startAnimating()
    }
    
    init(frame: CGRect, label: String) {
        super.init(frame: frame)
        loadFromNib()
        loadingLabel.text = label
        activityBoxView.layer.cornerRadius = 2
        activityBoxView.addDropShadow()
        activityIndicator.startAnimating()
    }
    
    func remove() {
        UIView.animate(withDuration: 0.2, animations: {self.alpha = 0.0},
                       completion: {(_) in
                        self.removeFromSuperview()
        })
    }
    
    func add(view: UIView) {
        self.alpha = 0.0
        view.addSubview(self)
        UIView.animate(withDuration: 0.2, animations: {self.alpha = 1},
                       completion: {(_) in
        })
    }
}
