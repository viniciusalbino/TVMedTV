//
//  HomeSections.swift
//  TVMed
//
//  Created by Vinicius Albino on 23/02/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation
import UIKit

enum HomeSections: Int {
    case categories
    case releases
    case catalog
    
    init(rawValue: Int) {
        switch rawValue {
        case 0:
            self = .categories
        case 1:
            self = .releases
        default:
            self = .catalog
        }
    }
    
    func heightForCellAtIndex() -> CGFloat {
        switch self {
        case .categories:
            return 120
        default :
            return 460
        }
    }
    
    static let allValues = [categories, releases, catalog]
}
