//
//  ViewControllerExtensionMenus.swift
//  wicconInterfaces
//
//  Created by Luis Fernando Perez on 21/03/18.
//  Copyright © 2018 Ricardo Coronado. All rights reserved.
//

import Foundation


extension ViewController: PopUpMenuFocoDelegate {
    
    
    func changeName(newName: String, foco: FocoListM) {
        if let focoData = getThisFoco(managedContext: managedContext, mac: foco.mac!, numSalida: foco.salida!){
            focoData.name = newName
            saveContext(managedContext: managedContext)
        }
    }
    
    func desactivateFoco(foco: FocoListM) {
        if let focoData = getThisFoco(managedContext: managedContext, mac: foco.mac!, numSalida: foco.salida!){
            focoData.isActivate = false
            saveContext(managedContext: managedContext)
        }
    }
    
}
