//
//  HomeEspecCell.swift
//  TVMed
//
//  Created by Vinicius Albino on 07/03/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation
import UIKit

class HomeSpecCell: UICollectionViewCell {
    
    @IBOutlet weak var image:UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel:UILabel!
    @IBOutlet weak var codeLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        image.clipsToBounds = false
        
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 0, height: -2)
        
        image.adjustsImageWhenAncestorFocused = true
    }
    
    func fill(item: Especiality) {
        if let url = URL(string: "https://tvmed.blob.core.windows.net/public/webplayer.tvmed.com.br/content/images/congresso/" + item.congressImage) {
            self.image.kf.setImage(with: url, placeholder: UIImage(named:"defaultImage"), options: nil, progressBlock: nil, completionHandler: nil)
        }
        self.titleLabel.text = item.descricao
        self.subtitleLabel.text = "\(item.prefixo) \(item.sufixo)"
        self.codeLabel.text = "\(item.codigo)"
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if context.nextFocusedView == self {
            coordinator.addCoordinatedAnimations({
                UIView.animate(withDuration: 0.5, animations: {
                    self.titleLabel.textColor = .black
                    self.subtitleLabel.textColor = .black
//                    self.layer.cornerRadius = 2
//                    self.layer.borderColor = UIColor.white.cgColor
//                    self.layer.borderWidth = 2
//                    self.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
                })
            }, completion: nil)
        } else if context.previouslyFocusedView == self {
            coordinator.addCoordinatedAnimations({
                UIView.animate(withDuration: 0.5, animations: {
                    self.titleLabel.textColor = .white
                    self.subtitleLabel.textColor = .white
//                    self.layer.borderColor = UIColor.clear.cgColor
//                    self.layer.borderWidth = 0
//                    self.layer.cornerRadius = 0
//                    self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                })
            }, completion: nil)
        }
    }
}
