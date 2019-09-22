//
//  PlacaData+CoreDataProperties.swift
//  wicconInterfaces
//
//  Created by Luis Fernando Perez on 15/03/18.
//  Copyright © 2018 Ricardo Coronado. All rights reserved.
//
//

import Foundation
import CoreData


extension PlacaData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlacaData> {
        return NSFetchRequest<PlacaData>(entityName: "PlacaData")
    }

    @NSManaged public var mac: String?
    @NSManaged public var ip: String?
    @NSManaged public var numSalidas: Int32
    @NSManaged public var focos: NSOrderedSet?

}

// MARK: Generated accessors for focos
extension PlacaData {

    @objc(insertObject:inFocosAtIndex:)
    @NSManaged public func insertIntoFocos(_ value: FocoData, at idx: Int)

    @objc(removeObjectFromFocosAtIndex:)
    @NSManaged public func removeFromFocos(at idx: Int)

    @objc(insertFocos:atIndexes:)
    @NSManaged public func insertIntoFocos(_ values: [FocoData], at indexes: NSIndexSet)

    @objc(removeFocosAtIndexes:)
    @NSManaged public func removeFromFocos(at indexes: NSIndexSet)

    @objc(replaceObjectInFocosAtIndex:withObject:)
    @NSManaged public func replaceFocos(at idx: Int, with value: FocoData)

    @objc(replaceFocosAtIndexes:withFocos:)
    @NSManaged public func replaceFocos(at indexes: NSIndexSet, with values: [FocoData])

    @objc(addFocosObject:)
    @NSManaged public func addToFocos(_ value: FocoData)

    @objc(removeFocosObject:)
    @NSManaged public func removeFromFocos(_ value: FocoData)

    @objc(addFocos:)
    @NSManaged public func addToFocos(_ values: NSOrderedSet)

    @objc(removeFocos:)
    @NSManaged public func removeFromFocos(_ values: NSOrderedSet)

}
