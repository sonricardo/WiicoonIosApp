//
//  Redes+CoreDataProperties.swift
//  wicconInterfaces
//
//  Created by Luis Fernando Perez on 20/03/18.
//  Copyright © 2018 Ricardo Coronado. All rights reserved.
//
//

import Foundation
import CoreData


extension Redes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Redes> {
        return NSFetchRequest<Redes>(entityName: "Redes")
    }

    @NSManaged public var password: String?
    @NSManaged public var ssid: String?

}
