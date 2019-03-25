//
//  SegmentedControlButton.swift
//  EEMI
//
//  Created by Jorge Elizondo on 3/25/19.
//  Copyright © 2019 Io Labs. All rights reserved.
//

import UIKit

@IBDesignable
class SegmentedControlButton: UIButton {
    
    var line = UIView()
    
    @IBInspectable var titleText: String? {
        didSet {
            self.setTitle(titleText, for: .normal)
        }
    }
    
    @IBInspectable var lineColor: UIColor? {
        didSet {
            self.line.backgroundColor = lineColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
         line = UIView(frame: CGRect(x: 0, y: self.frame.height-1, width: self.frame.width, height: 2))
         line.backgroundColor = lineColor ?? .lightGray
         self.addSubview(line)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
         line = UIView(frame: CGRect(x: 0, y: self.frame.height-1, width: self.frame.width, height: 2))
         line.backgroundColor = lineColor ?? .lightGray
         self.addSubview(line)
    }
        
    func selected() {
        self.line.backgroundColor = ColorPallet.primaryColor
        self.setTitleColor(ColorPallet.primaryColor, for: .normal)
        
    }
    
    func unselected() {
        self.line.backgroundColor = UIColor.lightGray
        self.setTitleColor(.lightGray, for: .normal)
    }

}
