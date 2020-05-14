//
//  SectionDetailVC.swift
//  proj2
//
//  Created by David on 13/05/2020.
//

import UIKit

class SectionDetailVC: UITableViewController {
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
    
    @IBAction func fieldEdited(_ sender: Any) {
        doneButton.isEnabled = !(nameField.text?.isEmpty ?? true)
    }
}

extension SectionDetailVC {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
