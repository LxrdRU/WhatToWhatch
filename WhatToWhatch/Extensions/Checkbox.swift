//
//  Checkbox.swift
//  MovieApp
//
//  Created by Andrey Markov on 2021-06-07.
//

import UIKit

class Checkbox: UIButton {
    // Images
    let checkedImage = UIImage(named: "checkmark.rectangle")
    let uncheckedImage = UIImage(named: "rectangle")
    
    // Bool property
    var isChecked: Bool = false {
        didSet {
            if isChecked == true {
                self.setImage(checkedImage, for: UIControl.State.normal)
            } else {
                self.setImage(uncheckedImage, for: UIControl.State.normal)
            }
        }
    }
        
    override func awakeFromNib() {
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        self.isChecked = false
    }
        
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}
