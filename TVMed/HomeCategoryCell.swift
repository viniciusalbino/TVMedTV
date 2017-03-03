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
                    self.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
                })
            }, completion: nil)
        } else if context.previouslyFocusedView == self {
            coordinator.addCoordinatedAnimations({
                UIView.animate(withDuration: 0.5, animations: {
                    self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                })
            }, completion: nil)
        }
    }
}
