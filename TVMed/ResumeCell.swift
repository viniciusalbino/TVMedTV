//
//  ResumeCell.swift
//  TVMed
//
//  Created by Vinicius de Moura Albino on 06/04/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation
import UIKit

struct ResumeDTO {
    var totalProducts = ""
    var totalFrete = ""
    var total = ""
    var discount = ""
}

class ResumeCell: UITableViewCell {
    
    @IBOutlet weak var totalProductsLabel: UILabel!
    @IBOutlet weak var totalFreteLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalDiscount: UILabel!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    func fill(dto: ResumeDTO) {
        if dto.total.length() > 0 {
            self.loadingView.stopAnimating()
            self.loadingView.isHidden = true
            self.totalProductsLabel.isHidden = false
            self.totalFreteLabel.isHidden = false
            self.totalLabel.isHidden = false
            
            self.totalProductsLabel.text = "TOTAL PRODUTOS : \(dto.totalProducts)"
            self.totalFreteLabel.text = "TOTAL FRETE : \(dto.totalFrete)"
            self.totalLabel.text = "TOTAL PEDIDO : \(dto.total)"
            if dto.discount.length() > 0 {
                self.totalDiscount.isHidden = false
                self.totalDiscount.text = "TOTAL DESCONTO : \(dto.discount)"
            } else {
                self.totalDiscount.isHidden = true
                self.totalDiscount.text = ""
            }
        } else {
            self.loadingView.startAnimating()
            self.loadingView.isHidden = false
            self.totalProductsLabel.isHidden = true
            self.totalLabel.isHidden = true
            self.totalFreteLabel.isHidden = true
            self.totalDiscount.isHidden = true
        }
    }
}
