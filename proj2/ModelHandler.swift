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
        fetchRequest.sortDescriptors = [ sortDescriptor ]
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: ModelHandler.moc, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }()
    
    private let sortDescriptor: NSSortDescriptor
    
    static var moc: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    init(delegate: NSFetchedResultsControllerDelegate?, sorted: NSSortDescriptor) {
        sortDescriptor = sorted
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
    
    func saveChanges() {
        do {
            try ModelHandler.moc.save()
        } catch {
            print(error)
        }
    }
}

extension Section {
    func setOrder(handler: ModelHandler<Section>) {
        self.order = Int64(handler.fetchController.fetchedObjects?.count ?? 0)
    }
}
