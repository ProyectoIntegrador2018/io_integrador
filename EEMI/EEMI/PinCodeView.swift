//
//  PinCodeView.swift
//  EEMI
//
//  Created by Jorge Elizondo on 2/19/19.
//  Copyright © 2019 Io Labs. All rights reserved.
//

import UIKit

protocol PinCodeDelegate {
    func didSelectButton(number: Int)
    func didSelectDelete()
}

@IBDesignable class PinCodeView: UIView {
    
    @IBOutlet var numberPadButtons: [UIButton]!
    @IBOutlet weak var pinFieldStackView: UIStackView!
    @IBOutlet weak var deleteButton: UIButton!
    
    var delegate: PinCodeDelegate!
    var pinToDraw = -1
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadFromNib()
        buttonsLayout()
        pinCodeFieldLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromNib()
        buttonsLayout()
        pinCodeFieldLayout()
    }
    
    func buttonsLayout() {
        for button in numberPadButtons {
            button.layer.cornerRadius = button.frame.height/2
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    func pinCodeFieldLayout() {
        let pinViews = pinFieldStackView.subviews
        for pinView in pinViews {
            pinFieldStackView.addArrangedSubview(pinView)
            pinView.layer.cornerRadius = pinView.frame.width/2
            pinView.layer.borderWidth = 1
            pinView.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    @IBAction func numberPadClick(_ sender: UIButton) {
        let buttonNumber = sender.tag
        delegate.didSelectButton(number: buttonNumber)
        
        let pinViews = pinFieldStackView.subviews
        pinToDraw += 1
        pinViews[pinToDraw].backgroundColor = .black
    }
    
    @IBAction func deleteButton(_ sender: UIButton) {
        delegate.didSelectDelete()

        let pinViews = pinFieldStackView.subviews
        pinViews[pinToDraw].backgroundColor = .clear
        pinToDraw -= 1
    }
}
