//
//  ViewController.swift
//  wicconInterfaces
//
//  Created by Luis Fernando Perez on 07/03/18.
//  Copyright © 2018 Ricardo Coronado. All rights reserved.
//

import UIKit
import CoreData

var placasList = [PlacaM]()

class ViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,CollectionViewCellDelegate {

    var managedContext: NSManagedObjectContext!
    var timer = Timer()
    //var placasList = [PlacaM]()
    var focosList = [FocoListM]()
    var macsWaiting = [String]()
    
    @IBOutlet weak var navigation: UINavigationItem!
    @IBOutlet weak var itemCast: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var progressViewCast: UIProgressView!
    @IBOutlet weak var switchInternetMode: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        progressViewCast.isHidden = true
        let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(press:)))
        longPressedGesture.minimumPressDuration = 1.2
        collectionView.addGestureRecognizer(longPressedGesture)
        
        createPlacaList()
        loadFocoList()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(managedObjectContextObjectsDidChange), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: managedContext)
        
        let image = UIImage(named: "logo76px")
        navigation.titleView = UIImageView(image: image)
        navigation.title = "Wiicoon"
        
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(ViewController.refresh), userInfo: nil, repeats: true)
        timer.fire()
    
    }
    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
        macsWaiting.removeAll()
    }
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return focosList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screen = UIScreen.main.bounds
        let originalHorizontalCellSize = 176
        let originalVerticalCellSize = 168
        
        let screenWidth = Float(screen.width)
        
        let numberHorizontaly = Int( screenWidth / Float(originalHorizontalCellSize))
        
        let width = CGFloat( (screenWidth / Float(numberHorizontaly)) - 2 )
        let heith = CGFloat( originalVerticalCellSize )
        
        return CGSize(width: width, height: heith)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.layer.cornerRadius = 0
        cell.delegate = self
        cell.numOfRow = indexPath.row
        if focosList[indexPath.row].estado == 1 {
            cell.imageOnOff.image = UIImage(named: "luz_on")
        }
        else{
            cell.imageOnOff.image = UIImage(named: "light_off")
        }
        cell.nameOfOut.text = focosList[indexPath.row].nombre
        switch focosList[indexPath.row].statusConnect{
            case StatusConnection.DISABLE:
                cell.imageConnectionIndicator.image = UIImage(named: "status_disconnected")
            case StatusConnection.ACCESS_POINT:
                cell.imageConnectionIndicator.image = UIImage(named: "status_ap")
            case StatusConnection.LAN:
                cell.imageConnectionIndicator.image = UIImage(named: "status_lan")
            case StatusConnection.INT_REMOTE:
                cell.imageConnectionIndicator.image = UIImage(named: "status_int_rem")
            
        }
        
        return cell
    }
    
    func didPressHeartButton(sender: Any) {
        self.performSegue(withIdentifier: "segueToHorarios", sender: sender)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        var estadoComando = 0
        let macCommand = focosList[indexPath.row].mac
        var ipComando:String? = nil
        if focosList[indexPath.row].estado == 0 {
            estadoComando = 1
        }
        if focosList[indexPath.row].statusConnect != StatusConnection.DISABLE {
            
            if focosList[indexPath.row].statusConnect == StatusConnection.LAN {
                ipComando = focosList[indexPath.row].ip
            }
            if focosList[indexPath.row].statusConnect == StatusConnection.INT_REMOTE {
                ipComando = IP_SERVIDOR
            }
            let salidaComando = focosList[indexPath.row].salida
            cell?.isUserInteractionEnabled = false
            httpRequestCommand(ip: ipComando, out: salidaComando!, state: estadoComando, mac: macCommand!) { (placa, mac) in
                DispatchQueue.main.sync(execute: {
                    cell?.isUserInteractionEnabled = true
                    if ( placa != nil){
                        if(mac == self.focosList[indexPath.row].mac){
                            for foco in placa!.focos{
                                if let focoSearch = getFocoByMacAndOut(mac: mac, out: foco.salida! , placas: placasList){
                                        focoSearch.estado = foco.estado
                                        
                                }
                            }
                        }
                    }
                 self.loadFocoList()
                 self.collectionView.reloadData()
                })
            }
        }
     }
   
    
    @IBAction func itemCastAction(_ sender: Any) {
       
        if getCurrentSSID() != "1" {
            startCastingIp()
        }
        else{
            //mensaje de que no se esta conectado
        }
        
    }
    @IBAction func itemAboutUs(_ sender: Any) {
        
        
    }
    @IBAction func itemConfigAction(_ sender: Any) {
    }
    
    @objc func refresh(){
        
        var currentSSID = getCurrentSSID()
        //muevele aqui si es para simulador
      // currentSSID = "Wiicoon_35EECF"
        
        if currentSSID.contains("Wiicoon") && !switchInternetMode.isOn {
            macsWaiting.removeAll()
            refreshThisBoard(ip: "192.168.4.1", macTarget: "",connection: StatusConnection.ACCESS_POINT)
        }else {
            for eachPlaca in placasList{
                if !macsWaiting.contains(eachPlaca.mac!){
                    macsWaiting.append(eachPlaca.mac!)
                    if switchInternetMode.isOn {
                        refreshThisBoard(ip: IP_SERVIDOR, macTarget: eachPlaca.mac!, connection: StatusConnection.INT_REMOTE)
                    }
                    else{
                        refreshThisBoard(ip: eachPlaca.ip, macTarget: eachPlaca.mac!, connection: StatusConnection.LAN)
                    }
                }
            }
        }
        
    }
    
    func refreshThisBoard(ip:String?,macTarget:String, connection:StatusConnection){
       
        httpRequestRefresh(ip: ip, macTarget: macTarget , respuesta: { (placa, mac, macTarget) in
            DispatchQueue.main.sync(execute: {
                if let i = self.macsWaiting.index(where: { $0 == macTarget}) {
                    self.macsWaiting.remove(at: i)
                }
                if placa != nil {
                    if let placaSearch = getBoardByMac(mac: mac, placas: placasList){
                       placaSearch.statusConnection = connection
                        for foco in placa!.focos{
                            if let focoSearch = getFocoByMacAndOut(mac: mac, out: foco.salida! , placas: placasList){
                                focoSearch.estado = foco.estado
                                
                            }
                        }
                        if placaSearch.ip != placa?.ip{
                            if let placaData = getThisBoard(managedContext: self.managedContext, mac: (placa?.mac)!){
                                placaData.ip = placa?.ip
                                saveContext(managedContext: self.managedContext)
                            }
                        }
                        
                    }
                    if connection == StatusConnection.ACCESS_POINT{
                        for placaEach in placasList{
                            if placaEach.mac != mac {
                                placaEach.statusConnection = StatusConnection.DISABLE
                            }
                        }
                    }
                    
                    
                }
                else {
                     if let placaSearch = getBoardByMac(mac: macTarget, placas: placasList){
                        placaSearch.statusConnection = StatusConnection.DISABLE
                    }
                    if connection == StatusConnection.ACCESS_POINT {
                        for placaEach in placasList {
                            placaEach.statusConnection = StatusConnection.DISABLE
                        }
                    }
                 }
                self.loadPlacaList()
                self.loadFocoList()
                self.collectionView.reloadData()
            })
        })
    }
    
    @objc func managedObjectContextObjectsDidChange(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>, inserts.count > 0 {
            loadPlacaList()
            loadFocoList()
            
         }
        
        if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>, updates.count > 0 {
            loadPlacaList()
            loadFocoList()
            
          }
        
        if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>, deletes.count > 0 {
            createPlacaList()
            cleanFocoList()
            loadFocoList()
        }
    }
 
    @objc func longPressed(press: UILongPressGestureRecognizer) {
        if press.state == .began {
            let location = press.location(in: collectionView)
            let indexPath = collectionView.indexPathForItem(at: location)
             if let index = indexPath {
                self.performSegue(withIdentifier: "seguePopUpFocoMenu", sender: index.row)
                print(index.row)
            } else {
                print("Could not find index path")
            }
        }
        
    }
    
    
    
    
    func createPlacaList(){
        
        var placasData  = [PlacaData]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PlacaData")
        do{
            placasData = try managedContext.fetch(fetchRequest) as! [PlacaData]
        }catch let error as NSError {
            print("ocurrio un error \(error.localizedDescription)")
        }
        placasList.removeAll()
        for placaData in placasData{
            
            let placaM = PlacaM(mac: placaData.mac!, numSalidas: Int(placaData.numSalidas))
            placaM.ip = placaData.ip
            for focoData in placaData.focos!{
                let focoDataAux = focoData as! FocoData
                let focoM = FocoM(salida: Int(focoDataAux.out))
                focoM.nombre = focoDataAux.name!
                focoM.isActivate = focoDataAux.isActivate
                placaM.agregarFoco(foco: focoM)
                
             }
            placasList.append(placaM)
        }
       
    }
    
    func loadPlacaList(){
        
        var placasData  = [PlacaData]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PlacaData")
        do{
            placasData = try managedContext.fetch(fetchRequest) as! [PlacaData]
        }catch let error as NSError {
            print("ocurrio un error \(error.localizedDescription)")
        }
       
        for placaData in placasData{
            var isPlacaExist = false
            
            for placaEdit in placasList{
                if(placaEdit.mac! == placaData.mac!){
                    isPlacaExist = true
                    placaEdit.ip = placaData.ip
                    for focoData in placaData.focos!{
                        let focoDataAux = focoData as! FocoData
                        for focoEdit in placaEdit.focos{
                            if(Int(focoDataAux.out) == focoEdit.salida){
                                focoEdit.nombre = focoDataAux.name!
                                focoEdit.isActivate = focoDataAux.isActivate
                            }
                        }
                    }
                }
            }
            if !isPlacaExist {
                let placaM = PlacaM(mac: placaData.mac!, numSalidas: Int(placaData.numSalidas))
                placaM.ip = placaData.ip
                for focoData in placaData.focos!{
                    let focoDataAux = focoData as! FocoData
                    let focoM = FocoM(salida: Int(focoDataAux.out))
                    focoM.nombre = focoDataAux.name!
                    focoM.isActivate = focoDataAux.isActivate
                    placaM.agregarFoco(foco: focoM)
                }
                placasList.append(placaM)
            }
        }
    }
    
    func loadFocoList(){
        
        for placaList in placasList{
            for focoInPlaca in placaList.focos{
                var isFocoExist = false
                var indexToRemov = -1
                for focoList in focosList{
                    if(placaList.mac! == focoList.mac! && focoInPlaca.salida == focoList.salida){
                        isFocoExist = true
                        
                        if focoInPlaca.isActivate{
                            focoList.ip = placaList.ip
                            focoList.nombre = focoInPlaca.nombre
                            focoList.statusConnect = placaList.statusConnection
                            focoList.estado = focoInPlaca.estado
                        }
                        else{
                            if let i = focosList.index(where: { $0.ip == focoList.ip && $0.mac == focoList.mac }) {
                               indexToRemov = i
                            }
                            
                        }
                        
                    }
                }
                if  indexToRemov != -1{
                   focosList.remove(at: indexToRemov)
                }
                if !isFocoExist {
                    if focoInPlaca.isActivate{
                        let newFocoList = FocoListM(mac: placaList.mac!, salida: focoInPlaca.salida!)
                        newFocoList.ip = placaList.ip
                        newFocoList.statusConnect = placaList.statusConnection
                        newFocoList.nombre = focoInPlaca.nombre
                        focosList.append(newFocoList)
                    }
                }
             }
         }
     }
    
    func cleanFocoList(){
        focosList.removeAll()
    }
    
    func startCastingIp(){
        self.progressViewCast.isHidden = false
        self.progressViewCast.progress = 0
        self.itemCast.isEnabled = false
        
        
       guard var ipIphone = getWiFiAddress()
        else {
           progressViewCast.isHidden = true
           return
        }
        if ipIphone.count > 13 {
            ipIphone = "192.168.1.1"
        }
       // var ipIphone = "192.168.0.49"
       
        for _ in 0...ipIphone.count {
            
            if ipIphone.last != "." {
                ipIphone.removeLast()
            }
            else{
                break
            }
        }
        
        
        for i in 1...254 {
            let ipCast = ipIphone + String(i)
            httpRequestDataInfo(ip:ipCast, respuesta: { (placa, mac) in
                if placa != nil {
                    if let placaFounded = getBoardByMac(mac: mac, placas: placasList){
                        if placaFounded.ip != ipCast {
                            let placaData = getThisBoard(managedContext: self.managedContext, mac: mac)
                            placaData?.ip = ipCast
                            saveContext(managedContext: self.managedContext)
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.progressViewCast.progress += (1/253)
                    if (self.progressViewCast.progress == 1) {
                        self.progressViewCast.progress = 0
                        self.progressViewCast.isHidden = true
                        self.itemCast.isEnabled = true
                    }
                }
            })
    
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch(segue.identifier!){
            
        case "segueConfig":
             let viewControllerConfic = segue.destination as! ViewControllerConfig
             viewControllerConfic.switchInternet = self.switchInternetMode
        case "seguePopUpFocoMenu":
            let viewControllerPopUp = segue.destination as! ViewControllerPopUpFocoMenu
            viewControllerPopUp.focoList = self.focosList[sender as! Int]
            viewControllerPopUp.delegate = self
        case "segueToHorarios":
            let viewControllerHorarios = segue.destination as! ViewControllerHorarios
            viewControllerHorarios.focoList = self.focosList[sender as! Int]
        default:    break
        }
    }

}

