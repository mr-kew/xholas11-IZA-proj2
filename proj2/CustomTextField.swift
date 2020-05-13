//
//  CustomTextField.swift
//  proj2
//
//  Created by David on 13/05/2020.
//

import UIKit

class CustomTextField: UITextField, UITextFieldDelegate {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
