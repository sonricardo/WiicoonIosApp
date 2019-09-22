//
//  ViewControllerAnimationRedComm.swift
//  wicconInterfaces
//
//  Created by Luis Fernando Perez on 11/03/18.
//  Copyright © 2018 Ricardo Coronado. All rights reserved.
//

import UIKit

class ViewControllerAnimationRedComm: UIViewController {

    
    
    @IBOutlet weak var imageRouter: UIImageView!
    
    var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageRouter.animationImages = [UIImage(named: "router_off")!,UIImage(named: "router_on")!]
        images.append(UIImage(named: "signal_vacia")!)
        images.append(UIImage(named: "signal_baja")!)
        images.append(UIImage(named: "signal_media")!)
        images.append(UIImage(named: "signal_completa")!)
        images.append(UIImage(named: "signal_media")!)
        images.append(UIImage(named: "signal_baja")!)
        
        imageRouter.animationDuration = 1.0
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        imageRouter.startAnimating()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
       
        imageRouter.stopAnimating()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
