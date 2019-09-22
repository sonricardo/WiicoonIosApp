//
//  RequestFunctions.swift
//  wicconInterfaces
//
//  Created by Luis Fernando Perez on 12/03/18.
//  Copyright © 2018 Ricardo Coronado. All rights reserved.
//

import Foundation
import UIKit

public let IP_SERVIDOR = "iotcontrol.ddns.net/api"
typealias respuestaPlaca = ( _ datos: PlacaM?, _ mac:String) -> Void
typealias respuestaNewHorario = ( _ id: Int?, _ mac:String?,_ macTarget:String) -> Void
typealias respuestaWithTarget = ( _ datos: PlacaM?, _ mac:String, _ macTarget:String) -> Void
typealias respuestaListaRedes = ( _ listaRedes: [SSIDOfPlaca]?, _ success:Bool) -> Void

func httpRequestDataInfo(ip:String?, respuesta: @escaping respuestaPlaca){
   
    let ipRequest = getIp(ip:ip)
    let urlCompleto = "http://\(ipRequest)/data_info"
    let objetoUrl = URL(string:urlCompleto)
    let urlRequest = URLRequest(url: objetoUrl!, timeoutInterval: 3.0)

    let tarea = URLSession.shared.dataTask(with: urlRequest) {(datos, resp, error) in
        
        if(datos != nil){
        guard let placa = getPlacaWithJson(datos: datos!)
            else{
                respuesta(nil,"error")
                return
            }
        respuesta(placa,placa.mac!)
        }
        else{
           respuesta(nil,"error")
        }
    }
    tarea.resume()
}

func httpRequestResetBoard(ip:String?,macTarget: String, respuesta: @escaping respuestaWithTarget){
    
    let ipRequest = getIp(ip:ip)
    let urlCompleto = "http://\(ipRequest)/data_reset"
    let objetoUrl = URL(string:urlCompleto)
   
    
    let tarea = URLSession.shared.dataTask(with: objetoUrl!) {(datos, resp, error) in
        
        if(datos != nil){
            guard let placa = getPlacaWithJson(datos: datos!)
                else{
                    respuesta(nil,"error",macTarget)
                    return
            }
            respuesta(placa,placa.mac!,macTarget)
        }
        else{
            respuesta(nil,"error",macTarget)
        }
    }
    
    tarea.resume()
}

func httpRequestActivarAP(ip:String?,macTarget: String, estado:Int, respuesta: @escaping respuestaWithTarget){
    
    let ipRequest = getIp(ip:ip)
    let urlCompleto = "http://\(ipRequest)/ap_config?estado=\(estado)"
    let objetoUrl = URL(string:urlCompleto)
    
    let tarea = URLSession.shared.dataTask(with: objetoUrl!) {(datos, resp, error) in
        
        if(datos != nil){
            guard let placa = getPlacaWithJson(datos: datos!)
                else{
                    respuesta(nil,"error",macTarget)
                    return
            }
            respuesta(placa,placa.mac!,macTarget)
        }
        else{
            respuesta(nil,"error",macTarget)
        }
    }
    
    tarea.resume()
}

func httpRequestShareRed(ip:String?,ssid:String ,password:String,respuesta: @escaping respuestaPlaca){
    
    let ipRequest = getIp(ip:ip)
    let urlCompleto = "http://\(ipRequest)/config?ssid=\(ssid)&pass=\(password)"
    let objetoUrl = URL(string:urlCompleto)
    let tarea = URLSession.shared.dataTask(with: objetoUrl!) {(datos, resp, error) in
        
        if(datos != nil){
            guard let placa = getPlacaWithJson(datos: datos!)
                else{
                    respuesta(nil,"error")
                    return
            }
            respuesta(placa,placa.mac!)
        }
        else{
            respuesta(nil,"error")
        }
    }
    tarea.resume()
}

func httpRequestRefresh(ip:String?,macTarget: String, respuesta: @escaping respuestaWithTarget){
    
    let ipRequest = getIp(ip:ip)
    let urlCompleto = "http://\(ipRequest)/data_info?mac=\(macTarget)"
    let objetoUrl = URL(string:urlCompleto)
    let urlRequest = URLRequest(url: objetoUrl!, timeoutInterval: 5.0)
    
    
    let tarea = URLSession.shared.dataTask(with: urlRequest) {(datos, resp, error) in
        
        if(datos != nil){
            
            guard let placa = getPlacaWithJson(datos: datos!)
                else{
                    respuesta(nil,"error",macTarget)
                    return
            }
            respuesta(placa,placa.mac!,macTarget)
        }
        else{
            respuesta(nil,"error",macTarget)
        }
    }
    
    tarea.resume()
}

func httpRequestCreateHorario(ip:String?,macTarget: String, codeWeek:Int, hora: Int, minuto:Int, numSalida:Int, typeTurn: Int, isRepetitive: Int,   respuesta: @escaping respuestaNewHorario){
    
    let ipRequest = getIp(ip:ip)
    let urlCompleto = "http://\(ipRequest)/alarma_config?hora=\(hora)&min=\(minuto)&dia=\(codeWeek)&foco=\(numSalida)&estado=\(typeTurn)&rep=\(isRepetitive)&mac=\(macTarget)"
    let objetoUrl = URL(string:urlCompleto)
    let urlRequest = URLRequest(url: objetoUrl!, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 2.0)
    
    let tarea = URLSession.shared.dataTask(with: urlRequest) {(datos, resp, error) in
        
        if(datos != nil){
            guard let id = getIdHorarioWithJson(datos: datos!)
                else{
                    respuesta(nil,nil,macTarget)
                    return
            }
            guard let mac = getMacWithJson(datos: datos!)
                else{
                    respuesta(nil,nil,macTarget)
                    return
            }
            respuesta(id,mac,macTarget)
        }
        else{
            respuesta(nil,nil,macTarget)
        }
    }
    
    tarea.resume()
}

func httpRequestShareTime(ip:String?,macTarget: String, año: Int, mes: Int, dia:Int, hora: Int, minuto: Int, segundo: Int,   respuesta: @escaping respuestaWithTarget){
    
    let ipRequest = getIp(ip:ip)
    let urlCompleto = "http://\(ipRequest)/time_config?hora=\(hora)&min=\(minuto)&seg=\(segundo)&dia=\(dia)&mes=\(mes)&ano=\(año)&mac=\(macTarget)"
    let objetoUrl = URL(string:urlCompleto)
    let urlRequest = URLRequest(url: objetoUrl!, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 2.0)
    
    let tarea = URLSession.shared.dataTask(with: urlRequest) {(datos, resp, error) in
        
        if(datos != nil){
            guard let placa = getPlacaWithJson(datos: datos!)
                else{
                    respuesta(nil,"error",macTarget)
                    return
            }
            respuesta(placa,placa.mac!,macTarget)
        }
        else{
            respuesta(nil,"error",macTarget)
        }
    }
    
    tarea.resume()
}

func httpRequestDeleteHorario(ip:String?,macTarget: String,idHorario:Int, respuesta: @escaping respuestaWithTarget){
    
    let ipRequest = getIp(ip:ip)
    let urlCompleto = "http://\(ipRequest)/alarma_borrar?id=\(idHorario)"
    let objetoUrl = URL(string:urlCompleto)
    let urlRequest = URLRequest(url: objetoUrl!, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 2.0)
    
    let tarea = URLSession.shared.dataTask(with: urlRequest) {(datos, resp, error) in
        
        if(datos != nil){
            guard let placa = getPlacaWithJson(datos: datos!)
                else{
                    respuesta(nil,"error",macTarget)
                    return
            }
            respuesta(placa,placa.mac!,macTarget)
        }
        else{
            respuesta(nil,"error",macTarget)
        }
    }
    
    tarea.resume()
}


func httpRequestCommand(ip:String?,out:Int,state:Int,mac:String, respuesta: @escaping respuestaPlaca){
    
    let ipRequest = getIp(ip:ip)
    let urlCompleto = "http://\(ipRequest)/foco_control?foco=\(out)&estado=\(state)&mac=\(mac)"
    let objetoUrl = URL(string:urlCompleto)
    let tarea = URLSession.shared.dataTask(with: objetoUrl!) {(datos, resp, error) in
        
        if(datos != nil){
            guard let placa = getPlacaWithJson(datos: datos!)
                else{
                    respuesta(nil,"error")
                    return
            }
            respuesta(placa,placa.mac!)
        }
        else{
            respuesta(nil,"error")
        }
    }
    tarea.resume()
}

func httpRequestScanRedes(ip:String?, macTarget:String, respuesta: @escaping respuestaListaRedes){
    
    let ipRequest = getIp(ip:ip)
    let urlCompleto = "http://\(ipRequest)/scan_redes"
    let objetoUrl = URL(string:urlCompleto)
    let urlRequest = URLRequest(url: objetoUrl!, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 5.0)
   
    let tarea = URLSession.shared.dataTask(with: urlRequest) {(datos, resp, error) in
   
        if(datos != nil){
            guard let listaRedes = getSSIDListWhithJson(datos: datos!)
                else{
                    respuesta(nil,false)
                    return
            }
            respuesta(listaRedes,true)
        }
        else{
            respuesta(nil,false)
        }
    }
    tarea.resume()
}

func httpRequestGetRedes(ip:String?, macTarget:String, respuesta: @escaping respuestaListaRedes){
    
    let ipRequest = getIp(ip:ip)
    let urlCompleto = "http://\(ipRequest)/get_redes"
    let objetoUrl = URL(string:urlCompleto)
    let tarea = URLSession.shared.dataTask(with: objetoUrl!) {(datos, resp, error) in
        
        if(datos != nil){
            guard let listaRedes = getSSIDListWhithJson(datos: datos!)
                else{
                    respuesta(nil,false)
                    return
            }
            respuesta(listaRedes,true)
        }
        else{
            respuesta(nil,false)
        }
    }
    tarea.resume()
}


func getIp(ip:String?)->String {
    
    var ipHttp = "192.168.4.1"
    if ip != nil {
        ipHttp = ip!
    }
   return ipHttp
}


func getPlacaWithJson(datos:Data)->PlacaM?{
    
    do{
      
        let json = try JSONSerialization.jsonObject(with: datos, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:Any]
        
        if  json["macAddress"] == nil{
            return nil
        }
        var focosFinal = [FocoM]()
        let focosPart = json["focos"] as! [[String:Any]]
        
        if focosPart.count > 0{
            for i in 0...focosPart.count-1{
                
                let foco:FocoM = FocoM(salida: focosPart[i]["numDeSalida"] as! Int )
                foco.estado = focosPart[i]["estado"] as! Int
                focosFinal.append(foco)
            }
        }
        var numSalidas:Int?
        
        if let numS = json["numSalidas"] as? Int {
            numSalidas = numS
        }
        else if let numS = json["numSalidas"] as? String {
            numSalidas = Int(numS)
        }
        
        let placa:PlacaM = PlacaM(mac: json["macAddress"] as! String, numSalidas: numSalidas! )
            placa.ip = json["ipAddress"] as? String
            placa.focos = focosFinal
        
        return placa
        
    }
    catch {
        print("El Procesamiento del JSON tuvo un error")
        return nil
        
    }
}

func getIdHorarioWithJson(datos:Data)->Int?{
    
    do{
        let json = try JSONSerialization.jsonObject(with: datos, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:Any]
      
        let idHorario = json["id"] as! Int
        return idHorario
    }
    catch {
        print("El Procesamiento del JSON tuvo un error")
        return nil
    }
}

func getMacWithJson(datos:Data)->String?{
    
    do{
        let json = try JSONSerialization.jsonObject(with: datos, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:Any]
        
        let mac = json["macAddress"] as! String
        
        return mac
    }
    catch {
        print("El Procesamiento del JSON tuvo un error")
        return nil
        
    }
}
func getSSIDListWhithJson(datos:Data)->[SSIDOfPlaca]?{
    
    do{
        
        let json = try JSONSerialization.jsonObject(with: datos, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:Any]
        
        let redes = json["redes"] as! [[String:Any]]
        var redesFinal = [SSIDOfPlaca]()
        
        for i in 0...redes.count-1{
            
            let ssid:SSIDOfPlaca = SSIDOfPlaca(nombre: redes[i]["SSID"] as! String, RSSI: redes[i]["RSSI"] as! Int)
            redesFinal.append(ssid)
        }
        
        return redesFinal
        
    }
    catch {
        print("El Procesamiento del JSON tuvo un error")
        return nil
        }
}
