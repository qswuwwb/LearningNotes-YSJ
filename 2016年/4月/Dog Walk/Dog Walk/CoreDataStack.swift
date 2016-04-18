//
//  CoreDataStack.swift
//  Dog Walk
//
//  Created by ysj on 16/4/18.
//  Copyright © 2016年 Razeware. All rights reserved.
//

import CoreData

class CoreDataStack {
    let modelName = "Model"
    
    private lazy var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count - 1]
    }()
    
    lazy var context: NSManagedObjectContext = {
        var managedObjectContext = NSManagedObjectContext.init(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.psc
        return managedObjectContext
    }()
    
    private lazy var psc: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator.init(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent(self.modelName)
        
        do {
            let option = [NSMigratePersistentStoresAutomaticallyOption: true]
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType , configuration: nil, URL: url, options: option)
            return coordinator
        } catch let error as NSError {
            print("error add persistent store")
            abort()
        }
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        let contentsURL = NSBundle.mainBundle().URLForResource(self.modelName, withExtension: "momd")
        return NSManagedObjectModel.init(contentsOfURL: contentsURL!)!
    }()
    
    func saveContext() {
        do {
            try context.save()
        } catch let error as NSError {
            print("error \(__FUNCTION__) \(error.userInfo)")
            abort()
        }
    }
    
    
    
    
    
    
    
    
}