//
//  ViewControllerAnimateShareMenu.swift
//  wicconInterfaces
//
//  Created by Luis Fernando Perez on 20/03/18.
//  Copyright © 2018 Ricardo Coronado. All rights reserved.
//

import UIKit

class ViewControllerAnimateShareMenu: UIViewController {

    @IBOutlet weak var imageHand: UIImageView!
    
    @IBOutlet weak var imageMenu: UIImageView!
    
    @IBOutlet weak var constraintWide: NSLayoutConstraint!
    
    @IBOutlet weak var constraintHeight: NSLayoutConstraint!
    
    
    var timer = Timer()
    var step = 0
    var heithInit:CGFloat = 0
    var wideInit:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        heithInit = constraintHeight.constant
        wideInit = constraintWide.constant
    }

    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        step = 0
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(ViewControllerAnimateShareMenu.move), userInfo: nil, repeats: true)
    }
    
    @objc func move () {
        switch step  {
        case 0: constraintWide.constant = wideInit
                constraintHeight.constant = heithInit
                imageHand.image = UIImage(named: "touch")
                imageMenu.isHidden = true
        case 1: constraintWide.constant += 6
                constraintHeight.constant -= 10
        case 2: constraintWide.constant += 6
                constraintHeight.constant -= 10
        case 3: constraintWide.constant += 6
                constraintHeight.constant -= 10
        case 4: constraintWide.constant += 6
                constraintHeight.constant -= 10
        case 5: constraintWide.constant += 6
                constraintHeight.constant -= 10
        case 7: imageHand.image = UIImage(named: "touch_pressed")
        case 9: imageHand.image = UIImage(named: "touch")
        case 10: imageMenu.isHidden = false
        case 11: constraintWide.constant -= 14
                 constraintHeight.constant += 5
        case 12: constraintWide.constant -= 14
                 constraintHeight.constant += 5
        case 13: constraintWide.constant -= 14
                 constraintHeight.constant += 5
        case 14: constraintWide.constant -= 14
                 constraintHeight.constant += 5
        case 15: constraintWide.constant -= 14
                 constraintHeight.constant += 5
       
        case 17: imageHand.image = UIImage(named: "touch_pressed")
        case 19: imageHand.image = UIImage(named: "touch")
        case 20: imageMenu.isHidden = true
        default: break
            
        }
        step += 1
        if(step > 20){
            step = 0
        }
        
    }
    

}
