//
//  Horario+CoreDataProperties.swift
//  wicconInterfaces
//
//  Created by Luis Fernando Perez on 31/03/18.
//  Copyright © 2018 Ricardo Coronado. All rights reserved.
//
//

import Foundation
import CoreData


extension Horario {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Horario> {
        return NSFetchRequest<Horario>(entityName: "Horario")
    }

    @NSManaged public var hora: Int64
    @NSManaged public var minuto: Int64
    @NSManaged public var dia: Int64
    @NSManaged public var isActivate: Bool
    @NSManaged public var typeTurn: Int64
    @NSManaged public var daysWeekCode: Int64
    @NSManaged public var fechaDeCreacion: NSDate?
    @NSManaged public var id: Int64
    @NSManaged public var dateBreak: NSDate?
    @NSManaged public var isRepetitive: Int64
    @NSManaged public var foco: FocoData?

}
