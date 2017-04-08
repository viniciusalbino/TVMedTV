//
//  ValidationObjects.swift
//  Zattini
//
//  Created by Christopher John Morris on 8/4/15.
//  Copyright (c) 2015 Netshoes. All rights reserved.
//

import Foundation

class ValidatingObject: NSObject {
    func isValid() -> Bool {
        return true
    }
}

class ValidatingString: ValidatingObject {
    let stringToValidate: String?
    
    init(stringToValidate: String?) {
        self.stringToValidate = stringToValidate
    }
}

class ValidatingCreditCard: ValidatingString {
    override func isValid() -> Bool {
        return true
    }
}
