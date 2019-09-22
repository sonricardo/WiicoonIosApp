//
//  ViewControllerSetNames.swift
//  wicconInterfaces
//
//  Created by Luis Fernando Perez on 12/03/18.
//  Copyright © 2018 Ricardo Coronado. All rights reserved.
//

import UIKit
import CoreData

class ViewControllerSetNames: UIViewController,UITableViewDelegate, UITableViewDataSource,TableCellSetNameDelegate {
    
    @IBOutlet weak var tableViewSetNames: UITableView!
    @IBOutlet weak var buttonShare: UIButton!
    @IBOutlet weak var buttonSave: UIButton!
    @IBOutlet weak var buttonSalir: UIButton!
    @IBOutlet weak var imageGuardado: UIImageView!
    
    var isNewPlaca = true
    var board:PlacaM?
    let app = UIApplication.shared.delegate as! AppDelegate
    var managedContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSetNames.dataSource = self
        tableViewSetNames.delegate = self
        managedContext = app.coreDataStack.managedContext
        hideKeyboard()
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
       if let i = self.navigationController?.viewControllers.index(of: self){
            self.navigationController?.viewControllers.remove(at: i)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return board!.numSalidas!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewSetNames.dequeueReusableCell(withIdentifier: "cellSetNames", for: indexPath) as! TableViewCellSetNames
        cell.delegate = self
        cell.position = indexPath.row
        cell.switchActivateOut.isOn = board!.focos[indexPath.row].isActivate
        cell.textFieldName.text = board?.focos[indexPath.row].nombre
        cell.selectionStyle = .none
        if board?.statusConnection == StatusConnection.DISABLE || board?.statusConnection == StatusConnection.INT_REMOTE {
        cell.buttonTest.isHidden = true
        }
        return cell
    }
    
    func didButtonTest(sender: Int) {
        var ip:String = ""
        
        switch (board!.statusConnection){
            case StatusConnection.ACCESS_POINT:
                 ip = "192.168.4.1"
            case StatusConnection.LAN:
                 ip = board!.ip!
            case StatusConnection.INT_REMOTE:
                 //ip del servidor
                 break
            default: break
        }
        let salida = board!.focos[sender].salida!
        var estado = board!.focos[sender].estado
        let mac = board!.mac!
        if(estado == 0){
            estado = 1
        }
        else {
            estado = 0
        }
        httpRequestCommand(ip: ip, out: salida, state: estado, mac: mac) { (placa, mac) in
           DispatchQueue.main.sync(execute: {
                if ( placa != nil){
                    if(mac == self.board!.mac){
                        for i in 0...self.board!.numSalidas! - 1 {
                            if self.board!.focos[sender].salida == placa?.focos[i].salida{
                                self.board!.focos[sender].estado = (placa?.focos[i].estado)!
                                print("prendio")
                                print(self.board!.focos[sender].estado)
                            }
                        }
                    }
                }
            })
        }
    }
    
    func didSwitchChange(state: Bool, position: Int) {
        board?.focos[position].isActivate = state
    }
    
    func hasNewName(name: String, position: Int) {
        board?.focos[position].nombre = name
    }
    
    @IBAction func buttonSharAction(_ sender: Any) {
       self.performSegue(withIdentifier: "segueSetToConnect", sender: nil)
    }
 
    @IBAction func buttonSaveAction(_ sender: Any) {
        var boardData:PlacaData?
        var isNew = true
        
        let boardFetch : NSFetchRequest<PlacaData> = PlacaData.fetchRequest()
        boardFetch.predicate = NSPredicate(format: "%K == %@", #keyPath(PlacaData.mac),(board?.mac)!)
        do{
            let resultados = try managedContext.fetch(boardFetch)
            if resultados.count>0{
                boardData = resultados.first
                isNew = false
            }
            else{
                boardData = PlacaData(context: managedContext)
                }
            boardData?.ip = board?.ip
            boardData?.mac = board?.mac
            boardData?.numSalidas = Int32(board!.numSalidas!)
            for foco in board!.focos {
                if isNew{
                    let newFoco = FocoData(context: managedContext)
                    newFoco.name = foco.nombre
                    newFoco.out = Int32(foco.salida!)
                    newFoco.isActivate = foco.isActivate
                    boardData?.addToFocos(newFoco)
                }
                else{
                    for focoEdit in (boardData?.focos)!{
                        let focoEditData = focoEdit as! FocoData
                        if(focoEditData.out == Int32(foco.salida!)){
                            focoEditData.name = foco.nombre
                            focoEditData.out = Int32(foco.salida!)
                            focoEditData.isActivate = foco.isActivate
                        }
                    }
                }
                
            }
            saveContext(managedContext: managedContext)
            }catch let error as NSError {
                print("ocurrio un error \(error.localizedDescription)")
                //error en el guardado
            }
          setupFornewBoardSaved()
     }
    
    @IBAction func buttonSalirAction(_ sender: Any) {
      
    
    }
    
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(ViewControllerSetNames.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    func setupFornewBoardSaved(){
        buttonShare.isHidden = false
        imageGuardado.isHidden = false
        buttonSalir.titleLabel?.text = "   SALIR"
        buttonSave.titleLabel?.text = "GUARDADO"
        buttonSave.setTitle("GUARDADO", for: .disabled)
        buttonSave.isEnabled = false
        tableViewSetNames.isUserInteractionEnabled = false
        
    }
    func setupForOldBoardEdited(){
        buttonShare.isHidden = false
        imageGuardado.isHidden = false
        buttonSalir.titleLabel?.text = "   SALIR"
        buttonSave.titleLabel?.text = "GUARDADO"
        buttonSave.isEnabled = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueSetToConnect"){
            let vCConnect = segue.destination as! ViewControllerConnectionBoard
            vCConnect.isNewBoard = false
            vCConnect.targetSSID = getSSIDWhithMac(mac: board!.mac!)
        }
    }
    
}
