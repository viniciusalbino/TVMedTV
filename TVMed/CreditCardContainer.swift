//
//  CreditCardContainer.swift
//  TVMed
//
//  Created by Vinicius de Moura Albino on 17/04/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation
import UIKit

class CreditCardContainer: UIViewController, SelectedCardDelegate {
    
    var tableViewController: CreditCardsTableViewController?
    weak var delegate:SelectedCardDelegate?
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addLogo()
        self.topView.layer.cornerRadius = 10
        self.bottomView.layer.cornerRadius = 10
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cardsEmbed" {
            guard let viewController = segue.destination as? CreditCardsTableViewController else {
                return
            }
            tableViewController = viewController
            viewController.delegate = self
        }
    }
    
    @IBAction func newCard() {
        self.performSegue(withIdentifier: "newCardSegue", sender: nil)
    }
    
    @IBAction func cancelar() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func selectedCard(card: RemoteCreditCard) {
        self.delegate?.selectedCard(card: card)
    }
}
