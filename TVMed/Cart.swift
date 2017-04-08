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
            "valorTotalPedito" : Int(totalValue),
            "descontoTotal" : descontoTotal,
            "partnerId" : partnerId.length() > 0 ? partnerId : "null",
            "percentualDesconto" : percentualDesconto,
            "especDesconto" : especDesconto.length() > 0 ? especDesconto : "",
            "formasPagamentoResposta" : formasPagamentoResposta.length() > 0 ? formasPagamentoResposta : "",
            "formasPagamentoDisplay" : formasPagamentoDisplay.length() > 0 ?  formasPagamentoDisplay : "",
            "observacoes": observacoes.length() > 0 ? observacoes : "",
            "formaPagamento" : formaPagamento.length() > 0 ? formaPagamento : "",
            "tipoPagto" : tipoPagto.length() > 0 ? tipoPagto : ""
        ]
        _ = parameters.addDictionary(dictionaryToAppend: card.parameters())
        var shippingParameters = [JSONDictionary]()
        for item in itemsCarrinho {
            shippingParameters.append(item.parameter())
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
