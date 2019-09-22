//
//  FocoData+CoreDataProperties.swift
//  wicconInterfaces
//
//  Created by Luis Fernando Perez on 26/03/18.
//  Copyright © 2018 Ricardo Coronado. All rights reserved.
//
//

import Foundation
import CoreData


extension FocoData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FocoData> {
        return NSFetchRequest<FocoData>(entityName: "FocoData")
    }

    @NSManaged public var isActivate: Bool
    @NSManaged public var name: String?
    @NSManaged public var out: Int32
    @NSManaged public var placa: PlacaData?
    @NSManaged public var horarios: NSOrderedSet?

}

// MARK: Generated accessors for horarios
extension FocoData {

    @objc(insertObject:inHorariosAtIndex:)
    @NSManaged public func insertIntoHorarios(_ value: Horario, at idx: Int)

    @objc(removeObjectFromHorariosAtIndex:)
    @NSManaged public func removeFromHorarios(at idx: Int)

    @objc(insertHorarios:atIndexes:)
    @NSManaged public func insertIntoHorarios(_ values: [Horario], at indexes: NSIndexSet)

    @objc(removeHorariosAtIndexes:)
    @NSManaged public func removeFromHorarios(at indexes: NSIndexSet)

    @objc(replaceObjectInHorariosAtIndex:withObject:)
    @NSManaged public func replaceHorarios(at idx: Int, with value: Horario)

    @objc(replaceHorariosAtIndexes:withHorarios:)
    @NSManaged public func replaceHorarios(at indexes: NSIndexSet, with values: [Horario])

    @objc(addHorariosObject:)
    @NSManaged public func addToHorarios(_ value: Horario)

    @objc(removeHorariosObject:)
    @NSManaged public func removeFromHorarios(_ value: Horario)

    @objc(addHorarios:)
    @NSManaged public func addToHorarios(_ values: NSOrderedSet)

    @objc(removeHorarios:)
    @NSManaged public func removeFromHorarios(_ values: NSOrderedSet)

}
