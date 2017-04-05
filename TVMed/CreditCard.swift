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
