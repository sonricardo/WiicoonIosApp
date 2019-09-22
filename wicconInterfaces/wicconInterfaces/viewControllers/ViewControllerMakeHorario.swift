//
//  ViewControllerMakeHorario.swift
//  wicconInterfaces
//
//  Created by Ricardo Coronado on 26/03/18.
//  Copyright © 2018 Ricardo Coronado. All rights reserved.
//

import UIKit
import CoreData

class ViewControllerMakeHorario: UIViewController{
    
    @IBOutlet weak var buttonCancelOut: UIButton!
    @IBOutlet weak var buttonGuardarOut: UIButton!
    @IBOutlet weak var imageOn: UIImageView!
    @IBOutlet weak var imageOff: UIImageView!
    @IBOutlet weak var checkBoxDom: CheckBox!
    @IBOutlet weak var checkBoxLun: CheckBox!
    @IBOutlet weak var checkBoxMar: CheckBox!
    @IBOutlet weak var checkBoxMie: CheckBox!
    @IBOutlet weak var checkBoxJue: CheckBox!
    @IBOutlet weak var checkBoxVie: CheckBox!
    @IBOutlet weak var checkBoxSab: CheckBox!
    @IBOutlet weak var segmentContOnOffOut: UISegmentedControl!
    @IBOutlet weak var segmentControlRepOut: UISegmentedControl!
    @IBOutlet weak var timerPicker: UIDatePicker!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var labelFocoName: UILabel!
    
    var focoList:FocoListM?
    var horarioEdit:Horario?
    let app = UIApplication.shared.delegate as! AppDelegate
    var managedContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        managedContext = app.coreDataStack.managedContext
        labelFocoName.text = focoList?.nombre
        if horarioEdit != nil {
            setupHorarioEdit()
        }
    }
    
    @IBAction func checkDomAction(_ sender: CheckBox) {
        if segmentControlRepOut.selectedSegmentIndex == 0 {
            let ultState = sender.isChecked
            setAllCheckBoxesDeselected()
            checkBoxDom.isChecked = ultState
        }
    }
    
    @IBAction func checkLunAct(_ sender: CheckBox) {
        if segmentControlRepOut.selectedSegmentIndex == 0 {
            let ultState = sender.isChecked
            setAllCheckBoxesDeselected()
            sender.isChecked = ultState
        }
    }
    
    @IBAction func checkMarAct(_ sender: CheckBox) {
        if segmentControlRepOut.selectedSegmentIndex == 0 {
            let ultState = sender.isChecked
            setAllCheckBoxesDeselected()
            sender.isChecked = ultState
        }
    }
    
    @IBAction func checkMieAct(_ sender: CheckBox) {
        if segmentControlRepOut.selectedSegmentIndex == 0 {
            let ultState = sender.isChecked
            setAllCheckBoxesDeselected()
            sender.isChecked = ultState
        }
    }
    
    @IBAction func checkJueAct(_ sender: CheckBox) {
        if segmentControlRepOut.selectedSegmentIndex == 0 {
            let ultState = sender.isChecked
            setAllCheckBoxesDeselected()
            sender.isChecked = ultState
        }
    }
    
    @IBAction func checkVieAct(_ sender: CheckBox) {
        if segmentControlRepOut.selectedSegmentIndex == 0 {
            let ultState = sender.isChecked
            setAllCheckBoxesDeselected()
            sender.isChecked = ultState
        }
    }
    
    @IBAction func checkSabAct(_ sender: CheckBox) {
        if segmentControlRepOut.selectedSegmentIndex == 0 {
            let ultState = sender.isChecked
            setAllCheckBoxesDeselected()
            sender.isChecked = ultState
        }
    }
    
    @IBAction func segmentControlRepeat(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            setAllCheckBoxesDeselected()
        }
    }
    
    @IBAction func segmentControlOnOff(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            imageOff.isHidden = false
            imageOn.isHidden = true
        }
        else{
            imageOff.isHidden = true
            imageOn.isHidden = false
        }
    }
    

    @IBAction func ButtonSaveAction(_ sender: Any) {
        if ( getDaysCode() > 0){
            if horarioEdit != nil {
                tryDeleteAndCreateHorario()
            }
            else {
                tryMakeNewHorario()
            }
        }
        else {
            let alert = createAdviseAlert(tittle: "ESCOJA ALMENOS UN DIA", message: "")
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func buttonCancelAction(_ sender: UIButton) {
        if let i = self.navigationController?.viewControllers.index(of: self){
            self.navigationController?.viewControllers.remove(at: i)
        }
    }
    
    func setAllCheckBoxesDeselected (){
        checkBoxDom.isChecked = false
        checkBoxLun.isChecked = false
        checkBoxMar.isChecked = false
        checkBoxMie.isChecked = false
        checkBoxJue.isChecked = false
        checkBoxVie.isChecked = false
        checkBoxSab.isChecked = false
    }
    
    func tryMakeNewHorario(){
        let date = Date()
        let calendar = Calendar.current
        let currentAño = calendar.component(.year, from: date)
        let currentMes = calendar.component(.month, from: date)
        let currentDia = calendar.component(.day, from: date)
        let currentHora = calendar.component(.hour, from: date)
        let currentMinute = calendar.component(.minute, from: date)
        let currentSecond = calendar.component(.second, from: date)
        let ip = getIpForRequest()
        let macTarget = focoList!.mac
        let numSalida = focoList!.salida
        let pickerCalendar = timerPicker.calendar
        let pickerDate = timerPicker.date
        let hour = pickerCalendar?.component(.hour, from: pickerDate)
        let minute = pickerCalendar?.component(.minute, from: pickerDate)
        let creationDate = Date()
        var isRepetitive:Int?
        var typeTurn:Int?
        var dateExplotion:Date?
        let daysCode = getDaysCode()
        if segmentContOnOffOut.selectedSegmentIndex == 0{
            typeTurn = Int(TYPE_TURN_OFF)
        }
        else {
            typeTurn = Int(TYPE_TURN_ON)
        }
        if(segmentControlRepOut.selectedSegmentIndex == 0){
           isRepetitive = Int(REPEAT_ONCE)
           dateExplotion = getExplotionDate(dayHorario: getDayWeekByCodeWeek(codeWeek: daysCode), hourHorario: hour!, minuteHorario: minute!)
        }
        else {
            isRepetitive = Int(REPEAT_EACH_WEEK)
        }
        setChargeState()
        httpRequestShareTime(ip: ip, macTarget: macTarget!, año: currentAño, mes: currentMes, dia: currentDia, hora: currentHora, minuto: currentMinute, segundo: currentSecond ) { (placaResp, macResp, macTargetResp) in
            
                if placaResp != nil{
                    
                    httpRequestCreateHorario(ip: ip, macTarget: macTarget!, codeWeek: daysCode, hora: hour!, minuto: minute!, numSalida: numSalida!, typeTurn: typeTurn!, isRepetitive: isRepetitive!) { (idHorario, macRes, macTargetRes) in
                            DispatchQueue.main.sync(execute: {
                            self.setNoChargeState()
                            if idHorario != nil {
                               
                                let currentFoco = getThisFoco(managedContext: self.managedContext, mac: (self.focoList?.mac!)!, numSalida: (self.focoList?.salida!)!)
                
                                self.createNewHorario(id: idHorario!, minuto: minute!, hora: hour!, isActive: true, typeTurn: typeTurn!, codeWeek: daysCode, creationDate: creationDate, explotionDate: dateExplotion,isRepetitive: isRepetitive!, foco: currentFoco!)
                                
                                if let i = self.navigationController?.viewControllers.index(of: self){
                                    self.navigationController?.viewControllers.remove(at: i)
                                }
                            }
                            else {
                                let alert = createAdviseAlert(tittle: "NO SE PUDO REALIZAR ESTA ACCION", message: "Hubo un fallo en la comunicacion con la placa")
                                self.present(alert, animated: true)
                            }
                        })
                    
                    }
                   
                }
              
                else {
                    DispatchQueue.main.sync(execute: {
                    self.setNoChargeState()
                    let alert = createAdviseAlert(tittle: "NO SE PUDO REALIZAR ESTA ACCION", message: "Hubo un fallo en la comunicacion con la placa")
                    self.present(alert, animated: true)
                   })
                }
            
        }
     }
    
    func tryDeleteAndCreateHorario(){
        
        let idHorarioEdit = Int(horarioEdit!.id)
        let ip = getIpForRequest()
        let macTarget = focoList!.mac
        let numSalida = focoList!.salida
        let pickerCalendar = timerPicker.calendar
        let pickerDate = timerPicker.date
        let hour = pickerCalendar?.component(.hour, from: pickerDate)
        let minute = pickerCalendar?.component(.minute, from: pickerDate)
        let creationDate = Date()
        var isRepetitive:Int?
        var typeTurn:Int?
        var dateExplotion:Date?
        let daysCode = getDaysCode()
        if segmentContOnOffOut.selectedSegmentIndex == 0{
            typeTurn = Int(TYPE_TURN_OFF)
        }
        else {
            typeTurn = Int(TYPE_TURN_ON)
        }
        if(segmentControlRepOut.selectedSegmentIndex == 0){
            isRepetitive = Int(REPEAT_ONCE)
            dateExplotion = getExplotionDate(dayHorario: getDayWeekByCodeWeek(codeWeek: daysCode), hourHorario: hour!, minuteHorario: minute!)
        }
        else {
            isRepetitive = Int(REPEAT_EACH_WEEK)
        }
        setChargeState()
        httpRequestDeleteHorario(ip: ip, macTarget: macTarget!, idHorario: idHorarioEdit ) { (placaResp, macResp, macTargetResp) in
            if placaResp != nil{
                DispatchQueue.main.sync(execute: {
                    self.managedContext.delete(self.horarioEdit!)
                })
                httpRequestCreateHorario(ip: ip, macTarget: macTarget!, codeWeek: daysCode, hora: hour!, minuto: minute!, numSalida: numSalida!, typeTurn: typeTurn!, isRepetitive: isRepetitive!) { (idHorario, macRes, macTargetRes) in
                    DispatchQueue.main.sync(execute: {
                        self.setNoChargeState()
                        if idHorario != nil {
                            
                            let currentFoco = getThisFoco(managedContext: self.managedContext, mac: (self.focoList?.mac!)!, numSalida: (self.focoList?.salida!)!)
                            
                            self.createNewHorario(id: idHorario!, minuto: minute!, hora: hour!, isActive: true, typeTurn: typeTurn!, codeWeek: daysCode, creationDate: creationDate, explotionDate: dateExplotion,isRepetitive: isRepetitive!, foco: currentFoco!)
                            
                            if let i = self.navigationController?.viewControllers.index(of: self){
                                self.navigationController?.viewControllers.remove(at: i)
                            }
                        }
                        else {
                            let alert = createAdviseAlert(tittle: "NO SE PUDO REALIZAR ESTA ACCION", message: "Hubo un fallo en la comunicacion con la placa")
                            self.present(alert, animated: true)
                        }
                    })
                    
                }
                
            }
                
            else {
                DispatchQueue.main.sync(execute: {
                    self.setNoChargeState()
                    let alert = createAdviseAlert(tittle: "NO SE PUDO REALIZAR ESTA ACCION", message: "Hubo un fallo en la comunicacion con la placa")
                    self.present(alert, animated: true)
                })
            }
            
        }
    }
    
    
    func createNewHorario(id:Int, minuto:Int, hora:Int, isActive:Bool, typeTurn:Int, codeWeek:Int, creationDate:Date, explotionDate:Date?, isRepetitive:Int, foco:FocoData){
        let newHorario = Horario(context: self.managedContext)
        newHorario.id = Int64(id)
        newHorario.minuto = Int64(minuto)
        newHorario.hora = Int64(hora)
      
        newHorario.isActivate = isActive
        newHorario.typeTurn = Int64(typeTurn)
        newHorario.daysWeekCode = Int64(codeWeek)
        newHorario.fechaDeCreacion = creationDate as NSDate
        newHorario.dateBreak = explotionDate as NSDate?
        newHorario.isRepetitive = Int64(isRepetitive)
        foco.addToHorarios(newHorario)
        saveContext(managedContext: self.managedContext)
    }
    
    func setChargeState(){
        self.buttonCancelOut.isEnabled = false
        self.buttonGuardarOut.isEnabled = false
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
    }
    func setNoChargeState(){
        
        self.buttonCancelOut.isEnabled = true
        self.buttonGuardarOut.isEnabled = true
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
        
    }
    
    func setupHorarioEdit(){
        
        let second = timerPicker.calendar.component(.second, from: timerPicker.date)
        let editDate = timerPicker.calendar.date(bySettingHour: Int(horarioEdit!.hora), minute: Int(horarioEdit!.minuto), second: second, of: timerPicker.date)
          timerPicker.setDate(editDate!, animated: true)
        
        if horarioEdit?.typeTurn == TYPE_TURN_ON{
            imageOn.isHidden = false
            imageOff.isHidden = true
            segmentContOnOffOut.selectedSegmentIndex = 1
        }else{
            imageOn.isHidden = true
            imageOff.isHidden = false
            segmentContOnOffOut.selectedSegmentIndex = 0
        }
        setCheckBoxDaysEdit()
        if horarioEdit?.isRepetitive == REPEAT_EACH_WEEK {
            segmentControlRepOut.selectedSegmentIndex = 1
        }
        else{
            segmentControlRepOut.selectedSegmentIndex = 0
        }
    }
    func setCheckBoxDaysEdit(){
        let codeWeek = horarioEdit!.daysWeekCode
        for i in 1...7 {
            if 2^^i & Int(codeWeek) > 0 {
                switch(i){
                case 1: checkBoxDom.isChecked = true
                case 2: checkBoxLun.isChecked = true
                case 3: checkBoxMar.isChecked = true
                case 4: checkBoxMie.isChecked = true
                case 5: checkBoxJue.isChecked = true
                case 6: checkBoxVie.isChecked = true
                case 7: checkBoxSab.isChecked = true
                default: break
                    
                }
            }
        }
    }
    func getDaysCode()->Int{
        
        var codeWeek = 0
        if(checkBoxDom.isChecked) { codeWeek += 2 }
        if(checkBoxLun.isChecked) { codeWeek += 4 }
        if(checkBoxMar.isChecked) { codeWeek += 8 }
        if(checkBoxMie.isChecked) { codeWeek += 16 }
        if(checkBoxJue.isChecked) { codeWeek += 32 }
        if(checkBoxVie.isChecked) { codeWeek += 64 }
        if(checkBoxSab.isChecked) { codeWeek += 128 }
        
        return codeWeek
    }
    func getIpForRequest()->String{
        var ip = ""
        switch focoList!.statusConnect {
            case StatusConnection.ACCESS_POINT: ip = "192.168.4.1"
            case StatusConnection.LAN: ip = (focoList?.ip)!
            case StatusConnection.INT_REMOTE: break//ip del server
            case StatusConnection.DISABLE: break//a la verga
            
        }
        return ip
    }
}
