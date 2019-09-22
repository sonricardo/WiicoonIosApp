//
//  viewControllerAnimationSearchWifi.swift
//  wicconInterfaces
//
//  Created by Luis Fernando Perez on 11/03/18.
//  Copyright © 2018 Ricardo Coronado. All rights reserved.
//

import UIKit

class viewControllerAnimationSearchWifi: UIViewController {
    
    @IBOutlet weak var imageHand: UIImageView!
    
    @IBOutlet weak var imageWifiList: UIImageView!
    
    
    @IBOutlet weak var imageWifiLogo: UIImageView!
    
    @IBOutlet weak var labelRedName: UILabel!
    
    @IBOutlet weak var wide: NSLayoutConstraint!
    
    @IBOutlet weak var heigth: NSLayoutConstraint!
    
    @IBOutlet weak var imageWifiSignalPhone: UIImageView!
    
     
     var timer = Timer()
     var step = 0
     var heithInit:CGFloat = 0
     var wideInit:CGFloat = 0
     
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        heithInit = heigth.constant
        wideInit = wide.constant
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        step = 0
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(viewControllerAnimationSearchWifi.move), userInfo: nil, repeats: true)
    }
    
    
     @objc func move () {
     switch step  {
     case 0: imageWifiLogo.isHidden = true
     imageWifiList.isHidden = true
     imageHand.image = UIImage(named: "touch")
     self.heigth.constant = heithInit
     self.wide.constant = wideInit
     labelRedName.isHidden = true
     imageWifiSignalPhone.isHidden = false
     case 3: imageHand.image = UIImage(named: "touch_pressed")
     case 5: imageHand.image = UIImage(named: "touch")
     imageWifiLogo.isHidden = false
     imageWifiList.isHidden = false
     labelRedName.isHidden = false
     imageWifiSignalPhone.isHidden = true
     case 7: self.heigth.constant += 2
     self.wide.constant += 18
     case 8: self.heigth.constant += 2
     self.wide.constant += 18
     case 9: self.heigth.constant += 2
     self.wide.constant += 18
     case 10: self.heigth.constant += 2
     self.wide.constant += 18
     case 11: self.heigth.constant += 2
     self.wide.constant += 18
     case 12: self.heigth.constant += 2
     self.wide.constant += 18
     case 13: self.heigth.constant += 2
     self.wide.constant += 14
     case 15: imageHand.image = UIImage(named: "touch_pressed")
     case 16: imageHand.image = UIImage(named: "touch")
     imageWifiLogo.isHidden = true
     imageWifiList.isHidden = true
     labelRedName.isHidden = true
     
     
     default: break
     
     }
     step += 1
     if(step > 16){
     step = 0
     }
     
     }
    
    

}
