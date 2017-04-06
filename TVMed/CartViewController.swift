//
//  CartViewController.swift
//  TVMed
//
//  Created by Vinicius de Moura Albino on 05/04/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation
import UIKit

class CartViewController: UITableViewController, CartDelegate {
    
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
            self.tableView.reloadData()
        } else {
            
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItensInSection(section: section)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 200.0
        case 1:
            return 400.0
        default:
            return 100.0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return tableView.dequeueReusableCell(withIdentifier: String(describing: CartCell.self)) as? CartCell ?? UITableViewCell()
        case 1:
            return UITableViewCell()
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if let cell = cell as? CartCell {
                cell.fill(cartItem: viewModel.cartCellForRow(row: indexPath.row))
            }
        default:
            break
        }
    }
}
