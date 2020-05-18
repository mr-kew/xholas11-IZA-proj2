//
//  ModelHandler.swift
//  proj2
//
//  Created by David on 13/05/2020.
//

import Foundation
import CoreData
import UIKit

/// Holds ModelHandler singletons
class SharedHandlers {
    static let tools = ModelHandler<Tool>(sorted: NSSortDescriptor(key: "name", ascending: true))
    static let sections = ModelHandler<Section>(sorted: NSSortDescriptor(key: "order", ascending: true))
    
    private init() {
        // Cannot be instantiated
    }
}

/// Manages CoreData access for rest of the app using FetchedResultsController
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
    
    /// Access to FetchedResultsController's delegate
    var delegate: NSFetchedResultsControllerDelegate? {
        get {
            return fetchController.delegate
        }
        set {
            fetchController.delegate = newValue
        }
    }
    
    let sortDescriptor: NSSortDescriptor
    
    /// Shortcut to ManagedObjectContext
    static var moc: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    fileprivate init(sorted: NSSortDescriptor) {
        sortDescriptor = sorted
    }
    
    /// Fetches data from database
    func performFetch() {
        do{
            try fetchController.performFetch()
        } catch {
            print(error)
        }
    }
    
    /// Creates new model, model should be edited and saved using saveChanges()
    func createModel() -> T {
        return T(context: ModelHandler.moc)
    }
    
    /// Removes model from database
    func remove(model: T) {
        ModelHandler.moc.delete(model)
    }
    
    /// Saves changes to models, returns true on success
    @discardableResult
    func saveChanges() -> Bool {
        do {
            try ModelHandler.moc.save()
            return true
        } catch {
            print(error)
        }
        return false
    }
    
    /// Discards all changes to models
    func discardChanges() {
        ModelHandler.moc.rollback()
    }
}

extension ModelHandler where T == Section {
    /// Generates order value for newly created Sections
    func getOrder() -> Int64 {
        let orders = self.models.map{ $0.order }
        if let max = orders.max() {
            return max
        }
        return 0
    }
}
