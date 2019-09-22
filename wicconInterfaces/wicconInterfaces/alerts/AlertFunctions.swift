//
//  AlertFunctions.swift
//  wicconInterfaces
//
//  Created by Luis Fernando Perez on 13/03/18.
//  Copyright © 2018 Ricardo Coronado. All rights reserved.
//

import Foundation
import UIKit

typealias  RespondeAlert = (_ resp:Bool)->Void
typealias  RespondeEditingString = (_ resp:String?)->Void

func createYesOrNotAlert(tittle:String, message: String, respondeAlert:@escaping RespondeAlert )->UIAlertController{
    let alert = UIAlertController(title: tittle, message: message, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "SI", style: UIAlertActionStyle.default, handler: { (action) in
        respondeAlert(true)
    }))
    alert.addAction(UIAlertAction(title: "NO", style: UIAlertActionStyle.cancel, handler: { (action) in
        respondeAlert(false)
    }))
    return alert
    
}

func createAdviseAlert(tittle:String, message: String)->UIAlertController{
    let alert = UIAlertController(title: tittle, message: message, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
        
    }))
    
    return alert
    
}

func createEditingNameAlert(tittle:String, message: String,initialName:String, RespondeEditingString:@escaping RespondeEditingString )->UIAlertController{
    
    var textFieldName:UITextField?
    
    let alert = UIAlertController(title: tittle, message: message, preferredStyle: UIAlertControllerStyle.alert)
    
    alert.addTextField { (textField) in
        textFieldName = textField
        textFieldName?.text = initialName
    }
    
    alert.addAction(UIAlertAction(title: "Guardar", style: UIAlertActionStyle.default, handler: { (action) in
        let responde = textFieldName?.text
        RespondeEditingString(responde)
    }))
    alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel, handler: { (action) in
        RespondeEditingString(nil)
    }))
   
    return alert
    
}

func alertEditOrNewPlaca( respondeAlert:@escaping RespondeAlert)-> UIAlertController{
    
    var alert = UIAlertController()
    alert = createYesOrNotAlert(tittle: "Esta placa ya esta agregada", message: "¿desea ir al menu de edicion?", respondeAlert: { (resp) in
        respondeAlert(resp)
    })
    return alert
}

func showToast(message : String, objectClass: AnyObject) {
    
    let toastLabel = UILabel(frame: CGRect(x: objectClass.self.view.frame.size.width/2 - 150, y: objectClass.self.view.frame.size.height-100, width: 300, height: 35))
    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    toastLabel.textColor = UIColor.white
    toastLabel.textAlignment = .center;
    toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds  =  true
    objectClass.self.view.addSubview(toastLabel)
    UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
        toastLabel.alpha = 0.0
    }, completion: {(isCompleted) in
        toastLabel.removeFromSuperview()
    })
}



