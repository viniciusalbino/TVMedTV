//
//  Cart.swift
//  TVMed
//
//  Created by Vinicius Albino on 03/04/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class Cart: Object {
    
    var itemsCarrinho = List<CartItem>()
    dynamic var carrinhoPrecoTotal = 0
    dynamic var valorFrete = 0
    dynamic var descontoTotal = 0
    dynamic var partnerId = ""
    dynamic var percentualDesconto = 0
    dynamic var especDesconto = ""
    dynamic var creditCard: CreditCard?
    dynamic var formasPagamentoResposta = ""
    dynamic var formasPagamentoDisplay = ""
    dynamic var observacoes = ""
    dynamic var formaPagamento = ""
    dynamic var tipoPagto = ""
    
    func parameters() -> JSONDictionary {
        var parameters: JSONDictionary = [
            "carrinhoPrecoTotal" : carrinhoPrecoTotal,
            "valorFrete" : valorFrete,
            "valorTotalPedito" : orderTotalPrice(),
            "descontoTotal" : descontoTotal,
            "partnerId" : partnerId,
            "percentualDesconto" : percentualDesconto,
            "especDesconto" : especDesconto,
            "formasPagamentoResposta" : formasPagamentoResposta,
            "formasPagamentoDisplay" : formasPagamentoDisplay,
            "observacoes": observacoes,
            "formaPagamento" : formaPagamento,
            "tipoPagto" : tipoPagto
        ]
        if let card = creditCard {
            _ = parameters.addDictionary(dictionaryToAppend: card.parameters())
        }
        let params = itemsCarrinho.forEach{$0.parameter()}
        _ = parameters.addDictionary(dictionaryToAppend: ["itensCarrinho" : params])
        
        return parameters
    }
    
    func orderTotalPrice() -> Int {
        let total = itemsCarrinho.map{$0.preco}.reduce(0, +)
        return valorFrete + total
    }
}
