//
//  CollectionViewCellConfig.swift
//  wicconInterfaces
//
//  Created by Luis Fernando Perez on 09/03/18.
//  Copyright © 2018 Ricardo Coronado. All rights reserved.
//

import UIKit

class CollectionViewCellConfig: UICollectionViewCell,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegateFlowLayout {
    
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numSalidas
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewOuts.dequeueReusableCell(withIdentifier: "cellTableOuts", for: indexPath)
       
        if focos![indexPath.row].isActivate == false{
            cell.textLabel?.text = "----------"
            
            }
        else{
            cell.textLabel?.text = focos![indexPath.row].nombre
        }
        return cell
    }
    
    func setupTableView(numSalidas:Int,focos:[FocoM]){
        tableViewOuts.delegate = self
        tableViewOuts.dataSource = self
        tableViewOuts.isUserInteractionEnabled = false
        self.numSalidas = numSalidas
        self.focos = focos
        tableViewOuts.reloadData()
    }
    
    var numSalidas = 0
    
    var focos:[FocoM]?
    
    @IBOutlet weak var imageViewBoard: UIImageView!
    
    @IBOutlet weak var imageViewStatusBar: UIImageView!
    
    
    @IBOutlet weak var labelMac: UILabel!
    
    
    
    @IBOutlet weak var tableViewOuts: UITableView!
}
