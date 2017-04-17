//
//  CreditCardsTableViewController.swift
//  TVMed
//
//  Created by Vinicius de Moura Albino on 08/04/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation
import UIKit

protocol SelectedCardDelegate: class {
    func selectedCard(card: RemoteCreditCard)
}

class CreditCardsTableViewController: UITableViewController, CreditCardDelegate {
    
    private lazy var viewModel: CreditCardsViewModel = CreditCardsViewModel(delegate: self)
    weak var delegate:SelectedCardDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.mask = nil
        self.title = "Cartões de crédito"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadContent()
    }
    
    func contentDidFinishedLoading() {
        stopLoading()
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItensInSection(section: section)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 120
        } else {
            return 150
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            return tableView.dequeueReusableCell(withIdentifier: String(describing: CardCell.self)) as? CardCell ?? UITableViewCell()
        case 1:
            return tableView.dequeueReusableCell(withIdentifier: "NewCardCell")!
        default:
            return tableView.dequeueReusableCell(withIdentifier: "CancelCell")!
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? CardCell {
            cell.fill(card: viewModel.cardForRow(row: indexPath.row))
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let card = viewModel.cardForRow(row: indexPath.row)
            self.showYesNoAlert(message: "Deseja concluir a compra com o cartão selecionado?", yesButton: "Sim", completeBlock: { action in
                if action.title == "Sim" {
                    self.startLoading()
                    self.viewModel.setPrimaryCard(card: card)
                }
            })
        case 1 :
            self.performSegue(withIdentifier: "newCardSegue", sender: nil)
        default:
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func changedCard(success: Bool, card: RemoteCreditCard?) {
        guard success, let creditCard = card else {
            self.showDefaultSystemAlertWithDefaultLayout(message: "Ocorreu um erro ao selecionar esse cartão. Por favor tente novamente.", completeBlock: nil)
            return
        }
        self.dismiss(animated: true, completion: nil)
        self.delegate?.selectedCard(card: creditCard)
    }
}
