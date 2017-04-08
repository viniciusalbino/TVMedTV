//
//  CardCell.swift
//  TVMed
//
//  Created by Vinicius de Moura Albino on 08/04/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation
import UIKit

class CardCell: UITableViewCell {
    @IBOutlet weak var brandImage: UIImageView!
    @IBOutlet weak var cardNumber: UILabel!
    @IBOutlet weak var cardName:UILabel!
    @IBOutlet weak var cardValidation:UILabel!
    
    func fill(card: CreditCard) {
        self.cardName.text = card.name
        self.cardNumber.text = card.maskedCard()
        self.cardValidation.text = card.validationMasked()
        self.brandImage.image = UIImage(named: card.brandImage)
    }
}
