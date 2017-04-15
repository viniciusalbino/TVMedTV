//
//  CongressCell.swift
//  TVMed
//
//  Created by Vinicius de Moura Albino on 12/04/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation
import UIKit

protocol SelectedMidiaDelegate: class {
    func didSelectedMidia(row: Int, midiaIndex: Int)
}

class CongressCell: UIView {
    @IBOutlet weak var detailsTextView:FocusTextView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var midiaFisicaButton: UIButton!
    @IBOutlet weak var midiaOnlineButton: UIButton!
    @IBOutlet weak var midiaFisicaOnlineButton: UIButton!
    private weak var midiaDelegate:SelectedMidiaDelegate?
    private var currentIndex = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        midiaFisicaButton.tag = 0
        midiaOnlineButton.tag = 1
        midiaFisicaOnlineButton.tag = 2
    }
    
    func fill(midia: MidiaPromotion, delegate: UITextViewDelegate, midiaDelegate: SelectedMidiaDelegate, row: Int) {
        self.currentIndex = row
        self.midiaDelegate = midiaDelegate
        self.titleLabel.text = midia.congressoFormattedName()
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
    
    @IBAction func buyMidia(sender: UIButton) {
        self.midiaDelegate?.didSelectedMidia(row: currentIndex, midiaIndex: sender.tag)
    }
}
