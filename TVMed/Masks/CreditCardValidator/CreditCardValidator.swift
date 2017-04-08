//
//  CreditCardValidator.swift
//
//  Created by Vinicius Albino on 19/04/16.
//  Copyright Netshoes (c) 2015. All rights reserved.
//

import Foundation

public class CreditCardValidator {
    
    public lazy var types: [CreditCardValidationType] = {
        var types = [CreditCardValidationType]()
        for object in CreditCardValidator.types {
            types.append(CreditCardValidationType(dict: object as [String : AnyObject]))
        }
        return types
        }()
    
    public init() { }
    
    /**
    Get card type from string
    
    - parameter string: card number string
    
    - returns: CreditCardValidationType structure
    */
    public func typeFromString(string: String) -> CreditCardValidationType? {
        guard !self.isElo(string: string) else {
            return types[0]
        }
        
        guard !self.validateIsNcard(string: string) else {
            return types[6]
        }
        
        for type in types {
            let predicate = NSPredicate(format: "SELF MATCHES %@", type.regex)
            let numbersString = self.onlyNumbersFromString(string: string)
            if predicate.evaluate(with: numbersString) {
                return type
            }
        }
        return nil
    }
    
    private func isElo(string: String) -> Bool {
        let eloBins = [401178, 401179, 438935, 457632, 504175, 506717, 506725, 506726, 506727, 506728, 506729,
                       506730, 506733, 506739, 506740, 506741, 506742, 506744, 506745, 506746, 506747, 506748, 636297, 636368,
                       509048, 509067, 509049, 509069, 509050, 509074, 509068, 509040, 509045, 509051, 509046, 509066, 509047, 509042,
                       509052, 509043, 509064, 431274, 506707, 506708, 506715, 506718, 506724, 506743, 506753, 506774, 506776, 506778,
                       509004, 509005, 509006, 509007, 509008, 509009, 509013, 509020, 509021, 509022, 509023, 509024, 509025, 509026,
                       509027, 509028, 509029, 509031, 509032, 509033, 509034, 509035, 509036, 509037, 509038, 509039, 509041, 509044,
                       509053, 509077, 509078, 509079, 509080, 457393, 457631, 506720, 506720, 506721, 506721, 506723, 506731, 506732,
                       506775, 506777, 509000, 509001, 509002, 509072, 509076, 509081, 509082, 509083, 506719, 506750, 506751, 506752,
                       509014, 509015, 509016, 509017, 509018, 509019, 509054, 509055, 509056, 509057, 509058, 509059, 509060, 509061,
                       509062, 509063, 509070, 509071, 509075, 509084, 509048, 509067, 509049, 509069, 509050, 509074, 509068, 509040,
                       509045, 509051, 509046, 509066, 509047, 509042, 509052, 509043, 509064, 509040, 401178, 401179, 431274, 438935,
                       451416, 457393, 457631, 457632, 504175, 627780, 636297, 636368]
        
        let trimmedString = string.trimWhiteSpaces()
        guard trimmedString.length() >= 6 else {
            return false
        }
        
        let eloString = trimmedString.substring(with: string.startIndex..<string.index(string.startIndex, offsetBy: 6))
        
        for i in eloBins {
            if Int(eloString) == i {
                return true
            }
        }
        
        let eloRanges = [
            [509085, 509807],
            [509000, 509999],
            [650031, 650033],
            [650035, 650051],
            [650405, 650439],
            [650485, 650538],
            [650541, 650598],
            [650700, 650718],
            [650720, 650727],
            [650901, 650920],
            [651652, 651679],
            [655000, 655019],
            [655021, 655058]]
        
        for range in eloRanges {
            for bin in range {
                if Int(eloString) == bin {
                    return true
                }
            }
        }
        
        return false
    }
    
    private func validateIsNcard(string: String) -> Bool {
        var nCardBins = [534447, 554480, 536804, 534448, 485103, 485104, 440132]
        
        #if DEBUG
        let debugBins = [492988, 492930, 453980, 492978, 531283, 554491, 556241, 553692]
            for bin in debugBins {
                nCardBins.append(bin)
            }
        #endif
        
        let trimmedString = string.trimWhiteSpaces()
        guard trimmedString.length() >= 6 else {
            return false
        }
        
        let nCardString = trimmedString.substring(with: string.startIndex..<string.index(string.startIndex, offsetBy: 6))
        
        for i in nCardBins {
            if Int(nCardString) == i {
                return true
            }
        }
        
        return false
    }
    
    /**
    Validate card number
    
    - parameter string: card number string
    
    - returns: true or false
    */
    public func validateString(string: String) -> Bool {
        let numbers = self.onlyNumbersFromString(string: string)
        
        if numbers.characters.count < 9 {
            return false
        }
        
        var reversedString = ""
        let range = numbers.startIndex..<numbers.endIndex
        
        numbers.enumerateSubstrings(in: range, options: [String.EnumerationOptions.reverse, String.EnumerationOptions.byComposedCharacterSequences]) { (substring, _, _, _) in
            reversedString += substring!
        }
        
        var oddSum = 0, evenSum = 0
        let reversedArray = reversedString.characters
        var i = 0
        
        for s in reversedArray {
            
            let digit = Int(String(s))!
            
            if i % 2 == 0 {
                evenSum += digit
            } else {
                oddSum += digit / 5 + (2 * digit) % 10
            }
            i += 1
        }
        return (oddSum + evenSum) % 10 == 0
    }
    
    /**
    Validate card number string for type
    
    - parameter string: card number string
    - parameter type:   CreditCardValidationType structure
    
    - returns: true or false
    */
    public func validateString(string: String, forType type: CreditCardValidationType) -> Bool {
        return typeFromString(string: string) == type
    }
    
    public func onlyNumbersFromString(string: String) -> String {
        let set = CharacterSet.decimalDigits.inverted
        let numbers = string.components(separatedBy: set)
        return numbers.joined(separator: "")
    }
    
    // MARK: - Loading data
    
    private static let types = [
        [
            "name": "Elo",
            "regex": "^((401178|401179|431274|438935|451416|457393|457631|457632|504175|627780|636297|636369|(506699|5067[0-6]\\d|50677[0-8])|(50900\\d|5090[1-9]\\d|509[1-9]\\d{2})|65003[1-3]|(65003[5-9]|65004\\d|65005[0-1])|(65040[5-9]|6504[1-3]\\d)|(65048[5-9]|65049\\d|6505[0-2]\\d|65053[0-8])|(65054[1-9]|6505[5-8]\\d|65059[0-8])|(65070\\d|65071[0-8])|65072[0-7]|(65090[1-9]|65091\\d|650920)|(65165[2-9]|6516[6-7]\\d)|(65500\\d|65501\\d)|(65502[1-9]|6550[3-4]\\d|65505[0-8]))[0-9]{10,12})"
        ], [
            "name": "Hipercard",
            "regex": "^(606282[0-9]{10}([0-9]{3})?)|(3841[0-9]{15})$"
        ], [
            "name": "Dinners Club",
            "regex": "^3(?:0[0-5]|[68][0-9])[0-9]{11}$"
        ], [
            "name": "American Express",
            "regex": "^3[47][0-9]{13}$"
        ], [
            "name": "Visa",
            "regex": "^4[0-9]{12}(?:[0-9]{3})?$"
        ], [
            "name": "MasterCard",
            "regex": "^5[1-5][0-9]{14}$"
        ], [
            "name": "NCard",
            "regex": ""
        ]
    ]
}
