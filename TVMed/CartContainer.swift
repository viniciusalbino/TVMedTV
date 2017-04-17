//
//  CartContainer.swift
//  TVMed
//
//  Created by Vinicius de Moura Albino on 16/04/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation
import UIKit

class CartContainer: UIViewController, CartDelegate, SelectedCardDelegate  {
    
    lazy var viewModel: CartViewModel = CartViewModel(delegate: self)
    var tableViewController: CartTableViewController?
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var purchaseButton: UIButton!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier ==  "presentCards" {
            if let navController = segue.destination as? UINavigationController, let controller = navController.childViewControllers.first as? CreditCardsTableViewController {
                controller.delegate = self
            }
        } else if segue.identifier == "CartTableViewControllerEmbed" {
            guard let viewController = segue.destination as? CartTableViewController else {
                return
            }
            tableViewController = viewController
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addLogo()
        self.topView.layer.cornerRadius = 4
        self.bottomView.layer.cornerRadius = 4
        self.purchaseButton.layer.cornerRadius = 4 
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
        guard let controller = tableViewController else {
            return
        }
        controller.cartItems = viewModel.cartItems
        controller.tableView.reloadData()
    }
    
    func finishedLoadingShipping() {
        self.totalPrice.text = viewModel.getResume().total
    }
    
    @IBAction func finishPurchasing() {
        let alertDTO = SystemAlertDTO(title: "Aviso", message: "Deseja finalizar a compra?", buttonActions: [(title: "Continuar", style: .default), (title: "Cancelar", style: .cancel)])
        self.showDefaultSystemAlert(systemAlertDTO: alertDTO, completeBlock: { action in
            if action.title == "Continuar" {
                self.startLoading()
                self.viewModel.continueCheckout()
            }
        })
    }
    
    func presentCardsSegue() {
        self.performSegue(withIdentifier: "presentCards", sender: self)
    }
    
    func selectedCard(card: RemoteCreditCard) {
        self.startLoading()
        viewModel.makePurchase(creditCard: card)
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
}
