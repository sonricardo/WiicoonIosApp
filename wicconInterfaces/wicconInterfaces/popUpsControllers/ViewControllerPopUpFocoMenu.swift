//
//  ViewControllerPopUpFocoMenu.swift
//  wicconInterfaces
//
//  Created by Luis Fernando Perez on 21/03/18.
//  Copyright © 2018 Ricardo Coronado. All rights reserved.
//

import UIKit

protocol PopUpMenuFocoDelegate:class {
    func changeName(newName:String,foco:FocoListM)
    func desactivateFoco(foco:FocoListM)
}

class ViewControllerPopUpFocoMenu: UIViewController {
    
    var focoList:FocoListM?
    weak var delegate:PopUpMenuFocoDelegate?
   
    @IBOutlet weak var labelFocoName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        labelFocoName.text = focoList?.nombre
        hideWhenTouchOut()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonCancelar(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func buttonCambiarNombre(_ sender: Any) {
        
        let alert = createEditingNameAlert(tittle: (focoList?.nombre)!, message: "escriba el nuevo nombre que le quiere dar", initialName: (focoList?.nombre)!) { (newName) in
            if newName == "" {
             self.dismiss(animated: true)
            }
            else if newName != nil{
                self.delegate?.changeName(newName: newName!, foco: self.focoList!)
                self.dismiss(animated: true)
            }
        }
        self.present(alert, animated: true)
    }
    
    @IBAction func buttonBorrar(_ sender: Any) {
        let alertDelete = createYesOrNotAlert(tittle: (focoList?.nombre)!, message: "¿esta seguro que desea borrar esta salida?") { (resp) in
            if resp{
                self.delegate?.desactivateFoco(foco: self.focoList!)
                self.dismiss(animated: true)
            }
            else{
              self.dismiss(animated: true)
            }
        }
        self.present(alertDelete,animated: true)
    }
    
    func hideWhenTouchOut()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(ViewControllerPopUpFocoMenu.dismissPop))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissPop()
    {
        self.dismiss(animated: true)
    }
}
