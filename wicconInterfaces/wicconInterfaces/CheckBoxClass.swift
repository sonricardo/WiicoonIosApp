//
//  CheckBoxClass.swift
//  wicconInterfaces
//
//  Created by Luis Fernando Perez on 27/03/18.
//  Copyright © 2018 Ricardo Coronado. All rights reserved.
//

import Foundation
import UIKit

class CheckBox: UIButton {
    // Images
    let checkedImage = UIImage(named: "checkedBox")! as UIImage
    let uncheckedImage = UIImage(named: "uncheckedBox")! as UIImage
    
    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(checkedImage, for: UIControlState.normal)
               self.setBackgroundImage(checkedImage, for:  UIControlState.normal)
                
            } else {
                self.setImage(uncheckedImage, for: UIControlState.normal)
                self.setBackgroundImage(uncheckedImage, for:  UIControlState.normal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControlEvents.touchUpInside)
         
        self.isChecked = false
    }
    
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}
