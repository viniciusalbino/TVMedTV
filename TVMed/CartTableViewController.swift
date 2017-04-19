//
//  CartViewController.swift
//  TVMed
//
//  Created by Vinicius de Moura Albino on 05/04/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation
import UIKit

protocol CartTableViewDelegate: class {
    func deleteFromCart(cartItem: CartItem)
}

class CartTableViewController: UITableViewController {
    
    var cartItems = [CartItem]()
    var delegate:CartTableViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.mask = nil;
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cartItems.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: String(describing: CartCell.self)) as? CartCell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? CartCell {
            cell.fill(cartItem: cartItems.object(index: indexPath.row) ?? CartItem())
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cartItem = cartItems.object(index: indexPath.row) ?? CartItem()
        let dto = SystemAlertDTO(title: "Excluir", message: "Deseja excluir \(cartItem.linhaTitulo) do seu carrinho?", buttonActions: [(title: "Cancelar", style: .default),(title: "Deletar", style: .destructive)])
        self.showDefaultSystemAlert(systemAlertDTO: dto) { action in
            if action.title == "Deletar" {
                self.delegate?.deleteFromCart(cartItem: cartItem)
            }
        }
    }
}
