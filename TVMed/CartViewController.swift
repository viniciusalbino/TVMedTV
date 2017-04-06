//
//  CartViewController.swift
//  TVMed
//
//  Created by Vinicius de Moura Albino on 05/04/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation
import UIKit

class CartViewController: UIViewController, CartDelegate {
    
    lazy var viewModel: CartViewModel = CartViewModel(delegate: self)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadContent()
    }
    
    func loadContent() {
        startLoading()
        viewModel.loadCart()
    }
    
    func contentDidFinishedLoading(success: Bool) {
        stopLoading()
        if success {
            
        } else {
            
        }
    }
}
