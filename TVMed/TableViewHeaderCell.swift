//
//  TopicHeader.swift
//  TVMed
//
//  Created by Vinicius de Moura Albino on 15/04/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation
import UIKit

class TableViewHeaderCell: UITableViewHeaderFooterView {
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.layer.cornerRadius = 4
    }
    
    func fill(text: String) {
        self.titleLabel.text = text
    }
}
