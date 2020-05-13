//
//  ModelHandler.swift
//  proj2
//
//  Created by David on 13/05/2020.
//

import Foundation
import CoreData
import UIKit

class ModelHandler {
    static var shared = ModelHandler()
    
    lazy var fetchController: NSFetchedResultsController<Tool> = {
        let fetchRequest = NSFetchRequest<Tool>(entityName: "Tool")
        fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "name", ascending: true) ]
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: ModelHandler.moc, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }()
    
    static var moc: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    private init() {
        
    }
    
    func performFetch() {
        do{
            try fetchController.performFetch()
        } catch {
            print(error)
        }
    }
    
    func addTool(name: String) {
        let tool = Tool(context: ModelHandler.moc)
        tool.name = name
        
        saveContext()
    }
    
    func editTool(name: String) {
        
    }
    
    func removeTool(tool: Tool) {
        ModelHandler.moc.delete(tool)
        
        saveContext()
    }
    
    func saveContext() {
        do {
            try ModelHandler.moc.save()
        } catch {
            print(error)
        }
    }
}
