//
//  ModelHandler.swift
//  proj2
//
//  Created by David on 13/05/2020.
//

import Foundation
import CoreData
import UIKit

class SharedHandlers {
    static let tools = ModelHandler<Tool>(sorted: NSSortDescriptor(key: "name", ascending: true))
    static let sections = ModelHandler<Section>(sorted: NSSortDescriptor(key: "order", ascending: true))
}

class ModelHandler<T: NSManagedObject> {
    var models: [T] {
        return fetchController.fetchedObjects ?? []
    }
    
    private lazy var fetchController: NSFetchedResultsController<T> = {
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: T.self))
        fetchRequest.sortDescriptors = [ sortDescriptor ]
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: ModelHandler.moc, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }()
    
    var delegate: NSFetchedResultsControllerDelegate? {
        get {
            return fetchController.delegate
        }
        set {
            fetchController.delegate = newValue
        }
    }
    
    let sortDescriptor: NSSortDescriptor
    
    static var moc: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    fileprivate init(sorted: NSSortDescriptor) {
        sortDescriptor = sorted
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
    
    func saveChanges() {
        do {
            try ModelHandler.moc.save()
        } catch {
            print(error)
        }
    }
}

extension ModelHandler where T == Section {
    func getOrder() -> Int64 {
        return Int64(self.models.count)
    }
    
    /*func setOrder(handler: ModelHandler<Section>) {
        self.order = Int64(handler.models.count ?? 0)
    }*/
}
