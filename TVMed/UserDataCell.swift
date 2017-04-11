//
//  UserDataCell.swift
//  TVMed
//
//  Created by Vinicius de Moura Albino on 10/04/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation
import UIKit

class UserDataCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel:UILabel!
    
    func fill(titleText: String, subtitle: String) {
        self.titleLabel.text = titleText
        self.detailLabel.text = subtitle
    }
}
