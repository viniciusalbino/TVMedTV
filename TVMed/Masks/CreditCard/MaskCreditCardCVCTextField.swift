//
//  MaskCreditCardCVCTextField.swift
//  Zattini
//
//  Created by Christopher John Morris on 7/21/15.
//  Copyright (c) 2015 Concrete Solutions. All rights reserved.
//

import Foundation

let kCreditCardCVCMask = Mask(exampleMask: "####", charactersToMask: [])

class MaskCreditCardCVCTextField: TextFieldMask {
    
    var currentFlag: CreditCardFactory = .elo
    
    override func isValid() -> Bool {
        return currentText.length() == currentFlag.cvvLenght
    }
    
    override func mask() -> Mask {
        return kCreditCardCVCMask
    }
    
    override func maskedCharacterSet() -> CharacterSet {
        return CharacterSet(charactersIn: "0123456789")
    }
}
