//
//  PlacaModel.swift
//  wicconInterfaces
//
//  Created by Luis Fernando Perez on 09/03/18.
//  Copyright © 2018 Ricardo Coronado. All rights reserved.
//

import Foundation
import UIKit

 public enum StatusConnection {
    case DISABLE
    case ACCESS_POINT
    case LAN
    case INT_REMOTE
}

public var REPEAT_EACH_WEEK:Int64 = 0
public var REPEAT_ONCE:Int64 = 1

public var TYPE_TURN_OFF:Int64 = 0
public var TYPE_TURN_ON:Int64 = 1

class PlacaModel {
    
    let mac:String?
    let numSal:Int?
    var nameFocos:[String]?
    
    init(mac:String, numSal: Int, names:[String]){
        self.mac = mac
        self.numSal = numSal
        nameFocos = names
    }
}

class PlacaM{
        
    let mac:String?
    let numSalidas:Int?
    var ip: String? = nil
    var focos = [FocoM]()
    var statusConnection = StatusConnection.DISABLE
        
 
    init(mac:String,numSalidas:Int){
        self.mac = mac
        self.numSalidas = numSalidas
    }
    func agregarFoco(foco:FocoM){
            self.focos.append(foco)
    }
        
}
func getBoardByMac(mac:String,placas:[PlacaM])->PlacaM?{
    for placa in placas {
        if(placa.mac == mac){
            return placa
        }
    }
    return nil
}

func getFocoByMacAndOut (mac:String,out:Int,placas:[PlacaM])->FocoM? {
    for placa in placas {
        if(placa.mac == mac){
            for foco in placa.focos{
                if(foco.salida == out){
                    return foco
                }
            }
        }
    }
    return nil
}

func getFocosByMac (mac:String, placas: [PlacaM])->[FocoM]? {
    
    for placa in placas {
        if(placa.mac == mac){
            return placa.focos
        }
    }
    return nil
}

class FocoM{
        
        let salida:Int?
        var estado = 0
        var isActivate = false
        var nombre:String = ""
        init(salida:Int) {
            self.salida = salida
            nombre = "foco_\(salida)"
        }
    
    }
    class FocoListM:FocoM {
        let mac:String?
        var statusConnect = StatusConnection.DISABLE
        var ip:String? = nil
        init(mac:String,salida:Int){
            self.mac = mac
            super.init(salida: salida)
            
        }
    }

    class SSIDOfPlaca {
       
        let nombre:String?
        let RSSI:Int?
        var calidad:String?
            
        init(nombre:String,RSSI:Int) {
            self.nombre = nombre
            self.RSSI = RSSI
            self.getCalidad(RSSI: RSSI)
        }
        func getCalidad(RSSI:Int){
            if RSSI > -60{
                self.calidad = "Exelente"
            }
            if RSSI <= -60 && RSSI > -75 {
                self.calidad = "Buena"
            }
            if RSSI <= -75 && RSSI > -90 {
                self.calidad = "Regular"
            }
            if RSSI <= -90 {
                self.calidad = "Mala"
            }
        }
    }

