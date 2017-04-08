//
//  MaskNumberPhoneTextField.swift
//  Shoestock
//
//  Created by Vinicius de Moura Albino on 21/03/17.
//  Copyright © 2017 Netshoes. All rights reserved.
//

import Foundation

class MaskPhoneNumberTextField: TextFieldMask {
    
    private let kNineDigitPhoneNumberMask = Mask(exampleMask: "(##) #####-####", charactersToMask: ["-", "(", ")", " "])
    private let kEightDigitPhoneNumberMask = Mask(exampleMask: "(##) ####-####", charactersToMask: ["-", "(", ")", " "])
    
    override func mask() -> Mask {
        return aggregateString().range(of:") 9") == nil
            ? kEightDigitPhoneNumberMask
            : kNineDigitPhoneNumberMask
    }
    
    override func maskedCharacterSet() -> CharacterSet {
        return CharacterSet(charactersIn: "0123456789")
    }
}
