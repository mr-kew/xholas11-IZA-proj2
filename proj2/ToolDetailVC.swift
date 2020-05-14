//
//  ToolDetailVC.swift
//  proj2
//
//  Created by David on 13/05/2020.
//

import UIKit

class ToolDetailVC: UITableViewController {
    var tool: Tool!
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var nameField: CustomTextField!
    @IBOutlet weak var weightField: CustomTextField!
    @IBOutlet weak var serialField: CustomTextField!
    @IBOutlet weak var useField: CustomTextField!
    @IBOutlet weak var sectionLabel: UILabel!
    
    private let removeButtonIndexPath = IndexPath(row: 0, section: 1)
    private let sectionsRowIndexPath = IndexPath(row: 4, section: 0)
    
    private var existing = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if tool == nil {
            tool = SharedHandlers.tools.createModel()
            existing = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        nameField.text = tool.name
        weightField.text = display(width: tool.weight)
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
        tool.name = nameField.text
        tool.weight = Int64(weightField.text ?? "") ?? 0
        tool.serialNumber = serialField.text
        tool.use = useField.text
        SharedHandlers.tools.saveChanges()
        
        pop()
    }
    
    @IBAction func fieldEdited(_ sender: Any) {
        doneButton.isEnabled = validInputs()
    }
    
    
    private func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    private func validInputs() -> Bool {
        let hasName = !(nameField.text?.isEmpty ?? true)
        let nameUnused = !SharedHandlers.tools.models.contains { $0.name == nameField.text }
        let hasSection = tool.belongs != nil
        return hasName && nameUnused && hasSection
    }
    
    private func display(width: Int64) -> String? {
        guard width > 0 else {
            return nil
        }
        return "\(width)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dest = segue.destination as? SectionsTableVC else {
            return
        }
        tool.name = nameField.text
        dest.tool = tool
    }
}

extension ToolDetailVC {
    override func numberOfSections(in tableView: UITableView) -> Int {
        if existing {
            return 2
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath == removeButtonIndexPath || indexPath == sectionsRowIndexPath {
            return indexPath
        }
        return nil
    }
}
