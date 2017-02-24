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
        // These properties are also exposed in Interface Builder.
        image.adjustsImageWhenAncestorFocused = true
        image.clipsToBounds = false
        
        self.titleLabel.tag = 10
        self.descrLabel.tag = 11
    }
    
    func fill(item: Release) {
        self.titleLabel.text = item.titulo
        self.descrLabel.text = item.descricao
        self.serialNumberLabel.text = item.numero
        if let url = URL(string: item.image) {
            self.image.kf.setImage(with:url)
        }
    }
}
