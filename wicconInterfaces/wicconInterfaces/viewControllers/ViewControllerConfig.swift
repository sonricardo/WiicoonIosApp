//
//  ViewControllerConfig.swift
//  wicconInterfaces
//
//  Created by Luis Fernando Perez on 08/03/18.
//  Copyright © 2018 Ricardo Coronado. All rights reserved.
//

import UIKit
import CoreData



class ViewControllerConfig: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
     @IBOutlet weak var collectionViewConfig: UICollectionView!
    
    //var placasList = [PlacaM]()
    
    private var reachability:Reachability!
    var managedContext: NSManagedObjectContext!
    let app = UIApplication.shared.delegate as! AppDelegate
    var lastConnection:Reachability.Connection?
    var switchInternet:UISwitch?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "logo76px")
        navigationItem.titleView = UIImageView(image: image)
        navigationItem.title = "Wiicoon"
        
        collectionViewConfig.delegate = self
        collectionViewConfig.dataSource = self
        managedContext = app.coreDataStack.managedContext
        
        let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(press:)))
        longPressedGesture.minimumPressDuration = 1.2
        collectionViewConfig.addGestureRecognizer(longPressedGesture)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.reachablityChanged),
                                               name: Notification.Name.reachabilityChanged,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.appDidEnterBackground),
                                               name: Notification.Name.UIApplicationDidEnterBackground,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.appWillEnterForeground),
                                               name: Notification.Name.UIApplicationWillEnterForeground,
                                               object: nil)
        reachability = Reachability.init()
        do {
            try self.reachability.startNotifier()
        } catch {
        }
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        collectionViewConfig.reloadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
      
    }
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return placasList.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(indexPath.row == 0){
          let cell = collectionViewConfig.dequeueReusableCell(withReuseIdentifier: "cellAdd", for: indexPath)
            return cell
        }
        else {
            let cell = collectionViewConfig.dequeueReusableCell(withReuseIdentifier: "cellConfig", for: indexPath) as! CollectionViewCellConfig
            cell.imageViewBoard.image = UIImage(named: "placa")
            cell.labelMac.text = placasList[indexPath.row - 1].mac
            cell.setupTableView(numSalidas: placasList[indexPath.row - 1].numSalidas!, focos: placasList[indexPath.row - 1].focos)
            switch placasList[indexPath.row - 1].statusConnection{
            case StatusConnection.DISABLE:
                cell.imageViewStatusBar.image = UIImage(named: "status_disconnected")
            case StatusConnection.ACCESS_POINT:
                cell.imageViewStatusBar.image = UIImage(named: "status_ap")
            case StatusConnection.LAN:
                cell.imageViewStatusBar.image = UIImage(named: "status_lan")
            case StatusConnection.INT_REMOTE:
                cell.imageViewStatusBar.image = UIImage(named: "status_int_rem")
                
            }
            
            return cell
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screen = UIScreen.main.bounds
        let originalHeight = 150
        let width =  screen.width - 6
        let heith = CGFloat(originalHeight)
        
        return CGSize(width: width, height: heith)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(indexPath.row == 0){
            self.performSegue(withIdentifier: "segueCheckConnection", sender: nil)
        }
        else {
            self.performSegue(withIdentifier: "segueSetNames", sender: indexPath.row - 1 )
            
        }
        
    }
   
    @objc func refresh(){
    
        let currentSSID = getCurrentSSID()
        
        if currentSSID.contains("Wiicoon"){
         
            refreshThisBoard(ip: "192.168.4.1", macTarget: "",connection: StatusConnection.ACCESS_POINT)
        }else {
            for eachPlaca in placasList{
                if switchInternet!.isOn {
                    refreshThisBoard(ip: IP_SERVIDOR, macTarget: eachPlaca.mac!, connection: StatusConnection.INT_REMOTE)
                }
                else{
                    refreshThisBoard(ip: eachPlaca.ip, macTarget: eachPlaca.mac!, connection: StatusConnection.LAN)
                }
            }
        }
        
    }
    
    func refreshThisBoard(ip:String?,macTarget:String, connection:StatusConnection){
        httpRequestRefresh(ip: ip, macTarget: macTarget , respuesta: { (placa, mac, macTarget) in
            DispatchQueue.main.sync(execute: {
                if placa != nil {
                    if let placaSearch = getBoardByMac(mac: mac, placas: placasList){
                        placaSearch.statusConnection = connection
                        for foco in placa!.focos{
                            if let focoSearch = getFocoByMacAndOut(mac: mac, out: foco.salida! , placas: placasList){
                                focoSearch.estado = foco.estado
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
                self.collectionViewConfig.reloadData()
            })
        })
    }

    
    @objc func reachablityChanged(notification: NSNotification) {
        let reachability = notification.object as! Reachability
       

        if reachability.connection != .none {
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
                refresh()
            } else {
                print("Reachable via Cellular")
                refresh()
            }
        } else {
            print("Network not reachable")
            for placa in placasList{
                placa.statusConnection = StatusConnection.DISABLE
            }
             self.collectionViewConfig.reloadData()
            
        }
    }
    
    @objc func appWillEnterForeground(notification: NSNotification) {
        if lastConnection == reachability.connection{
            if reachability.connection != .none {
                if reachability.connection == .wifi {
                    print("Reachable via WiFi")
                    refresh()
                } else {
                    print("Reachable via Cellular")
                    refresh()
                }
            } else {
                print("Network not reachable")
                for placa in placasList{
                    placa.statusConnection = StatusConnection.DISABLE
                }
                self.collectionViewConfig.reloadData()
                
            }
        }
    }

    @objc func appDidEnterBackground(notification: NSNotification) {
        lastConnection = reachability.connection
    }
    
    @objc func longPressed(press: UILongPressGestureRecognizer) {
        if press.state == .began {
            let location = press.location(in: collectionViewConfig)
            let indexPath = collectionViewConfig.indexPathForItem(at: location)
            if let index = indexPath {
                if index.row > 0 {
                    self.performSegue(withIdentifier: "seguePopUpPlacaMenu", sender: index.row - 1)
                }
            } else {
                print("Could not find index path")
            }
        }
        
    }
    @IBAction func unwindToViewController (sender: UIStoryboardSegue){
        
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "segueCheckConnection":
            
            let vCConnect = segue.destination as! ViewControllerConnectionBoard
            if(sender == nil){
                vCConnect.isNewBoard = true
            }
            else{
                vCConnect.isNewBoard = false
                vCConnect.targetSSID = getSSIDWhithMac(mac: (sender as! PlacaM).mac! )
            }
            vCConnect.placasList = placasList
            
        case "segueSetNames":
            let vCConnect = segue.destination as! ViewControllerSetNames
            vCConnect.isNewPlaca = false
            vCConnect.board = placasList[sender as! Int]
        case "seguePopUpPlacaMenu":
            let viewControllerPopUpMenu = segue.destination as! ViewControllerPopUpPlacaMenu
            viewControllerPopUpMenu.placa = placasList[sender as! Int]
            viewControllerPopUpMenu.delegate = self
        default:
            break
        }
    }
    
}
