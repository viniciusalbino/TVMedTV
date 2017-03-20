//
//  MidiaPromotion.swift
//  TVMed
//
//  Created by Vinicius Albino on 07/03/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

//{
//    "congresso": 8929,
//    "midia": 1,
//    "espec": "ONC",
//    "precoTipoMidia0": 600,
//    "precoTipoMidia1": 600,
//    "precoTipoMidia2": 650,
//    "precoTipoMidia3": 50,
//    "percentualDesconto": 0,
//    "nomeCongresso": "VIDEO CD- XI SIMPÓSIO DE PET/CT EM ONCOLOGIA/16",
//    "sinopse": "",
//    "prefixo": "(VCD)",
//    "sufixo": "",
//    "imagemHtml": "vcd.png",
//    "tipoMidia": 2,
//    "cna": false,
//    "videoDisponivel": true,
//    "videoProduzido": false,
//    "associacaoGratuito": false,
//    "cnaDisponivel": false,
//    "cnaTempoLimite": 0,
//    "clienteComprouParaAssistirOnLine": false,
//    "congaovivo": false,
//    "comSlide": false,
//    "ultimoEvento": null
//}
import Foundation
import ObjectMapper

struct MidiaPromotion: Mappable {
    var congresso = 0
    var midia = 0
    var espec = ""
    var precoTipoMidia0: Float = 0.0
    var precoTipoMidia1: Float = 0.0
    var precoTipoMidia2: Float = 0.0
    var precoTipoMidia3: Float = 0.0
    var percentualDesconto = 0
    var nomeCongresso = ""
    var sinopse = ""
    var prefixo = ""
    var sufixo = 0
    var imagemHtml = ""
    var tipoMidia = 0
    var cna = false
    var videoDisponivel = false
    var videoProduzido = false
    var associacaoGratuito = false
    var cnaDisponivel = false
    var cnaTempoLimite = 0
    var clienteComprouParaAssistirOnLine = false
    var congaovivo = false
    var comSlide = false
    var ultimoEvento = Date()
    
    init?(map: Map) {
        mapping(map: map)
    }
    
    init() {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        congresso        <- map["congresso"]
        midia  <- map["midia"]
        espec  <- map["espec"]
        precoTipoMidia0    <- map["precoTipoMidia0"]
        precoTipoMidia1 <- map["precoTipoMidia1"]
        precoTipoMidia2        <- map["precoTipoMidia2"]
        precoTipoMidia3          <- map["precoTipoMidia3"]
        percentualDesconto  <- map["percentualDesconto"]
        nomeCongresso    <- map["nomeCongresso"]
        sinopse <- map["sinopse"]
        prefixo        <- map["prefixo"]
        sufixo  <- map["sufixo"]
        imagemHtml  <- map["imagemHtml"]
        cna    <- map["cna"]
        videoDisponivel <- map["videoDisponivel"]
        videoProduzido        <- map["videoProduzido"]
        associacaoGratuito          <- map["associacaoGratuito"]
        cnaDisponivel  <- map["cnaDisponivel"]
        cnaTempoLimite    <- map["cnaTempoLimite"]
        clienteComprouParaAssistirOnLine <- map["clienteComprouParaAssistirOnLine"]
        congaovivo  <- map["congaovivo"]
        comSlide    <- map["comSlide"]
        ultimoEvento <- map["ultimoEvento"]
    }
    
    func formattedSubtitle() -> String {
        return "Categoria : \(espec)"
    }
    
    func formattedDescription() -> String {
        return sinopse.replacingOccurrences(of: "\\n", with: "\n")
    }
    
    func hasDiscount() -> Bool {
        return percentualDesconto > 0
    }
    
    func discountPercentage() -> String {
        let prices = [precoTipoMidia0, precoTipoMidia1, precoTipoMidia2, precoTipoMidia3]
        if let price = prices.object(index: tipoMidia) {
            let discount = price / Float(percentualDesconto)
            return (price - discount).currencyValue
        }
        return ""
    }
    
    func getMidiaPrice() -> String {
        let prices = [precoTipoMidia0, precoTipoMidia1, precoTipoMidia2, precoTipoMidia3]
        if let price = prices.object(index: tipoMidia) {
            return price.currencyValue
        }
        return "R$ 0,00"
    }
}
