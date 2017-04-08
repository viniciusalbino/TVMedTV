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
    dynamic var carrinhoPrecoTotal: Float = 0.0
    dynamic var valorFrete:Float = 0.0
    dynamic var descontoTotal:Float = 0.0
    dynamic var partnerId = ""
    dynamic var percentualDesconto = 0
    dynamic var especDesconto = ""
    dynamic var formasPagamentoResposta = ""
    dynamic var formasPagamentoDisplay = ""
    dynamic var observacoes = ""
    dynamic var formaPagamento = ""
    dynamic var tipoPagto = ""
    
    func parameters(card: CreditCard) -> [String: AnyObject] {
        var parameters: JSONDictionary = [
            "carrinhoPrecoTotal" : carrinhoPrecoTotal,
            "valorFrete" : valorFrete,
            "valorTotalPedito" : Int(orderTotalPrice()),
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
        _ = parameters.addDictionary(dictionaryToAppend: card.parameters())
        let params = itemsCarrinho.forEach{$0.parameter()}
        _ = parameters.addDictionary(dictionaryToAppend: ["itensCarrinho" : params])
        
        return parameters as [String : AnyObject]
    }
    
    func orderTotalPrice() -> Float {
        let total = Float(itemsCarrinho.map{$0.preco}.reduce(0, +))
        return valorFrete + total
    }
    
    func totalProducts() -> Float {
        let total = Float(itemsCarrinho.map{$0.preco}.reduce(0, +))
        return total
    }
    
    func discount() -> String {
        if descontoTotal > 0 {
            return descontoTotal.currencyValue
        } else {
            return ""
        }
    }
}
