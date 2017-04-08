//
//  CreditCardPersister.swift
//  TVMed
//
//  Created by Vinicius de Moura Albino on 07/04/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation
import RealmSwift

class CreditCardPersister {
    private let realmPersister = RealmPersister()

    
    func save(card: CreditCard, callback: @escaping (_ success: Bool) -> Void) {
        realmPersister.saveObjects(objects: [card]) { succes in
            callback(succes)
        }
    }
    
    func delete(callback: @escaping (_ success: Bool) -> Void) {
        realmPersister.deleteAllObjects(ofType: Cart.self) { success in
            callback(success)
        }
    }
    
    func query(callback: @escaping ([CreditCard]?) -> Void) {
        realmPersister.query(type: CreditCard.self) { success, objects in
            if success, let cards = objects {
                callback(cards)
            } else {
                callback(nil)
            }
        }
    }
}
