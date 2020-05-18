//
//  SectionDetailVC.swift
//  proj2
//
//  Created by David on 13/05/2020.
//

import UIKit

/// Edits given section, if section is nil new one will be created
class SectionDetailVC: UITableViewController {
    /// Section reference passed from previous controller
    var section: Section?

    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var nameField: CustomTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.allowsSelection = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        SharedHandlers.tools.discardChanges()
        
        if let section = section {
            nameField.text = section.name
        }
    }
    
    @IBAction func doneTouched(_ sender: Any) {
        if section == nil {
            section = SharedHandlers.sections.createModel()
            section?.order = SharedHandlers.sections.getOrder()
        }
        section?.name = nameField.text
        SharedHandlers.sections.saveChanges()
        
        navigationController?.popViewController(animated: true)
    }
    
    /// Done is disabled until all mandatory fields are filled (name has to be unique)
    @IBAction func fieldEdited(_ sender: Any) {
        let hasName = !(nameField.text?.isEmpty ?? true)
        let nameUnused = !SharedHandlers.tools.models.contains { $0.name == nameField.text }
        
        doneButton.isEnabled = hasName && nameUnused
    }
}

extension SectionDetailVC {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
