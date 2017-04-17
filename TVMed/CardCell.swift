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
    
    func fill(card: RemoteCreditCard) {
//        self.cardName.text = card.name
        self.cardNumber.text = card.numero
//        self.cardValidation.text = card.validationMasked()
        let brandEnum = BrandEnum(rawValue: card.bandeira)
        
        self.brandImage.image = UIImage(named: brandEnum.stringValue)
    }
}
