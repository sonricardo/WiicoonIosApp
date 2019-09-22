//
//  ViewControllerIphoneBoardComm.swift
//  wicconInterfaces
//
//  Created by Luis Fernando Perez on 10/03/18.
//  Copyright © 2018 Ricardo Coronado. All rights reserved.
//

import UIKit

class ContainerView: UIViewController {

  
    var segueIdentifier: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func segueIdentifierReceivedFromParent(_ identifier: String){
        
        self.segueIdentifier = identifier
        self.performSegue(withIdentifier: self.segueIdentifier!, sender: nil)
        
    }

}
