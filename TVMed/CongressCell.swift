//
//  CongressCell.swift
//  TVMed
//
//  Created by Vinicius de Moura Albino on 12/04/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation
import UIKit

class CongressCell: UIView {
    @IBOutlet weak var detailsTextView:FocusTextView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var midiaFisicaButton: UIButton!
    @IBOutlet weak var midiaOnlineButton: UIButton!
    @IBOutlet weak var midiaFisicaOnlineButton: UIButton!
    
    func fill(midia: MidiaPromotion, delegate: UITextViewDelegate) {
        self.titleLabel.text = midia.nomeCongresso
        self.detailsTextView.delegate = delegate
        self.detailsTextView.text = midia.formattedDescription()
        detailsTextView.layer.cornerRadius = 5
        
        guard !midia.clienteComprouParaAssistirOnLine else {
            return
        }
        
        if midia.precoTipoMidia0 > 0 {
            self.midiaFisicaButton.isHidden = false
            self.midiaFisicaButton.setTitle("Comprar Midia Fisica \(midia.midiaPrice(index: 0).currencyValue)", for: .normal)
        }
        if midia.precoTipoMidia1 > 0 {
            self.midiaOnlineButton.isHidden = false
            self.midiaOnlineButton.setTitle("Comprar Midia Online \(midia.midiaPrice(index: 1).currencyValue)", for: .normal)
        }
        if midia.precoTipoMidia2 > 0 {
            self.midiaFisicaOnlineButton.isHidden = false
            self.midiaFisicaOnlineButton.setTitle("Comprar Fisica + Online \(midia.midiaPrice(index: 2).currencyValue)", for: .normal)
        }
    }
}
