//
//  MaskCreditCardDateValidation.swift
//  Zattini
//
//  Created by Christopher John Morris on 2/2/16.
//  Copyright © 2016 Netshoes. All rights reserved.
//

import UIKit

let kCreditCardDateValidationMask = Mask(exampleMask: "## / ##", charactersToMask: ["/", " "])

class MaskCreditCardDateValidationTextField: TextFieldMask {
    
    override func mask() -> Mask {
        return kCreditCardDateValidationMask
    }
    
    override func maskedCharacterSet() -> CharacterSet {
        return CharacterSet(charactersIn: "0123456789")
    }
    
    override func isValid() -> Bool {
        if mask().exampleMask.length() == 0 {
            return true
        }
        
        if currentText.length() != 7 {
            return false
        }
        
        return currentText.length() == mask().exampleMask.length() && maskStrippedString.hasOnlyCharactersInSet(charSet: maskedCharacterSet()) && dateValidation()
    }
    
    func dateValidation() -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM / yy"
        
        if let date = dateFormatter.date(from: currentText) {
            var oneMonthComponent = DateComponents()
            oneMonthComponent.month = 1
            
            if let invalidDate = Calendar.current.date(byAdding: oneMonthComponent, to: date) {
                return invalidDate.compare(Date()) == .orderedDescending
            }
        }
        
        return false
    }
}
