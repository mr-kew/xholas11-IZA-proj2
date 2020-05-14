//
//  SectionsTableVC.swift
//  proj2
//
//  Created by David on 14/05/2020.
//

import UIKit

class SectionsTableVC: UITableViewController {
    var tool: Tool!

    private var lastSelectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsSelection = true
        tableView.allowsMultipleSelection = false
        
        SharedHandlers.sections.performFetch()
        
        if let section = tool.belongs, let row = SharedHandlers.sections.models.firstIndex(of: section) {
            lastSelectedIndexPath = IndexPath(row: row, section: 0)
        }
    }
}

extension SectionsTableVC {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SharedHandlers.sections.models.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sectionCell", for: indexPath)
        
        let section = SharedHandlers.sections.models[indexPath.row]
        cell.textLabel?.text = section.name
        if section == tool.belongs {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tool.belongs = SharedHandlers.sections.models[indexPath.row]
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        if let lastIndexPath = lastSelectedIndexPath {
            tableView.cellForRow(at: lastIndexPath)?.accessoryType = .none
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        lastSelectedIndexPath = indexPath
    }
}
