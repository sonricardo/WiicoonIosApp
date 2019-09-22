
//
//  FetchsFunctiom.swift
//  wicconInterfaces
//
//  Created by Luis Fernando Perez on 20/03/18.
//  Copyright © 2018 Ricardo Coronado. All rights reserved.
//

import Foundation
import CoreData

func getThisRed(managedContext : NSManagedObjectContext,ssid:String) ->Redes?{
   
    var red:Redes?
    let redFetch : NSFetchRequest<Redes> = Redes.fetchRequest()
    redFetch.predicate = NSPredicate(format: "%K == %@", #keyPath(Redes.ssid),ssid)
    do{
        let resultados = try managedContext.fetch(redFetch)
        if resultados.count>0{
            red = resultados.first
            
        }
        else{
            print("no se ha encontrado nunguna persona con ese nombre")
           
        }
        
    }catch let error as NSError {
        print("ocurrio un error \(error.localizedDescription)")
    }
    
    return red
}

func getThisFoco(managedContext : NSManagedObjectContext,mac:String, numSalida:Int) ->FocoData?{
    
    var placa:PlacaData?
    var foco:FocoData?
    
    let placaFetch : NSFetchRequest<PlacaData> = PlacaData.fetchRequest()
    placaFetch.predicate = NSPredicate(format: "%K == %@", #keyPath(PlacaData.mac),mac)
    do{
        let resultados = try managedContext.fetch(placaFetch)
        if resultados.count>0{
            placa = resultados.first
            for focoInPlaca in (placa?.focos)!{
                let currentFoco = focoInPlaca as! FocoData
                if currentFoco.out == Int32(numSalida) {
                    foco = currentFoco
                }
            }
        }
        else{
            print("no se ha encontrado nunguna persona con ese nombre")
            
        }
        
    }catch let error as NSError {
        print("ocurrio un error \(error.localizedDescription)")
    }
    
    return foco
}



func getThisBoard(managedContext : NSManagedObjectContext,mac:String) ->PlacaData?{
    
    var placa:PlacaData?
    let placaFetch : NSFetchRequest<PlacaData> = PlacaData.fetchRequest()
    placaFetch.predicate = NSPredicate(format: "%K == %@", #keyPath(PlacaData.mac),mac)
    do{
        let resultados = try managedContext.fetch(placaFetch)
        if resultados.count>0{
            placa = resultados.first
            
        }
        else{
            print("no se ha encontrado nunguna persona con ese nombre")
            
        }
        
    }catch let error as NSError {
        print("ocurrio un error \(error.localizedDescription)")
    }
    
    return placa
}

func getHorariosOfThisFoco(mac:String, numSalida:Int, managedContext : NSManagedObjectContext)->[Horario]?{
    var horarios = [Horario]()
    
    if let foco = getThisFoco(managedContext: managedContext, mac: mac, numSalida: numSalida){
        
        for horario in foco.horarios!{
            let currentHorario = horario as! Horario
            horarios.append(currentHorario)
        }
        return horarios
    }
    return nil
}
