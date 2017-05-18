//
//  WorkResult.swift
//  TVMed
//
//  Created by Vinicius Albino on 17/05/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class WorkResult: Object, Mappable {
    
    dynamic var status = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        status <- map["status"]
    }
    
    override static func primaryKey() -> String? {
        return "status"
    }
}
