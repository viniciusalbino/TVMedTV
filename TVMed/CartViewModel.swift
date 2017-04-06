//
//  CartViewModel.swift
//  TVMed
//
//  Created by Vinicius de Moura Albino on 05/04/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation

protocol CartDelegate: class {
    func contentDidFinishedLoading(success: Bool)
}

class CartViewModel {
    
    weak var delegate: CartDelegate?
    private var cartPersister = CartPersister()
    
    init(delegate: CartDelegate) {
        self.delegate = delegate
    }
    
    func loadCart() {
        cartPersister.query { cart in
            if let currentCart = cart {
                self.delegate?.contentDidFinishedLoading(success: true)
                print(currentCart)
            } else {
                self.delegate?.contentDidFinishedLoading(success: false)
            }
        }
    }
}
