//
//  MaskNameTextField.swift
//  Shoestock
//
//  Created by Vinicius de Moura Albino on 15/03/17.
//  Copyright © 2017 Netshoes. All rights reserved.
//

import Foundation

class MaskNameTextField: TextFieldMask {
    override func isValid() -> Bool {
        let components = currentText.components(separatedBy: " ")
        if components.count >= 2 {
            if let secondComponent = components.object(index: 1) {
                return secondComponent.length() > 0
            }
        }
        
        return false
    }
    
    override func maskedCharacterSet() -> CharacterSet {
        var set = CharacterSet.alphanumerics
        set.insert(charactersIn: " ")
        return set
    }
}
