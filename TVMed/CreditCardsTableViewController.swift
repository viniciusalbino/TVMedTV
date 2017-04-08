//
//  CreditCardsTableViewController.swift
//  TVMed
//
//  Created by Vinicius de Moura Albino on 08/04/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation
import UIKit

class CreditCardsTableViewController: UITableViewController, CreditCardDelegate {
    
    private lazy var viewModel: CreditCardsViewModel = CreditCardsViewModel(delegate: self)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadContent()
    }
    
    func contentDidFinishedLoading() {
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
            return 200
        } else {
            return 150
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return tableView.dequeueReusableCell(withIdentifier: String(describing: CardCell.self)) as? CardCell ?? UITableViewCell()
        } else {
            return tableView.dequeueReusableCell(withIdentifier: "NewCardCell")!
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? CardCell {
            cell.fill(card: viewModel.cardForRow(row: indexPath.row))
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
        } else {
            //newcard
            self.performSegue(withIdentifier: "newCardSegue", sender: nil)
        }
    }
}
