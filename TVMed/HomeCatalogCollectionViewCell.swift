//
//  HomeCatalogCollectionViewCell.swift
//  TVMed
//
//  Created by Vinicius Albino on 23/02/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class HomeCatalogCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image:UIImageView!
    @IBOutlet weak var serialNumberLabel:UILabel!
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var descrLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        image.clipsToBounds = false
        
        self.titleLabel.tag = 10
        self.descrLabel.tag = 11
        
        serialNumberLabel.layer.cornerRadius = 2
        serialNumberLabel.layer.masksToBounds = true
        
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 0, height: -2)
    }
    
    func fill(item: Release) {
        self.titleLabel.text = item.titulo
        self.descrLabel.text = item.descricao
        self.serialNumberLabel.text = "\(item.congresso)"
        if let url = URL(string: item.image) {
            self.image.kf.setImage(with:url)
        }
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
