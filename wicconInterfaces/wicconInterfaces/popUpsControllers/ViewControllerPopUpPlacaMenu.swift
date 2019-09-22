//
//  ViewControllerPopUpPlacaMenu.swift
//  wicconInterfaces
//
//  Created by Luis Fernando Perez on 21/03/18.
//  Copyright © 2018 Ricardo Coronado. All rights reserved.
//

import UIKit


protocol PopUpMenuPlacaDelegate:class {
  
    func deletePlaca(placa:PlacaM)
    func compartirRed(placa:PlacaM)
    func activarAP(result:Bool)
    func desactivarAP(result:Bool)
    func resetarPlaca(result:Bool)
}

class ViewControllerPopUpPlacaMenu: UIViewController {

    @IBOutlet weak var proccessResetPlaca: UIActivityIndicatorView!
    @IBOutlet weak var proccessActivarAP: UIActivityIndicatorView!
    @IBOutlet weak var proccessDesactivarAP: UIActivityIndicatorView!
    @IBOutlet weak var labelPlacaName: UILabel!
    
    weak var delegate:PopUpMenuPlacaDelegate?
    var placa:PlacaM?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelPlacaName.text = placa?.mac
        proccessResetPlaca.isHidden = true
        proccessActivarAP.isHidden = true
        proccessDesactivarAP.isHidden = true
        hideWhenTouchOut()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonCompartir(_ sender: UIButton) {
        delegate?.compartirRed(placa: placa!)
         self.dismiss(animated: true)
    }
    
    @IBAction func buttonResetear(_ sender: UIButton) {
        if placa?.statusConnection == StatusConnection.DISABLE {
         showToast(message: "No se puede. Placa desconectada", objectClass: self)
         return
        }
       
        var ip:String?
        switch placa!.statusConnection{
            case StatusConnection.ACCESS_POINT: ip = "192.168.4.1"
            case StatusConnection.LAN:   ip = placa?.ip
            case StatusConnection.INT_REMOTE:   break //ipserver
            default: break
        }
        proccessResetPlaca.isHidden = false
        proccessResetPlaca.startAnimating()
        self.view.isUserInteractionEnabled = false
        httpRequestResetBoard(ip: ip, macTarget: placa!.mac!, respuesta: { (placa, mac, macTarget) in
            DispatchQueue.main.sync(execute: {
                if (placa == nil) {
                   self.delegate?.resetarPlaca(result: false)
                   self.dismiss(animated: true)
                }
                else{
                    self.delegate?.resetarPlaca(result: true)
                    self.dismiss(animated: true)
                }
              
            })
        })
    }
    
    @IBAction func buttonActivarAP(_ sender: UIButton) {
        if placa?.statusConnection == StatusConnection.DISABLE {
            showToast(message: "No se puede. Placa desconectada", objectClass: self)
            return
        }
        
        var ip:String?
        switch placa!.statusConnection{
        case StatusConnection.ACCESS_POINT: ip = "192.168.4.1"
        case StatusConnection.LAN:   ip = placa?.ip
        case StatusConnection.INT_REMOTE:   break //ipserver
        default: break
        }
        proccessActivarAP.isHidden = false
        proccessActivarAP.startAnimating()
        self.view.isUserInteractionEnabled = false
        httpRequestActivarAP(ip: ip, macTarget: placa!.mac!,estado: 1, respuesta: { (placa, mac, macTarget) in
            DispatchQueue.main.sync(execute: {
                if (placa == nil) {
                    self.delegate?.activarAP(result: false)
                    self.dismiss(animated: true)
                }
                else{
                    self.delegate?.activarAP(result: true)
                    self.dismiss(animated: true)
                }
                
            })
        })
    }
    
    @IBAction func buttonDesactivarAP(_ sender: UIButton) {
        if placa?.statusConnection == StatusConnection.DISABLE {
            showToast(message: "No se puede. Placa desconectada", objectClass: self)
            return
        }
        
        var ip:String?
        switch placa!.statusConnection{
        case StatusConnection.ACCESS_POINT: ip = "192.168.4.1"
        case StatusConnection.LAN:   ip = placa?.ip
        case StatusConnection.INT_REMOTE:   break //ipserver
        default: break
        }
        proccessDesactivarAP.isHidden = false
        proccessDesactivarAP.startAnimating()
        self.view.isUserInteractionEnabled = false
        httpRequestActivarAP(ip: ip, macTarget: placa!.mac!, estado: 0, respuesta: { (placa, mac, macTarget) in
            DispatchQueue.main.sync(execute: {
                if (placa == nil) {
                    self.delegate?.desactivarAP(result: false)
                    self.dismiss(animated: true)
                }
                else{
                    self.delegate?.desactivarAP(result: true)
                    self.dismiss(animated: true)
                }
                
            })
        })
    }
    
    @IBAction func buttonEliminarPlaca(_ sender: UIButton) {
        let alertDelete = createYesOrNotAlert(tittle: (placa?.mac)!, message: "¿esta seguro que quiere eliminar esta placa?") { (resp) in
            if resp{
                self.delegate?.deletePlaca(placa: self.placa!)
                self.dismiss(animated: true)
            }
            else{
                self.dismiss(animated: true)
            }
        }
        self.present(alertDelete, animated: true)
    }
    
    @IBAction func buttonCancelar(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    func hideWhenTouchOut()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(ViewControllerPopUpPlacaMenu.dismissPop))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissPop()
    {
        self.dismiss(animated: true)
    }
    
}
