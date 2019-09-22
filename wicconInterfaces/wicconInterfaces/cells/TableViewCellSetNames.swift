//
//  TableViewCellSetNames.swift
//  wicconInterfaces
//
//  Created by Luis Fernando Perez on 13/03/18.
//  Copyright © 2018 Ricardo Coronado. All rights reserved.
//

import UIKit
protocol TableCellSetNameDelegate: class {
    func didButtonTest(sender: Int)
    func didSwitchChange(state:Bool,position:Int)
    func hasNewName(name:String,position:Int)
}
class TableViewCellSetNames: UITableViewCell {

    weak var delegate : TableCellSetNameDelegate?
    
    var position:Int?
   
    
    @IBOutlet weak var textFieldName: UITextField!
    
    @IBOutlet weak var switchActivateOut: UISwitch!
    
    @IBOutlet weak var buttonTest: UIButton!
    
    
    @IBAction func switchAction(_ sender: Any) {
        
        if(!textFieldName.text!.isEmpty){
            delegate?.didSwitchChange(state: switchActivateOut.isOn, position: position!)
            delegate?.hasNewName(name: textFieldName.text!, position: position!)
        }else{
            switchActivateOut.setOn(false, animated: true)
            delegate?.didSwitchChange(state: switchActivateOut.isOn, position: position!)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       
        textFieldName.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        buttonTest.layer.cornerRadius =  0.5 * buttonTest.bounds.size.width
        buttonTest.clipsToBounds = true
         }

    @IBAction func buttonTestAction(_ sender: Any) {
        delegate?.didButtonTest(sender: position!)
    }
    
    
    @IBAction func textFieldAction(_ sender: Any) {  //se activa cuando deSeleccionas el textField
       
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textFieldName.text!.isEmpty{
            switchActivateOut.setOn(false, animated: true)
            delegate?.didSwitchChange(state: switchActivateOut.isOn, position: position!)
        }
        else{
            delegate?.hasNewName(name: textFieldName.text!, position: position!)
            if !switchActivateOut.isOn {
                switchActivateOut.setOn(true, animated: true)
                delegate?.didSwitchChange(state: switchActivateOut.isOn, position: position!)
                
            }
        }
        
    }
    
}
