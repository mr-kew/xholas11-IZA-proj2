//
//  ModelHandler.swift
//  proj2
//
//  Created by David on 13/05/2020.
//

import Foundation
import CoreData
import UIKit

class ModelHandler<T: NSManagedObject> {
    lazy var fetchController: NSFetchedResultsController<T> = {
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: T.self))
        fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "name", ascending: true) ]
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: ModelHandler.moc, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }()
    
    static var moc: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    init(delegate: NSFetchedResultsControllerDelegate?) {
        fetchController.delegate = delegate
    }
    
    func performFetch() {
        do{
            try fetchController.performFetch()
        } catch {
            print(error)
        }
    }
    
    func createModel() -> T {
        return T(context: ModelHandler.moc)
    }
    
    func remove(model: T) {
        ModelHandler.moc.delete(model)
    }
    
    func saveContext() {
        do {
            try ModelHandler.moc.save()
        } catch {
            print(error)
        }
    }
}
