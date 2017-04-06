//
//  RealmPersister.swift
//  Shoestock
//
//  Created by Filipe Augusto de Souza Fragoso on 24/01/17.
//  Copyright © 2017 Netshoes. All rights reserved.
//

import Foundation
import RealmSwift

class RealmPersister: Object {
    
    private static let serialQueue = DispatchQueue(label: "br.com.tvMedTV")
    
    //mark: Saving Methods
    func saveUnique<T: Object>(object: T, completion: @escaping (_ success: Bool) -> Void) {
        deleteAllObjects(ofType: T.self) { deleteSuccess in
            if deleteSuccess {
                self.saveObjects(objects: [object]) { saveSucess in
                    saveSucess ? completion(true) : completion(false)
                }
            } else {
                completion(false)
            }
        }
    }
    
    func saveObjects<T: Object>(objects: [T]?, completion: @escaping (_ success: Bool) -> Void) {
            RealmPersister.serialQueue.async {
            if T.primaryKey() == nil {
                self.saveNonUniqueObjects(objects: objects) { success in
                    completion(success)
                }
            } else {
                self.saveUniqueObjects(objects: objects) { success in
                    completion(success)
                }
            }
        }
    }
    
    private func saveNonUniqueObjects(objects: [Object]?, completion: @escaping (_ success: Bool) -> Void) {
        guard let objects = objects, !objects.isEmpty else {
            completion(false)
            return
        }
        do {
            let realm = try RealmEncrypted.realm()
            try realm.write {
                realm.add(objects)
                completion(true)
            }
        } catch {
            completion(false)
            print("Realm did not write objects! \(objects)")
        }
    }
    
    private func saveUniqueObjects(objects: [Object]?, completion: @escaping (_ success: Bool) -> Void) {
        guard let objects = objects, !objects.isEmpty else {
            completion(false)
            return
        }
        do {
            let realm = try RealmEncrypted.realm()
            try realm.write {
                realm.add(objects, update: true)
                completion(true)
            }
        } catch {
            completion(false)
            print("Realm did not write objects! \(objects)")
        }
    }
    
    //mark: Deleting Methods
    func deleteObjects(objects: [Object]?, completion: @escaping (_ success: Bool) -> Void) {
        RealmPersister.serialQueue.async {
            self.delete(objects: objects) { sucess in
                completion(sucess)
            }
        }
    }
    
    func deleteAllObjects<T: Object>(ofType type: T.Type, completion: @escaping (_ success: Bool) -> Void) {
        RealmPersister.serialQueue.async {
            do {
                let realm = try RealmEncrypted.realm()
                self.delete(objects: Array(realm.objects(T.self))) { success in
                    completion(success)
                }
            } catch {
                print("Realm did not delete objects of type \(T())!")
                completion(false)
            }
         }
    }
    
    private func delete(objects: [Object]?, completion: @escaping (_ success: Bool) -> Void) {
        guard let objects = objects, !objects.isEmpty else {
            completion(true)
            return
        }
        do {
            let realm = try RealmEncrypted.realm()
            try realm.write {
                realm.delete(objects)
                completion(true)
            }
        } catch {
            print("Realm did not delete objects! \(objects)")
            completion(false)
        }
    }
    
    //mark: Querying Methods
    func query<T: Object>(type: T.Type, completion: @escaping (_ success: Bool, _ objects: [T]?) -> Void) {
        RealmPersister.serialQueue.async {
            do {
                let realm = try RealmEncrypted.realm()
                let objects = Array(realm.objects(T.self))
                objects.isEmpty ? completion(false, nil) : completion(true, objects)
            } catch {
                completion(false, nil)
                print("Realm did not query objects!")
            }
        }
    }
    
    func queryUnique<T: Object>(type: T.Type, completion: @escaping (_ success: Bool, _ object: T?) -> Void) {
        RealmPersister.serialQueue.async {
            do {
                let realm = try RealmEncrypted.realm()
                let object = realm.objects(T.self).first
                completion(object != nil, object)
            } catch {
                print("Realm did not query objects!")
                completion(false, nil)
            }
        }

    }
    
    func wipeAllPerstience(completion: @escaping (_ success: Bool) -> Void) {
        RealmPersister.serialQueue.async {
            do {
                let realm = try RealmEncrypted.realm()
                try realm.write {
                    realm.deleteAll()
                    completion(true)
                }
            } catch {
                print("Realm did not wipe persitence!")
                completion(false)
            }
        }
    }
}
