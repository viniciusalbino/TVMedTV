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
    case especiality
    
    init(rawValue: Int) {
        switch rawValue {
        case 0:
            self = .categories
        case 1:
            self = .releases
        default:
            self = .especiality
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
    
    var title: String {
        switch self {
        case .categories:
            return "Categorias"
        case .releases:
            return "Lançamentos"
        default:
            return "Catálogo"
        }
    }
    
    static let allValues = [categories, releases, especiality]
}
