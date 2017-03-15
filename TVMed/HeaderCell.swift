//
//  HeaderCell.swift
//  TVMed
//
//  Created by Vinicius Albino on 14/03/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation
import UIKit

class HeaderCell: UICollectionReusableView {
    @IBOutlet weak var titleLabel: UILabel!
    
    func fill(title: String) {
        self.titleLabel.text = title
    }
}
