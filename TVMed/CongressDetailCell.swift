//
//  CongressDetailCell.swift
//  TVMed
//
//  Created by Vinicius Albino on 19/03/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation
import UIKit

class CongressDetailCell: UITableViewCell {
    
    static let reuseIdentifier = "CongressDetailCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    func fill(title: String, subTitle: String) {
        self.titleLabel.text = title
        self.subTitleLabel.text = subTitle
    }
//    
//    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
//        if self.isFocused {
//            self.titleLabel.textColor = .black
//            self.subTitleLabel.textColor = .black
//        } else {
//            self.titleLabel.textColor = .white
//            self.subTitleLabel.textColor = .white
//        }
//    }
}
