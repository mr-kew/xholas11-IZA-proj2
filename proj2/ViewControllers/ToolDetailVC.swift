//
//  ToolDetailVC.swift
//  proj2
//
//  Created by David on 13/05/2020.
//

import UIKit

/// Edits given tool, if section is nil new one will be created
class ToolDetailVC: UITableViewController {
    var tool: Tool!
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var nameField: CustomTextField!
    @IBOutlet weak var weightField: CustomTextField!
    @IBOutlet weak var serialField: CustomTextField!
    @IBOutlet weak var useField: CustomTextField!
    @IBOutlet weak var sectionLabel: UILabel!
    
    /// IndexPaths for special rows
    private let removeButtonIndexPath = IndexPath(row: 0, section: 1)
    private let sectionsRowIndexPath = IndexPath(row: 4, section: 0)
    
    private var existing = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Immediately creates new tool if none was passed
        if tool == nil {
            tool = SharedHandlers.tools.createModel()
            existing = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        nameField.text = tool.name
        weightField.text = display(weight: tool.weight)
        serialField.text = tool.serialNumber
        useField.text = tool.use
        sectionLabel.text = tool.belongs?.name
        
        doneButton.isEnabled = validInputs()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == removeButtonIndexPath {
            SharedHandlers.tools.remove(model: tool!)
            SharedHandlers.tools.saveChanges()
            pop()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func doneTouched(_ sender: Any) {
        setToolFields()
        SharedHandlers.tools.saveChanges()
        
        pop()
    }
    
    /// Done is disabled until all mandatory fields are filled (name has to be unique)
    @IBAction func fieldEdited(_ sender: Any) {
        doneButton.isEnabled = validInputs()
    }
    
    
    private func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    /// Checks validity of all fields
    private func validInputs() -> Bool {
        let hasName = !(nameField.text?.isEmpty ?? true)
        let nameUnused = !SharedHandlers.tools.models.contains { $0.name == nameField.text }
        let hasSection = tool.belongs != nil
        return hasName && nameUnused && hasSection
    }
    
    private func display(weight: Int64) -> String? {
        guard weight > 0 else {
            return nil
        }
        return "\(weight)"
    }
    
    /// Sets tool with values in fields
    private func setToolFields() {
        tool.name = nameField.text
        tool.weight = Int64(weightField.text ?? "") ?? 0
        tool.serialNumber = serialField.text
        tool.use = useField.text
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dest = segue.destination as? SectionsTableVC else {
            return
        }
        
        setToolFields()
        dest.tool = tool
    }
}

// MARK: Table Settings

extension ToolDetailVC {
    override func numberOfSections(in tableView: UITableView) -> Int {
        // When editing existing tool, remove row will be displayed
        if existing {
            return 2
        } else {
            return 1
        }
    }
    
    /// Only special rows can be selected
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath == removeButtonIndexPath || indexPath == sectionsRowIndexPath {
            return indexPath
        }
        return nil
    }
}
