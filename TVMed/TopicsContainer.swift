//
//  TopicsContainer.swift
//  TVMed
//
//  Created by Vinicius de Moura Albino on 18/04/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation
import UIKit

class TopicsContainer: UIViewController {
    
    var topicsTableViewController: TopicsTableViewController?
    @IBOutlet weak var container:UIView!
    var currentMidia: MidiaPromotion?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addLogo()
        self.container.layer.cornerRadius = 50
    }
    
    func loadContent(midia: MidiaPromotion) {
        self.currentMidia = midia
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "topicsEmbed" {
            guard let viewController = segue.destination as? TopicsTableViewController else {
                return
            }
            topicsTableViewController = viewController
            viewController.loadContent(midia: currentMidia!)
        }
    }
}
