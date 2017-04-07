//
//  CartCell.swift
//  TVMed
//
//  Created by Vinicius de Moura Albino on 05/04/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation
import UIKit

class CartCell: UITableViewCell {
    
    @IBOutlet weak var congressImage:UIImageView!
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var priceLabel:UILabel!
    
    func fill(cartItem: CartItem) {
        self.titleLabel.text = cartItem.linhaTitulo
        print(cartItem.linhaTitulo)
    }
}
