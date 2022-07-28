 //
 //  CoreDataStack.swift
 //  CalidadMovil
 //
 //  Created by Avtar Singh on 11/15/17.
 //  Copyright © 2017 Sachtech. All rights reserved.
 //
 
 import Foundation
 import CoreData
 
 class CoreDataStack : NSObject{
    
    static let sharedInstance = CoreDataStack()
    private override init() {}
    
    // MARK: - Core Data stack
    
    func getContext()->NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "UserModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    private lazy var privateMOC: NSManagedObjectContext = {
        // Initialize Managed Object Context
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)

        // Configure Managed Object Context
        managedObjectContext.persistentStoreCoordinator = self.persistentContainer.persistentStoreCoordinator

        return managedObjectContext
    }()

    private(set) lazy var mainMOC: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

        managedObjectContext.parent = self.privateMOC

        return managedObjectContext
    }()
    
    func saveContext() {
            let context = self.persistentContainer.viewContext
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    let nserror = error as NSError
                    print("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
    }
    

    
    func deleteRecords(entityName:String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try self.getContext().execute(deleteRequest)
                try self.getContext().save()
            } catch {
                print ("There was an error")
            }
        }
    }
    
    func someEntityExists(entityName:String) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.includesSubentities = false
        
        var entitiesCount = 0
        
        do {
            entitiesCount = try getContext().count(for: fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        
        return entitiesCount > 0
    }
    
    func clearCoreData(){
        deleteRecords(entityName: CoreDataKeys.user)
    }
    
    func clearEntity(name:String){
          deleteRecords(entityName: name)
    }
 }

 class CoreDataKeys {
    public static let user = "User"
  
 }
