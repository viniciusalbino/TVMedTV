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
    
    func parameters(card: CreditCard, valorFrete: Float, totalValue: Float) -> JSONDictionary {
        var parameters: JSONDictionary = [
            "carrinhoPrecoTotal" : totalProducts(),
            "valorFrete" : Int(valorFrete),
            "valorTotalPedido" : Int(totalValue),
            "descontoTotal" : descontoTotal,
            "percentualDesconto" : 0,
            "formasPagamentoResposta" : 1,
            "formasPagamentoDisplay" : formasPagamentoDisplay.length() > 0 ?  formasPagamentoDisplay : "",
            "observacoes": "",
            "formaPagamento" : 1,
            "tipoPagto" : 1,
        ]
        _ = parameters.addDictionary(dictionaryToAppend: card.parameters())
        var shippingParameters = [JSONDictionary]()
        for item in itemsCarrinho {
            shippingParameters.append(item.parameter(price: self.orderTotalPrice()))
        }
        _ = parameters.addDictionary(dictionaryToAppend: ["itensCarrinho": shippingParameters])
        return parameters
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
