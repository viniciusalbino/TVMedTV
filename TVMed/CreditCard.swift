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

enum BrandEnum: String {
    case Visa
    case Mastercard
    case AmericanExpress
    case Dinners
    
    init(rawValue: String) {
        switch rawValue {
        case "Visa":
            self = .Visa
        case "MasterCard":
            self = .Mastercard
        case "American Express":
            self = .AmericanExpress
        case "Dinners Club":
            self = .Dinners
        default :
            self = .Mastercard
        }
    }
    
    var intValue: Int {
        switch self {
        case .Visa:
            return 1
        case .Mastercard:
            return 2
        case .AmericanExpress:
            return 3
        case .Dinners:
            return 4
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
        return ""
    }
    
    func validationMasked() -> String {
        return "\(month)/\(year)"
    }
    
    func parameters() -> JSONDictionary {
        return ["cartaoBandeira" : brand,
                "cartaoCodigoSeguranca" : cvv,
                "cartaoTitular" : name,
                "mesVencimentoResposta" : month,
                "anoVencimentoResposta" :year]
    }
}
