//
//  CongressDetailController.swift
//  TVMed
//
//  Created by Vinicius Albino on 16/03/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation
import UIKit

class CongressDetailController: UIViewController, CongressDetailDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var discountPrice: UILabel!
    @IBOutlet weak var finalPrice: UILabel!
    @IBOutlet weak var decriptionTextView: UITextView!
    @IBOutlet weak var congressImage: UIImageView!
    
    lazy var viewModel: CongressDetailViewModel = CongressDetailViewModel(delegate: self)
    
    func loadCongress(congressID: String) {
        DispatchQueue.main.async {
            self.viewModel.loadContent(id: congressID)
        }
    }
    
    func contentDidFinishedLoading(succes: Bool) {
        if succes {
            
        } else {
            
        }
    }
}
