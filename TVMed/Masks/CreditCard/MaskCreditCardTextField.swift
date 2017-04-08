//
//  MaskCreditCardTextField.swift
//  Zattini
//
//  Created by Christopher John Morris on 7/21/15.
//  Copyright (c) 2015 Concrete Solutions. All rights reserved.
//

import Foundation
import UIKit

let kAMXIdentifier34 = "34"
let kAMXIdentifier37 = "37"
let kVisaIdentifier = "4"
let kMasterCardIdentifier51 = "51"
let kMasterCardIdentifier52 = "52"
let kMasterCardIdentifier53 = "53"
let kMasterCardIdentifier54 = "54"
let kMasterCardIdentifier55 = "55"
let kHiperCardIdentifier60 = "60"
let kDinersClubCardIdentifier301 = "301"
let kDinersClubCardIdentifier302 = "302"
let kDinersClubCardIdentifier303 = "303"
let kDinersClubCardIdentifier304 = "304"
let kDinersClubCardIdentifier305 = "305"
let kDinersClubCardIdentifier36 = "36"
let kDinersClubCardIdentifier38 = "38"

let kSixteenDigitCreditCardMask = Mask(exampleMask: "#### #### #### ####", charactersToMask: [" "])
let kNineteenDigitCreditCardMask = Mask(exampleMask:  "#### #### #### #### ###", charactersToMask: [" "])
let kAMXDigitCreditCardMask = Mask(exampleMask:  "#### ###### #####", charactersToMask: [" "])

enum CreditCardFactory: String {
    case americanExpress = "American Express"
    case visa = "Visa"
    case mastercard = "MasterCard"
    case hipercard = "Hipercard"
    case dinnersClub = "Dinners Club"
    case elo = "Elo"
    case nCard = "NCard"
    
    var imageForCreditCardFlagIdentifier: UIImage {
        switch self {
        case .americanExpress:
            return UIImage(named: "American Express")!
        case .visa:
            return UIImage(named: "Visa")!
        case .mastercard:
            return UIImage(named: "MasterCard")!
        case .hipercard:
            return UIImage(named: "ic_cc_flag_hiper")!
        case .dinnersClub:
            return UIImage(named: "Dinners Club")!
        case .nCard:
            return UIImage(named: "ic_cc_flag_ncard")!
        default:
            return UIImage(named: "American Express")!
        }
    }
    
    var cvvLenght: Int {
        switch self {
        case .americanExpress:
            return 4
        default:
            return 3
        }
    }
}

class MaskCreditCardTextField: TextFieldMask {
    
    var creditCardValidator = CreditCardValidator()
    var type: String?
    
    override init() {
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.leftViewMode = .always
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 0, y: 9, width: 44, height: 44)
    }
    
    override func maskedCharacterSet() -> CharacterSet {
        return CharacterSet(charactersIn: "0123456789")
    }
    
    override func mask() -> Mask {
        switch identiferForProposedText(proposedText: aggregateString()) {
        case kAMXIdentifier34, kAMXIdentifier37:
            return kAMXDigitCreditCardMask
        case kVisaIdentifier,
        kMasterCardIdentifier51...kMasterCardIdentifier55,
        kDinersClubCardIdentifier38,
        kDinersClubCardIdentifier36,
        kDinersClubCardIdentifier301...kDinersClubCardIdentifier305:
            return kSixteenDigitCreditCardMask
        case kHiperCardIdentifier60:
            return kNineteenDigitCreditCardMask
        default:
            return kNineteenDigitCreditCardMask
        }
    }
    
    override func isValid() -> Bool {
        return creditCardValidator.validateString(string: currentText.replacingOccurrences(of: " ", with: "")) && type != nil
    }
    
    func identiferForProposedText(proposedText: String, aggregateID: String = "") -> String {
        if let identifier = identifierForProposedIdentifier(proposedID: aggregateID) {
            return identifier
        }
        if proposedText.characters.count == aggregateID.characters.count || proposedText.characters.count == 0 || aggregateID.characters.count > 5 {
            return ""
        }
        
        return identiferForProposedText(proposedText: proposedText, aggregateID: proposedText.substringToIndex(index: aggregateID.characters.count + 1))
    }
    
    func identifierForProposedIdentifier(proposedID: String) -> String? {
        if (bins().filter { $0 == proposedID }).count == 1 {
            return proposedID
        }
        return nil
    }
    
    func bins() -> [String] {
        return [
            kAMXIdentifier34,
            kAMXIdentifier37,
            kVisaIdentifier,
            kMasterCardIdentifier51,
            kMasterCardIdentifier52,
            kMasterCardIdentifier53,
            kMasterCardIdentifier54,
            kMasterCardIdentifier55,
            kHiperCardIdentifier60,
            kDinersClubCardIdentifier38,
            kDinersClubCardIdentifier36,
            kDinersClubCardIdentifier301,
            kDinersClubCardIdentifier302,
            kDinersClubCardIdentifier303,
            kDinersClubCardIdentifier304,
            kDinersClubCardIdentifier305
        ]
    }
    
    override func textChanged(textField: UITextField) {
        super.textChanged(textField: textField)
        if let type = creditCardValidator.typeFromString(string: currentText) {
            self.type = type.name
            guard let creditCard = CreditCardFactory(rawValue: type.name) else {
                noTypeFound()
                return
            }
            DispatchQueue.main.async {
                self.leftView = UIImageView(image: creditCard.imageForCreditCardFlagIdentifier)
            }
        } else {
            noTypeFound()
        }
    }
    
    private func noTypeFound() {
        DispatchQueue.main.async {
            self.leftView = nil
        }
        self.type = nil
    }
}
