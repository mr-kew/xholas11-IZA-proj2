//
//  ToolboxTableVC.swift
//  proj2
//
//  Created by David on 13/05/2020.
//

import UIKit
import CoreData

class ToolboxTableVC: UITableViewController {

    private var sections: [String] = ["Screws", "Bolts", "Nuts", "Plates"]
    private var items: [Tool] {
        return ModelHandler.shared.fetchController.fetchedObjects ?? []
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        tableView.allowsSelectionDuringEditing = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ModelHandler.shared.fetchController.delegate = self
        
        ModelHandler.shared.performFetch()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        updateTableView(editing: editing)
        navigationItem.rightBarButtonItem?.isEnabled = !editing
    }
    
    @IBAction func addToolTouched(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "toolSegue", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isEditing {
            performSegue(withIdentifier: "sectionSegue", sender: nil)
        } else {
            performSegue(withIdentifier: "toolSegue", sender: items[indexPath.row])
        }
    }
    
    private func updateTableView(editing: Bool) {
        tableView.beginUpdates()

        if sections.count > 1 {
            let set = IndexSet(sections.indices.dropFirst())
            insertOrDeleteSections(set, with: .fade, insertIf: !editing)
            tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .fade)
        } else if sections.count < 1 {
            insertOrDeleteSections(IndexSet(arrayLiteral: 0), with: .fade, insertIf: editing)
        }
        
        let editSectionsCount = sections.count + 1
        if items.count > editSectionsCount {
            let paths = (editSectionsCount..<items.count).map{ IndexPath(row: $0, section: 0) }
            insertOrDeleteRows(at: paths, with: .fade, insertIf: !editing)
        } else if items.count < editSectionsCount {
            let paths = (items.count..<editSectionsCount).map{ IndexPath(row: $0, section: 0) }
            insertOrDeleteRows(at: paths, with: .fade, insertIf: editing)
        }
        
        tableView.endUpdates()
    }
    
    private func insertOrDeleteSections(_ sections: IndexSet, with animation: UITableView.RowAnimation, insertIf: Bool) {
        if insertIf {
            tableView.insertSections(sections, with: animation)
        } else {
            tableView.deleteSections(sections, with: animation)
        }
    }
    
    private func insertOrDeleteRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation, insertIf: Bool) {
        if insertIf {
            tableView.insertRows(at: indexPaths, with: animation)
        } else {
            tableView.deleteRows(at: indexPaths, with: animation)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? ToolDetailVC {
            dest.tool = sender as? Tool
        }
    }
}

extension ToolboxTableVC {
    override func numberOfSections(in tableView: UITableView) -> Int {
        if isEditing {
            return 1
        } else {
            return sections.count
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isEditing {
            return sections.count + 1
        } else {
            return items.count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if !isEditing {
            return sections[section]
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isEditing && !isEditable(indexPath: indexPath) {
            return tableView.dequeueReusableCell(withIdentifier: "AddCell", for: indexPath)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToolCell", for: indexPath)
        if isEditing {
            cell.textLabel?.text = sections[indexPath.row]
            cell.accessoryType = .disclosureIndicator
        } else {
            cell.textLabel?.text = items[indexPath.row].name
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return isEditable(indexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            sections.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        default:
            break;
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = sections.remove(at: sourceIndexPath.row)
        sections.insert(item, at: destinationIndexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if !isEditable(indexPath: proposedDestinationIndexPath) {
            return IndexPath(row: sections.endIndex - 1, section: 0)
        }
        return proposedDestinationIndexPath
    }
    
    private func isEditable(indexPath: IndexPath) -> Bool {
        return indexPath.row < sections.endIndex
    }
}

extension ToolboxTableVC: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}

