//
//  CartItem.swift
//  TVMed
//
//  Created by Vinicius Albino on 03/04/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class CartItem: Object {
    
    dynamic var congresso = 0
    dynamic var midia = 0
    dynamic var linhaTitulo = ""
    dynamic var urlImagem = ""
    dynamic var espec = ""
    dynamic var preco = 0
    
    func parameter(price: Float) -> JSONDictionary {
        return ["congresso" : congresso,
                "midia" :  midia,
                "linhaTitulo" : linhaTitulo,
                "urlImage" : urlImagem,
                "espec" : espec,
                "preco" :  Int(price),
                "desconto" : 0,
                "precoSemDesconto" : preco,
                "tipoMidia": midia]
    }
}
