//
//  CollectionViewCellHorarios.swift
//  wicconInterfaces
//
//  Created by Luis Fernando Perez on 26/03/18.
//  Copyright © 2018 Ricardo Coronado. All rights reserved.
//

import UIKit

protocol CollectionViewCellHorariosDelegate: class {
    func didPressDeleteButton(row: Int,indicatorCharge:UIActivityIndicatorView)
    func didPressActivateSwitch(state: Bool, row: Int,indicatorCharge:UIActivityIndicatorView, switchAct:UISwitch)
}

class CollectionViewCellHorarios: UICollectionViewCell {
    
    weak var delegate:CollectionViewCellHorariosDelegate?
    var position:Int?
    
    @IBOutlet weak var indicatorCharge: UIActivityIndicatorView!
    @IBOutlet weak var labelHora: UILabel!
    @IBOutlet weak var labelMinuto: UILabel!
    @IBOutlet weak var labelAccion: UILabel!
    @IBOutlet weak var labelRepetir: UILabel!
    @IBOutlet weak var switchActivate: UISwitch!
    @IBOutlet weak var labelDays: UILabel!
   
    
    @IBAction func switchChange(_ sender: Any) {
       
        delegate?.didPressActivateSwitch(state: switchActivate.isOn, row: self.position!, indicatorCharge: indicatorCharge, switchAct: switchActivate)
        
            }
    
   
    
    @IBAction func buttonDelete(_ sender: Any) {
        delegate?.didPressDeleteButton(row: position!, indicatorCharge: self.indicatorCharge)
    }
    
  
}
