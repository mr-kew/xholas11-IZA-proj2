//
//  ToolDetailVC.swift
//  proj2
//
//  Created by David on 13/05/2020.
//

import UIKit

class ToolDetailVC: UIViewController {
    var tool: Tool?
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var removeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        removeButton.isHidden = (tool == nil)
    }
    
    @IBAction func doneTouched(_ sender: Any) {
        ModelHandler.shared.addTool(name: nameField.text!)
        
        pop()
    }
    
    @IBAction func removeTouched(_ sender: Any) {
        
        ModelHandler.shared.removeTool(tool: tool!);
        
        pop()
    }
    
    private func pop() {
        navigationController?.popViewController(animated: true)
    }
}
