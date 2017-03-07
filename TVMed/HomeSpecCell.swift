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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        image.clipsToBounds = false
        
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 0, height: -2)
    }
    
    func fill(item: Especiality) {
        if let url = URL(string: "https://tvmed.blob.core.windows.net/public/webplayer.tvmed.com.br/content/images/congresso/" + item.congressImage) {
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
