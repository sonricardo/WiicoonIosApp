//
//  ViewControllerHorarios.swift
//  wicconInterfaces
//
//  Created by Luis Fernando Perez on 26/03/18.
//  Copyright © 2018 Ricardo Coronado. All rights reserved.
//

import UIKit
import CoreData

class ViewControllerHorarios: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, CollectionViewCellHorariosDelegate  {
    
    
    
   
    
    @IBOutlet weak var collectionViewHorarioa: UICollectionView!
    
    let app = UIApplication.shared.delegate as! AppDelegate
    var managedContext: NSManagedObjectContext!
    var horariosData = [Horario]()
    var focoList:FocoListM?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        managedContext = app.coreDataStack.managedContext
        loadHorarios()
        
         collectionViewHorarioa.delegate = self
         collectionViewHorarioa.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadHorarios()
        collectionViewHorarioa.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let screen = UIScreen.main.bounds
    let originalHeight = 150
    let width = (screen.width)*1-20
    let heith = CGFloat(originalHeight)
    
    return CGSize(width: width, height: heith)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 2, left: 1, bottom: 0, right: 1)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
            return horariosData.count + 1
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellAddNewHorario", for: indexPath)
            return cell
        }
        else{
            let currentHorario = horariosData[indexPath.row - 1]
            
            if currentHorario.isActivate && currentHorario.isRepetitive == REPEAT_ONCE {
                let currentDate = Date()
                if currentDate.compare(currentHorario.dateBreak! as Date).rawValue > 0 {
                    currentHorario.isActivate = false
                    saveContext(managedContext: managedContext)
                }
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellHorario", for: indexPath) as! CollectionViewCellHorarios
            cell.delegate = self
            cell.indicatorCharge.isHidden = true
            cell.position = indexPath.row
            if horariosData[indexPath.row - 1].hora < 10 {
                 cell.labelHora.text = "0"+String(currentHorario.hora)
            }
            else {
                 cell.labelHora.text = String(currentHorario.hora)
            }
           
            if horariosData[indexPath.row - 1].minuto < 10 {
                cell.labelMinuto.text = "0"+String(currentHorario.minuto)
            }
            else {
                cell.labelMinuto.text = String(currentHorario.minuto)
            }
            
            if (horariosData[indexPath.row - 1].dia == REPEAT_EACH_WEEK){
                cell.labelRepetir.text = "SI"
            }else{
                cell.labelRepetir.text = "NO"
            }
            cell.switchActivate.setOn( currentHorario.isActivate,animated: false )
            if (horariosData[indexPath.row - 1].typeTurn == 1){
                cell.labelAccion.text = " ON"
                cell.labelAccion.backgroundColor = UIColor(red: 0, green: 0.5, blue: 0, alpha: 0.5)
            }else {
                cell.labelAccion.text = " OFF"
                cell.labelAccion.backgroundColor = UIColor(red: 0.5, green: 0, blue: 0, alpha: 0.8)
            }
            cell.labelDays.text = getStringDaysWithCodeWeekDays(codeWeek: horariosData[indexPath.row - 1].daysWeekCode)
            
            return cell
            
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       if focoList?.statusConnect != StatusConnection.DISABLE{
            if indexPath.row == 0 {
                self.performSegue(withIdentifier: "segueToMakeHorario", sender: nil)
            }
            else{
                self.performSegue(withIdentifier: "segueToMakeHorario", sender: indexPath.row)
            }
       }
        else{
            let alert = createAdviseAlert(tittle: "NO SE PUEDE REALIZAR ESTA ACCION", message: "el estatus de la placa es desconectada, no se puede agregar ni modificar horarios en este estatus")
            self.present(alert, animated: true)
        }
    }
    
    func didPressDeleteButton(row: Int, indicatorCharge: UIActivityIndicatorView) {
        indicartorChargeState(indicator: indicatorCharge)
        if focoList?.statusConnect == StatusConnection.DISABLE {
            let alert = createAdviseAlert(tittle: "NO SE PUEDE REALIZAR ESTA ACCION", message: "El status de conexion de la placa no permite realizar esta accion, regrese al menu principal y asegurese que la barra de conexion permita conexion con la placa")
            self.present(alert, animated: true)
           indicartorOffState(indicator: indicatorCharge)
        }
        else {
            tryToDelete(idHorario: Int(horariosData[row - 1].id),horario: horariosData[row - 1], indicator:indicatorCharge)
        }
    }
    
    func didPressActivateSwitch(state: Bool, row: Int,indicatorCharge: UIActivityIndicatorView,switchAct: UISwitch) {
        
        
        indicartorChargeState(indicator: indicatorCharge)
        horariosData[row - 1].isActivate = !state
       
        if focoList?.statusConnect == StatusConnection.DISABLE {
            let alert = createAdviseAlert(tittle: "NO SE PUEDE REALIZAR ESTA ACCION", message: "El status de conexion de la placa no permite realizar esta accion, regrese al menu principal y asegurese que la barra de conexion permita conexion con la placa")
            self.present(alert, animated: true)
            indicartorOffState(indicator: indicatorCharge)
            
        }
        else {
           
            if state == false {
                tryToDesActivate(idHorario: Int(horariosData[row - 1].id),horario: horariosData[row - 1], indicator: indicatorCharge)
            }
            else{
                tryToActivate(horario: horariosData[row - 1],indicator: indicatorCharge)
            }
        }
    }
    
    func tryToDelete(idHorario:Int,horario:Horario, indicator: UIActivityIndicatorView){
        let ip = getIpForRequest(focoList: self.focoList!)
        httpRequestDeleteHorario(ip: ip, macTarget: (focoList?.mac!)!, idHorario: idHorario){(placa,mac,macTarget) in
            DispatchQueue.main.sync(execute: {
                self.indicartorOffState(indicator: indicator)
                if placa != nil {
                    self.deleteHorario(horario: horario)
                    self.loadHorarios()
                    self.collectionViewHorarioa.reloadData()
                }
                else{
                    let alert = createAdviseAlert(tittle: "NO SE PUDO REALIZAR ESTA ACCION", message: "Hubo un fallo en la comunicacion con la placa")
                    self.present(alert, animated: true)
                    
                }
            })
          }
     }
    
    func tryToDesActivate(idHorario:Int,horario:Horario,indicator:UIActivityIndicatorView){
        let ip = getIpForRequest(focoList: self.focoList!)
        httpRequestDeleteHorario(ip: ip, macTarget: (focoList?.mac!)!, idHorario: idHorario){(placa,mac,macTarget) in
            DispatchQueue.main.sync(execute: {
                self.indicartorOffState(indicator: indicator)
                if placa != nil {
                    self.desActivateHorario(horario: horario)
                    self.loadHorarios()
                    self.collectionViewHorarioa.reloadData()
                }
                else{
                    let alert = createAdviseAlert(tittle: "NO SE PUDO REALIZAR ESTA ACCION", message: "Hubo un fallo en la comunicacion con la placa")
                    self.present(alert, animated: true)
                }
            })
        }
        
    }
    
    func tryToActivate(horario:Horario,indicator:UIActivityIndicatorView){
        let date = Date()
        let ip = getIpForRequest(focoList: focoList!)
        let macTarget = focoList!.mac
        let numSalida = focoList!.salida
        let daysCode = Int(horario.daysWeekCode)
        let hour = Int(horario.hora)
        let minute = Int(horario.minuto)
        let typeTurn = Int(horario.typeTurn)
        let isRepetitive = Int(horario.isRepetitive)
        var dateExplotion:Date?
        if( isRepetitive == Int(REPEAT_ONCE)){
            dateExplotion = getExplotionDate(dayHorario: getDayWeekByCodeWeek(codeWeek: daysCode), hourHorario: hour, minuteHorario: minute)
        }
        
        httpRequestCreateHorario(ip: ip, macTarget: macTarget!, codeWeek: daysCode, hora: hour, minuto: minute, numSalida: numSalida!, typeTurn: typeTurn, isRepetitive: isRepetitive) { (idHorario, macRes, macTargetRes) in
                DispatchQueue.main.sync(execute: {
                    self.indicartorOffState(indicator: indicator)
                    if idHorario != nil {
                        horario.id = Int64(idHorario!)
                        horario.fechaDeCreacion = date as NSDate
                        if( isRepetitive == Int(REPEAT_ONCE)){
                            horario.dateBreak = dateExplotion! as NSDate
                        }
                        horario.isActivate = true
                        saveContext(managedContext: self.managedContext)
                        self.loadHorarios()
                        self.collectionViewHorarioa.reloadData()
                    }
                    else {
                        let alert = createAdviseAlert(tittle: "NO SE PUDO REALIZAR ESTA ACCION", message: "Hubo un fallo en la comunicacion con la placa")
                                self.present(alert, animated: true)
                    }
                    
            })
        }
    }
    
    func deleteHorario(horario:Horario){
        managedContext.delete(horario)
        saveContext(managedContext: managedContext)
    }
    func activateHorario(horario:Horario){
        horario.isActivate = true
        saveContext(managedContext: managedContext)
    }
    func desActivateHorario(horario:Horario){
        horario.isActivate = false
        saveContext(managedContext: managedContext)
    }
    func indicartorChargeState(indicator: UIActivityIndicatorView){
        indicator.isHidden = false
        indicator.startAnimating()
        collectionViewHorarioa.isUserInteractionEnabled = false
        
    }
    func indicartorOffState(indicator: UIActivityIndicatorView){
        indicator.isHidden = true
        indicator.stopAnimating()
        collectionViewHorarioa.isUserInteractionEnabled = true
        collectionViewHorarioa.reloadData()
    }
    
    func loadHorarios(){
        if let horariosRaw = getHorariosOfThisFoco(mac: (focoList?.mac)!, numSalida: (focoList?.salida)!, managedContext: managedContext){
            horariosData = horariosRaw
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToMakeHorario"{
            if sender == nil {
                let viewCMakeHor = segue.destination as! ViewControllerMakeHorario
                viewCMakeHor.focoList = self.focoList
            }
            else {
                let viewCMakeHor = segue.destination as! ViewControllerMakeHorario
                viewCMakeHor.focoList = self.focoList
                viewCMakeHor.horarioEdit = horariosData[sender as! Int - 1]
            }
        }
    }
    
}


