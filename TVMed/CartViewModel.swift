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
    func finishedLoadingShipping()
    func finishedPurchasingProducts(success: Bool)
}

class CartViewModel {
    
    weak var delegate: CartDelegate?
    private var cartPersister = CartPersister()
    private var currentCart: Cart?
    private var currentShippingValue:Float = 0.0
    private var cartItems = [CartItem]()
    private var userRequest = UserRequests()
    private var checkoutRequest = CheckoutRequest()
    private var currentUser:User?
    
    init(delegate: CartDelegate) {
        self.delegate = delegate
    }
    
    func loadCart() {
        self.cartItems = [CartItem]()
        DispatchQueue.main.async {
            do {
                let realm = try RealmEncrypted.realm()
                let objects = Array(realm.objects(Cart.self))
                if let cart = objects.first {
                    self.currentCart = cart
                    for item in cart.itemsCarrinho {
                        self.cartItems.append(item)
                    }
                    self.delegate?.contentDidFinishedLoading(success: true)
                    self.getFreteValue(numberOfItens: self.cartItems.count)
                } else {
                    self.delegate?.contentDidFinishedLoading(success: false)
                }
            } catch {
                self.delegate?.contentDidFinishedLoading(success: false)
                print("Realm did not query objects!")
            }
        }
    }
    
    func getFreteValue(numberOfItens: Int) {
        guard numberOfItens > 0 else {
            return
        }
        self.userRequest.requestUserData { user,error in
            guard error == nil, let userData = user else {
                return
            }
            self.currentUser = userData
            self.checkoutRequest.calculateShipping(state: userData.estado, quantity: numberOfItens, callback: { valor, error in
                guard error == nil else {
                    return
                }
                self.currentShippingValue = valor
                self.delegate?.finishedLoadingShipping()
            })
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
    
    func getResume() -> ResumeDTO {
        guard let cart = currentCart else {
            return ResumeDTO()
        }
        let total = cart.orderTotalPrice() + self.currentShippingValue
        return ResumeDTO(totalProducts: "\(cart.totalProducts().currencyValue)", totalFrete: "\(self.currentShippingValue.currencyValue)", total: "\(total.currencyValue)", discount: "\(cart.discount())")
    }
    
    func cleanCart() {
        cartPersister.delete { success in
            if success {
                self.currentCart = nil
                self.cartItems = [CartItem]()
            }
            DispatchQueue.main.async {
                self.delegate?.contentDidFinishedLoading(success: true)
            }
        }
    }
    
    func continueCheckout() {
        guard let user = currentUser, let cart = currentCart else {
            self.delegate?.finishedPurchasingProducts(success: false)
            return
        }
        
        if let creditCard = cart.creditCard {
            
        } else {
            //present credit card flow
        }
    }
    
    func makePurchase(cart: Cart) {
        
        checkoutRequest.makePayment(cart: cart) { checkoutResponse, error in
            guard error == nil, let response = checkoutResponse else {
                self.delegate?.finishedPurchasingProducts(success: false)
                return
            }
            
        }
    }
}
