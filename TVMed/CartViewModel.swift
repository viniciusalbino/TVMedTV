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
    func presentCardsSegue()
    func updatedCart()
}

class CartViewModel {
    
    weak var delegate: CartDelegate?
    private var cartPersister = CartPersister()
    private var currentCart: Cart?
    private var currentShippingValue:Float = 0.0
    var cartItems = [CartItem]()
    private var userRequest = UserRequests()
    private var checkoutRequest = CheckoutRequest()
    private var currentUser:User?
    private var creditCardPersister = CreditCardPersister()
    
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
    
    func totalValue() -> [String] {
        guard let cart = currentCart else {
            return [""]
        }
        let total = cart.orderTotalPrice() + self.currentShippingValue
        var texts = [String]()
        var i = 1
        while i < 100 {
            let dividend = total / Float(i)
            texts.append("\(i)x = \(dividend.currencyValue)")
            if dividend >= 100.0 {
                i += 1
            } else {
                break
            }
        }
        texts.removeFirst()
        texts.removeLast()
        texts.insert("A vista = \(total.currencyValue)", at: 0)
        return texts
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
        guard let _ = currentUser else {
            self.delegate?.finishedPurchasingProducts(success: false)
            return
        }
        
        //show creditcards tableview
        self.delegate?.presentCardsSegue()
    }
    
    func makePurchase(creditCard: RemoteCreditCard, formaPagamento: String) {
        guard let cart = currentCart else {
            self.delegate?.finishedPurchasingProducts(success: false)
            return
        }
        let total = cart.orderTotalPrice() + self.currentShippingValue
        let params = cart.parameters(card: creditCard, valorFrete:self.currentShippingValue, totalValue: total, formaPagamento: formaPagamento)
        print(params)
        
        checkoutRequest.makePayment(cartParameters: params) { checkoutResponse, error in
            guard error == nil, let _ = checkoutResponse else {
                self.delegate?.finishedPurchasingProducts(success: false)
                return
            }
            self.cleanCart()
            self.delegate?.finishedPurchasingProducts(success: true)
        }
    }
    
    func deleteItemFromCart(cartItem: CartItem) {
        guard let cart = currentCart else {
            return
        }
//        cartPersister.delete { _ in }
        var updatedCart = cart
        do {
            let realm = try RealmEncrypted.realm()
            try realm.write {
                
                for (index, item) in cart.itemsCarrinho.enumerated() {
                    if item.congresso == cartItem.congresso {
                        cart.itemsCarrinho.remove(objectAtIndex: index)
                    }
                }
                
                self.cartItems = [CartItem]()
                for item in cart.itemsCarrinho {
                    self.cartItems.append(item)
                }
                
                updatedCart.carrinhoPrecoTotal = cart.carrinhoPrecoTotal
                updatedCart.valorFrete = cart.valorFrete
                updatedCart.descontoTotal = cart.descontoTotal
                updatedCart.partnerId = cart.partnerId
                updatedCart.percentualDesconto = cart.percentualDesconto
                updatedCart.especDesconto = cart.especDesconto
                updatedCart.formaPagamento = cart.formaPagamento
                updatedCart.formasPagamentoResposta = cart.formasPagamentoResposta
                updatedCart.formasPagamentoDisplay = cart.formasPagamentoDisplay
                updatedCart.observacoes = cart.observacoes
                updatedCart.tipoPagto = cart.tipoPagto
                updatedCart.itemsCarrinho = cart.itemsCarrinho
                realm.add(updatedCart)
                self.loadCart()
            }
        } catch {
            self.delegate?.contentDidFinishedLoading(success: false)
        }
    }
}
