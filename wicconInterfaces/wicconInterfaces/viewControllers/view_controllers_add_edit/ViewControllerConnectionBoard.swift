//
//  ViewControllerConnectionBoard.swift
//  wicconInterfaces
//
//  Created by Luis Fernando Perez on 10/03/18.
//  Copyright © 2018 Ricardo Coronado. All rights reserved.
//

import UIKit

class ViewControllerConnectionBoard: UIViewController {

   
    @IBOutlet weak var buttonProbar: UIButton!
    
    @IBOutlet weak var labelCurrentSSID: UILabel!
    @IBOutlet weak var labelTargetSSID: UILabel!
    @IBOutlet weak var labelInstruccion: UILabel!
    
    let animateSearchRed = "segueAnimateSearch"
    let animateIphoneBoardComm = "segueAnimateComm"
    let animateRedComm = "segueAnimateRed"
    
    var currentSSID:String?
    var targetSSID:String? = nil
    var isNewBoard:Bool = true
    var board:PlacaM? = nil
    var placasList = [PlacaM]()
    
    
    var containerView: ContainerViewController!
    
   override func viewDidLoad() {
        super.viewDidLoad()

   
    currentSSID = getCurrentSSID()
    labelCurrentSSID.text = currentSSID!
    tryCommunicate()
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(self.appBecomesToBackground),
                                           name: Notification.Name.UIApplicationWillEnterForeground,
                                           object: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        if let i = self.navigationController?.viewControllers.index(of: self){
            self.navigationController?.viewControllers.remove(at: i)
        }
    }
    
   
   
    @IBAction func buttonTry(_ sender: Any) {
       
        currentSSID = getCurrentSSID()
       //MUEVELE AQUI SI ES SIMULADOR
       /*if targetSSID != nil {
            currentSSID = targetSSID!
        }
        else{
            currentSSID = "Wiicoon_35EECF"
        }
        */
        tryCommunicate()
    }
    
    
    
    func tryCommunicate() {
        
       labelCurrentSSID.text = currentSSID!
       var mustSSIDContains = "Wiicoon"
        
        if isNewBoard {
            labelTargetSSID.text = "una red Wiicoon"
            labelInstruccion.text = "conectese a una red Wiicoon y luego oprima 'probar'"
        }else {
            labelTargetSSID.text = targetSSID!
            labelInstruccion.text = "conectese a la red \(targetSSID!) y luego oprima 'probar'"
            mustSSIDContains = targetSSID!
        }
        
        if currentSSID!.contains(mustSSIDContains) {
            containerView.segueIdentifierReceivedFromParent(animateIphoneBoardComm)
            buttonProbar.isEnabled = false
            labelInstruccion.text = "comunicandose con la placa..."
            httpRequestDataInfo(ip: nil, respuesta: { (placa, mac) in
                DispatchQueue.main.sync(execute: {
                    if(placa == nil){
                    
                        self.containerView.segueIdentifierReceivedFromParent(self.animateSearchRed)
                        self.buttonProbar.isEnabled = true
                            if  self.isNewBoard {
                                self.labelInstruccion.text = "error en la comunicación, verifique la conexión a la red wiicoon y luego oprima 'probar'"
                            }
                            else {
                                self.labelInstruccion.text = "error en la comunicación, verifique la conexión a la red  \(self.targetSSID!) y luego oprima 'probar'"
                            }
                    }
                
                    else{
                        self.board = placa
                        var macExist = false
                        if let i = self.placasList.index(where: { $0.mac == self.board?.mac }) {
                            self.board = self.placasList[i]
                            macExist = true
                        }
                        self.board?.statusConnection = StatusConnection.ACCESS_POINT
                        if(macExist && self.isNewBoard){  //si ya existe la mac
                            let alert = alertEditOrNewPlaca(respondeAlert: { (res)  in
                                if(res){ // va a editar
                                    
                                    self.performSegue(withIdentifier: "segueConnectionToEdit", sender: "edit")
                                   
                                  }
                                else{
                                    //pendiente poner en set todo o regresar al menu config
                                }
                            })
                            self.present(alert, animated: true, completion: nil)
                            print("success")
                        }
                        else {
                            if(self.isNewBoard){  //nueva placa
                            self.performSegue(withIdentifier: "segueConnectionToEdit", sender: "new")
                            }
                            else{  // cambio de conexion a red
                            self.performSegue(withIdentifier: "segueConnectionToShare", sender: "share")
                            }
                        
                        }
                        
                    }
                })
            })
        }
        else {
            containerView.segueIdentifierReceivedFromParent(animateSearchRed)
        }
    }
    
    @objc func appBecomesToBackground(notification: NSNotification) {
        currentSSID = getCurrentSSID()
        labelCurrentSSID.text = currentSSID
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch(segue.identifier!){
            
        case "connectionBoard":
                containerView = segue.destination as! ContainerViewController
        case "segueConnectionToEdit":
                let controllerViewSetNames = segue.destination as! ViewControllerSetNames
                controllerViewSetNames.board = self.board
                if(sender as! String == "new"){
                    controllerViewSetNames.isNewPlaca = true
                }
                else {
                    controllerViewSetNames.isNewPlaca = false
                }
        case "segueConnectionToShare":
             let controllerViewShare = segue.destination as! ViewControllerShareNet
             controllerViewShare.board = self.board
               break
        default: break
        }
        
      }

}
