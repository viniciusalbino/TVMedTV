//
//  TextFieldMask.swift
//  Shoestock
//
//  Created by Vinicius de Moura Albino on 06/03/17.
//  Copyright © 2017 Netshoes. All rights reserved.
//

import Foundation
import UIKit

/// Setting text should always be done using the
/// `pasteTextForMasking` method to ensure masking
/// is executed. Failing to do so will not mask the
/// string and validation will consequently fail
/// indefinitely
class TextFieldMask: AnnotatedTextField {
    var range: NSRange?
    var replacementString = ""
    
    var currentText: String {
        return (text ?? "")
    }
    
    var maskStrippedString: String {
        return mask().stringByStrippingMaskedCharacters(string: currentText)
    }
    
    init() {
        super.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(text: String) {
        super.init(frame: .zero)
        self.text = text
    }
    
    /// Use this method instead of setText/text so the text
    /// is masked and validation works as normal
    func pasteTextForMasking(text: String) {
        text.characters.forEach { char in
            let range = NSRange(location: (self.text ?? "").length(), length: 1)
            _ = self.shouldChangeCharacters(range: range, replacementString: String(char))
        }
    }
    
    func shouldChangeCharacters(range: NSRange, replacementString: String) -> Bool {
        self.range = range
        self.replacementString = replacementString
        if isDeleting() {
            deleteCharacter()
        } else {
            enterCharacter()
        }
        return false
    }
    
    func isDeleting() -> Bool {
        return replacementString == "" && currentText.length() > 0
    }
    
    func enterCharacter() {
        guard let r = range, shouldEnterCharacter() else {
            return
        }
        text = currentText + mask().maskedCharactersBeginningAt(index: r.location) + replacementString
    }
    
    func shouldEnterCharacter() -> Bool {
        return isShorterThanMask() && isReplacementLimitedToCharacterSet(characterSet: maskedCharacterSet())
    }
    
    func deleteCharacter() {
        guard let textFieldText = text, let r = range, textFieldText.length() > 0 else {
            return
        }
        
        let maskedString = mask().deleteMaskedCharactersFromStringBeginningAt(index: r.location, stringToDelete: textFieldText)
        text = maskedString.length() < textFieldText.length()
            ? maskedString
            : textFieldText.substring(to: textFieldText.index(textFieldText.startIndex, offsetBy: textFieldText.length() - 1))
    }
    
    func isShorterThanMask() -> Bool {
        let currentMask = mask()
        guard currentMask.exampleMask.length() > 0 else {
            return true
        }
        return currentText.length() < (currentMask.exampleMask).length()
    }
    
    func aggregateString() -> String {
        return currentText + replacementString
    }
    
    func isReplacementLimitedToCharacterSet(characterSet: CharacterSet) -> Bool {
        return replacementString.hasOnlyCharactersInSet(charSet: maskedCharacterSet())
    }
    
    func isValid() -> Bool {
        if mask().exampleMask.length() == 0 {
            return true
        }
        return currentText.length() == mask().exampleMask.length() && maskStrippedString.hasOnlyCharactersInSet(charSet: maskedCharacterSet())
    }
    
    func mask() -> Mask {
        return Mask(exampleMask: "", charactersToMask: [])
    }
    
    func maskedCharacterSet() -> CharacterSet {
        return CharacterSet.alphanumerics
    }
    
    func shouldChangeResult(shouldChange: Bool) -> Bool {
        if !shouldChange {
            self.sendActions(for: .editingChanged)
        }
        return shouldChange
    }
    
    class func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if let tf = textField as? TextFieldMask {
            return tf.shouldChangeCharacters(range: range, replacementString: string)
        }
        return true
    }
    
    func maskedTextForRange(range: NSRange, replacementString string: String) -> String {
        _ = shouldChangeCharacters(range: range, replacementString: string)
        return currentText
    }
    
}
