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
    @IBOutlet weak var totalButton: UIButton!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier ==  "presentCards" {
            if let navController = segue.destination as? UINavigationController, let controller = navController.childViewControllers.first as? CreditCardContainer {
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
        self.topView.layer.cornerRadius = 10
        self.bottomView.layer.cornerRadius = 10
        self.purchaseButton.layer.cornerRadius = 5
        self.totalButton.layer.cornerRadius = 5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadContent()
        self.totalButton.setTitle("Loading...", for: .normal)
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
        self.totalButton.isHidden = !(viewModel.cartItems.count > 0)
        self.purchaseButton.isHidden = !(viewModel.cartItems.count > 0)
    }
    
    func finishedLoadingShipping() {
        self.totalPrice.text = viewModel.getResume().total
        
        let total = "A vista = \(viewModel.getResume().total)"
        self.totalButton.setTitle(total, for: .normal)
        
        self.totalButton.isHidden = !(viewModel.cartItems.count > 0)
        self.purchaseButton.isHidden = !(viewModel.cartItems.count > 0)
    }
    
    @IBAction func showPaymentOptions() {
        let alertController = UIAlertController(title: "Opção de pagamento", message: "", preferredStyle: .alert)
        for language in viewModel.totalValue() {
            alertController.addAction(UIAlertAction(title: language, style: .default, handler: {action in
                self.totalButton.setTitle(action.title, for: .normal)
            }))
        }
        let cancel = UIAlertAction(title: "Cancelar", style: .destructive, handler:nil)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
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
        viewModel.makePurchase(creditCard: card, formaPagamento: self.totalButton.titleLabel?.text ?? "A vista \(viewModel.getResume().total)")
    }
    
    func finishedPurchasingProducts(success: Bool) {
        stopLoading()
        if success {
            let dto = SystemAlertDTO(title: "Sucesso", message: "Compra concluída com sucesso!", buttonActions: [(title: "Ok", style: .default)])
            self.showDefaultSystemAlert(systemAlertDTO: dto, completeBlock: { _ in
                self.totalButton.setTitle("", for: .normal)
                self.totalPrice.text = "R$ 0,00"
                self.totalButton.isHidden = !(self.viewModel.cartItems.count > 0)
                self.purchaseButton.isHidden = !(self.viewModel.cartItems.count > 0)
                if let viewController = self.tableViewController {
                    viewController.tableView.reloadData()
                }
            })
        } else {
            self.showDefaultSystemAlertWithDefaultLayout(message: "Ocorreu um erro ao finalizar sua compra. Por favor tente novamente", completeBlock: nil)
        }
    }
}
