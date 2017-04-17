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
    func changedCard(success: Bool, card: RemoteCreditCard?)
}

class CreditCardsViewModel {
    
    var delegate: CreditCardDelegate?
    private var creditCardPersister = CreditCardPersister()
    private var creditCards = [RemoteCreditCard]()
    private var userRequest = UserRequests()
    
    init(delegate: CreditCardDelegate) {
        self.delegate = delegate
    }
    
    func loadContent() {
        userRequest.getCreditCards { cards, error in
            guard error == nil, let creditCards = cards else {
                self.delegate?.contentDidFinishedLoading()
                return
            }
            self.creditCards = creditCards
            self.delegate?.contentDidFinishedLoading()
        }
    }
    
    func numberOfSections() -> Int {
        return 3
    }
    
    func numberOfItensInSection(section: Int) -> Int {
        if section == 0 {
            return self.creditCards.count
        } else {
            return 1
        }
    }
    
    func cardForRow(row: Int) -> RemoteCreditCard {
        return self.creditCards.object(index: row) ?? RemoteCreditCard()
    }
    
    func setPrimaryCard(card: RemoteCreditCard) {
        self.userRequest.changeCreditCard(cardId: card) { cards, error in
            guard error == nil, let creditCards = cards else {
                self.delegate?.changedCard(success: false, card: nil)
                return
            }
            self.creditCards = creditCards
            self.delegate?.changedCard(success: true, card: card)
        }
    }
}
