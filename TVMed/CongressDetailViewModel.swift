//
//  CongressDetailViewModel.swift
//  TVMed
//
//  Created by Vinicius Albino on 16/03/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation

protocol CongressDetailDelegate: class {
    func contentDidFinishedLoading(succes: Bool)
    func addedToCart(success: Bool)
}

class CongressDetailViewModel {
    
    private weak var delegate: CongressDetailDelegate?
    private var midias = [MidiaPromotion]()
    private var currentMidia: MidiaPromotion?
    private var selectedMidiaIndex = 0
    private var cartPersister = CartPersister()
    
    init(delegate: CongressDetailDelegate) {
        self.delegate = delegate
    }
    
    func loadContent(id: String) {
        let request = EspecialityRequest()
        
        request.getMidiaCongress(congressID: id) { content, error in
            guard error == nil, let midias = content else {
                self.delegate?.contentDidFinishedLoading(succes: false)
                return
            }
            self.midias = midias
            self.delegate?.contentDidFinishedLoading(succes: true)
        }
    }
    
    func loadMidiaPromotion(id: String) {
        let request = NewReleasesRequest()
        request.getMidiaPromotion(congressoId: id) { content, error in
            guard error == nil, let midias = content else {
                self.delegate?.contentDidFinishedLoading(succes: false)
                return
            }
            self.midias = midias
            self.delegate?.contentDidFinishedLoading(succes: true)
        }
    }
    
    func getCurrentMidia() -> MidiaPromotion {
        guard self.midias.count > 0, let midia = midias.object(index: selectedMidiaIndex) else {
            return MidiaPromotion()
        }
        return midia
    }
    
    func numberOfItensInSection() -> Int {
        return self.midias.count
    }
    
    func midiaForRow(row: Int) -> MidiaPromotion {
        return self.midias.object(index: row) ?? MidiaPromotion()
    }
    
    func setSelectedMidiaIndex(index: Int) {
        self.selectedMidiaIndex = index
        self.currentMidia = midiaForRow(row: index)
    }
    
    func setMidia(midia: MidiaPromotion) {
        self.currentMidia = midia
        self.midias = [midia]
        self.delegate?.contentDidFinishedLoading(succes: true)
    }
    
    func addToCart() {
        cartPersister.query { cart in
            if let currentCart = cart {
                currentCart.itemsCarrinho.append(self.mountCartItem())
                self.cartPersister.saveCart(cart: currentCart, callback: { success in
                    self.delegate?.addedToCart(success: success)
                })
            } else {
                self.mountNewCart()
            }
        }
    }
    
    func mountNewCart() {
        let cart = Cart()
        cart.itemsCarrinho.append(mountCartItem())
        cartPersister.saveCart(cart: cart) { success in
            self.delegate?.addedToCart(success: success)
        }
    }
    
    func mountCartItem() -> CartItem {
        let cartItem = CartItem()
        if let midia = currentMidia {
            cartItem.congresso = midia.congresso
            cartItem.espec = midia.espec
            cartItem.linhaTitulo = midia.nomeCongresso
            cartItem.midia = midia.midia
            cartItem.preco = midia.getMidiaIntegerPrice()
            cartItem.urlImagem = midia.imagemHtml
        }
        return cartItem
    }
}
