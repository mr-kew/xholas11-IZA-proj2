//
//  ToolboxTableVC.swift
//  proj2
//
//  Created by David on 13/05/2020.
//

import UIKit
import CoreData

/// Main table with tools in sections
class ToolboxTableVC: UITableViewController {
    // Quick access to all sections
    private var sections: [Section] {
        return SharedHandlers.sections.models
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        tableView.allowsSelectionDuringEditing = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        SharedHandlers.sections.discardChanges()
        SharedHandlers.sections.delegate = self
        SharedHandlers.sections.performFetch()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        manageAddButton()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        updateTableView(editing: editing)
        manageAddButton()
    }
    
    @IBAction func addToolTouched(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "toolSegue", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isEditing {
            var section: Section?
            if indexPath.row < sections.endIndex {
                section = sections[indexPath.row]
            }
            performSegue(withIdentifier: "sectionSegue", sender: section)
        } else {
            performSegue(withIdentifier: "toolSegue", sender: getTool(at: indexPath))
        }
    }
    
    private func getTool(at indexPath: IndexPath) -> Tool? {
        guard !sections.isEmpty, sections[indexPath.section].contains?.count ?? 0 > 0  else {
            return nil
        }
        return sections[indexPath.section].contains?[indexPath.row] as? Tool
    }
    
    /// Done button is disabled, if there are no sections
    private func manageAddButton() {
        navigationItem.rightBarButtonItem?.isEnabled = !isEditing && !sections.isEmpty
    }
    
    /// Animates cells in place on start/end of editing
    private func updateTableView(editing: Bool) {
        tableView.beginUpdates()
        updateRowsInFirstSection(editing: editing)
        updateSections(editing: editing)
        tableView.endUpdates()
    }
    
    /// Animates rows in first section
    private func updateRowsInFirstSection(editing: Bool) {
        if sections.count > 1 {
            let set = IndexSet(sections.indices.dropFirst())
            insertOrDeleteSections(set, with: .fade, insertIf: !editing)
            tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .fade)
        } else if sections.count < 1 {
            insertOrDeleteSections(IndexSet(arrayLiteral: 0), with: .fade, insertIf: editing)
        } else {
            tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .fade)
        }
    }
    
    /// Animates all sections
    private func updateSections(editing: Bool) {
        let editSectionsCount = sections.count + 1
        let itemsCount = sections.first?.contains?.count ?? 0
        if itemsCount > editSectionsCount {
            let paths = (editSectionsCount..<itemsCount).map{ IndexPath(row: $0, section: 0) }
            insertOrDeleteRows(at: paths, with: .fade, insertIf: !editing)
        } else if itemsCount < editSectionsCount {
            let paths = (itemsCount..<editSectionsCount).map{ IndexPath(row: $0, section: 0) }
            insertOrDeleteRows(at: paths, with: .fade, insertIf: editing)
        }
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
        } else if let dest = segue.destination as? SectionDetailVC {
            dest.section = sender as? Section
        }
    }
}

// MARK: Table settings

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
            return sections[section].contains?.count ?? 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if !isEditing {
            return sections[section].name
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isEditing && !isEditable(indexPath: indexPath) {
            return tableView.dequeueReusableCell(withIdentifier: "AddCell", for: indexPath)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToolCell", for: indexPath)
        if isEditing {
            cell.textLabel?.text = sections[indexPath.row].name
        } else {
            cell.textLabel?.text = getTool(at: indexPath)?.name
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }
    
    // MARK: Editng
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return isEditable(indexPath: indexPath)
    }
    
    /// Handles deleting cells
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            SharedHandlers.sections.remove(model: sections[indexPath.row])
            SharedHandlers.sections.performFetch()
            tableView.deleteRows(at: [indexPath], with: .automatic)

            SharedHandlers.sections.saveChanges()
        default:
            break;
        }
    }
    
    /// Handles moving cells
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        reorder(sections, source: sourceIndexPath.row, destination: destinationIndexPath.row)
        SharedHandlers.sections.saveChanges()
    }
    
    /// Prevents rows from being moved under last (uneditable) row
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if !isEditable(indexPath: proposedDestinationIndexPath) {
            return IndexPath(row: sections.endIndex - 1, section: 0)
        }
        return proposedDestinationIndexPath
    }
    
    private func isEditable(indexPath: IndexPath) -> Bool {
        // Last cell (when editing) adds new section and should not be moved or edited
        return indexPath.row < sections.endIndex
    }
    
    /// Handles moving sections when editing, sections are ordered by .order
    private func reorder(_ array: [Section], source: Int, destination: Int) {
        array[source].order = array[destination].order
        if source < destination {
            for index in (source+1)...destination {
                array[index].order -= 1
            }
        } else {
            for index in destination..<source {
                array[index].order += 1
            }
        }
    }
}

extension ToolboxTableVC: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}

