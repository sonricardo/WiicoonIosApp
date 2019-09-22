//
//  ViewControllerPopUpRedes.swift
//  wicconInterfaces
//
//  Created by Luis Fernando Perez on 19/03/18.
//  Copyright © 2018 Ricardo Coronado. All rights reserved.
//

import UIKit

protocol BackPopUp {
    func backDataPopUp(red:String)
}

class ViewControllerPopUpRedes: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var imageWifiSignal: UIImageView!
    
    @IBOutlet weak var proccessIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var labelHeadr: UILabel!
    
    @IBOutlet weak var tableViewRedes: UITableView!
    
    
    var delegate:BackPopUp?
    var macTarget:String = ""
    var listaRedesTable = [SSIDOfPlaca]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewRedes.delegate = self
        tableViewRedes.dataSource = self
        proccessIndicator.isHidden = false
        proccessIndicator.startAnimating()
        labelHeadr.text = "  Buscando redes"
        imageWifiSignal.isHidden = true
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
       
        httpRequestScanRedes(ip: "192.168.4.1", macTarget: macTarget) { (listaRedes, resp) in
            if listaRedes != nil {
                DispatchQueue.main.sync(execute: {
                    self.listaRedesTable = listaRedes!
                    self.setupListCame()
                })
            }
            else{
                httpRequestGetRedes(ip: "192.168.4.1", macTarget: self.macTarget, respuesta: { (listaRedes, resp) in
                    DispatchQueue.main.sync(execute: {
                        if listaRedes != nil {
                            self.listaRedesTable = listaRedes!
                            self.setupListCame()
                        }
                        else {
                            self.dismiss(animated: true)
                        }
                    })
                })
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaRedesTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewRedes.dequeueReusableCell(withIdentifier: "cellRedes", for: indexPath)
        
        cell.textLabel?.text = listaRedesTable[indexPath.row].nombre
        cell.detailTextLabel?.text = listaRedesTable[indexPath.row].calidad
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       delegate?.backDataPopUp(red: listaRedesTable[indexPath.row].nombre!)
       self.dismiss(animated: true)
    }
  
    func setupListCame(){
        
        self.tableViewRedes.reloadData()
        self.proccessIndicator.stopAnimating()
        self.proccessIndicator.isHidden = true
        self.imageWifiSignal.isHidden = false
        self.labelHeadr.text = "  Seleccione una Red"
      
    }
    
    
    
}
