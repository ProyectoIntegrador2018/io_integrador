//
//  TableViewStateIndicator.swift
//  EEMI
//
//  Created by Jorge Elizondo on 2/26/19.
//  Copyright © 2019 Io Labs. All rights reserved.
//

import UIKit

@IBDesignable class StateIndicatorView: UIView {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionImage: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromNib()
    }
    
    func hide() {
        UIView.animate(withDuration: 0.2, animations: {self.alpha = 0.0},
                       completion: {(_) in
                        self.isHidden = true
        })
    }
    
    func show() {
        self.alpha = 0.0
        self.isHidden = false
        UIView.animate(withDuration: 0.2, animations: {self.alpha = 1},
                       completion: {(_) in
        })
    }
}
