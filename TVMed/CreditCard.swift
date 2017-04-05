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

enum brand: Int {
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
            return "1"
        case .Mastercard:
            return "2"
        case .AmericanExpress:
            return "3"
        case .Dinners:
            return "4"
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
    
    func maskedCard() -> String {
        return ""
    }
    
    func parameters() -> JSONDictionary {
        return ["cartaoBandeira" : brand,
                "cartaoCodigoSeguranca" : cvv,
                "cartaoTitular" : name,
                "mesVencimentoResposta" : month,
                "anoVencimentoResposta" :year]
    }
}
