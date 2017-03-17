//
//  UIImageView+Extension.swift
//  TVMed
//
//  Created by Vinicius Albino on 15/03/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation
import Kingfisher
import UIKit

extension UIImageView {
    func setImage(url: String) {
        if let url = URL(string: url) {
            self.image.kf.setImage(with:url)
        }
    }
}
