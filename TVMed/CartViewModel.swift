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
    private var cartItems = [CartItem]()
    
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
    
    func numberOfItensInSection(section: Int) -> Int {
        if section == 0 {
            return self.cartItems.count
        } else {
            return 1
        }
    }
    
    func cartCellForRow(row: Int) -> CartItem {
        return self.cartItems.object(index: row) ?? CartItem()
    }
}
