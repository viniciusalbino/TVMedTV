//
//  CreditCardsViewModel.swift
//  TVMed
//
//  Created by Vinicius de Moura Albino on 08/04/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation

protocol CreditCardDelegate: class {
    func contentDidFinishedLoading()
}

class CreditCardsViewModel {
    
    var delegate: CreditCardDelegate?
    private var creditCardPersister = CreditCardPersister()
    private var creditCards = [CreditCard]()
    
    init(delegate: CreditCardDelegate) {
        self.delegate = delegate
    }
    
    func loadContent() {
        creditCardPersister.query { cards in
            if let savedCards = cards {
                self.creditCards = savedCards
            }
            self.delegate?.contentDidFinishedLoading()
        }
    }
    
    func numberOfSections() -> Int {
        return 2
    }
    
    func numberOfItensInSection(section: Int) -> Int {
        if section == 0 {
            return self.creditCards.count
        } else {
            return 1
        }
    }
    
    func cardForRow(row: Int) -> CreditCard {
        return self.creditCards.object(index: row) ?? CreditCard()
    }
}
