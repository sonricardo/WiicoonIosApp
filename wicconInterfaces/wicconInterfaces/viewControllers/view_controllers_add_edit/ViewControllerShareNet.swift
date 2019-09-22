//
//  ViewControllerShareNet.swift
//  wicconInterfaces
//
//  Created by Luis Fernando Perez on 12/03/18.
//  Copyright © 2018 Ricardo Coronado. All rights reserved.
//

import UIKit
import CoreData

class ViewControllerShareNet: UIViewController,BackPopUp {
    
    @IBOutlet weak var buttonSalir: UIButton!
    
    @IBOutlet weak var buttonPassword: UIButton!
    @IBOutlet weak var textViewPassword: UITextField!
    @IBOutlet weak var labelInstruccions: UILabel!
    @IBOutlet weak var labelRed: UILabel!
    
    @IBOutlet weak var buttomShare: UIButton!
    
    let app = UIApplication.shared.delegate as! AppDelegate
    var managedContext: NSManagedObjectContext!
    var containerView: ContainerViewController!
    var timer = Timer()
    let animateSearchRed = "segueAnimateSearch"
    let animateIphoneBoardComm = "segueAnimateComm"
    let animateRedComm = "segueAnimateRed"
    let animateShareComplete = "segueSharedComplete"
    let animateShareFail = "segueSharedFail"
    let animateShareMenu = "segueAnimateChooseRed"
    let animateShareClick = "segueAnimateClickShare"
    let Noanimate = "segueAnimateEmpty"
    var board:PlacaM?
    var red:Redes?
    var tokens = 5
    var count = 0
    var ssidTarget = ""
    var isFailedConnection = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        managedContext = app.coreDataStack.managedContext
        labelInstruccions.text = "Seleccione una red para compartir"
        ssidTarget = getSSIDWhithMac(mac: board!.mac!)
        hideKeyboard()
    }

    override func viewDidDisappear(_ animated: Bool) {
        if let i = self.navigationController?.viewControllers.index(of: self){
            self.navigationController?.viewControllers.remove(at: i)
        }
    }
    
    func backDataPopUp(red: String) {
        labelRed.text = red
        labelInstruccions.text = "Coloque el password correcto y oprima el botón de compartir"
        if let redData = getThisRed(managedContext: managedContext, ssid: red){
            textViewPassword.text = redData.password
        }
        else {
            textViewPassword.text = ""
        }
        containerView.segueIdentifierReceivedFromParent(Noanimate)
    }
    
    
    
    
    @IBAction func buttonActionShare(_ sender: UIButton) {
        buttonSalir.isHidden = true
        if labelRed.text == ""{
            containerView.segueIdentifierReceivedFromParent(animateShareMenu)
            return
        }
        //checar conexion de la red
        //if let currentSSIDs = getCurrentSSID().first{
        //  currentSSID = currentSSIDs
        // }
        //tomar mi conexion
        let currentSSID = ssidTarget
        if currentSSID != ssidTarget{
           self.performSegue(withIdentifier: "segueBackToConnect", sender: nil)
           return
        }
        
        if let redData = getThisRed(managedContext: managedContext, ssid: labelRed.text!){
           redData.password = textViewPassword.text
           saveContext(managedContext: managedContext)
        }
        else{
            let newRed = Redes(context: managedContext)
            newRed.ssid = labelRed.text
            newRed.password = textViewPassword.text
            saveContext(managedContext: managedContext)
        }
        buttomShare.isEnabled = false
        containerView.segueIdentifierReceivedFromParent(animateIphoneBoardComm)
        labelInstruccions.text = "Enviando datos de la Red....."
        httpRequestShareRed(ip: "192.168.4.1", ssid: labelRed.text!, password: textViewPassword.text!)
        { (placa, mac) in
            DispatchQueue.main.sync(execute: {
                if(placa != nil){
                    self.containerView.segueIdentifierReceivedFromParent(self.animateRedComm)
                    self.labelInstruccions.text = "Consiguiendo ip...."
                    self.getIpStep()
                }
                else {
                    self.buttomShare.isEnabled = true
                    self.containerView.segueIdentifierReceivedFromParent(self.Noanimate)
                    self.labelInstruccions.text = "Fallo en la comunicación, puede intentarlo de nuevo"
                    self.buttonSalir.isHidden = false
                }
             })
                
        }
       
    }
    
    func getIpStep(){
         timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(ViewControllerShareNet.launchHttpForIp), userInfo: nil, repeats: true)
        
    }
 
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(ViewControllerShareNet.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    @objc func launchHttpForIp(){
        //checar conexion de la red
        //if let currentSSIDs = getCurrentSSID().first{
          //  currentSSID = currentSSIDs
       // }
        let currentSSID = ssidTarget
        
        if currentSSID == ssidTarget {
            isFailedConnection = false
            httpRequestDataInfo(ip: "192.168.4.1") { (placa, mac) in
                DispatchQueue.main.sync(execute: {
                    if placa == nil {
                        //error
                    }else if placa?.ip != nil {
                       
                        self.containerView.segueIdentifierReceivedFromParent(self.animateShareComplete)
                        self.labelInstruccions.text = "Placa conectada a la red c: . Oprima el botón de salir para volver al menu principal"
                        if let placaData = getThisBoard(managedContext: self.managedContext, mac: (placa?.mac)!){
                             placaData.ip = placa?.ip
                            saveContext(managedContext: self.managedContext)
                            self.timer.invalidate()
                            self.count = 0
                            self.buttonSalir.isHidden = false
                        }
                     }
                })
                
            }
        }
        else {
            
            if !isFailedConnection {
                labelInstruccions.text = "reconectese a la red: \(ssidTarget) para continuar"
                containerView.segueIdentifierReceivedFromParent(animateSearchRed)
            }
            isFailedConnection = true
            count -= 1
        }
        count += 1
        if count > tokens {
            
            labelInstruccions.text = "No se pudo obtener la ip, compruebe que los datos de red sean correctos. Puede volver a intenrarlo"
            containerView.segueIdentifierReceivedFromParent(animateShareFail)
            buttomShare.isEnabled = true
            count = 0
            timer.invalidate()
            buttonSalir.isHidden = false
            return
        }
    }
    
    @IBAction func buttonActionShowRedes(_ sender: UIButton) {
        self.performSegue(withIdentifier: "seguePopRedes", sender: nil)
    }
    
    @IBAction func buttonActionPassword(_ sender: UIButton) {
        if textViewPassword.isSecureTextEntry {
            buttonPassword.setImage( UIImage(named:"noMostrar"), for: UIControlState.normal)
            textViewPassword.isSecureTextEntry = false
        }
        else {
            buttonPassword.setImage( UIImage(named:"mostrar"), for: UIControlState.normal)
            textViewPassword.isSecureTextEntry = true
        }
    }
    
    @IBAction func buttonActionSalir(_ sender: UIButton) {
        if let i = self.navigationController?.viewControllers.index(of: self){
            self.navigationController?.viewControllers.remove(at: i)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "connectionBoard"{
            containerView = segue.destination as! ContainerViewController
            
        }
        if segue.identifier == "seguePopRedes"{
            let popVc = segue.destination as! ViewControllerPopUpRedes
            popVc.delegate = self
            popVc.macTarget = self.board!.mac!
        }
        
        if(segue.identifier == "segueBackToConnect"){
            let vCConnect = segue.destination as! ViewControllerConnectionBoard
            vCConnect.isNewBoard = false
            vCConnect.targetSSID = getSSIDWhithMac(mac: board!.mac!)
        }
    }

}
