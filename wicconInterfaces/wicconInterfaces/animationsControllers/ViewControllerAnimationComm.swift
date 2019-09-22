//
//  ViewControllerAnimationComm.swift
//  wicconInterfaces
//
//  Created by Luis Fernando Perez on 10/03/18.
//  Copyright © 2018 Ricardo Coronado. All rights reserved.
//

import UIKit

class ViewControllerAnimationComm: UIViewController {

    @IBOutlet weak var imageViewSignal: UIImageView!
     var images = [UIImage]()
    
     weak var delegate: ViewControllerAnimationComm? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        images.append(UIImage(named: "signal_vacia")!)
        images.append(UIImage(named: "signal_baja")!)
        images.append(UIImage(named: "signal_media")!)
        images.append(UIImage(named: "signal_completa")!)
        images.append(UIImage(named: "signal_media")!)
        images.append(UIImage(named: "signal_baja")!)
        
        imageViewSignal.animationImages = images
        imageViewSignal.animationDuration = 2
       
        
        imageViewSignal.startAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        imageViewSignal.stopAnimating()
    }
    override func viewWillAppear(_ animated: Bool) {
        imageViewSignal.startAnimating()
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}
