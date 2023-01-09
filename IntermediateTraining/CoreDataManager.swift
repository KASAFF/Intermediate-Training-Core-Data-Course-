//
//  CoreDataManager.swift
//  IntermediateTraining
//
//  Created by Aleksey Kosov on 10.01.2023.
//

import CoreData

struct CoreDataManager {

    static let shared = CoreDataManager() // will live forever as long as your application is still alive, its properties will to

    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "IntermediateTrainingModels")
        container.loadPersistentStores { storeDescription, err in
            if let err = err {
                fatalError("Loading of store failed: \(err)")
            }
        }
        return container
    }()

    
}
