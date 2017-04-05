//
//  CartPersister.swift
//  TVMed
//
//  Created by Vinicius Albino on 03/04/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation
import RealmSwift

class CartPersister {
    private let realmPersister = RealmPersister()
    
    func saveCart(cart: Cart, callback: @escaping (_ success: Bool) -> Void) {
        realmPersister.saveUnique(object: cart) { success in
            callback(success)
        }
    }
    
    func delete(callback: @escaping (_ success: Bool) -> Void) {
        realmPersister.deleteAllObjects(ofType: Cart.self) { success in
            callback(success)
        }
    }
    
    func query(callback: @escaping (Cart?) -> Void) {
        realmPersister.queryUnique(type:  Cart.self) { success, object in
            if success, let cart = object {
                callback(cart)
            } else {
                callback(nil)
            }
        }
    }
}
