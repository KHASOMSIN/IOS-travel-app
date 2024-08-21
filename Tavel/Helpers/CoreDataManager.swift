//
//  CoreDataManager.swift
//  Tavel
//
//  Created by user245540 on 8/12/24.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private var container: NSPersistentContainer
    
    var context: NSManagedObjectContext {
        return container.viewContext
    }
    
    private init() {
        container = NSPersistentContainer(name: "Tavel")
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Unresolved error \(error)")
            }
        }
    }
    
    func save() throws {
        do {
            try context.save()
        } catch {
            print(error)
            throw error
        }
    }
}


