//
//  CollectionViewCell.swift
//  wicconInterfaces
//
//  Created by Luis Fernando Perez on 07/03/18.
//  Copyright © 2018 Ricardo Coronado. All rights reserved.
//

import UIKit

protocol CollectionViewCellDelegate: class {
    func didPressHeartButton(sender: Any)
}

class CollectionViewCell: UICollectionViewCell {
    
    
    weak var delegate: CollectionViewCellDelegate?
    
     var numOfRow:Int = 0
    
    @IBOutlet weak var imageConnectionIndicator: UIImageView!
    
    @IBOutlet weak var imageOnOff: UIImageView!
    
    @IBOutlet weak var nameOfOut: UILabel!
    
    @IBAction func alarmButton(_ sender: Any) {
        
        delegate?.didPressHeartButton(sender: numOfRow)
    }
    
}
