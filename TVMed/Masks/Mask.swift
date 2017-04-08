//
//  Mask.swift
//  Shoestock
//
//  Created by Vinicius de Moura Albino on 06/03/17.
//  Copyright © 2017 Netshoes. All rights reserved.
//

import Foundation

class Mask: NSObject {
    var maskCharacters = [MaskCharacter]()
    var exampleMask: String
    
    init(maskCharacters: [MaskCharacter]) {
        self.maskCharacters = maskCharacters
        self.exampleMask = ""
        super.init()
    }
    
    init(exampleMask: String, charactersToMask: [Character]) {
        self.exampleMask = exampleMask
        super.init()
        self.maskCharacters = self.initializeCharacters(exampleMask: exampleMask, charactersToMask: charactersToMask)
    }
    
    func maskedCharactersBeginningAt(index: Int, appendedCharacters: String = "") -> String {
        var tempAppendedCharacters = appendedCharacters
        let filteredCharacters = maskCharacters.filter { $0.position == index }
        if filteredCharacters.count != 1 {
            return tempAppendedCharacters
        }
        tempAppendedCharacters += String(filteredCharacters.first!.character)
        return maskedCharactersBeginningAt(index: index + 1, appendedCharacters: tempAppendedCharacters)
    }
    
    func deleteMaskedCharactersFromStringBeginningAt(index: Int, stringToDelete: String = "") -> String {
        var tempstringToDelete = stringToDelete
        if tempstringToDelete.characters.count == 0 {
            return tempstringToDelete
        }
        let filteredCharacters = maskCharacters.filter { $0.position == index }
        if filteredCharacters.count != 1 {
            return tempstringToDelete
        }
        tempstringToDelete = tempstringToDelete.substring(to: tempstringToDelete.endIndex)
        return deleteMaskedCharactersFromStringBeginningAt(index: index - 1, stringToDelete: tempstringToDelete)
    }
    
    func initializeCharacters(exampleMask: String, charactersToMask: [Character]) -> [MaskCharacter] {
        var maskedCharacters = [MaskCharacter]()
        for (index, char) in exampleMask.characters.enumerated() {
            let filtered = charactersToMask.filter { $0 == char }
            if filtered.count > 0 {
                maskedCharacters.append(MaskCharacter(character: char, position: index))
            }
        }
        return Mask(maskCharacters: maskedCharacters).maskCharacters
    }
    
    func stringByStrippingMaskedCharacters(string: String) -> String {
        var tempString = string
        for maskCharacter in (maskCharacters.map { String($0.character) }) {
            tempString = tempString.replacingOccurrences(of: maskCharacter, with: "")
        }
        return tempString
    }
}

extension Mask {
    static func createMaskForMaxLenght(lenght: Int) -> Mask {
        let maskWithNCharacteres = String(repeating: "#", count: lenght)
        return Mask(exampleMask: maskWithNCharacteres, charactersToMask: [])
    }
}

class MaskCharacter: NSObject {
    var character: Character
    var position: Int
    
    init(character: Character, position: Int) {
        self.character = character
        self.position = position
    }
}
