//
//  ViewControllerConfigExtension.swift
//  wicconInterfaces
//
//  Created by Luis Fernando Perez on 21/03/18.
//  Copyright © 2018 Ricardo Coronado. All rights reserved.
//

import Foundation
import UIKit


extension ViewControllerConfig:PopUpMenuPlacaDelegate {
   
    func activarAP(result: Bool) {
        if result {
            showToast(message: "AP activado", objectClass: self)
        }
        else {
            showToast(message: "fallo en el proceso", objectClass: self)
        }
    }
    
    func desactivarAP(result: Bool) {
        if result {
            showToast(message: "AP desactivado", objectClass: self)
        }
        else {
            showToast(message: "fallo en el proceso", objectClass: self)
        }
    }
    
    func resetarPlaca(result: Bool) {
        print(result)
        if result {
            showToast(message: "placa reseteada", objectClass: self)
        }
        else {
            showToast(message: "fallo en el proceso", objectClass: self)
         }
        refresh()
    }
    
   
    func deletePlaca(placa: PlacaM) {
       
        if let placaData = getThisBoard(managedContext: managedContext, mac: placa.mac!){
                //borrar horarios
            for focoInPlaca in placaData.focos!{
                let currentFoco = focoInPlaca as! FocoData
                managedContext.delete(currentFoco)
            }
            managedContext.delete(placaData)
            saveContext(managedContext: managedContext)
        }
       
       collectionViewConfig.reloadData()
       
    }
    
    func compartirRed(placa: PlacaM) {
        self.performSegue(withIdentifier: "segueCheckConnection", sender: placa)
    } 

   

}

