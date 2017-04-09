//
//  CartViewController.swift
//  TVMed
//
//  Created by Vinicius de Moura Albino on 05/04/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation
import UIKit

class CartViewController: UITableViewController, CartDelegate, SelectedCardDelegate {
    
    lazy var viewModel: CartViewModel = CartViewModel(delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.backgroundColor = UIColor(h)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadContent()
    }
    
    func loadContent() {
        startLoading()
        DispatchQueue.main.async {
            self.viewModel.loadCart()
        }
    }
    
    func contentDidFinishedLoading(success: Bool) {
        stopLoading()
        self.tableView.reloadData()
    }
    
    func finishedPurchasingProducts(success: Bool) {
        stopLoading()
        if success {
            let dto = SystemAlertDTO(title: "Sucesso", message: "Compra concluída com sucesso!", buttonActions: [(title: "Ok", style: .default)])
            self.showDefaultSystemAlert(systemAlertDTO: dto, completeBlock: { _ in })
        } else {
            self.showDefaultSystemAlertWithDefaultLayout(message: "Ocorreu um erro ao finalizar sua compra. Por favor tente novamente", completeBlock: nil)
        }
        print("completed purchase")
    }
    
    func finishedLoadingShipping() {
        self.tableView.reloadSections(IndexSet(integer: 2), with: .automatic)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItensInSection(section: section)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 200.0
        case 2:
            return 350.0
        default:
            return 100.0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Mídias"
        case 1:
            return "Limpar Carrinho"
        case 2:
            return "Resumo"
        default:
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return tableView.dequeueReusableCell(withIdentifier: String(describing: CartCell.self)) as? CartCell ?? UITableViewCell()
        case 1:
            return tableView.dequeueReusableCell(withIdentifier: "CleanCart")!
        case 2:
            return tableView.dequeueReusableCell(withIdentifier: String(describing: ResumeCell.self)) as? ResumeCell ?? UITableViewCell()
        default:
            return tableView.dequeueReusableCell(withIdentifier: "BuyCell")!
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if let cell = cell as? CartCell {
                cell.fill(cartItem: viewModel.cartCellForRow(row: indexPath.row))
            }
        case 2:
            if let cell = cell as? ResumeCell {
                cell.fill(dto: viewModel.getResume())
            }
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            let alertDTO = SystemAlertDTO(title: "Aviso", message: "Deseja limpar todos os itens do carrinho?", buttonActions: [(title: "Limpar", style: .default), (title: "Cancelar", style: .cancel)])
            self.showDefaultSystemAlert(systemAlertDTO: alertDTO, completeBlock: { action in
                if action.title == "Limpar" {
                    self.startLoading()
                    self.viewModel.cleanCart()
                }
            })
        case 3:
            let alertDTO = SystemAlertDTO(title: "Aviso", message: "Deseja finalizar a compra?", buttonActions: [(title: "Continuar", style: .default), (title: "Cancelar", style: .cancel)])
            self.showDefaultSystemAlert(systemAlertDTO: alertDTO, completeBlock: { action in
                if action.title == "Continuar" {
                    self.startLoading()
                    self.viewModel.continueCheckout()
                }
            })
        default:
            self.tableView.deselectRow(at: indexPath, animated: true)
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier ==  "presentCards" {
            if let navController = segue.destination as? UINavigationController, let controller = navController.childViewControllers.first as? CreditCardsTableViewController {
                controller.delegate = self
            }
        }
    }
    
    func presentCardsSegue() {
        self.performSegue(withIdentifier: "presentCards", sender: self)
    }
    
    func selectedCard(card: CreditCard) {
        self.startLoading()
        viewModel.makePurchase(creditCard: card)
    }
}
