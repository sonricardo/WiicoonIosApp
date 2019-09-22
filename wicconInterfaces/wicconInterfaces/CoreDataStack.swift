//
//  CoreDataStack.swift
//  wicconInterfaces
//
//  Created by Luis Fernando Perez on 14/03/18.
//  Copyright © 2018 Ricardo Coronado. All rights reserved.
//

import Foundation
import CoreData


class CoreDataStack {
    
    private let modelName:String
    
    init(modelName:String) {
        self.modelName = modelName
    }
    
    private lazy var storeContainer : NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores(completionHandler: { (storesDescription, error) in
            
            if let error = error as NSError? {
                print("ocurrio un error \(error.localizedDescription)")
            }
        })
        return container
    }()
    
    lazy var managedContext : NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    func saveContext (){
        guard managedContext.hasChanges else { return }
        do{
            try managedContext.save()
        }
        catch let error as NSError {
            print("ocurrio un error \(error.localizedDescription)")
        }
    }
    
    
}
func saveContext (managedContext : NSManagedObjectContext){
    guard managedContext.hasChanges else { return }
    do{
        try managedContext.save()
    }
    catch let error as NSError {
        print("ocurrio un error \(error.localizedDescription)")
    }
}
