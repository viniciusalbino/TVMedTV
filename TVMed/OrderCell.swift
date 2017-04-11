//
//  OrderCell.swift
//  TVMed
//
//  Created by Vinicius Albino on 29/03/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation

import UIKit
import Kingfisher

class OrderCell: UICollectionViewCell {
    
    @IBOutlet weak var image:UIImageView!
    @IBOutlet weak var serialNumberLabel:UILabel!
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var descrLabel:UILabel!
    
    override func awakeFromNib( ) {
        super.awakeFromNib()
        image.clipsToBounds = false
        
        self.titleLabel.tag = 10
        self.descrLabel.tag = 11
        
        serialNumberLabel.layer.cornerRadius = 2
        serialNumberLabel.layer.masksToBounds = true
        
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 0, height: -2)
        
        image.adjustsImageWhenAncestorFocused = true
    }
    
    func fill(item: MidiaPromotion) {
        self.titleLabel.text = item.nomeCongresso
        self.descrLabel.text = item.formattedSubtitle()
        self.serialNumberLabel.text = "\(item.congresso)"
        if let url = URL(string: item.imagemHtml) {
            self.image.kf.setImage(with: url, placeholder: UIImage(named:"defaultImage"), options: nil, progressBlock: nil, completionHandler: nil)
        }
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if context.nextFocusedView == self {
            coordinator.addCoordinatedAnimations({
                UIView.animate(withDuration: 0.5, animations: {
                    self.titleLabel.textColor = .black
                    self.descrLabel.textColor = .black
//                    self.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
                })
            }, completion: nil)
        } else if context.previouslyFocusedView == self {
            coordinator.addCoordinatedAnimations({
                UIView.animate(withDuration: 0.5, animations: {
                    self.titleLabel.textColor = .white
                    self.descrLabel.textColor = .white
//                    self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                })
            }, completion: nil)
        }
    }
}
