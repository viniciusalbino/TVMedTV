//
//  MaskCEPTextField.swift
//  Shoestock
//
//  Created by Vinicius de Moura Albino on 21/03/17.
//  Copyright © 2017 Netshoes. All rights reserved.
//

import Foundation

class MaskCEPTextField: TextFieldMask {
    
    private static var kCEPMask: Mask {
        return Mask(exampleMask: "#####-###", charactersToMask: ["-"])
    }
    
    class func cepMaxLength() -> Int {
        return kCEPMask.exampleMask.characters.count
    }
    
    override func mask() -> Mask {
        return MaskCEPTextField.kCEPMask
    }
    
    override func maskedCharacterSet() -> CharacterSet {
        return CharacterSet(charactersIn: "0123456789")
    }
}
