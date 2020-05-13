//
//  ToolDetailVC.swift
//  proj2
//
//  Created by David on 13/05/2020.
//

import UIKit

class ToolDetailVC: UITableViewController {
    var tool: Tool?
    var modelHandler: ModelHandler<Tool>!
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var nameField: CustomTextField!
    @IBOutlet weak var sectionField: CustomTextField!
    
    let removeButtonIndexPath = IndexPath(row: 0, section: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tool = tool {
            nameField.text = tool.name
            sectionField.text = tool.section
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        modelHandler.remove(model: tool!)
        modelHandler.saveChanges()
        
        pop()
    }
    
    @IBAction func doneTouched(_ sender: Any) {
        if tool == nil {
            tool = modelHandler.createModel()
        }
        tool?.name = nameField.text
        tool?.section = sectionField.text
        modelHandler.saveChanges()
        
        pop()
    }
    
    @IBAction func fieldEdited(_ sender: Any) {
        doneButton.isEnabled = (!(nameField.text?.isEmpty ?? true) && !(sectionField.text?.isEmpty ?? true))
    }
    
    
    private func pop() {
        navigationController?.popViewController(animated: true)
    }
}

extension ToolDetailVC {
    override func numberOfSections(in tableView: UITableView) -> Int {
        if tool == nil {
            return 1
        } else {
            return 2
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath == removeButtonIndexPath {
            return indexPath
        }
        return nil
    }
}
