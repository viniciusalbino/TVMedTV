//
//  HomeCategoryCell.swift
//  TVMed
//
//  Created by Vinicius Albino on 01/03/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation
import UIKit

class HomeCategoryCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel:UILabel!
    
    func fill(category:Categorie) {
        self.titleLabel.text = category.descricao
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if context.nextFocusedView == self {
            coordinator.addCoordinatedAnimations({
                UIView.animate(withDuration: 0.5, animations: {
                    self.layer.cornerRadius = 2
                    self.layer.borderColor = UIColor.white.cgColor
                    self.layer.borderWidth = 2
                })
            }, completion: nil)
        } else if context.previouslyFocusedView == self {
            coordinator.addCoordinatedAnimations({
                UIView.animate(withDuration: 0.5, animations: {
                    self.layer.borderColor = UIColor.clear.cgColor
                    self.layer.borderWidth = 0
                    self.layer.cornerRadius = 0
                })
            }, completion: nil)
        }
    }
}
