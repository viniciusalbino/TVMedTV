//
//  TopicCell.swift
//  TVMed
//
//  Created by Vinicius de Moura Albino on 15/04/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation
import UIKit

class TopicCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playButton: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.cornerRadius = 2
        self.titleLabel.layer.cornerRadius = 2
        self.playButton.isHidden = true
    }
    
    func fill(text: String) {
        self.titleLabel.text = text
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if context.nextFocusedView == self {
            coordinator.addCoordinatedAnimations({
                UIView.animate(withDuration: 0.3, animations: {
                    self.titleLabel.textColor = .white
                    self.playButton.isHidden = false
//                    self.contentView.backgroundColor = UIColor(hexString: "##105133")
                })
            }, completion: nil)
        } else if context.previouslyFocusedView == self {
            coordinator.addCoordinatedAnimations({
                UIView.animate(withDuration: 0.3, animations: {
                    self.titleLabel.textColor = UIColor(hexString: "#9D7040")
                    self.playButton.isHidden = true
//                    self.contentView.backgroundColor = .white
                })
            }, completion: nil)
        }
    }
}
