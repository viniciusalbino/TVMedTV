//
//  CreditCard.swift
//  TVMed
//
//  Created by Vinicius Albino on 03/04/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

enum BrandEnum: Int {
    case Visa
    case Mastercard
    case AmericanExpress
    case Dinners
    
    init(rawValue: Int) {
        switch rawValue {
        case 1:
            self = .Visa
        case 2:
            self = .Mastercard
        case 3:
            self = .AmericanExpress
        case 4:
            self = .Dinners
        default :
            self = .Mastercard
        }
    }
    
    var stringValue: String {
        switch self {
        case .Visa:
            return "Visa"
        case .Mastercard:
            return "MasterCard"
        case .AmericanExpress:
            return "American Express"
        case .Dinners:
            return "Dinners Club"
        }
    }
}

class CreditCard: Object {
    
    dynamic var cardNumber = ""
    dynamic var brand = 0
    dynamic var cvv = ""
    dynamic var name = ""
    dynamic var month = ""
    dynamic var year = ""
    dynamic var brandImage = ""
    
    func maskedCard() -> String {
        return cardNumber.maskCardNumber()
    }
    
    func validationMasked() -> String {
        return "\(month)/\(year)"
    }
    
    func parameters() -> JSONDictionary {
        return ["bandeira" : brand,
                "cvv" : cvv,
                "nomeTitular" : name,
                "mesVencimento" : month,
                "anoVencimento" :year,
                "numero" : cardNumber.trimWhiteSpaces()]
    }
}
